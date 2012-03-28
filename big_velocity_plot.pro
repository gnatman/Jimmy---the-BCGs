;#############################################################################
;
; Last updated by Jimmy
; E-mail: jimmy@physics.tamu.edu
; 
; Updated versions of the software are available from my web page
; http://galaxies.physics.tamu.edu/
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
;   BIG_VELOCITY_PLOT
;
; PURPOSE:
;	This code makes pretty plots to display results after data has been binned
;	and run through PPXF.  Used for writing my paper, it will show the velocities
;	of all galaxies at one time in one figure.
;
; INPUT PARAMETERS:
;
;
; TYPES:
;   vbinned: Binned by Voronoi Method
;   one: Everything binned together into one bin.
;   rad: Data is binned radially, currently not very useful.
;
; ENVIRONMENTAL VARIABLES:
;	If called by a bash script, the following variables must be defined in the bash
;	script that called this program.
;
;
;
; OUTPUT:
;   Encapsulated Postscript file.
;
; NOTES:
;
;
;--------------------------------
;
; LOGICAL PROGRESSION OF IDL CODE:
;	1.
;	2.
;	3.
;
;--------------------------------
;
; REQUIRED ROUTINES:
;       ;IDL Astronomy Users Library: http://idlastro.gsfc.nasa.gov/
;		;Voronoi Binning optional file by Michele Cappellari http://www-astro.physics.ox.ac.uk/~mxc/idl/
;		;set_colours.pro Written by Rob Sharp, Australian Astronomical Observatory
;
; MODIFICATION HISTORY:
;   V0.1 -- Created by Jimmy, 2012
;
;----------------------------------------------------------------------------

pro big_velocity_plot

sauron_colormap

testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)

!P.Multi = [0, 3, 4, 0, 0]

galaxy_names= [ '1027', '1042', '1048', '1050', '1066', '1067','1153', '1261', '2001', '2039', '2086']
plot_names=[ 'velocity', 'dispersion', 'sn' ]

for j=0, n_elements(plot_names)-1 do begin
print,plot_names[j]

set_plot, 'ps'
device, filename='big_'+plot_names[j]+'.eps', /encapsul, /color, BITS=8

