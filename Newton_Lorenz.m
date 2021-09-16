clear all
%close all
%clear workspace
clc

global zi e M x1 vel Ex_1 Ex_2 Ex_3 x1 Bpolr Bpolz B N k1

l_b = 10.4/1000;
l_s = 5/1000;%длина сетки
L = 4*l_s + 3*l_b;%длина системы сеток вместе с самиими сетками
%d_y = 10%диаметр jотверстия сетки по y 
d_z = 2.5/1000;%диаметр jотверстия сетки по z 
zi = 1; %H ion charge
e = 1.60e-19;%electron charge
M = 1.67e-27;%H ion mass
psy = 0.3;%угол расходимости пучка в градусах
psy_rad = 0.01;%угол расходимости в радианах
psy_rad_1 = 0.6385
teta = 81.2;%угол между индукцией и осью r в градусах
teta_rad = 1.41842;%угол между индукцией и осью r в радианах

%коэффициент уменьшения магнитного поля
N = 200;
k1 = 1;

%температура ионов
T = 300;
k_B=1.38*10e-23;%Boltzman's constant

%initial coordinates
x0 = 0;
y0 = 0;
z0 = 0;

%initial energy, eV
U = 60e3;
%intial energy in Joules

v=sqrt(3*k_B*T/M);
%initial velocity
vx0 =v;
vy0 =0;
vz0 =0;

%initial vector
%Y01 = [ vx0; vy0; vz0; x0; y0; z0];
Y01 = [x0; y0; z0; vx0; vy0; vz0];
dt=1e-10;%временные рамки
tend=1e-6;
%motion calculation

[t,Y] = ode45(@motion, 0:dt:tend, Y01);

%попытка вывести координаты и скорости в точке выхода из зоны ускорения
l = length(Y(:,1));
x_search = 5;
%i = 1;
x_desire = 1.2;
%обнуляем координаты
x_1 = 0;
y_1 = 0;
z_1 = 0;
%обнуляем скорости
Vx_1 = 0;
Vy_1 = 0;
Vz_1 = 0;
%значение магнитной индукции в точке старта
B_1 = 0.0422;
%проекция вектора B на вертикальную ось z
B_z = B_1*sin(teta_rad);
alfa = 0;
beta = 0;
gamma = 0;
%[a, b] = min(abs(Y(:,1)-x_desire));
count = 0;

