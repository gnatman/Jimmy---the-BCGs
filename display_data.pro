pro display_data,type,galaxy

sauron_colormap

testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)

if (testing ne 1) then begin
	;read in the requisite files, and expected redshift from the environmental variables.
	rdfloat, '/Users/jimmy/Astro/reduced/'+galaxy+'pro/voronoi_2d_bins.txt', xbin, ybin,sn,NPix, SKIPLINE=1              ;2d_bins
	rdfloat, '/Users/jimmy/Astro/reduced/'+galaxy+'pro/ppxf_v_bin_output', bin,V,v_sig,sigma,sigma_sig,h3,h4,h5,h6,Chi2,z ;bin_output
	rdfloat, '/Users/jimmy/Astro/reduced/'+galaxy+'pro/voronoi_2d_binning_output.txt', x, y, xpix, ypix, binNum, SKIPLINE=1        ;2d_binning_output
endif

if (testing) then begin
	;read in the requisite files, and expected redshift from the environmental variables.
	rdfloat, getenv('infile1'), xbin, ybin,sn,NPix, SKIPLINE=1              ;2d_bins
	rdfloat, getenv('infile2'), bin,V,v_sig,sigma,sigma_sig,h3,h4,h5,h6,Chi2,z ;bin_output
	rdfloat, getenv('infile3'), x, y, xpix, ypix, binNum, SKIPLINE=1        ;2d_binning_output
endif

table_file_name = 'table.txt'
if type eq 'radial' then begin
    table_file_name = 'table_rad.txt'
endif
if type eq 'one' then begin
    table_file_name = 'table_one.txt'
endif

openw,1,table_file_name
printf,1,'Mean Z: ',mean(z)
printf,1,'Mean Vel: ',wmean(V, v_sig, ERROR=verror), '  +/-',verror
printf,1,'Mean Sigma: ',wmean(sigma, sigma_sig, ERROR=serror), '  +/-',serror
printf,1,'Min & Max Z: ',min(z),max(z)
printf,1,'Min & Max Vel: ',min(V),max(V)
printf,1,'Min & Max Sigma: ',min(sigma),max(sigma)

;print,'Bin Number, X-bin, Y-bin, Velocity, Sigma, Z, Chi^2'
printf,1,'Bin Number, X-bin, Y-bin, Velocity, Sigma, Z
for i = 0, n_elements(xbin)-1 do begin
    ;print, i, xbin[i],ybin[i],V[i],v_sig[i],sigma[i],sigma_sig[i],z[i],Chi2[i]
    printf,1, i, xbin[i],ybin[i],V[i],v_sig[i],sigma[i],sigma_sig[i],z[i],FORMAT='(i6,6f10.3,f10.6)'
endfor

close,1

;xbin = xbin+0.603
;x=x+0.603
;xpix = xpix+2

print,'Mean Z: ',mean(z)
print,'Mean Vel: ',wmean(V, v_sig, ERROR=verror), '  +/-',verror
print,'Mean Sigma: ',wmean(sigma, sigma_sig, ERROR=serror), '  +/-',serror
print,'Min & Max Z: ',min(z),max(z)
print,'Min & Max Vel: ',min(V),max(V)
print,'Min & Max Sigma: ',min(sigma),max(sigma)

max_scale=(max(V)*1.2)+100
min_scale=(min(V)*1.2)-100

if type eq 'vbinned' then begin

print,'min(xbin)',min(xbin),'max(ybin)',max(ybin)

if galaxy eq '1050' then begin
	xmod = -8
	ymod = 0.5
	bcg_center_x = -1.2
	bcg_center_y = -0.2
	companion = 'n'
	xmin = -6
	xmax = 6
	ymin = -6
	ymax = 6
endif
if galaxy eq '1027' then begin
	xmod = -3
	ymod = -0.8
	bcg_center_x = 8.95
	bcg_center_y = -7.45
	companion='y'
	comp_center_x = 1
	comp_center_y = 1.15
	xmin = -2
	xmax = 13
	ymin = -10
	ymax = 4
endif
if galaxy eq '1066' then begin
	xmod = -3
	ymod = -1
	bcg_center_x = -5.05
	bcg_center_y = 5.55
	companion='y'
	comp_center_x = 2.2
	comp_center_y = -3.6
	xmin = -7
	xmax = 9
	ymin = -9
	ymax = 9
endif
if galaxy eq '1153' then begin
	xmod = -0.6
	ymod = 0.75
	bcg_center_x = 0.15
	bcg_center_y = 1.5
	companion = 'n'
	xmin = -4
	xmax = 8
	ymin = -4
	ymax = 8
endif
if galaxy eq '2001' then begin
	xmod = -7.2
	ymod = 0
	bcg_center_x = -3.83
	bcg_center_y = 2.85
	companion='n'
	xmin = -10
	xmax = 2
	ymin = -3
	ymax = 9
endif
if galaxy eq '2086' then begin
	xmod = -2
	ymod = 0
	bcg_center_x = -4.9
	bcg_center_y = 3.05
	companion='y'
	comp_center_x = 0.4
	comp_center_y = 0.5
	xmin = -10
	xmax = 4
	ymin = -4
	ymax = 10
endif

;print, 'max(sn)',sn,max(sn)
;print,'xbin[1],ybin[1]',xbin[1],ybin[1]

title_x_position = max(xbin)+xmod
title_y_position = max(ybin)+ymod

