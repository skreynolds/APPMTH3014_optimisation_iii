%
% steepest_descent_ex14.m, (c) Matthew Roughan, 2012
%
% created: 	Tue Apr 10 2012 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% STEEPEST_DESCENT_EX14: example 14, from p.59 of notes
%    showing steepest descent
%
%    and compare to conjugate directions
%

clear

% create 4 real variables 
syms x1 x2 lambda real
x = [x1; x2];

% define the function of interest
% f = x1^4 + 4*x1^2*x2^2 - 2*x1^2 +2*x2^2 - 1;
% f = 10*x1^2 +2*x1*x2 + x2^2;
f = 5*x1^2 + x2^2 + 4*x1*x2 - 14*x1 - 6*x2;

% note that when f is a scalar function, the Jacobian returns the gradient
grad = simplify(jacobian(f, x))';
pretty(grad)

% now compute the Hessian
hessian = simplify(jacobian(jacobian(f,x),x))';
pretty(hessian)

% do the first iteration of Steepest descent
fprintf('+++++++++++++++++++\nFirst step of Steepest descent method\n+++++++++++++++++++\n');
x_step_0 = [0,10]';
f_val = subs(f, x, x_step_0)
grad_f = subs(grad, x, x_step_0);
u0 = - grad_f
g = subs(f, x, x_step_0 + lambda*u0)
g = simplify(g)
g_d = diff(g)
lambda_0 = 0.0700224;
% do a Fibonacci search on a wide range
a0 = 0; b0 = 1; epsilon = 0.000001;
G = @(x) double(subs(g, lambda, x));
[lambda_00, f0, a, b, error_est] = fibonacci_search(G, a0, b0, epsilon, 0);
% following were a bit strange but now work?
% [lambda_ds, f0, a, b, error_est] = dichotomous_search(G, a0, b0, epsilon, 0);
% [lambda_gs, f0, a, b, error_est] = goldensection_search(G, a0, b0, epsilon, 0);
% [lambda_fs, f0, a, b, error_est] = fibonacci_search(G, a0, b0, epsilon, 0);

fprintf('  lambda_0 (notes) = %.12f,  g''(lambda_0) = %.12f\n', lambda_0, double(subs(g_d, lambda, lambda_0)));
fprintf('  lambda_0 (calc)  = %.12f,  g''(lambda_0) = %.12f\n', lambda_00, double(subs(g_d, lambda, lambda_00)));
x_step_1 = x_step_0 + lambda_00 * u0

% do the second iteration of Steepest descent
fprintf('+++++++++++++++++++\nSecond step of Steepest descent method\n+++++++++++++++++++\n');
f_val = subs(f, x, x_step_1)
grad_f = subs(grad, x, x_step_1);
u1 = - grad_f
g = subs(f, x, x_step_1 + lambda*u1);
g = simplify(g);
g_d = diff(g);
lambda_1 = 0.316159;
a0 = 0; b0 = 1; epsilon = 0.000001;
G = @(x) double(subs(g, lambda, x));
[lambda_11, f1, a, b, error_est] = dichotomous_search(G, a0, b0, epsilon, 0);
fprintf('  lambda_1 (notes) = %.12f,  g''(lambda_1) = %.12f\n', lambda_1, double(subs(g_d, lambda, lambda_1)));
fprintf('  lambda_1 (calc)  = %.12f,  g''(lambda_1) = %.12f\n', lambda_11, double(subs(g_d, lambda, lambda_11)));

x_step_2 = x_step_1 + lambda_11 * u1



% repeat the steps Steepest descent
fprintf('+++++++++++++++++++\nRepeat Steepest descent method\n+++++++++++++++++++\n');
x_k = x_step_0;
N = 10;
for i=1:N
  f_val = subs(f, x, x_k);
  xs(:,i) = double(x_k);
  fs(i) = double(f_val);
  grad_f = subs(grad, x, x_k);
  u = - grad_f;
  g = subs(f, x, x_k + lambda*u);
  g_d = diff(g);
  a0 = 0; b0 = 10; epsilon = 0.0001; % precision chosen to match what happens in notes
  G = @(x) double(subs(g, lambda, x));
  [lambda_k, f1, a, b, error_est] = dichotomous_search(G, a0, b0, epsilon, 0);
  fprintf('  i=%3d,  f(x) = %14.10f, lambda=%.12f, ||grad(f(x))||=%14.10f\n', i-1, f_val, ...
	  double(lambda_k), double(sqrt(sum(grad_f.^2))));
  
  x_k = x_k + lambda_k * u;
end
f_val = subs(f, x, x_k);
grad_f = subs(grad, x, x_k);
i = i + 1;
fprintf('  i=%3d,  f(x) = %14.10f, ||grad(f(x))||=%14.10f\n', i-1, double(f_val), double(sqrt(sum(grad_f.^2))));
xs(:,i) = x_k;
fs(i) = double(f_val);
x_k

% plot the results
[X,Y] = meshgrid(-1:0.05:2);
% for i=1:size(X,1)
%   for j=1:size(X,2)
%     Z(i,j) = subs(f, [x1 x2], [X(i,j), Y(i,j)]);
%   end
% end
Z = double(subs(f, {x1, x2}, {X, Y}));

figure(1)
hold off
contour(X, Y, Z, [10 7 fs(1:3)]);
hold on
plot(xs(1,:), xs(2,:), 'bo-');
axis equal 

[X,Y] = meshgrid(-1:0.2:2);
Z = subs(f, {x1, x2}, {X, Y});
figure(2)
hold off
mesh(X,Y,Z);
hold on
plot3(xs(1,:), xs(2,:), fs, 'ro-', 'linewidth', 2);
set(gca, 'zlim', [-2.5 5]);

% compare the results for a quadratic with conjugate directions
f = 10*x1^2 +2*x1*x2 + x2^2;
A = [[20 2]; [2 2]];
b = [0;0];
c = 0;
x0 = [1,1]';

figure(10)
hold off
[X,Y] = meshgrid(-1.3:0.01:2);
Z = double(subs(f, {x1, x2}, {X, Y}));
contour(X, Y, Z, [10 7 fs(1:3)]);
hold on
plot(xs(1,:), xs(2,:), 'bo-');
axis equal 

%[x_star, p, X, g, alpha, U, time_cg, time_d] = conjugate_direction(A, b, c, x0)
%plot(X(1,:), X(2,:), 'gx-');

pause
[x_star, p, X, g, alpha, beta, U, time_cg, time_d] = conjugate_gradient(A, b, c, x0)
plot(X(1,:), X(2,:), 'rd-');






