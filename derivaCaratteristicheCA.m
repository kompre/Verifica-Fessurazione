function [ tab ] = derivaCaratteristiche( f_ck, R_ck )
%DERIVACARATTERISTICHE Summary of this function goes here
%   Detailed explanation goes here

ni = .2; % coefficiente di Poisson
gamma_cls = 1.5;
alpha_cc = .85;

f_cd = alpha_cc*f_ck/gamma_cls;

f_cm = f_ck +8;

if f_ck <= 50
    f_ctm = .3 *f_ck^(2/3);
else
    f_ctm = 2.12 * log(1+f_cm/10);
end

f_ctk05 = .7 * f_ctm;

f_ctk95 = 1.3 * f_ctm;

E_cm = 22*(f_cm/10)^.3 * 1E3;

G = E_cm/(2*(1+ni));

if f_ck <= 50
    varepsilon_cu = 3.5;
else
    varepsilon_cu = 2.6 + 35*((90-f_ck)/100)^4;
end

if f_ck <= 50
    varepsilon_c2 = 2;
else
    varepsilon_c2 = 2 + .085*(f_ck-50)^.53;
end

if f_ck <= 50
    varepsilon_c3 = 1.75;
else
    varepsilon_c3 = 1.75 + .55*(f_ck-50)/40;
end


if f_ck <= 50
    varepsilon_c4 = .7;
else
    varepsilon_c4 = .2*varepsilon_cu;
end

f_bk = 2.25 * f_ctk05;

tab = table(f_ck,R_ck,gamma_cls,alpha_cc,f_cd,f_cm,f_ctm,f_ctk05,f_ctk95,f_bk,E_cm,ni,G,varepsilon_cu,varepsilon_c2,varepsilon_c3,varepsilon_c4);

end

