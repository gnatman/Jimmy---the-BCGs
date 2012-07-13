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
	lambda_sn10='/Users/jimmy/Astro/reduced/'+bcg+'pro/'+target+'/sn10/lambda_re.txt'
	table_sn10='/Users/jimmy/Astro/reduced/'+bcg+'pro/'+target+'/sn10/table_one.txt'
	lambda_sn5='/Users/jimmy/Astro/reduced/'+bcg+'pro/'+target+'/sn5/lambda_re.txt'
	table_sn5='/Users/jimmy/Astro/reduced/'+bcg+'pro/'+target+'/sn5/table_one.txt'
	output='/Users/jimmy/Astro/reduced/'+bcg+'pro/output.csv'
endif

if (testing) then begin
	;read in the requisite files, and expected redshift from the environmental variables.
	lambda_sn10=getenv('infile1')
	table_sn10=getenv('infile2')
	lambda_sn5=getenv('infile3')
	table_sn5=getenv('infile4')
	output=getenv('outfile')
endif

;
;
if (bcg eq '_') then begin
	if (target eq 'main') then begin
		sarah_redshift = '-'
		sarah_dispersion = '-'
		sarah_dispersion_error = '-'
		sarah_r_e = '-'
		sarah_m_dyn = '-'
		sarah_m_dyn_error = '-'
		sarah_lambda = '-'
		sarah_lambda_error = '-'
		sarah_epsilon = '-'
		sdss_redshift = '-'
		sdss_dispersion = '-'
		sdss_dispersion_error = '-'
		sdss_r_e = '-'
		sdss_m_dyn = '-'
		sdss_m_dyn_error = '-'
		sdss_lambda = '-'
		sdss_lambda_error = '-'
		sdss_epsilon = '-'
	endif
	if (target eq 'comp') then begin
		sarah_redshift = '-'
		sarah_dispersion = '-'
		sarah_dispersion_error = '-'
		sarah_r_e = '-'
		sarah_m_dyn = '-'
		sarah_m_dyn_error = '-'
		sarah_lambda = '-'
		sarah_lambda_error = '-'
		sarah_epsilon = '-'
		sdss_redshift = '-'
		sdss_dispersion = '-'
		sdss_dispersion_error = '-'
		sdss_r_e = '-'
		sdss_m_dyn = '-'
		sdss_m_dyn_error = '-'
		sdss_lambda = '-'
		sdss_lambda_error = '-'
		sdss_epsilon = '-'
	endif
endif
;
;

sarah_redshift = '-'
sarah_dispersion = '-'
sarah_dispersion_error = '-'
sarah_r_e = '-'
sarah_m_dyn = '-'
sarah_m_dyn_error = '-'
sarah_lambda = '-'
sarah_lambda_error = '-'
sarah_epsilon = '-'
sdss_redshift = '-'
sdss_dispersion = '-'
sdss_dispersion_error = '-'
sdss_r_e = '-'
sdss_m_dyn = '-'
sdss_m_dyn_error = '-'
sdss_lambda = '-'
sdss_lambda_error = '-'
sdss_epsilon = '-'

if (bcg eq '1027') then begin
	if (target eq 'main') then begin
		sarah_redshift = '0.0894'
		sarah_dispersion = '263'
		sarah_dispersion_error = '2'
		sarah_m_dyn = '11.80'
		sarah_m_dyn_error = '0.29'
		sarah_lambda = '0.104'
		sarah_lambda_error = '0.009'
		sdss_redshift = '0.088'
		sdss_dispersion = '246.34'
		sdss_dispersion_error = '8.27'
		sdss_r_e = '4.64'
		sdss_epsilon = '0.93'
	endif
	if (target eq 'comp') then begin
		sarah_redshift = '0.0909'
		sarah_dispersion = '224'
		sarah_dispersion_error = '4'
		sarah_m_dyn = '11.57'
		sarah_m_dyn_error = '0.20'
		sarah_lambda = '0.248'
		sarah_lambda_error = '0.004'
		sdss_redshift = '0.0908'
		sdss_dispersion = '200.82'
		sdss_dispersion_error = '8.14'
		sdss_r_e = '3.71'
		sdss_epsilon = '0.035'
	endif
endif
if (bcg eq '1042') then begin
	if (target eq 'main') then begin
		sdss_redshift = '0.097200'
		sdss_dispersion = '246.89'
		sdss_dispersion_error = '8.74'
		sdss_r_e = '4.432619'
	endif
