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
;   JIMMY_CIRCLE
;
; PURPOSE:
;   This code is used to create radial bins.  Basically it draws circles in pixels.
;
;
; CALLING SEQUENCE:
;   jimmy_circle, radius, xout, yout, h
;
; INPUT PARAMETERS:
;   Radius: Radius in pixels of the circle to be drawn.
;
; OUTPUT PARAMETERS:
;   xout: Vector containing the x coordinates of the circle pixels
;   yout: Vector containing the y coordinates of the circle pixels
;   h: Dummy index tracking the number of pixels in the circle.
;
; NOTES:
;	I wish I knew a better way to do this, but for now it seems to work.  Also 
;	I think there's still a hack in there to cover a time when radius=4 was
;	missing pixels.
;
;--------------------------------
;
; LOGICAL PROGRESSION OF IDL CODE:
;	1.Create the first 1/8th of the circle
;	2.Mirror along 45 degree line
;	3.Mirror along y-axis
;	4.Mirror along x-axis
;
;--------------------------------
;
; REQUIRED ROUTINES:
;       None
;
; MODIFICATION HISTORY:
;   V0.9 -- Created by Jimmy, 2011
;
;----------------------------------------------------------------------------

function jimmy_circle, rad, xout, yout, h

radius = rad
x = radius
y = 0
yend = round(radius*sin(0.785))
xend = radius*cos(0.785)

x_vector = intarr(radius*10)
y_vector = intarr(radius*10)

h=0

for y=0,yend do begin
    temprad = sqrt(x*x+y*y)
    testrad = temprad ;round(temprad)
    ;print,'testrad',testrad,'   should be less than: ',radius+0.5
    if (testrad gt radius+0.5) then begin
        x = x - 1
    endif
    x_vector[h] = x
    y_vector[h] = y
    if (radius eq 3 AND y eq 1) then begin
        h = h+1
        x_vector[h] = 3
        y_vector[h] = 2
        ;print, 'x', x_vector[h], ' y', y_vector[h],' radius',testrad
        h = h+1
    endif
    ;print, 'x', x_vector[h], ' y', y_vector[h],' radius',testrad
    h = h+1
endfor    

i = x

while (i ne 0) do begin
    i = i - 1
    ;if (radius eq 3 AND y eq 1) then begin
    ;    h = h+1
    ;    x_vector[h] = 3
    ;    y_vector[h] = 2
    ;    ;print, 'x', x_vector[h], ' y', y_vector[h],' radius',testrad
    ;endif
    x_vector[h] = y_vector[i]
    y_vector[h] = x_vector[i]
    testrad = sqrt(x_vector[h]*x_vector[h]+y_vector[h]*y_vector[h])
    ;print, 'x', x_vector[h], ' y', y_vector[h],' radius',testrad
    h = h+1
endwhile

j = h - 1

while (j ne 0) do begin
    j = j - 1
    x_vector[h] = -x_vector[j]
    y_vector[h] = y_vector[j]
    testrad = sqrt(x_vector[h]*x_vector[h]+y_vector[h]*y_vector[h])
    ;print, 'x', x_vector[h], ' y', y_vector[h],' radius',testrad
    h = h+1
endwhile

k = h-1

while (k ne 1) do begin
    k = k - 1
    x_vector[h] = x_vector[k]
    y_vector[h] = -y_vector[k]
    testrad = sqrt(x_vector[h]*x_vector[h]+y_vector[h]*y_vector[h])
    ;print, 'x', x_vector[h], ' y', y_vector[h],' radius',testrad
    h = h+1
endwhile

;finalx = intarr(h)
;finaly = intarr(h)

for l=0, h-1 do begin
    xout[l] = x_vector[l]
    yout[l] = y_vector[l]
endfor

return, 0

end