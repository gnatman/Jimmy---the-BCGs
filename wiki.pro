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
;   WIKI
;
; PURPOSE:
;   This code formats and automatically uploads our results to the wiki.
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
pro wiki, bcg, target
COMPILE_OPT idl2, HIDDEN

testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)

if (testing ne 1) then begin
	;read in the requisite files, and expected redshift from the environmental variables.
	dir='/Users/jimmy/Astro/reduced/'+bcg+'pro/'+target
	;dir=getenv('input')+bcg+'pro/'+target
endif

if (testing) then begin
	;read in the requisite files, and expected redshift from the environmental variables.
	dir=getenv('input')+bcg+'pro/'+target
	;dir='/Users/jimmy/Astro/reduced/'+bcg+'pro/'+target
endif


readcol, dir+'/sn10/lambda_re.txt', F='F,F,F,F', dummy1, r_e, epsilon, lambda, /silent
readcol, dir+'/sn10/table_one.txt', F='A,A,A,A,F,F', dummy1, dummy2, dummy3, dummy4, values, dummy5;, /silent
readcol, dir+'/sn10/table_one.txt', F='A,A,A,A', dummy6, dummy7, dummy8, dummy9, errors;, /silent

redshift10 = values[0]
dispersion10 = values[2]
dispersion_err10 = errors[1]
r_e10 = r_e
radius_rad10 = r_e10*4.84813681E-6
distance10 = redshift10*1.302773E26
radius_m10 = distance10*tan(radius_rad10)
mass10 = (5*radius_m10*((dispersion10*1000)^2))/(1.98892E30*6.673E-11)
log_mass10 = alog10(mass10)
m_dyn10 = log_mass10
mass_err10 = (dispersion_err10*2000)/(dispersion10*1000*alog(10))
lambda10 = lambda
lambda_err10 = 0
epsilon10 = epsilon

readcol, dir+'/sn5/lambda_re.txt', F='F,F,F,F', dummy1, r_e, epsilon, lambda, /silent
readcol, dir+'/sn5/table_one.txt', F='A,A,A,A,F,F', dummy1, dummy2, dummy3, dummy4, values, dummy5;, /silent
readcol, dir+'/sn5/table_one.txt', F='A,A,A,A', dummy6, dummy7, dummy8, dummy9, errors;, /silent

redshift5 = values[0]
dispersion5 = values[2]
dispersion_err5 = errors[1]
r_e5 = r_e
radius_rad5 = r_e5*4.84813681E-6
distance5 = redshift5*1.302773E26
radius_m5 = distance5*tan(radius_rad5)
mass5 = (5*radius_m5*((dispersion5*1000)^2))/(1.98892E30*6.673E-11)
log_mass5 = alog10(mass5)
m_dyn5 = log_mass5
mass_err5 = (dispersion_err5*2000)/(dispersion5*1000*alog(10))
lambda5 = lambda
lambda_err5 = 0
epsilon5 = epsilon

redshift_s = 10
dispersion_s = 10
dispersion_err_s = 10
r_e_s = 10
radius_rad_s = r_e_s*4.84813681E-6
distance_s = redshift_s*1.302773E26
radius_m_s = distance_s*tan(radius_rad_s)
mass_s = (5*radius_m_s*((dispersion_s*1000)^2))/(1.98892E30*6.673E-11)
log_mass_s = alog10(mass_s)
m_dyn_s = log_mass_s
mass_err_s = (dispersion_err_s*2000)/(dispersion_s*1000*alog(10))
lambda_s = 10
lambda_err_s = 10
epsilon_s = 10

redshift_sdss = 10
dispersion_sdss = 10
r_e_sdss = 10
radius_rad_sdss = r_e_sdss*4.84813681E-6
distance_sdss = redshift_sdss*1.302773E26
radius_m_sdss = distance_sdss*tan(radius_rad_sdss)
mass_sdss = (5*radius_m_sdss*((dispersion_sdss*1000)^2))/(1.98892E30*6.673E-11)
log_mass_sdss = alog10(mass_sdss)
m_dyn_sdss = log_mass_sdss
lambda_sdss = 10
epsilon_sdss = 10



;print,'Name: ',bcg+'_'+target,' Z: ',redshift,' Dispersion: ',dispersion,' +\- ',dispersion_err,' Mass: ',m_dyn,' +\- ',mass_err,' Lambda: ',lambda,' +\- ',lambda_err,' R_e: ',r_e,' Ellipticity: ',epsilon, 'Signal/Noise: ',sn

