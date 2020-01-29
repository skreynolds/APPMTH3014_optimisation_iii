function [x_star, p, X, g, lambda, beta, U, time_cg, time_d] = conjugate_gradient(A, b, c, x0)
% conjugate_gradient.m, (c) Matthew Roughan, 2012
%
% created: 	Tue Feb 21 2012 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% Find the minimiser of the quadratic function
%        f(x) = 1/2 x'Ax + b'x + c
%      where A is positive definite and symmetric.
% 
%
% INPUTS: (all real valued)
%        A = NxN matrix, which should be symmetric and positive definite
%        b = Nx1 vector
%        c = scalar
%        x0 = optional starting point
%
% OUTPUTS:        
%        x_star = minimiser, found using conjugate gradient
%        p      = minimiser, found directly by completing the square so
%                 that 
%                      f(x) = 1/2 (x-p)' A (x-p) + d
%        X       = Nx(k+1) matrix whose columns are the estimated points at 
%                   each step (k is nuber of steps <= N, and only < N when
%                   the algorithm converges early)
%        g       = Nxk matrix whose columns are the gradients at each point
%        lambda  = Nx1 vector of distances (along a search direction)
%        beta    = Nx1 vector
%        U       = an NxN matrix whose colums are the search directions, 
%                  which are chosen to be mutually conjugate WRT to A
%        time_cg = time take by conjugate gradient
%        time_d  = time take by direct method
%
%
% EXAMPLES:
%        A = [[3 1 0]; [1 2 1]; [0 1 4]];
%        b = [3 2 1]';
%        c = 0;
%        [x_star, p, X, g, lambda, time_cg, time_d] = conjugate_direction(A, b, c, x0)
%            
%     or create a positive definite matrix by taking M'*M (for real matrix M)
% 
% NB: Matlab's 'quadprog' also solves quadratic programs
%     and is probably a lot better at it, but may be harder to read.

% check input matrix is square
sa = size(A);
if (sa(1) ~= sa(2))
    error('conjugate_vectors: matrix A must be square.');
end
N = sa(1);

% check input matrix is symmetric
max_diff = max(max(abs(A - A')));
if (max_diff >= 10*eps)
    error('conjugate_directions: matrix A is not symmetric.');
end

% check input matrix is positive definite
%    there is probably a faster way to check this though
eigenvalues = eig(A);
if (any(eigenvalues <= 0))
   error('conjugate_directions: matrix A is not positive definite.');
end

% check b is consistent (in size)
sb = size(b); 
if (sb(1)~=N || sb(2)~=1)
   error('conjugate_directions: vector b is the wrong size.'); 
end

% set a default starting point
if (nargin < 4)
    x0 = zeros(N,1); % for want of a better starting point
end


% now compute conjugate vectors according to algorithm on p.69
% first obtain conjugate vectors
tic;
X(:,1) = x0;
lambda = zeros(N,1);
beta = zeros(N,1);
g(:,1) = A*X(:,1) + b;
if (all(abs(g(:,1))<10*eps))
        return;
end
U(:,1) = -g(:,1);
for k=1:N
    lambda(k) = - (g(:,k)'*U(:,k)) / ( U(:,k)'*A*U(:,k) );
    X(:,k+1) = X(:,k) + lambda(k)*U(:,k);
    g(:,k+1) = A*X(:,k+1) + b;
    if (all(abs(g(:,k+1))<10*eps))
        break; 
    end
    beta(k) = (g(:,k+1)'*A*U(:,k)) / ( U(:,k)'*A*U(:,k) );
    U(:,k+1) = -g(:,k+1) + beta(k)*U(:,k);
end
x_star = X(:,end);
time_cg = toc;


% now compute the solution directly for comparison
tic;
p = -inv(A)*b;
time_d = toc;








