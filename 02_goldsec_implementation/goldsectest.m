% func = @(x)(-4*x^3 - 9*x^2 + 30*x);
% goldsec(func,-10,10,1)

% func = @(x)(x^4 - 4*x^3 + 6);
% goldsec(func,-10,10,2)

% func = @(x)(-4*x.^3 - 9*x.^2 + 30.*x);
% goldsec(func,-3,0,0.2)

func = @(x)(x.^3 - x).*exp(1 - x.^2);
goldsec(func,-4,1,.01)
