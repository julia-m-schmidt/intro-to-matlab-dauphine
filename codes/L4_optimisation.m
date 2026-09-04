%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 4 - Optimisation, solver-based  (slides 10-23)
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%  Needs the Optimization Toolbox (fminunc, fmincon, linprog).

clear; close all; clc;

% TODAY'S QUESTION: an optimiser always returns an answer, and always
% says it succeeded. It promises a LOCAL minimum. Everyone hears "the best
% one". That gap is where the whole lecture lives - and it is the last and
% sharpest version of this course's theme: the code ran, so it must be right.

%% 1) Quadratic toy example: f(x) = 0.1 x^2
% A quadratic bowl is the simplest convex function. 
% The minimum is clearly at x=0, but we use a solver to show how MATLAB works.

fun1 = @(x) 0.1*x.^2;                          % objective function (0.1 * x^2), find value that minimises it
X = -5:0.1:5;                                  % grid of x-values
figure('Color','w','Name','Quadratic'); 
plot(X, fun1(X), 'LineWidth', 1.5);
grid on; box on;
xlabel('x'); ylabel('f(x)'); title('f(x) = 0.1 x^2');

% Starting guess x0 = 1 (arbitrary)
x0 = 1;
[xopt1, fval1] = fminunc(@(x) fun1(x), x0, ...
    optimoptions('fminunc','Display','off'));

% Show optimum on the graph
hold on; plot(xopt1, fval1, 'ro', 'MarkerSize', 7, 'LineWidth', 1.2); hold off;
fprintf('Quadratic: x* = %.4f, f* = %.4f\n', xopt1, fval1);

% fminunc = unconstrained minimization. 
% It uses derivatives internally, but we don’t need to worry about that here.

%% 2) Noisy quadratic: f(x) = 0.1 x^2 + sin(x)
% Add a sine wave to the quadratic. 
% Now the function has many local minima and maxima. 
% This shows the difference between convex vs non-convex problems.

fun2 = @(x) 0.1*x.^2 + sin(x);
X = -8:1:5; Y = -8:0.01:5;                      % coarse and fine grids

figure('Color','w','Name','Noisy Quadratic');
plot(X, fun2(X), 'o-'); hold on;                % coarse points
plot(Y, fun2(Y), '--');                         % dense smooth curve
grid on; box on;
xlabel('x'); ylabel('f(x)'); title('f(x) = 0.1 x^2 + sin(x)');

x0 = 1;                                         % start value
[xopt2, fval2] = fminunc(@(x) fun2(x), x0, ...
    optimoptions('fminunc','Display','off'));

plot(xopt2, fval2, 'ro', 'MarkerSize', 7, 'LineWidth', 1.2); hold off;
fprintf('Noisy quadratic: x* = %.4f, f* = %.4f\n', xopt2, fval2);

%% THE TRAP: same function, same solver, one different number
% PREDICT: does the starting guess change the ANSWER, or just the path?


starts = [-5 -4 -1 1 2 3 5];
fprintf('\n  x0        x*         f*      exitflag\n');
for k = 1:numel(starts)
    [xk, fk, flag] = fminunc(fun2, starts(k), ...
        optimoptions('fminunc','Display','off'));
    fprintf('  %+3d    %+8.4f  %+8.4f      %d\n', starts(k), xk, fk, flag);
end

%  READING THE TABLE BELOW. The star is the usual maths notation for "the
%  optimal one", so:
%    x0        the STARTING GUESS we hand the solver. An INPUT - we chose it
%    x*        the x the solver STOPPED at        ("x-star", the argmin found)
%    f*        the height there, i.e. f(x*)       (the value being minimised)
%    exitflag  1 = "converged successfully"
%
%  So each row reads: "starting from x0, the solver ended up at x*, where the
%  function is worth f*". Watch the exitflag column: it says 1 on EVERY row.

