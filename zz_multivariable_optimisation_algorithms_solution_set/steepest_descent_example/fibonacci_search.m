function [estimate, f, a, b, error_est] = fibonacci_search(func, a0, b0, epsilon, plot_on)
%
% fibonacci_search.m, (c) Matthew Roughan, 2012, 2013
%
% created: 	Tue Feb 21 2012 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% FIBONACCI_SEARCH performs the fibonacci section search for a minimum on the function 'func'
%     a(i) is the lower endpoint of the search interval at the beginning 
%     of the i-th iteration; b(i) is the upper endpoint.
%     l(i) is the length of the interval [a(i),b(i)]; 
%
% Note that indices vary from those in lectures because Matlab arrays start at i=1, not 0
%
% INPUTS:
%        funct   = function handle for the function to minimize
%                   must be a simple function of one variable
%        a0      = initial lower bound
%        b0      = initial upper bound
%        epsilon = max width of interval at termination 
%        plot_on = 1 if you want to plot the results (and see tables of them)
%                = 2 to get LaTex ready output
%         
% OUTPUTS:        
%        estimate = the estimate of the location of the minimum
%        f = final value of function at x
%        a, b = vectors of the intervals
%        error_est = max error in the estimate
%
% EXAMPLES:
%        fibonacci_search(@cos,  0, 6, 0.001, 1)
%           will do a search to find pi
%
%        fibonacci_search(@ex_func,  1, 2, 0.001, 1)
%           shows a search on an arbitrary function
%
%        fibonacci_search(@ex_func2, 1, 2, 0.001, 1)
%           shows a search on a discontinuous function
%
%        fibonacci_search(@ex_func,  0, 2, 0.001, 1)
%           shows a search on an arbitrary multi-modal function 
%           which gets the search wrong
%

% initialize
if (a0 >= b0)
  error('a0 must be < b0');
end
a(1)=a0;
b(1)=b0;
if (nargin < 4)
  epsilon = eps;
end
l(1)=b(1)-a(1);
if (nargin < 5)
  plot_on = 0;
end

if ~isa(func, 'function_handle')
  error('func should be a function handle, e.g., @sin');
end

% we can calculate the number of interations the Golden Section search would take
gamma=double((sqrt(5)-1)/2);
no_of_iterations=ceil(log(epsilon/l(1))/log(gamma));

if (plot_on==1)
  figure(1)
  hold off
  x = a0:l(1)/1000:b0;
  plot(x, func(x));
  set(gca,'fontsize', 24)
  set(gca,'linewidth', 3)
  
  grey = [0.8 0.8 0.8];
end


% calculate how many steps are needed, using the Fibonacci sequence
test=double((b(1)-a(1))/epsilon);
fibonacci_sequence(1)=1;
fibonacci_sequence(2)=2; % normally F(1)=F(2)=1 for the Fibonacci sequence
i=2;
while fibonacci_sequence(i)<test
    i=i+1;
    fibonacci_sequence(i)=fibonacci_sequence(i-1)+fibonacci_sequence(i-2);
end
no_of_iterations = i-1;

