;#############################################################################
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
;   ONE_BIN
;
; PURPOSE:
;   This code pulls in all the fibers for the galaxy or companion and throws
;	them into one bin.
;
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	infile: The Voronoi 2d binned data
;	outfile1: X and Y positions of bins
;	outfile2: X and Y bins
;
; NOTES:
;	If run directly from IDL, edit everything within an 'if (testing ne 1)'
;	statement to have the proper directories. At least when those statements
;	actually get added.
;
;--------------------------------
;
; LOGICAL PROGRESSION OF IDL CODE:
;	None
;
;--------------------------------
;
; REQUIRED ROUTINES:
;       None
;
; MODIFICATION HISTORY:
;   V0.5 -- Created by Jimmy, 2011
;
;----------------------------------------------------------------------------
pro one_bin


testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)


if (testing) then begin
	rdfloat, getenv('infile'), x, y, xpix, ypix, signal, noise,SKIPLINE=1
endif
    
if (testing ne 1) then begin
    rdfloat, '/Users/jimmy/Astro/reduced/1050pro/voronoi_2d_binning.txt', x, y, xpix, ypix, signal, noise,SKIPLINE=1
endif


file_size = size(x)

number_of_elements = file_size[1]

;print,'number_of_elements',number_of_elements

xnew = x
ynew = y
xpixnew = xpix
ypixnew = ypix
binNum = fltarr(number_of_elements)
xNode = 0
yNode = 0
sn = (total(signal)/total(noise))*sqrt(number_of_elements)
nPixels = number_of_elements
total_noise = total(noise)/sqrt(number_of_elements)

astrolib
;forprint, xnew, ynew, xpixnew, ypixnew, binNum, TEXTOUT='/Users/jimmy/Astro/reduced/1050pro/one_bin_output.txt', $
forprint, xnew, ynew, xpixnew, ypixnew, binNum, TEXTOUT=getenv('outfile1'), $
    COMMENT='#         X"          Y"          Xpix          Ypix          BIN_NUM'

;forprint, xNode, yNode, sn, nPixels, total_noise, TEXTOUT='/Users/jimmy/Astro/reduced/1050pro/one_bin_bins.txt', $
forprint, xNode, yNode, sn, nPixels, total_noise, TEXTOUT=getenv('outfile2'), $
    COMMENT='#         Xbin          Ybin          S/N     Num Pixels        Total Noise'

end