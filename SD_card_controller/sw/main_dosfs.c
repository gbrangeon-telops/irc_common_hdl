/*
	Test program for DOSFS
	Lewin A.R.W. Edwards (sysadm@zws.com)
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#include "xcache_l.h"
#include "common.h"
#include "sd_routines.h"
#include "spi_routines.h"


#include "dosfs.h"

// Function to print the contents of a buffer
PrintBuffer(uint8_t *buffer, uint32_t len)
	{
   	uint32_t Count; 	
 	   for(Count = 0; Count < len; Count++)
 	   { xil_printf("%c", buffer[Count]);}					
      xil_printf("\r\n");	
   }
   
   
int main(void)
{
	
	//Enable the PPC cache.	
	XCache_EnableICache(0x00000001);
   	XCache_EnableDCache(0x00000001);
   	
   	u32 Count;
   	
   	//clears the screen
   	ClearScreen();	
    	
	
	/* Init SPI device & driver */
	INFOMSGLN("Initializing SPI device...");   			
	if(spi_init())
	{
		INFOMSG("failed!");
		return 1;
	}else{
		INFOMSG("OK.");
	}
	
	/* Initialize the SD card */
	INFOMSGLN("Initializing SD card...");		
	if(SD_init()){
		INFOMSG("failed!");
		return 1;
	}else{
		INFOMSG("OK.");
	}
	
	maintest(2,3);
}

int maintest(void)
{
	uint8_t sector[SECTOR_SIZE], sector2[SECTOR_SIZE];
	uint32_t pstart, psize, Count, i, j;
	uint8_t pactive, ptype;
	VOLINFO vi;
	DIRINFO di;
	DIRENT de;
	uint32_t cache;
	FILEINFO fi;
	uint8_t *p;

	// Obtain pointer to first partition on first (only) unit
	pstart = DFS_GetPtnStart(0, sector, 0, &pactive, &ptype, &psize);
	if (pstart == 0xffffffff) {
		xil_printf("Cannot find first partition\r\n");
		return -1;
	}

	xil_printf("Partition 0 start sector %d active %d type %d size %d\r\n", pstart, pactive, ptype, psize);

	if (DFS_GetVolInfo(0, sector, pstart, &vi)) {
		xil_printf("Error getting volume information\r\n");
		return -1;
	}
	xil_printf("Volume label '%-11.11s'\r\n", vi.label);
	xil_printf("%d sector/s per cluster, %d reserved sector/s, volume total %d sectors.\r\n", vi.secperclus, vi.reservedsecs, vi.numsecs);
	xil_printf("%d sectors per FAT, first FAT at sector #%d, root dir at #%d.\r\n",vi.secperfat,vi.fat1,vi.rootdir);
	xil_printf("(For FAT32, the root dir is a CLUSTER number, FAT12/16 it is a SECTOR number)\r\n");
	xil_printf("%d root dir entries, data area commences at sector #%d.\r\n",vi.rootentries,vi.dataarea);
	xil_printf("%d clusters (%d bytes) in data area, filesystem IDd as ", vi.numclusters, vi.numclusters * vi.secperclus * SECTOR_SIZE);
	if (vi.filesystem == FAT12)
		xil_printf("FAT12.\r\n");
	else if (vi.filesystem == FAT16)
		xil_printf("FAT16.\r\n");
	else if (vi.filesystem == FAT32)
		xil_printf("FAT32.\r\n");
	else
		xil_printf("[unknown]\r\n");
   xil_printf("done!\r\n");
   
   //------------------------------------------------------------
   // File read test
	//printf("Readback test\n");	
	
	xil_printf("Reading file: REP2/text1.txt\r\n");
	if (DFS_OpenFile(&vi, "README.TXT", DFS_READ, sector, &fi)) {
   //if (DFS_OpenFile(&vi, "REP2/text1.txt", DFS_READ, sector, &fi)) {
		xil_printf("error opening file\r\n");
		return -1;
	}
	
	DFS_ReadFile(&fi, sector, sector2, &i, fi.filelen);
	xil_printf("read complete %d bytes (expected %d) pointer %d\r\n", i, fi.filelen, fi.pointer);
	
	//Print out the read buffer containts
	PrintBuffer(sector, i);
	xil_printf("\r\n");
	
	xil_printf("Reading file: REP2/text2.txt\r\n");
	if (DFS_OpenFile(&vi, "REP2/text2.txt", DFS_READ, sector, &fi)) {
		xil_printf("error opening file\n");
		return -1;
	}
	
	DFS_ReadFile(&fi, sector, sector2, &i, fi.filelen);
	xil_printf("read complete %d bytes (expected %d) pointer %d\r\n", i, fi.filelen, fi.pointer);
	
	PrintBuffer(sector, i);
	xil_printf("\r\n");
	
	xil_printf("Reading file: text1.txt at root dir\r\n");
	if (DFS_OpenFile(&vi, "text1.txt", DFS_READ, sector, &fi)) {
		xil_printf("error opening file\n");
		return -1;
	}
	
	DFS_ReadFile(&fi, sector, sector2, &i, fi.filelen);
	xil_printf("read complete %d bytes (expected %d) pointer %d\r\n", i, fi.filelen, fi.pointer);
  	
   PrintBuffer(sector, i);
	xil_printf("\r\n");
	
 	xil_printf("done!");
	return 0;
}
