dfdx = @(x)(4*x^3 - 12*x^2 + 1);

d2fdx2 = @(x)(12*x^2 - 24*x);

newton(dfdx,d2fdx2,-5,5,5*10^-5)