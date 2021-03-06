;#############################################################################
;
; Based initially off code written by Sarah Brough, Australian Astronomical Observatory
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
;   COMBINE_CUBE_QUADRANTS
;
; PURPOSE:
;	This code pulls each individual cube quadrant created by
;		"spectra_to_cube_quadrant" and combines them into one cube
;
;
; CALLING SEQUENCE:
;   combine_cube_quadrants,'observation','flag'
;	eg combine_cube_quadrants,'a','pt180'
;
; INPUT PARAMETERS:
;   Observation: Galaxies have multiple pointings, this identifies which
;		pointing the data is from, identified chronologically by letter
;   Pointing: To identify which pointing we're reducing, different pointings
;		need different calibration files, and may be rotated by 180 degrees
;		which would be identified as pt180, pt181, etc.
;
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	infile1: The directory containing the spectra files produced by the pipeline.
;
; OUTPUT:
;   One data cube with 3 extentions.
;
; NOTES:
;	If run directly from IDL, edit everything within an 'if (testing ne 1)'
;		statement to have the proper directories.
;
;--------------------------------
;
; LOGICAL PROGRESSION OF IDL CODE:
;	1.Read in the individual quadrants
;	2.Combine them.
;	3.Renormalize fiber transmission over the whole cube
;	4.Write Cube
;
;--------------------------------
;
; REQUIRED ROUTINES:
;       IDL Astronomy Users Library: http://idlastro.gsfc.nasa.gov/
;		Hitme.pro Written by Rob Sharp Australian Astronomical Observatory
;		cuberot.pro Written by Erik Rosolowsky https://people.ok.ubc.ca/erosolo/www/Landing.html
;
; MODIFICATION HISTORY:
;   V1.0 -- Created by Jimmy, 2011
;
;----------------------------------------------------------------------------

pro combine_cube_quadrants,obs,pointing


testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)




;READ IN INDIVIDUAL QUADRANT DATA
;Store each extention as a seperate array, and pull out the relevant keywords for later.

if (testing) then begin
    dir=getenv('infile1')
endif

if (testing ne 1) then begin
    dir='/Users/jimmy/Astro/reduced/1067pro'
endif

;Read in all the files we'll be combining, as well as the extentions that we'll be combining.
im1=mrdfits(dir+'/ifu_science_reduced_1'+obs+'_idl_'+pointing+'.fits',0,header0, /SILENT)
im1_notsky=mrdfits(dir+'/ifu_science_reduced_1'+obs+'_idl_'+pointing+'.fits',1,header0, /SILENT)
var1=mrdfits(dir+'/ifu_science_reduced_1'+obs+'_idl_'+pointing+'.fits',2,header0, /SILENT)
diag1=mrdfits(dir+'/diagnostic_1'+obs+'_'+pointing+'.fits',0,header0, /SILENT)
im2=mrdfits(dir+'/ifu_science_reduced_2'+obs+'_idl_'+pointing+'.fits',0,header0, /SILENT)
im2_notsky=mrdfits(dir+'/ifu_science_reduced_2'+obs+'_idl_'+pointing+'.fits',1,header0, /SILENT)
var2=mrdfits(dir+'/ifu_science_reduced_2'+obs+'_idl_'+pointing+'.fits',2,header0, /SILENT)
diag2=mrdfits(dir+'/diagnostic_2'+obs+'_'+pointing+'.fits',0,header0, /SILENT)
im3=mrdfits(dir+'/ifu_science_reduced_3'+obs+'_idl_'+pointing+'.fits',0,header0, /SILENT)
im3_notsky=mrdfits(dir+'/ifu_science_reduced_3'+obs+'_idl_'+pointing+'.fits',1,header0, /SILENT)
var3=mrdfits(dir+'/ifu_science_reduced_3'+obs+'_idl_'+pointing+'.fits',2,header0, /SILENT)
diag3=mrdfits(dir+'/diagnostic_3'+obs+'_'+pointing+'.fits',0,header0, /SILENT)
im4=mrdfits(dir+'/ifu_science_reduced_4'+obs+'_idl_'+pointing+'.fits',0,header0, /SILENT)
im4_notsky=mrdfits(dir+'/ifu_science_reduced_4'+obs+'_idl_'+pointing+'.fits',1,header0, /SILENT)
var4=mrdfits(dir+'/ifu_science_reduced_4'+obs+'_idl_'+pointing+'.fits',2,header0, /SILENT)
diag4=mrdfits(dir+'/diagnostic_4'+obs+'_'+pointing+'.fits',0,header0, /SILENT)



crval=fxpar(header0,'CRVAL3')
crpix=fxpar(header0,'CRPIX3')
cdelt=fxpar(header0,'CDELT3')
imsize=size(im1)
number_of_wave_pixels=imsize[3] ;depth of cube




