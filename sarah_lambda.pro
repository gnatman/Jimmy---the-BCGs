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
;   SARAH_LAMBDA
;
; PURPOSE:
;   This code calculates the lambda parameter for a given galaxy.
;
;
; NOTES:
;	Still based very heavily off of Sarah's code, plan on completely rewriting
;	this before writing my paper.
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
;   V0.1 -- Created by Sarah, 2010
;	V0.2 -- Edited by Jimmy, mostly formatting and commenting.
;
;----------------------------------------------------------------------------
pro sarah_lambda, gal, obj

;
;
;find where thing 1 and thing 2 are referenced, because we probably do it differently.
;
;

;loadct, 2
sauron_colormap

print,'obj: ',obj


testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)


if (testing ne 1) then begin
    dir='/Users/jimmy/Astro/reduced/'+gal+'pro/'
    if (strmatch(obj,'1') eq 1) then begin
		openw, 9, dir+'main/lambda.txt'
		openw, 1, dir+'main/lambda_re.txt'
    endif
    if (strmatch(obj,'2') eq 1) then begin
		openw, 9, dir+'comp/lambda.txt'
		openw, 1, dir+'comp/lambda_re.txt'
    endif
endif

if (testing) then begin
    dir=getenv('indir')
	openw, 9, dir+'lambda.txt'
	openw, 1, dir+'lambda_re.txt'
endif

file1='voronoi_2d_bins.txt'
file2='ppxf_v_bin_output'
file3='voronoi_2d_binning_output.txt'
file4='voronoi_2d_binning.txt'

rdfloat, dir+file1, xbin, ybin,sn,NPix,total_noise, SKIPLINE=1, /SILENT
rdfloat, dir+file2, bin,V,v_sig,sig,sig_sig,h3,h4,h5,h6,Chi2,z, /SILENT
rdfloat, dir+file3, x, y, xpix, ypix, binNum, SKIPLINE=1, /SILENT
rdfloat, dir+file4, xarc, yarc, x2, y2, signal, noise, SKIPLINE=1, /SILENT

;
;maybe just make one getenv call here and read these variables in from the galaxy themselves
;

;
;Or don't even bother with xmin and xmax if my masking works properly.
;

if (strmatch(gal,'1050') eq 1) then begin
    if (strmatch(obj,'1') eq 1) then begin
        r_e=6.29
        xmin=-5.
        xmax=5.
    endif
endif

if (strmatch(gal,'1027') eq 1) then begin
    if (strmatch(obj,'1') eq 1) then begin
        r_e=4.64
        xmin=5.
        xmax=13.
    endif
    if (strmatch(obj,'2') eq 1) then begin
        r_e=3.71
        xmin=-2
        xmax=5.                
    endif
endif

if (strmatch(gal,'1066') eq 1) then begin
    if (strmatch(obj,'1') eq 1) then begin
        r_e=7.03
        xmin=-6.
        xmax=-2.
    endif
    if (strmatch(obj,'2') eq 1) then begin
        r_e=7.23
        xmin=-2.
        xmax=5.                
    endif
endif

if (strmatch(gal,'2086') eq 1) then begin
    if (strmatch(obj,'1') eq 1) then begin
        r_e=4.63
        xmin=-8
        xmax=-3
    endif
    if (strmatch(obj,'2') eq 1) then begin
        r_e=1.51
        xmin=-3
        xmax=1               
    endif
endif

if (strmatch(gal,'1153') eq 1) then begin
    if (strmatch(obj,'1') eq 1) then begin
        r_e=3.11
        xmin=-4
        xmax=4
    endif
endif

if (strmatch(gal,'2001') eq 1) then begin
    if (strmatch(obj,'1') eq 1) then begin
        r_e=11.94
        xmin=-13
        xmax=13
    endif
endif

;
;above will probably be removed
;

;
;assign binned velocities from voronoi + ppxf analysis to original pixels
;

;create zerod out arrays that are the size of the number of lines in voronoi_2d_binning_output.txt
velocity=fltarr(n_elements(binNum))
dispersion=fltarr(n_elements(binNum))


;reassign velocity/dispersion measured in our bins output to the voronoi grouped pixels
for i=0,n_elements(binNum)-1 do begin
    for j = 0, n_elements(xbin)-1 do begin
        if (binNum[i] eq j) then begin
            velocity[i] = V[j]
            dispersion[i] = sig[j]
        endif
    endfor
