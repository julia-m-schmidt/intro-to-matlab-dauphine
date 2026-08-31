%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 1 - Matrices + Exercise 3  (slides 18-25)
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%

%% Housekeeping
clear; close all; clc;

%  TODAY'S QUESTION: * and .* are different operators, and MATLAB will
% happily run the wrong one without complaining. An assistant writes these
% correctly maybe 80% of the time. Your job is the other 20%.

%% ===================== PART A: CREATING MATRICES =====================

%% Matrices: creation by literals and constructors
x = [1 2; 3 4; 5 6]          % literal with ; to break rows
x2 = [1 2
      3 4
      5 6]                   % same literal, vertical layout
Xz = zeros(3,2);             % preallocate then fill
Xz(1,1) = 1; Xz(1,2) = 2;    % fill one by one
Xz(2,1) = 3; Xz(2,2) = 4;
Xz(3,1) = 5; Xz(3,2) = 6

%  Three ways to get the same 3x2. Preallocation (zeros) matters once
% you write loops in Lecture 3 - growing an array inside a loop is slow.

%% Random matrices
rng(1)                       % reproducible: same "random" numbers every run
A = rand(2,2);               % uniform on [0,1]
B = randn(2,2);              % standard normal N(0,1)

%% Block matrices
C = [A, zeros(2,2); 2*eye(2), B]   

%% Concatenation
D_h = [A B]                  % horizontal (columns add)
D_v = [A; B]                 % vertical   (rows add)

%% Basic operations
E_plus   = A + B
E_minus  = A - B
E_scalar = A + 5             % scalar broadcasts to every entry

%% ===================== PART B: PRODUCTS =====================

%% Inner product vs outer product
w = [1 2 3];                 % 1x3  -> a ROW
u = [4; 5; 6];               % 3x1  -> a COLUMN

