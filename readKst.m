clc
clear
A=xlsread('niacine-acetone');

tv=unique(A(:,4));
%separating each tv
colours='rgbcmy';
markers='+o*.xsd^><ph';

for i=1:length(tv)
    
    j=A(:,4)==tv(i);
    Cdust=A(j,1); 
    Cgas=A(j,2);
    Kst=A(j,3);
    hdl=getFigureHdl([num2str(tv(i)) 'ms']);
    plotContourExpData(Cdust,Cgas,Kst,20,20,hdl);
end



