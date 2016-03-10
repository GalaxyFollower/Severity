function  series=plotIsoYgas(gas, dust, Cdust, ygas, dPdt)
global P0 V R T0

Cdust=Cdust/dust.W; %mole concentration of fust
Cgas=ygas*P0/(R*T0); %mole concenttration of gas

phi=(dust.f/dust.fuel_O2*Cdust+gas.f/gas.fuel_O2*Cgas)./(0.21*(1 ...
     -ygas)*P0/R/T0);
Phi=phi./(1+phi);


Ygas=round(Cgas/gas.fuel_O2./(Cgas/gas.fuel_O2+Cdust/dust.fuel_O2)*20)/20;
[y ]=unique(Ygas);

hdl=getFigureHdl('Regresion');
figure(hdl)
set(hdl,'position',[ 77   777   633   800])

clf
axes1 = axes('Parent',hdl,'YGrid','on','XGrid','on',...
    'Position',[0.18 0.12 0.75 0.85],...
    'FontSize',14);
box(axes1,'on');
xmin=round(min(Phi)*20)/20
xmax=round(max(Phi)*20)/20

k=1;
for i=1:length(y)

    Phi_yi=round(Phi(Ygas==y(i))*50)/50; 
    dPdt_yi=dPdt(Ygas==y(i));
    phi_yi=unique(Phi_yi);
    n=length(phi_yi);
    dPdt_mean=zeros(n,1);
    dPdt_std=zeros(n,1);
    
    for j=1:length(phi_yi)
        dPdt_mean(j)=mean(dPdt_yi(Phi_yi==phi_yi(j)));
        dPdt_std(j)=std(dPdt_yi(Phi_yi==phi_yi(j)));
    end
    
    
    if(i>-1)
      plotseries(Phi_yi,dPdt_yi,phi_yi,dPdt_mean,dPdt_std,y(i))
      name{(k-1)*3+1,1}='';
      name{(k-1)*3+2,1}=['$\Upsilon_\mathrm{gas}=$' num2str(y(i))];
      name{(k-1)*3+3,1}='';
      
      series(k).name=['$\Upsilon_\mathrm{gas}=$' num2str(y(i))];
      series(k).dPdt_yi=[Phi_yi dPdt_yi];
      series(k).dPdt_mean=[phi_yi dPdt_mean dPdt_std];
      
      k=k+1;
    end
end

makelegend(name)
end

function makelegend(name)


hdl=legend(name,'interpreter','latex','edgecolor',[0 0 0],'position',[0.144 0.185 0.12 0.82]);
child=get(hdl,'children');
set(hdl,'Interpreter','latex',...
    'Position',[0.2 0.7 0.25 0.25],...
    'FontSize',15);
j=1;
for i=1:length(child)
    if(strcmp(get(child(i),'type'),'line'))
     
        child2(j)=child(i);  
       %fprintf([ num2str(j) '\t[' num2str(get(child(i),'color'))  ']\t' ...
           %'[' num2str(get(child(i),'Ydata')) ']\n' ])
              j=j+1;
    elseif( strcmp(get(child(i),'type'),'text'))
        set(child(i),'fontsize',15)
    else

    end
          
end
j=1;
for i=1:length(child2)
    set(child2(i),'markersize',6)
    if(j==1)
        ydata=get(child2(i),'ydata');
    elseif(j==4)
        j=0;
        set(child2(i),'ydata', ydata*ones(size(get(child2(i),'ydata'))) )
    else
        set(child2(i),'ydata', ydata*ones(size(get(child2(i),'ydata'))) )
    
    end
    j=j+1;
end
xlabel('$\Phi_\mathrm{eq}$ [ - ]','interpreter','latex','fontsize',30)
ylabel('$\left(\frac{\mathrm{d}P}{\mathrm{d}t}\right)_\mathrm{max} \left[\mathrm{\frac{bar}{s}}\right]$ ','interpreter','latex','fontsize',30)

end
function plotseries(Phi_yi,dPdt_yi,phi_yi,dPdt_mean,dPdt_std,yi)
color=[.43 .19 0.63
       0 0.69 0.31
       1 0 0
       0 0.44 .75
       1 0.75 0
       ];
   
   Yi=[0 0.05 0.4 0.75 1]';
   i=find(yi==Yi);
   
	marker='o^sdp+'; 
    hold 'on'
    plot(Phi_yi,dPdt_yi,'linestyle','none', 'marker', marker(i), ...
        'markerfaceColor',color(i,:),'color',color(i,:),'markersize',5)
    ft = fittype( 'smoothingspline' );
    opts = fitoptions( ft );
    [fitresult, gof] = fit( phi_yi,dPdt_mean, ft, opts );

    
     hold 'on'
    x=min(Phi_yi):(max(Phi_yi)-min(Phi_yi))/(100):max(Phi_yi);
    plot(x, fitresult(x),'color',color(i,:),'linewidth',2 );  
    %plot(phi_yi,dPdt_mean,'color',color(i,:))
    errorbar(phi_yi,dPdt_mean,dPdt_std,'linestyle','none','color',color(i,:))
    hold 'off'
end
