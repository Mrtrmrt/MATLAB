clear all
close all
clear workspace
clc

global zi e M x1 vel Ex_1 Ex_2 Ex_3 x1 Bpolr Bpolz B N l1 k1

l_b = 10.4/1000;%длина между сетками
l_s = 5/1000;%длина сетки
L = 4*l_s + 3*l_b;%длина системы сеток вместе с самиими сетками
d_z = 3/1000;%диаметр jотверстия сетки по z
d_y = 38/1000;
zi = 1; %H ion charge
e = 1.60e-19;%electron charge
M = 1.67e-27;%H ion mass
phi = 3.35;%угол расходимости пучка в градусах
psy_rad = 0.01;%угол расходимости в радианах
psy_1 = 0.6;%36.58;
teta = 81.2;%угол между индукцией и осью r в градусах
teta_rad = 1.41842;%угол между индукцией и осью r в радианах

%коэффициент уменьшения магнитного поля
N = 1%201;
k1 = 1;%1:1:206;
%k_k = 120:1:205;

%температура ионов
T = 300;
k_B=1.38*10e-23;%Boltzman's constant

%тепловая скорость
v=sqrt(3*k_B*T/M);

%число частиц
Number_parts = 1000;
%пределы расходимости угла
eps_1 = -30;
eps_2 = 30;
%шаг по углу
step = (eps_2-eps_1)/Number_parts;
epsilon= 30.*(rand(1,Number_parts));

%initial coordinates
%initial velocity
vx0 =[];
vy0 =[];
vz0 =[];
%initial angle
%epsilon = [eps_1:step:eps_2];

%len_epsilon = length(epsilon);%число частиц для расчета
%временные рамки
dt=1e-10;
tend=1e-6;
%вектор начальных условий
Y01 = [];
%расстояние до точки вылета за пределы сеток
x_desire = L;
%значение магнитной индукции в точке старта
B_1 = 0.0422;
%проекция вектора B на вертикальную ось z
B_z = B_1*sin(teta_rad);
%углы
alfa = 0;
beta = 0;
gamma = 0;
%граница по z
z_edge = d_z*0.1;
y_edge = d_y*0.1;
count_arr = [];
%вызов функции расчет в цикле
%for j1 = 1:length(k_k)
%    k1 = k_k(j1);
%    disp(j1);
for i = 1:Number_parts
    %формируем вектора начальных условий
    
    %стартовые координаты
    x0(i) = 0;
    y0(i) = ((y_edge - (-y_edge)).*rand(1,1)+(-y_edge));
    z0(i) =((z_edge - (-z_edge)).*rand(1,1)+(-z_edge));
    
    %угол между скоростью и осью x
    eps = epsilon(i);
    %disp(eps);
    
    %вектор начальной скорости
    vx0(i) = v*cos(deg2rad(eps));
    vy0(i) = v*sin(deg2rad(eps));
    vz0(i) = 0;
    %disp(sqrt(vx0(i)^2 + vy0(i)^2));
    Y01 = [x0(i); y0(i); z0(i); vx0(i); vy0(i); vz0(i)];
    
    %вызов функции расчета
    [t,Y] = ode45(@motion, 0:dt:tend, Y01);
    %TT{i} = t;
    YY{i} = Y;
    
end 
%figure(4)
%A = histogram(z0)
%проверка условия вылета за пределы второй сетки
%поиск координаты х вылета ионов за пределы сетки
count = 0;
x_1=[];
y_1=[];
z_1=[];
V_1=[];
alfa = [];
gamma =[];