% Two different answers, 1.63 apart - and EVERY row
% reports exitflag = 1, i.e. "success". MATLAB is not lying: fminunc promises
% a LOCAL minimum and delivered one every time. 
%
% Now look at the x0 = -5 row. We tell you optimisation is "a ball
% rolling downhill into the nearest valley". From -5, the nearest valley is
% at -1.31. The solver lands at +3.84 - the far side of a hill.
% Why: a solver does not roll, it takes FINITE STEPS, and an early step can
% jump clean over a valley. The ball picture is fine for thirty seconds and
% wrong after that.
%
% The practical habit: plot the function first, and try several
% starting points. If they disagree, you have a non-convex problem and the
% answer you report is a choice you made.

%% Show both answers on the curve
[xa, fa] = fminunc(fun2, 1, optimoptions('fminunc','Display','off'));
[xb, fb] = fminunc(fun2, 3, optimoptions('fminunc','Display','off'));
figure('Color','w','Name','Same solver, two answers');
plot(Y, fun2(Y), 'LineWidth', 1.4); hold on; grid on; box on;
plot(xa, fa, 'go', 'MarkerSize', 9, 'LineWidth', 1.6);
plot(xb, fb, 'ro', 'MarkerSize', 9, 'LineWidth', 1.6);
legend({'f(x) = 0.1x^2 + sin(x)', ...
        sprintf('from x_0=1:  f = %.4f', fa), ...
        sprintf('from x_0=3:  f = %.4f', fb)}, 'Location','north');
xlabel('x'); ylabel('f(x)'); title('One function, one solver, two "successes"');
hold off;

%% 3) Constrained problem: 2 <= x <= 5 with fmincon
% Now we add simple bounds on x.
% fmincon = constrained minimization (general tool).

lb = 2; ub = 5;
x0 = 1;  % deliberately OUTSIDE the bounds - fmincon accepts this and
         % moves the guess into the feasible box. Starting inside is tidier,
         % but it is not a requirement. Verified: exitflag = 1.

opts = optimoptions('fmincon','Display','off');
[xoptb, fvalb] = fmincon(@(x) fun2(x), x0, [], [], [], [], lb, ub, [], opts);

figure('Color','w','Name','Bounds'); 
plot(Y, fun2(Y), 'LineWidth', 1.2); grid on; box on; hold on;
xline(lb,'k--'); xline(ub,'k--');               % plot bounds
plot(xoptb, fvalb, 'ro', 'MarkerSize', 7, 'LineWidth', 1.2);
xlabel('x'); ylabel('f(x)'); title('Constrained: 2 \leq x \leq 5');
hold off;
fprintf('Bounds: x* = %.4f, f* = %.4f\n', xoptb, fvalb);

% Constraints restrict where the solver may look. The global minimum
% (-1.31) is OUTSIDE [2,5], so the best feasible point is 3.8375 - the same
% local minimum the unconstrained solver fell into from x0 = 3.
% Worth saying: here the "wrong" answer is the RIGHT answer, because the
% constraint is part of the question. Constraints are economics, not
% numerics - a capacity limit, a budget, a non-negativity condition.

%% 4) Linear program (Exercise 2)
% Maximize:       (1/3)x + 2y
% Subject to:     x <= 10,  y <= 15,  x + y = 20,  x,y >= 0
% Note: linprog minimizes, so we minimize the negative of the objective.

% 1) Standard-form inputs
c   = [-1/3; -2];          % minimize -((1/3)x + 2y)
A   = [1 0; 0 1];          % x <= 10, y <= 15
b   = [10; 15];
Aeq = [1 1];               % x + y = 20
beq = 20;
lb  = [0; 0];              % x >= 0, y >= 0

% 2) Solve
opts = optimoptions('linprog','Display','none');
[xopt, fval] = linprog(c, A, b, Aeq, beq, lb, [], opts);