endif
if (bcg eq '1048') then begin
	if (target eq 'main') then begin
		sdss_redshift = '0.077450'
		sdss_dispersion = '65.09'
		sdss_dispersion_error = '5.61'
		sdss_r_e = '6.099069'
	endif
	if (target eq 'comp') then begin
		sdss_redshift = '0.077450'
		sdss_dispersion = '100.55'
		sdss_dispersion_error = '9.94'
		sdss_r_e = '2.057725'
	endif
	if (target eq '2ndcomp') then begin
		sdss_redshift = '0.073597'
		sdss_dispersion = '171.07'
		sdss_dispersion_error = '8.24'
		sdss_r_e = '3.505275'
	endif
endif
if (bcg eq '1050') then begin
	if (target eq 'main') then begin
		sarah_redshift = '0.722'
		sarah_dispersion = '399'
		sarah_dispersion_error = '2'
		sarah_m_dyn = '12.20'
		sarah_m_dyn_error = '0.55'
		sarah_lambda = '0.085'
		sarah_lambda_error = '0.005'
		sdss_redshift = '0.721'
		sdss_dispersion = '352.60'
		sdss_dispersion_error = '7.32'
		sdss_r_e = '6.29'
		sdss_epsilon = '0.066'
	endif
endif
if (bcg eq '1066') then begin
	if (target eq 'main') then begin
		sarah_redshift = '0.837'
		sarah_dispersion = '232'
		sarah_dispersion_error = '3'
		sarah_m_dyn = '11.84'
		sarah_m_dyn_error = '0.26'
		sarah_lambda = '0.181'
		sarah_lambda_error = '0.006'
		sdss_redshift = '0.0836'
		sdss_dispersion = ''
		sdss_dispersion_error = ''
		sdss_r_e = '7.03'
		sdss_epsilon = '0.100'
	endif
	if (target eq 'comp') then begin
		sarah_redshift = '0.0836'
		sarah_dispersion = '231'
		sarah_dispersion_error = '3'
		sarah_m_dyn = '11.85'
		sarah_m_dyn_error = '0.28'
		sarah_lambda = '0.569'
		sarah_lambda_error = '0.006'
		sdss_redshift = '0.0836'
		sdss_dispersion = '246.7'
		sdss_dispersion_error = '7.8'
		sdss_r_e = '7.23'
		sdss_epsilon = '0.312'
	endif
	if (target eq '2ndcomp') then begin
		sdss_redshift = '0.083595'
		sdss_dispersion = '199.3'
		sdss_dispersion_error = '7.30'
		sdss_r_e = '2.013'
	endif
endif
if (bcg eq '1067') then begin
	if (target eq 'main') then begin
		sdss_redshift = '0.095'
		sdss_dispersion = '186.83'
		sdss_dispersion_error = '7.70'
		sdss_r_e = '2.636639'
	endif
endif
if (bcg eq '1153') then begin
	if (target eq 'main') then begin
		sdss_redshift = '0.06000'
		sdss_dispersion = '251.440'
		sdss_dispersion_error = '6.72'
		sdss_r_e = '3.107662'
	endif
endif
if (bcg eq '1261') then begin
	if (target eq 'main') then begin
		sdss_redshift = '0.091000'
		sdss_dispersion = '226.91'
		sdss_dispersion_error = '13.62'
		sdss_r_e = '3.343759'
	endif
	if (target eq 'comp') then begin
		sdss_redshift = '0.0887970'
		sdss_dispersion = '125.23'
		sdss_dispersion_error = '11.53'
		sdss_r_e = '2.886154'
	endif
endif
if (bcg eq '2001') then begin
	if (target eq 'main') then begin
		sdss_redshift = '0.041132'
		sdss_dispersion = '208.960'
		sdss_dispersion_error = '5.24'
		sdss_r_e = '11.94404'
	endif
	if (target eq 'comp') then begin
		sdss_redshift = '0.042469'
		sdss_dispersion = '0'
		sdss_dispersion_error = '0'
		sdss_r_e = '21.75893'
	endif
endif
if (bcg eq '2039') then begin
	if (target eq 'main') then begin
		sdss_redshift = '0.083'
		sdss_dispersion = '301.34'
		sdss_dispersion_error = '4.84'
		sdss_r_e = '6.306086'
	endif
	if (target eq 'comp') then begin
		sdss_redshift = '0.084182'
		sdss_dispersion = '106.36'
		sdss_dispersion_error = '6.22'
		sdss_r_e = '21.75893'
	endif
