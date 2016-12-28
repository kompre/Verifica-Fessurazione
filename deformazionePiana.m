function [ e1, e2 ] = deformazionePiana( x, L, d, ecu, esu, ec2 )
%DEFORMAZIONEPIANA calcolo della deformazioni agli estremi della sezione 
%   calcolo dei valori di deformazione ai lembi estremi della sezione di
%   altezza L, dato la distanza x dell'asse neutro da un lembo della
%   sezione. L'origine è coincidente con il valore di deformazione e1
%
%   Varibiali di input:
%       ecu:    deformazione ultima del cls
%       ec2:    deformazione cls per sezione interamente reagente      
%       esu:    deformazione ultima dell'acciaio [DEVE ESSERE NEGATIVO]
%       x:  distanza dell'asse neutro dall'origine
%       L:  altezza totale della sezione
%       d:  distanza dell'armatura dal'origine
%
%   Variabili di output:
%       e1: deformazione della sezione al lembo coincidente con l'origine
%       e2: deformazione della sezione al lembo estremo della sezione

limite_campo2_campo3 = ecu/(ecu-esu)*d;

if x <= limite_campo2_campo3
    e1 = x/(d-x)*(-esu);
    e2 = (L-x)/(d-x)*esu;
elseif x <= L
    e1 = ecu;
    e2 = -(L-x)/x*ecu;
else
    e1 = x/(x-3/4*L)*ec2;
    e2 = (x-L)/(x-3/4*L)*ec2;
end
end