% 3) Report (flip sign to get the maximum value)
valMax = -fval;
fprintf('LP optimum: x=%.4f, y=%.4f, objective=%.4f\n', xopt(1), xopt(2), valMax);

% 4) Simple plot (feasible line segment + optimum)
figure('Color','w','Name','LP Feasible Set'); hold on; grid on; box on;
% Equality line x+y=20 within bounds:
fplot(@(x) 20 - x, [0, 20], 'LineWidth', 1.2);  % x+y=20
xline(10,'--');  yline(15,'--');                % x<=10, y<=15
plot(xopt(1), xopt(2), 'ro','MarkerSize',7,'LineWidth',1.2); % optimum
xlabel('x'); ylabel('y');
title('LP feasible set and optimum');
legend({'x+y=20','x=10','y=15','optimum'},'Location','best');
hold off;

%% 5) Does the Hessian actually make it FASTER? (slides 24+)
% Everything above had ONE variable. Any solver wins instantly on those, so
% nothing we did could show why derivatives are worth the effort. To see the
% payoff we need a function that is genuinely hard.
%
% ROSENBROCK: f = 100(x2 - x1^2)^2 + (1 - x1)^2, minimum at (1,1).
% The standard test function. It is a long, narrow, CURVED valley: easy to
% fall into, very hard to walk along. Downhill is almost never towards
% the answer - which is exactly the situation where curvature earns its keep.

figure('Color','w','Name','Rosenbrock valley');
[X1,X2] = meshgrid(-2:0.05:2, -1:0.05:3);
contour(X1,X2, log10(100*(X2-X1.^2).^2 + (1-X1).^2), 30);  % log scale, else you see nothing
hold on; grid on; box on;
plot(-1.2, 1, 'ro','MarkerSize',9,'LineWidth',1.5);   % start
plot(   1, 1, 'gp','MarkerSize',14,'LineWidth',1.5);  % true minimum
xlabel('x_1'); ylabel('x_2'); title('Rosenbrock: the banana valley (log contours)');
legend({'f (log_{10})','start','minimum'},'Location','northwest'); hold off;

%% THE RACE: 400 variables, three ways of doing the same thing
% Same function, same start, same answer. Only the derivative information
% we hand over changes.
% PREDICT: which is fastest, and by how much?

n   = 400;                      % 400 variables (must be even)
x0R = repmat([-1.2;1], n/2, 1); % same bad start, repeated

% THREE LAYERS, and notice that only two of them change below:
%   1. THE SOLVER     fminunc  - the same in all three rows, never varies
%   2. THE ALGORITHM  'Algorithm', ...   how far it dares to step
%   3. THE CURVATURE  where the Hessian comes from - guessed, estimated, or ours
%
% Layer 3 is the ONLY difference between rows 2 and 3. One option.

cfg = { 'quasi-newton, gradient only', ...
            optimoptions('fminunc','Algorithm','quasi-newton', ...
                'SpecifyObjectiveGradient',true,'Display','off');
            % curvature: BFGS builds its own guess from the gradients it has
            % seen. It never asks us for a Hessian and would ignore one.
            % (BFGS = Broyden-Fletcher-Goldfarb-Shanno, four people, 1970.)

        'trust-region, Hessian ESTIMATED', ...
            optimoptions('fminunc','Algorithm','trust-region', ...
                'SpecifyObjectiveGradient',true,'Display','off');
            % curvature: no HessianFcn option, so MATLAB works the Hessian out
            % by finite differences - poking the function in all 400
            % directions, EVERY iteration. This is the expensive row.

        'trust-region, Hessian SUPPLIED', ...
            optimoptions('fminunc','Algorithm','trust-region', ...
                'SpecifyObjectiveGradient',true, ...
                'HessianFcn','objective', ...   % <=== HESSIAN SWITCHED ON HERE
                'Display','off') };
            % curvature: OURS. 'HessianFcn','objective' means "the 3rd output
            % of the objective function IS the Hessian - go and ask for it".
            % That is the whole hand-over. There is no Hessian ARGUMENT to
            % fminunc; you return it from your own function (see rosenN below).
            %
            % Two things must ALSO be true or it is silently ignored:
            %   - Algorithm must be 'trust-region'  ('quasi-newton' warns and ignores)
            %   - SpecifyObjectiveGradient must be true (no Hessian without a gradient)

