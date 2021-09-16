%программа построения магнитных полей 
clear all
clc
close all
clear workspace

global zi e M Ex  Ey  Ez B0 R0 a r0 h T LR Bx By Bz E
global Btor_x Btor_y Btor_z

%глобальные токи
global I_plasma I1 I2 I3 I4 I5 I6

%глобальные геометрические характеристики
global a R0 r1 r2 r3 r4 r5 r6 h0 h1 h2 h3 h4 h5 h6 

%глобальные параметры сетки
global step zmin zmax rmin rmax r R Z
global xmin xmax ymin ymax X Y theta

R0=1.48;%большой радиус токамака
a=0.67;%малый радиус токамака
h0 = 0;

%ток в плазме
I_plasma=2e6;

%токи в катушках полоидального поля
I1=15e3*100; %ОУ1
I2=-12e3*100 ; %ОУ2
I3=-15.5e3*48 ;%ОУ3
I4=-17e3*60 ;%ОУ4
I5=-17e3*80 ;%ОУ5
I6=20.5e3*864;%ОУ6

%составляющие ускоряющего поля
Ex=60e3;
Ey=0;
Ez=0;

B_0=2;%тороидальное поле на оси плазменного шнура

%радиусы катушек полоидального поля
r1=1120/1000;%ОУ1
r2=2620/1000;%ОУ2
r3=3360/1000;%ОУ3
r4=3750/1000;%ОУ4
r5=2940/1000;%ОУ5
r6=990/1000;%ОУ6

%координата z полоидальных катушек
h1=2340e-3;%высота первых катушек 
h2=2120e-3;%высота вторых катушек 
h3=950e-3;%высота третьих катушек 
h4=-894e-3;
h5=-2352e-3;
h6=-2927e-3;