openw,9,'output.csv'
;printf,9, bcg, ',', target, ',', STRCOMPRESS(redshift10, /REMOVE_ALL), ',', STRCOMPRESS(dispersion10, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_err10, /REMOVE_ALL), ',', STRCOMPRESS(STRING(m_dyn10), /REMOVE_ALL), ',', STRCOMPRESS(STRING(mass_err10), /REMOVE_ALL), ',', STRCOMPRESS(lambda10, /REMOVE_ALL), ',', STRCOMPRESS(lambda_err10, /REMOVE_ALL), ',', STRCOMPRESS(r_e10, /REMOVE_ALL), ',', STRCOMPRESS(epsilon10, /REMOVE_ALL), ',', STRCOMPRESS(redshift5, /REMOVE_ALL), ',', STRCOMPRESS(dispersion5, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_err5, /REMOVE_ALL), ',', STRCOMPRESS(m_dyn5, /REMOVE_ALL), ',', STRCOMPRESS(mass_err5, /REMOVE_ALL), ',', STRCOMPRESS(lambda5, /REMOVE_ALL), ',', STRCOMPRESS(lambda_err5, /REMOVE_ALL), ',', STRCOMPRESS(r_e5, /REMOVE_ALL), ',', STRCOMPRESS(epsilon5, /REMOVE_ALL), ',', STRCOMPRESS(redshift_s, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_s, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_err_s, /REMOVE_ALL), ',', STRCOMPRESS(m_dyn_s, /REMOVE_ALL), ',', STRCOMPRESS(mass_err_s, /REMOVE_ALL), ',', STRCOMPRESS(lambda_s, /REMOVE_ALL), ',', STRCOMPRESS(lambda_err_s, /REMOVE_ALL), ',', STRCOMPRESS(r_e_s, /REMOVE_ALL), ',', STRCOMPRESS(epsilon_s, /REMOVE_ALL), ',', STRCOMPRESS(redshift_sdss, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_sdss, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_err_sdss, /REMOVE_ALL), ',', STRCOMPRESS(m_dyn_sdss, /REMOVE_ALL), ',', STRCOMPRESS(mass_err10, /REMOVE_ALL), ',', STRCOMPRESS(lambda_sdss, /REMOVE_ALL), ',', STRCOMPRESS(lambda_err_sdss, /REMOVE_ALL), ',', STRCOMPRESS(r_e_sdss, /REMOVE_ALL), ',', STRCOMPRESS(epsilon_sdss, /REMOVE_ALL)
printf,9, FORMAT = '( 38( A, "," ))', bcg, target, STRCOMPRESS(redshift10, /REMOVE_ALL), STRCOMPRESS(dispersion10, /REMOVE_ALL), STRCOMPRESS(dispersion_err10, /REMOVE_ALL), STRCOMPRESS(STRING(m_dyn10), /REMOVE_ALL), STRCOMPRESS(STRING(mass_err10), /REMOVE_ALL), STRCOMPRESS(lambda10, /REMOVE_ALL), STRCOMPRESS(lambda_err10, /REMOVE_ALL), STRCOMPRESS(r_e10, /REMOVE_ALL), STRCOMPRESS(epsilon10, /REMOVE_ALL), STRCOMPRESS(redshift5, /REMOVE_ALL), STRCOMPRESS(dispersion5, /REMOVE_ALL), STRCOMPRESS(dispersion_err5, /REMOVE_ALL), STRCOMPRESS(m_dyn5, /REMOVE_ALL), STRCOMPRESS(mass_err5, /REMOVE_ALL), STRCOMPRESS(lambda5, /REMOVE_ALL), STRCOMPRESS(lambda_err5, /REMOVE_ALL), STRCOMPRESS(r_e5, /REMOVE_ALL), STRCOMPRESS(epsilon5, /REMOVE_ALL), STRCOMPRESS(redshift_s, /REMOVE_ALL), STRCOMPRESS(dispersion_s, /REMOVE_ALL), STRCOMPRESS(dispersion_err_s, /REMOVE_ALL), STRCOMPRESS(m_dyn_s, /REMOVE_ALL), STRCOMPRESS(mass_err_s, /REMOVE_ALL), STRCOMPRESS(lambda_s, /REMOVE_ALL), STRCOMPRESS(lambda_err_s, /REMOVE_ALL), STRCOMPRESS(r_e_s, /REMOVE_ALL), STRCOMPRESS(epsilon_s, /REMOVE_ALL), STRCOMPRESS(redshift_sdss, /REMOVE_ALL), STRCOMPRESS(dispersion_sdss, /REMOVE_ALL), STRCOMPRESS(m_dyn_sdss, /REMOVE_ALL), STRCOMPRESS(lambda_sdss, /REMOVE_ALL), STRCOMPRESS(r_e_sdss, /REMOVE_ALL), STRCOMPRESS(epsilon_sdss, /REMOVE_ALL)
close,9







































end