;CREATE FULL CUBE
;Creating cube using information in individual quadrants. In the binary tables data runs from 21 - 60 to fix that here, read in data 0 - 60 (limiting for cubes that run 21-40) and - 20 to create correct end product

x1=0
x2=59
y1=0
y2=59

Nx=x2-x1+1 ;width of cube
Ny=y2-y1+1 ;height of cube

if (testing ne 1) then begin
    print,'Size of cube : ',Nx-20,Ny-20,number_of_wave_pixels
endif

;Create 40x40xwavelength arrays, using the most general case here incase sizes change
cube=fltarr(Nx-20,Ny-20,number_of_wave_pixels)
cube_notsky=fltarr(Nx-20,Ny-20,number_of_wave_pixels)
var=fltarr(Nx-20,Ny-20,number_of_wave_pixels)
diag=fltarr(Nx-20,Ny-20,5)

;go through x & y of each quadrant and place it in the proper position of the final cube
for x=0,Nx-1 do begin 
    for y=0,Ny-1 do begin
        ;make sure there is data in fiber before writing to appropriate cube spaxel.
        if (total(im1[x,y,*]) ne 0.0) then begin
            cube[x-20,y-20,*]=im1[x,y,*]
            cube_notsky[x-20,y-20,*]=im1_notsky[x,y,*]
            var[x-20,y-20,*]=var1[x,y,*]
        endif
        if (total(diag1[x,y,*]) ne 0.0) then begin
            diag[x-20,y-20,*]=diag1[x,y,*]
        endif
        if (x lt 40) then begin
            if (total(im2[x,y,*]) ne 0.0) then begin
                cube[x-20,y-20,*]=im2[x,y,*]
                cube_notsky[x-20,y-20,*]=im2_notsky[x,y,*]
                var[x-20,y-20,*]=var2[x,y,*]
            endif
            if (total(diag2[x,y,*]) ne 0.0) then begin
                diag[x-20,y-20,*]=diag2[x,y,*]
            endif
        endif
        if ((x lt 40) and (y lt 40)) then begin
            if (total(im3[x,y,*]) ne 0.0) then begin
                cube[x-20,y-20,*]=im3[x,y,*]
                cube_notsky[x-20,y-20,*]=im3_notsky[x,y,*]
                var[x-20,y-20,*]=var3[x,y,*]
            endif
            if (total(diag3[x,y,*]) ne 0.0) then begin
                diag[x-20,y-20,*]=diag3[x,y,*]
            endif
        endif
        if (y lt 40) then begin
            if (total(im4[x,y,*]) ne 0.0) then begin
                cube[x-20,y-20,*]=im4[x,y,*]
                cube_notsky[x-20,y-20,*]=im4_notsky[x,y,*]
                var[x-20,y-20,*]=var4[x,y,*]
            endif
            if (total(diag4[x,y,*]) ne 0.0) then begin
                diag[x-20,y-20,*]=diag4[x,y,*]
            endif
        endif
    endfor
endfor




;RENORMALIZE FIBER TRANSMISSION ACROSS WHOLE CUBE

imsize2=size(cube)
cube_x=imsize2[1]
cube_y=imsize2[2]
number_of_cube_wave_pixels=imsize2[3]

wave_pix_5557 = ((5557-crval)/cdelt)+crpix ;for the 5577 skyline, convert to pixels
wave_pix_5597 = ((5597-crval)/cdelt)+crpix ;set up a 2nd limit, 40 angstroms away.

sky_pix_range=findgen(wave_pix_5597-wave_pix_5557+1) ;find the range of sky in pixels
sky_angst_range=((sky_pix_range+wave_pix_5557)*cdelt)+crval ;then convert to angstroms

cube_trans=fltarr(cube_x,cube_y,number_of_cube_wave_pixels)
var_trans=fltarr(cube_x,cube_y,number_of_cube_wave_pixels)
int_flux_5577=fltarr(cube_x,cube_y)
im_corr=fltarr(wave_pix_5597+1) ;offset subtracted data


