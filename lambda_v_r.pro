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
;   LAMBDA_V_R
;
; PURPOSE:
;   This code creates a plot of radial profile of lambda_r, used for making posters.
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

pro lambda_v_r

COMPILE_OPT idl2, HIDDEN

loadct, 4, /SILENT
set_plot, 'ps'
device, filename='lambda_v_rad.eps', /encapsul, /color, BITS=8

lambda_files = file_search('/Users/jimmy/Astro/reduced/*/{comp,main}/sn10/lambda.txt',COUNT=nfiles)
lambda_re_files = strarr(n_elements(lambda_files))
temp_string = strsplit(lambda_files, '/', /extract)
for i=0, n_elements(temp_string)-1 do begin
	lambda_re_files[i] = '/'+temp_string[i,0]+'/'+temp_string[i,1]+'/'+temp_string[i,2]+'/'+temp_string[i,3]+'/'+temp_string[i,4]+'/'+temp_string[i,5]+'/'+temp_string[i,6]+'/'+'lambda_re.txt'
endfor

lambda = fltarr(n_elements(lambda_files))
lambda_error = fltarr(n_elements(lambda_files))
half_lambda_re = fltarr(n_elements(lambda_files))
half_lambda_re_error = fltarr(n_elements(lambda_files))
epsilon = fltarr(n_elements(lambda_files))
half_epsilon_re = fltarr(n_elements(lambda_files))
dispersion = fltarr(n_elements(lambda_files))
r_e = fltarr(n_elements(lambda_files))
half_r_e = fltarr(n_elements(lambda_files))
redshift = fltarr(n_elements(lambda_files))
tempradius = fltarr(n_elements(lambda_files))
templambda = fltarr(n_elements(lambda_files))
templambdaerror = fltarr(n_elements(lambda_files))
tempradius2 = fltarr(n_elements(lambda_files),7)
templambda2 = fltarr(n_elements(lambda_files),7)
templambda2_error = fltarr(n_elements(lambda_files),7)
tempepsilon2 = fltarr(n_elements(lambda_files),7)
epsilon_re = fltarr(n_elements(lambda_files))
lambda_re = fltarr(n_elements(lambda_files))
lambda_re_error = fltarr(n_elements(lambda_files))
linestyle = fltarr(n_elements(lambda_files))
for i=0, n_elements(lambda_files)-1 do begin
	print,'Reading in: ',lambda_re_files[i]
	readcol, lambda_files[i], F='F,F,F,F,F', tempradius, tempr_e, tempepsilon, templambda, templambdaerror, SKIPLINE=1
	readcol, lambda_re_files[i], F='F,F,F,F,F', dummy1, dummy2, tempepsilon_re, templambda_re, templambda_re_error, SKIPLINE=1
	tempradius2[i,*] = tempradius[*]
	r_e[i] = tempr_e[0]
	tempepsilon2[i,*] = tempepsilon[*]
	templambda2[i,*] = templambda[*]
	templambda2_error[i,*] = templambdaerror[*]
	print,templambdaerror
	if (n_elements(templambda_re) eq 3) then begin
		r_e[i] = tempr_e[0]
		lambda_re[i] = templambda_re[1]
		lambda_re_error[i] = templambda_re_error[1]
		epsilon_re[i] = tempepsilon_re[1]
		half_r_e[i] = tempr_e[0]
		half_lambda_re[i] = templambda_re[0]
		half_lambda_re_error[i] = templambda_re_error[0]
		half_epsilon_re[i] = tempepsilon_re[0]
	endif else if (n_elements(templambda_re) eq 2) then begin
		r_e[i] = tempr_e[0]
		lambda_re[i] = templambda_re[1]
		lambda_re_error[i] = templambda_re_error[1]
		epsilon_re[i] = tempepsilon_re[1]
		half_r_e[i] = tempr_e[0]
		half_lambda_re[i] = templambda_re[0]
		half_lambda_re_error[i] = templambda_re_error[0]
		half_epsilon_re[i] = tempepsilon_re[0]
	endif else begin
		r_e[i] = tempr_e[0]
		lambda_re[i] = templambda_re[0]
		lambda_re_error[i] = templambda_re_error[0]
		epsilon_re[i] = tempepsilon_re[0]
		half_r_e[i] = tempr_e[0]
		half_lambda_re[i] = templambda_re[0]
		half_lambda_re_error[i] = templambda_re_error[0]
		half_epsilon_re[i] = tempepsilon_re[0]
	endelse
	if (n_elements(templambda_re) eq 3) then begin
		if (lambda_re[i] lt (0.31*sqrt(epsilon_re[i]))) then begin
			linestyle[i] = 2
			print,'slow rotator: ', lambda_files[i]
		endif else begin
			linestyle[i] = 0
			print,'fast rotator: ',lambda_files[i]
		endelse
	endif
	if (n_elements(templambda_re) lt 3) then begin
		if (lambda_re[i] lt (0.265*sqrt(half_epsilon_re[i]))) then begin
			linestyle[i] = 2
			print,'slow rotator: ', lambda_files[i]
		endif else begin
			linestyle[i] = 0
			print,'fast rotator: ',lambda_files[i]
		endelse
	endif
	
	print,'lambda_re[i]: ',lambda_re[i],' (0.31*sqrt(epsilon_re[i])): ',(0.31*sqrt(epsilon_re[i]))
	print,'epsilon_re[i]: ',epsilon_re[i]
	print,'sqrt(epsilon_re[i]): ',sqrt(epsilon_re[i])
