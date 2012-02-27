;#############################################################################
;
; Based initially off code written by Michele Cappellari
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
;   JIMMY_PPXF
;
; PURPOSE:
;   This code calls the Cappellari PPXF fitting program.  It's used for 
;	calculating velocity and velocity dispersions on bins from voronoi tesselaton.
;	It also performs a monte carlo routine with noise added.
;
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;	    infile1: Stacked and masked data cube.
;		infile2: voronoi_2d_binning_output.txt or equivalent.
;		infile3: MILES_library directory.
;		infile4: voronoi_2d_bins.txt or equivalent.
;		outfile: ppxf_v_bin_output or equivalent.
;		start_range: Starting range in pixels for the fit, if you want to set manually.
;		end_range: Ending range of fit, used to isolate absorbtion features to fit to.
;		template_list: Used to pick a subset of the library for the fitting.
;		monte_iterations: Number of monte carlo iterations.
;		redshift: Initial redshift guess.
;
; NOTES:
;	If run directly from IDL, edit everything within an 'if (testing ne 1)'
;		statement to have the proper directories.
;	Also of note, PPXF.pro has been edited to allow printing out of the PPXF fitting results.
;
;--------------------------------
;
; LOGICAL PROGRESSION OF IDL CODE:
;	None written yet.
;
;--------------------------------
;
; REQUIRED ROUTINES:
;       IDL Astronomy Users Library: http://idlastro.gsfc.nasa.gov/
;		PPXF from Michele Cappellari: http://www-astro.physics.ox.ac.uk/~mxc/idl/
;
; MODIFICATION HISTORY:
;   V1.0 -- Created by Jimmy, 2011
;
;----------------------------------------------------------------------------

function determine_goodPixels, logLam, lamRangeTemp, redshift, act_z

; Wavelengths of sky lines - correct for z as wavelength re-scaled below
lines = [5577.0d/(1+act_z),5892.0d/(1+act_z)] 
dv = [250d,250d] ; width/2 of masked gas emission region in km/s
c = 299792.458d ; speed of light in km/s

flag = bytarr(n_elements(logLam))

for j=0,n_elements(lines)-1 do $
    flag or= logLam gt alog(lines[j]) + (redshift - dv[j])/c $
         and logLam lt alog(lines[j]) + (redshift + dv[j])/c
         
flag or= logLam lt alog(lamRangeTemp[0]) + (redshift + 900d)/c ; Mask edges of
flag or= logLam gt alog(lamRangeTemp[1]) + (redshift - 900d)/c ; stellar library

return, where(flag eq 0)
end

;------------------------------------------------------------------------------
pro jimmy_ppxf

testing=0 ;Set to 0 if you want to be in "testing" mode
testing_string=getenv('not_testing') ;read from bash
testing=FIX(testing_string) ;needed for the string to be an integer


;Read in files for input and start output
if (testing) then begin
    fits_read, getenv('infile1'), datacube, h
    var=mrdfits(getenv('infile1'),1,h, /SILENT)
    rdfloat, getenv('infile2'), xarc, yarc, x, y, binNum, SKIPLINE=1, /SILENT
    rdfloat, getenv('infile4'), dummy, dummy, dummy, dummy, total_noise, SKIPLINE=1, /SILENT
    openw, 9, getenv('outfile')
endif
if (testing ne 1) then begin
    fits_read, '/Users/jimmy/Astro/reduced/1050pro/temp.fits', datacube, h
    var=mrdfits('/Users/jimmy/Astro/reduced/1050pro/temp.fits',1,h) ;, /SILENT)
    rdfloat, '/Users/jimmy/Astro/reduced/1050pro/voronoi_2d_binning_output.txt', xarc, yarc, x, y, binNum, SKIPLINE=1
    rdfloat, '/Users/jimmy/Astro/reduced/1050pro/voronoi_2d_bins.txt', dummy, dummy, dummy, dummy, total_noise, SKIPLINE=1
    openw, 9, '/Users/jimmy/Downloads/ppxf_v_bin_output'
endif


