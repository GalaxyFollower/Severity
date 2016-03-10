function plotContourExpData(X,Y,Z,hdl)
% Function to plot contours of expewrimental data
% X,Y, Independent Variables
% Z, dependent variable
%m,n, number of divisions for x and y axes

Xu=unique(round(X(:)*1000)/1000);
Yu=unique(round(Y(:)*1000)/1000);


minX=min(Xu);
maxX=max(Xu);
nX=length(Xu);
dX=[minX;(Xu(2:nX)+Xu(1:nX-1))/2;maxX];
nX=100;
minY=min(Yu);
maxY=max(Yu);
nY=length(Yu);
dY=[minY;(Yu(2:nY)+Yu(1:nY-1))/2;maxY];
nY=100;


[XGrid, YGrid]=meshgrid(minX:(maxX-minX)/(nX-1):maxX, minY:(maxY-minY)/(nY-1):maxY);


%ZGrid=max(griddata(X,Y,Z,XGrid,YGrid,'cubic'),griddata(X,Y,Z,XGrid,YGrid,'natural'));
ZGrid=griddata(X,Y,Z,XGrid,YGrid,'natural');
%f=0.9;
%ZGrid=(f*griddata(X,Y,Z,XGrid,YGrid,'cubic') + (1-f)*griddata(X,Y,Z,XGrid,YGrid,'natural'));
%limZ=ceil(max(Z)/(2*10^floor(log10(max(Z)))))*(2*10^floor(log10(max(Z))));
rd=10.^(floor(log10((max(Z)))));
limZ=max(Z);
stp=round(limZ./rd)-mod(round(limZ./rd),5);
stp(stp==0)=1;
stp=stp.*rd/10;
stp(ceil(limZ./stp)>=20)=2*stp(ceil(limZ./stp)>=20);

limZ=max(max(Z),max(0:stp:max(Z)));
levelist=0:stp:limZ;
if(levelist(end)<limZ)
    levelist=[levelist levelist+stp];
end
levels=ceil(levelist(end)./stp)+1;
limZ=levelist(end);

%stp=round((limZ)/(levels));
[cont hdlctr]=contourf(hdl,XGrid,YGrid,ZGrid,levels);%,'ShowText','on');

%stp=floor((limZ)/(levels)*10)/10;%Pm
hold on;
plot3(hdl,X,Y,Z,'ko','MarkerFaceColor',[0 0 0]);
hold off
%limZ=1500;

set(hdlctr,'levellist',levelist);
hdlclb=contourcmap('jet',[0:stp:limZ],'colorbar','on');
themap=jet(levels);

set(hdl,'Color',themap(1,:));
set(hdlctr,'levellist',[0:stp:limZ]);
%caxis([0 limZ]);




hdllbl=get(hdlclb,'ylabel');
set(hdllbl,'string','$\left(\frac{d P}{d t}\right)_{max}  [\frac{bar}{s}]^$')
%set(hdllbl,'string','$P_\mathrm{m}$  $\mathrm{[bar]}$')%Pm
if(limZ<50)
    set(hdllbl,'string','P_{m} [ bar ]')
    set(hdllbl,'interpreter','tex')
else
    set(hdllbl,'string','$\mathsf{\left(\frac{d P}{d t}\right)_{max}~[~\frac{bar}{s}~]}$')
    set(hdllbl,'interpreter','latex')
end

set(hdllbl,'fontsize',20);
%xlabel(hdl,'\Upsilon_{gas} [ - ]','fontweight','bold', 'Interpreter','tex','Fontsize',20)
%ylabel(hdl,'\Phi_{eq} [ - ]', 'Interpreter','tex','fontweight','bold','Fontsize',20)
xlabel(hdl,'\Upsilon_{gas} [ - ]','fontweight','bold', 'Interpreter','tex','Fontsize',20)
ylabel(hdl,'\Phi_{eq} [ - ]', 'Interpreter','tex','fontweight','bold','Fontsize',20)

end

