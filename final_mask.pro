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
;   FINAL_MASK
;
; PURPOSE:
;   This code reads in the final stacked cube and masks it to focus only on
;	either the BCG or it's companion.  Can also be used to block out bright 
;	objects in the field of view that screw up our results.
;
;
; CALLING SEQUENCE:
;   final_mask,'target','mask'
;	eg final_mask,'1050','all'
;
; INPUT PARAMETERS:
;   Target: Name of the galaxy to be masked.
;   Mask: Chooses the mask file to be read in.  File format is two columns, x & y,
;		each row is the x and y coordinates of the fibers to be masked.  I use 
;		ds9 to identify which fibers need to be masked.
;
; MASKS:
;   all: Neither the galaxy or the companion is masked out, only bad fibers.
;   main: Focus on the BCG, and mask out all companions.
;   comp: Focus on the 1st companion, and mask everything else.
;	2ndcomp: If a 2nd companion exists, focus on it, and mask everything else.
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	infile1: The directory containing the spectra files produced by the pipeline.
;	final_mask: The location of the mask file.
;
; OUTPUT:
;   One data cube, same as input, but now masked.
;
; NOTES:
;	If run directly from IDL, edit everything within an 'if (testing ne 1)'
;		statement to have the proper directories.
;
;--------------------------------
;
; LOGICAL PROGRESSION OF IDL CODE:
;	1.Read in the data cube, and mask file.
;	2.Mask the data.
;	3.Write cube back out.
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

pro final_mask,target,mask

;By reading in a list of fibers to set to zero, we can mask one portion of the final data cube.

testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)

if (testing) then begin
    dir=getenv('infile1')
endif

if (testing ne 1) then begin
    dir='/Users/jimmy/Astro/reduced/'+target+'pro/'
endif

im=mrdfits(dir+'temp.fits',0,header0) ;, /SILENT)
var=mrdfits(dir+'temp.fits',1,header0) ;, /SILENT)

imsize=size(im)
x_size=imsize[1]
y_size=imsize[2]

crval=fxpar(header0,'CRVAL3')
crpix=fxpar(header0,'CRPIX3')
cdelt=fxpar(header0,'CDELT3')

;DS9 counts from 1, IDL counts from 0

;SET BAD FIBERS TO ZERO
;Done by importing a column list of bad fibers (with a 0 at the end to keep the loop from freaking out)

if (testing ne 1) then begin
    readcol,'/Users/jimmy/Astro/reduced/'+target+'sof/'+mask+'_mask.txt',F='F,F',mask_x,mask_y
endif

if (testing) then begin
    readcol,getenv('final_mask'),F='F,F',mask_x,mask_y
endif

mask_size=size(mask_x)

;Actual masking process
for i=0,mask_size[1]-1 do begin
        im[mask_x[i]-1,mask_y[i]-1,*]=0.0
endfor

im_2d=fltarr(x_size,y_size)

for i=0,x_size-1 do begin
    for j=0,y_size-1 do begin
        total = total(im[i,j,*])
        im_2d[i,j] = total
        if ( total le 0.0 ) then begin
            im_2d[i,j] = 0.0
        endif
    endfor
endfor


;WRITE OUT THE CUBE
;Done using standard idl file writes

if (testing) then begin
    fileout=dir+mask+'/'+target+mask+'.fits'
    fileout_var=dir+mask+'/'+target+mask+'_var.fits'
    fovout=dir+mask+'/'+target+mask+'_fov.fits'
endif
if (testing ne 1) then begin
    fileout='/Users/jimmy/Downloads/temp.fits'
    fileout_var='/Users/jimmy/Downloads/temp_var.fits'
    fovout='/Users/jimmy/Downloads/temp_fov.fits'
endif

mwrfits,im,fileout,create=1 ;/create=1 creates new file even if old one exists
mwrfits,im_2d,fovout,create=1

;reads header from newly created file to ensure proper header writting
head=headfits(fileout)

;add important header properties
sxaddpar,head,'CRVAL3',crval
sxaddpar,head,'CRPIX3',crpix
sxaddpar,head,'CDELT3',cdelt

;write over former cube with new header
mwrfits,im,fileout,head,create=1
mwrfits,im_2d,fovout,head,create=1

;add as new extension variance array
mwrfits,var,fileout,head,create=0
mwrfits,var,fileout_var,head,create=1


end
