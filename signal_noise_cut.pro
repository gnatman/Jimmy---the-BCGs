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
;   SIGNAL_NOISE_CUT
;
; PURPOSE:
;   This code calculates the signal to noise for each bin, and then performs a
;	signal to noise cut.
;
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	infile: The fully stacked fits file to be run through the procedure
;	sncut: The signal to noise cutoff level
;	outfile1: The ouput text file that lists the bins that pass the cut
;
;
; NOTES:
;	If run directly from IDL, edit everything within an 'if (testing ne 1)'
;	statement to have the proper directories. (Not implimented yet)
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
;		CanConnect http://www.idlcoyote.com/code_tips/hasdisplay.html
;
; MODIFICATION HISTORY:
;   V0.9 -- Created by Jimmy, 2011
;
;----------------------------------------------------------------------------

pro signal_noise_cut

;Location of test.fits file to be s/n cutted
file=getenv('infile')

;s/n wish to output
limit=FLOAT(getenv('sncut'))

; read in first extension which contains image data, and second extention, which has the variance data
im=mrdfits(file,0,header0)
var=mrdfits(file,1,header0)

crval=fxpar(header0,'CRVAL3')
crpix=fxpar(header0,'CRPIX3')
cdelt=fxpar(header0,'CDELT3')

;wish to calc s/n in 5000A region
wave_pix_4950 = (4950-crval)/cdelt
wave_pix_5050 = (5050-crval)/cdelt
sn_region = findgen(wave_pix_5050 - wave_pix_4950 + 1) ;+1 or +2 depending on what makes "POLY_FIT: X and Y must have same number of elements" disappear
sn_wave_region = ((sn_region + wave_pix_4950)*cdelt)+crval ;;rename this variable, maybes

imsize=size(im)
x_fibers=imsize[1]
y_fibers=imsize[2]
number_of_wave_pixels=imsize[3]

gal_lin=fltarr(number_of_wave_pixels)
var_lin=fltarr(number_of_wave_pixels)
noise_lin=fltarr(number_of_wave_pixels)
x=fltarr(x_fibers*y_fibers)
y=fltarr(x_fibers*y_fibers)
signal=fltarr(x_fibers*y_fibers)
var_noise=fltarr(x_fibers*y_fibers)
noise=fltarr(x_fibers*y_fibers)

k=0

;used once to send a spakel to Karl G.  Can probaly be deleted.
;print, 'im[20,21,*]',im[20,21,*]
;forprint,im[20,21,*],TEXTOUT='/Users/jimmy/kg.txt'

;go through x & y of each cube
for n0=0,x_fibers-1 do begin
    for n1=0,y_fibers-1 do begin
        
        gal_lin=im[n0,n1,wave_pix_4950:wave_pix_5050]
        var_lin=var[n0,n1,wave_pix_4950:wave_pix_5050]
        
        ; fit polynomial to region, with order 3 & fit output to array yfit
        ;print,'size(sn_wave_region)',size(sn_wave_region)
        ;print,'size(gal_lin)',size(gal_lin) 
        pfit=poly_fit(sn_wave_region,gal_lin, 3, yfit=yfit) ;fix on line 20
        
        ;create array = data - (vector of fitted yvalues)
        noise_lin=gal_lin-yfit
        
        ;make back into single dimension array:
        x[k]=n0
        y[k]=n1
        
        if mean(gal_lin) gt 0 then begin
            signal[k]=mean(gal_lin)
            noise[k]=robust_sigma(noise_lin)
        endif    
        if mean(gal_lin) le 0 then begin
            signal[k]=0.0
            noise[k]=9.9e6^2      ;robust_sigma(ncube[i,j,good])
        endif
        k=k+1    
    endfor
endfor

;checking integrated flux measurements
fibers=findgen(x_fibers*y_fibers)

if CanConnect() then begin
	plot,fibers,signal/noise,xtitle="fibre number",ytitle="Signal/Noise (4861)"
endif

signal_clean=where((signal ne 0) and (signal/noise ge limit))

;I believe spaxel scale should be 0.66 arcseconds and not cdelt, which is like 0.602
cdelt = 0.66

;WRITING OUT DATA FOR VORONOI TESSELATION
;voronoi tesselation requires as input x,y in arcseconds; pixels and
;the flux & noise in those fibres - can be output here:
astrolib
forprint, (x[signal_clean]-mean(x))*cdelt,(y[signal_clean]-mean(y))*cdelt,x[signal_clean],y[signal_clean],signal[signal_clean],noise[signal_clean], $
format='(2f10.4,2i6,2f20.4)',$
TEXTOUT=getenv('outfile1'), $
COMMENT='#         X"  Y"  Xpix          Ypix          signal noise'

end