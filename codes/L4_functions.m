% L4_functions.m — Lecture 4: User-defined functions + anonymous functions
% Author: Julia M. Schmidt
% In this lecture:
%   * Learn how to create and call your own functions
%   * Use anonymous (inline) functions
%   * Apply functions to small exercises in finance/economics

clear; close all; clc;

%% 0) External functions: calling examples
% Functions can live in SEPARATE .m files with the same name as the function.
% (Example: Square.m contains a function called "Square").
%
% Why? This lets us build reusable blocks of code.
%
% Here we call three small user functions:
%   * Square.m   — returns x^2
%   * Power.m    — returns x^n
%   * stats.m    — returns min, max, and variance of a vector

y = Square(4)
disp('Square(3) ='); disp(Square(3));           % expect 9
disp('Power(2,5) ='); disp(Power(2,5));         % expect 32

[valMin,valMax,V] = stats(rand(20,1));          % call with random data
fprintf('stats -> min=%.3f, max=%.3f, var=%.3f\n', valMin, valMax, V);

% Difference between *scripts* and *functions*.
% Functions have their own "workspace" and only communicate through inputs/outputs.

%% 1) Anonymous function demo
% Sometimes we just need a tiny function on the fly.
% Anonymous functions use the syntax: @(arguments) expression
%
% Example: f(x) = x^2

sqr = @(x) x.^2;                                % define inline
q1 = integral(sqr,0,1);                         % call with a handle
q2 = integral(@(x) x.^2, 0, 1);                 % define directly in call
fprintf('Integral of x^2 on [0,1]: %.4f / %.4f (two ways)\n', q1, q2);

% Note: the @ symbol turns a function name or expression into a "handle"
% that can be passed to functions like integral, fminsearch, etc.

%% Exercise 1(a): equivalent periodic rates
% Write a function eqRate(rAnnual, period) that converts an annual rate
% into its periodic equivalent:
%   period = 'monthly', 'quarterly', or 'semiannual'
%
% Example: what is the monthly rate that compounds to 10% per year?

fprintf('Eq. monthly rate for 10%% annual: %.4f\n', eqRate(0.10,'monthly'));

% simple division (0.10/12) and compound equivalence ( (1+0.10)^(1/12)-1 ).

%%  Exercise 1(b): logs and log-differences
% Logs are useful in finance and economics:
%   * log(x) turns multiplicative changes into additive ones
%   * diff(log(x)) approximates growth rates
%
% Task: write a function logStats(x) returning:
%   * lx   = log(x)
%   * dlx  = diff(log(x)) with NaN padding so vectors align

x = 1 + 0.01*rand(30,1);              % positive sample data
[lx, dlx] = logStats(x);

disp('First 5 log(x) values:');
disp(lx(1:5));

disp('First 5 diff(log(x)) values:');
disp(dlx(1:5));

% emphasize that log differences are an approximation
% to percentage changes, widely used for returns, inflation, GDP growth, etc.

%% ====== Local function files (save as separate .m files) ======
% Example file contents (students create these in their own folder):

% -- Square.m --
% function y = Square(x)
%     y = x.^2;
% end

% -- Power.m --
% function y = Power(x,n)
%     y = x.^n;
% end

% -- stats.m --
% function [vmin,vmax,vvar] = stats(x)
%     vmin = min(x);
%     vmax = max(x);
%     vvar = var(x);
% end

% -- eqRate.m --
% function r = eqRate(rAnnual,period)
%     switch lower(period)
%         case 'monthly'
%             r = (1+rAnnual)^(1/12)-1;
%         case 'quarterly'
%             r = (1+rAnnual)^(1/4)-1;
%         case 'semiannual'
%             r = (1+rAnnual)^(1/2)-1;
%         otherwise
%             error('Unknown period');
%     end
% end

% -- logStats.m --
% function [lx,dlx] = logStats(x)
%     lx = log(x);
%     dlx = [NaN; diff(lx)];
% end

% Notes:
% 
% - test always with small inputs before using in larger workflows.
