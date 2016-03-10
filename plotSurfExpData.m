function plotSurfExpData(X,Y,Z,m,n,hdl)
% Function to plot contours of expewrimental data
% X,Y, Independent Variables
% Z, dependent variable
%m,n, number of divisions for x and y axes

minX=min(X);
maxX=max(X);
minY=min(Y);
maxY=max(Y);
 
[XGrid, YGrid]=meshgrid(minX:(maxX-minX)/(m-1):maxX, ...
     minY:(maxY-minY)/(n-1):maxY);

% 
% [XGrid, YGrid]=meshgrid(minX:(maxX-minX)/(m-1):maxX, ...
%     unique(Y));
ZGrid=griddata(X,Y,Z,XGrid,YGrid,'cubic');
% surf(hdl,XGrid,YGrid,ZGrid);
% hold on;
% plot3(hdl,X,Y,Z,'ko');

surf(hdl,XGrid,YGrid,ZGrid);
hold on;
plot3(hdl,X,Y,Z,'ko','MarkerFaceColor',[0 0 0]);


hold off
end

