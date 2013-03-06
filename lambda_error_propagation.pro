;rad = 2
;vel = -5
;disp = 3
;vel_error=2
;disp_error=2
;lambda_error = sqrt( ( (vel_error^2)*(((rad*vel)/(rad*abs(vel)*sqrt((vel^2)+(disp^2))) ) - (rad*vel*abs(vel))/(rad*(((vel^2)+(disp^2))^3/2)))^2)+(((disp_error)^2)*((rad*vel*abs(vel))/(rad*(((vel^2)*(disp^2))^3/2)))) )
;lambda_error2 = sqrt( ( (vel_error^2)*(((rad*vel)/(rad*abs(vel)*sqrt((vel^2)+(disp^2))) ) - ((rad*vel*abs(vel))/(rad*(((vel^2)+(disp^2))^3/2))))^2 )+(((disp_error)^2)*((rad*vel*abs(vel))/(rad*(((vel^2)*(disp^2))^3/2)))) )
;lambda_error =  sqrt( ( (vel_error^2) * (((rad*vel) / (rad*abs(vel)*sqrt((vel^2)+(disp^2)))) - ((rad*vel*abs(vel)) / (rad*(((vel^2)+(disp^2))^3/2))))^2 ) + ( ((disp_error)^2) * ((rad*vel*abs(vel)) / (rad*(((vel^2)*(disp^2))^3/2)))^2) )

pro lambda_error_propagation
arc_radius = 2
velocity = -5
dispersion = 3
velocity_error = 2
dispersion_error = 2

v_sig_squared = velocity_error^2
v_squared = velocity^2
sig_sig_squared = dispersion_error^2
sig_squared = dispersion^2

v_sig_left_numerator = arc_radius*velocity
v_sig_left_denominator = arc_radius*abs(velocity)*sqrt(v_squared+sig_squared)
v_sig_left = v_sig_left_numerator/v_sig_left_denominator

v_sig_right_numerator = arc_radius*abs(velocity)*velocity
v_sig_right_denominator = arc_radius*(sqrt(v_squared+sig_squared))^3
v_sig_right = v_sig_right_numerator/v_sig_right_denominator

sig_sig_mess_numerator = arc_radius*abs(velocity)*velocity
sig_sig_mess_denominator = arc_radius*(sqrt(v_squared+sig_squared))^3
sig_sig_mess = sig_sig_mess_numerator/sig_sig_mess_denominator

v_sig_mess = v_sig_left - v_sig_right
first = v_sig_squared*(v_sig_mess^2)
second = sig_sig_squared*(sig_sig_mess^2)
lambda_error = sqrt( first + second )
lambda_error2 = sqrt( ((velocity_error^2)*((((arc_radius*velocity)/(arc_radius*abs(velocity)*sqrt((velocity^2)+(dispersion^2)))) - ((arc_radius*abs(velocity)*velocity)/(arc_radius*(sqrt((velocity^2)+(dispersion^2)))^3)))^2)) + ((dispersion_error^2)*(((arc_radius*abs(velocity)*velocity)/(arc_radius*(sqrt((velocity^2)+(dispersion^2)))^3))^2)) )


print,'v_sig_squared', v_sig_squared
print,'v_squared', v_squared
print,'sig_sig_squared',sig_sig_squared
print,'sig_squared',sig_squared
print,'v_sig_left_numerator',v_sig_left_numerator
print,'v_sig_left_denominator',v_sig_left_denominator
print,'v_sig_left',v_sig_left
print,'v_sig_right_numerator',v_sig_right_numerator
print,'v_sig_right_denominator',v_sig_right_denominator
print,'v_sig_right',v_sig_right
print,'sig_sig_mess_numerator',sig_sig_mess_numerator
print,'sig_sig_mess_denominator',sig_sig_mess_denominator
print,'sig_sig_mess',sig_sig_mess
print,'v_sig_mess',v_sig_mess
print,'first',first
print,'second',second
print,'lambda_error',lambda_error
print,'lambda_error2',lambda_error2


;answer = 0.268

end