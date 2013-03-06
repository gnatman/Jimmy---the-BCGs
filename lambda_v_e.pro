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
;   LAMBDA_V_E
;
; PURPOSE:
;   This code creates a plot of lambda_R_e vs ellipticity, used for making posters.
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
pro lambda_v_e
COMPILE_OPT idl2, HIDDEN

loadct, 4, /SILENT

set_plot, 'ps'
device, filename='lambda_v_e.eps', /encapsul, /color, BITS=8 ;, SET_CHARACTER_SIZE=[270,190]



lambda_files_main = file_search('$HOME/Astro/reduced/*/main/sn10/lambda_re.txt',COUNT=nfiles)
lambda_files_comp = file_search('$HOME/Astro/reduced/*/comp/sn10/lambda_re.txt',COUNT=nfiles)

r_e = fltarr(n_elements(lambda_files_main))
lambda = strarr(n_elements(lambda_files_main))
lambda_error = strarr(n_elements(lambda_files_main))
epsilon = fltarr(n_elements(lambda_files_main))
name = strarr(n_elements(lambda_files_main))
r_e_comp = fltarr(n_elements(lambda_files_comp))
lambda_comp = strarr(n_elements(lambda_files_comp))
lambda_comp_error = strarr(n_elements(lambda_files_comp))
epsilon_comp = fltarr(n_elements(lambda_files_comp))
name_comp = strarr(n_elements(lambda_files_comp))
half_r_e = fltarr(n_elements(lambda_files_main))
half_lambda = strarr(n_elements(lambda_files_main))
half_lambda_error = strarr(n_elements(lambda_files_main))
half_epsilon = fltarr(n_elements(lambda_files_main))
half_r_e_comp = fltarr(n_elements(lambda_files_comp))
half_lambda_comp = strarr(n_elements(lambda_files_comp))
half_lambda_comp_error = strarr(n_elements(lambda_files_comp))
half_epsilon_comp = fltarr(n_elements(lambda_files_comp))

for i=0, n_elements(lambda_files_main)-1 do begin
	readcol, lambda_files_main[i], F='F,F,F,F,F', radius, tempr_e, tempepsilon, templambda, templambdaerror, /silent
		if (n_elements(tempr_e) eq 3) then begin
			r_e[i] = tempr_e[1]
			lambda[i] = templambda[1]
			lambda_error[i] = templambdaerror[1]
			epsilon[i] = tempepsilon[1]
			half_r_e[i] = tempr_e[0]
			half_lambda[i] = templambda[0]
			half_lambda_error[i] = templambdaerror[0]
			half_epsilon[i] = tempepsilon[0]
		endif else if (n_elements(tempr_e) eq 2) then begin
			r_e[i] = tempr_e[1]
			lambda[i] = templambda[1]
			lambda_error[i] = templambdaerror[1]
			epsilon[i] = tempepsilon[1]
			half_r_e[i] = tempr_e[0]
			half_lambda[i] = templambda[0]
			half_lambda_error[i] = templambdaerror[0]
			half_epsilon[i] = tempepsilon[0]
		endif else begin
			r_e[i] = tempr_e[0]
			lambda[i] = templambda[0]
			lambda_error[i] = templambdaerror[0]
			epsilon[i] = tempepsilon[0]
			half_r_e[i] = tempr_e[0]
			half_lambda[i] = templambda[0]
			half_lambda_error[i] = templambdaerror[0]
			half_epsilon[i] = tempepsilon[0]
		endelse
		name[i] = strmid(lambda_files_main[i], 27, 4)+strmid(lambda_files_main[i], 35, 4)
