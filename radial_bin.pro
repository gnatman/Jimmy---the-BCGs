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
;   RADIAL_BIN
;
; PURPOSE:
;   This code is used to create radial bins.  It calls jimmy_circle to draw
;	draw the circles, and then pulls in the ppxf data to bin it all together.
;
;
; CALLING SEQUENCE:
;   jimmy_circle, radius, xout, yout, h
;
; INPUT PARAMETERS:
;   None
;
; OUTPUT PARAMETERS:
;   None
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	infile: The text file that describes the binning.
;	outfile1: radial_2d_binning_output.txt
;	outfile2: radial_2d_bins.txt
;
; NOTES:
;	Currently not very well documented, and not very well written.  But may
;	not use this code at all, so not going to fix right now.
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
;   V1.0 -- Created by Jimmy, 2011
;
;----------------------------------------------------------------------------

pro radial_bin

rdfloat, getenv('infile'), x, y, xpix, ypix, signal, noise,SKIPLINE=1
;rdfloat, '/Users/jimmy/Astro/reduced/1050pro/radial_2d_binning.txt', x, y, xpix, ypix, signal, noise,SKIPLINE=1

;fname='/Users/jimmy/Downloads/radial_2d_binning_output.txt' 
;fname2='/Users/jimmy/Downloads/radial_2d_bins.txt'
fname=getenv('outfile1')
fname2=getenv('outfile2')
openw,1,fname
openw,2,fname2

printf,1,'#         X"       Y"          Xpix    Ypix   BIN_NUM'
printf,2,'#      Xbin      Ybin     S/N     Num Pixels     Total Noise'

;this is a cheat
;
;
;signal = 10
;noise = 1
total_noise = 10
;
;

radius = getenv('radius')

xpixold = xpix
ypixold = ypix

xpix = fltarr(radius*4)
ypix = fltarr(radius*4)
xarc = fltarr(radius*4)
yarc = fltarr(radius*4)
xout = fltarr(radius*10)
yout = fltarr(radius*10)

target = '1050'
target = getenv('target')
print,'target: ',target

fits_read, '/Users/jimmy/Astro/reduced/'+target+'pro/all/'+target+'all_fov.fits', img, h
find_galaxy, img, majorAxis, eps, ang, xc, yc, /PLOT
print,'x-center ',xc,'  y-center ',yc

xcenter = xc
ycenter = yc

for i = 0,radius do begin

