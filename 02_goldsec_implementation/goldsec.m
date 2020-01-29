function goldsec(func,ao,bo,err)

gamma = (sqrt(5)-1)/2;
k = 1;
a = ao;
b = bo;
q = ao + gamma*(bo - ao);
p = bo - gamma*(bo - ao);

fq = func(q);
fp = func(p);

n = ceil((log(err/(b -a))/log(gamma)));

errTable = zeros(n,8);

errTable(k,1) = k - 1;
errTable(k,2) = a;
errTable(k,3) = p;
errTable(k,4) = q;
errTable(k,5) = b;
errTable(k,6) = fp;
errTable(k,7) = fq;
errTable(k,8) = b - a;

while abs((b - a)) > err

    if fp < fq
        b = q;
        q = p;
        p = a + b - q;
    else
        a = p;
        p = q;
        q = a + b - p;
    end

k = k + 1;

errTable(k,1) = k - 1;
errTable(k,2) = a;
errTable(k,3) = p;
errTable(k,4) = q;
errTable(k,5) = b;
errTable(k,6) = fp;
errTable(k,7) = fq;
errTable(k,8) = b - a;
    
fq = func(q);
fp = func(p);

end

xstar = (a + b)/2;
disp(errTable);
disp(xstar);

end