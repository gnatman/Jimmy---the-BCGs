pro jimmy_lambda_v_m

loadct, 4
;sauron_colormap
set_plot, 'ps'
device, filename='lambda_v_mass.eps', /encapsul, /color, BITS=8 ;, SET_CHARACTER_SIZE=[270,190]

label = [ 'BCG 1050', 'BCG 1027', 'BCG 1066', 'BCG 2086', 'BCG 2001', 'BCG 1153' ] 
lambda = [ 0.124, 0.150, 0.164, 0.144, 0.179, 0.240 ]
m_dyn = [ 12.08, 11.85, 11.88, 11.82, 11.25, 11.87 ]
label_comp = [ 'Comp 1027', 'Comp 1066', 'Comp 2086' ] 
lambda_comp = [ 0.272, 0.483, 0.11 ]
m_dyn_comp = [ 11.6, 11.6, 11.06 ]
sarah_lambda = [ 0.113958, 0.112633, 0.346064, 0.256023, 0.715347, 0.103441 ]
sarah_m_dyn = [ 12.2, 11.8, 11.57, 11.84, 11.85, 11.78, 11.15 ]

;Window,1,XSIZE=1200,YSIZE=700

usersym, [ -1, 1, 1, -1, -1 ], [ 1, 1, -1, -1, 1 ], /fill

plot, m_dyn, lambda, PSYM=4, yrange=[0,0.8], xrange = [9.8,12.5], CHARSIZE = 1.5, CHARTHICK = 7, ythick = 5, xthick = 5 ; XTITLE='!3Log (M!Ddyn!N[M!D!9n!X!N])', YTITLE='!4k!D!3R!Le',
oplot, m_dyn, lambda, PSYM=8, COLOR = 180, symsize = 1.2
oplot, m_dyn_comp, lambda_comp, PSYM=1, COLOR = 180, symsize = 1.2, thick = 10
m_dyn[0] = m_dyn[0]+0.05
m_dyn[1] = m_dyn[1]+0.05
m_dyn[2] = m_dyn[2]+0.05
m_dyn[3] = m_dyn[3]-0.7
m_dyn[4] = m_dyn[4]-0.25
m_dyn[5] = m_dyn[5]+0.05
lambda[0] = lambda[0]-0.01
lambda[1] = lambda[1]-0
lambda[2] = lambda[2]+0.02
lambda[3] = lambda[3]-0.025
lambda[4] = lambda[4]+0.02
lambda[5] = lambda[5]
;xyouts, m_dyn, lambda, label, CHARSIZE = 1.2, CHARTHICK = 4, COLOR = 180

;oplot, sarah_m_dyn, sarah_lambda, PSYM=6, color=100
;xyouts, sarah_m_dyn+0.02, sarah_lambda-0.005, label, color=100, CHARSIZE = 1

readcol,'/Users/jimmy/Astro/Supporting\ Documents/SAURON_Data_Fig7_LR_MB_Mvir_core.txt', F='A,F,F,F,A', dummy1, sauron_lambda, dummy2, sauron_m_dyn, dummy3

USERSYM, [0,1,0,-1],[-1,0,1,0],/FILL


oplot, sauron_m_dyn, sauron_lambda, PSYM=5, symsize = 1.2, thick=2

device,/close

file_move,'lambda_v_mass.eps','Downloads/lambda_v_mass.eps', /OVERWRITE

end