function F = motion(t,Y);
global zi 
%переменные для расчета магнитных полей
R0 = 1.48; %большой радиус токамака
a  = 0.67; %координата по z полоидально катушки
h0 = 0;
I_plasma=2e6;%ток в плазме

%токи в катушках полоидального поля
I1 = 15e3*100; %ОУ1
I2 = -12e3*100; %ОУ2
I3 = -15.5e3*48;%ОУ3
I4 = -17e3*60;%ОУ4
I5 = -17e3*80;%ОУ5
I6 = 20.5e3*432;%ОУ6

%составляющие ускоряющего поля
Ex = -60e3;
Ey = 0;
Ez = 0;

B_0=2;%тороидальное поле на оси плазменного шнура

%радиусы катушек полоидального поля
r1 = 1119.6164e-3;%ОУ1
r2 = 2619.4019e-3;%ОУ2
r3 = 3359.4316e-3;%ОУ3
r4 = 3571.02916e-3;%ОУ4
r5 = 2939.60821e-3;%ОУ5
r6 = 885.9899e-3;%ОУ6

%координата z полоидальных катушек
h1 = 2342.209064e-3;%высота первых катушек
h2 = 2119.453e-3;%высота вторых катушек
h3 = 946.8405e-3;%высота третьих катушек
h4 = -893.5961e-3;
h5 = -2373.480014e-3;
h6 = -2883.8386e-3;

%границы расчета
%задание шага
step=0.1;
     zmin=-7;
     zmax=7;
     rmin=0;
     rmax=7;
     
     xmin=0;
     xmax=7;
     ymin=0;
     ymax=7;     
     
     %создаем сетку
     [X1,Y1,Z1]=meshgrid(xmin:step:xmax,ymin:step:ymax,zmin:step:zmax);
     %[X,Y]=meshgrid(xmin:step:xmax,ymin:step:ymax);
     r=sqrt(X.^2+Y.^2);
     %theta=atan(Y./X);
     [THETA, R1, Z1]= cart2pol(X1,Y1,Z1);
     %[R,Z] = meshgrid (rmin:step:rmax,zmin:step:zmax);
     
     %полоидальное поле от тока в плазме
     [Bpolr_0, Bpolz_0] = poloidal_field_2(R0, R1, Z1, I_plasma, h0);
      
     %поле от тока в полоидальной катушке 1
	 [Bpolr_1,Bpolz_1] = poloidal_field_2(r1, R1, Z1, I1, h1);
	 
	 %поле от тока в полоидальной катушке 2
	 [Bpolr_2,Bpolz_2] = poloidal_field_2(r2, R1, Z1, I2, h2);
	 
	 %поле от тока в полоидальной катушке 3
	 [Bpolr_3,Bpolz_3] = poloidal_field_2(r3, R1, Z1, I3, h3);
	 
	 %поле от тока в полоидальной катушке 4
	 [Bpolr_4,Bpolz_4] = poloidal_field_2(r4, R1, Z1, I4, h4);
	 
	 %поле от тока в полоидальной катушке 5
	 [Bpolr_5,Bpolz_5] = poloidal_field_2(r5, R1, Z1, I5, h5);
	 
	 %поле от тока в полоидальной катушке 6
	 [Bpolr_6,Bpolz_6] = poloidal_field_2(r6, R1, Z1, I6, h6);
     
     %суммма составляющих
	 Bpolr = Bpolr_0+Bpolr_1+Bpolr_2+Bpolr_3+Bpolr_4+Bpolr_5+Bpolr_6;
	 Bpolz = Bpolz_0+Bpolz_1+Bpolz_2+Bpolz_3+Bpolz_4+Bpolz_5+Bpolz_6;
     
     %перейдем в декартову систему координат
     Bpolx=Bpolr.*cos(THETA);
	 Bpoly=Bpolr.*sin(THETA);
	 Bpolz=Bpolz;
     
     %задаем вектор начальных условий
     x=Y(1);
     y=Y(2);
     z=Y(3);
     Vx=Y(4);
   	 Vy=Y(5);
     Vz=Y(6);
     
     f1=zi*e/M*(Ex+Bpolz.*Y(5)-Bpoly.*Y(6)); %проекция на x
     f2=zi*e/M*(Ey+Bpolx.*Y(6)-Bpolz.*Y(4)); %проекция на y
     f3=zi*e/M*(Ez+Bpoly.*Y(4)-Bpolx.*Y(5)); %проекция на z
     f4=Y(4);
     f5=Y(5);
     f6=Y(6);
    
  
     F=[f1;  f2;  f3;  f4;  f5;  f6]; %f1; f2; f3;
end
    
   