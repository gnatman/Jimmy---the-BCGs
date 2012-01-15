pro one_bin

rdfloat, getenv('infile'), x, y, xpix, ypix, signal, noise,SKIPLINE=1
;rdfloat, '/Users/jimmy/Astro/reduced/1050pro/voronoi_2d_binning.txt', x, y, xpix, ypix, signal, noise,SKIPLINE=1


file_size = size(x)

number_of_elements = file_size[1]

;print,'number_of_elements',number_of_elements

xnew = x
ynew = y
xpixnew = xpix
ypixnew = ypix
binNum = fltarr(number_of_elements)
xNode = 0
yNode = 0
sn = (total(signal)/total(noise))*sqrt(number_of_elements)
nPixels = number_of_elements
total_noise = total(noise)/sqrt(number_of_elements)

astrolib
;forprint, xnew, ynew, xpixnew, ypixnew, binNum, TEXTOUT='/Users/jimmy/Astro/reduced/1050pro/one_bin_output.txt', $
forprint, xnew, ynew, xpixnew, ypixnew, binNum, TEXTOUT=getenv('outfile1'), $
    COMMENT='#         X"          Y"          Xpix          Ypix          BIN_NUM'

;forprint, xNode, yNode, sn, nPixels, total_noise, TEXTOUT='/Users/jimmy/Astro/reduced/1050pro/one_bin_bins.txt', $
forprint, xNode, yNode, sn, nPixels, total_noise, TEXTOUT=getenv('outfile2'), $
    COMMENT='#         Xbin          Ybin          S/N     Num Pixels        Total Noise'

end