endif
if (bcg eq '2086') then begin
	if (target eq 'main') then begin
		sarah_redshift = '0.0840'
		sarah_dispersion = '266'
		sarah_dispersion_error = '8'
		sarah_m_dyn = '11.78'
		sarah_m_dyn_error = '0.46'
		sarah_lambda = '0.090'
		sarah_lambda_error = '0.006'
		sdss_redshift = '0.0840'
		sdss_dispersion = '275.81'
		sdss_dispersion_error = '8.77'
		sdss_r_e = '4.63'
		sdss_epsilon = '0.083'
	endif
	if (target eq 'comp') then begin
		sarah_redshift = '0.819'
		sarah_dispersion = '228'
		sarah_dispersion_error = '3'
		sarah_m_dyn = '11.15'
		sarah_m_dyn_error = '0.41'
		sdss_redshift = '0.0830'
		sdss_dispersion = '203.93'
		sdss_dispersion_error = '9.31'
		sdss_r_e = '1.51'
		sdss_epsilon = '0.024'
	endif
endif


readcol, lambda_sn10, F='F,F,F,F', dummy1, r_e, epsilon, lambda, /silent
readcol, table_sn10, F='A,A,A,A,F,F', dummy1, dummy2, dummy3, dummy4, values, dummy5;, /silent
readcol, table_sn10, F='A,A,A,A', dummy6, dummy7, dummy8, dummy9, errors;, /silent

print,'r_e: ',r_e,'epsilon: ',epsilon, 'lambda: ',lambda
print,'values: ',values
print,'errors: ',errors


if (n_elements(lambda) eq 3) then begin
	r_e10 = r_e[1]
	lambda10 = lambda[1]
	epsilon10 = epsilon[1]
	half_r_e10 = r_e[0]
	half_lambda10 = lambda[0]
	half_epsilon10 = epsilon[0]
endif else if (n_elements(lambda) eq 2) then begin
	r_e10 = r_e[1]
	lambda10 = lambda[1]
	epsilon10 = epsilon[1]
	half_r_e10 = r_e[0]
	half_lambda10 = lambda[0]
	half_epsilon10 = epsilon[0]
endif else begin
	r_e10 = r_e[0]
	lambda10 = lambda[0]
	epsilon10 = epsilon[0]
	half_r_e10 = r_e[0]
	half_lambda10 = lambda[0]
	half_epsilon10 = epsilon[0]
endelse

redshift10 = values[0]
dispersion10 = values[2]
dispersion_err10 = errors[1]
;r_e10 = r_e
radius_rad10 = r_e10*4.84813681E-6
distance10 = redshift10*1.302773E26
radius_m10 = distance10*tan(radius_rad10)
mass10 = (5*radius_m10*((dispersion10*1000)^2))/(1.98892E30*6.673E-11)
log_mass10 = alog10(mass10)
m_dyn10 = log_mass10
mass_err10 = (dispersion_err10*2000)/(dispersion10*1000*alog(10))
;lambda10 = lambda
lambda_err10 = 0
;epsilon10 = epsilon

readcol, lambda_sn5, F='F,F,F,F', dummy1, r_e, epsilon, lambda, /silent
readcol, table_sn5, F='A,A,A,A,F,F', dummy1, dummy2, dummy3, dummy4, values, dummy5;, /silent
readcol, table_sn5, F='A,A,A,A', dummy6, dummy7, dummy8, dummy9, errors;, /silent

if (n_elements(lambda) eq 3) then begin
	r_e5 = r_e[1]
	lambda5 = lambda[1]
	epsilon5 = epsilon[1]
	half_r_e5 = r_e[0]
	half_lambda5 = lambda[0]
	half_epsilon5 = epsilon[0]
endif else if (n_elements(lambda) eq 2) then begin
	r_e5 = r_e[1]
	lambda5 = lambda[1]
	epsilon5 = epsilon[1]
	half_r_e5 = r_e[0]
	half_lambda5 = lambda[0]
	half_epsilon5 = epsilon[0]
endif else begin
	r_e5 = r_e[0]
	lambda5 = lambda[0]
	epsilon5 = epsilon[0]
	half_r_e5 = r_e[0]
	half_lambda5 = lambda[0]
	half_epsilon5 = epsilon[0]
endelse

