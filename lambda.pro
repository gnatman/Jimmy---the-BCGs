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
;   LAMBDA
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
;   v0.5 -- 4/23/2012 Functional but ugly version of the code.
;   V0.1 -- 4/01/2012 Created  by Jimmy.
;
;----------------------------------------------------------------------------
pro lambda, gal, obj
COMPILE_OPT idl2, HIDDEN

testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)

;Specify the location of input files.
if (testing ne 1) then begin
    bins_file='/Users/jimmy/Astro/reduced/'+gal+'pro/'+obj+'/sn5/voronoi_2d_bins.txt'
    ppxf_result='/Users/jimmy/Astro/reduced/'+gal+'pro/'+obj+'/sn5/ppxf_v_bin_output'
    binning_output='/Users/jimmy/Astro/reduced/'+gal+'pro/'+obj+'/sn5/voronoi_2d_binning_output.txt'
    binning_input='/Users/jimmy/Astro/reduced/'+gal+'pro/'+obj+'/sn5/voronoi_2d_binning.txt'
    lambda_file='/Users/jimmy/Astro/reduced/'+gal+'pro/'+obj+'/sn5/lambda.txt'
    lambda_re_file='/Users/jimmy/Astro/reduced/'+gal+'pro/'+obj+'/sn5/lambda_re.txt'
    fitsdir='/Users/jimmy/Astro/reduced/'+gal+'pro/'+obj+'/'
endif
if (testing) then begin
    bins_file=getenv('infile1')
    ppxf_result=getenv('infile2')
    binning_output=getenv('infile3')
    binning_input=getenv('infile4')
    lambda_file=getenv('outfile1')
    lambda_re_file=getenv('outfile2')
    fitsdir=getenv('fitsdir')
endif
;File names contained within the directory.
;bins_file='voronoi_2d_bins.txt' ;has bin x & position as well as s/n info
;ppxf_result='ppxf_v_bin_output' ;has velocity & dispersion info
;binning_output='voronoi_2d_binning_output.txt';correlates bin # to position (tells us which pixels belong in which bin)
;binning_input='voronoi_2d_binning.txt';binning input file, signal and noise numbers as well as positions
fits_read, fitsdir+gal+obj+'_fov.fits', img, h
;Read in the data from our source files.
rdfloat, bins_file, xbin, ybin,sn,NPix,total_noise, SKIPLINE=1, /SILENT
rdfloat, ppxf_result, bin,V,v_sig,sig,sig_sig,h3,h4,h5,h6,Chi2,z, /SILENT
rdfloat, binning_output, x, y, xpix, ypix, binNum, SKIPLINE=1, /SILENT
rdfloat, binning_input, xarc, yarc, x2, y2, signal, noise, SKIPLINE=1, /SILENT



;File names of output files.  Using two different files because that's easier to parse
openw, 9, lambda_file ;output file for this info.
openw, 1, lambda_re_file ;output file for this info.

;Pull in effective radius.
if (testing ne 1) then begin
    r_e = 3.71 ;change manually.
endif
if (testing) then begin
    r_e = getenv('r_e')
endif

;
;
;
;
if (strmatch(gal,'1027') eq 1) then begin
    if (strmatch(obj,'main') eq 1) then begin
        r_e=4.64
        xmin=5.
        xmax=13.
    endif
    if (strmatch(obj,'comp') eq 1) then begin
        r_e=3.71
        xmin=-2
        xmax=5.                
    endif
endif
;
;
;
;

;Create blank arrays to store the numbers we'll be working with.
number_of_fibers=n_elements(binNum)
velocity=fltarr(number_of_fibers)
dispersion=fltarr(number_of_fibers)

;Restructure our arrays so that they are in the same order as binning_output which contains position information.
for i=0,number_of_fibers-1 do begin
    for j = 0, n_elements(xbin)-1 do begin
        if (binNum[i] eq j) then begin
            velocity[i] = V[j]
            dispersion[i] = sig[j]
        endif
    endfor
endfor

;
;
;
;
;
;
;
;
;This is where our data is definitely good.
;clean=where(dispersion gt 120. and dispersion lt 500. and xarc gt xmin and xarc lt xmax)
;clean=where(dispersion gt 120. and dispersion lt 500.0)
;clean=where(xarc gt xmin and xarc lt xmax)

