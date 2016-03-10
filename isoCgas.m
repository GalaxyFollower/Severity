function [Phi, Y]=isoCgas(gas,dust, ygas,islimit, hdl)
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
Y=0:0.01:1;
ygas=ygas(:);
pre='     ';
pre=repmat(pre,[length(ygas) 1]);
if(~isempty(pre(ygas==gas.LEL,:)))
    pre(ygas==gas.LEL,:)='LEL= ';
end
if(pre(ygas==gas.UEL,:))
    pre(ygas==gas.UEL,:)='UEL= ';
end

       
names=[num2str(ygas*100)];

m=length(Y);
n=length(ygas);

ygas=repmat(ygas,[1 m]);
Ygas_fuel=repmat(Y,[n 1]);


%phi=ygas./(0.21*(1-ygas))*(gas.f/gas.fuel_O2)./Ygas_fuel;
phi=(1/gas.fuel_O2)*ygas.*(gas.f +  dust.f*(1-Ygas_fuel)./Ygas_fuel)./(0.21*(1-ygas));

Phi=phi./(phi+1);
Phi(isnan(Phi))=1;

kx=get(hdl,'xlim');
kx=1/(kx(2)-kx(1));

ky=get(hdl,'ylim');
ky=1/(ky(2)-ky(1));
K=ky/kx;
k=1;
p=2;
for i=1:n
    per1=0.07;
    per2=0.55;
    pen=(per2-per1)*m/(n^p-1);
    
    j=int32(pen*k^p+per1*m-pen);

    if(ygas(i,1)==gas.LEL || ygas(i,1)== gas.UEL)
        j=int32((0.7*m-0.05*m)*(k-0.5)/n+0.05*m);
        j=int32(0.7*m);
        phinames=Phi(i,j);
        ynames=Y(j);
        orientation=180/pi*atan(K*(Phi(i,j+1)-Phi(i,j-1))/(Y(j+1)-Y(j-1)));
        text(ynames,phinames,[ pre(i,:) names(i,:) '%'],'Rotation',orientation, ...
            'horizontalalignment','center','verticalalignment','top', ...
            'Color' ,[0 0 0] , 'Fontweight', 'bold', 'parent',hdl)
    else
        k=k+1;
        phinames=Phi(i,j);
        ynames=Y(j);
        orientation=180/pi*atan(K*(Phi(i,j+1)-Phi(i,j-1))/(Y(j+1)-Y(j-1)));
        text(ynames,phinames,[ names(i,:) '%'],'Rotation',orientation, ...
            'horizontalalignment','center','fontsize',8,'verticalalignment','top', ...
             'parent', hdl)
    end
end


hold on
i=ygas(:,1)==gas.UEL | ygas(:,1)==gas.LEL;
plot(hdl,Y,Phi(i,:),'k-','LineWidth',3);
plot(hdl,Y,Phi(~i,:),'k:','LineWidth',1);

hold off