endfor

plot, [0,0], [0,0], yrange=[0,1], xrange = [0,1.0], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, xtitle='!3R/R!De', ytitle='!4k!D!3R'
for i=0, n_elements(lambda_files)-1 do begin
	oplot, tempradius2[i,*]/r_e[i], templambda2[i,*], THICK = 8, COLOR = 180, LINESTYLE = linestyle[i]
	oploterror, tempradius2[i,*]/r_e[i], templambda2[i,*], templambda2_error[i,*]+0.000000001, THICK = 8, COLOR = 180, LINESTYLE = linestyle[i], errthick  = 2, errcolor = 180
	;xyouts, max(tempradius2[i,*]/r_e[i]), max(templambda2[i,*]), strmid(lambda_files[i], 27, 4)+strmid(lambda_files[i], 35, 4), CHARSIZE = 0.5, CHARTHICK = 2, COLOR = 180
endfor




sauron = file_search('$HOME/Astro/Supporting Documents/sauron_lambda_profiles/*',COUNT=nfiles)
rsauron = findgen(50)
lsauron = findgen(50)
for j=0,nfiles-1 do begin
		;print, sauron[j]
        readcol, sauron[j], F='F,F', rsauron, lsauron, /SILENT
        oplot, rsauron, lsauron, COLOR = 1
endfor
sauron = file_search('$HOME/Astro/Supporting Documents/sauron_lambda_profiles_slow/*',COUNT=nfiles)
rsauron = findgen(50)
lsauron = findgen(50)
for j=0,nfiles-1 do begin
		;print, sauron[j]
        readcol, sauron[j], F='F,F', rsauron, lsauron, /SILENT
        oplot, rsauron, lsauron, COLOR = 1, LINESTYLE = 2
endfor

;LEGEND
plots, [0.86,0.975], [0.935,0.935], COLOR = 1
xyouts, 0.665, 0.925, 'SAURON Fast', charthick=2
plots, [0.86,0.975], [0.885,0.885], COLOR = 1, LINESTYLE = 2
xyouts, 0.665, 0.875, 'SAURON Slow', charthick=2
plots, [0.86,0.975], [0.835,0.835], THICK = 8, COLOR = 180, LINESTYLE = 0
xyouts, 0.665, 0.825, 'Fast Rotator', charthick=2
plots, [0.86,0.975], [0.785,0.785], THICK = 8, COLOR = 180, LINESTYLE = 2
xyouts, 0.665, 0.775, 'Slow Rotator', charthick=2
plots, [0.65,1],[0.75,0.75], thick=5
plots, [0.65,0.65],[0.75,1.0], thick=5