endfor
for i=0, n_elements(lambda_files_comp)-1 do begin
	readcol, lambda_files_comp[i], F='F,F,F,F,F', radius, tempr_e, tempepsilon, templambda, templambdaerror, /silent
		if (n_elements(tempr_e) eq 3) then begin
			r_e_comp[i] = tempr_e[1]
			lambda_comp[i] = templambda[1]
			lambda_comp_error[i] = templambdaerror[1]
			epsilon_comp[i] = tempepsilon[1]
			half_r_e_comp[i] = tempr_e[0]
			half_lambda_comp[i] = templambda[0]
			half_lambda_comp_error[i] = templambdaerror[0]
			half_epsilon_comp[i] = tempepsilon[0]
		endif else if (n_elements(tempr_e) eq 2) then begin
			r_e_comp[i] = tempr_e[1]
			lambda_comp[i] = templambda[1]
			lambda_comp_error[i] = templambdaerror[1]
			epsilon_comp[i] = tempepsilon[1]
			half_r_e_comp[i] = tempr_e[0]
			half_lambda_comp[i] = templambda[0]
			half_lambda_comp_error[i] = templambdaerror[0]
			half_epsilon_comp[i] = tempepsilon[0]
		endif else begin
			r_e_comp[i] = tempr_e[0]
			lambda_comp[i] = templambda[0]
			lambda_comp_error[i] = templambdaerror[0]
			epsilon_comp[i] = tempepsilon[0]
			half_r_e_comp[i] = tempr_e[0]
			half_lambda_comp[i] = templambda[0]
			half_lambda_comp_error[i] = templambdaerror[0]
			half_epsilon_comp[i] = tempepsilon[0]
		endelse
		name_comp[i] = strmid(lambda_files_comp[i], 27, 4)+strmid(lambda_files_comp[i], 35, 4)
endfor

print,'lambda before: ',lambda

;epsilon = epsilon[where(epsilon ne 0)]
;lambda = lambda[where(epsilon ne 0)]
;half_lambda = half_lambda[where(half_lambda ne 0)]
;name = name[where(name ne '')]
;epsilon_comp = epsilon_comp[where(epsilon_comp ne 0)]
;lambda_comp = lambda_comp[where(epsilon_comp ne 0)]
;half_lambda_comp = half_lambda_comp[where(epsilon_comp ne 0)]
;name_comp = name_comp[where(name_comp ne '')]
;print, epsilon, lambda, epsilon_comp, lambda_comp

print,'lambda after: ',lambda
print,'size of epsilon: ', n_elements(epsilon), ' size of lambda: ',n_elements(lambda)

usersym, [ -1, 1, 1, -1, -1 ], [ 1, 1, -1, -1, 1 ], /fill

epsilon_error = fltarr(n_elements(epsilon))

plot, epsilon, lambda, PSYM=4, yrange=[0,1.0], xrange = [0,1.0], CHARSIZE = 1.75, CHARTHICK = 5, ythick = 4, xthick = 4, XTITLE='!4e!3!De', YTITLE='!4k!D!3R!Le'
oploterror, epsilon, lambda, lambda_error+0.000000001, PSYM=8, COLOR = 180, symsize = 1.2, errthick  = 2, errcolor = 180
oploterror, epsilon_comp, lambda_comp, lambda_comp_error+0.000000001, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10, errthick  = 2, errcolor = 180
;xyouts, epsilon, lambda, name, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
;xyouts, epsilon_comp, lambda_comp, name_comp, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180

;Read in and plot the SAURON values
readcol,'$HOME/Astro/Supporting\ Documents/SAURON_Data_Fig5_LR_Ell.txt', F='A,F,F,F,A', sauron_name, sauron_lambda, sauron_lambda_half, sauron_epsilon, sauron_epsilon_half, /SILENT
;USERSYM, [0,1,0,-1],[-1,0,1,0],/FILL
oplot, sauron_epsilon, sauron_lambda, PSYM=5, symsize=1.2, thick=2

;Read in and plot the ATLAS3D values
readcol,'$HOME/Astro/Supporting\ Documents/Emsellem2011_Atlas3D_Paper3_TableB1.txt', F='A,F,F,F,A,F,F,F,F,A,A', atlas3d_name, atlas3d_rmax, atlas3d_epsilon, atlas3d_epsilon_half, atlas3d_band, atlas3d_v_disp, atlas3d_v_disp_half, atlas3d_lambda, atlas3d_lambda_half, atlas3d_fast_slow, atlas3d_fast_slow_half, /SILENT
oplot, atlas3d_epsilon, atlas3d_lambda, PSYM=7, symsize=1.2, thick=2

