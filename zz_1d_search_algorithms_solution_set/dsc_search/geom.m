function [z1, z2, z3, s] = geom(func,x0,h)
    
n = 1;
x(1) = x0;
x(2) = x(1) + h;

if func(x(2)) > func(x(1))
    x(1) = x(2); x(2) = x0;
    h = -h;
end

while func(x(n+1)) <= func(x(n))
    n = n + 1;
    x(n+1) = x0 + h*2^(n-1);
end
restab = [(1:n+1)' x' func(x)'];
disp(restab);

if n == 1
    z1 = x0; z2 = x0+h; z3 = x0+2*h;
    s=h;
else
    xbar = (x(n)+x(n+1))/2;
    if func(x(n)) < func(xbar)
        z1 = x(n-1); z2 = x(n); z3 = xbar;
    else
        z1 = x(n); z2 = xbar; z3 = x(n+1);
    end
    s = h*2^(n-2);
end

if h<0
    placeholder = z1;
    z1 = z3;
    z3 = placeholder;
end

end