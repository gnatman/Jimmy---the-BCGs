pro average_seeing

galaxy_names= [ '1027', '1042', '1048', '1050', '1066', '1067','1153', '1261', '2001', '2039', '2086']

files = file_search('/Users/jimmy/Astro/reduced/raw/*.fits',COUNT=nfiles)

for i=0, n_elements(galaxy_names)-1 do begin
	firstavg = 0
	secavg = 0
	K = 0
	for j=0, nfiles-1 do begin
		;data=mrdfits(files[j], 0, header)
		fits_read, files[j], data, header
		date = fxpar(header,'DATE')
		object = fxpar(header,'OBJECT')
		category = hierarch(headfits(files[j]), 'HIERARCH ESO DPR CATG') 
		fwhm_begin = hierarch(headfits(files[j]), 'HIRARCH ESO TEL AMBI FWHM START')
		fwhm_end = hierarch(headfits(files[j]), 'HIERARCH ESO TEL AMBI FWHM END')
		fwhm_other = hierarch(headfits(files[j]), 'HIERARCH ESO TEL IA FWHM')
		if category eq 'SCIENCE ' then begin
			if object eq 'C4_DR3_'+galaxy_names[i] then begin
				fwhm_avg = (fwhm_begin+fwhm_end)/2
				print,'1st Method: ',fwhm_avg,' 2nd Method: ',fwhm_other, ' Date: ', date
				firstavg = firstavg + abs(fwhm_avg)
				secavg = secavg + abs(fwhm_other)
				if abs(fwhm_avg) ne 0 then begin
					k = k+1
				endif
			endif
		endif
	endfor

	print,'C4_DR3_'+galaxy_names[i],' Total: '
	print,'1st Method: ',firstavg/k,' 2nd Method: ',secavg/k
	print,' '
	print,' '
	print,' '
	print,' '
	print,' '
	print,' '
	print,' '
	print,' '
	print,' '
	print,' '
	print,' '
endfor

end