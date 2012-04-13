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
;   JIMMY_LAMBDA
;
; PURPOSE:
;   This code calculates the lambda parameter for a given galaxy as well as the 
;	ellipticity.
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	    inddir: Directory containing all the input information.
;
; NOTES:
;	None
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
;   V0.1 -- Created  by Jimmy.
;
;----------------------------------------------------------------------------
pro new_lambda, gal, obj

testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)


;Specify the location of source files.
if (testing ne 1) then begin
    dir='/Users/jimmy/Astro/reduced/'+gal+'pro/'+obj+'/'
endif
if (testing) then begin
    dir=getenv('indir')
endif
bins_file='voronoi_2d_bins.txt' ;has bin x & position as well as s/n info
ppxf_result='ppxf_v_bin_output' ;has velocity & dispersion info
binning_output='voronoi_2d_binning_output.txt';correlates bin # to position (tells us which pixels belong in which bin)
binning_input='voronoi_2d_binning.txt';binning input file, signal and noise numbers as well as positions
fits_read, dir+gal+obj+'_fov.fits', img, h
;openw, 9, dir+'lambda.txt' ;output file for this info.

;Read in the data from our source files.
rdfloat, dir+bins_file, xbin, ybin,sn,NPix,total_noise, SKIPLINE=1, /SILENT
rdfloat, dir+ppxf_result, bin,V,v_sig,sig,sig_sig,h3,h4,h5,h6,Chi2,z, /SILENT
rdfloat, dir+binning_output, x, y, xpix, ypix, binNum, SKIPLINE=1, /SILENT
rdfloat, dir+binning_input, xarc, yarc, x2, y2, signal, noise, SKIPLINE=1, /SILENT

;Pull in effective radius.  Could try calculating this to check.
if (testing ne 1) then begin
    r_e = 6.29 ;change manually.
endif
if (testing) then begin
    r_e = getenv('r_e')
endif


;Create blank arrays to store the numbers we'll be working with.
velocity=fltarr(n_elements(binNum))
dispersion=fltarr(n_elements(binNum))

;restructure our arrays so that they are in the same order as binning_output which contains position information.
for i=0,n_elements(binNum)-1 do begin
    for j = 0, n_elements(xbin)-1 do begin
        if (binNum[i] eq j) then begin
            velocity[i] = V[j]
            dispersion[i] = sig[j]
        endif
    endfor
endfor


;Find the central pixel of our galaxy.
;input: image
;output: sigma along major axis, elpticity, position angle, x center, y center
find_galaxy, img, majorAxis, eps, ang, xc, yc, /PLOT
hitme
;Now we have the pixel definition of center, so lets find the center in arcseconds.
for j=0,n_elements(binNum)-1 do begin
	if xpix[j] eq xc then begin
		if ypix[j] eq yc then begin
			xc_arc = xarc[j]
			yc_arc = yarc[j]
		endif
	endif
endfor
print,'Central x & y position in arcseconds: ', xc_arc, yc_arc

x_pos = x2 - xc
y_pos = y2 - yc
radius = sqrt((x_pos^2)+(y_pos^2))
arc_radius = radius*0.66 
if gal eq '1153' || '1067' then begin
	arc_radius = radius*0.33
endif




;
;Find the isophotes, use those lines to find the mean velocity and dispersions within those lines, and then also sum up the signal within those lines.
;Is this pixel within this circle?
;x = rcos(theta)
;y = rsin(theta)
;r = sqrt(x^2+y^2)
;theta = cos^-1 (x/r)



;MEASURE GALAXY PHOTOMETRY
minlevel = 50000 ; counts/pixel
print,'Excecuting sectors_photometry.'
;input: background subtracted image file, ellipticity, position angle, and center points
sectors_photometry, img, eps, ang, xc, yc, radius, angle, counts, MINLEVEL=minlevel
;output: a vector of counts described by a radius and an angle

;PERFORM MGE FIT TO GALAXY PHOTOMETRY
print,'Excecuting MGE_fit_sectors.'

ngauss = 19