redshift5 = values[0]
dispersion5 = values[2]
dispersion_err5 = errors[1]
;r_e5 = r_e
radius_rad5 = r_e5*4.84813681E-6
distance5 = redshift5*1.302773E26
radius_m5 = distance5*tan(radius_rad5)
mass5 = (5*radius_m5*((dispersion5*1000)^2))/(1.98892E30*6.673E-11)
log_mass5 = alog10(mass5)
m_dyn5 = log_mass5
mass_err5 = (dispersion_err5*2000)/(dispersion5*1000*alog(10))
;lambda5 = lambda
lambda_err5 = 0
;epsilon5 = epsilon

redshift_s = sarah_redshift
dispersion_s = sarah_dispersion
dispersion_err_s = sarah_dispersion_error
r_e_s = sarah_r_e
lambda_s = sarah_lambda
lambda_err_s = sarah_lambda_error
epsilon_s = sarah_epsilon
m_dyn_s = sarah_m_dyn
mass_err_s = sarah_m_dyn_error

redshift_sdss = sdss_redshift
dispersion_sdss = sdss_dispersion
dispersion_err_sdss = sdss_dispersion_error
r_e_sdss = sdss_r_e
lambda_sdss = sdss_lambda
lambda_err_sdss = sdss_lambda_error
epsilon_sdss = sdss_epsilon
m_dyn_sdss = sdss_m_dyn
mass_err_sdss = sdss_m_dyn_error



;print,'Name: ',bcg+'_'+target,' Z: ',redshift,' Dispersion: ',dispersion,' +\- ',dispersion_err,' Mass: ',m_dyn,' +\- ',mass_err,' Lambda: ',lambda,' +\- ',lambda_err,' R_e: ',r_e,' Ellipticity: ',epsilon, 'Signal/Noise: ',sn