% perform the search
p(1)=double(b(1)-fibonacci_sequence(no_of_iterations)/fibonacci_sequence(no_of_iterations+1)*(b(1)-a(1)));
q(1)=double(a(1)+b(1)-p(1));
fp(1) = func(p(1));
fq(1) = func(q(1));
n_evaluations = 2;
for i=1:no_of_iterations-1 % last step is different, so don't do it here
  l(i)=b(i)-a(i);
  if fp(i)<fq(i)
    a(i+1)=a(i);
    b(i+1)=q(i);
    q(i+1)=p(i);
    p(i+1)=double(a(i+1)+b(i+1)-q(i+1));
    if (i < no_of_iterations-1)
      fq(i+1) = fp(i);
      fp(i+1) = func(p(i+1));
      n_evaluations = n_evaluations + 1;
    else
      fq(i+1) = fp(i);
      fp(i+1) = fp(i); % because p=q at the last iteration
    end
  else
    a(i+1)=p(i);
    b(i+1)=b(i);
    p(i+1)=q(i);
    q(i+1)=double(a(i+1)+b(i+1)-p(i+1));
    if (i < no_of_iterations-1)
      fp(i+1) = fq(i);
      fq(i+1) = func(q(i+1));
      n_evaluations = n_evaluations + 1;
    else
      fq(i+1) = fq(i);
      fp(i+1) = fq(i); % because p=q at the last iteration
    end
  end
  
  if (plot_on==1)
    figure(2)
    set(gca,'fontsize', 24)
    set(gca,'linewidth', 3)
    hold off
    plot(x, func(x),'linewidth', 3);
    YY = get(gca, 'ylim');
    fill([a(i+1) b(i+1) b(i+1) a(i+1) a(i+1)], [YY(1) YY(1) YY(2) YY(2) YY(1)], grey);
    hold on
    plot(x, func(x),'linewidth', 3);
    plot([a(i) a(i)], YY, 'r','linewidth', 3);
    plot([b(i) b(i)], YY, 'r','linewidth', 3);
    plot([p(i) p(i)], YY, 'r--','linewidth', 3);
    plot([q(i) q(i)], YY, 'r--','linewidth', 3);
    
    if (l(i) >= l(1)/8)
      h = text(a(i), YY(2), 'a', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
      h = text(b(i), YY(2), 'b', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
      h = text(p(i), YY(2), 'p', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
      h = text(q(i), YY(2), 'q', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    pause;
  end
  
end

% last step
alpha = epsilon/100;
p_dash = p(end) - alpha;
n_evaluations = n_evaluations + 1;
if func(p_dash) <= fp(end)
  a(no_of_iterations+1)=a(no_of_iterations); 
  b(no_of_iterations+1)=p(no_of_iterations);
  p(no_of_iterations+1)=p(no_of_iterations);
  q(no_of_iterations+1)=q(no_of_iterations);
else 
  a(no_of_iterations+1)=p(no_of_iterations);
  b(no_of_iterations+1)=b(no_of_iterations);
  p(no_of_iterations+1)=p(no_of_iterations);
  q(no_of_iterations+1)=q(no_of_iterations);
end

% estimates
estimate=(a(end)+b(end))/2;
error_est=(b(end)-a(end))/2;
f = func(estimate);

if (plot_on==1)
  fprintf(1, '\n  number of iterations = %d', no_of_iterations)      
  fprintf(1, '\n      the ith row gives the state after the ith iteration')      
  fprintf(1,'\n  i       a(i)        p(i)       q(i)       b(i)        f(p(i))        f(q(i))     I(i)\n')
  for i=1:no_of_iterations
    fprintf(1, '%3d%11.5f %11.5f%11.5f%11.5f%15.5f%15.5f%11.5f\n',i-1,a(i),p(i),q(i),b(i),fp(i),fq(i),b(i)-a(i))      
  end 
  i=no_of_iterations+1;
  fprintf(1, '%3d%11.5f %11s%11s%11.5f%15s%15s%11.5f\n',i-1,a(i),' ', ' ', b(i),' ', ' ', b(i)-a(i))      
  fprintf(1,'\n The final interval is                            [%.8f,%.8f]',a(end),b(end))
  fprintf(1,'\n The estimate of the minimiser of f is            %.8f',estimate)
  fprintf(1,'\n with an error of no more than                    %.5f', error_est)
  fprintf(1,'\n      which should be no more than epsilon/2 =    %.5f', epsilon/2)
  fprintf(1,'\n The no.of times the interval has been reduced is %d', no_of_iterations)
  fprintf(1,'\n The number of function evaluations (estimate)    %d', no_of_iterations+1)
  fprintf(1,'\n The number of function evaluations (actual)      %d', n_evaluations)
  fprintf(1,'\n')
elseif (plot_on == 2)
  fprintf(1, '\n  number of iterations = %d', no_of_iterations)      
  fprintf(1, '\n      the ith row gives the state after the ith iteration')      
  fprintf(1,'\n\\begin{tabular}{r|rrrrrrr}')
  fprintf(1, '\n  i &        a(i) &         p(i) &        q(i) &        b(i) &         f(p(i)) &         f(q(i)) &      I(i)\\\\\n')
  fprintf(1,'\\hline\n')
  for i=1:no_of_iterations
    fprintf(1, '%3d & %11.5f & %11.5f & %11.5f & %11.5f & %15.5f & %15.5f & %11.5f\\\\\n',i-1,a(i),p(i),q(i),b(i),fp(i),fq(i),b(i)-a(i))      
  end 
  i=no_of_iterations+1;
  fprintf(1, '%3d & %11.5f & %11s & %11s & %11.5f & %15s & %15s & %11.5f\\\\\n',i-1,a(i),' ', ' ', b(i),' ', ' ', b(i)-a(i))      
  fprintf(1,'\\end{tabular}\n')
  fprintf(1,'\n The final interval is                            [%.8f,%.8f]',a(end),b(end))
  fprintf(1,'\n The estimate of the minimiser of f is            %.8f',estimate)
  fprintf(1,'\n with an error of no more than                    %.5f', error_est)
  fprintf(1,'\n      which should be no more than epsilon/2 =    %.5f', epsilon/2)
  fprintf(1,'\n The no.of times the interval has been reduced is %d', no_of_iterations)
  fprintf(1,'\n The number of function evaluations (estimate)    %d', 1 + no_of_iterations)
  fprintf(1,'\n The number of function evaluations (actual)      %d', n_evaluations)
  fprintf(1,'\n')
end
