pro fundamental_plane

label = strarr(20)
r_e = fltarr(20)
mag = fltarr(20)
dispersion = fltarr(20)

label[0] = '1027 main'
r_e[0] = 4.641871
mag[0] = 15.04584
dispersion[0] = 1020

;label[1] = '1027 comp'
;r_e[1] = 1.059312
;mag[1] = 17.32379
;dispersion[1] = 0

label[2] = '1042 main'
r_e[2] = 4.432619
mag[2] = 15.30906
dispersion[2] = 857

label[3] = '1048 main'
r_e[3] = 6.099069
mag[3] = 14.93839
dispersion[3] = 828

;label[4] = '1048 comp'
;r_e[4] = 2.057725
;mag[4] = 16.12447
;dispersion[4] = 

;label[5] = '1048 comp'
;r_e[5] = 3.505275
;mag[5] = 16.25722
;dispersion[5] = 

label[6] = '1050 main'
r_e[6] = 6.291864
mag[6] = 13.94314
;dispersion[6] = 371.8116
dispersion[6] = 514

;label[7] = '1066 main'
;r_e[7] = 7.033243
;mag[7] = 14.98288
;dispersion[7] = 

label[8] = '1066 comp'
r_e[8] = 7.229138
mag[8] = 14.922091
dispersion[8] = 249

;label[9] = '1066 comp'
;r_e[9] = 0.7481485
;mag[9] = 19.13939
;dispersion[9] = 

label[10] = '1067 main'
r_e[10] = 2.636639
mag[10] = 16.27434
;dispersion[10] = 189.2718
dispersion[10] = 208

label[11] = '1153 main'
r_e[11] = 3.107662
mag[11] = 15.57647
dispersion[11] = 295

label[12] = '1261 main'
r_e[12] = 3.343759
mag[12] = 16.20052
dispersion[12] = 520

;label[13] = '1261 comp'
;r_e[13] = 2.886154
;mag[13] = 19.36363
;dispersion[13] = 

label[14] = '2001 main'
r_e[14] = 11.94404
mag[14] = 13.49922
dispersion[14] = 695

;label[15] = '2001 comp'
;r_e[15] = 21.75893
;mag[15] = 17.48413
;dispersion[15] = 

label[16] = '2039 main'
r_e[16] = 6.306086
mag[16] = 14.33879
dispersion[16] = 505

;label[17] = '2039 comp'
;r_e[17] = 21.75893
;mag[17] = 17.48413
;dispersion[17] = 

label[18] = '2086 main'
r_e[18] = 4.629934
mag[18] = 15.33398
;dispersion[18] = 271.6089
dispersion[18] = 599

;label[19] = '2086 comp'
;r_e[19] = 0.7102907
;mag[19] = 18.81232
;dispersion[19] = 

r_e = r_e[where(r_e ne 0)]
mag = mag[where(mag ne 0)]
dispersion = dispersion[where(dispersion ne 0)]

print,'alog10(r_e*(mag^0.8))',0.8*alog10(r_e*(mag))
print,'(r_e - ((0.8/2.5)*mag))',(r_e - ((0.8/2.5)*mag))

plot, alog10(dispersion), (r_e - ((0.8/2.5)*mag)), psym = 4

end