openw,9,output
;printf,9, bcg, ',', target, ',', STRCOMPRESS(redshift10, /REMOVE_ALL), ',', STRCOMPRESS(dispersion10, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_err10, /REMOVE_ALL), ',', STRCOMPRESS(STRING(m_dyn10), /REMOVE_ALL), ',', STRCOMPRESS(STRING(mass_err10), /REMOVE_ALL), ',', STRCOMPRESS(lambda10, /REMOVE_ALL), ',', STRCOMPRESS(lambda_err10, /REMOVE_ALL), ',', STRCOMPRESS(r_e10, /REMOVE_ALL), ',', STRCOMPRESS(epsilon10, /REMOVE_ALL), ',', STRCOMPRESS(redshift5, /REMOVE_ALL), ',', STRCOMPRESS(dispersion5, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_err5, /REMOVE_ALL), ',', STRCOMPRESS(m_dyn5, /REMOVE_ALL), ',', STRCOMPRESS(mass_err5, /REMOVE_ALL), ',', STRCOMPRESS(lambda5, /REMOVE_ALL), ',', STRCOMPRESS(lambda_err5, /REMOVE_ALL), ',', STRCOMPRESS(r_e5, /REMOVE_ALL), ',', STRCOMPRESS(epsilon5, /REMOVE_ALL), ',', STRCOMPRESS(redshift_s, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_s, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_err_s, /REMOVE_ALL), ',', STRCOMPRESS(m_dyn_s, /REMOVE_ALL), ',', STRCOMPRESS(mass_err_s, /REMOVE_ALL), ',', STRCOMPRESS(lambda_s, /REMOVE_ALL), ',', STRCOMPRESS(lambda_err_s, /REMOVE_ALL), ',', STRCOMPRESS(r_e_s, /REMOVE_ALL), ',', STRCOMPRESS(epsilon_s, /REMOVE_ALL), ',', STRCOMPRESS(redshift_sdss, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_sdss, /REMOVE_ALL), ',', STRCOMPRESS(dispersion_err_sdss, /REMOVE_ALL), ',', STRCOMPRESS(m_dyn_sdss, /REMOVE_ALL), ',', STRCOMPRESS(mass_err10, /REMOVE_ALL), ',', STRCOMPRESS(lambda_sdss, /REMOVE_ALL), ',', STRCOMPRESS(lambda_err_sdss, /REMOVE_ALL), ',', STRCOMPRESS(r_e_sdss, /REMOVE_ALL), ',', STRCOMPRESS(epsilon_sdss, /REMOVE_ALL)
printf,9, FORMAT = '( 38( A, "," ))', bcg, target, STRCOMPRESS(redshift10, /REMOVE_ALL), STRCOMPRESS(dispersion10, /REMOVE_ALL), STRCOMPRESS(dispersion_err10, /REMOVE_ALL), STRCOMPRESS(STRING(m_dyn10), /REMOVE_ALL), STRCOMPRESS(STRING(mass_err10), /REMOVE_ALL), STRCOMPRESS(lambda10, /REMOVE_ALL), STRCOMPRESS(lambda_err10, /REMOVE_ALL), STRCOMPRESS(r_e10, /REMOVE_ALL), STRCOMPRESS(epsilon10, /REMOVE_ALL), STRCOMPRESS(redshift5, /REMOVE_ALL), STRCOMPRESS(dispersion5, /REMOVE_ALL), STRCOMPRESS(dispersion_err5, /REMOVE_ALL), STRCOMPRESS(m_dyn5, /REMOVE_ALL), STRCOMPRESS(mass_err5, /REMOVE_ALL), STRCOMPRESS(lambda5, /REMOVE_ALL), STRCOMPRESS(lambda_err5, /REMOVE_ALL), STRCOMPRESS(r_e5, /REMOVE_ALL), STRCOMPRESS(epsilon5, /REMOVE_ALL), STRCOMPRESS(redshift_s, /REMOVE_ALL), STRCOMPRESS(dispersion_s, /REMOVE_ALL), STRCOMPRESS(dispersion_err_s, /REMOVE_ALL), STRCOMPRESS(m_dyn_s, /REMOVE_ALL), STRCOMPRESS(mass_err_s, /REMOVE_ALL), STRCOMPRESS(lambda_s, /REMOVE_ALL), STRCOMPRESS(lambda_err_s, /REMOVE_ALL), STRCOMPRESS(r_e_s, /REMOVE_ALL), STRCOMPRESS(epsilon_s, /REMOVE_ALL), STRCOMPRESS(redshift_sdss, /REMOVE_ALL), STRCOMPRESS(dispersion_sdss, /REMOVE_ALL), STRCOMPRESS(m_dyn_sdss, /REMOVE_ALL), STRCOMPRESS(lambda_sdss, /REMOVE_ALL), STRCOMPRESS(r_e_sdss, /REMOVE_ALL), STRCOMPRESS(epsilon_sdss, /REMOVE_ALL)
close,9
print,m_dyn10
print, bcg, target, STRCOMPRESS(redshift10, /REMOVE_ALL), STRCOMPRESS(dispersion10, /REMOVE_ALL), STRCOMPRESS(dispersion_err10, /REMOVE_ALL), STRCOMPRESS(STRING(m_dyn10), /REMOVE_ALL), STRCOMPRESS(STRING(mass_err10), /REMOVE_ALL), STRCOMPRESS(lambda10, /REMOVE_ALL), STRCOMPRESS(lambda_err10, /REMOVE_ALL), STRCOMPRESS(r_e10, /REMOVE_ALL), STRCOMPRESS(epsilon10, /REMOVE_ALL), STRCOMPRESS(redshift5, /REMOVE_ALL), STRCOMPRESS(dispersion5, /REMOVE_ALL), STRCOMPRESS(dispersion_err5, /REMOVE_ALL), STRCOMPRESS(m_dyn5, /REMOVE_ALL), STRCOMPRESS(mass_err5, /REMOVE_ALL), STRCOMPRESS(lambda5, /REMOVE_ALL), STRCOMPRESS(lambda_err5, /REMOVE_ALL), STRCOMPRESS(r_e5, /REMOVE_ALL), STRCOMPRESS(epsilon5, /REMOVE_ALL), STRCOMPRESS(redshift_s, /REMOVE_ALL), STRCOMPRESS(dispersion_s, /REMOVE_ALL), STRCOMPRESS(dispersion_err_s, /REMOVE_ALL), STRCOMPRESS(m_dyn_s, /REMOVE_ALL), STRCOMPRESS(mass_err_s, /REMOVE_ALL), STRCOMPRESS(lambda_s, /REMOVE_ALL), STRCOMPRESS(lambda_err_s, /REMOVE_ALL), STRCOMPRESS(r_e_s, /REMOVE_ALL), STRCOMPRESS(epsilon_s, /REMOVE_ALL), STRCOMPRESS(redshift_sdss, /REMOVE_ALL), STRCOMPRESS(dispersion_sdss, /REMOVE_ALL), STRCOMPRESS(m_dyn_sdss, /REMOVE_ALL), STRCOMPRESS(lambda_sdss, /REMOVE_ALL), STRCOMPRESS(r_e_sdss, /REMOVE_ALL), STRCOMPRESS(epsilon_sdss, /REMOVE_ALL)


end