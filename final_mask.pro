pro final_mask,target,mask

;By reading in a list of fibers to set to zero, we can mask one portion of the final data cube.

testing=0 ;Set to 0 if you want to be in "testing" mode, where more output is displayed, and files are split up, so they can be more easily examined, also paths are then hard coded.
testing_string=getenv('not_testing')
testing=FIX(testing_string)

if (testing) then begin
    dir=getenv('infile1')
endif

if (testing ne 1) then begin
    dir='/Users/jimmy/Astro/reduced/'+target+'pro/'+mask+'/'
endif

im=mrdfits(dir+'temp.fits',0,header0) ;, /SILENT)
var=mrdfits(dir+'temp.fits',1,header0) ;, /SILENT)

imsize=size(im)
x_size=imsize[1]
y_size=imsize[2]

crval=fxpar(header0,'CRVAL3')
crpix=fxpar(header0,'CRPIX3')
cdelt=fxpar(header0,'CDELT3')

;DS9 counts from 1, IDL counts from 0

;SET BAD FIBERS TO ZERO
;Done by importing a column list of bad fibers (with a 0 at the end to keep the loop from freaking out)

if (testing ne 1) then begin
    readcol,'/Users/jimmy/Astro/reduced/'+target+'sof/'+mask+'_mask.txt',F='F,F',mask_x,mask_y
endif

if (testing) then begin
    readcol,getenv('final_mask'),F='F,F',mask_x,mask_y
endif

mask_size=size(mask_x)

;Actual masking process
for i=0,mask_size[1]-1 do begin
        im[mask_x[i]-1,mask_y[i]-1,*]=0.0
endfor

im_2d=fltarr(x_size,y_size)

for i=0,x_size-1 do begin
    for j=0,y_size-1 do begin
        total = total(im[i,j,*])
        im_2d[i,j] = total
        if ( total le 0.0 ) then begin
            im_2d[i,j] = 0.0
        endif
    endfor
endfor


;WRITE OUT THE CUBE
;Done using standard idl file writes

if (testing) then begin
    fileout=dir+mask+'/'+target+mask+'.fits'
    fileout_var=dir+mask+'/'+target+mask+'_var.fits'
    fovout=dir+mask+'/'+target+mask+'_fov.fits'
endif
if (testing ne 1) then begin
    fileout='/Users/jimmy/Downloads/temp.fits'
    fileout_var='/Users/jimmy/Downloads/temp_var.fits'
    fovout='/Users/jimmy/Downloads/temp_fov.fits'
endif

mwrfits,im,fileout,create=1 ;/create=1 creates new file even if old one exists
mwrfits,im_2d,fovout,create=1

;reads header from newly created file to ensure proper header writting
head=headfits(fileout)

;add important header properties
sxaddpar,head,'CRVAL3',crval
sxaddpar,head,'CRPIX3',crpix
sxaddpar,head,'CDELT3',cdelt

;write over former cube with new header
mwrfits,im,fileout,head,create=1
mwrfits,im_2d,fovout,head,create=1

;add as new extension variance array
mwrfits,var,fileout,head,create=0
mwrfits,var,fileout_var,head,create=1


end
