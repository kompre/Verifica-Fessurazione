function [ tab ] = derivaCaratteristicheAcciaio()
%DERIVACARATTERISTICHE Summary of this function goes here
%   Detailed explanation goes here
tab = table;

tab.fyk = 450;
tab.ftk = 540;
tab.gamma_s = 1.15;
tab.fyd = tab.fyk/tab.gamma_s;
tab.Es = 210000;
tab.esu = 67.5e-3;
tab.eyd = tab.fyd/tab.Es;

end