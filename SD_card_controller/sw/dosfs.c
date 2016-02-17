/*******************************************************************************************************************
      Telops Inc.
      Modified by KBE
      Descreption: This is a light version of the DosFs. Only a min of fuctions that nedded were implemented here.
                     Only read version is implemented beacuse we dont need the PPC to write the SD at this time and
                     so to save code memory space.
********************************************************************************************************************/
/*
	DOSFS Embedded FAT-Compatible Filesystem
	(C) 2005 Lewin A.R.W. Edwards (sysadm@zws.com)

	You are permitted to modify and/or use this code in your own projects without
	payment of royalty, regardless of the license(s) you choose for those projects.

	You cannot re-copyright or restrict use of the code as released by Lewin Edwards.
********************************************************************************************************************/

#include <string.h>
#include <stdlib.h>

#include "dosfs.h"
#include "sd_routines.h"
#include "utils.h"

/*

    User defined functions

*/


uint32_t DFS_ReadSector(uint8_t unit, uint8_t *buffer, uint32_t sector, uint32_t count)
{
	//param unit  is not used beacuse we will always have only one unit in the system
	//param count is not used because it's allways 1 in this version of DosFs Otherwise
	//juste use the SD_readMultipleBlock function like this:
	//SD_readMultipleBlock(buffer, sector, count);	
	return SD_readSingleBlock(buffer, sector);		
}

/*
	Get starting sector# of specified partition on drive #unit
	NOTE: This code ASSUMES an MBR on the disk.
	scratchsector should point to a SECTOR_SIZE scratch area
	Returns 0xffffffff for any error.
	If pactive is non-NULL, this function also returns the partition active flag.
	If pptype is non-NULL, this function also returns the partition type.
	If psize is non-NULL, this function also returns the partition size.
*/
uint32_t DFS_GetPtnStart(uint8_t unit, uint8_t *scratchsector, uint8_t pnum, uint8_t *pactive, uint8_t *pptype, uint32_t *psize)
{
	uint32_t result;
	PMBR mbr = (PMBR) scratchsector;

	// DOS ptable supports maximum 4 partitions
	if (pnum > 3)
		return DFS_ERRMISC;

	// Read MBR from target media
	if (DFS_ReadSector(unit,scratchsector,0,1)) {
		return DFS_ERRMISC;
	}

	result = (uint32_t) mbr->ptable[pnum].start_0 |
	  (((uint32_t) mbr->ptable[pnum].start_1) << 8) |
	  (((uint32_t) mbr->ptable[pnum].start_2) << 16) |
	  (((uint32_t) mbr->ptable[pnum].start_3) << 24);

	if (pactive)
		*pactive = mbr->ptable[pnum].active;

	if (pptype)
		*pptype = mbr->ptable[pnum].type;

	if (psize)
		*psize = (uint32_t) mbr->ptable[pnum].size_0 |
		  (((uint32_t) mbr->ptable[pnum].size_1) << 8) |
		  (((uint32_t) mbr->ptable[pnum].size_2) << 16) |
		  (((uint32_t) mbr->ptable[pnum].size_3) << 24);

	return result;
}


