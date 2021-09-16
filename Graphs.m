close all
clear all
clc
clear workspace

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
I6=20.5e3*432;%ОУ6

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
r6=890/1000;%ОУ6

%координата z полоидальных катушек
h1=2340e-3;%высота первых катушек 
h2=2120e-3;%высота вторых катушек 
h3=950e-3;%высота третьих катушек 
h4=-890e-3;
h5=-2370e-3;
h6=-2880e-3;

step=0.01;
     zmin=-7;
     zmax=7;
     rmin=-7;
     rmax=7;
r = rmin:step:rmax;
z = zmin:step:zmax;
%r = 2.28;
z = 0;

%k2_0=(4*r0*abs(r))./((abs(r)+r0).^2+(z-h0).^2);
     %[i1,i2]=find(k2_0>1);
     %k2_0(i1,i2)=round(k2_0(i1,i2));
     %[K,E]=ellipke(k2_0);
     
%Bpolr = -2e-7.*sign(r)*I0.*((z-h0)./(abs(r).*sqrt((abs(r)+r0).^2+(z-h0).^2))).*(K-E.*((abs(r).^2+r0^2+(z-h0).^2)./((abs(r)-r0).^2+(z-h0).^2)));
%Bpolz = 2e-7.*I0.*(1./sqrt((abs(r)+r0).^2+(z-h0).^2)).*(K-E.*((abs(r).^2-r0^2+(z-h0).^2)./((abs(r)-r0).^2+(z-h0).^2)));
     
