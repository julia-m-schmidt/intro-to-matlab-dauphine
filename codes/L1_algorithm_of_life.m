%% Algorithm of Life -- from words to code
%  Lecture 1 warm-up. Run ONE SECTION AT A TIME: Cmd+Enter (Ctrl+Enter on PC).
%
%  Your partner just described a daily routine in words. Here is what it takes
%  to turn one into something a machine can actually follow -- and on the way
%  it quietly uses all four lectures of this course.

%% 0. The version you handed me
%
%       buy_ingredients
%       chop_everything
%       make_curry         
%       eat
%
%  Give this to somebody who has never cooked. Where do they stop?
%
%  On make_curry. The step has been NAMED, not SPECIFIED. Naming is not
%  specifying. And the recipe is no help, because the recipe says:
%
%       "season to taste"
%
%  Which is not an instruction. It is a description of a person tasting.
%  Everything below is what it costs to say it properly.

%% 1. The state of the kitchen                               [Lecture 1]
clc

target    = 7;      % the spice level I actually want, 0-10
spice     = 0;      % where we start: coconut milk, no chili yet
caution   = 0.5;    % each time, close half the remaining gap
tolerance = 0.25;   % "close enough". This number is the whole exercise.
chiliLeft = 8;      % what is in the kitchen

fprintf('Target spice level %.1f, starting from %.1f, %d chilies in the drawer.\n', ...
        target, spice, chiliLeft);

%% 2. A decision -- can this curry happen at all?            [Lecture 3]
if chiliLeft >= 5
    disp('Plenty of chili. Proceed.')
elseif chiliLeft > 0
    disp('Not many chilies. This will be a mild curry.')
else
    disp('No chili. This is a soup, and we should be honest about that.')
end

%% 3. The loop -- taste, adjust, taste again            [Lectures 3 + 4]
%  This is what "season to taste" actually means, written down.

spice  = 0;
record = spice;      % remember every taste, so we can draw it later
taste  = 0;

while abs(target - spice) > tolerance && chiliLeft > 0

    taste     = taste + 1;
    spice     = addChili(spice, target, caution);   % <-- our own function
    chiliLeft = chiliLeft - 1;
    record(taste + 1) = spice;

    fprintf('taste %d:  spice %.3f   (gap %.3f)\n', ...
            taste, spice, target - spice);
end

fprintf('\nDone after %d tastes. Final spice %.3f, gap %.3f.\n', ...
        taste, spice, target - spice);
fprintf('%d chilies left in the drawer.\n', chiliLeft);

%% 4. Draw it                                                [Lecture 2]
figure

plot(0:taste, record, '-o', 'LineWidth', 2, 'MarkerSize', 8)
hold on
yline(target, '-',  'the curry I wanted', 'LineWidth', 1.5)
yline(target - tolerance, '--', 'close enough', 'LabelHorizontalAlignment', 'left')
hold off

grid on
xlabel('number of tastes')
ylabel('spice level (0-10)')
title('Season to taste, written down')
ylim([0 target + 1])
legend('the curry so far', 'Location', 'southeast')

%% 5. Why the tolerance is the whole point
%  Look at the gap column in section 3: 3.5, 1.75, 0.875, 0.4375, 0.219...
%  It halves every time. It gets closer forever and never lands exactly on 7.
%
%  So this loop would NEVER STOP:
%
%       while spice ~= target        % <-- do not run this
%
%  Same lesson as 0.1 + 0.2 ~= 0.3 in exercise 1, and sin(pi) ~= 0 in
%  exercise 2. Never ask a decimal to be exactly equal to anything.
%  Ask it to be CLOSE ENOUGH. That is what tolerance is for.
%
%  Proof, with a safety net so it cannot hang:

spice    = 0;
maxTries = 50;

for k = 1:maxTries
    spice = addChili(spice, target, caution);
end

fprintf('After %d tastes the gap is %.3e -- small, but not zero.\n', ...
        maxTries, target - spice);
fprintf('spice == target ?  %d   (0 means false)\n', spice == target);

%% 6. What just happened
%
%   variables, a vector, types              -> today
%   the figure                              -> Lecture 2
%   the if and the while                    -> Lecture 3
%   addChili.m, sitting in its own file     -> Lecture 4
%   closing a gap until it is small enough  -> Lecture 4, optimisation
%
%  That last one is not a metaphor. Tasting and adjusting IS how a solver
%  works. You have now run the whole course once, in a kitchen.
%
%  Change ONE number in section 1 and re-run sections 3 and 4:
%     caution   = 1.0     straight to the target. Why is that a bad idea?
%     caution   = 0.1     very timid. Count the chilies.
%     tolerance = 0.01    fussier. Do you have enough chili to get there?
%     chiliLeft = 3       the drawer runs out. Which part of the while stops it?