for i = 1:l
    disp(Y(i,1))
    if  (abs(Y(i,1) - x_desire)/Y(i,1))*100 <= 0.15%Y(i,1)>1.19985 && Y(i,1)<=1.20001 
        %disp(Y(i,1)
        %[a, b] = min(abs(Y(i,1)-x_desire))
        %b = i;
        x_1 = Y(i,1)%координата вылета частицы по x
        y_1 = Y(i,2)%координата вылета частицы по y
        z_1 = Y(i,3)%координата вылета частицы по z
        
        Vx_1 = Y(i,4)
        Vy_1 = Y(i,5)
        Vz_1 = Y(i,6)
        
        %суммарная скорость
        V_1 = sqrt(Vx_1^2 + Vy_1^2 + Vz_1^2);

        %пересчитываем
        B_z = B_z/N;
        
        %vdr_1 = (Ex_1*B_z)/B_z^2;%после первой сетки
        %vdr_2 = (Ex_2*B_z)/B_z^2;%после второй сетки
        %vdr_3 = (Ex_3*B_z)/B_z^2;%после третьей сетки
        
        alfa = abs(atan(Vy_1/Vx_1))%угол между проекциями Vхy
        %beta = atan(Vy_1/Vx_1);
        gamma = abs(atan(Vz_1/Vx_1))%угол между проекциями Vхz
        %проверка условия нахождения внутри конуса
        if alfa<psy_rad/2 && gamma<psy_rad/2
            disp('Поле скомпенсировано');
        else
            disp('Давай еще разок');
        end
        h = i; %строка матрицы
        break
    %else disp('no')
    end   
end
%подсчет отношений скоростей и их проекций на вылете из зоны ускорения
%V_1 = sqrt(Vx_1^2 + Vy_1^2 + Vz_1^2);
%отношение проекций скоростей на плоскости
l_0 = v/10^3;
l_xy = sqrt(Vx_1^2 + Vy_1^2)/10^3;
%определим углы
%alfa = atan(Vy_1/Vx_1)*180/pi;%угол между Vxy и направлением оси x
%beta = atan(Vy_1/Vx_1)*180/pi;%угол между Vyz и направлением оси x
%gamma = atan(Vz_1/Vx_1)*180/pi;%угол между Vyz и направлением оси x

%определим дрейфовые скорости движения иона между сетками
%vdr_1 = (Ex_1*B_new*sin(teta_rad))/B_new^2;%после первой сетки
%vdr_2 = (Ex_2*B_new*sin(teta_rad))/B_new^2;%после второй сетки
%vdr_3 = (Ex_3*B_new*sin(teta_rad))/B_new^2;%после третьей сетки

%psy_new = abs(vdr_3/V_1);

%проверка условия расходимости пучка на каждом промежутке
%if vdr_1<=V_1 && vdr_2<=V_1 && vdr_3<=V_1
%    psy_new = abs(vdr_3/V_1)
%    disp('Магнитное поле скомпенсировано');
%else 
%    disp('Попробуйте еще раз');
%end

%plotting
figure(1)
%animation
view(3);
axis equal;
hold on;
comet3 (Y(:,1),Y(:,2),Y(:,3));
set(gca,'FontSize',14, 'FontName','Times New Roman');
title('x vs t');
xlabel('x, M');
ylabel('y, М');
zlabel('z, М');
grid;
axis equal;

figure (2);
%проекция траектории на плоскость xy
xlabel('x, м');
ylabel('y, м');
hold on
hold on
k1 = plot(Y(:,1), Y(:,2));
set(k1,'Linewidth',2,'Color','r');
mark1 = plot(x0,y0,'o');
set(mark1,'Linewidth',4,'Color','#D95319');
mark2 = plot(x_1,y_1,'o');
set(mark2,'Linewidth',4,'Color','#7E2F8E');
clear color
grid
hold on
q1 = quiver(x0,y0,vx0/v,vy0/v, 1);%вектор начальной скорости
set(q1,'Linewidth',2,'Color','k');
hold on
%вектор скорости на вылете из зоны ускоорения
q2 = quiver(x_1,y_1,Vx_1/V_1,Vy_1/V_1,1);
set(q2,'Linewidth',2,'Color','b');
hold on
set(gca,'FontSize',14, 'FontName','Times New Roman');
hold on
%a = text(1.3,-1.1,'A(','FontName','Times New Roman','FontSize',16);
%b = text(1.37,-1.1,num2str(x_1),'FontName','Times New Roman','FontSize',16);
%c = text(1.45,-1.1,',','FontName','Times New Roman','FontSize',16);
%d = text(1.48,-1.1,num2str(y_1),'FontName','Times New Roman','FontSize',16);
%f = text(1.66,-1.1,')','FontName','Times New Roman','FontSize',16);
%(['Проекция траектории частицы на плоскость xy, M = ',num2str(M),'кг']);
%axis([0 1.4 -1.4 0])
axis equal


figure(3);
%трехмерный вид
view(3);
xlabel('x, м');
ylabel('y, м');
zlabel('z,м');
hold on
mark1 = plot3(x0,y0,z0,'o');
set(mark1,'Linewidth',4,'Color','#D95319');
mark2 = plot3(x_1,y_1,z_1,'o');
set(mark2,'Linewidth',4,'Color','#7E2F8E');
hold on;
k2 = plot3(Y(:,1),Y(:,2),Y(:,3));
set(k2,'Linewidth',2,'Color','#D95319');
hold on
q1 = quiver3(x0,y0,z0, vx0/v,vy0/v, vz0/v,1);%вектор начальной скорости
set(q1,'Linewidth',2,'Color','k');
hold on
%вектор скорости на вылете из зоны ускорения
q2 = quiver3(x_1,y_1,z_1, Vx_1/V_1, Vy_1/V_1, Vz_1/V_1,1);
set(q2,'Linewidth',2,'Color','b');
hold on
xlabel('x,м');
ylabel('y,м');
zlabel('z,м ');
grid
hold on
set(gca,'FontSize',14, 'FontName','Times New Roman');
%axis([0 3 -0.01 0.01 -0.01 0.01]);
hold on
axis equal
hold on


figure(4);
%проекция на плоскость yz
xlabel('y, м');
ylabel('z, м');
hold on
k3 = plot(Y(:,2),Y(:,3));
set(k3,'Linewidth',2,'Color','r');
hold on
mark1 = plot(y0,z0,'o');
set(mark1,'Linewidth',6,'Color','#D95319');
mark2 = plot(y_1,z_1,'o');
set(mark2,'Linewidth',6,'Color','#7E2F8E');
hold on
q1 = quiver(y0,z0,vy0/v,vz0/v,1);%вектор начальной скорости
set(q1,'Linewidth',2,'Color','k');
hold on;
q2 = quiver(y_1,z_1,...
    Vy_1/V_1, Vz_1/V_1,1);
set(q2,'Linewidth',2,'Color','b');
grid
set(gca,'FontSize',14, 'FontName','Times New Roman');
axis equal
hold on


figure(5);
%проекция на плоскость xz
xlabel('x, м');
ylabel('z, м');
hold on
k4 = plot(Y(:,1),Y(:,3));
set(k4,'Linewidth',2,'Color','r');
hold on
mark1 = plot(x0,z0,'o');
set(mark1,'Linewidth',6,'Color','#D95319');
mark2 = plot(x_1,z_1,'o');
set(mark2,'Linewidth',6,'Color','#7E2F8E');
hold on;
q1 = quiver(x0,z0,vx0/v,vz0/v,0.4);%вектор начальной скорости
set(q1,'Linewidth',2,'Color','k');
hold on;
q2 = quiver(x_1,z_1,...
    Vx_1/V_1, Vz_1/V_1,1.2);
set(q2,'Linewidth',2,'Color','b');
grid
set(gca,'FontSize',14, 'FontName','Times New Roman');
axis([0 1.4 -0.5 0.5]);
axis equal
hold on
