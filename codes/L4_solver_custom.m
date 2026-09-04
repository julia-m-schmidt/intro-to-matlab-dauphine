%% Demo: Providing gradient and Hessian to fminunc
% Author: Julia M. Schmidt
% Function: f(x1,x2) = (x1-1)^2 + (x2-2)^2
% True minimum at (1,2)

%% 1) Symbolic calculation (for teaching only)
% -------------------------------------------
% Use MATLAB's Symbolic Toolbox to *derive* the formulas
% for the gradient (slope) and the Hessian (curvature matrix).
% This helps students check their hand-derivatives.

syms x1 x2
f = (x1-1)^2 + (x2-2)^2;

grad_f = gradient(f,[x1,x2])   % gradient vector
hess_f = hessian(f,[x1,x2])   % Hessian matrix

% Expected:
%   grad_f = [2(x1-1); 2(x2-2)]
%   hess_f = [2 0; 0 2]

%% 2) Define function handle with value, gradient, and Hessian
% -----------------------------------------------------------
% fminunc can accept all three if coded properly using deal(...).

myfun = @(x) deal( ...
    (x(1)-1)^2 + (x(2)-2)^2, ...              % function value f(x)
    [2*(x(1)-1); 2*(x(2)-2)], ...             % gradient ∇f(x)
    [2 0; 0 2] );                             % Hessian ∇²f(x)

%% 3) Set solver options: trust-region + gradient + Hessian
options = optimoptions('fminunc', ...
    'Algorithm','trust-region', ...
    'SpecifyObjectiveGradient',true, ...
    'HessianFcn','objective', ...
    'Display','iter');

%% 4) Run the solver
x0 = [0;0];  % starting guess
[xopt,fval,exitflag,output] = fminunc(myfun,x0,options);

disp('Optimal solution:');
disp(xopt);

%% 5) Visualization of the optimization problem
% ---------------------------------------------
% We make a contour plot of f(x1,x2) and mark the starting point and the optimum.

% Define grid
[X1,X2] = meshgrid(-1:0.1:3, -1:0.1:4);
F = (X1-1).^2 + (X2-2).^2;

% Plot contours
figure;
contour(X1,X2,F,20); hold on;
xlabel('x1'); ylabel('x2');
title('Contour plot of f(x1,x2) with optimal solution');
grid on;

% Plot starting point
plot(x0(1),x0(2),'ro','MarkerSize',10,'MarkerFaceColor','r');
text(x0(1)+0.1,x0(2),'Start','Color','r');

% Plot optimal point
plot(xopt(1),xopt(2),'go','MarkerSize',10,'MarkerFaceColor','g');
text(xopt(1)+0.1,xopt(2),'Optimal','Color','g');

legend({'Contours','Start','Optimal'},'Location','best');
