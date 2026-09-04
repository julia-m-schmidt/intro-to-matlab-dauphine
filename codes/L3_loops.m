%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 3 - Loops  (slides 16-28)
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%  Dependencies: base MATLAB only.
%

clear; close all; clc;
rng('default'); rng(0,'twister');   %  rng('default') first

%% 1) FOR loop - vector iteration (slide 17)
% Task: go through each element of a vector and print its index and value
a = rand(3,1);   % a 3x1 column vector with random values in [0,1]
for i = 1:length(a)
    % num2str(i) converts the index into a string so we can concatenate it
    disp(["row " + num2str(i) + " has value " + num2str(a(i))]);
end

%% 2) FOR loop - nested over a matrix (slide 18)
% Task: iterate over ALL entries of a 3x3 matrix, row by row, column by column
A = rand(3,3);   % random 3x3 matrix
for i = 1:size(A,1)         % loop over rows (size(A,1) = number of rows)
    for j = 1:size(A,2)     % loop over columns (size(A,2) = number of columns)
        disp(["row " + num2str(i) + " and column " + num2str(j) + ...
              " has value " + num2str(A(i,j))]);
    end
end

%%  Gluing text together: the separator is not optional
% You will write lines like this all day. Two of the three below work.
% PREDICT which one does not even start:
try
    eval("disp(['row 'num2str(1)' has value 'num2str(0.5)])");
catch ME
    fprintf('no separator -> %s\n', ME.message);
end
disp(['row ',num2str(1),' has value ',num2str(0.5)])   % commas: fine
disp(['row ' num2str(1) ' has value ' num2str(0.5)])   % spaces: also fine

%  Inside [ ] a SPACE separates elements, exactly like [1 2 3]. So
% 'row ' followed by a space and then num2str(i) is two elements of a char
% array, which is what we want. With no separator at all, MATLAB cannot tell
% where one piece ends and the next begins.
%
%  Note what KIND of bug this is: it fails before anything runs. That is
% the best kind you will ever get - caught for free, before a single wrong
% number exists. Compare Lectures 1 and 2, where the bugs ran happily.

%% 3) WHILE loop - vector iteration (slides 19-21)
% Task: same as 1), but using a WHILE loop (condition-controlled)
i = 0;
a = rand(3,1);   % another random 3x1 vector
while i < length(a)   % continue until all elements are visited
    i = i + 1;        % increment counter manually (important in WHILE loops!)
    disp(["row " + num2str(i) + " has value " + num2str(a(i))]);
end

%% 4) WHILE loop - nested over a matrix (slides 22-23)
% Task: same as 2), but with nested WHILE loops
A = rand(3,3);
i = 0; 
j = 0;
while i < size(A,1)       % outer loop: rows
    i = i + 1;
    while j < size(A,2)   % inner loop: columns
        j = j + 1;
        disp(["row " + num2str(i) + " and column " + num2str(j) + ...
              " has value " + num2str(A(i,j))]);
    end
    j = 0; % reset inner counter (see below - this line is the whole lesson)
end

%  DELETE THAT LINE and re-run this section. PREDICT first.
% Without the reset, j stays at 3 after the first row, so the inner condition
% j < 3 is already false and the inner loop never runs again: you print row 1
% completely and then nothing. No error. A silently incomplete answer.
% This is the single most common while-loop bug and it is worth breaking live.

%% Exercise 2 - Worked references (slides 24-28)
% Goal: practice FOR and WHILE loops, accumulation, reverse iteration,
% filtering with conditions, and repetition until a condition is met.

%% (1) Sum elements of q
% Task:s accumulate the sum manually (instead of using sum(q))
q = [3, 7, 9, 10]; 
Q = 0;  % initialize accumulator at zero
for i = 1:numel(q)
    % each loop adds the i-th element into the running total
    Q = Q + q(i);
end
fprintf('[1] Sum of q = %d\n', Q);

% Why do we need to initialize Q=0 before the loop?

%% (2) Print q in reverse order
% Task: iterate backwards using "start:step:end" syntax
for i = numel(q):-1:1
    fprintf('[2] row %d has value %d\n', i, q(i));
end

% In MATLAB, "a:b:c" means start at a, step by b, stop at c.

%% (3) Cost of basket: prices (p) * quantities (q)
% Task: compute dot product c = sum(p .* q)
p = [2,7,8,1];
c = 0;  % initialize total cost
for i = 1:numel(q)
    % Each loop multiplies price(i) * quantity(i) and adds it to c
    c = c + p(i)*q(i);
end
fprintf('[3] Total cost of basket c = %d\n', c);

% This is how you’d compute a shopping bill item by item.

%% (4) Same basket cost with WHILE loop
i = 0; 
c2 = 0;  % reset accumulator
while i < numel(q)
    i = i + 1;  % must increment manually in WHILE
    c2 = c2 + p(i)*q(i);
end
fprintf('[4] Total cost with while c2 = %d\n', c2);

% how do FOR and WHILE differ? 
% (FOR → known number of iterations, WHILE → condition-driven)

%% (5) Filter random integers: keep values >7 or <2
v = randi([1,10], 50, 1);   % 50 random integers between 1 and 10
% Logical indexing: create a boolean mask for values we want to keep
idx = (v > 7) | (v < 2);

fprintf('[5] Filtered %d of %d values\n', nnz(idx), numel(v));
disp('Values kept:');
disp(v(idx)');  % transpose to print in a row

% Logical masks (idx) let us "filter" arrays without explicit loops.

%%  BEFORE section 6: how to stop a runaway loop
% Section 6 loops until it guesses a number. It WILL finish - but if you mistype
% the condition (say ~= becomes ==) it will never finish and MATLAB will look
% frozen. Press Ctrl+C in the Command Window to interrupt.

%% (6) Guessing game: count iterations until match
mystery_nb = randi([1,100],1);   % hidden number
count = 0;
guess = 0;   % initialize guess
maxtries = 1e6;                  %  safety valve - see below
while guess ~= mystery_nb && count < maxtries
    % Keep guessing random numbers until we hit the mystery number
    guess = randi([1,100],1);
    count = count + 1;  % track number of tries
end
fprintf('[6] Mystery number %d found in %d iterations.\n', mystery_nb, count);

%  PREDICT before running it a few times: how many tries on average?
% Each guess is right with probability 1/100 and the tries are independent,
% so the count is geometric with mean 100. Run the section five times: you
% will see values from single digits to several hundred. That spread IS the
% distribution - a single run tells you almost nothing, which is the same
% lesson as the 5x5 matrix in Lecture 1.
%
% Empirical check (uses a loop over loops):
N = 2000; tries = zeros(N,1);
for k = 1:N
    m = randi([1,100],1); g = 0; c = 0;
    while g ~= m && c < 1e5
        g = randi([1,100],1); c = c + 1;
    end
    tries(k) = c;
end
fprintf('    mean tries over %d games = %.1f (theory: 100)\n', N, mean(tries));


disp('Loops demo complete.');
