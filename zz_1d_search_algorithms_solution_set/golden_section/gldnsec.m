function gldnsec = gldnsec(func,a0,b0,epsilon)
    
    hold on;
    
% initialisation
    n = 1;
    gamma = (sqrt(5) - 1)/2;
    N = ceil(log(epsilon/(b0 - a0)) / log(gamma));
    a = zeros(N,1);
    b = a; p = a; q = a;
    a(1) = a0;
    b(1) = b0;
    p(1) = b0 - gamma*(b0 - a0);
    q(1) = a0 + gamma*(b0 - a0);
    fp = func(p(1));
    fq = func(q(1));
    
    line([a(1) b(1)],[1 1]);
    
    while (b(n) - a(n)) > epsilon
        if fp < fq
            a(n + 1) = a(n);
            b(n + 1) = q(n);
            q(n + 1) = p(n);
            fq = fp;
            p(n + 1) = a(n + 1) + b(n + 1) - q(n + 1);
            fp = func(p(n + 1));
        else
            a(n + 1) = p(n);
            b(n + 1) = b(n);
            p(n + 1) = q(n);
            fp = fq;
            q(n + 1) = a(n + 1) + b(n + 1) - p(n + 1);
            fq = func(q(n + 1));
        end
        n = n + 1;
        line([a(n) b(n)],[n n]);
    end
    
    
    resultab = [a p q b (b-a)];
    disp(resultab);
    gldnsec = (a(n) + b(n)) / 2;
    
end