%clear K E;
     %считаем поле плазмы до радиуса тора
     [Bpolr_0, Bpolz_0] = poloidal_field(R0, r, z, I_plasma, h0);
     B0 = sqrt(Bpolr_0.^2+Bpolz_0.^2);
     M_B0 = max(B0);
     %for 
     
     
     
     %считаем поле плазмы после радиуса тора
     %rmin=R0+20*step;
     %rmax=7;
     %r = rmin:step:rmax;
     %z = 0;
     %[Bpolr_R0, Bpolz_R0] = poloidal_field(R0, r, z, I_plasma, h0);
     %B_R0 = sqrt(Bpolr_R0.^2+Bpolz_R0.^2);
     %M_B0 = max(B_R0);
     %B_R0plot = plot(r,B_R0);
     
     %set(B_R0plot,'Linewidth',3,'Color','b');
     %plot(6455/1000,0.00545,'Linewidth',7,'Marker','o','MarkerFaceColor','g');
     %plot(6135/1000,0.006392,'Linewidth',7,'Marker','o','MarkerFaceColor','k');
 
     
     %поле от тока в полоидальной катушке 1;
     [Bpolr_1,Bpolz_1] = poloidal_field(r1, r, z, I1, h1);
     B1 = sqrt(Bpolr_1.^2+Bpolz_1.^2);
     M_B1 = max(B1);
   
     %поле от тока в полоидальной катушке 2
     [Bpolr_2,Bpolz_2] = poloidal_field(r2, r, z, I2, h2);
     B2 = sqrt(Bpolr_2.^2+Bpolz_2.^2);
     M_B2 = max(B2);
     
     %поле от тока в полоидальной катушке 3
     [Bpolr_3,Bpolz_3] = poloidal_field(r3, r, z, I3, h3);
     B3 = sqrt(Bpolr_3.^2+Bpolz_3.^2);
     M_B3 = max(B3);
     
     %поле от тока в полоидальной катушке 4
     [Bpolr_4,Bpolz_4] = poloidal_field(r4, r, z, I4, h4);
     B4 = sqrt(Bpolr_4.^2+Bpolz_4.^2);
     M_B4 = max(B4);
     
     %поле от тока в полоидальной катушке 5
     [Bpolr_5,Bpolz_5] = poloidal_field(r5, r, z, I5, h5);
     B5 = sqrt(Bpolr_5.^2+Bpolz_5.^2);
     M_B5 = max(B5);
     
     %поле от тока в полоидальной катушке 6
     [Bpolr_6,Bpolz_6] = poloidal_field(r6, r, z, I6, h6);
     B6 = sqrt(Bpolr_6.^2+Bpolz_6.^2);
     M_B6 = max(B6);
     
     %суммма составляющих
     %Bpolr_Full=abs(Bpolr_0)+abs(Bpolr_1)+abs(Bpolr_2)+abs(Bpolr_3)+abs(Bpolr_4)+abs(Bpolr_5)+abs(Bpolr_6);
     %Bpolz_Full=abs(Bpolz_0)+abs(Bpolz_1)+abs(Bpolz_2)+abs(Bpolz_3)+abs(Bpolz_4)+abs(Bpolz_5)+abs(Bpolz_6);
     
     Bpolr=Bpolr_1+Bpolr_2+Bpolr_3+Bpolr_4+Bpolr_5+Bpolr_6;
     Bpolz=Bpolz_1+Bpolz_2+Bpolz_3+Bpolz_4+Bpolz_5+Bpolz_6;
     
     Bpolr_Full=Bpolr_0+Bpolr_1+Bpolr_2+Bpolr_3+Bpolr_4+Bpolr_5+Bpolr_6;
     Bpolz_Full=Bpolz_0+Bpolz_1+Bpolz_2+Bpolz_3+Bpolz_4+Bpolz_5+Bpolz_6;
     
     
     %Bpolr=Bpolr_0;
     %Bpolz=Bpolz_0;
     B_sum = sqrt(Bpolr.^2+Bpolz.^2);
     %B_sum = B1+B2+B3+B4+B5+B6;
     B_Full = sqrt(Bpolr_Full.^2+Bpolz_Full.^2);
     %B_Full = sqrt(B_sum.^2 + B0.^2);
     %B_Full = B1+B2+B3+B4+B5+B6;
     max(B_sum);
     
     B_plasma = sqrt(Bpolr_0.^2+Bpolz_0.^2)';
     
     figure(1)
     hold on
     xlabel('r, м');
     ylabel('Bsum, Тл');
     grid
     set(gca,'FontSize',16, 'FontName','Times New Roman')
     B_plot = plot(r,B0);
     set(B_plot,'Linewidth',2,'Color','r');
     %h = text(0.1,0.8,'0,8491 Тл','FontName','Times New Roman','FontSize',16);
     p1 = plot(2.15,0.2825,'o');
     set(p1,'Linewidth',6,'Color','#0072BD');%граница ВК
     p2 = plot(6135/1000,0.0064,'o');
     set(p2,'Linewidth',6,'Color','#7E2F8E');%ИОС
     p3 = plot(6455/1000,0.0055,'o');%источник ионов
     set(p3,'Linewidth',6,'Color','k');
     p4 = plot(4935/1000,0.01269,'o');%граница зоны рекомбинации
     set(p4,'Linewidth',6,'Color','#77AC30');
     %l = text(2.3,0.285,'0,2825 Тл','FontName','Times New Roman','FontSize',16);
     %g = text(5.9,0.03,'0,0064 Тл','FontName','Times New Roman','FontSize',16);
     %q = text(6.3,0.03,'0,0055 Тл','FontName','Times New Roman','FontSize',16);
     %axis equal
    % plot(0,0.8491,'Linewidth',7,'Marker','o','MarkerFaceColor','r');
    
     axis([2.15 7 0 0.3])
     
     figure(2)
     hold on
     xlabel('r, м');
     ylabel('Bsum, Тл');
     grid
     set(gca,'FontSize',16, 'FontName','Times New Roman')
     K = plot(r,B_sum);
     P = plot(r, B0);
     F = plot(r,abs(B_Full));
     set(K,'Linewidth',2,'Color','r');
     set(P,'Linewidth',2,'Color','#EDB120');
     set(F,'Linewidth',2,'Color','#D95319');
     %plot(R0,0.4207,'Linewidth',7,'Marker','o','MarkerFaceColor','r');
     p1 = plot(6455/1000,0.03721,'o');%источник ионов
     set(p1,'Linewidth',8,'Color','k');
     p2 = plot(6135/1000,0.04317,'o');
     set(p2,'Linewidth',8,'Color','#7E2F8E');%ИОС
     p3 = plot(4935/1000,0.07567,'o');
     set(p3,'Linewidth',8,'Color','#77AC30');%граница зоны нейтрализации
     p3 = plot(2150/1000,0.7294,'o');
     set(p3,'Linewidth',8,'Color','#0072BD');%граница вк токамака
     
     %axis equal
     axis([2.15 7 0 1])
     
     figure(3)
     hold on
     xlabel('r, м');
     ylabel('Bsum, Тл');
     grid
     set(gca,'FontSize',16, 'FontName','Times New Roman')
     K = plot(r,B_sum);
     set(K,'Linewidth',2,'Color','r');
     %plot(R0,0.4207,'Linewidth',7,'Marker','o','MarkerFaceColor','r');
     p1 = plot(6455/1000,0.042,'o');
     set(p1,'Linewidth',6,'Color','k');
     p2 = plot(6135/1000,0.05,'o');
     set(p2,'Linewidth',6,'Color','#7E2F8E');
     p3 = plot(1.48,0.4207,'o');
     set(p3,'Linewidth',6,'Color','#0072BD');
     p3 = plot(4935/1000,0.08715,'o');%зона нейтрализации
     set(p3,'Linewidth',6,'Color','#77AC30');
     %h = text(1.2,0.45,'0,4207 Тл','FontName','Times New Roman','FontSize',16);
     %g = text(5.8,0.15,'0,0495 Тл','FontName','Times New Roman','FontSize',16);
     %q = text(6.4,0.15,'0,0426 Тл','FontName','Times New Roman','FontSize',16);
     %axis equal
     axis([0 7 0 0.6])