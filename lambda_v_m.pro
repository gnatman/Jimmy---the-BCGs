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

loadct, 4
;sauron_colormap
set_plot, 'ps'
device, filename='lambda_v_mass.eps', /encapsul, /color, BITS=8 ;, SET_CHARACTER_SIZE=[270,190]

label = [ 'BCG 1050', 'BCG 1027', 'BCG 1066', 'BCG 2086', 'BCG 2001', 'BCG 1153' ] 
;lambda = [ 0.124, 0.150, 0.164, 0.144, 0.179, 0.240 ]
m_dyn = [ 12.08, 11.85, 11.88, 11.82, 11.25, 11.87 ]
label_comp = [ 'Comp 1027', 'Comp 1066', 'Comp 2086' ] 
lambda_comp = [ 0.272, 0.483, 0.11 ]
m_dyn_comp = [ 11.6, 11.6, 11.06 ]
sarah_lambda = [ 0.113958, 0.112633, 0.346064, 0.256023, 0.715347, 0.103441 ]
sarah_m_dyn = [ 12.2, 11.8, 11.57, 11.84, 11.85, 11.78, 11.15 ]


lambda_files = file_search('/Users/jimmy/Astro/reduced/*/{comp,main}/lambda_re.txt',COUNT=nfiles)
table_files = file_search('/Users/jimmy/Astro/reduced/*/{comp,main}/table_one.txt',COUNT=nfiles)
print,'lambda_files',lambda_files
print,'table_files',table_files
lambda = fltarr(n_elements(lambda_files))
epsillon = fltarr(n_elements(lambda_files))
for i=0, n_elements(files)-1 do begin
	readcol, lambda_files[i], F='F,F,F', dummy1, tempepsillon, templambda;, /silent
	readcol, table_files[i], F='A,A,F,A,F', dummy1, dummy2, values, dummy3, errors
	dispersion[i] = values[1]
	print,'dispersion[i]',dispersion[i]
	lambda[i] = templambda
	epsillon[i] = tempepsillon
endfor

;print,lambda
;print,epsillon




;Window,1,XSIZE=1200,YSIZE=700

usersym, [ -1, 1, 1, -1, -1 ], [ 1, 1, -1, -1, 1 ], /fill

plot, m_dyn, lambda, PSYM=4, yrange=[0,0.8], xrange = [9.8,12.5], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5 ; XTITLE='!3Log (M!Ddyn!N[M!D!9n!X!N])', YTITLE='!4k!D!3R!Le',
oplot, m_dyn, lambda, PSYM=8, COLOR = 180, symsize = 1.2
oplot, m_dyn_comp, lambda_comp, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
m_dyn[0] = m_dyn[0]+0.05
m_dyn[1] = m_dyn[1]+0.05
m_dyn[2] = m_dyn[2]+0.05
m_dyn[3] = m_dyn[3]-0.7
m_dyn[4] = m_dyn[4]-0.25
m_dyn[5] = m_dyn[5]+0.05
lambda[0] = lambda[0]-0.01
lambda[1] = lambda[1]-0
lambda[2] = lambda[2]+0.02
lambda[3] = lambda[3]-0.025
lambda[4] = lambda[4]+0.02
lambda[5] = lambda[5]
;xyouts, m_dyn, lambda, label, CHARSIZE = 1.2, CHARTHICK = 4, COLOR = 180

;oplot, sarah_m_dyn, sarah_lambda, PSYM=6, color=100
;xyouts, sarah_m_dyn+0.02, sarah_lambda-0.005, label, color=100, CHARSIZE = 1

readcol,'/Users/jimmy/Astro/Supporting\ Documents/SAURON_Data_Fig7_LR_MB_Mvir_core.txt', F='A,F,F,F,A', dummy1, sauron_lambda, dummy2, sauron_m_dyn, dummy3, /SILENT

USERSYM, [0,1,0,-1],[-1,0,1,0],/FILL


oplot, sauron_m_dyn, sauron_lambda, PSYM=5, symsize = 1.2, thick=2

device,/close

file_move,'lambda_v_mass.eps','Downloads/lambda_v_mass.eps', /OVERWRITE

end