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
;   LAMBDA_V_RE
;
; PURPOSE:
;   This code creates a plot of lambda_R_e vs mass, used for making posters.
;	Will likely be combined into a larger display results plot that automatically
;	pulls in data.
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
pro lambda_v_re
COMPILE_OPT idl2, HIDDEN

loadct, 4, /SILENT
;sauron_colormap
set_plot, 'ps'
device, filename='lambda_v_r_e.eps', /encapsul, /color, BITS=8 ;, SET_CHARACTER_SIZE=[270,190]


lambda_files = file_search('$HOME/Astro/reduced/*/{comp,main}/sn10/lambda_re.txt',COUNT=nfiles)
table_files = strarr(n_elements(lambda_files))
temp_string = strsplit(lambda_files, '/', /extract)
for i=0, n_elements(temp_string)-1 do begin
	table_files[i] = '/'+temp_string[i,0]+'/'+temp_string[i,1]+'/'+temp_string[i,2]+'/'+temp_string[i,3]+'/'+temp_string[i,4]+'/'+temp_string[i,5]+'/'+temp_string[i,6]+'/'+'table_one.txt'
endfor
print, table_files

r_e = fltarr(n_elements(lambda_files))
dispersion = fltarr(n_elements(lambda_files))
redshift = fltarr(n_elements(lambda_files))
lambda = fltarr(n_elements(lambda_files))
epsilon = fltarr(n_elements(lambda_files))
name = strarr(n_elements(lambda_files))
r_e_comp = fltarr(n_elements(lambda_files))
dispersion_comp = fltarr(n_elements(lambda_files))
redshift_comp = fltarr(n_elements(lambda_files))
lambda_comp = fltarr(n_elements(lambda_files))
epsilon_comp = fltarr(n_elements(lambda_files))
name_comp = strarr(n_elements(lambda_files))
for i=0, n_elements(lambda_files)-1 do begin
	readcol, lambda_files[i], F='F,F,F,F', dummy1, tempr_e, tempepsilon, templambda, /silent
	readcol, table_files[i], F='A,A,A,A,F,F', dummy1, dummy2, dummy3, dummy4, values, dummy5, /silent
	if (temp_string[i,5] eq 'main') then begin
		r_e[i] = tempr_e[0]
		dispersion[i] = values[2]
		redshift[i] = values[0]
		lambda[i] = templambda
		epsilon[i] = tempepsilon
		radius_rad = r_e*4.84813681E-6
		distance = redshift*1.302773E26
		radius_m = distance*tan(radius_rad)
		mass = (5*radius_m*((dispersion*1000)^2))/(1.98892E30*6.673E-11)
		log_mass = alog10(mass)
		m_dyn = log_mass
		;name[i] = strmid(temp_string[i,4], 0, 4)+temp_string[i,5] ;causes a bunch of divide by 0 and illegal operand errors
	endif else begin
		r_e_comp[i] = tempr_e[0]
		dispersion_comp[i] = values[2]
		redshift_comp[i] = values[0]
		lambda_comp[i] = templambda
		epsilon_comp[i] = tempepsilon
		radius_rad_comp = r_e_comp*4.84813681E-6
		distance_comp = redshift_comp*1.302773E26
		radius_m_comp = distance_comp*tan(radius_rad_comp)
		mass_comp = (5*radius_m_comp*((dispersion_comp*1000)^2))/(1.98892E30*6.673E-11)
		log_mass_comp = alog10(mass_comp)
		m_dyn_comp = log_mass_comp
		name_comp[i] = strmid(temp_string[i,4], 0, 4)+temp_string[i,5] ;causes a bunch of divide by 0 and illegal operand errors
	endelse
endfor

r_e = r_e[where(r_e ne 0)]
lambda = lambda[where(lambda ne 0)]
name = name[where(name ne '')]
r_e_comp = r_e_comp[where(r_e_comp ne 0)]
lambda_comp = lambda_comp[where(lambda_comp ne 0)]
name_comp = name_comp[where(name_comp ne '')]

usersym, [ -1, 1, 1, -1, -1 ], [ 1, 1, -1, -1, 1 ], /fill

plot, r_e, lambda, PSYM=4, yrange=[0,1.0], xrange = [0,12.5], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, XTITLE='R!De', YTITLE='!4k!D!3R!Le'
oplot, r_e, lambda, PSYM=8, COLOR = 180, symsize = 1.2
oplot, r_e_comp, lambda_comp, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
xyouts, r_e, lambda, name, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
xyouts, r_e_comp, lambda_comp, name_comp, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180

;USERSYM, [0,1,0,-1],[-1,0,1,0],/FILL
;oplot, sauron_m_dyn, sauron_lambda, PSYM=5, symsize = 1.2, thick=2

device,/close

;file_move,'lambda_v_mass.eps','Downloads/lambda_v_mass.eps', /OVERWRITE

end