clear all
close all
clear workspace
clc

global zi e M x1 vel Ex_1 Ex_2 Ex_3 x1 Bpolr Bpolz B N l1 k1

l_b = 10.4/1000;%����� ����� �������
l_s = 5/1000;%����� �����
L = 4*l_s + 3*l_b;%����� ������� ����� ������ � ������� �������
d_z = 3/1000;%������� j��������� ����� �� z
d_y = 38/1000;
zi = 1; %H ion charge
e = 1.60e-19;%electron charge
M = 1.67e-27;%H ion mass
phi = 3.35;%���� ������������ ����� � ��������
psy_rad = 0.01;%���� ������������ � ��������
psy_1 = 0.6;%36.58;
teta = 81.2;%���� ����� ��������� � ���� r � ��������
teta_rad = 1.41842;%���� ����� ��������� � ���� r � ��������

%����������� ���������� ���������� ����
N = 1%201;
k1 = 1;%1:1:206;
%k_k = 120:1:205;

%����������� �����
T = 300;
k_B=1.38*10e-23;%Boltzman's constant

%�������� ��������
v=sqrt(3*k_B*T/M);

%����� ������
Number_parts = 1000;
%������� ������������ ����
eps_1 = -30;
eps_2 = 30;
%��� �� ����
step = (eps_2-eps_1)/Number_parts;
epsilon= 30.*(rand(1,Number_parts));

%initial coordinates
%initial velocity
vx0 =[];
vy0 =[];
vz0 =[];
%initial angle
%epsilon = [eps_1:step:eps_2];

%len_epsilon = length(epsilon);%����� ������ ��� �������
%��������� �����
dt=1e-10;
tend=1e-6;
%������ ��������� �������
Y01 = [];
%���������� �� ����� ������ �� ������� �����
x_desire = L;
%�������� ��������� �������� � ����� ������
B_1 = 0.0422;
%�������� ������� B �� ������������ ��� z
B_z = B_1*sin(teta_rad);
%����
alfa = 0;
beta = 0;
gamma = 0;
%������� �� z
z_edge = d_z*0.1;
y_edge = d_y*0.1;
count_arr = [];
%����� ������� ������ � �����
%for j1 = 1:length(k_k)
%    k1 = k_k(j1);
%    disp(j1);
for i = 1:Number_parts
    %��������� ������� ��������� �������
    
    %��������� ����������
    x0(i) = 0;
    y0(i) = ((y_edge - (-y_edge)).*rand(1,1)+(-y_edge));
    z0(i) =((z_edge - (-z_edge)).*rand(1,1)+(-z_edge));
    
    %���� ����� ��������� � ���� x
    eps = epsilon(i);
    %disp(eps);
    
    %������ ��������� ��������
    vx0(i) = v*cos(deg2rad(eps));
    vy0(i) = v*sin(deg2rad(eps));
    vz0(i) = 0;
    %disp(sqrt(vx0(i)^2 + vy0(i)^2));
    Y01 = [x0(i); y0(i); z0(i); vx0(i); vy0(i); vz0(i)];
    
    %����� ������� �������
    [t,Y] = ode45(@motion, 0:dt:tend, Y01);
    %TT{i} = t;
    YY{i} = Y;
    
end 
%figure(4)
%A = histogram(z0)
%�������� ������� ������ �� ������� ������ �����
%����� ���������� � ������ ����� �� ������� �����
count = 0;
x_1=[];
y_1=[];
z_1=[];
V_1=[];
alfa = [];
gamma =[];

for j = 1:length(YY)
     [a, b] = min(abs(YY{j}(:,1)-x_desire));
     x_1(j) = YY{j}(b,1);%���������� ������ ������� �� x
     disp(x_1);
     y_1(j) = YY{j}(b,2);%���������� ������ ������� �� y
     disp(y_1);
     z_1(j) = YY{j}(b,3);%���������� ������ ������� �� z
     disp(z_1);
        
     Vx_1(j) = YY{j}(b,4);
     Vy_1(j) = YY{j}(b,5);
     Vz_1(j) = YY{j}(b,6);
     
     %V_1(j) = sqrt(Vx_1.^2 + Vy_1.^2 + Vz_1.^2)

     %�������������
     %B_z = B_z/(N*k);
     
     %�������� ������� ��������� ���� �� �����
     %if abs(z_1) >= abs(d_z/2)
     %    disp(z_1)
     %    count = count+1;
     %    disp('��� ����� �� �����');
     %else
     %    disp('��� �� ����� �� �����');
     %end
        
     alfa(j) = abs(rad2deg(atan(Vy_1(j)/Vx_1(j))));%���� ����� ���������� V�y
     %disp(alfa);
     %beta = abs(rad2deg(atan(Vy_1/Vx_1));
     gamma(j) = abs(rad2deg(atan(Vz_1(j)/Vx_1(j))));%���� ����� ���������� V�z
     %disp(gamma);
     if abs(alfa(j))<=psy_1/2 && abs(gamma(j))<=psy_1/2 %&& abs(y_1) <= abs(d_y) && abs(z_1) <= abs(d_z)
         disp('���� ���������������');
         
     else
         disp('����� ��� �����');
         count = count + 1;
         
     end
end
%count_arr(j1) = count;
%end

%end
count_arr = count_arr';


%plotting
figure(1);
%���������� ���
view(3);
xlabel('x, �');
ylabel('y, �');
zlabel('z, �');
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
%quiver3(x0,y0,z0, vx0/v,vy0/v, vz0/v,1,'k');%������ ��������� ��������
hold on
%������ �������� �� ������ �� ���� ���������

hold on
grid
hold on
set(gca,'FontSize',14, 'FontName','Times New Roman');
%axis([-0.05 L -0.01 0.01 -0.01 0.01]);
hold on
axis equal
hold on

figure(2);
%�������� �� ��������� xz
xlabel('x, �');
ylabel('z, �');
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
%quiver(x0,z0,vx0/v,vz0/v,0.01,'k');%������ ��������� ��������
hold on;
%quiver(x_1,z_1,...
    %Vx_1/V_1, Vz_1/V_1,2,'b');
grid
set(gca,'FontSize',14, 'FontName','Times New Roman');
%axis([0 0.0512 -0.01 0.01]);
axis equal
hold on

figure(3);
%�������� �� ��������� yz
xlabel('y, �');
ylabel('z, �');
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
%quiver(y0,z0,vy0/v,vz0/v,1,'k');%������ ��������� ��������
hold on;
%quiver(y_1,z_1,...
%    Vy_1/V_1, Vz_1/V_1,1,'b');
grid
set(gca,'FontSize',14, 'FontName','Times New Roman');
axis equal
hold on



