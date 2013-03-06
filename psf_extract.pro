pro psf_extract,galaxy,xpos,ypos,xpsf,ypsf

xmin = xpos-16
ymin = ypos-16
xmax = xpos+16
ymax = ypos+16
;xpsf=1027
;ypsf=725

galfit_image = mrdfits('/Users/jimmy/Astro/sdss/'+galaxy+'/galfit_psf.fits',2,header0)

psf_image = fltarr(xmax-xmin, ymax-ymin)

for x=xmin, xmax-1 do begin
	for y=ymin, ymax-1 do begin
		psf_image[x-xmin,y-ymin] = galfit_image[x,y]
	endfor
endfor

spawn,'xy2sky -d /Users/jimmy/Astro/sdss/'+galaxy+'/drC-001729-r3-0022.fits xpsf ypsf',coords
xy = strsplit(coords, /EXTRACT)
print,float(xy[0]),float(xy[1])
;print, ind
;print, xy[0], xy[1]

mwrfits,psf_image,'/Users/jimmy/Astro/sdss/'+galaxy+'/psf.fits',/create
head=headfits('/Users/jimmy/Astro/sdss/'+galaxy+'/psf.fits')
sxaddpar,head,'RA_TARG',float(xy[0])
sxaddpar,head,'DEC_TARG',float(xy[1])
mwrfits,psf_image,'/Users/jimmy/Astro/sdss/'+galaxy+'/psf.fits',head,/create

end