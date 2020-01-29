function xstar = dsc(func,x0,h,cont,tol)
    n=1;
    x(1)=x0;
    while true
        [z1 z2 z3 s] = geom(func,x(n),h);
        xstar = z2 + (s/2) * (func(z1)-func(z3)) ...
                    /(func(z1)-2*func(z2)+func(z3));
        x(n+1) = xstar;
        h = cont*h;
        n = n+1;
        disp(xstar);
        if z3-z1 <= tol
            break
        end
    end
end