;Print some diagnostic data to see how much gets cut
;print,'Number of elements: ',n_elements(dispersion)
;print,'Number used: ',n_elements(clean)
;print,'Number rejected: ',n_elements(dispersion) - n_elements(clean)
;print, 'x limits: ',xmin,' to',xmax


;assign all our variables to only the spaxels that pass the cut.
;xarc=x[clean]
;yarc=y[clean]
;xpix=xpix[clean] 
;ypix=ypix[clean]
;binNum=binNum[clean] 
;signal=signal[clean] 
;velocity=velocity[clean] 
;dispersion=dispersion[clean] 
;
;
;
;
;
;
;

img_size = size(img)
new_img = fltarr(img_size[1],img_size[2])
isophote_img = fltarr(img_size[1],img_size[2], 7)
for k=0, number_of_fibers-1 do begin
	for i=0, img_size[1]-1 do begin
		for j=0, img_size[2]-1 do begin
			if (i eq xpix[k] and j eq ypix[k]) then begin
				new_img[i,j] = img[i,j]
			endif
		endfor
	endfor
endfor
if (testing ne 1) then begin
	mwrfits,new_img,'new_img.fits',create=1 ;/create=1 creates new file even if old one exists
endif
;Find the central pixel of our galaxy.
find_galaxy, new_img, majorAxis, eps, ang, xc, yc, Fraction=1;, /PLOT
;hitme
;Now we have the pixel definition of center, so lets find the center in arcseconds.
for j=0,number_of_fibers-1 do begin
	if xpix[j] eq xc then begin
		if ypix[j] eq yc then begin
			xc_arc = xarc[j]
			yc_arc = yarc[j]
		endif
	endif
endfor
print,'Central x & y position in arcseconds: ', xc_arc, yc_arc


;Creates signal step levels between the min and the max signal range. The number of divisions 
;(steps) to use must be specified.
photometry_steps=7 ;Why seven steps, does more or less work better?
isophote=fltarr(photometry_steps)
for j=0, photometry_steps-1 do begin
	min_signal=min(signal)
	max_signal=max(signal)/1.1 ;**********************************;
	isophote[j]=alog10(min_signal) + (j * ( (alog10(max_signal) - alog10(min_signal)) / photometry_steps) )
	isophote[j]=10^(isophote[j]) ;go back to linear scale
endfor

;Take the ring of pixels surrounding the central pixel, and remove the central velocity, I don't like this.
central=where(xarc gt xc_arc-1.0 and xarc lt xc_arc+1.0 and yarc gt yc_arc-1. and yarc lt yc_arc+1.)
median_central_velocity=median(velocity[central],/EVEN) ;Find the median velocity of our central pixels square.
print, 'Median Velocity (within 1" of the center): ', median_central_velocity
velocity=velocity-median_central_velocity

;setting up variables to calculate radii and lambda parameters
area=fltarr(photometry_steps)
radius_sb=fltarr(photometry_steps)

;Values to be calculated in our big loop.
lambda=fltarr(photometry_steps)
lambda_sb=fltarr(photometry_steps)
epsillon=fltarr(photometry_steps)
theta=fltarr(photometry_steps)


;Find the radius of the pixel
x_dist = x2 - xc
y_dist = y2 - yc
radius = sqrt((x_dist^2)+(y_dist^2))
arc_radius = radius*0.66 
if (gal eq '1067' or gal eq '1153') then begin
	arc_radius = radius*0.33
endif


;This is used to plot the isophotes to check for consistency
plotter = fltarr(number_of_fibers)
if CanConnect() then begin
loadct,39
plot,[0,45],[0,45], color=255, /NODATA, /ISO
endif

;Used to derive the radius of the circle later.
pix_area=(0.66^2) ;r^2
if gal eq '1153' then begin
	pix_area=(0.33^2) ;r^2
endif
if gal eq '1067' then begin
	pix_area=(0.33^2) ;r^2
endif

;Title, print it now so it doesn't print 50 times.
print, 'count_pix . . epsillon[j] . . theta[j] . . radius[j] . radius[j]/r_e . lambda[j] . lambda_sb[j] . isophote[j]'
;if (testing ne 1) then begin
		printf, 9, 'radius_sb[j], r_e, epsillon[j], lambda[j]'
;endif


