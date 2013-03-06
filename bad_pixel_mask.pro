pro bad_pixel_mask,galaxy,xmin,xmax,ymin,ymax

seg_image = mrdfits('/Users/jimmy/Astro/sdss/'+galaxy+'/segmentation.fits',0,header0)

imsize = size(seg_image)

mask_image = fltarr(imsize[1],imsize[2])
mask_image[*,*] = 1.0

;xmin = 1360
;xmax = 1440
;ymin = 700
;ymax = 800

for x=xmin, xmax-1 do begin
	for y=ymin, ymax-1 do begin
		if seg_image[x,y] ne 0 then begin
			mask_image[x,y] = 0
		endif
		if seg_image[x,y] eq 0 then begin
			mask_image[x,y] = 1
		endif
		;if seg_image[x,y] eq 349 then begin
		;	mask_image[x,y] = 1
		;endif
	endfor
endfor

mwrfits,mask_image,'/Users/jimmy/Astro/sdss/'+galaxy+'/bad_pixel_mask.fits',/create
head=headfits('/Users/jimmy/Astro/sdss/'+galaxy+'/bad_pixel_mask.fits')
mwrfits,mask_image,'/Users/jimmy/Astro/sdss/'+galaxy+'/bad_pixel_mask.fits',head,/create

end