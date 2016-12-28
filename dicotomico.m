function [ xm ] = dicotomico( M,V,q,cost,intervallo )
%DICOTOMICO Summary of this function goes here
%   intervallo = [a,b]
for i = 1:2
    m(i) = momento(M,V,q,intervallo(i))-cost;
    if m(i) < 0
        a = intervallo(i);
    else
        b = intervallo(i);
    end
end

errore = abs(a-b)/2;

while errore >= .001
    xm = (a+b)/2;
    Fx = momento(M,V,q,xm)-cost;
    if Fx < 0
        a = xm;
    else
        b = xm;
    end
    errore = abs(b-a)/2;
end

end

