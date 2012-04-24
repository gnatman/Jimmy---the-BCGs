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
;   JIMMY_LAMBDA_V_R
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

pro jimmy_lambda_v_r

loadct, 4
set_plot, 'ps'
device, filename='lambda_v_rad.eps', /encapsul, /color, BITS=8

readcol, '/Users/jimmy/Astro/reduced/1027pro/main/lambda.txt', F='F,F', r1027, e1027, l1027, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1027pro/comp/lambda.txt', F='F,F', r1027_comp, e1027comp, l1027_comp, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1042pro/main/lambda.txt', F='F,F', r1042, e1042, l1042, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1048pro/main/lambda.txt', F='F,F', r1048, e1048, l1048, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1050pro/main/lambda.txt', F='F,F', r1050, e1050, l1050, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1066pro/main/lambda.txt', F='F,F', r1066, e1066, l1066, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1066pro/comp/lambda.txt', F='F,F', r1066_comp, e1066_comp, l1066_comp, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1067pro/main/lambda.txt', F='F,F', r1067, e1067, l1067, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1153pro/main/lambda.txt', F='F,F', r1153, e1153, l1153, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/1261pro/main/lambda.txt', F='F,F', r1261, e1261, l1261, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/2001pro/main/lambda.txt', F='F,F', r2001, e2001, l2001, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/2039pro/main/lambda.txt', F='F,F', r2039, e2039, l2039, /SILENT, SKIPLINE=1
readcol, '/Users/jimmy/Astro/reduced/2086pro/main/lambda.txt', F='F,F', r2086, e2086, l2086, /SILENT, SKIPLINE=1 


;readcol, '/Users/jimmy/Astro/Supporting Documents/fake_sauron_slow', F='F,F', r_sauron_slow, l_sauron_slow, /SILENT
;readcol, '/Users/jimmy/Astro/Supporting Documents/fake_sauron_fast', F='F,F', r_sauron_fast, l_sauron_fast, /SILENT
;readcol, '/Users/jimmy/Astro/Supporting Documents/fake_slow', F='F,F', r_slow, l_slow, /SILENT
;readcol, '/Users/jimmy/Astro/Supporting Documents/fake_fast', F='F,F', r_fast, l_fast, /SILENT




plot, [0,0], [0,0], yrange=[0,1], xrange = [0,2], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5 ;xtitle='!3R/R!De', ytitle='!4k!D!3R', 
oplot, r1027, l1027, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r1027_comp, l1027_comp, THICK = 8, COLOR = 180, LINESTYLE = 0 
oplot, r1042, l1042, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r1048, l1048, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r1050, l1050, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r1066, l1066, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r1066_comp, l1066_comp, THICK = 8, COLOR = 180, LINESTYLE = 0
oplot, r1067, l1067, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r1153, l1153, THICK = 8, COLOR = 180, LINESTYLE = 0
oplot, r1261, l1261, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r2001, l2001, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r2039, l2039, THICK = 8, COLOR = 180, LINESTYLE = 2
oplot, r2086, l2086, THICK = 8, COLOR = 180, LINESTYLE = 2
;oplot, r_fast, l_fast, THICK = 8, COLOR = 180, LINESTYLE = 0
;oplot, r_slow, l_slow, THICK = 8, COLOR = 180, LINESTYLE = 2
;oplot, r_sauron_slow, l_sauron_slow, COLOR = 1, LINESTYLE = 2
;oplot, r_sauron_fast, l_sauron_fast, COLOR = 1

sauron = file_search('/Users/jimmy/Astro/Supporting Documents/sauron_lambda_profiles/*',COUNT=nfiles)
print,'nfiles',nfiles
rsauron = findgen(50)
lsauron = findgen(50)
for j=0,nfiles-1 do begin
		;print, sauron[j]
        readcol, sauron[j], F='F,F', rsauron, lsauron, /SILENT
        ;oplot, rsauron, lsauron, COLOR = 1
endfor
sauron = file_search('/Users/jimmy/Astro/Supporting Documents/sauron_lambda_profiles_slow/*',COUNT=nfiles)
print,'nfiles',nfiles
rsauron = findgen(50)
lsauron = findgen(50)
for j=0,nfiles-1 do begin
		;print, sauron[j]
        readcol, sauron[j], F='F,F', rsauron, lsauron, /SILENT
        ;oplot, rsauron, lsauron, COLOR = 1, LINESTYLE = 2
endfor

x_label = [r1027[max(r1027)]+0.03,r1050[max(r1050)]+0.13,r1066[max(r1066)],r1153[max(r1153)]-0.35,r2001[max(r2001)]-0.05,r2086[max(r2086)],r1027_comp[max(r1027_comp)]-0.18,r1066_comp[max(r1066_comp)]]
y_label = [l1027[max(l1027)],l1050[max(l1050)]-0.02,l1066[max(l1066)]-0.02,l1153[max(l1153)]-0.015,l2001[max(l2001)]+0.015,l2086[max(l2086)],l1027_comp[max(l1027_comp)],l1066_comp[max(l1066_comp)]]
label = ['1027','1050','1066','1153','2001','2086','1027 Comp','1066 Comp']

xyouts, x_label, y_label, label, CHARSIZE = 1.2, CHARTHICK = 5, COLOR = 180

device,/close

file_move,'lambda_v_rad.eps','Downloads/lambda_v_rad.eps', /OVERWRITE


end