fprintf('\n  %-34s %6s %8s %9s\n','what we hand the solver','iters','f-evals','seconds');
for k = 1:size(cfg,1)
    best = inf;
    for rep = 1:3                                   % best of 3, to beat timing noise
        t = tic;
        [xR,~,~,outR] = fminunc(@rosenN, x0R, cfg{k,2});
        best = min(best, toc(t));
    end
    fprintf('  %-34s %6d %8d %9.3f\n', cfg{k,1}, outR.iterations, outR.funcCount, best);
end
fprintf('  (all three land on the same answer: max|x-1| = %.2e)\n', max(abs(xR-1)));

%  WHAT THE TABLE SAYS - three separate lessons, do not merge them:
%
%  1. CURVATURE BUYS BETTER STEPS.
%     quasi-newton takes ~36 iterations; both trust-region rows take ~25.
%     Knowing the bend of the valley means you stop zig-zagging across it.
%
%  2. EXACT vs ESTIMATED CURVATURE COSTS THE SAME NUMBER OF STEPS.
%     Rows 2 and 3 have the SAME iteration count. MATLAB's estimate is a
%     good estimate. So the Hessian does not buy you fewer steps here.
%
%  3. IT BUYS YOU CHEAPER STEPS - and that is the whole win.
%     To estimate the Hessian, MATLAB must poke the function in every one of
%     400 directions, every iteration. We hand it over in closed form for
%     free. Same steps, ~100x less work per step.
%
%  THE TRAP, and it is the lecture's theme again:
%  look at rows 1 and 2. Switching to 'trust-region' WITHOUT supplying the
%  Hessian is SLOWER than not bothering at all - you have paid for the
%  expensive algorithm and given it nothing to work with. Half of the change
%  is worse than none of it. The code ran, exitflag was 1, and you made it worse.
%
%  Scaling is the real point: at n = 2 all three rows are indistinguishable.
%  The gap only opens as the problem grows. Small problems teach you nothing
%  about whether derivatives are worth writing.

%% ------------------------------------------------------------------
%  Local functions must sit at the END of a script file.
%
%  NOTE the nargout guards. They mean "only compute the gradient if I was
%  actually asked for it". This is the robust way to write an objective:
%  the same function then works with EVERY algorithm, whether or not that
%  algorithm wants derivatives. (The @(x) deal(f,g,H) shortcut you may see
%  online breaks the moment a solver asks for fewer than three outputs.)

function [f,g,H] = rosenN(x)
    n = numel(x);
    od = 1:2:n-1;    % odd  positions: the x1 of each pair
    ev = 2:2:n;      % even positions: the x2 of each pair

    f = sum(100*(x(ev)-x(od).^2).^2 + (1-x(od)).^2);          % value

    if nargout > 1                                             % gradient
        g = zeros(n,1);
        g(od) = -400*x(od).*(x(ev)-x(od).^2) - 2*(1-x(od));
        g(ev) =  200*(x(ev)-x(od).^2);
    end

    if nargout > 2                                             % Hessian
        % SPARSE: variables only interact in pairs, so almost every entry is
        % zero. Storing 400x400 = 160,000 numbers to hold ~1,200 non-zeros
        % would throw away most of the speed-up.
        H = sparse(od,od, 1200*x(od).^2 - 400*x(ev) + 2, n,n) ...
          + sparse(ev,ev, 200*ones(n/2,1),                n,n) ...
          + sparse(od,ev, -400*x(od),                     n,n) ...
          + sparse(ev,od, -400*x(od),                     n,n);
    end
end
