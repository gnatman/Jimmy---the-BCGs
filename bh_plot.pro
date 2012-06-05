pro bh_plot
COMPILE_OPT idl2, HIDDEN

readcol, '/Users/jimmy/Astro/Catalogs/bh_catalog.txt', F='A,A,F,F,F,F,F,F,F,A,A', name, type, distance, dispersion, dispersion_error, luminosity, mass, mass_min, mass_max, method, reference, SKIPLINE=1;, /silent

;for i=0, (n_elements(name)-1) do begin
;	print, name[i], type[i], distance[i], dispersion[i], dispersion_error[i], luminosity[i], mass[i], mass_min[i], mass_max[i], method[i], reference[i]
;endfor

A = FINDGEN(17) * (!PI*2/16.)
USERSYM, COS(A), SIN(A), /FILL
;X = [-6, 0, 6, 0, -6]  
;Y = [0, 6, 0, -6, 0]  
;USERSYM, X, Y, /FILL

;loadct, 4, /SILENT

set_plot, 'ps'
device, filename='bh_mass.eps', /encapsul, XSIZE=5, YSIZE=5, /INCHES

;data = Scale_Vector(Findgen(101), 30, 1200)
x_min = 80
x_max = 380
plot, dispersion, mass, psym = 8, yrange=[1E6,1E11], xrange = [x_min,x_max], XTICKS = 6, xtitle='!4' + String("162B) + '!X'+'(km s!E-1!N)', ytitle='M!IBH!N(M!D!9n!X!N)', /YLOG, /XLOG, BACKGROUND=255, COLOR=0, CHARSIZE = 1.5, CHARTHICK = 5, ythick = 5, xthick = 5
xyouts, 300, 5E10, 'BCGs?', CHARTHICK=5, CHARSIZE=1.2
;xyouts, dispersion, mass, name
;oploterror, dispersion, mass, mass_max, psym=3,/HIBAR
;oploterror, dispersion, mass, mass_min, psym=3,/LOBAR
oplot, [240,631], [2E9,2E9]
oplot, [240,240], [2E9, 1E11]

x =  findgen(631)
mbh = (10^8.29)*(x/200)^5.12
oplot, x, mbh

device,/close

end