/*
	Retrieve volume info from BPB and store it in a VOLINFO structure
	You must provide the unit and starting sector of the filesystem, and
	a pointer to a sector buffer for scratch
	Attempts to read BPB and glean information about the FS from that.
	Returns 0 OK, nonzero for any error.
*/
uint32_t DFS_GetVolInfo(uint8_t unit, uint8_t *scratchsector, uint32_t startsector, PVOLINFO volinfo)
{
	PLBR lbr = (PLBR) scratchsector;
	volinfo->unit = unit;
	volinfo->startsector = startsector;

	if(DFS_ReadSector(unit,scratchsector,startsector,1))
		return DFS_ERRMISC;

// tag: OEMID, refer dosfs.h
//	strncpy(volinfo->oemid, lbr->oemid, 8);
//	volinfo->oemid[8] = 0;

	volinfo->secperclus = lbr->bpb.secperclus;
	volinfo->reservedsecs = (uint16_t) lbr->bpb.reserved_l |
		  (((uint16_t) lbr->bpb.reserved_h) << 8);

	volinfo->numsecs =  (uint16_t) lbr->bpb.sectors_s_l |
		  (((uint16_t) lbr->bpb.sectors_s_h) << 8);

	if (!volinfo->numsecs)
		volinfo->numsecs = (uint32_t) lbr->bpb.sectors_l_0 |
		  (((uint32_t) lbr->bpb.sectors_l_1) << 8) |
		  (((uint32_t) lbr->bpb.sectors_l_2) << 16) |
		  (((uint32_t) lbr->bpb.sectors_l_3) << 24);

	// If secperfat is 0, we must be in a FAT32 volume; get secperfat
	// from the FAT32 EBPB. The volume label and system ID string are also
	// in different locations for FAT12/16 vs FAT32.
	volinfo->secperfat =  (uint16_t) lbr->bpb.secperfat_l |
		  (((uint16_t) lbr->bpb.secperfat_h) << 8);
	if (!volinfo->secperfat) {
		volinfo->secperfat = (uint32_t) lbr->ebpb.ebpb32.fatsize_0 |
		  (((uint32_t) lbr->ebpb.ebpb32.fatsize_1) << 8) |
		  (((uint32_t) lbr->ebpb.ebpb32.fatsize_2) << 16) |
		  (((uint32_t) lbr->ebpb.ebpb32.fatsize_3) << 24);

		memcpy(volinfo->label, lbr->ebpb.ebpb32.label, 11);
		volinfo->label[11] = 0;
	
// tag: OEMID, refer dosfs.h
//		memcpy(volinfo->system, lbr->ebpb.ebpb32.system, 8);
//		volinfo->system[8] = 0; 
	}
	else {
		memcpy(volinfo->label, lbr->ebpb.ebpb.label, 11);
		volinfo->label[11] = 0;
	
// tag: OEMID, refer dosfs.h
//		memcpy(volinfo->system, lbr->ebpb.ebpb.system, 8);
//		volinfo->system[8] = 0; 
	}

	// note: if rootentries is 0, we must be in a FAT32 volume.
	volinfo->rootentries =  (uint16_t) lbr->bpb.rootentries_l |
		  (((uint16_t) lbr->bpb.rootentries_h) << 8);

	// after extracting raw info we perform some useful precalculations
	volinfo->fat1 = startsector + volinfo->reservedsecs;

	// The calculation below is designed to round up the root directory size for FAT12/16
	// and to simply ignore the root directory for FAT32, since it's a normal, expandable
	// file in that situation.
	if (volinfo->rootentries) {
		volinfo->rootdir = volinfo->fat1 + (volinfo->secperfat * 2);
		volinfo->dataarea = volinfo->rootdir + (((volinfo->rootentries * 32) + (SECTOR_SIZE - 1)) / SECTOR_SIZE);
	}
	else {
		volinfo->dataarea = volinfo->fat1 + (volinfo->secperfat * 2);
		volinfo->rootdir = (uint32_t) lbr->ebpb.ebpb32.root_0 |
		  (((uint32_t) lbr->ebpb.ebpb32.root_1) << 8) |
		  (((uint32_t) lbr->ebpb.ebpb32.root_2) << 16) |
		  (((uint32_t) lbr->ebpb.ebpb32.root_3) << 24);
	}

	// Calculate number of clusters in data area and infer FAT type from this information.
	volinfo->numclusters = (volinfo->numsecs - volinfo->dataarea) / volinfo->secperclus;
	if (volinfo->numclusters < 4085)
		volinfo->filesystem = FAT12;
	else if (volinfo->numclusters < 65525)
		volinfo->filesystem = FAT16;
	else
		volinfo->filesystem = FAT32;

	return DFS_OK;
}