;LEGEND
plots, 0.775, 0.94, PSYM=5, symsize = 1.2, thick=2
xyouts, 0.8, 0.93, 'SAURON', charthick=2
plots, 0.775, 0.89, PSYM=7, symsize = 1.2
xyouts, 0.8, 0.870, 'ATLAS!A3D!X', charthick=2
plots, 0.775, 0.84, PSYM=8, COLOR = 180, symsize = 1.2, thick = 10
xyouts, 0.8, 0.825, 'BCG', charthick=2
plots, 0.775, 0.79, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
xyouts, 0.8, 0.775, 'Companion', charthick=2
plots, [0.75,1],[0.76,0.76], thick=5
plots, [0.75,0.75],[0.76,1.0], thick=5

oplot, findgen(101)/100, 0.31*sqrt((findgen(101)/100)), thick = 5, color = 90



device,/close

set_plot, 'ps'
device, filename='half_lambda_v_e.eps', /encapsul, /color, BITS=8 ;, SET_CHARACTER_SIZE=[270,190]

plot, half_epsilon, half_lambda, PSYM=4, yrange=[0,1.0], xrange = [0,1.0], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, XTITLE='!4e!3!De!N!D/2', YTITLE='!4k!D!3R!Le!N!D/2'
oploterror, half_epsilon, half_lambda, half_lambda_error+0.000000001, PSYM=8, COLOR = 180, symsize = 1.2, errthick  = 2, errcolor = 180
oploterror, half_epsilon_comp, half_lambda_comp, half_lambda_comp_error+0.000000001, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10, errthick  = 2, errcolor = 180
;xyouts, half_epsilon, half_lambda, name, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
;xyouts, half_epsilon_comp, half_lambda_comp, name_comp, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180

;Read in and plot the SAURON values
readcol,'$HOME/Astro/Supporting\ Documents/SAURON_Data_Fig5_LR_Ell.txt', F='A,F,F,F,A', sauron_name, sauron_lambda, sauron_lambda_half, sauron_epsilon, sauron_epsilon_half, /SILENT
;USERSYM, [0,1,0,-1],[-1,0,1,0],/FILL
oplot, sauron_epsilon_half, sauron_lambda_half, PSYM=5, symsize=1.2, thick=2

;Read in and plot the ATLAS3D values
readcol,'$HOME/Astro/Supporting\ Documents/Emsellem2011_Atlas3D_Paper3_TableB1.txt', F='A,F,F,F,A,F,F,F,F,A,A', atlas3d_name, atlas3d_rmax, atlas3d_epsilon, atlas3d_epsilon_half, atlas3d_band, atlas3d_v_disp, atlas3d_v_disp_half, atlas3d_lambda, atlas3d_lambda_half, atlas3d_fast_slow, atlas3d_fast_slow_half, /SILENT
oplot, atlas3d_epsilon_half, atlas3d_lambda_half, PSYM=7, symsize=1.2, thick=2

;LEGEND
plots, 0.775, 0.94, PSYM=5, symsize = 1.2, thick=2
xyouts, 0.8, 0.925, 'SAURON', charthick=2
plots, 0.775, 0.89, PSYM=7, symsize = 1.2
xyouts, 0.8, 0.875, 'ATLAS!A3D!X', charthick=2
plots, 0.775, 0.84, PSYM=8, COLOR = 180, symsize = 1.2, thick = 10
xyouts, 0.8, 0.825, 'BCG', charthick=2
plots, 0.775, 0.79, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
xyouts, 0.8, 0.775, 'Companion', charthick=2
plots, [0.75,1],[0.76,0.76], thick=5
plots, [0.75,0.75],[0.76,1.0], thick=5

oplot, findgen(101)/100, 0.31*sqrt((findgen(101)/100)), thick = 5, color = 90

device,/close

;file_move,'lambda_v_mass.eps','Downloads/lambda_v_mass.eps', /OVERWRITE

end