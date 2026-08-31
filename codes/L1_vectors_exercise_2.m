%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 1 - Vectors  (slides 15-17)
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%  Do not press "Run" - one section below is *designed* to fail.
%

%% Housekeeping
clear; close all; clc;

% TODAY'S QUESTION: a vector has a SHAPE, not just contents.
% [1 2 3] and [1;2;3] hold the same numbers and are not the same object.
% Nearly every "why doesn't this work" in this course is a shape problem.

%% ===================== PART A: BUILDING A ROW VECTOR =====================
% Five ways to build the SAME row vector. Watch the Workspace panel:
% x is overwritten each time. Nothing warns you. That is normal here because
% we mean it - but remember the feeling, it is how real scripts go wrong.

x = [1 2 3]      % explicit
x = 1:1:3;       % colon operator: start, step, end
x = 1:3;         % colon operator with default step of 1
x = zeros(1,3);  % preallocate 1x3 with zeros, then fill

x(1,1) = 1;
x(1,2) = 2;
x(1,3) = 3;

x = linspace(1,3,3);   % N evenly spaced points between start and end (inclusive)

% linspace says:  "give me N points between start and end"
% start:step:end says: "count from start to end using this step size"

%% Column vector
x = [1; 2; 3];
x = zeros(3,1);
x(1,1) = 1;
x(2,1) = 2;
x(3,1) = 3;
x = [1:3]';      

% PREDICT before running: which of these is true?
iscolumn(x)
isrow(x)

%% ===================== PART B: MIXED CONTENTS =====================

% A vector can hold an integer, an irrational and a complex number at
% once - but NOT because MATLAB is clever. It promotes everything to the
% widest type present. Check what that did to the whole vector:
x = [sqrt(64) pi complex(3,4)]
class(x)
isreal(x)        % false - ONE complex entry made the WHOLE vector complex

%% Is it a column vector?
iscolumn(x)

%% Transpose row -> column
x = transpose(x)

% Careful: x' would ALSO conjugate (3+4i becomes 3-4i).
% Compare the two, this is the whole point of slide 23:
x.'
x'

%% Length of vector
length(x)

%% ===================== PART C: THE DELIBERATE ERROR =====================

% Another vector y, of a DIFFERENT length
y = [sin(pi); exp(2)]

% PREDICT: what is the first entry of y?
% It prints as 0.0000. It is not zero.
sin(pi)              % 1.2246e-16
sin(pi) == 0         % false
% Same lesson as 0.1 + 0.2 ~= 0.3 in exercise 1. Never test a float with ==.
% Use a tolerance instead:
abs(sin(pi)) < 1e-10

%% This section is SUPPOSED to fail
% x is 3x1, y is 2x1. Addition needs identical shapes.
% Read the error message - MATLAB tells you exactly what is wrong.
% "Arrays have incompatible sizes for this operation."
size(x)
size(y)

x + y            % <-- deliberate error. 

%% Fix it: make the shapes match
y = [y; 0]       % append a 0, now y is 3x1

%% Linear combination
z = 2*x + y + 5

% the "+ 5" added 5 to EVERY entry (scalar broadcasting),
% while "+ y" added element by element. Two different rules, one symbol.

%% Slice from 2nd element to end
z(2:end)

% MATLAB indexes from 1, not 0. 'end' is a keyword meaning "last".
% If you have written Python, this is the single most common thing you will
% get wrong all semester.

%% Transpose back
z = z'

%% ===================== PART D: EXERCISE 2 (slide 17) =====================

%% 1) Create vector z
z = [1 5 7 9];

%% 2) Length
len = length(z)

%% 3) Random vector w of size 4
w = rand(1,4)

%% 4) Check if w is a row vector
isrow(w)

%% 5) Show the 3rd value
disp(w(3))

%% 6) Multiply the 3rd value by 2
w(3) = 2 * w(3);
w                

%% ===================== PART E: PROPERTY CHECKS (slide 23) ==============

isnumeric(w)
ischar(w)
isequal([1 2 3], [1 2 3])
isequal([1 2 3], [1; 2; 3])   % PREDICT: same numbers. Same object?
isinf(1/0)
isnan(0/0)

% isequal is shape-aware. That last one is false. If you ever "check"
% a result with == and get a matrix of answers instead of one true/false,
% you wanted isequal.