% The rule for (m x n) * (n x p):  the INNER pair of dimensions (the two n's)
% must match. They are summed over and disappear. The OUTER pair (m and p)
% survives as the shape of the answer. That is where both names come from.

% (1x3)*(3x1): inner pair is 3 and 3. The long dimension is summed away,
% the outer pair 1 and 1 survives -> a single number.
inner = w * u                % 1x1 = 32  = 1*4 + 2*5 + 3*6

% (3x1)*(1x3): inner pair is now 1 and 1 - they match too, so this is just as
% legal. The sum is over a single term, so nothing is really added up, and the
% outer pair 3 and 3 survives -> a whole matrix.
outer = u * w                % 3x3, entry (i,j) = u(i)*w(j)

% Swapping the order is what
% swaps WHICH vector is the row and which is the column, and orientation is
% the real rule:
%
%       row * column  -> a scalar   (inner)
%       column * row  -> a matrix   (outer)
%
% Proof that order alone is not the story: two rows will not multiply, and
% neither will two columns. Try it:
%       w * w    % errors
%       u * u    % errors
%
% Nothing errors above, though. If you wanted 32 and got the 3x3, MATLAB says
% nothing - and if you then take a mean of it you get a plausible wrong
% answer. mean(outer) is [5 10 15]; mean(outer,'all') is 10. Neither is 32.

%%  PREDICT: does the next line error?
% w is 1x3 (a row), u is 3x1 (a column). They do not have the same shape.
dot_builtin = dot(w,u)



% Answer: 32. No error. dot() ignores row/column orientation for vectors,
% unlike *. Two functions, two different rules about shape.


equal_check = (dot_builtin == w*u)   % true

%% Elementwise vs matrix power & division
A = [1 2; 3 4];              %  NOTE: this overwrites the random A above.
                             % Everything computed before this line is now
                             % unreproducible. Nothing errors, nothing warns.
                             % This is the single most common way student
                             % scripts die. Name your variables carefully.

elem_square = A.^2           % elementwise square
mat_square  = A^2            % A*A

elem_mult = w .* u.'         % elementwise multiply (shapes must match)
elem_div  = A ./ (A+1)       % elementwise right division

%%  PREDICT: is left division the same thing?
left_div  = (A+1) .\ A       % elementwise left division
isequal(elem_div, left_div)  % ?

% Answer: identical. a./b and b.\a are the same operation written backwards.
% .\ is almost never worth using - it exists so that A\b (solving a linear
% system) has an elementwise sibling. Seeing it in code is usually a sign
% the code was written by someone showing off, or by a machine.

%% ===================== PART C: COMPLEX + TRANSPOSE =====================

%% Transpose and conjugate transpose
%  was Z = [1+i ...]. Now 1i. Read the trap below to see why.
%
%  .' and ' are each ONE operator that happens to be two characters. The dot
%  is not a separate thing - "Z." on its own is a syntax error. Read .' the
%  same way you read .* : a single symbol.
Z = [1+1i 2-1i; -3+2i 4];

% .' reflects the matrix across its main diagonal: the entry in row i,
%    column j swaps places with the entry in row j, column i. No value changes.
Z_T  = Z.'                   % transpose: flip only

% '  does that same reflection AND conjugates every entry - that is, flips
%    the sign of each imaginary part:  2-1i  becomes  2+1i.
Z_H  = Z'                    % conjugate transpose (also called Hermitian)

% For real matrices these are identical, which is why people use ' out of
% habit and never notice - until their data has complex numbers in it.

% So which one do you actually want?
%
%   .'  when you only care about SHAPE: tipping a row of data into a column,
%       lining dimensions up for a product. The numbers must not change.
%
%   '   when you are doing linear algebra and want the maths to come out
%       right. Compare the diagonals:
%           Z' * Z   -> diagonal is 15 and 21     real and positive
%           Z.'* Z   -> diagonal is 5-10i, 19-4i  complex, and meaningless
%                                                 as a "sum of squares"
%
% In econometrics you type X'*X and X'*y without ever thinking about it,
% because on real data ' and .' agree. They stop agreeing the moment the
% data is complex.

%%  TRAP: i is not a protected name
% In Lecture 3 you will write   for i = 1:10   ... which makes i a counter.
% Run this and watch what happens to a "complex" matrix:
i = 3;
Z_broken = [1+i 2-i; -3+2i 4]
clear i

% Look carefully: 1+i became 4 and 2-i became -1, because i was a variable.
% But -3+2i is STILL complex - because "2i" glued to a number is a literal,
% not a reference to the variable. Same letter, two meanings, one line.
% This is why you write 1i, 2i, 3i and never bare i for the imaginary unit.

%% ===================== PART D: LOGICAL INDEXING =====================

%% Relational operators and logical indexing
M = [-1 0 2; 3 -4 5];
mask = M > 0                 %  show it: a logical matrix, same shape as M
positives = M(mask)          % extracts the positive entries

%  Two things to notice:
%  1. mask is 2x3 (the shape of M), but positives is 3x1 - a COLUMN, always.
%  2. MATLAB reads down the columns, not across the rows. That is why you get
%     3, 2, 5 and not 2, 3, 5. Column-major order. It will bite you again.

%% Property checks
% These return TRUE/FALSE depending on the property of a variable.
% Very useful for debugging and validating input data.

isnumeric(M)     % numeric array (double, single, int...)? false for cell/struct/string
islogical(mask)  % a logical (boolean) array? only true/false values
isreal(Z)        % real-valued? FALSE if there are imaginary parts
isfinite(M)      % every element finite? 1/0 gives Inf, 0/0 gives NaN - both fail
isnan(M)         % which elements are "Not-a-Number"? (missing/invalid data)
isempty([])      % empty array? size([]) is 0x0, so this is true

%% Quick size checks (good debugging habit)
size(A), size(B), size(w), size(u)

%  When something breaks, check size() FIRST. Nine times out of ten the
% bug is a shape, not a formula.

%% Cosine similarity: where the dot product earns its keep
%  renamed to p and q. This block used to overwrite u and v, and u
% was still needed above.
p = [1 2 3];
q = [4 5 6];
cos_sim = dot(p,q) / (norm(p) * norm(q))    % 0.9746

% Two vectors can have very different magnitudes and still point the same
% way. This is how search engines and recommender systems compare documents.

%% ===================== PART E: EXERCISE 3 (slides 24-25) ===============

%% Setup
%  was rng('default') then rng('shuffle') - contradictory, and
% 'shuffle' makes the result different every run, which fights the
% reproducibility point we make two slides earlier. Pick one:
rng('shuffle')    % different numbers every run - that is the point of step 3
% rng(42)         % <- swap to this when you want a reproducible answer

%% 1) Generate 5x5 Gaussian and count positives
X = randn(5,5);                    % standard normal draws
num_pos = sum(X(:) > 0)            % number of positive entries
myshare = num_pos / numel(X)       % share of positives