/*
	Fetch FAT entry for specified cluster number
	You must provide a scratch buffer for one sector (SECTOR_SIZE) and a populated VOLINFO
	Returns a FAT32 BAD_CLUSTER value for any error, otherwise the contents of the desired
	FAT entry.
	scratchcache should point to a UINT32. This variable caches the physical sector number
	last read into the scratch buffer for performance enhancement reasons.
*/
uint32_t DFS_GetFAT(PVOLINFO volinfo, uint8_t *scratch, uint32_t *scratchcache, uint32_t cluster)
{
	uint32_t offset, sector, result;

	if (volinfo->filesystem == FAT12) {
		offset = cluster + (cluster / 2);
	}
	else if (volinfo->filesystem == FAT16) {
		offset = cluster * 2;
	}
	else if (volinfo->filesystem == FAT32) {
		offset = cluster * 4;
	}
	else
		return 0x0ffffff7;	// FAT32 bad cluster	

	// at this point, offset is the BYTE offset of the desired sector from the start
	// of the FAT. Calculate the physical sector containing this FAT entry.
	sector = ldiv(offset, SECTOR_SIZE).quot + volinfo->fat1;

	// If this is not the same sector we last read, then read it into RAM
	if (sector != *scratchcache) {
		if(DFS_ReadSector(volinfo->unit, scratch, sector, 1)) {
			// avoid anyone assuming that this cache value is still valid, which
			// might cause disk corruption
			*scratchcache = 0;
			return 0x0ffffff7;	// FAT32 bad cluster	
		}
		*scratchcache = sector;
	}

	// At this point, we "merely" need to extract the relevant entry.
	// This is easy for FAT16 and FAT32, but a royal PITA for FAT12 as a single entry
	// may span a sector boundary. The normal way around this is always to read two
	// FAT sectors, but that luxury is (by design intent) unavailable to DOSFS.
	offset = ldiv(offset, SECTOR_SIZE).rem;

	if (volinfo->filesystem == FAT12) {
		// Special case for sector boundary - Store last byte of current sector.
		// Then read in the next sector and put the first byte of that sector into
		// the high byte of result.
		if (offset == SECTOR_SIZE - 1) {
			result = (uint32_t) scratch[offset];
			sector++;
			if(DFS_ReadSector(volinfo->unit, scratch, sector, 1)) {
				// avoid anyone assuming that this cache value is still valid, which
				// might cause disk corruption
				*scratchcache = 0;
				return 0x0ffffff7;	// FAT32 bad cluster	
			}
			*scratchcache = sector;
			// Thanks to Claudio Leonel for pointing out this missing line.
			result |= ((uint32_t) scratch[0]) << 8;
		}
		else {
			result = (uint32_t) scratch[offset] |
			  ((uint32_t) scratch[offset+1]) << 8;
		}
		if (cluster & 1)
			result = result >> 4;
		else
			result = result & 0xfff;
	}
	else if (volinfo->filesystem == FAT16) {
		result = (uint32_t) scratch[offset] |
		  ((uint32_t) scratch[offset+1]) << 8;
	}
	else if (volinfo->filesystem == FAT32) {
		result = ((uint32_t) scratch[offset] |
		  ((uint32_t) scratch[offset+1]) << 8 |
		  ((uint32_t) scratch[offset+2]) << 16 |
		  ((uint32_t) scratch[offset+3]) << 24) & 0x0fffffff;
	}
	else
		result = 0x0ffffff7;	// FAT32 bad cluster	
	return result;
}


/*
	Convert a filename element from canonical (8.3) to directory entry (11) form
	src must point to the first non-separator character.
	dest must point to a 12-byte buffer.
*/
uint8_t *DFS_CanonicalToDir(uint8_t *dest, uint8_t *src)
{
	uint8_t *destptr = dest;

	memset(dest, ' ', 11);
	dest[11] = 0;

	while (*src && (*src != DIR_SEPARATOR) && (destptr - dest < 11)) {
		if (*src >= 'a' && *src <='z') {
			*destptr++ = (*src - 'a') + 'A';
			src++;
		}
		else if (*src == '.') {
			src++;
			destptr = dest + 8;
		}
		else {
			*destptr++ = *src++;
		}
	}

	return dest;
}

/*
	Find the first unused FAT entry
	You must provide a scratch buffer for one sector (SECTOR_SIZE) and a populated VOLINFO
	Returns a FAT32 BAD_CLUSTER value for any error, otherwise the contents of the desired
	FAT entry.
	Returns FAT32 bad_sector (0x0ffffff7) if there is no free cluster available
*/
uint32_t DFS_GetFreeFAT(PVOLINFO volinfo, uint8_t *scratch)
{
	uint32_t i, result = 0xffffffff, scratchcache = 0;
	
	// Search starts at cluster 2, which is the first usable cluster
	// NOTE: This search can't terminate at a bad cluster, because there might
	// legitimately be bad clusters on the disk.
	for (i=2; i < volinfo->numclusters; i++) {
		result = DFS_GetFAT(volinfo, scratch, &scratchcache, i);
		if (!result) {
			return i;
		}
	}
	return 0x0ffffff7;		// Can't find a free cluster
}


