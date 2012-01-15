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