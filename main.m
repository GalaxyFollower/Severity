clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       CHOOSE MIXTURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global P0 V R T0
% 
MIXTURE='METHANE-STARCH';
MIXTURE='PYROGAS-STARCH';
%MIXTURE='NIACINE-ACETONE';
%MIXTURE='CARBON-HYDROGEN';
%MIXTURE='MAGNESIUM_STEARATE-ETHANOL';
%MIXTURE='TELITHROMYCIN-ACETONE';
%MIXTURE='NIACINE-ETHER';
%MIXTURE='TELITHROMYCIN-TOLUENE';
tvfx=60;
nisoC=15;
if(strcmp(MIXTURE,'METHANE-STARCH'))
    file='Starch-Methane';
    Gas=Fuel('Methane','GAS',16.0425,0.5,1,0.044, 0.16,[]);
    Dust=Fuel('Starch','SOLID',162.141,(1/6),0.3, [],[],150);
end
if(strcmp(MIXTURE,'PYROGAS-STARCH'))
    file='starch-pyrogas';
    Gas=Fuel('Methane','GAS',27.06,1/0.633,1,0.089,0.64,[]);
    Dust=Fuel('Starch','SOLID',162.141,(1/6),0.3, [],[],150);
end

if(strcmp(MIXTURE,'NIACINE-ACETONE'))
    file='niacine-acetone';
    Gas=Fuel('Acetone','GAS',58.0791,1/4,1, 0.026, 0.13, []);
    Dust=Fuel('Niacine','SOLID',123.109,(4/25),1,[] ,[] ,60 );
end

if(strcmp(MIXTURE,'CARBON-HYDROGEN'))
    file='carbon-hydrogen';
    Gas=Fuel('Hydrogen','GAS',2,2,1, .04, .75,[]);
    Dust=Fuel('Carbon','SOLID',12,1,1,[],[],80);
end

if(strcmp(MIXTURE,'MAGNESIUM_STEARATE-ETHANOL'))
    file='magnesium_stearate-ethanol';
    Gas=Fuel('Ethanol','GAS',46,2/7,0.5, 0.028, .154,[]);
    Dust=Fuel('Magnesium stearate','SOLID',591.27,1/52,0.3619,[],[],30);
  
end


if(strcmp(MIXTURE,'TELITHROMYCIN-ACETONE'))
    file='telithromycin-acetone';
    Gas=Fuel('Acetone','GAS',58.08,1/4,1, 0.026, .13,[]);
    Dust=Fuel('Telithromycin','SOLID',821.03,4/217,0.25,[],[],40);
end

if(strcmp(MIXTURE,'NIACINE-ETHER'))
    file='niacine-ether';
    Gas=Fuel('Diisopropyl ether','GAS',102.18,1/9,1, 0.007, .084,[]);
    Dust=Fuel('Niacine','SOLID',123.109,(4/25),0.26,[] ,[] ,60 );
end

if(strcmp(MIXTURE,'TELITHROMYCIN-TOLUENE'))
    file='telithromycin-toluene';
    Gas=Fuel('Toluene','GAS',92.14,1/9,0.5, 0.013, .09,[]);
    Dust=Fuel('Telithromycin','SOLID',821.03,4/217,0.25,[],[],40);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   CONDITIONS SPHERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V=20E-3;% m^3
P0=1E5;% Pa
T0=298;% K
R=8.314; % J/(mol K)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       READING DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=xlsread(file);
Cdust=A(:,1);
ygas=A(:,2);
Pm=A(:,3);
dPdtmax=A(:,4);
tv=A(:,5);
%E=A(:,6);
%tv=E;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  AVERAGING DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cdust=Cdust(tv==tvfx);
ygas=ygas(tv==tvfx);
dPdtmax=dPdtmax(tv==tvfx);
%dPdtmax=Pm(tv==tvfx);


%[Gas.f, Dust.f]=estimate_f(Gas, Dust, Cdust, ygas, dPdtmax)

Cdust_u=unique(Cdust);
k=1;
for i=1:length(Cdust_u)
    ygas_u=unique(ygas(abs(Cdust-Cdust_u(i))<=1));
    for j=1:length(ygas_u)
        Cdust_mean(k)=Cdust_u(i);
        ygas_mean(k)=ygas_u(j);
        dPdt_mean(k)=mean(dPdtmax(abs(Cdust-Cdust_u(i))<1 & ...
            abs(ygas-ygas_u(j))<0.002));    
        k=k+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ndust=Cdust_mean/Dust.W*V; %Number of Moles of fust
ngas=ygas_mean*P0*V/(R*T0); %Number of moles of gas

Cst=Dust.W*Dust.fuel_O2*0.21*P0/(R*T0);

 
phi=(Dust.f/Dust.fuel_O2*ndust+Gas.f/Gas.fuel_O2*ngas)*R*T0./(0.21*(1 ...
     -ygas_mean)*P0*V);%MIRIAM
Phi=phi./(1+phi);

Ygas_fuel=1/Gas.fuel_O2*ngas./(1/Gas.fuel_O2*ngas+1/Dust.fuel_O2*ndust);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       PLOTTING DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig=getFigureHdl(MIXTURE);

%colmap=(1-jet(100))*0.5+jet(100);
%..........................
%   Making contours
%..........................
figure(fig)
clf
position=get(0,'Screensize');
position(3)=position(4);

set(fig, 'Position', position );
hdl=plotyy(0,0,0,0);
hold(hdl(1),'on')
hold(hdl(2),'on')
xlim(hdl(1),[0 1])
xlim(hdl(2),[0 1])
ylim(hdl(1),[min(floor(Phi*200)/200 ) max(ceil(Phi*200)/200 )])
ylim(hdl(2),[min(floor(Phi*200)/200 ) max(ceil(Phi*200)/200 )])

set(hdl(2),'ycolor',[ 0 0 0],'ytick',[],'xtick',[]);
set(hdl(1),'ycolor',[ 0 0 0],'Color',[0 0 0.75],'yaxislocation','left','FontSize',14,'xtick',(0:0.1:1)','ytick',(0:0.1:1)');

%levels=floor(max(dPdt_mean)/100);
%levels=15;



plotContourExpData(Ygas_fuel,Phi,dPdt_mean,hdl(1));

%Isoconcentration
i=Cdust>0;
Cdust_iso=  unique([round(exp(log(Dust.MEC*0.1):log(max(Cdust)*1/(Dust.MEC*0.1))/nisoC:log(max(Cdust)*1))) Dust.MEC]);
i=ygas>0;
Cgas_iso= unique([round(exp(log(Gas.LEL*0.2):log(max(ygas)/(Gas.LEL*0.2))/nisoC:log(max(ygas)))*1000)/1000 Gas.LEL Gas.UEL]);

isoCdust(Gas,Dust,Cdust_iso,false,hdl(2));
%isoCdust(Gas,Dust,Dust.MEC,true,hdl);
isoCgas(Gas,Dust,Cgas_iso, false, hdl(2));
%isoCgas(Gas,Dust,[Gas.LEL Gas.UEL], true, hdl);

lechatelier(hdl(2),Gas,Dust)
hold(hdl(1),'off')
hold(hdl(2),'off')

%..........................
%   Making surf
%.........................
% 
% hdl=subplot(1,2,2);
% plotSurfExpData(Phi,Ygas_fuel,dPdt_mean,100,100,hdl);





