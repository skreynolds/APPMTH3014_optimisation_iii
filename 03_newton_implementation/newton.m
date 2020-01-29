function newton(dfdx,d2fdx2,a0,b0,err)

int = err*2;

%x(1) = (b0 - a0)/2;
x(1) = 4;
x(2) = x(1) - (dfdx(x(1))/d2fdx2(x(1)));

k = 2;

while abs(x(k-1)-x(k)) > int
    
    x(k+1) = x(k) - (dfdx(x(k))/d2fdx2(x(k)));
    
    k = k + 1;
end

RES = [(0:(length(x)-1))' x'];

disp(RES);

end