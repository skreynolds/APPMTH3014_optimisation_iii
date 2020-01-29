function xstar = newton(symfunc,x0,tol)
    % Initialisation
    n=1;
    x(1)=x0;
    funcd = matlabFunction(diff(symfunc));
    funcdd = matlabFunction(diff(diff(symfunc)));
    
    while true
        fd = funcd(x(n));
        fdd = funcdd(x(n));
        
        if fdd ~= 0
            x(n+1) = x(n) - fd/fdd;
            n = n+1;
        else
            disp('Start again at a different x0');
            break
        end
        if abs(fd) < tol || n>10000
            xstar = x(n);
            disp([(1:n)' x']);
            disp(xstar);
            break
        end
    end
end