/*
	Open a file for reading or writing. You supply populated VOLINFO, a path to the file,
	mode (DFS_READ or DFS_WRITE) and an empty fileinfo structure. You also need to
	provide a pointer to a sector-sized scratch buffer.
	Returns various DFS_* error states. If the result is DFS_OK, fileinfo can be used
	to access the file from this point on.
*/
uint32_t DFS_OpenFile(PVOLINFO volinfo, uint8_t *path, uint8_t mode, uint8_t *scratch, PFILEINFO fileinfo)
{
	uint8_t tmppath[MAX_PATH];
	uint8_t filename[12];
	uint8_t *p;
	DIRINFO di;
	DIRENT de;

	// larwe 2006-09-16 +1 zero out file structure
	memset(fileinfo, 0, sizeof(FILEINFO));

	// save access mode
	fileinfo->mode = mode;

	// Get a local copy of the path. If it's longer than MAX_PATH, abort.
	strncpy((char *) tmppath, (char *) path, MAX_PATH);
	tmppath[MAX_PATH - 1] = 0;
	if (strcmp((char *) path,(char *) tmppath)) {
		return DFS_PATHLEN;
	}

	// strip leading path separators
	while (tmppath[0] == DIR_SEPARATOR)
		strcpy((char *) tmppath, (char *) tmppath + 1);

	// Parse filename off the end of the supplied path
	p = tmppath;
	while (*(p++));

	p--;
	while (p > tmppath && *p != DIR_SEPARATOR) // larwe 9/16/06 ">=" to ">" bugfix
		p--;
	if (*p == DIR_SEPARATOR)
		p++;

	DFS_CanonicalToDir(filename, p);

	if (p > tmppath)
		p--;
	if (*p == DIR_SEPARATOR || p == tmppath) // larwe 9/16/06 +"|| p == tmppath" bugfix
		*p = 0;

	// At this point, if our path was MYDIR/MYDIR2/FILE.EXT, filename = "FILE    EXT" and
	// tmppath = "MYDIR/MYDIR2".
	di.scratch = scratch;
	if (DFS_OpenDir(volinfo, tmppath, &di))
		return DFS_NOTFOUND;

	while (!DFS_GetNext(volinfo, &di, &de)) {
		if (!memcmp(de.name, filename, 11)) {
			// You can't use this function call to open a directory.
			if (de.attr & ATTR_DIRECTORY)
				return DFS_NOTFOUND;

			fileinfo->volinfo = volinfo;
			fileinfo->pointer = 0;
			// The reason we store this extra info about the file is so that we can
			// speedily update the file size, modification date, etc. on a file that is
			// opened for writing.
			if (di.currentcluster == 0)
				fileinfo->dirsector = volinfo->rootdir + di.currentsector;
			else
				fileinfo->dirsector = volinfo->dataarea + ((di.currentcluster - 2) * volinfo->secperclus) + di.currentsector;
			fileinfo->diroffset = di.currententry - 1;
			if (volinfo->filesystem == FAT32) {
				fileinfo->cluster = (uint32_t) de.startclus_l_l |
				  ((uint32_t) de.startclus_l_h) << 8 |
				  ((uint32_t) de.startclus_h_l) << 16 |
				  ((uint32_t) de.startclus_h_h) << 24;
			}
			else {
				fileinfo->cluster = (uint32_t) de.startclus_l_l |
				  ((uint32_t) de.startclus_l_h) << 8;
			}
			fileinfo->firstcluster = fileinfo->cluster;
			fileinfo->filelen = (uint32_t) de.filesize_0 |
			  ((uint32_t) de.filesize_1) << 8 |
			  ((uint32_t) de.filesize_2) << 16 |
			  ((uint32_t) de.filesize_3) << 24;

			return DFS_OK;
		}
	}

#ifdef DOSFS_USE_WRITE
	// At this point, we KNOW the file does not exist. If the file was opened
	// with write access, we can create it.
	if (mode & DFS_WRITE) {
		uint32_t cluster, temp;

		// Locate or create a directory entry for this file
		if (DFS_OK != DFS_GetFreeDirEnt(volinfo, tmppath, &di, &de))
			return DFS_ERRMISC;

		// put sane values in the directory entry
		memset(&de, 0, sizeof(de));
		memcpy(de.name, filename, 11);
		de.crttime_l = 0x20;	// 01:01:00am, Jan 1, 2006.
		de.crttime_h = 0x08;
		de.crtdate_l = 0x11;
		de.crtdate_h = 0x34;
		de.lstaccdate_l = 0x11;
		de.lstaccdate_h = 0x34;
		de.wrttime_l = 0x20;
		de.wrttime_h = 0x08;
		de.wrtdate_l = 0x11;
		de.wrtdate_h = 0x34;

		// allocate a starting cluster for the directory entry
		cluster = DFS_GetFreeFAT(volinfo, scratch);

		de.startclus_l_l = cluster & 0xff;
		de.startclus_l_h = (cluster & 0xff00) >> 8;
		de.startclus_h_l = (cluster & 0xff0000) >> 16;
		de.startclus_h_h = (cluster & 0xff000000) >> 24;

		// update FILEINFO for our caller's sake
		fileinfo->volinfo = volinfo;
		fileinfo->pointer = 0;
		// The reason we store this extra info about the file is so that we can
		// speedily update the file size, modification date, etc. on a file that is
		// opened for writing.
		if (di.currentcluster == 0)
			fileinfo->dirsector = volinfo->rootdir + di.currentsector;
		else
			fileinfo->dirsector = volinfo->dataarea + ((di.currentcluster - 2) * volinfo->secperclus) + di.currentsector;
		fileinfo->diroffset = di.currententry - 1;
		fileinfo->cluster = cluster;
		fileinfo->firstcluster = cluster;
		fileinfo->filelen = 0;
		
		// write the directory entry
		// note that we no longer have the sector containing the directory entry,
		// tragically, so we have to re-read it
		if (DFS_ReadSector(volinfo->unit, scratch, fileinfo->dirsector, 1))
			return DFS_ERRMISC;
		memcpy(&(((PDIRENT) scratch)[di.currententry-1]), &de, sizeof(DIRENT));
		if (DFS_WriteSector(volinfo->unit, scratch, fileinfo->dirsector, 1))
			return DFS_ERRMISC;

		// Mark newly allocated cluster as end of chain			
		switch(volinfo->filesystem) {
#ifdef DOSFS_USE_FAT12
			case FAT12:		cluster = 0xff8;	break;
#endif
			case FAT16:		cluster = 0xfff8;	break;
			case FAT32:		cluster = 0x0ffffff8;	break;
			default:		return DFS_ERRMISC;
		}
		temp = 0;
		DFS_SetFAT(volinfo, scratch, &temp, fileinfo->cluster, cluster);

		return DFS_OK;
	}
#endif

	return DFS_NOTFOUND;
}

