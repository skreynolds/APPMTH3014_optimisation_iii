%
% conjugate_gradient_test.m, (c) Matthew Roughan, 2013
%
% created: 	Wed May 15 2013 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% Q3 in CE 4
%         
%
%

A = [[5 2 1]; [2 1 0]; [1 0 2]];
b = [-3; -1; 0];
c = 0;
x0 = [0; 0; 0];

[x_star, p, X, g, lambda, beta, U, time_cg, time_d] = conjugate_gradient(A, b, c, x0);

for i=1:size(X,2)
  if (i<size(X,2))
    fprintf('%d & (%.3f,%.3f,%.3f) & (%.3f,%.3f,%.3f) &  %.3f \\\\ \n', i-1, X(:,i), U(:,i), lambda(i));
  else
    fprintf('%d & (%.3f,%.3f,%.3f) & &  \\\\ \n', i-1, X(:,i));
  end
end
