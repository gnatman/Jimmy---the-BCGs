;#############################################################################
;
;
; Last updated by Jimmy
; E-mail: jimmy@physics.tamu.edu
; 
; Updated versions of the software are available from my web page
; http://galaxies.physics.tamu.edu/jimmy/
;
; This software is provided as is without any warranty whatsoever.
; Permission to use, for non-commercial purposes is granted.
; Permission to modify for personal or internal use is granted,
; provided this copyright and disclaimer are included unchanged
; at the beginning of the file. All other rights are reserved.
;
;#############################################################################
;
; NAME:
;   BRIGHTEST_POINT
;
; PURPOSE:
;   This code looks at each data cube and tries to find the brightest point
;	after the cube has been collapsed.  Then it finds the offset of all the 
;	brightest points of all the other cubes from the first cube, so that the
;	offsets for stacking are automatically generated.
;
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	    infile1: Stacked and masked data cube.
;
; NOTES:
;	If run directly from IDL, edit everything within an 'if (testing ne 1)'
;		statement to have the proper directories.
;
;--------------------------------
;
; LOGICAL PROGRESSION OF IDL CODE:
;	1. Read in the list of files.
;	2. Find the brightest point in the cube
;	3. Find the x and y coordinates of that point.
;	4. Calculate the offset of each cube from the 1st cube.
;	5. Write the offsets to an idl.ifudat file.
;
;--------------------------------
;
; REQUIRED ROUTINES:
;       IDL Astronomy Users Library: http://idlastro.gsfc.nasa.gov/
;
; MODIFICATION HISTORY:
;   V0.1 -- Created by Jimmy, 2012
;
;----------------------------------------------------------------------------

pro brightest_point

testing=0 ;Set to 0 if you want to be in "testing" mode
testing_string=getenv('not_testing') ;read from bash
testing=FIX(testing_string) ;needed for the string to be an integer

;Read in files for input and start output
if (testing) then begin
	print, getenv('infile1')+'/ifu_science_cube*_idl*.fits'
	print, getenv('outfile1')+'/auto.ifudat'
	file_list = file_search(getenv('infile1')+'/ifu_science_cube*_idl*.fits',COUNT=nfiles)
	openw, 9, getenv('outfile1')+'/auto.ifudat'
endif
if (testing ne 1) then begin
    file_list = file_search('/Users/jimmy/Astro/reduced/1042pro/ifu_science_cube*_idl*.fits',COUNT=nfiles)
	openw, 9, '/Users/jimmy/Astro/reduced/1042pt1sof/auto.ifudat'
endif

number_of_files=size(file_list)

position = intarr(number_of_files[1],2)
position_offset = intarr(number_of_files[1],2)

printf,9, '# Root Directory, do not mess with grid variable'
printf,9, 'dir='
printf,9, 'grid=5 5'
printf,9, '# Filename xoffset yoffset'

for l=0,number_of_files[1]-1 do begin
	
	file=file_list[l]
	print,'file: ',file

	img=mrdfits(file,0,header0, /SILENT)

	img_size = size(img)

	x_size = img_size[1]
	y_size = img_size[2]
	summed_fibers = fltarr(x_size*y_size)
	k = 0

	for i=0,x_size-1 do begin
		for j=0,y_size-1 do begin
			summed_fibers[k] = total(img[i,j,*])
			k=k+1
		endfor
	endfor
	;print,summed_fibers
	brightest_point = max(summed_fibers)
	
	for i=0,x_size-1 do begin
		for j=0,y_size-1 do begin
			if (total(img[i,j,*]) eq brightest_point) then begin
				;print, 'Brightest point: ', i, j
				position[l,0] = i
				position[l,1] = j
				print, 'Brightest point: ', position[l,0]+1, position[l,1]+1 ;+1 because idl counts from zero, ds9 counts from 1
				position_offset[l,0] = position[0,0] - position[l,0]+10
				position_offset[l,1] = position[0,1] - position[l,1]+10
				print, 'Point Offset: ', position_offset[l,0], position_offset[l,1]
				printf,9, file, position_offset[l,0], position_offset[l,1], FORMAT='(a,2i)'
			endif
		endfor
	endfor
endfor
close,9
end