/*
	Open a directory for enumeration by DFS_GetNextDirEnt
	You must supply a populated VOLINFO (see DFS_GetVolInfo)
	The empty string or a string containing only the directory separator are
	considered to be the root directory.
	Returns 0 OK, nonzero for any error.
*/
uint32_t DFS_OpenDir(PVOLINFO volinfo, uint8_t *dirname, PDIRINFO dirinfo)
{
	// Default behavior is a regular search for existing entries
	dirinfo->flags = 0;

	if (!strlen((char *) dirname) || (strlen((char *) dirname) == 1 && dirname[0] == DIR_SEPARATOR)) {
		if (volinfo->filesystem == FAT32) {
			dirinfo->currentcluster = volinfo->rootdir;
			dirinfo->currentsector = 0;
			dirinfo->currententry = 0;

			// read first sector of directory
			return DFS_ReadSector(volinfo->unit, dirinfo->scratch, volinfo->dataarea + ((volinfo->rootdir - 2) * volinfo->secperclus), 1);
		}
		else {
			dirinfo->currentcluster = 0;
			dirinfo->currentsector = 0;
			dirinfo->currententry = 0;

			// read first sector of directory
			return DFS_ReadSector(volinfo->unit, dirinfo->scratch, volinfo->rootdir, 1);
		}
	}

	// This is not the root directory. We need to find the start of this subdirectory.
	// We do this by devious means, using our own companion function DFS_GetNext.
	else {
		uint8_t tmpfn[12];
		uint8_t *ptr = dirname;
		uint32_t result;
		DIRENT de;

		if (volinfo->filesystem == FAT32) {
			dirinfo->currentcluster = volinfo->rootdir;
			dirinfo->currentsector = 0;
			dirinfo->currententry = 0;

			// read first sector of directory
			if (DFS_ReadSector(volinfo->unit, dirinfo->scratch, volinfo->dataarea + ((volinfo->rootdir - 2) * volinfo->secperclus), 1))
				return DFS_ERRMISC;
		}
		else {
			dirinfo->currentcluster = 0;
			dirinfo->currentsector = 0;
			dirinfo->currententry = 0;

			// read first sector of directory
			if (DFS_ReadSector(volinfo->unit, dirinfo->scratch, volinfo->rootdir, 1))
				return DFS_ERRMISC;
		}

		// skip leading path separators
		while (*ptr == DIR_SEPARATOR && *ptr)
			ptr++;

		// Scan the path from left to right, finding the start cluster of each entry
		// Observe that this code is inelegant, but obviates the need for recursion.
		while (*ptr) {
			DFS_CanonicalToDir(tmpfn, ptr);

			de.name[0] = 0;

			do {
				result = DFS_GetNext(volinfo, dirinfo, &de);
			} while (!result && memcmp(de.name, tmpfn, 11));

			if (!memcmp(de.name, tmpfn, 11) && ((de.attr & ATTR_DIRECTORY) == ATTR_DIRECTORY)) {
				if (volinfo->filesystem == FAT32) {
					dirinfo->currentcluster = (uint32_t) de.startclus_l_l |
					  ((uint32_t) de.startclus_l_h) << 8 |
					  ((uint32_t) de.startclus_h_l) << 16 |
					  ((uint32_t) de.startclus_h_h) << 24;
				}
				else {
					dirinfo->currentcluster = (uint32_t) de.startclus_l_l |
					  ((uint32_t) de.startclus_l_h) << 8;
				}
				dirinfo->currentsector = 0;
				dirinfo->currententry = 0;

				if (DFS_ReadSector(volinfo->unit, dirinfo->scratch, volinfo->dataarea + ((dirinfo->currentcluster - 2) * volinfo->secperclus), 1))
					return DFS_ERRMISC;
			}
			else if (!memcmp(de.name, tmpfn, 11) && !(de.attr & ATTR_DIRECTORY))
				return DFS_NOTFOUND;

			// seek to next item in list
			while (*ptr != DIR_SEPARATOR && *ptr)
				ptr++;
			if (*ptr == DIR_SEPARATOR)
				ptr++;
		}

		if (!dirinfo->currentcluster)
			return DFS_NOTFOUND;
	}
	return DFS_OK;
}

