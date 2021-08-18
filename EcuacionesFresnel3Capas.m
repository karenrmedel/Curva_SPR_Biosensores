clear all;
figure(1)
clf
clc 

%---PAR�METROS DE LAS DISTINTAS CAPAS
%Vidrio (SF10), 633 nm
enpr=1.76;          %n del vidrio (s�lo hay parte real)

%Oro, 633 nm
e1n=0.1726;         %Parte real de n (oro)
e1k=3.4218;         %Parte imaginaria de n (oro)
e1r=e1n^2-e1k^2;    %Parte real de epsilon (oro)
e1i=2*e1n*e1k;      %Parte imaginaria de epsilon (oro)
e1=complex(e1r,e1i); %Epsilon compleja (oro)
d1=47e-9;           %Grosor de la capa de oro (m)

%Agua
n2=1.333;               %n del analito (s�lo hay parte real)
e2=n2^2;            %epsilon del analito (s�lo hay parte real)

%---CONSTANTES Y PAR�METROS DADOS 
c=2.99792458e8;
lambda=632.8e-9;
omega=2*pi/lambda*c;

%---ESCANEO DE LOS �NGULOS Y SOLUCI�N DE LAS ECUACIONES DE FRESNEL
ang0=48;            %L�mite inferior
ang1=60;            %L�mite superior
% vals=10000;
% interval=ang1-ang0;
% angmat=ang0:(interval/vals):ang1; %Vector de �ngulos
theta_deg=ang0:.01:ang1; % Rango: 48� a 60�. Intervalos: 0.01�  MATRIZ DE GRADOS DESDE 48 A 60 ( DE .01 EN .01)
theta_ext=theta_deg/180*pi; %Transformamos grados a radianes

for x=1:(length(theta_ext))
    theta=theta_ext(x);
	rpr1=(cos(theta)/enpr - sqrt(e1-(enpr^2)*(sin(theta)^2))/e1)/...
		(cos(theta)/enpr + sqrt(e1-(enpr^2)*(sin(theta)^2))/e1);
	r12=(sqrt(e1-(enpr^2)*(sin(theta)^2))/e1 -...
		sqrt(e2-(enpr^2)*(sin(theta)^2))/e2) /...
		(sqrt(e1-(enpr^2)*(sin(theta)^2))/e1 +...
		sqrt(e2-(enpr^2)*(sin(theta)^2))/e2);
	kz1d1=omega/c*d1*sqrt(e1-(enpr^2)*(sin(theta)^2));
	rpr12=(rpr1+ r12*exp(2*i*kz1d1))/(1+rpr1*r12*exp(2*i*kz1d1));
	ref(x)=rpr12*(conj(rpr12))*100;
end
 
refmin=find(ref==min(ref));
thetacr=theta_deg(refmin); %Posici�n del �ngulo cr�tico (m�n. reflectancia)

%---DIBUJO DE LA GR�FICA
plot(theta_deg,ref, 'k')
title('SIMULACI�N CURSVA SPR')
legend(['\thetamin = ', num2str(thetacr), '�'])
ylabel('Reflectancia R (%)')
xlabel('�ngulo \theta (�)')