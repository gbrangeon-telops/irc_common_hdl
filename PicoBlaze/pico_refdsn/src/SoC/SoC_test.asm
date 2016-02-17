; Written by Olivier Bourgois with pBlazeIDE assembler syntax
; Date        : Oct 17 2006
; Filename    : SoC_test.asm
; Description : Basic Picoblaze SoC (System on Chip Test) testing
; 
; This program simply tests the pico core, uart and gpio register cores.  It does so
; by writing/reading back a value down the IO chain	incrementing it and then looping
; by running the controller_TB and observing the GPIO port in controller.bde we can see the
; value at the GPIO port incrementing at each run of the loop proving that the system
; is working properly. 
; 
 
; VHDL file generation settings: => VHDL "template file", "output file", "entity name"
VHDL      "vhdl_rom.in", "code_rom.vhd", "code_rom"

; Base Serial Port  Addresses
serial_stat		    DSIN	  0
serial_tx           DSOUT	  1
serial_rx			DSIN      1

; Interval Timer Port Addresses
timer_ctrl_hi       DSOUT	  3
timer_ctrl_lo       DSOUT	  2
timer_stat_hi       DSIN	  3
timer_stat_lo       DSIN	  2

; I/O Register Address
gpout 		   		DSOUT     4
gpin                DSIN      4

; RAM Register Address
ram                 DSRAM     $10

; constants
init_val            EQU       $00			      ; initial value to seed test
baud_hi        		EQU       $00                 ; interval timer for setting baud rate
baud_lo        		EQU       $04

cold_start:         LOAD      s1, baud_hi         ; set the interval timer tick time
	                OUT       s1, timer_ctrl_hi
                    LOAD      s1, baud_lo
	                OUT       s1, timer_ctrl_lo	
		   			LOAD      s1, init_val        ; output the first value to the serial port
loop:               CALL      serial_write        ; write count to serial port
					LOAD      s1, 0 			  ; clear the return register
                    CALL      serial_read         ; read it back
					OUT       s1, gpout           ; write it to the register for sim monitoring
                    LOAD      s1, 0 			  ; clear the return register
					IN        s1, gpin            ; read it back
					LOAD      s3, s1              ; copy it to s3
					AND       s3, $0F             ; mask it to generate a RAM address
					ADD       s3, ram             ; add the ram base address offset
					OUT       s1, ( s3 )          ; write it to the ram
					LOAD      s1, 0               ; clear the return register
					IN        s1, ( s3 )          ; read back from the ram
                    ADD       s1, 1               ; increment it
                    JUMP      loop                ; repeat until doomsday

; Write character in register s1 to serial port 0
serial_write: 
                    LOAD      s0, serial_stat     ; Read status register at IO port 0
                    IN        s2, ( s0 )
                    TEST      s2, 2               ; Check if transmit fifo is full
                    JUMP      NZ, serial_write    ; if full, then wait.

                    LOAD      s0, serial_tx       ; Write to transmit register at IO port 1
                    OUT       s1, ( s0 )
                    RET                           ; Done...

; Read character from serial port 0 in register s1
serial_read: 
                    LOAD      s0, serial_stat     ; Read status register
                    IN        s2, ( s0 )
                    TEST      s2, 16              ; Check if data ready (DR)
                    JUMP      Z, serial_read      ; if not ready, then wait

                    LOAD      s0, serial_rx       ; Read for receive register
                    IN        s1, ( s0 )
                    RET                           ; Done...
