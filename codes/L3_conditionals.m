%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 3 - Conditional statements  (slides 3-15)
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%  Dependencies: base MATLAB only.
%

clear; close all; clc;
rng('default');  


%% 1) if ... end (slides 3-5)
% Task: Draw a uniform integer 1..100; print only if above 50
a = randi(100,1);
fprintf('Drawn a = %d\n', a);
if a > 50
    disp("a is above 50");
end

%% 2) if ... else ... end (slides 6-8)
a = randi(100,1);
fprintf('Drawn a = %d\n', a);
if a > 50
    disp("a is above 50");
else
    disp("a is equal or below 50");
end

%% 3) if ... elseif ... else ... end (slides 9-11)
a = randi(100,1);
fprintf('Drawn a = %d\n', a);
if a > 50
    disp("a is above 50");
elseif a == 50
    disp("a is equal to 50");
else
    disp("a is below 50");
end

%%  TRAP: = is not ==
% Slide 10 says in words: "Display 'a is equal to 50' if a = 50".
% That is fine English and broken MATLAB. PREDICT what each line does:

a = 7;
a == 5        % a QUESTION: is a equal to 5?   -> false
% a = 5       % a COMMAND: put 5 into a.  Uncomment it and watch a change.

% Inside an if, MATLAB refuses the assignment outright:
try
    eval('if a = 5, disp(''hello''), end');
catch ME
    fprintf('"if a = 5" gives: %s\n', ME.message);
end

%  MATLAB protects you here. C, and older languages, do not - there
% "if (a = 5)" silently assigns and is always true. Worth knowing, because
% you will read code in those languages, and because it is the origin of the
% "always use ==" rule you will see repeated everywhere.
% Analogy: "=" puts a book in a box. "==" opens the box to check what is inside.

%% 4) Multiple conditions with || (OR) and && (AND)  (slides 12-14)

% In MATLAB:
%   || (short-circuit OR)  → true if AT LEAST ONE condition is true
%   (evaluates first element first, then stops if not fulfilled)
%   && (short-circuit AND) → true only if ALL conditions are true
%
% These operators are used for combining scalar logical tests,
% especially inside if/while statements.

% ----------------------------
% Example 1: OR condition (||)
% ----------------------------
% Generate a random integer between 1 and 4
a = randi(4,1);

% If a is 1 OR a is 3 → then a is odd
% Otherwise → a must be 2 or 4, so it is even
if (a == 1) || (a == 3)
    disp("a is odd");
else
    disp("a is even");
end

% -----------------------------
% Example 2: AND condition (&&)
% -----------------------------
% Generate a random integer between 1 and 100
b = randi(100,1);

% Check if b is BOTH >= 20 AND <= 30 (i.e. inside the interval [20,30])
if (b >= 20) && (b <= 30)
    fprintf('b = %d is in [20,30]\n', b);
else
    fprintf('b = %d is NOT in [20,30]\n', b);
end


%%  TRAP: && vs & 
%
%  THE IDEA IN ONE LINE:   &  SELECTS.   &&  DECIDES.
%
% x below is SEVEN numbers, not one. So (x >= 0) is not one answer - it asks
% the question of every element and hands back seven:
%
%     x        = -3  -2  -1   0   1   2   3
%     (x >= 0) =  0   0   0   1   1   1   1
%     (x <= 2) =  1   1   1   1   1   1   0
%
%   &  combines them ELEMENT BY ELEMENT -> seven answers -> a MASK, whose job
%      is to select:  x(mask)
%   && demands ONE answer, because its job is to decide. An 'if' can only
%      branch one way; it cannot go seven ways at once.

x = -3:3;

mask = (x >= 0) & (x <= 2)     % fine: a 1x7 logical mask
x(mask)                        % -> 0 1 2

% DIRECTION 1 - the LOUD mistake. && cannot digest seven answers:
try
    if (x > 0) && (x < 2), disp('yes'); end
catch ME
    fprintf('&& with a vector: %s\n', ME.message);
end

% DIRECTION 2 - the SILENT one.
% Same line with a single &. PREDICT: does it error?
if (x > 0) & (x < 2)
    disp('took the TRUE branch');
else
    disp('took the FALSE branch - and note: no error, no warning');
end

%  It does NOT error. MATLAB accepts a whole array as an if-condition and
% quietly treats it as ALL(...). So you silently asked "is EVERY element
% between 0 and 2?", which is a different question from the one you meant.
fprintf('all(mask) = %d   <- that is what the if above really tested\n', ...
        all((x > 0) & (x < 2)));

%  And here is the version that hides. When the mask happens to be all true,
% the code APPEARS to work, and the bug waits for the day one element fails:
y = [1 2 3];
if (y > 0) & (y < 10)
    disp('looks like it worked - but only because every element passed');
end

%  One more, worth ten seconds: an EMPTY condition is false.
if ([] > 0), disp('true'); else, disp('if [] is FALSE - a filter that'); end
disp('   matched nothing takes the else branch, silently.');

%  Rule of thumb:
%   inside if/while  -> && and ||   (one answer:  a DECISION)
%   building a mask  -> &  and |    (one per element: a SELECTION)
%
% Get it backwards one way and you get an error (lucky). Get it backwards the
% other way and you get a mask where you wanted a decision, and MATLAB says
% nothing at all (not lucky).
%
%  THE DIAGNOSTIC: an 'if' should never be handed a vector. If you are not
% sure whether it will be, say what you actually mean - any(...) or all(...) -
% and then the reader knows too.

