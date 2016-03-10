function lechatelier( hdl,gas, dust)
% a little help

P=1E5;
R=8.314;
T=298;
%lechatelier
ygas=0:0.0001:gas.LEL;
Cdust=(dust.MEC-dust.MEC/gas.LEL*ygas)/dust.W;
C_O2=0.21*(1-ygas)*P/(R*T);


Ygas=gas.f/gas.fuel_O2*ygas*P/(R*T)./(gas.f/gas.fuel_O2*ygas*P/R/T+dust.f/dust.fuel_O2*Cdust);

phi=(gas.f/gas.fuel_O2*ygas*P/R/T+dust.f/dust.fuel_O2*Cdust)./C_O2;
Phi=phi./(1+phi);

hold(hdl,'on')
plot(hdl, Ygas, Phi,'k','LineWidth',3);

i=int32(length(ygas)/2);
kx=get(hdl,'xlim');
kx=1/(kx(2)-kx(1));
ky=get(hdl,'ylim');
ky=1/(ky(2)-ky(1));
K=ky/kx;
orientation=180/pi*atan(K*(Phi(i+1)-Phi(i-1))/(Ygas(i+1)-Ygas(i-1)));

text(Ygas(i),Phi(i), 'Le Chatelier','Rotation',orientation, ...
    'horizontalalignment','center','verticalalignment','top', ...
    'Color' ,[0 0 0] , 'Fontweight', 'bold', 'parent',hdl)

hold(hdl,'off')