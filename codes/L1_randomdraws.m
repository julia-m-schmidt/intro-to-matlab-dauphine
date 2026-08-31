%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 1 - Random numbers, data import/export  (slides 26-30, appendix 34-37)
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%
%  TOOLBOX NOTE: the Halton sections need the Statistics and Machine Learning
%  Toolbox. Section 0 checks for you. Everything else runs on base MATLAB.
%

%% Housekeeping
clear; close all; clc;

%  TODAY'S QUESTION: "random" on a computer means "reproducible if you
% ask nicely". A simulation you cannot re-run is a result nobody can check -
% including you, in six months, when a referee asks.

%% 0) Toolbox check                                                 % 
% Run this first. If it says MISSING, skip the Halton sections - nothing
% else in Lecture 1 depends on them.
if exist('haltonset','file') == 2 || exist('haltonset','class') == 8
    fprintf('Statistics and Machine Learning Toolbox: OK\n');
else
    fprintf(['Statistics and Machine Learning Toolbox: MISSING\n' ...
             'Halton sections will not run. Add-Ons > Get Add-Ons.\n']);
end

%% ===================== PART A: UNIFORM DRAWS =====================

%% 1. Uniform draws on [0,1]
x = rand(1,5);
disp('Uniform draws:');
disp(x);

%  Run this section three times. Three different answers. That is the
% default: MATLAB seeds itself from the clock at startup.

%% Halton sequence: an alternative to rand
% A Halton sequence is a "low-discrepancy" sequence:
% - Unlike purely random draws (rand), it spreads points out evenly.
% - Used in numerical integration (Monte Carlo), simulation, and finance
%   (e.g. option pricing) to reduce the variance of estimates.
% - Think "pseudo-deterministic": no clumping, fills the space better.

p = haltonset(2);        % 2-dimensional Halton generator
                         % "2D" means each draw gives two coordinates (x,y)
halton_draws = net(p,5); % first 5 points of the sequence (deterministic)

disp('Halton draws:');
disp(halton_draws);

%  LOOK AT THE FIRST ROW. It is exactly (0, 0).
% The raw Halton sequence starts at zero. That is fine for plotting, and a
% disaster the moment you push it through an inverse CDF (see Part D:
% norminv(0) is -Inf). This is why slide 35 uses 'Skip'. Defaults are not
% always safe defaults.

%% ===================== PART B: SEEDS AND REPRODUCIBILITY ===============

%% 2. Deterministic draws using a seed
rng(2);                 % fix the seed
y = rand(1,5);
disp('Deterministic draws with rng(2):');
disp(y);

% Slide 27 claims this prints:
%   0.4360  0.0259  0.5497  0.4353  0.4204
%  Verified in R2024b - it still does. But that is a promise about a
% specific generator, not a law of nature. If you ever need bit-identical
% results across MATLAB versions, say so explicitly: rng(2,'twister').

%%  If rng(2) throws an error, read this
% Some toolboxes (Dynare, in particular) run a startup script that switches
% MATLAB to the old "legacy" random generator. Then rng() refuses to work:
%   "The current random number generator is the legacy generator."
% The one-line fix, before any rng(seed) call:
%   rng('default')
% You now know more about this than the error message tells you.

%% 3. Save and reuse a random state
s = rng;                % save the current generator state
a = rand(1,3);
disp('First set of numbers:');
disp(a);

rng(s);                 % restore that exact state
b = rand(1,3);
disp('Reproduced numbers:');
disp(b);

isequal(a,b)         

%  rng(seed) restarts the sequence. rng(s) rewinds to a point in the
% middle of it. Use the second when you want one part of a simulation to
% repeat while the rest keeps moving.

%% ===================== PART C: DATA IMPORT AND EXPORT ==================
% Slides 29-30. This is the section everybody skips and everybody needs.

%% Import: the wrong tool
data = readmatrix("WB_Data.xls");
size(data)
%  PREDICT: WB_Data has country names in the first columns.
% What did readmatrix do with them?
data(1:3, 1:5)

% Answer: columns 1-4 are entirely NaN. readmatrix returns a NUMERIC matrix,
% so every text column silently became NaN. No error. No warning. If you had
% averaged column 3 you would have got NaN and blamed the data.

%% Import: the right tool
T = readtable("WB_Data.xls");
head(T,5)
size(T)
T.Properties.VariableNames(1:6)

% readtable keeps text as text and numbers as numbers, and it names the
% columns. For anything with headers, this is what you want.

%%  Which sheet did we even read?
sheetnames("WB_Data.xls")
% Three sheets. Both readmatrix and readtable silently took the FIRST one.
% To be explicit:
% T2 = readtable("WB_Data.xls", 'Sheet', 'Data');

%% Explore what you imported                                       % 
height(T)          % number of rows
width(T)           % number of columns
summary(T(:,5:7))  % per-column statistics, incl. how many NaNs

% Get into the habit: import, then LOOK. size, head, summary. Every time.

%% Export                                                          % 
% The slide section is called "Data import AND EXPORT" but nothing was ever
% exported. Three ways out:

outdir = tempdir;   % writes to a scratch folder; change to pwd to keep it

writetable(T(1:10,:), fullfile(outdir,'wb_subset.xlsx'));  % to Excel
writetable(T(1:10,:), fullfile(outdir,'wb_subset.csv'));   % to CSV
save(fullfile(outdir,'wb_subset.mat'), 'T');               % to MATLAB format

fprintf('Wrote 3 files to:\n  %s\n', outdir);

% .mat is fastest and keeps types exactly, but only MATLAB reads it.
% .csv is the one your co-author, your future self, and Python can all open.

%% ===================== PART D: APPENDIX - HALTON (slides 34-37) ========

%% Building the sequence properly
N = 100;
p = haltonset(1,'Skip',1e3,'Leap',1e6);   % 1-D, skip the first 1000 points,
                                          % then keep 1 point every 1e6+1
p = scramble(p,'RR2');                    % scramble to break the regularity
temp = net(p,N);                          % take the first N points

% 'Skip' is what removes the leading 0 we saw in Part A.
min(temp)      % strictly greater than 0 now

%% Halton vs rand: which estimates the mean better?
err_halton = abs(mean(temp)      - 0.5);
err_rand   = abs(mean(rand(1,N)) - 0.5);

fprintf('\nError with Halton : %.6f\n', err_halton);
fprintf('Error with rand   : %.6f\n', err_rand);
fprintf('Halton is %.1fx closer\n', err_rand/err_halton);

%  Run this a few times. err_rand jumps around; err_halton barely moves.
% That is the whole selling point: same number of draws, less variance.
% (Your exact numbers will differ from mine - rand is involved.)

%% From uniform to normal: the probability integral transform
% If U is uniform on [0,1], then norminv(U) is standard normal.
a = norminv(temp);
fprintf('\nmean(a) = %.4f  (should be near 0)\n', mean(a));
fprintf('std(a)  = %.4f  (should be near 1)\n', std(a));

figure;
histogram(a, 20, 'Normalization', 'pdf'); hold on;
xg = linspace(-4,4,200);
plot(xg, normpdf(xg), 'r-', 'LineWidth', 1.5);
title('Halton draws pushed through norminv');
legend('scrambled Halton','N(0,1) density','Location','best');
grid on;

%%  Why 'Skip' was not optional
% Without it, the first Halton point is 0, and norminv(0) is -Inf:
p_bad = haltonset(1);
norminv(net(p_bad,5))'
% One -Inf in your sample and every mean, std and plot downstream is ruined.
% Nothing errors. This is the shape of most real numerical bugs.