%%  The SECOND difference: short-circuiting
% && reads the LEFT side first. If that already settles the answer, the right
% side is never evaluated at all. & always evaluates both. That is not a
% performance trick, it is a safety net - the "guard" pattern:

v = [1 2 3];
k = 7;                       % deliberately out of range

(k <= numel(v)) && (v(k) > 0)   % false. No error: v(k) is never reached.

try
    (k <= numel(v)) & (v(k) > 0)
catch ME
    fprintf('with a single & : %s\n', ME.message);
end

%  Read it aloud: "check that it is SAFE, and only then look." 7 <= 3 is
% false, so && already knows the whole thing is false and does not touch
% v(7). The single & evaluates both sides no matter what, so v(7) runs and
% the line dies. Order of conditions is a decision, not a style preference.
%
%% Exercise 1 - Conditional Statements (worked references, live-coding version)
% Goal: practice IF/ELSE logic, comparison operators, and mapping numbers to text.
%
%  SECTION NAMES MATCH THE SLIDE. Slide 15 lists SIX numbered tasks; the
% sections below are TASK 1 ... TASK 6 and do exactly those, in that order.

%% TASK 1 (slide 15): max between two random numbers x and y
% rand() ~ U(0,1)  (continuous on [0,1])
x = rand();
y = rand();

% >> “What does rand return? Are ties likely?”
% Ties have probability ~0 in continuous draws, but we’ll code for the general case anyway.
if x > y
    max_xy = x;
else
    max_xy = y;
end
fprintf('[1] Max(x,y) = %.4f  (x=%.4f, y=%.4f)\n', max_xy, x, y);

% NOTE: MATLAB also has max(x,y), but we use IF to practice control flow.

%% TASK 2 (slide 15): max among three numbers x, y, z
% We reuse x,y and draw z fresh to emphasize “same scale, same distribution.”
z = rand();

% >> “How many branches do we need? Why do we check >= ?”
% Using >= makes this robust even if values were not continuous (e.g., integers).
if (x >= y) && (x >= z)
    max_xyz = x;
elseif (y >= x) && (y >= z)
    max_xyz = y;
else
    max_xyz = z;
end
fprintf('[2] Max(x,y,z) = %.4f  (x=%.4f, y=%.4f, z=%.4f)\n', max_xyz, x, y, z);

% Sanity check (optional): compare with built-in
% disp(max([x,y,z]));   % uncomment to show equivalence

%% TASK 3 (slide 15): draw the traffic light - a random integer in {1,2,3}
% randi([a,b],1) draws an integer in {a, a+1, ..., b}
trafficlight = randi([1,3],1);
fprintf('[3] Traffic light code = %d\n', trafficlight);

%% TASK 4 (slide 15): map the code to a colour and print it
% 1 = red, 2 = orange, 3 = green
% >> "Map numbers to categories." (This is common in data work.)
if trafficlight == 1
    color = "red";
elseif trafficlight == 2
    color = "orange";
else
    color = "green";
end
fprintf('[4] The traffic light color is %s\n', color);


switch trafficlight
    case 1, color2 = "red";
    case 2, color2 = "orange";
    case 3, color2 = "green";
    otherwise, color2 = "IMPOSSIBLE";   
end
fprintf('    switch gives the same answer: %s\n', color2);

%  Note the 'otherwise'. The if/elseif version above has NO such branch:
% its final 'else' quietly claims that anything not 1 and not 2 must be green.
% If trafficlight were ever 4, or 0, or NaN, the if-version says "green" and
% the switch-version says "IMPOSSIBLE". Neither errors.
% ASK THE ROOM: which behaviour do you want in code that controls a car?
% A missing 'otherwise' is the most common bug in student conditionals, and
% it is invisible until the day the data contains something unexpected.

%% TASK 5 (slide 15): the driver's decision - random in {1,2}
% 2 = pass the light, 1 = stop
decision = randi([1,2],1);       % 1 or 2 with equal probability

% Map number to text for readable output
if decision == 2
    dec_str = "pass";
else
    dec_str = "stop";
end
fprintf('[5] Driver decision code = %d  ->  %s\n', decision, dec_str);

%% TASK 6 (slide 15): print DANGER by combining the decision and the colour
% >> "Two independent draws, combined with AND."
% Use short-circuit AND (&&) for scalar logicals inside IF.
if (decision == 2) && (trafficlight == 1)
    disp('[6] *** DANGER: driver passes while light is RED ***');
else
    disp('[6] OK: no red-pass conflict detected.');
end

%  Only ONE of the six combinations is dangerous (pass + red), so this fires
% about 1 time in 6. Re-run the section a few times, or use the forced values
% in the "optional experiments" block at the end, rather than waiting for it.

%% Recap
% - rand vs randi: continuous vs discrete draws
% - IF / ELSEIF / ELSE: mutually exclusive branches
% - && and ||: short-circuit (scalar) logic inside IF/WHILE
% - Mapping numeric codes to strings for readable logs
% - Always print enough context (codes + text) to debug quickly

%% Optional quick experiments 
% 1) Force a red light to show DANGER:
% trafficlight = 1; decision = 2;  % expect DANGER message
% 2) Bias the driver to pass more often and rerun several times.
% decision = (rand() < 0.7) + 1;   % ~70% pass (2), 30% stop (1)


disp('Conditionals demo complete.');
