function [estimate, f, a, b, error_est, c,d,e] = dichotomous_search(func, a0, b0, epsilon, plot_on)
%
% dichotomous_search.m, (c) Matthew Roughan, 2012
%
% created: 	Tue Feb 21 2012 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% DICHOTOMOUS_SEARCH performs the dichotomous search for a minimum on the function 'func'
%     a(i) is the lower endpoint of the search interval at the beginning 
%     of the i-th iteration; b(i) is the upper endpoint.
%     l(i) is the length of the interval [a(i),b(i)]; c(i) is its midpoint. 
%     epsilon is the upper bound on the length of the final interval.
%
%
% INPUTS:
%        funct = function handle for the function to minimize
%                   must be a simple function of one variable
%        a_0   = initial lower bound
%        b_0   = initial upper bound
%        epsilon = max width of interval at termination 
%        plot_on = 1 if you want to plot the results (and see tables of them)
%                = 2 to get LaTex ready output
%         
% OUTPUTS:        
%        estimate = the estimate of the location of the minimum
%        f = fincal value of function at x
%        a, b = vectors of the intervals
%        error_est = max error in the estimate
%
% EXAMPLES:
%        dichotomous_search(@cos,  0, 6, 0.001, 1)
%           will do a search to find pi
%
%        dichotomous_search(@ex_func,  1, 2, 0.001, 1)
%           shows a search on an arbitrary function
%
%        dichotomous_search(@ex_func2, 1, 2, 0.001, 1)
%           shows a search on a discontinuous function
%
%        dichotomous_search(@ex_func,  0, 2, 0.001, 1)
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

% we can calculate the number of interations in advance, because each one halves the interval
no_of_iterations=ceil(log(l(1)/epsilon)/log(2));

if (plot_on==1)
  figure(1)
  hold off
  x = a0:l(1)/1000:b0;
  plot(x, func(x));
  set(gca,'fontsize', 24)
  set(gca,'linewidth', 3)
  
  grey = [0.8 0.8 0.8];
end

% perform the search
c(1)=0.5*(a(1)+b(1));
d(1)=0.5*(a(1)+c(1));
e(1)=0.5*(c(1)+b(1));
fc = func(c(1));  
n_evaluations = 1;
for i=1:no_of_iterations
  l(i)=b(i)-a(i);
  d(i)=0.5*(a(i)+c(i));
  e(i)=0.5*(c(i)+b(i));
  fd = func(d(i));
  n_evaluations = n_evaluations + 1;
  if fd<fc
    a(i+1)=a(i);
    b(i+1)=c(i);
    c(i+1)=d(i);
    fc = fd;
  else
    fe = func(e(i));
    n_evaluations = n_evaluations + 1;
    if fc > fe
      a(i+1)=c(i); 
      b(i+1)=b(i);
      c(i+1)=e(i);
      fc = fe;
    else 
      a(i+1)=d(i);
      b(i+1)=e(i);
      c(i+1)=c(i); % fc remains the same
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
    plot([c(i) c(i)], YY, 'r--','linewidth', 3);
    plot([d(i) d(i)], YY, 'r--','linewidth', 3);
    plot([e(i) e(i)], YY, 'r--','linewidth', 3);
    
    if (l(i) >= l(1)/8)
      h = text(a(i), YY(2), 'a', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
      h = text(b(i), YY(2), 'b', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
      h = text(c(i), YY(2), 'c', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
      h = text(d(i), YY(2), 'd', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
      h = text(e(i), YY(2), 'e', ...
	       'fontsize', 18, 'color', 'r', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    pause;
  end
  
end
% NB: this could be more efficient, as we recalculate the function value at various points more than once

estimate=(a(end)+b(end))/2;
error_est=(b(end)-a(end))/2;
f = func(estimate);

if (plot_on==1)
  fprintf(1, '\n  number of iterations = %d', no_of_iterations)      
  fprintf(1, '\n      the ith row gives the state after the ith iteration')      
  fprintf(1,'\n')
  fprintf(1,'  i       a(i)        d(i)       c(i)       e(i)       b(i)       I(i) \n')
  for i=1:no_of_iterations
    fprintf(1, '%3d%11.6f %11.6f%11.6f%11.6f%11.6f%11.6f\n',i-1,a(i),d(i),c(i),e(i),b(i),b(i)-a(i))      
  end 
  i=no_of_iterations+1;
  fprintf(1, '%3d%11.6f %11.6s%11.6f%11.6s%11.6f%11.6f\n',i-1,a(i),' ',c(i),' ',b(i),b(i)-a(i))      

  fprintf(1,'\n The final interval is                            [%.8f,%.8f]',a(end),b(end))
  fprintf(1,'\n The estimate of the minimiser of f is            %.8f',estimate)
  fprintf(1,'\n with an error of no more than                    %.5f', error_est)
  fprintf(1,'\n      which should be no more than epsilon/2 =    %.5f', epsilon/2)
  fprintf(1,'\n The no.of times the interval has been reduced is %d', no_of_iterations)
  fprintf(1,'\n The number of function evaluations (estimate)    %d', 2*no_of_iterations +  1)
  fprintf(1,'\n The number of function evaluations (actual)      %d', n_evaluations)
  fprintf(1,'\n   The discrepency is because you don''t have to evaluate f() for every point')
  fprintf(1,'\n')
elseif (plot_on == 2)
  fprintf(1, '\n  number of iterations = %d', no_of_iterations)      
  fprintf(1, '\n      the ith row gives the state after the ith iteration')      
  fprintf(1,'\n')
  fprintf(1,'\\begin{tabular}{r|rrrrrr}\n')
  fprintf(1,'  i &        a(i) &        d(i) &        c(i) &        e(i) &        b(i) &       I(i) \\\\\n')
  fprintf(1,'\\hline\n')
  for i=1:no_of_iterations
    fprintf(1, '%3d & %11.6f & %11.6f & %11.6f & %11.6f & %11.6f & %11.6f\\\\\n',i-1,a(i),d(i),c(i),e(i),b(i),b(i)-a(i))      
  end 
  i=no_of_iterations+1;
  fprintf(1, '%3d & %11.6f & %11.6s & %11.6f & %11.6s & %11.6f & %11.6f\\\\\n',i-1,a(i),' ',c(i),' ',b(i),b(i)-a(i))      
  fprintf(1,'\\end{tabular}\n')

  fprintf(1,'\n The final interval is                            [%.8f,%.8f]',a(end),b(end))
  fprintf(1,'\n The estimate of the minimiser of f is            %.8f',estimate)
  fprintf(1,'\n with an error of no more than                    %.5f', error_est)
  fprintf(1,'\n      which should be no more than epsilon/2 =    %.5f', epsilon/2)
  fprintf(1,'\n The no.of times the interval has been reduced is %d', no_of_iterations)
  fprintf(1,'\n The number of function evaluations (estimate)    %d', 2*no_of_iterations +  1)
  fprintf(1,'\n The number of function evaluations (actual)      %d', n_evaluations)
  fprintf(1,'\n   The discrepency is because you don''t have to evaluate f() for every point')
  fprintf(1,'\n')
end





