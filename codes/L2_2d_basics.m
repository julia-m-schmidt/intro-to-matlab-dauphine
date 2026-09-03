%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 2 - 2D plotting  (slides 5-13)
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%  Dependencies: base MATLAB only.
%

%% Housekeeping
clear; close all; clc;
rng('default'); rng(42);   %  rng('default') first - see L1_randomdraws

%  TODAY'S QUESTION: a plot is an ARGUMENT, not a picture.
% Slides 3-4 show two charts that are technically correct and completely
% misleading. Nothing in MATLAB will stop you drawing either of them, and
% nothing in an AI assistant will either - it has never seen your data and
% cannot know whether the picture is honest. Every plot you make today,
% ask: what would someone conclude from this, and is that true?

%% ===================== PART A: plot(Y) - THE INDEX TRAP =====================
% Slides 5-7

X = -2:2;
Y = X.^2;               % element-wise power. Note the dot.

%  PREDICT before running: X runs from -2 to 2. What will the x-axis show?
fig1 = figure('Name','Simple 2D plot: y vs index','Color','w');
plot(Y, 'LineWidth', 1.5);
grid on; box on;
title('plot(Y): MATLAB uses the INDEX on the x-axis');
xlabel('Index i'); ylabel('Y(i)=X(i)^2');

%  The x-axis runs 1..5, not -2..2. You gave MATLAB only the heights,
% so it invented the positions: (1,4), (2,1), (3,0), (4,1), (5,4).
% The shape is a V, not a parabola - the picture is WRONG and no error
% was raised. Ask yourself how you would have noticed if the function were
% something less familiar than x^2.

%% ===================== PART B: plot(X,Y) - GIVING IT THE x =================
% Slides 8-10

Xc = -2:2;
Yc = Xc.^2;
fig2 = figure('Name','2D plot with custom x','Color','w');
subplot(1,2,1);
plot(Xc, Yc, 'o-','LineWidth',1.5);
grid on; box on;
title('Coarse grid: X = -2:2'); xlabel('x'); ylabel('y=x^2');

Xd = -2:0.1:2;             % denser grid
Yd = Xd.^2;
subplot(1,2,2);
plot(Xd, Yd, 'LineWidth',1.5);
grid on; box on;
title('Denser grid: X = -2:0.1:2'); xlabel('x'); ylabel('y=x^2');

%  Same function, same command, two different-looking curves. The
% "smoothness" of a plotted function is a property of YOUR GRID, not of the
% function. A coarse grid can hide a spike entirely. When you see a suspiciously
% smooth curve in someone else's paper, ask how many points it was drawn with.

%%  TRAP: what if you forget the dot?
% PREDICT: does this error, or does it silently do something else?
try
    Ybad = Xd^2;
catch ME
    fprintf('Xd^2 errors:\n  %s\n', ME.message);
end


% Answer: it ERRORS, loudly and helpfully, because Xd is 1x41 and ^ means
% matrix power - A^2 is A*A - which needs a SQUARE matrix. Remember this
% feeling, because you are about to lose it.
%
% In Part C of L2_3d_basics the SAME typo does NOT error, because meshgrid on
% two equal-length axes returns a square matrix, and squaring a square matrix
% is perfectly legal. The sharpest version of the point:
%
%    axes 11 and 11  ->  grid 11x11  ->  (X.*Y)^2 runs, and is silently wrong
%    axes 11 and 10  ->  grid 10x11  ->  (X.*Y)^2 errors
%
% Same typo, same session, same person. The only thing that differs is whether
% your two axes happen to have the same number of points.
% Whether a bug shouts at you is luck, not skill.

%% ===================== PART C: STYLING =====================
% Slides 11-12

fig3 = figure('Name','Styling a figure','Color','w');
plot(Xd, Yd, 'LineWidth', 1.8); hold on;
plot(Xd, 2*Yd, '--', 'LineWidth', 1.8);
legend({'y=x^2','y=2x^2'}, 'Location','northwest');
title('plotting function x^2 and 2x^2'); xlabel('x'); ylabel('y');
grid on; box on;

%  'hold on' is the difference between drawing a second line and
% REPLACING the first. Comment it out and re-run this section to see.
% This is the single most common "why did my plot disappear" in Lecture 2.

%% ===================== PART D: EXERCISE 1 (slide 13) =====================

%% 1) Plot y = cos(x) on the support -10:10
x = -10:0.01:10;
y = cos(x);
fig4 = figure('Name','Exercise 1 (reference solution)','Color','w');
plot(x, y, 'LineWidth', 1.5); hold on;

%  Slide 13 says "the support -10:10". Note that -10:10 on its own gives
% 21 integer points, and cos() sampled at 21 integers looks like noise, not a
% wave. The support is [-10,10]; the STEP is your choice. Try it:
%   xbad = -10:10; plot(xbad, cos(xbad))
% Deciding the grid IS part of the answer. The slide does not tell you.

%% 2) Title and axis labels
title('Cosine family'); xlabel('x'); ylabel('value'); grid on; box on;

%% 3) Same figure: z = 2cos(x)
z = 2*cos(x);
plot(x, z, 'LineWidth', 1.5);

