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
pro paper_table
COMPILE_OPT idl2, HIDDEN

lambda_files = file_search('$HOME/Astro/reduced/*/{comp,main}/sn10/lambda_re.txt',COUNT=nfiles)
table_files = strarr(n_elements(lambda_files))
temp_string = strsplit(lambda_files, '/', /extract)
for i=0, n_elements(temp_string)-1 do begin
	table_files[i] = '/'+temp_string[i,0]+'/'+temp_string[i,1]+'/'+temp_string[i,2]+'/'+temp_string[i,3]+'/'+temp_string[i,4]+'/'+temp_string[i,5]+'/'+temp_string[i,6]+'/'+'table_one.txt'
endfor
print, table_files

r_e = fltarr(n_elements(lambda_files))
half_r_e = fltarr(n_elements(lambda_files))
velocity = fltarr(n_elements(lambda_files))
vel_error = fltarr(n_elements(lambda_files))
dispersion = fltarr(n_elements(lambda_files))
disp_error = fltarr(n_elements(lambda_files))
redshift = fltarr(n_elements(lambda_files))
lambda = fltarr(n_elements(lambda_files))
half_lambda = fltarr(n_elements(lambda_files))
epsilon = fltarr(n_elements(lambda_files))
half_epsilon = fltarr(n_elements(lambda_files))
name = strarr(n_elements(lambda_files))
for i=0, n_elements(lambda_files)-1 do begin
	readcol, lambda_files[i], F='F,F,F,F', radius, tempr_e, tempepsilon, templambda, /silent
	readcol, table_files[i], F='A,A,A,A,F,F', dummy1, dummy2, dummy3, dummy4, values, dummy5, /silent
	;readcol, table_files[i], F='A,A,A,A,F,F,F', dummy1, dummy2, dummy3, velocity[i], vel_error[i], dispersion[i], disp_error[i], /silent
	readcol, table_files[i], F='A,A,A,A,F,F,F', dum1, dum2, dum3, dum4, dum5, dum6, dum7, /silent
	print, dum1, dum2, dum3, dum4, dum5, dum6, dum7
	;print, 'values: ', dummy1, dummy2, dummy3, velocity[i], vel_error[i], dispersion[i], disp_error[i]
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
	velocity[i] = dum4
	vel_error[i] = dum5
	dispersion[i] = dum6
	disp_error[i] = dum7
	redshift[i] = values[0]
	radius_rad = r_e*4.84813681E-6
	distance = redshift*1.302773E26
	radius_m = distance*tan(radius_rad)
	mass = (5*radius_m*((dispersion*1000)^2))/(1.98892E30*6.673E-11)
	log_mass = alog10(mass)
	m_dyn = log_mass
	mass_error = (disp_error*2000)/(dispersion*1000*alog(10))
	lambda_error = 0
	if (temp_string[i,5] eq 'comp') then begin
		name[i] = strmid(temp_string[i,4], 0, 4)+' Comp' ;causes a bunch of divide by 0 and illegal operand errors
	endif
	if (temp_string[i,5] eq 'main') then begin
		name[i] = strmid(temp_string[i,4], 0, 4)+' BCG' ;causes a bunch of divide by 0 and illegal operand errors
	endif
endfor

for i=0, n_elements(name)-1 do begin
	if (redshift[i] ne 0) then begin
		;print,name[i],' & ',r_e[i],' & ',redshift[i],' & ',dispersion[i],' $\pm$',disp_error[i],' & ',m_dyn[i],' $\pm$',mass_error[i],' & ',epsilon[i],' & ',lambda[i], ' $\pm$', lambda_error, ' \\', FORMAT = '(A,A,F6.2,A,F6.4,A,I3,A,I3,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A)'
		print,name[i],' & ',r_e[i],' & ',redshift[i],' & ',dispersion[i],' $\pm$',disp_error[i],' & ',m_dyn[i],' & ',epsilon[i],' & ',lambda[i], ' $\pm$', lambda_error, ' \\', FORMAT = '(A,A,F6.2,A,F6.4,A,I3,A,I3,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A)'

	endif
endfor

end