tempsignal = [0]
tempnoise = [0]

    if i eq 0 then begin
        x = [0]
        y = [0]
        xpix = x+xcenter
        ypix = y+ycenter
        xarc = x*0.33
        yarc = y*0.33
        bin = i        
        ;print, xpixold, xpix[0], ypixold, ypix[0]
        chosen = where(xpixold eq xpix[0] AND ypixold eq ypix[0])
        ;print, 'signal: ',signal
        ;print, 'chosen: ',chosen
        tempsignal = signal[chosen]
        tempnoise = noise[chosen]
        sn = (total(tempsignal)/total(tempnoise))*sqrt(1)
        total_noise = total(tempnoise)/sqrt(1)
        for j=0,(i*4) do begin
            PRINTF,1,xarc[j],yarc[j],xpix[j],ypix[j],bin
        endfor
        printf,2,xarc[0],yarc[0],sn,1,total_noise
    endif

    if i eq 1 then begin
        tmp = jimmy_circle(i, xout, yout, h)
        ;x = [1,0,-1,0]
        ;y = [0,1,0,-1]
        x = xout
        y = yout
        xpix = x+xcenter
        ypix = y+ycenter
        xarc = x*0.33
        yarc = y*0.33
        bin = i
        for j=0,(h)-1 do begin
            chosen = where(xpixold eq xpix[j] AND ypixold eq ypix[j])
            tempsignal = tempsignal+signal[chosen]
            tempnoise = tempnoise+noise[chosen]
            PRINTF,1,xarc[j],yarc[j],xpix[j],ypix[j],bin
        endfor
        sn = (total(tempsignal)/total(tempnoise))*sqrt(h)
        total_noise = total(tempnoise)/sqrt(h)
        printf,2,xarc[0],yarc[0],sn,h,total_noise
    endif

    if i eq 2 then begin
        tmp = jimmy_circle(i, xout, yout, h)
        x = [2,1,0,-1,-2,-1,0,1]
        y = [0,1,2,1,0,-1,-2,-1]
        x = xout
        y = yout
        xpix = x+xcenter
        ypix = y+ycenter
        xarc = x*0.33
        yarc = y*0.33
        bin = i
        for j=0,(h)-1 do begin
            chosen = where(xpixold eq xpix[j] AND ypixold eq ypix[j])
            tempsignal = tempsignal+signal[chosen]
            tempnoise = tempnoise+noise[chosen]
            PRINTF,1,xarc[j],yarc[j],xpix[j],ypix[j],bin
        endfor
        sn = (total(tempsignal)/total(tempnoise))*sqrt(h)
        total_noise = total(tempnoise)/sqrt(h)
        printf,2,xarc[0],yarc[0],sn,h,total_noise
    endif

    if i eq 3 then begin
        tmp = jimmy_circle(i, xout, yout, h)
        x = [3,3,3,2,2,1,0,-1,-2,-2,-3,-3,-3,-3,-3,-2,-2,-1,0,1,2,2,3,3]
        y = [0,1,2,2,3,3,3,3,3,2,2,1,0,-1,-2,-2,-3,-3,-3,-3,-3,-2,-2,-1]
        ;print,'xout',xout
        ;print,'yout',yout
        ;x = xout
        ;y = yout
        xpix = x+xcenter
        ypix = y+ycenter
        xarc = x*0.33
        yarc = y*0.33
        bin = i
        for j=0,(h)-1 do begin
            chosen = where(xpixold eq xpix[j] AND ypixold eq ypix[j])
            tempsignal = tempsignal+signal[chosen]
            tempnoise = tempnoise+noise[chosen]
            PRINTF,1,xarc[j],yarc[j],xpix[j],ypix[j],bin
        endfor
        sn = (total(tempsignal)/total(tempnoise))*sqrt(h)
        total_noise = total(tempnoise)/sqrt(h)
        printf,2,xarc[0],yarc[0],sn,h,total_noise
    endif

    if i eq 4 then begin
        tmp = jimmy_circle(i, xout, yout, h)
        x = [4,3,2,1,0,-1,-2,-3,-4,-3,-2,-1,0,1,2,3]
        y = [0,1,2,3,4,3,2,1,0,-1,-2,-3,-4,-3,-2,-1]
        x = xout
        y = yout
        xpix = x+xcenter
        ypix = y+ycenter
        xarc = x*0.33
        yarc = y*0.33
        bin = i
        for j=0,(h)-1 do begin
            chosen = where(xpixold eq xpix[j] AND ypixold eq ypix[j])
            tempsignal = tempsignal+signal[chosen]
            tempnoise = tempnoise+noise[chosen]
            PRINTF,1,xarc[j],yarc[j],xpix[j],ypix[j],bin
        endfor
        sn = (total(tempsignal)/total(tempnoise))*sqrt(h)
        total_noise = total(tempnoise)/sqrt(h)
        printf,2,xarc[0],yarc[0],sn,h,total_noise
    endif

    if i eq 5 then begin
        tmp = jimmy_circle(i, xout, yout, h)
        x = [5,4,3,2,1,0,-1,-2,-3,-4,-5,-4,-3,-2,-1,0,1,2,3,4]
        y = [0,1,2,3,4,5,4,3,2,1,0,-1,-2,-3,-4,-5,-4,-3,-2,-1]
        x = xout
        y = yout
        xpix = x+xcenter
        ypix = y+ycenter
        xarc = x*0.33
        yarc = y*0.33
        bin = i
        for j=0,(h)-1 do begin
            chosen = where(xpixold eq xpix[j] AND ypixold eq ypix[j])
            tempsignal = tempsignal+signal[chosen]
            tempnoise = tempnoise+noise[chosen]
            PRINTF,1,xarc[j],yarc[j],xpix[j],ypix[j],bin
        endfor
        sn = (total(tempsignal)/total(tempnoise))*sqrt(h)
        total_noise = total(tempnoise)/sqrt(h)
        printf,2,xarc[0],yarc[0],sn,h,total_noise
    endif

endfor

close,1
close,2

end