%% 4) w = cos(2x), green dashed
w = cos(2*x);
plot(x, w, 'g--', 'LineWidth', 1.5);

%  Amplitude vs frequency: the 2 in 2*cos(x) makes it TALLER,
% the 2 in cos(2*x) makes it FASTER. Students mix these up constantly;
% seeing both on one axis is the whole point of steps 3 and 4.

%% 5) Horizontal dotted line at f(x)=1
yline(1, ':', 'LineWidth', 1.5);

%% 6) Show only values of x above 0
xlim([0, max(x)]);

%% 7) Show only y, z, w > 0
%  Two honest ways to do this, and they mean DIFFERENT things.

% (a) Zoom: keep all the data, look at part of it.
fig5a = figure('Name','Exercise 1 - (a) zoom with ylim','Color','w');
plot(x, y, 'LineWidth',1.5); hold on;
plot(x, z, 'LineWidth',1.5);
plot(x, w, 'g--', 'LineWidth',1.5);
yline(1, ':', 'LineWidth', 1.5);
xlim([0, max(x)]); ylim([0, inf]);        %  keeps step 6's xlim
grid on; box on;
title('(a) ylim: zoomed, curves continue off-screen');
xlabel('x'); ylabel('value');
legend({'y=cos(x)','z=2cos(x)','w=cos(2x)','y=1'}, 'Location','best');

% (b) Mask: delete the data you do not want, using NaN.
y_pos = y; y_pos(y<=0) = NaN;             
z_pos = z; z_pos(z<=0) = NaN;             % variable for all three - confusing
w_pos = w; w_pos(w<=0) = NaN;

fig5b = figure('Name','Exercise 1 - (b) NaN masking','Color','w');
plot(x, y_pos, 'LineWidth',1.5); hold on;
plot(x, z_pos, 'LineWidth',1.5);
plot(x, w_pos, 'g--', 'LineWidth',1.5);
yline(1, ':', 'LineWidth', 1.5);
xlim([0, max(x)]);                        %  keep step 6's restriction
ylim([-2, 2]);                            %  FULL natural range on purpose, so
                                          % the deleted band is visible. See
                                          % the note below - this line is the
                                          % difference between (a) and (b).
grid on; box on;
title('(b) NaN mask: data below zero deleted');
xlabel('x'); ylabel('value');
legend({'y=cos(x)','z=2cos(x)','w=cos(2x)','y=1'}, 'Location','best');

%  Compare the two figures. They have to be read together.
%
% (a) ZOOM. Every number is still in the workspace. The curves run downwards
%     and leave through the BOTTOM EDGE of the axes, and that exit is the
%     signal: it tells you there is more data below the frame.
%
% (b) MASK. The numbers are gone, replaced by NaN. ylim is [-2 2] here, so the
%     empty band where the negative parts used to be is visible. Nothing marks
%     it as deleted. The arcs simply hang in the air.
%
%  NOW THE UNCOMFORTABLE PART - do this live:
%     set (b)'s ylim to [0 2], the same as (a), and re-run.
% The two figures become INDISTINGUISHABLE. One was made by looking at less,
% the other by deleting data, and the reader cannot tell which. (That is why
% (b) is given the wider ylim above: it is the only way the figure is honest
% about what was done to it.)
%
% MATLAB refuses to draw NaN. That is what makes masking useful, and it is
% exactly what makes it dangerous. This is slides 3-4 happening in your own
% code, by your own hand, in four lines.

%  Also note: mask(y>0) and mask(z>0) are IDENTICAL, because z = 2y and
% doubling never changes a sign. Only w differs. Worth 20 seconds - it is a
% free check that your masking did what you think.

%% 9) 1x3 subplot with the sine family
x2 = -10:0.05:10;
y2 = sin(x2);
w2 = 2*sin(x2);
z2 = sin(2*x2);

fig6 = figure('Name','Subplots - sine family','Color','w');
subplot(1,3,1);
plot(x2,y2,'LineWidth',1.5); grid on; box on; title('y_2 = sin(x)');
subplot(1,3,2);
plot(x2,w2,'LineWidth',1.5); grid on; box on; title('w_2 = 2sin(x)');
subplot(1,3,3);
plot(x2,z2,'LineWidth',1.5); grid on; box on; title('z_2 = sin(2x)');
sgtitle('Exercise 1 - Subplots (1x3)');

%  LOOK AT THE Y-AXES. Panel 2 runs to +/-2, panels 1 and 3 to +/-1,
% but all three panels are the same HEIGHT on screen. So 2sin(x) looks
% identical to sin(x). Three panels, three different rulers - and the reader
% will not notice unless they read the numbers.
% Fix it and see the difference:
%   linkaxes(findobj(fig6,'Type','axes'),'y')
% Independent axes across panels is the most common misleading chart in
% economics papers, and subplot creates it BY DEFAULT.

%% Exporting figures (useful for the assignment)
% exportgraphics(fig3,'fig_styling.png','Resolution',150);
% exportgraphics(fig6,'fig_subplots.png','Resolution',150);

disp('Demo complete: 2D plotting essentials.');