/*
	Get next entry in opened directory structure. Copies fields into the dirent
	structure, updates dirinfo. Note that it is the _caller's_ responsibility to
	handle the '.' and '..' entries.
	A deleted file will be returned as a NULL entry (first char of filename=0)
	by this code. Filenames beginning with 0x05 will be translated to 0xE5
	automatically. Long file name entries will be returned as NULL.
	returns DFS_EOF if there are no more entries, DFS_OK if this entry is valid,
	or DFS_ERRMISC for a media error
*/
uint32_t DFS_GetNext(PVOLINFO volinfo, PDIRINFO dirinfo, PDIRENT dirent)
{
	uint32_t tempint;	// required by DFS_GetFAT

	// Do we need to read the next sector of the directory?
	if (dirinfo->currententry >= SECTOR_SIZE / sizeof(DIRENT)) {
		dirinfo->currententry = 0;
		dirinfo->currentsector++;

		// Root directory; special case handling 
		// Note that currentcluster will only ever be zero if both:
		// (a) this is the root directory, and
		// (b) we are on a FAT12/16 volume, where the root dir can't be expanded
		if (dirinfo->currentcluster == 0) {
			// Trying to read past end of root directory?
			if (dirinfo->currentsector * (SECTOR_SIZE / sizeof(DIRENT)) >= volinfo->rootentries)
				return DFS_EOF;

			// Otherwise try to read the next sector
			if (DFS_ReadSector(volinfo->unit, dirinfo->scratch, volinfo->rootdir + dirinfo->currentsector, 1))
				return DFS_ERRMISC;
		}

		// Normal handling
		else {
			if (dirinfo->currentsector >= volinfo->secperclus) {
				dirinfo->currentsector = 0;
				if (
#ifdef DOSFS_USE_FAT12
                                  (dirinfo->currentcluster >= 0xff7 &&  volinfo->filesystem == FAT12) ||
#endif
				  (dirinfo->currentcluster >= 0xfff7 &&  volinfo->filesystem == FAT16) ||
				  (dirinfo->currentcluster >= 0x0ffffff7 &&  volinfo->filesystem == FAT32)) {
				  
				  	// We are at the end of the directory chain. If this is a normal
				  	// find operation, we should indicate that there is nothing more
				  	// to see.
				  	if (!(dirinfo->flags & DFS_DI_BLANKENT))
						return DFS_EOF;
					
					// On the other hand, if this is a "find free entry" search,
					// we need to tell the caller to allocate a new cluster
					else
						return DFS_ALLOCNEW;
				}
				dirinfo->currentcluster = DFS_GetFAT(volinfo, dirinfo->scratch, &tempint, dirinfo->currentcluster);
			}
			if (DFS_ReadSector(volinfo->unit, dirinfo->scratch, volinfo->dataarea + ((dirinfo->currentcluster - 2) * volinfo->secperclus) + dirinfo->currentsector, 1))
				return DFS_ERRMISC;
		}
	}

	memcpy(dirent, &(((PDIRENT) dirinfo->scratch)[dirinfo->currententry]), sizeof(DIRENT));

	if (dirent->name[0] == 0) {		// no more files in this directory
		// If this is a "find blank" then we can reuse this name.
		if (dirinfo->flags & DFS_DI_BLANKENT)
			return DFS_OK;
		else
			return DFS_EOF;
	}

	if (dirent->name[0] == 0xe5)	// handle deleted file entries
		dirent->name[0] = 0;
	else if ((dirent->attr & ATTR_LONG_NAME) == ATTR_LONG_NAME)
		dirent->name[0] = 0;
	else if (dirent->name[0] == 0x05)	// handle kanji filenames beginning with 0xE5
		dirent->name[0] = 0xe5;

	dirinfo->currententry++;

	return DFS_OK;
}

