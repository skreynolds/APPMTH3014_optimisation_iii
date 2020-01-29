function fibon = fibon(func,a0,b0,epsilon)

    % initialisation

    FN1 = ceil((b0 - a0) / epsilon);

    %Determine N and the sequence of fib numbers
    fib(1) = 1;
    fib(2) = 2;
    k = 2;

    while FN1 > fib(k)
        fib(k + 1) = fib(k) + fib(k-1);
        k = k + 1;
    end
    
    % initialisation    
    N = length(fib)-1;
    a = zeros(N,1);
    b = a; p = a; q = a; I = a; fnp = a; fnq = a;
    gamma0 = fib(N)/fib(N+1);
    a(1) = a0;
    b(1) = b0;
    p(1) = b0 - gamma0*(b0 - a0);
    q(1) = a0 + gamma0*(b0 - a0);
    fp = func(p(1));
    fq = func(q(1));
    I(1) = b0 - a0;
    fnp(1) = fp;
    fnq(1) = fq;
    
    for n = 1:(N-1)
        if fp < fq
            a(n+1) = a(n);
            b(n+1) = q(n);
            q(n+1) = p(n);
            fq = fp;
            p(n+1) = a(n+1) + b(n+1) - q(n+1);
            fp = func(p(n+1));
            fnp(n+1) = fp;
            fnq(n+1) = fq;
        else
            a(n+1) = p(n);
            b(n+1) = b(n);
            p(n+1) = q(n);
            fp = fq;
            q(n+1) = a(n+1) + b(n+1) - p(n+1);
            fq = func(q(n+1));
            fnp(n+1) = fp;
            fnq(n+1) = fq;
        end
        I(n+1) = b(n+1) - a(n+1);
    end

    if func(p(end)-0.001) < fp
        a(end+1) = a(end);
        b(end+1) = p(end);
    else
        a(end+1) = p(end);
        b(end+1) = b(end);
    end
    
    tabres = [a(1:(end-1)) p q b(1:(end-1)) fnp fnq I];
    disp(tabres);
    fibon = (a(end)+b(end))/2;
    
end
