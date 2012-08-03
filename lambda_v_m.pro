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
;   LAMBDA_V_M
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
pro lambda_v_m
COMPILE_OPT idl2, HIDDEN

loadct, 4, /SILENT
;sauron_colormap
set_plot, 'ps'
device, filename='lambda_v_mass.eps', /encapsul, /color, BITS=8 ;, SET_CHARACTER_SIZE=[270,190]

label = [ 'BCG 1050', 'BCG 1027', 'BCG 1066', 'BCG 2086', 'BCG 2001', 'BCG 1153' ] 
;lambda = [ 0.124, 0.150, 0.164, 0.144, 0.179, 0.240 ]
;m_dyn = [ 12.08, 11.85, 11.88, 11.82, 11.25, 11.87 ]
;label_comp = [ 'Comp 1027', 'Comp 1066', 'Comp 2086' ] 
;lambda_comp = [ 0.272, 0.483, 0.11 ]
;m_dyn_comp = [ 11.6, 11.6, 11.06 ]
;sarah_lambda = [ 0.113958, 0.112633, 0.346064, 0.256023, 0.715347, 0.103441 ]
;sarah_m_dyn = [ 12.2, 11.8, 11.57, 11.84, 11.85, 11.78, 11.15 ]

spawn,'rm -rf $HOME/Astro/reduced/pro'
spawn,'rm -rf $HOME/Astro/reduced/sof'

lambda_files = file_search('$HOME/Astro/reduced/*/{comp,main}/sn10/lambda_re.txt',COUNT=nfiles)
table_files = strarr(n_elements(lambda_files))
temp_string = strsplit(lambda_files, '/', /extract)
for i=0, n_elements(temp_string)-1 do begin
	table_files[i] = '/'+temp_string[i,0]+'/'+temp_string[i,1]+'/'+temp_string[i,2]+'/'+temp_string[i,3]+'/'+temp_string[i,4]+'/'+temp_string[i,5]+'/'+temp_string[i,6]+'/'+'table_one.txt'
endfor
print, table_files

