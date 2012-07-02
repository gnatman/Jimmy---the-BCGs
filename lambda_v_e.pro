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



lambda_files = file_search('$HOME/Astro/reduced/*/{comp,main}/sn10/lambda_re.txt',COUNT=nfiles)

r_e = fltarr(n_elements(lambda_files))
lambda = strarr(n_elements(lambda_files))
epsilon = fltarr(n_elements(lambda_files))
name = strarr(n_elements(lambda_files))
r_e_comp = fltarr(n_elements(lambda_files))
lambda_comp = strarr(n_elements(lambda_files))
epsilon_comp = fltarr(n_elements(lambda_files))
name_comp = strarr(n_elements(lambda_files))
for i=0, n_elements(lambda_files)-1 do begin
	readcol, lambda_files[i], F='F,F,F,F', dummy1, tempr_e, tempepsilon, templambda, /silent
	if (strmid(lambda_files[i], 35, 4) eq 'main') then begin
		r_e[i] = tempr_e[0]
		lambda[i] = templambda
		epsilon[i] = tempepsilon
		name[i] = strmid(lambda_files[i], 27, 4)+strmid(lambda_files[i], 35, 4)
	endif else begin
		r_e_comp[i] = tempr_e[0]
		lambda_comp[i] = templambda
		epsilon_comp[i] = tempepsilon
		name_comp[i] = strmid(lambda_files[i], 27, 4)+strmid(lambda_files[i], 35, 4)
	endelse
endfor


usersym, [ -1, 1, 1, -1, -1 ], [ 1, 1, -1, -1, 1 ], /fill

plot, epsilon, lambda, PSYM=4, yrange=[0,1.0], xrange = [0,1.0], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, XTITLE='!4e!3!De', YTITLE='!4k!D!3R!Le'
oplot, epsilon, lambda, PSYM=8, COLOR = 180, symsize = 1.2
oplot, epsilon_comp, lambda_comp, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
xyouts, epsilon, lambda, name, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180
xyouts, epsilon_comp, lambda_comp, name_comp, CHARSIZE = 1, CHARTHICK = 1, COLOR = 180

;Read in and plot the SAURON values
readcol,'$HOME/Astro/Supporting\ Documents/SAURON_Data_Fig5_LR_Ell.txt', F='A,F,F,F,A', sauron_name, sauron_lambda, sauron_lambda_half, sauron_epsilon, sauron_epsilon_half, /SILENT
;USERSYM, [0,1,0,-1],[-1,0,1,0],/FILL
oplot, sauron_epsilon, sauron_lambda, PSYM=5, symsize=1.2, thick=2

;Read in and plot the ATLAS3D values
readcol,'$HOME/Astro/Supporting\ Documents/Emsellem2011_Atlas3D_Paper3_TableB1.txt', F='A,F,F,F,A,F,F,F,F,A,A', atlas3d_name, atlas3d_rmax, atlas3d_epsilon, atlas3d_epsilon_half, atlas3d_band, atlas3d_v_disp, atlas3d_v_disp_half, atlas3d_lambda, atlas3d_lambda_half, atlas3d_fast_slow, atlas3d_fast_slow_half, /SILENT
oplot, atlas3d_epsilon, atlas3d_lambda, PSYM=7, symsize=1.2, thick=2


device,/close

;file_move,'lambda_v_mass.eps','Downloads/lambda_v_mass.eps', /OVERWRITE

end