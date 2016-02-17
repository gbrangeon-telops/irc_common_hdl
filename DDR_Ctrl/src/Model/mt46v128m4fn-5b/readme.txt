Disclaimer of Warranty:
-----------------------
This software code and all associated documentation, comments or other 
information (collectively "Software") is provided "AS IS" without 
warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGES. Because some jurisdictions prohibit the exclusion or 
limitation of liability for consequential or incidental damages, the 
above limitation may not apply to you.

Copyright 2003 Micron Technology, Inc. All rights reserved.

Getting Started:
----------------
Unzip these four files to a folder.
Point your simulator to the folder where you located the files.
At the ModelSim command prompt, type "do tb.do"

File Descriptions:
------------------
ddr.v               --ddr model 
ddr_parameters.v    --File that contains all parameters used by the model
readme.txt          --This file
tb.v                --Test bench
tb.do               --File that compiles and runs the above files

Defining the Speed Grade:
-------------------------
The verilog compiler directive "`define" may be used to choose between 
multiple speed grades supported by the ddr model.  Allowable speed 
grades are listed in the ddr_parameters.v file and begin with the 
letters "sg".  The speed grade is used to select a set of timing 
parameters for the ddr model.  The following is an example of defining 
the speed grade using the ModelSim simulator.

    vlog +define+sg5 ddr.v

Defining the Organization:
--------------------------
The verilog compiler directive "`define" may be used to choose between 
multiple organizations supported by the ddr model.  Valid 
organizations include "x4", "x8", and "x16", and are listed in the 
ddr_parameters.v file.  The organization is used to select the amount 
of memory and the port sizes of the ddr model.  The following is an 
example of defining the organization using the ModelSim simulator.

    vlog +define+x8 ddr.v

All combinations of speed grade and organization are considered valid 
by the ddr model even though a Micron part may not exist for every 
combination.

Allocating Memory:
------------------
An associative array has been implemented to reduce the amount of 
static memory allocated by the DDR model.  The number of 
entries in the associative array is controlled by the part_mem_bits 
parameter, and is equal to 2^part_mem_bits.  For example, if the 
part_mem_bits parameter is equal to 10, the associative array will be 
large enough to store 1024 write data transfers to unique addresses.  
The following is an example of setting the part_mem_bits parameter to
8 using the ModelSim simulator.

	vsim -Gpart_mem_bits=8 ddr

It is possible to allocate memory for every address supported by the 
DDR2 model by using the verilog compiler directive "`define FULL_MEM".
This procedure will improve simulation performance at the expense of 
system memory.  The following is an example of allocating memory for
every address using the ModelSim simulator.

	vlog +define+FULL_MEM ddr.v
