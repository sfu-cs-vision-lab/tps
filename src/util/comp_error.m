function [distance angular] = comp_error(esti,real)

real_r = real(:,1);
real_g = real(:,2);
real_b = real(:,3);
P_r = esti(:,1);
P_g = esti(:,2);
P_b = esti(:,3);

distance = sqrt((P_r - real_r).^2 + (P_g - real_g).^2);
        
angular_value = ((P_r .* real_r) + (P_g .* real_g) + (P_b .* real_b)) ./ (sqrt(real_r .* real_r + real_g .* real_g + real_b .* real_b).* sqrt(P_r.*P_r+P_g.*P_g+P_b.*P_b));
angular = (acos(angular_value) * 360)/(2*3.14);