device,/close

;plot lambda v r, without dividing by r_e
set_plot, 'ps'
device, filename='lambda_v_rad_raw.eps', /encapsul, /color, BITS=8

plot, [0,0], [0,0], yrange=[0,1], xrange = [0,6.0], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, xtitle='!3R (arcsec)', ytitle='!4k!D!3R'
for i=0, n_elements(lambda_files)-1 do begin
	oplot, tempradius2[i,*], templambda2[i,*], THICK = 8, COLOR = 180, LINESTYLE = linestyle[i]
	oploterror, tempradius2[i,*], templambda2[i,*], templambda2_error[i,*]+0.000000001, THICK = 8, COLOR = 180, LINESTYLE = linestyle[i], errthick  = 2, errcolor = 180
	;xyouts, max(tempradius2[i,*]), max(templambda2[i,*]), strmid(lambda_files[i], 27, 4)+strmid(lambda_files[i], 35, 4), CHARSIZE = 0.5, CHARTHICK = 2, COLOR = 180
endfor

device,/close


;set_plot, 'ps'
;device, filename='lambda_v_rad_prop.eps', /encapsul, /color, BITS=8
;plot, [0,0], [0,0], yrange=[0,0.5], xrange = [0,1.5], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, xtitle='!3R/R!De', ytitle='!4k!D!3R'
;i=13
;oplot, tempradius2[i,*]/r_e[i], templambda2[i,*], THICK = 8;, COLOR = 180, LINESTYLE = linestyle[i]
;xyouts, max(tempradius2[i,*]/r_e[i])+0.01, max(templambda2[i,*]), '2039', CHARSIZE = 1, CHARTHICK = 5;, COLOR = 180
;i=15
;oplot, tempradius2[i,*]/r_e[i], templambda2[i,*], THICK = 8;, COLOR = 180, LINESTYLE = linestyle[i]
;xyouts, max(tempradius2[i,*]/r_e[i]), max(templambda2[i,*])-0.01, '2086', CHARSIZE = 1, CHARTHICK = 5;, COLOR = 180
;
;sauron = file_search('$HOME/Astro/Supporting Documents/sauron_lambda_profiles/*',COUNT=nfiles)
;rsauron = findgen(50)
;lsauron = findgen(50)
;for j=0,nfiles-1 do begin
;		;print, sauron[j]
;       readcol, sauron[j], F='F,F', rsauron, lsauron, /SILENT
;       oplot, rsauron, lsauron, COLOR = 1, LINESTYLE = 2
;endfor
;sauron = file_search('$HOME/Astro/Supporting Documents/sauron_lambda_profiles_slow/*',COUNT=nfiles)
;rsauron = findgen(50)
;lsauron = findgen(50)
;for j=0,nfiles-1 do begin
;		;print, sauron[j]
;        readcol, sauron[j], F='F,F', rsauron, lsauron, /SILENT
;        oplot, rsauron, lsauron, COLOR = 1, LINESTYLE = 2
;endfor
;
;oplot, [1.0,1.5],[0.1,0.1]
;oplot, [1.0,1.0],[0,0.1]
;xyouts, 1.05, 0.07, 'SAURON', CHARTHICK=4
;xyouts, 1.05, 0.04, 'Erickson', CHARTHICK=4
;oplot, [1.25,1.4],[0.075,0.075], linestyle=2, THICK=3
;oplot, [1.25,1.4],[0.045,0.045], THICK=7
;
;device,/close

;file_move,'lambda_v_rad.eps','Downloads/lambda_v_rad.eps', /OVERWRITE


end