for j=0,photometry_steps-1 do begin   
    count_pix = 0 ;the number of pixels being used.
    for k=0,number_of_fibers-1 do begin
        if (signal[k] gt isophote[j]) then begin ;signal is signal from signal to noise calculation
            count_pix=count_pix+1 ;incriment count pix in order to determine the number of spaxels being used
            ;print,'xpix[k]: ',xpix[k],' ypix[k]: ',ypix[k]
            for i=0, img_size[1]-1 do begin
				for l=0, img_size[2]-1 do begin
					if (i eq xpix[k] and l eq ypix[k]) then begin
						isophote_img[i,l,j] = img[i,l]
					endif
				endfor
			endfor
        endif
    endfor
    if (testing ne 1) then begin
	    mwrfits,isophote_img[*,*,j],'new_img'+string(j)+'.fits',create=1 ;/create=1 creates new file even if old one exists
	endif
	tempimg = isophote_img[*,*,j]
    find_galaxy, tempimg, tempmajorAxis, tempeps, tempang, tempxc, tempyc, Fraction=1, /QUIET
	epsillon[j] = tempeps
	theta[j] = tempang
	
	
	;Find the radius of all the pixels, as if they were one constant radius circle.
    area[j]=count_pix*pix_area ;number of pixels times the area per pixel
    radius_sb[j]=sqrt(area[j]/!pi)
 
    ;Initially set all variables to zero.
    sum_upper_lam=0.0 ;upper lambda is the numerator in the equation
    sum_lower_lam=0.0 ;lower lambda is the denominator in the equation
    sum_upper_lam_sb=0.0 ;upper lambda is the numerator in the equation
    sum_lower_lam_sb=0.0 ;lower lambda is the denominator in the equation
    
    for k=0,number_of_fibers-1 do begin
        if (signal[k] gt isophote[j]) then begin
        	plotter[k] = plotter[k]+1
        	if CanConnect() then begin
        		xyouts,xpix[k],ypix[k],'!9B!3',color=(plotter[k]*30)+0
        	endif
        	sum_upper_lam = (abs(velocity[k]) * signal[k] * arc_radius[k]) + sum_upper_lam
            sum_lower_lam = (signal[k] * arc_radius[k] * sqrt(velocity[k]^2 + dispersion[k]^2)) + sum_lower_lam
            sum_upper_lam_sb = (abs(velocity[k]) * signal[k] * radius_sb[j]) + sum_upper_lam_sb
            ;print,'abs(velocity[k]): ',abs(velocity[k])
            ;print,'signal[k]: ',signal[k]
            ;print,'radius_sb[j]: ',radius_sb[j]
            ;print,'sum_upper_lam_sb: ',sum_upper_lam_sb
            sum_lower_lam_sb = (signal[k] * radius_sb[j] * sqrt(velocity[k]^2 + dispersion[k]^2)) + sum_lower_lam_sb
            endif
    endfor
    
	lambda[j] = sum_upper_lam / sum_lower_lam
    lambda_sb[j] = sum_upper_lam_sb / sum_lower_lam_sb
    
    print, count_pix, epsillon[j], theta[j], radius_sb[j], radius_sb[j]/r_e, lambda[j], lambda_sb[j], isophote[j]
	printf, 9, radius_sb[j], r_e, epsillon[j], lambda[j], FORMAT='(4f10.6)'
endfor

;This is the average of the radii of all the spaxels that are in one particular isophote,
;but not in any of the others.
average_radius=fltarr(photometry_steps)

current_xpix = fltarr(number_of_fibers+1)
current_ypix = fltarr(number_of_fibers+1)

for j=0,photometry_steps-1 do begin
	counter=0
	for i=0,number_of_fibers-1 do begin
		if plotter[i] ge j+1 then begin
			average_radius[j] = average_radius[j] + arc_radius[i]
			counter=counter+1
			;print,'xpix[i]: ',xpix[i],' ypix[i]: ',ypix[i]
			;current_xpix[i] = xpix[i]
			;current_ypix[i] = ypix[i]
		endif
		if plotter[i] ge j+2 then begin
			average_radius[j] = average_radius[j] - arc_radius[i]
			counter=counter-1
		endif
	endfor
	average_radius[j] = (average_radius[j]/counter)
endfor
;print,'average_radius: ',average_radius
;print,'radius_sb: ',radius_sb


