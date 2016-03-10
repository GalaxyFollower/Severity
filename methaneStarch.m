clc
clear
A=xlsread('methane-starch');


%separating each tv
colours='rgbcmy';
markers='+o*.xsd^><ph';
    

Yfuel=A(:,1); 
phi=A(:,2);
Phi=A(:,3);
Pm=A(:,4);
stdevPm=A(:,5);
dPdt=A(:,6);
stdevdPdt=A(:,7);

yfuel=unique(Yfuel);
for i=1:length(yfuel)
    dPdtnorm(Yfuel==yfuel(i))=dPdt(Yfuel==yfuel(i)),%/max(dPdt(Yfuel==yfuel(i)));
end



hdl=getFigureHdl('Starch-Methane');
plotContourExpData(Phi,Yfuel,dPdtnorm,20,20,hdl);


