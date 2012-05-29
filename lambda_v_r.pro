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

lambda_files = file_search('/Users/jimmy/Astro/reduced/*/{comp,main}/lambda.txt',COUNT=nfiles)
lambda_re_files = file_search('/Users/jimmy/Astro/reduced/*/{comp,main}/lambda_re.txt',COUNT=nfiles)
lambda = fltarr(n_elements(lambda_files))
epsillon = fltarr(n_elements(lambda_files))
dispersion = fltarr(n_elements(lambda_files))
r_e = fltarr(n_elements(lambda_files))
redshift = fltarr(n_elements(lambda_files))
tempradius = fltarr(n_elements(lambda_files))
templambda = fltarr(n_elements(lambda_files))
tempradius2 = fltarr(n_elements(lambda_files),7)
templambda2 = fltarr(n_elements(lambda_files),7)
tempepsillon2 = fltarr(n_elements(lambda_files),7)
epsillon_re = fltarr(n_elements(lambda_files))
lambda_re = fltarr(n_elements(lambda_files))
linestyle = fltarr(n_elements(lambda_files))
for i=0, n_elements(lambda_files)-1 do begin
	print,'Reading in: ',lambda_files[i]
	readcol, lambda_files[i], F='F,F,F,F', tempradius, tempr_e, tempepsillon, templambda, /silent, SKIPLINE=1
	readcol, lambda_re_files[i], F='F,F,F,F', dummy1, dummy2, tempepsillon_re, templambda_re, /silent, SKIPLINE=1
	tempradius2[i,*] = tempradius[*]
	r_e[i] = tempr_e[0]
	tempepsillon2[i,*] = tempepsillon[*]
	templambda2[i,*] = templambda[*]
	epsillon_re[i] = tempepsillon_re
	lambda_re[i] = templambda_re
	if (lambda_re[i] lt (0.31*sqrt(epsillon_re[i]))) then begin
		linestyle[i] = 2
		print,'lambda_re[i]: ',lambda_re[i],' (0.31*sqrt(epsillon_re[i])): ',(0.31*sqrt(epsillon_re[i]))
		print,'epsillon_re[i]: ',epsillon_re[i]
		print,'sqrt(epsillon_re[i]): ',sqrt(epsillon_re[i])
		;print,'slow rotator'
	endif else begin
		linestyle[i] = 0
		print,'lambda_re[i]: ',lambda_re[i],' (0.31*sqrt(epsillon_re[i])): ',(0.31*sqrt(epsillon_re[i]))
		print,'epsillon_re[i]: ',epsillon_re[i]
		print,'sqrt(epsillon_re[i]): ',sqrt(epsillon_re[i])
		;print,'fast rotator'
	endelse
endfor

plot, [0,0], [0,0], yrange=[0,1], xrange = [0,1.5], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, xtitle='!3R/R!De', ytitle='!4k!D!3R'
for i=0, n_elements(lambda_files)-1 do begin
	oplot, tempradius2[i,*]/r_e[i], templambda2[i,*], THICK = 8, COLOR = 180, LINESTYLE = linestyle[i]
	xyouts, max(tempradius2[i,*]/r_e[i]), max(templambda2[i,*]), strmid(lambda_files[i], 27, 4)+strmid(lambda_files[i], 35, 4), CHARSIZE = 0.5, CHARTHICK = 2, COLOR = 180
	;print, max(tempradius2[i,*]/r_e[i]), max(templambda2[i,*])
	;print,tempradius2[i,*]/r_e[i], templambda2[i,*]
endfor



;readcol, '/Users/jimmy/Astro/Supporting Documents/fake_sauron_slow', F='F,F', r_sauron_slow, l_sauron_slow, /SILENT
;readcol, '/Users/jimmy/Astro/Supporting Documents/fake_sauron_fast', F='F,F', r_sauron_fast, l_sauron_fast, /SILENT
;readcol, '/Users/jimmy/Astro/Supporting Documents/fake_slow', F='F,F', r_slow, l_slow, /SILENT
;readcol, '/Users/jimmy/Astro/Supporting Documents/fake_fast', F='F,F', r_fast, l_fast, /SILENT
;oplot, r_fast, l_fast, THICK = 8, COLOR = 180, LINESTYLE = 0
;oplot, r_slow, l_slow, THICK = 8, COLOR = 180, LINESTYLE = 2
;oplot, r_sauron_slow, l_sauron_slow, COLOR = 1, LINESTYLE = 2
;oplot, r_sauron_fast, l_sauron_fast, COLOR = 1

sauron = file_search('/Users/jimmy/Astro/Supporting Documents/sauron_lambda_profiles/*',COUNT=nfiles)
rsauron = findgen(50)
lsauron = findgen(50)
for j=0,nfiles-1 do begin
		;print, sauron[j]
        readcol, sauron[j], F='F,F', rsauron, lsauron, /SILENT
        ;oplot, rsauron, lsauron, COLOR = 1
endfor
sauron = file_search('/Users/jimmy/Astro/Supporting Documents/sauron_lambda_profiles_slow/*',COUNT=nfiles)
rsauron = findgen(50)
lsauron = findgen(50)
for j=0,nfiles-1 do begin
		;print, sauron[j]
        readcol, sauron[j], F='F,F', rsauron, lsauron, /SILENT
        ;oplot, rsauron, lsauron, COLOR = 1, LINESTYLE = 2
endfor


device,/close

set_plot, 'ps'
device, filename='lambda_v_rad_prop.eps', /encapsul, /color, BITS=8
plot, [0,0], [0,0], yrange=[0,0.2], xrange = [0,1], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5, xtitle='!3R/R!De', ytitle='!4k!D!3R'
i=13
oplot, tempradius2[i,*]/r_e[i], templambda2[i,*], THICK = 8, COLOR = 180, LINESTYLE = linestyle[i]
xyouts, max(tempradius2[i,*]/r_e[i])+0.01, max(templambda2[i,*]), '2039', CHARSIZE = 1, CHARTHICK = 5, COLOR = 180
i=15
oplot, tempradius2[i,*]/r_e[i], templambda2[i,*], THICK = 8, COLOR = 180, LINESTYLE = linestyle[i]
xyouts, max(tempradius2[i,*]/r_e[i]), max(templambda2[i,*])+0.01, '2086', CHARSIZE = 1, CHARTHICK = 5, COLOR = 180

device,/close

;file_move,'lambda_v_rad.eps','Downloads/lambda_v_rad.eps', /OVERWRITE


end