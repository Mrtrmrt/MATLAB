function [Bpolr, Bpolz] = poloidal_field_2(radius, R_r, Z_z, I, h)
global E
%функция расчета полоидального поля от тока в плазме

k2_0=(4*radius*abs(R_r))./((abs(R_r)+radius).^2+(Z_z-h).^2);
     [i1,i2]=find(k2_0>1);
     k2_0(i1,i2)=round(k2_0(i1,i2));
     [K,E]=ellipke(k2_0);
     
     %полоидальное поле от тока в проводнике
     Bpolr = -2e-7.*sign(R_r)*I.*((Z_z-h)./(abs(R_r).*sqrt((abs(R_r)+radius).^2+(Z_z-h).^2))).*(K-E.*((abs(R_r).^2+radius^2+(Z_z-h).^2)./((abs(R_r)-radius).^2+(Z_z-h).^2)));
     Bpolz = 2e-7.*I.*(1./sqrt((abs(R_r)+radius).^2+(Z_z-h).^2)).*(K-E.*((abs(R_r).^2-radius^2+(Z_z-h).^2)./((abs(R_r)-radius).^2+(Z_z-h).^2)));
     
     %clear K E;
     
     %Bpolr = 
     %Bpolr = 
end