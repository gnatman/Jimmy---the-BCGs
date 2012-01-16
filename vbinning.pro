;#############################################################################
;
; Based initially off code written by Michele Cappellari
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
;   VBINNING
;
; PURPOSE:
;   This code bins up the fibers using the Voronoi 2D binning method developed by
;	Cappellari.  
;
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	infile: List of bins, already run through the signal/noise cut
;	targetsn: The target signal/noise to bin up to
;	outfile1: The list of 2D bins after binning to the target signal/noise
;
; NOTES:
;	If run directly from IDL, edit everything within an 'if (testing ne 1)'
;		statement to have the proper directories.
;
;--------------------------------
;
; LOGICAL PROGRESSION OF IDL CODE:
;	None
;
;--------------------------------
;
; REQUIRED ROUTINES:
;       IDL Astronomy Users Library: http://idlastro.gsfc.nasa.gov/
;
; MODIFICATION HISTORY:
;   V1.0 -- Created by Jimmy, 2011
;
;----------------------------------------------------------------------------

pro vbinning

testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)


if (testing) then begin
    rdfloat, getenv('infile'), x, y, xpix, ypix, signal, noise,SKIPLINE=1
    targetSN = getenv('targetsn')
endif
    
if (testing ne 1) then begin
    rdfloat, '/Users/jimmy/idl/voronoi_2d_binning/voronoi_2d_binning.txt', x, y, xpix, ypix, signal, noise,SKIPLINE=1
    targetSN = 5.0
endif


; Load a colortable and open a graphic window so you can see the bins
loadct, 13
r = GET_SCREEN_SIZE()
window, xsize=r[0]*0.4, ysize=r[1]*0.8


;Perform the binning procedure
;input x,y,signal,noise,targetSN
voronoi_2d_binning, x, y, signal, noise, targetSN, binNum, xNode, yNode, xBar, yBar, sn, nPixels, scale, total_noise, /PLOT
;output binNum, xNode, yNode, xBar, yBar, sn, nPixels, scale, total_noise
;total_noise is a customization by me, helps with the fitting later


;write out found information to two files, first is by fiber, second is by bin
if (testing) then begin
    forprint, x, y, xpix, ypix, binNum, TEXTOUT=getenv('outfile1'), $
    COMMENT='#         X"          Y"          Xpix          Ypix          BIN_NUM'
    forprint, xNode, yNode, sn, nPixels, total_noise, TEXTOUT=getenv('outfile2'), $
    COMMENT='#         Xbin          Ybin          S/N     Num Pixels        Total Noise'
endif
    
if (testing ne 1) then begin
    forprint, x, y, xpix, ypix, binNum, TEXTOUT='/Users/jimmy/idl/voronoi_2d_binning/voronoi_2d_binning_output.txt', $
    COMMENT='#         X"          Y"          Xpix          Ypix          BIN_NUM'
    forprint, xNode, yNode, sn, nPixels, total_noise, TEXTOUT='/Users/jimmy/idl/voronoi_2d_binning/voronoi_2d_bins.txt', $
    COMMENT='#         Xbin          Ybin          S/N     Num Pixels        Total Noise'
endif


END