% X(:) flattens the matrix to a column. X(:)>0 is a logical vector.
% sum() adds up the trues. Counting by summing logicals is a core MATLAB move.

%% 2) Step (a): the concatenation warm-up from slide 25
str1 = "Hello ";
str2 = "world!";
disp([str1 str2])

%  PREDICT before you run it: does that print "Hello world!"?
% It does NOT. Check what you actually built:
combined = [str1 str2];
class(combined)
size(combined)

% You built a 1x2 ARRAY OF TWO STRINGS, not one joined string.
% Square brackets concatenate CONTAINERS. For "..." (string), each piece is
% its own element, so you get a list. For '...' (char), each piece is a list
% of letters, so gluing them gives one longer word:
disp(['Hello ' 'world!'])          % char - this one really does join

%% 2) Steps (b)-(d): the message
%  The original line below is the bug this exercise is really about.
message_broken = ["The number of shares above zero is " num2str(myshare)];
disp(message_broken)               % prints with quotes, and truncated

% Three ways to do it properly. Pick one and understand it:
disp(['The number of shares above zero is ' num2str(myshare)])   % char + brackets
disp("The number of shares above zero is " + myshare)            % string + plus
fprintf('The number of shares above zero is %.4f\n', myshare)    % fprintf

%  fprintf is used all over this course but never appears on a slide.
% Read it as: a template with %-placeholders, then the values to drop in.
%   %d integer, %f decimal, %.4f decimal with 4 digits, %s text, \n newline.
% disp prints one thing. fprintf builds a sentence. You want fprintf.

%  Slide 25(d) says that without num2str "MATLAB throws a type error".
% It does not. Try it:
disp(["The share is " myshare])    % silently converts - looks fine, is a 1x2
disp(['The share is ' myshare])    % silently prints INVISIBLE GARBAGE

% The second one converted 0.48 into a character by its ASCII code. No error,
% no warning, no output you can see. Remember this the next time code "runs
% fine". Running is not the same as working.

%% 3) Compare to the theoretical value
theoretical = 0.5;
fprintf('\nEmpirical share : %.4f\n', myshare);
fprintf('Theoretical share for N(0,1): %.3f\n', theoretical);

% Why 0.5? N(0,1) is symmetric about 0, so P(Z>0) = P(Z<0) = 0.5 exactly.
% With only 25 draws you will be some way off. That is sampling noise,
% not a bug.

%% 4) Convergence demo with larger matrices
%  HEADS-UP: the next block uses a 'for' loop, which is Lecture 3.
% You are not expected to write this yet. Read it as English:
% "for each n in this list, make an n-by-n matrix and record the share".
% Slide 24 only asks you to increase the size by hand - that is enough.

sizes  = [5 10 20 50 100 200 500 1000];
shares = zeros(size(sizes));       % preallocate

for k = 1:numel(sizes)
    n = sizes(k);
    Xn = randn(n,n);               %  was A - stop reusing A
    shares(k) = sum(Xn(:) > 0) / numel(Xn);
end

fprintf('\nConvergence demo (n x n matrix):\n');
for k = 1:numel(sizes)
    fprintf('  %4dx%-4d : share = %.4f\n', sizes(k), sizes(k), shares(k));
end

% Law of Large Numbers in one table: more draws, less noise.

%% Visualisation
figure;
plot(sizes.^2, shares, 'o-'); hold on;
yline(theoretical, '--r');
set(gca,'XScale','log');           %  without this, the first 6 points
                                   % are squashed against the y-axis
xlabel('Number of draws (n^2, log scale)');
ylabel('Share of elements > 0');
title('Share of positives vs. sample size (N(0,1))');
legend('empirical','theoretical 0.5','Location','best');   % 
grid on;
