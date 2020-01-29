function dichotstar = dichot(func,a0,b0,epsilon)

% Assumptions

hold on;

N = ceil(log((b0 - a0)/epsilon)/log(2));

n = 1;
a = zeros(N,1);
b = a; c = a; d = a; e = a;
a(1) = a0;
b(1) = b0;

line([a(1) b(1)],[1 1]);

while abs(b(n) - a(n)) > epsilon
    c(n) = (a(n) + b(n))/2;
    d(n) = (a(n) + c(n))/2;
    e(n) = (b(n) + c(n))/2;
    
    fc(n) = func(c(n));
    fd(n) = func(d(n));
    fe(n) = func(e(n));
    
    if fd(n) < fc(n)
        a(n + 1) = a(n);
        b(n + 1) = c(n);
    else
        if fc(n) > fe(n)
            a(n + 1) = c(n);
            b(n + 1) = b(n);
        else
            a(n + 1) = d(n);
            b(n + 1) = e(n);
        end        
    end
    
    n = n + 1;
    line([a(n) b(n)],[n n]);
end

dichotstar = (a(n) + b(n))/2;
disp(dichotstar);
tabdisp1 = [a [d;0] [c;0] [e;0] b];
disp(tabdisp1);
tabdisp2 = [fd' fc' fe'];
disp(tabdisp2);

end