r_e = fltarr(n_elements(lambda_files))
half_r_e = fltarr(n_elements(lambda_files))
dispersion = fltarr(n_elements(lambda_files))
redshift = fltarr(n_elements(lambda_files))
lambda = fltarr(n_elements(lambda_files))
half_lambda = fltarr(n_elements(lambda_files))
epsilon = fltarr(n_elements(lambda_files))
half_epsilon = fltarr(n_elements(lambda_files))
name = strarr(n_elements(lambda_files))
r_e_comp = fltarr(n_elements(lambda_files))
half_r_e_comp = fltarr(n_elements(lambda_files))
dispersion_comp = fltarr(n_elements(lambda_files))
redshift_comp = fltarr(n_elements(lambda_files))
lambda_comp = fltarr(n_elements(lambda_files))
half_lambda_comp = fltarr(n_elements(lambda_files))
epsilon_comp = fltarr(n_elements(lambda_files))
half_epsilon_comp = fltarr(n_elements(lambda_files))
name_comp = strarr(n_elements(lambda_files))
for i=0, n_elements(lambda_files)-1 do begin
	readcol, lambda_files[i], F='F,F,F,F', radius, tempr_e, tempepsilon, templambda, /silent
	readcol, table_files[i], F='A,A,A,A,F,F', dummy1, dummy2, dummy3, dummy4, values, dummy5, /silent
	if (temp_string[i,5] eq 'main') then begin
		if (n_elements(tempr_e) eq 3) then begin
			r_e[i] = tempr_e[1]
			lambda[i] = templambda[1]
			epsilon[i] = tempepsilon[1]
			half_r_e[i] = tempr_e[0]
			half_lambda[i] = templambda[0]
			half_epsilon[i] = tempepsilon[0]
		endif else if (n_elements(tempr_e) eq 2) then begin
			r_e[i] = tempr_e[1]
			lambda[i] = templambda[1]
			epsilon[i] = tempepsilon[1]
			half_r_e[i] = tempr_e[0]
			half_lambda[i] = templambda[0]
			half_epsilon[i] = tempepsilon[0]
		endif else begin
			r_e[i] = tempr_e[0]
			lambda[i] = templambda[0]
			epsilon[i] = tempepsilon[0]
			half_r_e[i] = tempr_e[0]
			half_lambda[i] = templambda[0]
			half_epsilon[i] = tempepsilon[0]
		endelse
		dispersion[i] = values[2]
		redshift[i] = values[0]
		radius_rad = r_e*4.84813681E-6
		distance = redshift*1.302773E26
		radius_m = distance*tan(radius_rad)
		mass = (5*radius_m*((dispersion*1000)^2))/(1.98892E30*6.673E-11)
		log_mass = alog10(mass)
		m_dyn = log_mass
		name[i] = strmid(temp_string[i,4], 0, 4)+temp_string[i,5] ;causes a bunch of divide by 0 and illegal operand errors
	endif else begin
		if (n_elements(tempr_e) eq 3) then begin
			r_e_comp[i] = tempr_e[1]
			lambda_comp[i] = templambda[1]
			epsilon_comp[i] = tempepsilon[1]
			half_r_e_comp[i] = tempr_e[0]
			half_lambda_comp[i] = templambda[0]
			half_epsilon_comp[i] = tempepsilon[0]
		endif else if (n_elements(tempr_e) eq 2) then begin
			r_e_comp[i] = tempr_e[1]
			lambda_comp[i] = templambda[1]
			epsilon_comp[i] = tempepsilon[1]
			half_r_e_comp[i] = tempr_e[0]
			half_lambda_comp[i] = templambda[0]
			half_epsilon_comp[i] = tempepsilon[0]
		endif else begin
			r_e_comp[i] = tempr_e[0]
			lambda_comp[i] = templambda[0]
			epsilon_comp[i] = tempepsilon[0]
			half_r_e_comp[i] = tempr_e[0]
			half_lambda_comp[i] = templambda[0]
			half_epsilon_comp[i] = tempepsilon[0]
		endelse
		dispersion_comp[i] = values[2]
		redshift_comp[i] = values[0]
		radius_rad_comp = r_e_comp*4.84813681E-6
		distance_comp = redshift_comp*1.302773E26
		radius_m_comp = distance_comp*tan(radius_rad_comp)
		mass_comp = (5*radius_m_comp*((dispersion_comp*1000)^2))/(1.98892E30*6.673E-11)
		log_mass_comp = alog10(mass_comp)
		m_dyn_comp = log_mass_comp
		name_comp[i] = strmid(temp_string[i,4], 0, 4)+temp_string[i,5] ;causes a bunch of divide by 0 and illegal operand errors
	endelse
endfor

for i=0, n_elements(name)-1 do begin
	if (redshift[i] ne 0) then begin
		print,'Name: ',name[i],' Z: ',redshift[i],' Dispersion: ',dispersion[i],' Mass: ',m_dyn[i],' Lambda: ',lambda[i],' R_e: ',r_e[i],' Ellipticity: ',epsilon[i]
	endif
endfor

for i=0, n_elements(name_comp)-1 do begin
	if (redshift_comp[i] ne 0) then begin
		print,'Name: ',name_comp[i],' Z: ',redshift_comp[i],' Dispersion: ',dispersion_comp[i],' Mass: ',m_dyn_comp[i],' Lambda: ',lambda_comp[i],' R_e: ',r_e_comp[i],' Ellipticity: ',epsilon_comp[i]
	endif
endfor


;Window,1,XSIZE=1200,YSIZE=700

usersym, [ -1, 1, 1, -1, -1 ], [ 1, 1, -1, -1, 1 ], /fill