%задание шага
step=0.1;
     zmin=-7;
     zmax=7;
     rmin=-7;
     rmax=7;
     
     xmin=-7;
     xmax=7;
     ymin=-7;
     ymax=7;     
     
     [X,Y]=meshgrid(xmin:step:xmax,ymin:step:ymax);
     r=sqrt(X.^2+Y.^2);
     theta=atan(Y./X);
     [R,Z] = meshgrid (rmin:step:rmax,zmin:step:zmax);
  
     %поле от тока в плазме
     [Bpolr_0,Bpolz_0] = poloidal_field(R0, R, Z, I_plasma, h0);
     
     %поле от тока в полоидальной катушке 1;
     [Bpolr_1,Bpolz_1] = poloidal_field(r1, R, Z, I1, h1);
   
     %поле от тока в полоидальной катушке 2
     [Bpolr_2,Bpolz_2] = poloidal_field(r2, R, Z, I2, h2);
     
     %поле от тока в полоидальной катушке 3
     [Bpolr_3,Bpolz_3] = poloidal_field(r3, R, Z, I3, h3);
     
     %поле от тока в полоидальной катушке 4
     [Bpolr_4,Bpolz_4] = poloidal_field(r4, R, Z, I4, h4);
     
     %поле от тока в полоидальной катушке 5
     [Bpolr_5,Bpolz_5] = poloidal_field(r5, R, Z, I5, h5);
     
     %поле от тока в полоидальной катушке 6
     [Bpolr_6,Bpolz_6] = poloidal_field(r6, R, Z, I6, h6);
   
     Bpolr = Bpolr_0 + Bpolr_1+Bpolr_2+Bpolr_3+Bpolr_4+Bpolr_5+Bpolr_6;
     Bpolz = Bpolz_0 + Bpolz_1+Bpolz_2+Bpolz_3+Bpolz_4+Bpolz_5+Bpolz_6;
     
     %значение полного полоидального поля
     B=sqrt(Bpolr.^2+Bpolz.^2);
     
     %определение максимальных значений искомых полей
     B1=sqrt(Bpolr_1.^2+Bpolz_1.^2);
     Maximum_1 = max(max(B1));
     B2=sqrt(Bpolr_2.^2+Bpolz_2.^2);
     Maximum_2 = max(max(B2));
     B3=sqrt(Bpolr_3.^2+Bpolz_3.^2);
     Maximum_3 = max(max(B3));
     B4=sqrt(Bpolr_4.^2+Bpolz_4.^2);
     Maximum_4 = max(max(B4));
     B5=sqrt(Bpolr_5.^2+Bpolz_5.^2);
     Maximum_5 = max(max(B5));
     B6=sqrt(Bpolr_6.^2+Bpolz_6.^2);
     Maximum_6 = max(max(B6));
     Maximum = max(max(B));
    
     %переход в декартову систему координат
     %Bpolx=Bpolr.*cos(theta);
     %Bpoly=Bpolr.*sin(theta);
     %Bpolz=Bpolz;
     
     %суммарный вектор магнитной индукции
     %Bx = Bpolx + Btor_x
     %By = Bpoly + Btor_y
     %Bz = Bpolz + Btor_z
     
     %начальная скорость иона
     v0 = 8.6239e+03;
     %градиент поля B
     %B_grad = 
     %угол между векторами E и B
     alfa = atan(Bpolz/Bpolr);%*180/pi;
     
     %построение графиков
     figure(1);
     hold on;
     xlabel('r, м');
     ylabel('z, м');
     
     plot(R0,0,'or',-R0,0,'+r');%,a,-h/2,'+r',-a,-h/2,'or');
     
     plot(r1,h1,'or',-r1,h1,'+r');
     plot(r2,h2,'+r',-r2,h2,'or');
     plot(r3,h3,'+r',-r3,h3,'or');
     plot(r4,h4,'+r',-r4,h4,'or');
     plot(r5,h5,'+r',-r5,h5,'or');
     plot(r6,h6,'or',-r6,h6,'+r');
 
     
    
     h=streamslice(R,Z,Bpolr,Bpolz, 8);
     set(h,'Color','b');
     set(gca,'FontSize',14, 'FontName','Times New Roman');
     cc = -0.85:0.1:-0.1;
     %%for i =1:length(cc)
         %%g1 = streamline(R,Z,Bpolr,Bpolz, 1.48, cc(i));
         %%set(g1,'Color','k');
         %%g2 = streamline(R,Z,Bpolr,Bpolz, -1.48, cc(i));
         %%set(g2,'Color','k');
     %%end
     hold on
     %mark1 = plot(-6.135,0,'o');
     %set(mark1,'Linewidth',6,'Color','#D95319');
     %mark2 = plot(-6.135+10.4/1000,0,'o');
     %set(mark2,'Linewidth',6,'Color','#7E2F8E');
     %mark3 = plot(-6.135+2*10.4/1000,0,'o');
     %set(mark3,'Linewidth',6,'Color','#77AC30');
     %mark4 = plot(-6.135+3*10.4/1000,0,'o');
     %set(mark4,'Linewidth',6,'Color','#A2142F');
     hold on
     %quiver(-6.135,0, v0,0,1e-6,'k');
     grid;
     %axis([-6.14 -6.104 -0.01 0.01]);
     axis equal
     hold on;
     
     figure(2);%векторное поле
     hold on;
     shading flat;
     colormap('lines')
     xlabel('r');
     ylabel('z');
     plot(R0,0,'+r',-R0,0,'or');
     title(['Распределение магнитного поля от тока в плазме, I = ' ,num2str(I_plasma/1e6),' МА',' , ', 'I1= ' ,num2str(I1/1e3), 'кА']);
     quiver(R,Z,Bpolr,Bpolz,4,'b');
     plot(r1,h1,'+r',-r1,h1,'or');
     plot(r2,h2,'+r',-r2,h2,'or');
     plot(r3,h3,'+r',-r3,h3,'or');
     plot(r3,-h4,'+r',-r3,-h4,'or');
     plot(r2,-h5,'+r',-r2,-h5,'or');
     plot(r1,-h6,'+r',-r1,-h6,'or');
     grid;
     axis square;
     hold on;
     
     figure(3);
     hold on;
     contourf(R,Z,B0);
     shading flat;
     colormap('lines')
     xlabel('r');
     ylabel('z');
     plot(R0,0,'+r',-R0,0,'or');%,a,-h/2,'+r',-a,-h/2,'or');
     title(['Распределение магнитного поля от тока в плазме, I = ' ,num2str(I_plasma/1e6),' МА']);%,' , ', 'I_plasma= ' ,num2str(I1/1e3), 'кА']);
     quiver(R,Z,Bpolr_0,Bpolz_0,8,'w');
     %quiver(R,Z,Bpolr_1,Bpolz_1,5);
     %quiver(R,Z,Bpolr_2,Bpolz_2,5);
     %quiver(R,Z,Bpolr_3,Bpolz_3,5);
     %quiver(R,Z,Bpolr_4,Bpolz_4,5);
     %quiver(R,Z,Bpolr_5,Bpolz_5,5);
     %quiver(R,Z,Bpolr_6,Bpolz_6,5);
     shading flat;
     colormap('lines')
     grid;
     axis square;
     hold on;
     
     figure(4);%магнитные силовые линии
     hold on;
     xlabel('r, м');
     ylabel('z, м');
     
     plot(R0,0,'+r',-R0,0,'or');%,a,-h/2,'+r',-a,-h/2,'or');
     
     plot(r1,h1,'+r',-r1,h1,'or');
     plot(r2,h2,'+r',-r2,h2,'or');
     plot(r3,h3,'+r',-r3,h3,'or');
     plot(r4,-h4,'+r',-r4,-h4,'or');
     plot(r5,-h5,'+r',-r5,-h5,'or');
     plot(r6,-h6,'+r',-r6,-h6,'or');
     grid
     axis equal
     
     figure(5);%поле от тока в плазме
     hold on;
     plot(R0,0,'+r',-R0,0,'or');
     xlabel('r');
     ylabel('z');
     title(['Распределение магнитного поля от тока в плазме, I = ' ,num2str(I_plasma/1e6),' MA']);
     contour(R,Z,B0);
     h=streamslice(R,Z,Bpolr,Bpolz);
     set(h,'Color','b');
     grid;
     axis square;
     hold on;
     r=0.67;
        c1=[1.48 0];
        c2=[-1.48 0]
        pos1 = [c1-r 2*r 2*r];
        pos2 = [c2-r 2*r 2*r];
        rectangle('Position',pos1,'Curvature',[1 1]);
        rectangle('Position',pos2,'Curvature',[1 1]);
        xlim([-6,6]);
        ylim([-5,5]);
        
     figure(6)%тороидальное магнитное поле
     %hold on;
     %contourf(X,Y,Btor);
     %shading flat;
     %colormap('lines')
     %xlabel('x');
     %ylabel('y');
     %title('Распределение тороидального магнитного поля');
     %plot(0,0,'+r');
     %quiver(X,Y,Btorx,Btory,3,'w');
     %q=streamslice(X,Y,Btorx,Btory);
     %set(q,'Color','w');
     %grid
     %axis square;
     %hold on;
     
     %R_1=2.150;
     %r=0.81;
     %c1=[0 0];
     %pos1 = [c1-R_1 2*R_1 2*R_1];
     %pos2 = [c1-r 2*r 2*r];
     %rectangle('Position',pos1,'Curvature',[1 1]);
     %rectangle('Position',pos2,'Curvature',[1 1]);
     %axis square;
     %hold on;
     
         
     figure(7);
     hold on;
     plot(R0,0,'+r',-R0,0,'or');
     %quiver(R,Z,Bpolr,Bpolz,5);
     %title('Распределение магнитных силовых линий суммарного магнитного поля');
     xlabel('r, м');
     ylabel('z, м');
     hold on;
     f=streamslice(R,Z,Bpolr,Bpolz);
     set(f,'Color','r');
     %streamline(R,Z,Bpolr,Bpolz, 5, 0, 0.01);
     %streamline(R,Z,Bpolr,Bpolz, -5, 0, 0.01);
     
     %streamline(R,Z,Bpolr,Bpolz, 5.2, 0, 0.01);
     %streamline(R,Z,Bpolr,Bpolz, -5.2, 0, 0.01);
    
     %streamline(R,Z,Bpolr,Bpolz, 4.2, 0, 0.01);
     %streamline(R,Z,Bpolr,Bpolz, -4.2, 0, 0.01);
    
     %streamline(R,Z,Bpolr,Bpolz, 4.5, 0, 0.005);
     %streamline(R,Z,Bpolr,Bpolz, -4.5, 0, 0.005);
     
     %streamline(R,Z,Bpolr,Bpolz, 5.5, 0, 0.01);
     %streamline(R,Z,Bpolr,Bpolz, -5.5, 0, 0.01);
     
     %streamline(R,Z,Bpolr,Bpolz, 6, 0, 0.01);
     %streamline(R,Z,Bpolr,Bpolz, -6, 0, 0.01);
     
     %streamline(R,Z,Bpolr,Bpolz, 6.5, 0, 0.01);
     %streamline(R,Z,Bpolr,Bpolz, -6.5, 0, 0.01);
     
     %streamline(R,Z,Bpolr,Bpolz, 7, 0, 0.01);
     %streamline(R,Z,Bpolr,Bpolz, -7, 0, 0.01);
     
     
     %streamline(R,Z,Bpolr,Bpolz, 5, 0, 0.01);
     %streamline(R,Z,Bpolr,Bpolz, -5, 0, 0.01);
     
     hold on;
     r=0.67;
        c1=[1.48 0];
        c2=[-1.48 0]
        pos1 = [c1-r 2*r 2*r];
        pos2 = [c2-r 2*r 2*r];
        rectangle('Position',pos1,'Curvature',[1 1]);
        rectangle('Position',pos2,'Curvature',[1 1]);
        xlim([-6,6]);
        ylim([-5,5]);
   
     %contour(R,Z,B0);
     %contour(R,Z,B1);
     %contour(R,Z,B2);
     %contour(R,Z,B3);
     %contour(R,Z,B4);
     %contour(R,Z,B5);
     %contour(R,Z,B6);
        
     plot(r1,h1,'+k',-r1,h1,'ok');
     plot(r2,h2,'+k',-r2,h2,'ok');
     plot(r3,h3,'+k',-r3,h3,'ok');
     plot(r3,-h4,'+k',-r3,-h4,'ok');
     plot(r2,-h5,'+k',-r2,-h5,'ok');
     plot(r1,-h6,'+k',-r1,-h6,'ok');
     grid
     axis square;
     hold on;
     
     figure(8)
     hold on
     xlabel('r, м');
     ylabel('B0,Тл');
     plot(R,B0);
     grid
     axis square;
     
     figure(9)
     hold on
     xlabel('z, м');
     ylabel('Bpol,Тл');
     plot(Z,B);
     grid
     axis square
      
     
     
     
     
     
     
     
     