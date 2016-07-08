function [es,esCi,chi2,p]=cramerV(table,nRow,nCol,confLevel)
% this function computes Cramer's V, including exact analytical CI
% ** NOTE: in the case of 2 by 2 tables Cramer's V is identical to phi
% except possibly for the sign), which will be taken care of in the last
% lines
%Ajout personnel
table=double(table);
%Fin ajout personnel
colSum=sum(table);
rowSum=sum(table,2);
n=sum(sum(table));
k=min(nRow,nCol);
df=(nRow-1)*(nCol-1);
% expected frequency of occurrence in each cell: product of row and
% column totals divided by total N
ef=(rowSum*colSum)/n;
% chi square stats
chi2=(table-ef).^2./ef;
chi2=sum(chi2(:));
p = 1-chi2cdf(chi2,df);
% Cramer's V
es=sqrt(chi2/(n*(k-1)));
% CI (Smithson 2003, p. 40)
ncp=ncpci(chi2,'X2',df,'confLevel',confLevel);
esCi=sqrt((ncp+df)/(n*(k-1)));

