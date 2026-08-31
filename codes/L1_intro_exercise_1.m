%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 1 - Fundamental Classes
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%  Do not press "Run". Sections are separated by %%.


%% Housekeeping                                                    
clear; close all; clc;

% 'clear all' also clears breakpoints and force-reloads every function.
% You almost never want it - plain 'clear' is enough. If an assistant hands
% you 'clear all', it learned that from 15-year-old forum posts.

% No cd() here, on purpose. An absolute path works on exactly one
% machine (mine), and breaks on all of yours. Instead: use the "Current
% Folder" browser on the left, or check where MATLAB thinks you are:
pwd
% dir

%% ===================== PART A: FUNDAMENTAL CLASSES =====================

%% Scalar
s = 5;
size(s)   % returns 1  1

%% Vector
v = [1 2 3];    % 1x3 row vector
size(v)
v = [1; 2; 3];  % 3x1 column vector
size(v)

%% Matrix
M = [1 2; 3 4];  % 2x2 matrix
size(M)          % returns 2  2

%% Logical
x = true
y = (5 > 3)      % semicolons removed so you actually see something

%% Character array vs string
old = 'Dauphine';   % char
new = "Dauphine";   % string

% The difference is not cosmetic. PREDICT before running:
class(old)
class(new)
length(old)         % ?
length(new)         % ?
strlength(new)      % ?
old == new          % ?
old == old          % ?

% Rule of thumb: '...' is a LIST OF CHARACTERS.
% "..." is ONE PIECE OF TEXT. Almost every string bug you will hit this
% semester comes from mixing them up.

%% Numeric
a = 42;             % double (default)
b = int32(42);      % 32-bit integer
c = single(3.14);   % single precision float

% PREDICT: true or false?
c == 3.14
0.1 + 0.2 == 0.3
% If that surprised you, ask a tool to explain floating point to you.
% This is what they are genuinely excellent at - and you should ask.

%% Cell array
C = {1, "Paris", [1 2 3]}

%% Structure
student.name = "Julia";
student.age = 24;
student.grades = [5 18 11]

%% Table
T = table([1;2;3], ["A";"B";"C"], 'VariableNames',{'ID','Label'})  

%% Function handle
f = @sin;
f(pi/2)

%% Built-in functions
sin(pi/2)     % 1
cos(pi)       % -1

exp(1)        % Euler's number e = 2.718...
log(100)      % natural log (not base 10!)
log10(100)    % base 10 log


%% ===================== PART B: EXERCISE 1 =====================

%% 1) Simple calculations directly
8 + 9
8 * 9
8 / 9
8^9

%% 2a) Store numbers in variables    <-- the DEFINITIONS
u = 8;
v = 9;          % Note: this silently overwrites the vector v from Part A.
          

%% 2b) Repeat the calculations using variables    <-- the USE
u + v
u * v
u / v
u^v

%% 3) Clear the workspace
clear

% LIVE DEMO - three steps, in this order:
%   1. Run 2a, then 2b.        -> u + v gives 17
%   2. Run THIS section.       -> watch the Workspace panel empty out
%   3. Re-run 2b ONLY.         -> Unrecognized function or variable 'u'
%
% The point is step 3. Do NOT re-run 2a: that just re-creates u and v and you
% get 17 again, which demonstrates nothing. 'clear' deleted the variables;
% the lines that USE them are still there and now have nothing to work with.
%
% This is the difference between the script (the text you wrote) and the
% workspace (what MATLAB currently has in memory). They are not the same
% thing, and confusing them is the single most common beginner error.

%% 4) Use built-in MATLAB functions
sin(pi/2)
sqrt(16)
log(10*exp(-5))

% PREDICT: is the line below the same thing?
log(10e-5)
% Both are valid MATLAB. They are not equal. The slide says log(10e^-5) -
% which one did I mean? Ask an assistant to code the slide and see which it
% picks. It has to guess, because the notation is ambiguous. So do you.

%% 5) Complex number example
u = 1 + sqrt(-4)   
real(u)            % separate real part
imag(u)            % separate imaginary part

% MATLAB quietly goes complex here. Python's math.sqrt(-4) raises an
% error; numpy returns nan unless you ask for a complex dtype. Same maths,
% three different behaviours. Never assume a translated script does the same
% thing as the original.

%% 6) Read the documentation
help sin      % 'help' prints in the console - better for live use
% doc sin     % opens the browser (steals your screen in class)

% doc/help tells you what the function DOES.
% An assistant tells you what you probably MEANT.
% You need both, but only one of them is the ground truth.