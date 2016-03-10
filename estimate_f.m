function [fgas, fdust, r,Phi_gas, Phi_dust, dPdt_gas, dPdt_dust]= ...
    estimate_f(gas, dust, Cdust, ygas, dPdt)
global P0 R T0

Cdust=Cdust/dust.W; %mole concentration of fust
Cgas=ygas*P0/(R*T0); %mole concenttration of gas

phi=(1/dust.fuel_O2*Cdust+1/gas.fuel_O2*Cgas)./(0.21*(1 ...
     -ygas)*P0/R/T0);
Phi=phi./(1+phi);
Phi_dust=Phi(ygas==0);
Phi_gas=Phi(Cdust==0);

 
 
dPdt_dust=dPdt(ygas==0);
dPdt_gas=dPdt(Cdust==0);

if(length(Phi_dust)>=5)
    ft = fittype( 'poly4' );
    opts = fitoptions( ft );
    opts.Lower = [-Inf -Inf -Inf -Inf -Inf];
    opts.Upper = [Inf Inf Inf Inf Inf];
    % Fit model to data.
    [fitresultdust, gofdust] = fit( Phi_dust, dPdt_dust, ft, opts );
    racines=roots([4*fitresultdust.p1 3*fitresultdust.p2 2*fitresultdust.p3 fitresultdust.p4]);
else
    ft = fittype( 'poly3' );
    opts = fitoptions( ft );
    opts.Lower = [-Inf -Inf -Inf -Inf];
    opts.Upper = [Inf Inf Inf Inf];
    % Fit model to data.
    [fitresultdust, gofdust] = fit( Phi_dust, dPdt_dust, ft, opts );
    racines=roots([4*fitresultdust.p1 3*fitresultdust.p2 2*fitresultdust.p3 fitresultdust.p4]);
end

%racines=roots([3*fitresultdust.p1 2*fitresultdust.p2 fitresultdust.p3]);
racines=racines(imag(racines)==0);
[maxdpdt i]=max(fitresultdust(racines));
racines=racines(i);
fdust=(1-racines)/racines;



if(length(Phi_gas)>=5)
    ft = fittype( 'poly4' );
    opts = fitoptions( ft );
    opts.Lower = [-Inf -Inf -Inf -Inf -Inf];
    opts.Upper = [Inf Inf Inf Inf Inf]; 
    
    [fitresultgas, gofgas] = fit( Phi_gas, dPdt_gas, ft, opts );
    racines=roots([4*fitresultgas.p1 3*fitresultgas.p2 2*fitresultgas.p3 fitresultgas.p4]);
    
else
    ft = fittype( 'poly3' );
    opts = fitoptions( ft );
    opts.Lower = [-Inf  -Inf -Inf -Inf];
    opts.Upper = [Inf  Inf Inf Inf]; 
    [fitresultgas, gofgas] = fit( Phi_gas, dPdt_gas, ft, opts );
    racines=roots([3*fitresultgas.p1 2*fitresultgas.p2 fitresultgas.p3]);
end
racines=racines(imag(racines)==0);
[maxdpdt i]=max(fitresultgas(racines));
racines=racines(i);
fgas=(1-racines)/racines;

hdl=getFigureHdl('Regresion Dust');
figure(hdl)
plot(Phi_dust,dPdt_dust, 'r*')
hold 'on'
x=min(Phi_dust):(max(Phi_dust)-min(Phi_dust))/(100):max(Phi_dust);
plot(x, fitresultdust(x),'b-');
hold 'off'

hdl=getFigureHdl('Regresion Gas');
figure(hdl)
plot(Phi_gas,dPdt_gas, 'r*')
x=min(Phi_gas):(max(Phi_gas)-min(Phi_gas))/(100):max(Phi_gas);
hold 'on'
plot(x, fitresultgas(x),'b-')
hold 'off'

if(fgas>0.8)
    fgas=1;
end

if(fdust>0.95)
    fdust=1;
end


r=[gofgas.rsquare gofdust.rsquare ];


end