for i=0, n_elements(galaxy_names)-1 do begin
	galaxy=galaxy_names[i]

	print,'galaxy: ',galaxy, plot_names[j]

	if (testing ne 1) then begin
		;read in the requisite files, and expected redshift from the environmental variables.
		rdfloat, '/Users/jimmy/Astro/reduced/'+galaxy+'pro/all/voronoi_2d_bins.txt', xbin, ybin,sn,NPix, SKIPLINE=1              ;2d_bins
		rdfloat, '/Users/jimmy/Astro/reduced/'+galaxy+'pro/all/ppxf_v_bin_output', bin,V,v_sig,sigma,sigma_sig,h3,h4,h5,h6,Chi2,z ;bin_output
		rdfloat, '/Users/jimmy/Astro/reduced/'+galaxy+'pro/all/voronoi_2d_binning_output.txt', x, y, xpix, ypix, binNum, SKIPLINE=1        ;2d_binning_output
	endif

	if (testing) then begin
		;read in the requisite files, and expected redshift from the environmental variables.
		rdfloat, getenv('infile1'), xbin, ybin,sn,NPix, SKIPLINE=1              ;2d_bins
		rdfloat, getenv('infile2'), bin,V,v_sig,sigma,sigma_sig,h3,h4,h5,h6,Chi2,z ;bin_output
		rdfloat, getenv('infile3'), x, y, xpix, ypix, binNum, SKIPLINE=1        ;2d_binning_output
	endif

	max_scale=(max(V)*1.2)+100
	min_scale=(min(V)*1.2)-100

	;default
		xmod = 0
		ymod = 0
		bcg_center_x = 0
		bcg_center_y = 0
		companion = 'n'
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0
		bottomAxisLoc = 0
		rightAxesLoc = 0.5
		topAxesLoc = 1
		pixelsize=1

	if galaxy eq '1027' then begin
		xmod = -3
		ymod = -0.8
		bcg_center_x = 8.95
		bcg_center_y = -7.45
		companion='y'
		comp_center_x = 1
		comp_center_y = 1.15
		xmin = -7
		xmax = 18
		ymin = -15
		ymax = 10
		leftAxisLoc = 0.05
		bottomAxisLoc = 0.8
		rightAxesLoc = 0.45
		topAxesLoc = 1.0
	endif
	if galaxy eq '1042' then begin
		xmod = -2
		ymod = 0
		bcg_center_x = -4.9
		bcg_center_y = 3.05
		companion='y'
		comp_center_x = 0.4
		comp_center_y = 0.5
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0.05
		bottomAxisLoc = 0.6
		rightAxesLoc = 0.45
		topAxesLoc = 0.8
	endif
	if galaxy eq '1048' then begin
		xmod = 0
		ymod = 0
		bcg_center_x = 0
		bcg_center_y = 0
		companion = 'n'
		xmin = -13
		xmax = 12
		ymin = -15
		ymax = 10
		leftAxisLoc = 0.05
		bottomAxisLoc = 0.4
		rightAxesLoc = 0.45
		topAxesLoc = 0.6
	endif
	if galaxy eq '1050' then begin
		xmod = -8
		ymod = 0.5
		bcg_center_x = -1.2
		bcg_center_y = -0.2
		companion = 'n'
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0.05
		bottomAxisLoc = 0.2
		rightAxesLoc = 0.45
		topAxesLoc = 0.4
	endif
	if galaxy eq '1066' then begin
		xmod = -3
		ymod = -1
		bcg_center_x = -5.05
		bcg_center_y = 5.55
		companion='y'
		comp_center_x = 2.2
		comp_center_y = -3.6
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0.05
		bottomAxisLoc = 0
		rightAxesLoc = 0.45
		topAxesLoc = 0.2
	endif
	if galaxy eq '1153' then begin
		xmod = -0.6
		ymod = 0.75
		bcg_center_x = 0.15
		bcg_center_y = 1.5
		companion = 'n'
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0.40
		bottomAxisLoc = 0.8
		rightAxesLoc = 0.85
		topAxesLoc = 1.0
		;pixelsize=0.5
	endif
	if galaxy eq '1261' then begin
		xmod = -0.6
		ymod = 0.75
		bcg_center_x = 0.15
		bcg_center_y = 1.5
		companion = 'n'
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0.55
		bottomAxisLoc = 0.6
		rightAxesLoc = 0.95
		topAxesLoc = 0.8
	endif
	if galaxy eq '2001' then begin
		xmod = 0
		ymod = 0
		bcg_center_x = -3.83
		bcg_center_y = 2.85
		companion='n'
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0.55
		bottomAxisLoc = 0.4
		rightAxesLoc = 0.95
		topAxesLoc = 0.6
	endif
	if galaxy eq '2039' then begin
		xmod = -0.6
		ymod = 0.75
		bcg_center_x = 0.15
		bcg_center_y = 1.5
		companion = 'n'
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0.55
		bottomAxisLoc = 0.2
		rightAxesLoc = 0.95
		topAxesLoc = 0.4
	endif
	if galaxy eq '2086' then begin
		xmod = -2
		ymod = 0
		bcg_center_x = -4.9
		bcg_center_y = 3.05
		companion='y'
		comp_center_x = 0.4
		comp_center_y = 0.5
		xmin = -13
		xmax = 12
		ymin = -13
		ymax = 12
		leftAxisLoc = 0.55
		bottomAxisLoc = 0
		rightAxesLoc = 0.95
		topAxesLoc = 0.2
	endif


		;xmin = -13
		;xmax = 12
		;ymin = -13
		;ymax = 12

	title_x_position = max(xbin)+xmod
	title_y_position = max(ybin)+ymod

	;Sarah's graph scales, used to directly compare my results to hers.
	max_scale=400
	min_scale=-400

	
	;!P.REGION=[0,0,0.5,1]
	!X.MARGIN=[0,100]
	!X.OMARGIN=[10,50]
	
	if plot_names[j] eq 'velocity' then begin
	display_bins, xbin, ybin, V, x,y, PIXELSIZE=pixelsize, RANGE=[min_scale, max_scale], XRANGE=[xmin,xmax], YRANGE=[ymin,ymax], XMARGIN=[0,0], XOMARGIN=[100,10];, REGION=[leftAxisLoc, bottomAxisLoc, rightAxesLoc, topAxesLoc];, TITLE='Velocity', CHARSIZE=2.3, CHARTHICK=7
	;color_bar_y, xmax+1.25, xmax+2.25, !Y.crange[0],!y.crange[1],min_scale,max_scale,title='km/s';, CHARSIZE=2, CHARTHICK=7
	if galaxy eq '1048' then begin
		xyouts, xmin+0.5, ymin+20, galaxy;, CHARSIZE=2.3, CHARTHICK=10
	endif else begin
		xyouts, xmin+0.5, ymin+0.5, galaxy;, CHARSIZE=2.3, CHARTHICK=10
	endelse
	;xyouts, bcg_center_x, bcg_center_y, '!9B!3', CHARSIZE=2, CHARTHICK=12
	;if (companion eq 'y') then begin
	;	xyouts, comp_center_x, comp_center_y, '+', CHARSIZE=2, CHARTHICK=12
	;endif
	endif
	
	if plot_names[j] eq 'dispersion' then begin
	display_bins, xbin, ybin, sigma, x,y, PIXELSIZE=pixelsize, RANGE=[0, 550], XRANGE=[xmin,xmax], YRANGE=[ymin,ymax], XMARGIN=[0,0], XOMARGIN=[100,10];, TITLE='Dispersion', CHARSIZE=2.3, CHARTHICK=7
	;color_bar_y, xmax+1.25, xmax+2.25, !Y.crange[0],!y.crange[1],0,550,title='km/s';, CHARSIZE=2, CHARTHICK=7
	if galaxy eq '1048' then begin
		xyouts, xmin+0.5, ymin+20, galaxy;, CHARSIZE=2.3, CHARTHICK=10
	endif else begin
		xyouts, xmin+0.5, ymin+0.5, galaxy;, CHARSIZE=2.3, CHARTHICK=10
	endelse	;xyouts, bcg_center_x, bcg_center_y, '!9B!3', CHARSIZE=2, CHARTHICK=12
	;if (companion eq 'y') then begin
	;	xyouts, comp_center_x, comp_center_y, '+', CHARSIZE=2, CHARTHICK=12
	;endif
	endif

	if plot_names[j] eq 'sn' then begin
	display_bins, xbin, ybin, sn, x,y, PIXELSIZE=pixelsize, RANGE=[3, max(sn)*1.1], XRANGE=[xmin,xmax], YRANGE=[ymin,ymax], XMARGIN=[0,0], XOMARGIN=[100,10];, TITLE='Signal/Noise', CHARSIZE=2.3, CHARTHICK=7
	;color_bar_y, xmax+1.25, xmax+2.25, !Y.crange[0],!y.crange[1],3,max(sn)*1.1,title='S/N';, CHARSIZE=2, CHARTHICK=7
	if galaxy eq '1048' then begin
		xyouts, xmin+0.5, ymin+20, galaxy;, CHARSIZE=2.3, CHARTHICK=10
	endif else begin
		xyouts, xmin+0.5, ymin+0.5, galaxy;, CHARSIZE=2.3, CHARTHICK=10
	endelse	;xyouts, bcg_center_x, bcg_center_y, '!9B!3', CHARSIZE=2, CHARTHICK=12
	;if (companion eq 'y') then begin
	;	xyouts, comp_center_x, comp_center_y, '+', CHARSIZE=2, CHARTHICK=12
	;endif 
	endif

	
endfor
loadct,0
plot, [0,1], [0,1], /NODATA, color=255, xmargin=[5,0]
sauron_colormap
if plot_names[j] eq 'velocity' then begin
color_bar_y, 0, 0.1, !Y.crange[0],!y.crange[1],min_scale,max_scale,title='km/s';, CHARSIZE=2, CHARTHICK=7
endif
if plot_names[j] eq 'dispersion' then begin
color_bar_y, 0, 0.1, !Y.crange[0],!y.crange[1],0,550,title='km/s';, CHARSIZE=2, CHARTHICK=7
endif
if plot_names[j] eq 'sn' then begin
color_bar_y, 0, 0.1, !Y.crange[0],!y.crange[1],3,max(sn)*1.1,title='S/N';, CHARSIZE=2, CHARTHICK=7
endif
device,/close
endfor

!P.Multi = 0
end
