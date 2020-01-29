%% Steepest Decent Algoorithm
% You need to specify a function f expressed in symbolic form and the
% vector of variables x that you have specified also in symbolic form

function steepdesc = steepdesc(f,x,x0,tol)

% Create the grad vector
delf = simplify(jacobian(f,x))';
pretty(delf)

% Initialise k as zero
k = 1;
xk = x0;
syms lambda

while norm(subs(delf,x,xk)) > tol
    u = -subs(delf,x,xk);
    g = subs(f,x,xk+lambda*u);
    func = @(x)(double(subs(g,lambda,x)));
    % lambdastar = fibon(func,0,1,0.001);
    lambdastar = dichot(func,0,1,0.001);
    xk = xk + lambdastar*u;
    f_val = subs(f,x,xk);
    fprintf('\n  k=%3d,  f(x) = %14.10f, lambdastar=%.12f, ||grad(f(x))||=%14.10f\n', k, f_val, ...
	  double(lambdastar),double(sqrt(sum(-u).^2)));
    fprintf('\nx = %14.10f, %14.10f, %14.10f, %14.10f,\n',xk);
    k = k + 1;
    if k == 30
        break
    end
end

steepdesc = xk;

end