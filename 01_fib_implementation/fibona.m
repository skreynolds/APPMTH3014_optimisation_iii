function fibona(func,a1,b1,err)


% Determine the number that Fn has to be greater than, which
% will in turn allow us to determine N
    int = 2*err;
    Fn = ceil((b1 - a1)/int);

%Determine N and the sequence of fib numbers
    f(1) = 1;
    f(2) = 2;
    k = 2;

    while Fn > f(k)
        f(k + 1) = f(k) + f(k-1);
        k = k + 1;
    end

% Set initial conditions for the algorithm
    j = length(f);
    a = zeros(j,1);
    b = zeros(j,1);
    p = zeros(j,1);
    q = zeros(j,1);
    fp = zeros(j,1);
    fq = zeros(j,1);
    
    a(1) = a1;
    b(1) = b1;
    p(1) = b1 - f(j-1)/f(j)*(b1 - a1);
    q(1) = a1 + f(j-1)/f(j)*(b1 - a1);
    fp(1) = func(p(1));
    fq(1) = func(q(1));

    for i = 2:(j-1)
    
        if  fp(i-1) < fq(i-1)
            a(i) = a(i-1);
            b(i) = q(i-1);
            q(i) = p(i-1);
            p(i) = a(i) + b(i) - q(i);
        else
            a(i) = p(i-1);
            b(i) = b(i-1);
            p(i) = q(i-1);
            q(i) = a(i) + b(i) - p(i);
        end
        
        fp(i) = func(p(i));
        fq(i) = func(q(i));
        
    end


    f(j) = func(p(j-1) - eps);
    
    n = 1:length(f);
    
    RES = [transpose(n) a p q b fp fq (abs(b - a))];
    disp(RES);
    
    if f(j) > f(j-1)
        x = (p(j-1) + b(j-1))/2;
        disp(x);
    else
        x = (a(j-1) + p(j-1))/2;
        disp(x);
    end
        

end