;Set initial wavelength range to the full range (3500 - 7000)
initial_wavelength_range = sxpar(h,'CRVAL3') + [0d,sxpar(h,'CDELT3')*(sxpar(h,'NAXIS3') -1d)]
pixel_scale=sxpar(h,'CDELT3')
imsize=size(datacube)
initial_pixel_range = imsize[3]


;create blank arrays to store our good pixels
goodpix_safe1=fltarr(max(binNum)+1)
goodpix_safe=fltarr(max(binNum)+1)
ppxf_plot_number = 0 ;used for tracking file names in the printed plots


;for all the bins, number determined by the binning routines
for i = 0, max(binNum) do begin
    goodpix_safe[i]=0 ;initially start with our min of range being zero
    goodpix_safe1[i]=initial_pixel_range-1 ;high to the max pixel initially

    noise_level = total_noise[i] ;Pull in the noise from binning procedure
	
    ;go through each fiber and see if that pixel is in that bin, then find smallest goodpix range
    for j=0,n_elements(x)-1 do begin
        if binNum[j] eq i then begin
            ;creating an array describing which wavelength pixels aren't zero
            goodpix=where(datacube[x[j],y[j],*] ne 0.0)
            ;finding first & last good pixel numbers, compare to saved, if current spectrum for that bin is narrower, the range will be shrunk to that new value
            if goodpix[0] gt goodpix_safe[i] then goodpix_safe[i]=goodpix[0]
            if goodpix[n_elements(goodpix)-1] lt goodpix_safe1[i] then goodpix_safe1[i]=goodpix[n_elements(goodpix)-1]
        endif
    endfor    

    ;These are used to hold the total spectra as each bin is added
    sum_spectra=0.0
    var_sum=0.0

    ;trimming last 15A (i.e.25pix) from either end of spectrum as they are generally rubbish
    goodpix_safe[i]=goodpix_safe[i]+25
    goodpix_safe1[i]=goodpix_safe1[i]-25.
    ;Go one step further and manually set the plotting range, to isolate certain absorption features or cut out noise ends
    if (testing) then begin
        goodpix_safe[i]=getenv('start_range')
        goodpix_safe1[i]=getenv('end_range')
    endif
    
    new_wavelength_range = fltarr(2)
    new_wavelength_range[0] = initial_wavelength_range[0]+(goodpix_safe[i]*pixel_scale)
    new_wavelength_range[1] = initial_wavelength_range[0]+(goodpix_safe1[i]*pixel_scale)
    
    print,' '
    print, 'Starting & ending pixel', goodpix_safe[i], goodpix_safe1[i]
    print, 'Size of new spectrum in pixels', goodpix_safe1[i] - goodpix_safe[i] + 1 ;+1 because the size array starts with zero
    print, 'Starting & ending wavelength', new_wavelength_range[0], new_wavelength_range[1]
    print,' '

    t = 0 ;keep track of number of fibers going into a bin

    ;go through each pixel that should be binned, and sum the spectra
    for j=0,n_elements(x)-1 do begin        
        if binNum[j] eq i then begin
            t = t+1
            if t eq 1 then begin
                print,' Fibers going into bin: ',binNum[j]," of ", max(binNum)
            endif
            spectra=datacube[x[j],y[j],*] ;pull in whole spectra
            spectra=spectra[goodpix_safe[i]:goodpix_safe1[i]] ;restrict to good pixels
            sum_spectra=spectra+sum_spectra ;sum it all
            variance=var[x[j],y[j],*] ;pull in variance
            variance=variance[goodpix_safe[i]:goodpix_safe1[i]] ;variance in only good range
            var_sum=(variance^2)+var_sum ;Sum all the variance as well, in quadrature
        endif
        if j eq n_elements(x)-1 then begin
            print, t, ' fibers being used'
        endif
    endfor
    var_sum = sqrt(var_sum) ;square root the errors, were added in quadrature
    print, ' '


    ; If the galaxy is at a significant redshift (z > 0.03), one would need to apply 
    ; a large velocity shift in PPXF to match the template to the galaxy spectrum.
    ; This would require a large initial value for the velocity (V > 1e4 km/s) 
    ; in the input parameter START = [V,sig]. This can cause PPXF to stop! 
    ; The solution consists of bringing the galaxy spectrum roughly to the 
    ; rest-frame wavelength, before calling PPXF. 
    
    if (testing) then begin
        z = FLOAT(getenv('redshift'))
    endif
    if (testing ne 1) then begin
        z = 0.072
    endif
    
    
    shifted_wavelength_range = new_wavelength_range/(1+z) ; Compute approximate restframe wavelength range


    ; Read a galaxy spectrum and rebin it logarithmically.
    ; As the keyword VELSCALE has not been previously defined, LOG_REBIN will
    ; keep the same number of pixels in the spectrum, and will provide in output
    ; the velocity scale in km/s, to be used in the subsequent calls below.

    ;Input the x and y coordinates, output logarithmically rebinned x and y coordinates
    log_rebin, shifted_wavelength_range, sum_spectra, galaxy, log_wavelength, VELSCALE=velScale
    log_rebin, shifted_wavelength_range, var_sum, noise, log_var, VELSCALE=velScale
    
    ;Pull in the template file names
    if (testing) then begin
        miles = file_search(getenv('infile3') + getenv('template_list'), COUNT=nfiles)
    endif
    if (testing ne 1) then begin
        miles = file_search('/Users/jimmy/Astro/MILES_library/s02*.fits',COUNT=nfiles)
    endif


    ; Extract the wavelength range and logarithmically rebin one spectrum
    ; to the same velocity scale of the VIMOS galaxy spectrum, to determine
    ; the size needed for the array which will contain the template spectra.

    fits_read, miles[0], ssp, h
    template_range = sxpar(h,'CRVAL1') + [0d,sxpar(h,'CDELT1')*(sxpar(h,'NAXIS1')-1d)]
    log_rebin, template_range, ssp, sspNew, log_template, VELSCALE=velScale
    templates = dblarr(n_elements(sspNew),nfiles)
    

    ; Logarithmically rebin the whole Vazdekis library of spectra,
    ; and store each template as a column in the array TEMPLATES,
    ; after convolving it with the quadratic difference between
    ; the SAURON and the Vazdekis instrumental resolution.
    ;
    ; Example: Vazdekis spectra have a resolution of 1.8A FWHM at 5100A
    ; this corresponds to sigma ~ 1.8/5100*3e5/2.355 = 45 km/s.
    ; SAURON has an instrumental resolution of sigma = 108 km/s.
    ; The quadratic difference is sigma = sqrt(108^2 - 45^2) = 98 km/s
    ; (the above reasoning can be applied if the shape of the instrumental
    ; spectral profiles can be well approximated by a Gaussian).
    ;
    ;MILES have 2.3A at 5100A which corresponds to
    ;sigma~2.3/5100*3e5/2.355 = 57.45 km/s)
    ;VIMOS has a resolution of 2.1A FWHM at 5100 which corresponds to
    ;sigma~2.1/5100*3e5/2.355 = 52.45 km/s)
    ; The quadratic difference MILES VIMOS is sigma = sqrt(57.45^2 - 52.45^2) = 23 km/s
    ; The quadratic difference VIMOS vazdekis sigma = sqrt(52.45^2 - 45) = 26 km/s

    sigma = 23d/velScale ; Quadratic sigma difference in pixels MILES --> VIMOS ;was 26, don't know why
    lsf = psf_Gaussian(NPIXEL=8*sigma, ST_DEV=sigma, /NORM, NDIM=1)
    for j=0,nfiles-1 do begin
        fits_read, miles[j], ssp
        log_rebin, template_range, ssp, sspNew, VELSCALE=velScale
        templates[*,j] = convol(sspNew,lsf)/median(sspNew) ; Degrade template to SAURON resolution
    endfor


    ; The galaxy and the template spectra do not have the same starting wavelength.
    ; For this reason an extra velocity shift DV has to be applied to the template
    ; to fit the galaxy spectrum. We remove this artificial shift by using the
    ; keyword VSYST in the call to PPXF below, so that all velocities are
    ; measured with respect to DV. This assume the redshift is negligible.
    ; In the case of a high-redshift galaxy one should de-redshift its 
    ; wavelength to the rest frame before using the line below (see above).
    c = 299792.458d
    dv = (log_template[0]-log_wavelength[0])*c ; km/s


    redshift = 1d ; Initial estimate of the galaxy redshift in km/s, hopefully zero because we shifted above
    ;use determine good pixels function to do exactly that.
    goodPixels = determine_goodPixels(log_wavelength,template_range,redshift,z)


    ; Here the actual fit starts. The best fit is plotted on the screen.
    ; Gas emission lines are excluded from the pPXF fit using the
    ; GOODPIXELS keyword

    start = [redshift, 300d] ; (km/s), starting guess for [V,sigma]


    ;Begin Monte Carlo procedure
    monte_velocity=fltarr(getenv('monte_iterations'))
    monte_sigma=fltarr(getenv('monte_iterations'))
    
    print,'Proposed noise level: ',noise_level ;Good to check how much noise we're adding/subtracting from signal
    print,' '
    
    if ( getenv('montecarlointoppxf') eq 'y' ) then begin
        galaxy_size = size(galaxy) ;size of logarithmically rebinned spectra
        for k=0,getenv('monte_iterations')-1 do begin
            noisy = (RANDOMU(seed, galaxy_size[1])-0.5)*noise_level ;generate noise for each pixel in the spectra
            noisy_galaxy = galaxy + noisy ;make the galaxy noisy
            ;perform a ppxf fit on the noisy galaxy
            noise = galaxy*0 + 1
            ppxf, templates, noisy_galaxy, noise, velScale, start, sol, GOODPIXELS=goodPixels, /PLOT, MOMENTS=4, DEGREE=6, VSYST=dv,BIAS=0, ERROR=error
            monte_velocity[k]=sol[0] ;store to a vector of all the resulting velocities
            monte_sigma[k]=sol[1] ;store to a vector of all the resulting dispersions
        endfor
    endif

    velocity_std_dev = stddev(monte_velocity) ;compute the standard deviation, this is our error in velocity
    sigma_std_dev = stddev(monte_sigma) ;compute the standard deviation, this is our error in dispersion

    print,'Error in Velocity: ',velocity_std_dev
    print,'Error in Dispersion: ',sigma_std_dev 
    print,' '

    print,'size of galaxy: ',size(galaxy)
    print,'size of noise: ',size(noise)

    noise = galaxy*0 + 1

    ;Perform the pPXF fit on the galaxy using the templates and 1 sigma errors on the spectra
    ppxf, templates, galaxy, noise, velScale, start, sol, GOODPIXELS=goodPixels, /PLOT, /PRINT, MOMENTS=4, DEGREE=4, VSYST=dv,BIAS=0, ERROR=error


    ;if (testing ne 1) then begin
        print, 'Formal errors:    dV    dsigma       dh3       dh4' ;these are probably garbage, only work if reduced chi squared is about 1
        print, error*sqrt(sol[6]), FORMAT='(10x,2f10.1,2f10.3)'
    ;endif
    
    
    ; If the galaxy is at significant redshift z and the wavelength has been
    ; de-redshifted with the two lines near the beginning of this procedure,
    ; the best-fitting redshift is now given by the following commented line: 
    print, 'Best-fitting redshift z:', (z + 1)*(1 + sol[0]/c) - 1  
    print,' '
    print,' '
     

    printf, 9, i, sol[0], velocity_std_dev, sol[1], sigma_std_dev, sol[2], sol[3], sol[4], sol[5], sol[6],(z + 1)*(1 + sol[0]/c) - 1, FORMAT='(i6,2f10.1,7f10.3,f10.6,e12.5)'


    ;make the directory that the plots are saved to, move the printed plot to the directory, and then directory will be moved with bash
    file_mkdir,'ppxf_fits'
    file_move,'ppxf_fit.eps','ppxf_fits/'+STRTRIM(ppxf_plot_number,2)+'.eps', /OVERWRITE
    ppxf_plot_number = ppxf_plot_number+1 ;up the counter

endfor


close, 9 ;close the file write, we're done here


end
;------------------------------------------------------------------------------