/*
	Read an open file
	You must supply a prepopulated FILEINFO as provided by DFS_OpenFile, and a
	pointer to a SECTOR_SIZE scratch buffer.
	Note that returning DFS_EOF is not an error condition. This function updates the
	successcount field with the number of bytes actually read.
*/
uint32_t DFS_ReadFile(PFILEINFO fileinfo, uint8_t *scratch, uint8_t *buffer, uint32_t *successcount, uint32_t len)
{
	uint32_t remain, Count;
	uint32_t result = DFS_OK;
	uint32_t sector;
	uint32_t bytesread;

	// Don't try to read past EOF
	if (len > fileinfo->filelen - fileinfo->pointer)
		len = fileinfo->filelen - fileinfo->pointer;

	remain = len;
	*successcount = 0;

	while (remain && result == DFS_OK) {
		// This is a bit complicated. The sector we want to read is addressed at a cluster
		// granularity by the fileinfo->cluster member. The file pointer tells us how many
		// extra sectors to add to that number.
		sector = fileinfo->volinfo->dataarea +
		  ((fileinfo->cluster - 2) * fileinfo->volinfo->secperclus) +
		  div(div(fileinfo->pointer,fileinfo->volinfo->secperclus * SECTOR_SIZE).rem, SECTOR_SIZE).quot;

		// Case 1 - File pointer is not on a sector boundary
		if (div(fileinfo->pointer, SECTOR_SIZE).rem) {
			uint16_t tempreadsize;

			// We always have to go through scratch in this case
			result = DFS_ReadSector(fileinfo->volinfo->unit, scratch, sector, 1);

			// This is the number of bytes that we actually care about in the sector
			// just read.
			tempreadsize = SECTOR_SIZE - (div(fileinfo->pointer, SECTOR_SIZE).rem);
					
			// Case 1A - We want the entire remainder of the sector. After this
			// point, all passes through the read loop will be aligned on a sector
			// boundary, which allows us to go through the optimal path 2A below.
		   	if (remain >= tempreadsize) {
				memcpy(buffer, scratch + (SECTOR_SIZE - tempreadsize), tempreadsize);
				bytesread = tempreadsize;
				buffer += tempreadsize;
				fileinfo->pointer += tempreadsize;
				remain -= tempreadsize;
			}
			// Case 1B - This read concludes the file read operation
			else {
				memcpy(buffer, scratch + (SECTOR_SIZE - tempreadsize), remain);

				buffer += remain;
				fileinfo->pointer += remain;
				bytesread = remain;
				remain = 0;
			}
		}
		// Case 2 - File pointer is on sector boundary
		else {
			// Case 2A - We have at least one more full sector to read and don't have
			// to go through the scratch buffer. You could insert optimizations here to
			// read multiple sectors at a time, if you were thus inclined (note that
			// the maximum multi-read you could perform is a single cluster, so it would
			// be advantageous to have code similar to case 1A above that would round the
			// pointer to a cluster boundary the first pass through, so all subsequent
			// [large] read requests would be able to go a cluster at a time).
			if (remain >= SECTOR_SIZE) {
				result = DFS_ReadSector(fileinfo->volinfo->unit, buffer, sector, 1);
				remain -= SECTOR_SIZE;
				buffer += SECTOR_SIZE;
				fileinfo->pointer += SECTOR_SIZE;
				bytesread = SECTOR_SIZE;
			}
			// Case 2B - We are only reading a partial sector
			else {
				result = DFS_ReadSector(fileinfo->volinfo->unit, scratch, sector, 1);
				memcpy(buffer, scratch, remain);
				buffer += remain;
				fileinfo->pointer += remain;
				bytesread = remain;
				remain = 0;
			}
		}

		*successcount += bytesread;

		// check to see if we stepped over a cluster boundary
		if (div(fileinfo->pointer - bytesread, fileinfo->volinfo->secperclus * SECTOR_SIZE).quot !=
		  div(fileinfo->pointer, fileinfo->volinfo->secperclus * SECTOR_SIZE).quot) {
			// An act of minor evil - we use bytesread as a scratch integer, knowing that
			// its value is not used after updating *successcount above
			bytesread = 0;
			if (
#ifdef DOSFS_USE_FAT12
                          ((fileinfo->volinfo->filesystem == FAT12) && (fileinfo->cluster >= 0xff8)) ||
#endif
			  ((fileinfo->volinfo->filesystem == FAT16) && (fileinfo->cluster >= 0xfff8)) ||
			  ((fileinfo->volinfo->filesystem == FAT32) && (fileinfo->cluster >= 0x0ffffff8)))
				result = DFS_EOF;
			else
				fileinfo->cluster = DFS_GetFAT(fileinfo->volinfo, scratch, &bytesread, fileinfo->cluster);
		}
	}
	
	return result;
}

