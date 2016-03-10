function [Phi, Y]=isoCdust(gas,dust, Cdust, islimit, hdl)
%(Gas, Dust) =struct( ...
%     'name',name, ... 
%     'state',state, ...
%     'W', molarMass, ...
%     'fuel_O2', fuel_O2, ...
%     'f', f ... volatiles fraction
%     );


P=1E5;%Pa
R=8.314;
T=298;

Y=0:0.001:1;
Cdust=Cdust(:);
pre='     ';
pre=repmat(pre,[length(Cdust) 1]);
if(~isempty(pre(Cdust==dust.MEC,:)))
    pre(Cdust==dust.MEC,:)='MEC= ';
end


names=num2str(round(Cdust*10)/10);
m=length(Y);
n=length(Cdust);

Cdust=repmat(Cdust,[1 m]);
Ygas=repmat(Y,[n 1]);

%Cgas=(Ygas./(1-Ygas))*(dust.f/gas.f)*gas.fuel_O2/dust.fuel_O2.*Cdust/dust.W;
Cgas=(Ygas./(1-Ygas))*gas.fuel_O2/dust.fuel_O2.*Cdust/dust.W;
Co2=0.21*(P/(R*T)-Cgas);

%phi=dust.f/dust.fuel_O2*Cdust/dust.W./(1-Ygas)./(Co2);
phi=(dust.f/dust.fuel_O2*Cdust/dust.W + gas.f/gas.fuel_O2*Cgas)./Co2;

Phi=phi./(phi+1);
Phi(isnan(Phi))=1;

kx=get(hdl,'xlim');
kx=1/(kx(2)-kx(1));

ky=get(hdl,'ylim');
ky=1/(ky(2)-ky(1));
K=ky/kx;
k=1;
p=0.5;
for i=1:n
   
    per1=0.95;
    per2=0;
    pen=(per2-per1)*m/(n^p-1);
    
    j=int32(pen*k^p+per1*m-pen);
    % j=int32(-(0.92-0.01)*m/(n-1)^p*(k-1)^p +0.92*m );
     
    if(Cdust(i,1)==dust.MEC)
        j=int32(-(0.85-0.01)*m/(n-1)^p*(k-1.25)^p +0.85*m );
        j=int32(0.45*m);
        phinames=Phi(i,j);
        ynames=Y(j);
        orientation=180/pi*atan(K*(Phi(i,j+1)-Phi(i,j-1))/(Y(j+1)-Y(j-1)));
        text(ynames,phinames,[ pre(i,:) names(i,:) ' g/m^3'],'Rotation',orientation, ...
            'horizontalalignment','center','verticalalignment','top', ...
            'Color' ,[0 0 0] , 'Fontweight', 'bold', 'parent',hdl)
    else

        phinames=Phi(i,j);
        ynames=Y(j);
        orientation=180/pi*atan(K*(Phi(i,j+1)-Phi(i,j-1))/(Y(j+1)-Y(j-1)));
        k=k+1;
        text(ynames,phinames,[ names(i,:) ' g/m^3'],'Rotation',orientation, ...
            'horizontalalignment','center','fontsize',8,'verticalalignment','top', ...
            'parent',hdl)
    end
end


hold on
%plot(hdl,Y,Phi,'k-.','LineWidth',1);
i=Cdust(:,1)==dust.MEC;

    plot(hdl,Y,Phi(i,:),'k-','LineWidth',3);
    plot(hdl,Y,Phi(~i,:),'k-','LineWidth',1);

hold off

