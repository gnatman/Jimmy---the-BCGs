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
;   SDSS_CROP
;
; PURPOSE:
;   This code pulls in SDSS files containing the galaxy of interest and then 
;	crops them down so that they are much easier to work with
;
;
; NOTES:
;	Still very ugly, not ready for prime time.
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
;   V0.1 -- Created by Jimmy, 2011
;
;----------------------------------------------------------------------------

pro sdss_crop,target

;This directory contains other directories, named by target, which contain the actual SDSS image files, in all 5 grisms
dir='/Users/jimmy/Astro/sdss/'+target+'/'

;Use if statements to determine the proper bounds for the cropping.

if (target eq 1027) then begin
y_start = 0
y_end = 0
x_start = 0
x_end = 0
endif

if (target eq 1050) then begin
y_start = 550
y_end = 725
x_start = 1750
x_end = 1950
endif

if (target eq 1066) then begin
y_start = 1050
y_end = 1180
x_start = 175
x_end = 375
endif

if (target eq 1067) then begin
y_start = 0
y_end = 0
x_start = 0
x_end = 0
endif

if (target eq 1153) then begin
y_start = 1025
y_end = 1150
x_start = 480
x_end = 600
endif

if (target eq 2001) then begin
y_start = 0
y_end = 0
x_start = 0
x_end = 0
endif

if (target eq 2086) then begin
y_start = 0
y_end = 0
x_start = 0
x_end = 0
endif

;Use if statements to determine the proper filenames for each target.

if (target eq 1027) then begin
u_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
g_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
r_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
i_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
z_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
endif

if (target eq 1050) then begin
u_im=mrdfits(dir+'drC-001462-u3-0539.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
g_im=mrdfits(dir+'drC-001462-g3-0539.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
r_im=mrdfits(dir+'drC-001462-r3-0539.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
i_im=mrdfits(dir+'drC-001462-i3-0539.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
z_im=mrdfits(dir+'drC-001462-z3-0539.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
endif

if (target eq 1066) then begin
u_im=mrdfits(dir+'drC-002334-u5-0046.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
g_im=mrdfits(dir+'drC-002334-u5-0046.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
r_im=mrdfits(dir+'drC-002334-r5-0046.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
i_im=mrdfits(dir+'drC-002334-i5-0046.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
z_im=mrdfits(dir+'drC-002334-z5-0046.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
endif

if (target eq 1067) then begin
u_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
g_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
r_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
i_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
z_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
endif

if (target eq 1153) then begin
u_im=mrdfits(dir+'drC-000752-u4-0651.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
g_im=mrdfits(dir+'drC-000752-g4-0651.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
r_im=mrdfits(dir+'drC-000752-r4-0651.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
i_im=mrdfits(dir+'drC-000752-i4-0651.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
z_im=mrdfits(dir+'drC-000752-z4-0651.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
endif

if (target eq 2001) then begin
u_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
g_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
r_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
i_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
z_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
endif

if (target eq 2086) then begin
u_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
g_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
r_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
i_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
z_im=mrdfits(dir+'.fits',0,header0, RANGE=[y_start,y_end-1], /DSCALE, /SILENT)
endif

;sum up all the image files, just gives us a brighter image
im=u_im+g_im+r_im+i_im+z_im

;Determine the dimensions of our fits files
imsize=size(im)
x_size=x_end-x_start;imsize[1]
y_size = imsize[2]
;and the cropped file size
crop_im=fltarr(x_size+1,y_size)
crop_imsize=size(crop_im)


;DS9 counts from 1, IDL counts from 0
for j=0,y_size-1 do begin
    h=0
    for i=x_start,x_end do begin
        crop_im[h,j] = r_im[i,j]
        h=h+1
    endfor
endfor

;Write out the final cropped image

fileout=dir+'/'+target+'_crop.fits'
mwrfits,crop_im,fileout,create=1 ;/create=1 creates new file even if old one exists

end