/*
	ajout� par ENO ce 2 juin 2010 pour lire les 2 premiers secteurs de la SD card
*/


IRC_Status SD_readTest()
{
	uint8_t sector[SECTOR_SIZE], sector2[SECTOR_SIZE];
	uint32_t pstart, psize, Count;
	uint8_t pactive, ptype;
	VOLINFO vi;
	DIRINFO di;
	DIRENT de;
	uint32_t cache;
	FILEINFO fi;
	uint8_t *p;

	// Obtain pointer to first partition on first (only) unit
	pstart = DFS_GetPtnStart(0, sector, 0, &pactive, &ptype, &psize);
	if (pstart == 0xffffffff) 
	{
		PRINTF("Cannot find first partition\r\n");
		return IRC_FAILURE;
	}

	PRINTF("Partition 0 start sector %d active %d type %d size %d\r\n", pstart, pactive, ptype, psize);

	if (DFS_GetVolInfo(0, sector, pstart, &vi)) 
	{
		PRINTF("Error getting volume information\r\n");
		return IRC_FAILURE;
	}
	
	PRINTF("Volume label '%-11.11s'\n", vi.label);
	PRINTF("%d sector/s per cluster, %d reserved sector/s, volume total %d sectors.\n", vi.secperclus, vi.reservedsecs, vi.numsecs);
	PRINTF("%d sectors per FAT, first FAT at sector #%d, root dir at #%d.\n",vi.secperfat,vi.fat1,vi.rootdir);
	PRINTF("(For FAT32, the root dir is a CLUSTER number, FAT12/16 it is a SECTOR number\n");
	PRINTF("%d root dir entries, data area commences at sector #%d.\n",vi.rootentries,vi.dataarea);
	PRINTF("%d clusters (%d bytes) in data area, filesystem IDd as \n", vi.numclusters, vi.numclusters * vi.secperclus * SECTOR_SIZE);
	
	if (vi.filesystem == FAT12)
		PRINTF("file system is FAT12.\n");
	else if (vi.filesystem == FAT16)
		PRINTF("file system is FAT16.\n");
	else if (vi.filesystem == FAT32)
		PRINTF("file system is FAT32.\n");
	else
		PRINTF("unknown file system \n");

	PRINTF("\n");	
	PRINTF("reading 1st data block# %d.\n", vi.dataarea);		   		   	   	   	   	
   if(SD_readSingleBlock(sector, vi.dataarea)) PRINTF("SD block read failed.\n");
   	
	/* Printf entire block*/
	for(Count = 0; Count < BLOCK_SIZE; Count++) PRINTF("%d ", sector[Count]);					
	PRINTF("\n");	
	
	PRINTF("reading the file's data:");	
	Count = 0;
	while(sector[Count]!='~')
	{	   		   	   	   	   	
		PRINTF("%X ", sector[Count]);
		Count++;
	}
	PRINTF("\n");
	PRINTF("done!");
	return IRC_SUCCESS;
}