;go through x & y of each cube
for x=0,cube_x-1 do begin
    for y=0,cube_y-1 do begin
        ;This if statement stops the "CURVEFIT: Failed to converge- CHISQ increasing without bound" errors when there's nothing there to fit.
        if (max(cube[x,y,10:(number_of_cube_wave_pixels-1)]) gt 1) then begin ;could have done just *, but I have diagnostic stuff in frames 0-4 at least
            ;calculate noise offset using 5577 skyline in the cube that was not sky subtracted
            yfit=robust_linefit(sky_angst_range,cube_notsky[x,y,wave_pix_5557:wave_pix_5597],offset) ;yfit is a throw away here

            ;subtract continuum
            im_corr[wave_pix_5557:wave_pix_5597]=cube_notsky[x,y,wave_pix_5557:wave_pix_5597]-offset

            ;fit gaussian to corrected data
            gauss_fit=gaussfit(sky_angst_range,im_corr[wave_pix_5557:wave_pix_5597],gauss_coeff) ;gauss_fit is a throwaway, it's the coefficients we care about.

            ;calculate integrated flux in sky line
            int_flux_5577[x,y]=gauss_coeff[0]*gauss_coeff[2]*sqrt(2*!pi)
        endif
    endfor
endfor

;don't want to calculate median integrated flux for fibers with no flux.
good_lines=where(int_flux_5577 gt 0.0)
;calculate median of integrated flux
med_int_flux=median(int_flux_5577[good_lines])

;divide the flux found in skyline by median integrated flux to find our scale factor
scale=int_flux_5577/med_int_flux

for x=0,cube_x-1 do begin
    for y=0,cube_y-1 do begin
        cube_trans[x,y,*]=(cube[x,y,*]/scale[x,y]) ;scale the final cube signal
        var_trans[x,y,*]=(var[x,y,*]/(scale[x,y])^2) ;as is multiplicative need to adjust variance with scale squared
        ;to fix for zero flux regions:
        if (scale[x,y] le 0) then begin        
            cube_trans[x,y,*]=0.0
            var_trans[x,y,*]=9.9e6^2
        endif
        ;The first four frames of our cube contain quality check data, so let's preserve them.
        ;cube_trans[x,y,0]=cube[x,y,0] ;Fibers identifier
        ;cube_trans[x,y,1]=cube[x,y,1] ;Fibers used for sky
        ;cube_trans[x,y,2]=cube[x,y,2] ;Fibers that are identified bad
        ;cube_trans[x,y,3]=cube[x,y,3] ;Fibers that are zero, either set that way or naturally
    endfor
endfor





;WRITE OUT THE CUBE
;Done using standard idl file writes

if (testing) then begin
    fileout=dir+'ifu_science_cube'+obs+'_idl_'+pointing+'.fits'
    fileout_180=dir+'ifu_science_cube'+obs+'_idl_'+pointing+'.fits'
    diagout=dir+'diag_cube'+obs+'_'+pointing+'.fits'
    fovout=dir+'ifu_full_fov'+obs+'_'+pointing+'_idl.fits'
endif
if (testing ne 1) then begin
    fileout='/Users/jimmy/Downloads/ifu_science_cube'+obs+'_idl.fits'
    fileout_180='/Users/jimmy/Downloads/ifu_science_cube'+obs+'_idl_pt180.fits'
    diagout='/Users/jimmy/Downloads/diag_cube.fits'
    fovout='/Users/jimmy/Downloads/fov.fits'
endif

print,'Writing test data cube to file : '+fileout

mwrfits,cube_trans,fileout,/create ;/create creates new file even if old one exists

;reads header from newly created file to ensure proper header writting
head=headfits(fileout)

;add important header properties
sxaddpar,head,'CRVAL3',crval
sxaddpar,head,'CRPIX3',crpix
sxaddpar,head,'CDELT3',cdelt

fov=fltarr(Nx-20,Ny-20)

if (pointing eq 'pt180') then begin ;rotate the cube back to normal so it can be stacked with everything else.
    cube_trans_180=fltarr(cube_x,cube_y,number_of_cube_wave_pixels)
    var_trans_180=fltarr(cube_x,cube_y,number_of_cube_wave_pixels)
    diag_180=fltarr(Nx-20,Ny-20,5)
    
    cube_trans_180=cuberot(cube_trans,180)
    mwrfits,cube_trans_180,fileout_180,head,/create
    
    var_trans_180=cuberot(var_trans,180)
    mwrfits,var_trans_180,fileout_180,head
    
    diag_180=cuberot(diag,180)
    mwrfits,diag_180,diagout,head,/create
    
    for x=0,cube_x-1 do begin
		for y=0,cube_y-1 do begin
			fov[x,y] = total(cube_trans_180[x,y,*])
		endfor
	endfor
	mwrfits,fov,fovout,head,/create
endif else begin
	;write over former cube with new header
	mwrfits,cube_trans,fileout,head,/create

	;add as new extension variance array
	mwrfits,var_trans,fileout,head

	mwrfits,diag,diagout,head,/create
	
	for x=0,cube_x-1 do begin
		for y=0,cube_y-1 do begin
			fov[x,y] = total(cube_trans[x,y,*])
		endfor
	endfor
	mwrfits,fov,fovout,head,/create
endelse

end