endfor

;This is where our data is definitely good.
;clean=where(dispersion gt 120. and dispersion lt 500. and xarc gt xmin and xarc lt xmax)
;clean=where(dispersion gt 120. and dispersion lt 500.0)
clean=where(xarc gt xmin and xarc lt xmax)

;Print some diagnostic data to see how much gets cut
print,'Number of elements: ',n_elements(dispersion)
print,'Number used: ',n_elements(clean)
print,'Number rejected: ',n_elements(dispersion) - n_elements(clean)
print, 'x limits: ',xmin,' to',xmax


;assign all our variables to only the spaxels that pass the cut.
xarc=x[clean]
yarc=y[clean]
xpix=xpix[clean] 
ypix=ypix[clean]
binNum=binNum[clean] 
signal=signal[clean] 
velocity=velocity[clean] 
dispersion=dispersion[clean] 


;
;Consider replacing this with a find_galaxy call.  Maybe not necessary, but something to consider
;

;Find the central pixel, in arcseconds
for j=0,n_elements(binNum)-1 do begin
    if signal[j] eq max(signal) then begin
        central_xpix=xpix[j]
        central_ypix=ypix[j]   
        central_xarc=xarc[j]
        central_yarc=yarc[j]        
    endif
endfor

print,'Central x & y pixel: ', central_xpix + 1, central_ypix + 1
print,'Central x & y position: ', central_xarc, central_yarc


;
;Why seven steps? Is 8 or 6 better?
;

steps=7

;calculate isophote levels from log range of intensities
I_phote=fltarr(steps)


for k=0,steps-1 do begin
    min_signal=min(signal)
    max_signal=max(signal)/1.1 ;slightly reduced why?
    
    I_phote[k]=alog10(min_signal) + (k * ( (alog10(max_signal) - alog10(min_signal)) / steps) )
    I_phote[k]=10^(I_phote[k])
endfor

print,'I_phote: ',I_phote

;Take the ring of pixels surrounding the central pixel
central=where(xarc gt central_xarc-1.0 and xarc lt central_xarc+1.0 and yarc gt central_yarc-1. and yarc lt central_yarc+1.)

median_central_velocity=median(velocity[central],/EVEN) ;Find the median velocity of our central pixels square.

print, 'Median Velocity (within 1" of the center): ', median_central_velocity

velocity=velocity-median_central_velocity

;setting up variables to calculate radii and lambda parameters
area=fltarr(steps)
radius=fltarr(steps)
lambda=fltarr(steps)
eps=fltarr(steps)
theta=fltarr(steps)
Lp=fltarr(steps)
Lm=fltarr(steps)
plotter = fltarr(n_elements(binNum))
maxx = max(x, MIN=minx)
maxy = max(y, MIN=miny)

x_ell=fltarr(steps,200)
y_1=fltarr(steps,200)
x_ell_re=fltarr(200)
y_re=fltarr(200)
y_2=fltarr(steps,200)
t=fltarr(200)
a=fltarr(steps)
b=fltarr(steps)
sig_prof=fltarr(steps)

pix_area=(0.66^2) ;pi*r^2

;Title, print it now so it doesn't print 50 times.
print, 'count_pix . . eps[k] . . theta[k] . . radius[k] . radius[k]/r_e . lambda[k] . I_phote[k]'
printf, 9,'radius_sb[j], r_e, epsillon[j], lambda[j]'

plot,[0,40],[0,40], color=255, /NODATA, /ISO