if radius_sb[0] gt r_e then begin
effective_area = !pi*r_e^2
effective_pix_area = effective_area/pix_area
re_pixels = ROUND(effective_pix_area)
print,'effective_area',effective_area
print,'re_pixels',re_pixels

;print,'SORT(signal): ',SORT(signal)
sorter = REVERSE(SORT(signal))
sorted_signal = signal[sorter]
sorted_xpix = xpix[sorter]
sorted_ypix = ypix[sorter]
sorted_xarc=x[sorter]
sorted_yarc=y[sorter]
sorted_velocity=velocity[sorter] 
sorted_dispersion=dispersion[sorter] 


xpix_re = fltarr(re_pixels)
ypix_re = fltarr(re_pixels)
signal_re = fltarr(re_pixels)
xarc_re = fltarr(re_pixels)
yarc_re = fltarr(re_pixels)
velocity_re = fltarr(re_pixels)
dispersion_re = fltarr(re_pixels)
plotter_re = fltarr(re_pixels)

for i=0,re_pixels-1 do begin
	xpix_re[i] = sorted_xpix[i]
	ypix_re[i] = sorted_ypix[i]
	signal_re[i] = sorted_signal[i]
	xarc_re[i] = sorted_xarc[i]
	yarc_re[i] = sorted_yarc[i]
	velocity_re[i] = sorted_velocity[i]
	dispersion_re[i] = sorted_dispersion[i]
endfor

x_dist_re = xpix_re - xc
y_dist_re = ypix_re - yc
radius_re = sqrt((x_dist_re^2)+(y_dist_re^2))
arc_radius_re = radius_re*0.66 


re_img = fltarr(img_size[1],img_size[2])
for k=0, re_pixels-1 do begin
	for i=0, img_size[1]-1 do begin
		for j=0, img_size[2]-1 do begin
			if (i eq xpix_re[k] and j eq ypix_re[k]) then begin
				re_img[i,j] = img[i,j]
			endif
		endfor
	endfor
endfor
if (testing ne 1) then begin
	mwrfits,re_img,'re_img.fits',create=1 ;/create=1 creates new file even if old one exists
endif
find_galaxy, re_img, majorAxis_re, eps_re, ang_re, xc_re, yc_re, LEVEL=1; , /PLOT





	;Find the radius of all the pixels, as if they were one constant radius circle.
	radius_sb_re=sqrt(effective_area/!pi)
 
	;Initially set all variables to zero.
	sum_upper_lam_re=0.0 ;upper lambda is the numerator in the equation
	sum_lower_lam_re=0.0 ;lower lambda is the denominator in the equation
	
    
    for k=0,re_pixels-1 do begin
        	plotter_re[k] = plotter_re[k]+1
			if CanConnect() then begin
        	xyouts,xpix_re[k],ypix_re[k],'!9B!3',color=(plotter_re[k]*30)+0
        	endif
            sum_upper_lam_re = (abs(velocity_re[k]) * signal_re[k] * arc_radius_re[k]) + sum_upper_lam_re
            sum_lower_lam_re = (signal_re[k] * arc_radius_re[k] * sqrt(velocity_re[k]^2 + dispersion_re[k]^2)) + sum_lower_lam_re
            sum_upper_lam_sb_re = (abs(velocity_re[k]) * signal_re[k] * r_e) + sum_upper_lam_re
            sum_lower_lam_sb_re = (signal_re[k] * radius_sb_re * sqrt(velocity_re[k]^2 + dispersion_re[k]^2)) + sum_lower_lam_re
    endfor
    
	lambda_re = sum_upper_lam_re / sum_lower_lam_re
    lambda_sb_re = sum_upper_lam_sb_re / sum_lower_lam_sb_re
    
    print, re_pixels, eps_re, ang_re, radius_sb_re, radius_sb_re/r_e, lambda_re, lambda_sb_re, 0
	;if (testing ne 1) then begin
		printf, 1, 'radius_sb_re, r_e, eps_re, lambda_re'
		printf, 1, radius_sb_re, r_e, eps_re, lambda_re, FORMAT='(4f10.6)'
	;endif    
endif else begin
	printf, 1, 'radius_sb_re, r_e, eps_re, lambda_re'
	printf, 1, radius_sb[0], r_e, epsillon[0], lambda[0], FORMAT='(4f10.6)'
endelse

;if (testing ne 1) then begin
	close, 9
	close, 1
;endif

end