set_plot, 'ps'
device, filename='velocity.eps', /encapsul, /color, BITS=8
display_bins, xbin, ybin, V, x,y, PIXELSIZE=1, RANGE=[min_scale, max_scale], CHARSIZE=2.3, CHARTHICK=7, XRANGE=[xmin,xmax], YRANGE=[ymin,ymax];, TITLE='Velocity'
;color_bar_y, xmax+1.25, xmax+2.25, !Y.crange[0],!y.crange[1],min_scale,max_scale,title='km/s', CHARSIZE=2, CHARTHICK=7
xyouts, xmin+0.5, ymin+0.5, galaxy, CHARSIZE=2.3, CHARTHICK=10
xyouts, bcg_center_x, bcg_center_y, '!9B!3', CHARSIZE=2, CHARTHICK=12
if (companion eq 'y') then begin
	xyouts, comp_center_x, comp_center_y, '+', CHARSIZE=2, CHARTHICK=12
endif

;Sarah's graph scales, used to directly compare my results to hers.
max_scale=400
min_scale=-400

set_plot, 'ps'
device, filename='velocity_scale.eps', /encapsul, /color, BITS=8
display_bins, xbin, ybin, V, x,y, PIXELSIZE=1, RANGE=[min_scale, max_scale], CHARSIZE=2.3, CHARTHICK=7, XRANGE=[xmin,xmax], YRANGE=[ymin,ymax];, TITLE='Velocity'
;color_bar_y, xmax+1.25, xmax+2.25, !Y.crange[0],!y.crange[1],min_scale,max_scale,title='km/s', CHARSIZE=2, CHARTHICK=7
xyouts, xmin+0.5, ymin+0.5, galaxy, CHARSIZE=2.3, CHARTHICK=10
xyouts, bcg_center_x, bcg_center_y, '!9B!3', CHARSIZE=2, CHARTHICK=12
if (companion eq 'y') then begin
	xyouts, comp_center_x, comp_center_y, '+', CHARSIZE=2, CHARTHICK=12
endif

set_plot, 'ps'
device, filename='sigma_scale.eps', /encapsul, /color, BITS=8
display_bins, xbin, ybin, sigma, x,y, PIXELSIZE=1, RANGE=[0, 550], CHARSIZE=2.3, CHARTHICK=7, XRANGE=[xmin,xmax], YRANGE=[ymin,ymax];, TITLE='Dispersion'
;color_bar_y, xmax+1.25, xmax+2.25, !Y.crange[0],!y.crange[1],0,550,title='km/s', CHARSIZE=2, CHARTHICK=7
xyouts, xmin+0.5, ymin+0.5, galaxy, CHARSIZE=2.3, CHARTHICK=10
xyouts, bcg_center_x, bcg_center_y, '!9B!3', CHARSIZE=2, CHARTHICK=12
if (companion eq 'y') then begin
	xyouts, comp_center_x, comp_center_y, '+', CHARSIZE=2, CHARTHICK=12
endif

set_plot, 'ps'
device, filename='signal_noise.eps', /encapsul, /color, BITS=8
display_bins, xbin, ybin, sn, x,y, PIXELSIZE=1, RANGE=[3, max(sn)*1.1], CHARSIZE=2.3, CHARTHICK=7, XRANGE=[xmin,xmax], YRANGE=[ymin,ymax];, TITLE='Signal/Noise'
;color_bar_y, xmax+1.25, xmax+2.25, !Y.crange[0],!y.crange[1],3,max(sn)*1.1,title='S/N', CHARSIZE=2, CHARTHICK=7
xyouts, xmin+0.5, ymin+0.5, galaxy, CHARSIZE=2.3, CHARTHICK=10
xyouts, bcg_center_x, bcg_center_y, '!9B!3', CHARSIZE=2, CHARTHICK=12
if (companion eq 'y') then begin
	xyouts, comp_center_x, comp_center_y, '+', CHARSIZE=2, CHARTHICK=12
endif 

device,/close

endif

;spelled wrong to skip it until fixed
if type eq 'radiall' then begin
xin = fltarr(100)
yin = fltarr(100)
sigin = fltarr(100)
vin = fltarr(100)
snin = fltarr(100)
h=0
xin[0] = x[0]
yin[0] = y[0]
sigin[0] = sigma[0]
vin[0] = V[0]
snin[0] = sn[0]


for i=0,n_elements(NPix)-1 do begin
    for j=0,(NPix[i]-1) do begin
        xin[h] = 3*x[h]
        yin[h] = 3*y[h]
        sigin[h] = sigma [i]
        vin[h] = V[i]
        snin[h] = sn[i]
        h=h+1
    endfor
endfor

max_scale=400
min_scale=-400

set_plot, 'ps'
device, filename='velocity_rad.eps', /encapsul, /color, BITS=8
display_pixels, xin, yin, vin, PIXELSIZE=1, RANGE=[min_scale, max_scale];, _EXTRA=POSITION[0.05,0.05,0.8,0.95]sauron_colormap
color_bar_y, max(xbin)+5, max(xbin)+6, !Y.crange[0],!y.crange[1],min_scale,max_scale,title='V [km/s]'

set_plot, 'ps'
device, filename='sigma_rad.eps', /encapsul, /color, BITS=8
display_pixels, xin, yin, sigin, PIXELSIZE=1, RANGE=[min(sigma)/1.1, max(sigma)*1.1];, _EXTRA=POSITION[0.05,0.05,0.8,0.95]sauron_colormap
color_bar_y, max(xbin)+5, max(xbin)+6, !Y.crange[0],!y.crange[1],0,400,title='Sigma [km/s]'

set_plot, 'ps'
device, filename='signal_noise_rad.eps', /encapsul, /color, BITS=8
display_pixels, xin, yin, snin, PIXELSIZE=1, RANGE=[0, max(sn)*1.1];, _EXTRA=POSITION[0.05,0.05,0.8,0.95]sauron_colormap
color_bar_y, max(xbin)+2, max(xbin)+3, !Y.crange[0],!y.crange[1],0,max(sn)*1.1,title='S/N'

device,/close

endif


end