function [xstar,x,u,lambda,beta] = conjgrad(A,b,c,x0)
% Step 1
k = 1;
N = size(x0,1);
x(1:N,k) = x0;

% Step 2
g(1:N,k) = A*x0 + b;
if abs(g(:,k)) < 10*eps
    xstar = x0;
    return
end
u(:,k) = -g(:,k);

while true
    % Step 3
    lambda(k) = -(g(:,k)'*u(:,k)) / (u(:,k)'*A*u(:,k));
    
    % Step 4
    x(:,k+1) = x(:,k) + lambda(k)*u(:,k);
    
    % Step 5
    g(:,k+1) = A*x(:,k+1) + b;
    if abs(g(:,k+1)) < 10*eps
        xstar = x(:,k+1);
        return
    end
    
    % Step 6
    beta(k) = (g(:,k+1)'*A*u(:,k)) / (u(:,k)'*A*u(:,k));
    
    % Step 7
    u(:,k+1) = -g(:,k+1) + beta(k)*u(:,k);
    
    % Step 8
    k = k+1;
    
end

if ~(xstar == 0)
    xstar = x(:,end);
end


end