for k=0,steps-1 do begin   
    count_pix = 0 ;the number of pixels being used.
    for j=0,n_elements(binNum)-1 do begin
        if (signal[j] gt I_phote[k]) then begin ;signal is signal from signal to noise calculation
            count_pix=count_pix+1 ;incriment count pix in order to...
        endif
    endfor


    area[k]=count_pix*pix_area ;number of pixels times the area per pixel

    radius[k]=sqrt(area[k]/!pi) ;seems like a weird way to go about it, couldn't we just count out in radii?
 
    ;Initially set all variables to zero.
    sum_upper_lam=0.0 ;upper lambda is the numerator in the equation
    sum_lower_lam=0.0 ;lower lambda is the denominator in the equation
    sum_ix=0.0
    sum_iy=0.0
    sum_ixy=0.0
    sum_sig=0.0

    for j=0,n_elements(binNum)-1 do begin
        if (signal[j] gt I_phote[k]) then begin
        	plotter[j] = plotter[j]+1
        	;print,'xpix[j]: ',xpix[j],' ypix[j]: ',ypix[j],' plotter[j]: ',plotter[j]
        	xyouts,xpix[j],ypix[j],'!9B!3',color=(plotter[j]*30)+0
            sum_upper_lam = (abs(velocity[j]) * signal[j] * radius[k]) + sum_upper_lam
            sum_lower_lam = (signal[j] * radius[k] * sqrt(velocity[j]^2 + dispersion[j]^2)) + sum_lower_lam
            sum_ix = (signal[j] * ((xarc[j] - central_xarc)^2)) + sum_ix
            sum_iy = (signal[j] * ((yarc[j] - central_yarc)^2)) + sum_iy
            sum_ixy = (signal[j] * (abs(xarc[j] - central_xarc)) * (abs(yarc[j]-central_yarc))) + sum_ixy
            sum_sig = dispersion[j] + sum_sig
        endif
    endfor

    delta=((sum_ix - sum_iy)^2) + (4.0 * (sum_ixy^2))
    Lp2 = ((sum_ix+sum_iy) + sqrt(delta)) /2.0
    Lm2 = ((sum_ix+sum_iy) - sqrt(delta)) /2.0
    Lp[k] = sqrt(Lp2)
    Lm[k] = sqrt(Lm2)
    eps[k] = (Lp[k] - Lm[k]) /Lp[k]
    theta[k] = (atan((sum_iy - Lp2) /sum_ixy)) * 180.0/!pi  
    sig_prof[k] = sum_sig /count_pix


    lambda[k] = sum_upper_lam / sum_lower_lam
    

    print, count_pix, eps[k], theta[k], radius[k], radius[k]/r_e, lambda[k], I_phote[k]
    if (testing ne 1) then begin
		printf, 9, radius[k], r_e, eps[k], lambda[k], FORMAT='(4f10.6)'
	endif


    ;radius=sqrt(a x b) and eps = b/a therefore:
    a[k] = sqrt(radius[k]^2 /eps[k])
    b[k] = a[k] * (eps[k])


    for n=0,199 do begin        
        t[n] = (n * ((2.0 * !pi) /199))
        ;print,'t[n]',t[n]
        x_ell[k,n] = central_xarc + (a[k] * cos(t[n]) * cos(theta[k] * (!pi/180.0))) - (b[k] * sin(t[n]) * sin(theta[k] * (!pi/180.0)))
        y_1[k,n] = central_yarc + (a[k] * cos(t[n]) * sin(theta[k] * (!pi/180.0))) + (b[k] * sin(t[n]) * cos(theta[k] * (!pi/180.0)))
    endfor
endfor



if radius[0] le r_e then begin   
    eps_re=eps[0]   
    theta_re=theta[0]
    lambda_re=lambda[0]
    radius_re=radius[0]
    a_re=a[0]
    b_re=b[0]
    sig_re=sig_prof[0]

    print, gal, obj, 'radius[0] le r_e'
endif