;input: counts at each postition specified from sectors_photometry and ellipticity from find_galaxy
MGE_fit_sectors, radius, angle, counts, eps, SOL=sol, SCALE=scale, NGAUSS=ngauss, /PRINT

; Print the data-model contours comparison of the whole image
MGE_print_contours, img>minlevel, ang, xc, yc, sol, FILE='/Users/jimmy/mge_contours.ps', SCALE=scale, MAGRANGE=9
; Print the data-model contours comparison of the central regions
s = SIZE(img)
img = img[xc-s[1]/9:xc+s[1]/9,yc-s[2]/9:yc+s[2]/9]
MGE_print_contours, img, ang, s[1]/9, s[2]/9, sol, FILE='/Users/jimmy/nuclear_mge_contours.ps', SCALE=scale, MAGRANGE=9


;arc_radius = radius*0.66
;clean = where(arc_radius lt r_e)
;arc_radius = arc_radius[clean]
;angle = angle[clean]
;counts = counts[clean]

;print,'arc_radius: ',arc_radius[clean], ' angle: ',angle[clean], ' counts: ',counts[clean]



;
;Testing for now, but...
;Fix this for 1153!!!!!
;
;
;

;for j=0, n_elements(arc_radius)-1 do begin
;	if angle[j] ge 0 then begin
;		x = arc_radius[j]*cos(angle[j])/0.66
;		y = arc_radius[j]*sin(angle[j])/0.66
;		print,'arc_radius: ',arc_radius[j], ' angle: ',angle[j], ' counts: ',alog10(counts[j]), ' x: ', x, ' y: ', y
;	endif
;endfor











;Creates signal step levels between the min and the max signal range
;with the number of steps specified, this specifies the isophote levels that we
;will go up to.
photometry_steps=7
isophote=fltarr(photometry_steps)
lambda=fltarr(photometry_steps)
theta=fltarr(photometry_steps)
eps=fltarr(photometry_steps)
;Title, print it now so it doesn't print 50 times.
print, 'count_pix . . eps[k] . . theta[k] . . radius[k] . radius[k]/r_e . lambda[k] . I_phote[k]'

for j=0, photometry_steps-1 do begin
	min_signal=min(signal)
	max_signal=max(signal)/1.1
	;
	;DELETE THIS 1.1 and recheck.
	;
	;
	isophote[j]=alog10(min_signal) + (j * ( (alog10(max_signal) - alog10(min_signal)) / photometry_steps) )
	isophote[j]=10^(isophote[j]) ;go back to linear scale
endfor

print,'isophote: ',isophote

;maybe move this in to above loop.
for j=0,photometry_steps-1 do begin   
	count_pix = 0 ;the number of pixels being used.
    for k=0,n_elements(binNum)-1 do begin
        if (signal[k] gt isophote[j]) then begin ;if our signal is greater than our current step level
            ;print,'signal[k]: ',signal[k],' isophote[j]: ',isophote[j]
            ;print,'x_pos: ',x_pos[k],' y_pos: ',y_pos[k],' radius: ',radius[k],' arc_radius: ',arc_radius[k]
            ;print,'dispersion[k]: ',dispersion[k]
            print,'radius[k]',radius[k]
            if arc_radius[k] gt r_e then begin
            	print,'PANIC!  RADIUS IS GREATER THAN EFFECTIVE RADIUS.'
            endif
            count_pix=count_pix+1 ;incriment count pix in order to keep track of how many pixels end up in each bin
            ;Clear out our initial values.
            sum_numerator = 0
            sum_denominator = 0
            
            numerator = abs(velocity[k]) * signal[k] * radius[k]
            denominator = signal[k] * radius[k] * sqrt(velocity[k]^2 + dispersion[k]^2)

			sum_numerator = numerator + sum_numerator
			sum_denominator = denominator + sum_denominator
			
        endif
    endfor
    lambda[j] = sum_numerator / sum_denominator
	print, count_pix, eps[j], theta[j], arc_radius[j], arc_radius[j]/r_e, lambda[j], isophote[j]
endfor
    
    
    
    ;beginning lambda calculation, we will determine the numerator and denominator seperately.
    ;numerator = 
    ;

;close, 9

end