print,m_dyn
plot, m_dyn, lambda, PSYM=4, yrange=[0,1.0], xrange = [9.8,12.5], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, XTITLE='!3Log (M!Ddyn!N[M!D!9n!X!N])', YTITLE='!4k!D!3R!Le'
oplot, m_dyn, lambda, PSYM=8, COLOR = 180, symsize = 1.2
oplot, m_dyn_comp, lambda_comp, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
<<<<<<< HEAD
xyouts, m_dyn, lambda, name, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
xyouts, m_dyn_comp, lambda_comp, name_comp, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
=======
;xyouts, m_dyn, lambda, name, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
;xyouts, m_dyn_comp, lambda_comp, name_comp, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
>>>>>>> Trying 100 monte carlo iterations

;oplot, sarah_m_dyn, sarah_lambda, PSYM=6, color=100
;xyouts, sarah_m_dyn+0.02, sarah_lambda-0.005, label, color=100, CHARSIZE = 1

readcol,'$HOME/Astro/Supporting\ Documents/SAURON_Data_Fig7_LR_MB_Mvir_core.txt', F='A,F,F,F,A', dummy1, sauron_lambda, dummy2, sauron_m_dyn, dummy3, /SILENT

;USERSYM, [0,1,0,-1],[-1,0,1,0],/FILL


oplot, sauron_m_dyn, sauron_lambda, PSYM=5, symsize = 1.2, thick=2

;LEGEND
plots, 11.95, 0.94, PSYM=5, symsize = 1.2, thick=2
xyouts, 12, 0.925, 'SAURON', charthick=2
plots, 11.95, 0.89, PSYM=8, COLOR = 180, symsize = 1.2
xyouts, 12, 0.875, 'BCG', charthick=2
plots, 11.95, 0.84, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
xyouts, 12, 0.825, 'Companion', charthick=2
plots, [11.85,12.5],[0.8,0.8], thick=5
plots, [11.85,11.85],[0.8,1.0], thick=5

device,/close

set_plot, 'ps'
device, filename='half_lambda_v_mass.eps', /encapsul, /color, BITS=8 ;, SET_CHARACTER_SIZE=[270,190]
plot, m_dyn, half_lambda, PSYM=4, yrange=[0,1.0], xrange = [9.8,12.5], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, XTITLE='!3Log (M!Ddyn!N[M!D!9n!X!N])', YTITLE='!4k!D!3R!Le!N!D/2'
oplot, m_dyn, half_lambda, PSYM=8, COLOR = 180, symsize = 1.2
oplot, m_dyn_comp, half_lambda_comp, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
<<<<<<< HEAD
xyouts, m_dyn, half_lambda, name, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
xyouts, m_dyn_comp, half_lambda_comp, name_comp, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
=======
;xyouts, m_dyn, half_lambda, name, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
;xyouts, m_dyn_comp, half_lambda_comp, name_comp, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
>>>>>>> Trying 100 monte carlo iterations

readcol,'$HOME/Astro/Supporting\ Documents/SAURON_Data_Fig7_LR_MB_Mvir_core.txt', F='A,F,F,F,A', name, sauron_lambda, magnitude, sauron_m_dyn, class, /SILENT
readcol,'$HOME/Astro/Supporting\ Documents/SAURON_Data_Fig5_LR_Ell.txt', F='A,F,F,F,F', name, sauron_lambda, sauron_half_lambda, sauron_ellipticity, sauron_half_ellipticity, /SILENT
oplot, sauron_m_dyn, sauron_half_lambda, PSYM=5, symsize = 1.2, thick=2

;LEGEND
plots, 11.95, 0.94, PSYM=5, symsize = 1.2, thick=2
xyouts, 12, 0.925, 'SAURON', charthick=2
plots, 11.95, 0.89, PSYM=8, COLOR = 180, symsize = 1.2
xyouts, 12, 0.875, 'BCG', charthick=2
plots, 11.95, 0.84, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
xyouts, 12, 0.825, 'Companion', charthick=2
plots, [11.85,12.5],[0.8,0.8], thick=5
plots, [11.85,11.85],[0.8,1.0], thick=5
device,/close

;file_move,'lambda_v_mass.eps','Downloads/lambda_v_mass.eps', /OVERWRITE

end