if radius[0] gt r_e then begin 
    print, gal, ' ', obj, 'radius[0] gt r_e'

    count_pix=0
    
    m=(alog10(signal[0])-alog10(signal[steps-1]))/(radius[0]-radius[steps-1])

    c=alog10(signal[0])-(m*radius[0])

    signal_re=(m*r_e)+c

    signal_re=10^(signal_re)

    for j=0,n_elements(binNum)-1 do begin
        if (signal[j] gt signal_re) then begin
            count_pix=count_pix+1
        endif
    endfor

    area_re=count_pix*pix_area

    radius_re=sqrt(area_re/!pi)

    sum_upper_lam=0.0
    sum_lower_lam=0.0
    sum_ix=0.0
    sum_iy=0.0
    sum_ixy=0.0
    sum_sig=0.0

    for j=0,n_elements(binNum)-1 do begin
        if (signal[j] gt signal_re) then begin
            sum_upper_lam=(abs(velocity[j])*signal[j]*radius_re)+sum_upper_lam
            sum_lower_lam=(signal[j]*radius_re*sqrt(velocity[j]^2+dispersion[j]^2))+sum_lower_lam
            sum_ix=(signal[j]*((xarc[j]-central_xarc)^2))+sum_ix
            sum_iy=(signal[j]*((yarc[j]-central_yarc)^2))+sum_iy
            sum_ixy=(signal[j]*(abs(xarc[j]-central_xarc))*(abs(yarc[j]-central_yarc)))+sum_ixy
            sum_sig=dispersion[j]+sum_sig
        endif
    endfor

    delta=((sum_ix-sum_iy)^2)+(4.*(sum_ixy^2))
    Lp2=((sum_ix+sum_iy)+sqrt(delta))/2.
    Lm2=((sum_ix+sum_iy)-sqrt(delta))/2.
    Lpe=sqrt(Lp2)
    Lme=sqrt(Lm2)
    eps_re=(Lpe-Lme)/Lpe
    theta_re=(atan((sum_iy-Lp2)/sum_ixy))*180./!pi    
    lambda_re=sum_upper_lam/sum_lower_lam
    ;radius=sqrt(a x b) and eps = b/a therefore:
    a_re=sqrt(radius_re^2/eps_re)
    b_re=a_re*(eps_re)
    sig_re=sum_sig/count_pix
endif

for n=0,199 do begin        
    t[n]=0.0+(n*((2.*!pi)/199))
    x_ell_re[n]=central_xarc+(a_re*cos(t[n]) *cos(theta_re*(!pi/180.)))-(b_re*sin(t[n])*sin(theta_re*(!pi/180.)))
    y_re[n]=central_yarc+(a_re*cos(t[n])*sin(theta_re*(!pi/180.)))+(b_re*sin(t[n])*cos(theta_re*(!pi/180.)))
endfor

;print, xpix
;print, ypix

;plot, [minx-0, maxx-0], [miny-0,maxy-0], /NODATA
;loadct,12
;set_plot, 'ps'
;device, filename='iphotes.eps', /encapsul, /color, BITS=8
;display_bins, xbin, ybin, sn, x,y, PIXELSIZE=1,RANGE=[0, 7]
;color_bar_y, 10, 11, !Y.crange[0],!y.crange[1],0,8,title='S/N'
;device,/close

;help,xbin,ybin,plotter,xarc,yarc

;plotbin,xbin,plotter

;for k=0,steps-1 do begin   
;	for j=0,n_elements(binNum)-1 do begin
;    	if (signal[j] gt I_phote[k]) then begin
;    		print,'xpix[j]: ',xpix[j],' ypix[j]: ',ypix[j],' plotter[j]: ',plotter[j]
;	    endif
;	endfor
;endfor

print,'Effective radius, act radius, ellip re, ellip theta, lambda,dispersion:'
print, r_e,radius_re,eps_re,theta_re,lambda_re,sig_re
if (testing ne 1) then begin
		printf, 1,'radius_sb_re, r_e, eps_re, lambda_re'
		printf, 1, radius_re, r_e, eps_re, lambda_re, FORMAT='(4f10.6)'
endif


;set_plot, 'ps'
;device, filename='lambda_v_R_e.eps', /encapsul, /color, BITS=8

;plot, radius/r_e, lambda, xtitle='radius/r_e', ytitle='lambda', title=gal+' '+obj, yrange=[0,0.5], xrange = [0,1]

;hitme

;plot, radius, alog10(i_phote), xtitle='radius', ytitle='log(i_phote)'
;hitme

;plot_velfield, xarc, yarc, signal, FLUX=signal

;set_plot, 'ps'
;device, filename='test.ps', /color, BITS=8

;display_pixels, xarc, yarc, alog10(signal), PIXELSIZE=0.66, RANGE=[min(alog10(signal)), max(alog10(signal))]
;oplot, x_ell_re,y_re

;for k=0,steps-1 do begin   
;    oplot, x_ell[k,*], y_1[k,*]
;endfor
;color_bar_y, 13.5, 15.5, !Y.crange[0],!y.crange[1],min(velocity),max(velocity),title='V [km/s]'

;device,/close
;set_plot,'x'

;    if (testing ne 1) then begin
		close, 9
		close, 1
;	endif

end