for j = 1:length(YY)
     [a, b] = min(abs(YY{j}(:,1)-x_desire));
     x_1(j) = YY{j}(b,1);%координата вылета частицы по x
     disp(x_1);
     y_1(j) = YY{j}(b,2);%координата вылета частицы по y
     disp(y_1);
     z_1(j) = YY{j}(b,3);%координата вылета частицы по z
     disp(z_1);
        
     Vx_1(j) = YY{j}(b,4);
     Vy_1(j) = YY{j}(b,5);
     Vz_1(j) = YY{j}(b,6);
     
     %V_1(j) = sqrt(Vx_1.^2 + Vy_1.^2 + Vz_1.^2)

     %пересчитываем
     %B_z = B_z/(N*k);
     
     %проверка условия попадания иона на сетку
     %if abs(z_1) >= abs(d_z/2)
     %    disp(z_1)
     %    count = count+1;
     %    disp('Ион попал на сетку');
     %else
     %    disp('Ион не попал на сетку');
     %end
        
     alfa(j) = abs(rad2deg(atan(Vy_1(j)/Vx_1(j))));%угол между проекциями Vхy
     %disp(alfa);
     %beta = abs(rad2deg(atan(Vy_1/Vx_1));
     gamma(j) = abs(rad2deg(atan(Vz_1(j)/Vx_1(j))));%угол между проекциями Vхz
     %disp(gamma);
     if abs(alfa(j))<=psy_1/2 && abs(gamma(j))<=psy_1/2 %&& abs(y_1) <= abs(d_y) && abs(z_1) <= abs(d_z)
         disp('Поле скомпенсировано');
         
     else
         disp('Давай еще разок');
         count = count + 1;
         
     end
end
%count_arr(j1) = count;
%end

%end
count_arr = count_arr';


%plotting
figure(1);
%трехмерный вид
view(3);
xlabel('x, м');
ylabel('y, м');
zlabel('z, м');
hold on
mark1 = plot3(x0,y0,z0,'o');
set(mark1,'Linewidth',6,'Color','#D95319');
mark2 = plot3(x_1,y_1,z_1,'o');
set(mark2,'Linewidth',6,'Color','#7E2F8E');
hold on;
for i = 1:length(YY)
    k2 = plot3(YY{i}(:,1),YY{i}(:,2),YY{i}(:,3));
    %set(k,'Linewidth',2,'Color','r');
    hold on
    %quiver3(x_1,y_1,z_1, Vx_1/V_1, Vy_1/V_1, Vz_1/V_1,1,'b');
end
%quiver3(x0,y0,z0, vx0/v,vy0/v, vz0/v,1,'k');%вектор начальной скорости
hold on
%вектор скорости на вылете из зоны ускорения

hold on
grid
hold on
set(gca,'FontSize',14, 'FontName','Times New Roman');
%axis([-0.05 L -0.01 0.01 -0.01 0.01]);
hold on
axis equal
hold on

figure(2);
%проекция на плоскость xz
xlabel('x, м');
ylabel('z, м');
hold on
for i = 1:length(YY)
    k3 = plot(YY{i}(:,1),YY{i}(:,3));
    %set(k,'Linewidth',2,'Color','r');
end
hold on
mark1 = plot(x0,z0,'o');
set(mark1,'Linewidth',3,'Color','#D95319');
%mark2 = plot(x_1,z_1,'o');
%set(mark2,'Linewidth',6,'Color','#7E2F8E');
hold on;
%quiver(x0,z0,vx0/v,vz0/v,0.01,'k');%вектор начальной скорости
hold on;
%quiver(x_1,z_1,...
    %Vx_1/V_1, Vz_1/V_1,2,'b');
grid
set(gca,'FontSize',14, 'FontName','Times New Roman');
%axis([0 0.0512 -0.01 0.01]);
axis equal
hold on

figure(3);
%проекция на плоскость yz
xlabel('y, м');
ylabel('z, м');
hold on
for i = 1:length(YY)
    k4 = plot(YY{i}(:,2),YY{i}(:,3));
    %set(k,'Linewidth',2,'Color','r');
end
hold on
mark1 = plot(y0,z0,'o');
set(mark1,'Linewidth',6,'Color','#D95319');
%mark2 = plot(y_1,z_1,'o');
%set(mark2,'Linewidth',6,'Color','#7E2F8E');
hold on
%quiver(y0,z0,vy0/v,vz0/v,1,'k');%вектор начальной скорости
hold on;
%quiver(y_1,z_1,...
%    Vy_1/V_1, Vz_1/V_1,1,'b');
grid
set(gca,'FontSize',14, 'FontName','Times New Roman');
axis equal
hold on



