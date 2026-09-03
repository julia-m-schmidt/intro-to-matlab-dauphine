%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 2 - Exercise 2: 3D scatter + fitted regression plane  (slides 23-25)
%
%  SECTION NAMES MATCH THE SLIDE. Slide 24 lists six numbered steps; the
%  sections below are called STEP 1 ... STEP 6 and do exactly those, in that
%  order. The SETUP sections are the copy-paste block from slide 23.
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%
%  TOOLBOX NOTE: needs the Econometrics Toolbox for Data_NelsonPlosser.
%  Section 0 checks. Everything else is base MATLAB.
%

clear; close all; clc;

%  TODAY'S QUESTION: a regression with two regressors IS a plane.
% Not "like" a plane - it is one. Once you can see that, R^2 stops being a
% number you report and becomes something you can look at.

%% SETUP A (slide 23): load the data
% The old version had 25 lines of try/catch that SIMULATED a fake dataset if
% the toolbox was missing. That is worse than failing: you would have got a
% plot, a regression, and an R^2 - all from invented numbers, with only a
% warning scrolling past. Fail loudly instead.

if isempty(which('Data_NelsonPlosser.mat'))
    error(['Data_NelsonPlosser.mat not found. It ships with the ' ...
           'ECONOMETRICS TOOLBOX. Check with: ver']);
end

load Data_NelsonPlosser        % gives Data (111x14), dates, series

%  NOTE THE UNDERSCORE, as in Lecture 1. If you copy-pasted this line
% from the slide PDF and it failed with "Unable to find file or directory
% 'Data'", that is why: the underscore does not survive copy-paste from some
% PDFs. Type it rather than pasting it.

%% SETUP B (slide 23): select the sample
ourData = Data(51:end, :);
Time    = dates(51:end);

SP    = ourData(:,14);        % (SP)    STOCK PRICES
BY    = ourData(:,13);        % (BY)    BOND YIELD
GNPPC = ourData(:, 3);        % (GNPPC) REAL PER CAPITA GNP

%  The column numbers come off the slide. The dataset ships a `series`
% variable that names them - check rather than trust:
series([3 13 14])

%% SETUP C: returns and growth rates
rt  = 100*diff(log(SP));      % price return, in PERCENT
gt  = 100*diff(log(GNPPC));   % GDP per capita growth, in PERCENT
BYt = BY(2:end);              % align: diff() returned one fewer element
t   = Time(2:end);

%  WATCH THE UNITS. rt and gt are multiplied by 100; BY is NOT, because
% a bond yield is already in percent. So b2 below reads "percentage points of
% return per percentage point of yield". In Lecture 1 we did the same
% regression WITHOUT the 100s and got b2 = -0.0189 instead of -1.89.
% Same model, same conclusion, coefficients 100x apart. Nobody warns you
% about units - not MATLAB, and not an assistant.

fprintf('lengths: SP=%d, rt=%d, gt=%d, BYt=%d\n', ...
    numel(SP), numel(rt), numel(gt), numel(BYt));

%% STEP 1 (slide 24): plot the price return, with time in abscissa
% Slide 24 asks for this FIRST and the old reference file skipped it entirely.
% Always look at a series before you regress it.

figure('Name','Step 1: returns over time','Color','w');
plot(t, rt, '-o', 'LineWidth', 1.2); hold on;
yline(0, 'k:');
grid on; box on;
xlabel('Year'); ylabel('r_t  (%)');
title('Stock price returns, 1911-1970');

%  Look before you model. The 1930s are enormous in both directions.
% Sixty annual observations spanning the Depression and two world wars is
% not a lot of data, and a couple of points will be doing much of the work
% in the regression you are about to run.

%% STEP 2 (slide 24): estimate rt = b0 + b1*gt + b2*BYt + et
%
%  We estimate it with the two TOOLBOX commands first, because they are the
%  ones you will actually use. The raw linear-algebra version (X\rt) is at the
%  bottom of this section, in comments - it is the least intuitive of the
%  three, and you do not need it to get the right answer.
%
%  Both commands below are Statistics and Machine Learning Toolbox.

if isempty(which('fitlm')) || isempty(which('regress'))
    error(['STEP 2 needs the STATISTICS AND MACHINE LEARNING TOOLBOX ' ...
           '(fitlm, regress). Check with: ver']);
end

%% STEP 2a: fitlm - the one to LOOK at
%  Pass the RAW regressors. fitlm builds the intercept ITSELF.

mdl = fitlm([gt BYt], rt)     % no semicolon: we WANT the table printed

%  Read the table. For EVERY coefficient you get the estimate, its standard
% error, its t-statistic and its p-value - then R^2, adjusted R^2 and the
% F-test underneath. x1 is gt, x2 is BYt. Nothing else in this file gives you
% the uncertainty; this is where it comes from.

beta = mdl.Coefficients.Estimate;   % 3x1 - [b0; b1; b2], same order as always
yhat = mdl.Fitted;                  % 60x1 - one prediction per year

%% STEP 2b: regress - the one to COMPUTE with
%
%  SAME MODEL, SAME NUMBERS, OPPOSITE INPUT. regress does NOT add an
%  intercept. You must hand it the full design matrix, ones column included.
%
%  WHAT IS ACTUALLY IN X?
%  One row per YEAR. One column per THING THAT GETS ITS OWN COEFFICIENT.
%  We have 60 years and 3 coefficients (b0, b1, b2), so X is 60x3:
%
%                col 1    col 2     col 3          what we explain
%               (ones)     gt        BYt                  rt
%       1911  [    1      0.92      3.90  ]             -1.18
%       1912  [    1      4.03      3.90  ]              3.09
%        ...       ...     ...       ...                  ...
%       1970  [    1     -1.72      7.60  ]            -15.47
%               \____/   \_______________/
%              intercept    the real data
%
%  THE COLUMN OF ONES IS THE WHOLE TRICK, and it is the part nobody explains.
%  We want b0 added to every year. There is no "and also add a constant"
%  button. So we invent a regressor that equals 1 in every single year -
%  because b0*1 = b0. The intercept becomes an ordinary coefficient on a
%  column of ones. That is the entire idea.
%
%  Delete that column and you have NOT estimated "the same model, no
%  intercept". You have forced the plane through the origin: you are asserting
%  that a year with zero growth and a zero bond yield must have zero return.
%
%  SHAPES ARE THE WHOLE STORY:
%       X is 60x3,  beta is 3x1,  so  X*beta is 60x1 - one fitted value per
%       year, matching rt. When a regression refuses to run, print size() of
%       both sides before you change anything else. It is almost always this.

X = [ones(size(rt)), gt, BYt];              % 60x3 - see the sketch above
[b, bint, r, rint, stats] = regress(rt, X); % note: (y, X), not (X, y)

%  What each output is:
%    b     = the coefficients        - the same [b0; b1; b2] fitlm just printed
%    bint  = 95% confidence intervals, one row per coefficient
%    r     = residuals               - rt - yhat, the vertical misses
%    rint  = intervals for outlier diagnostics
%    stats = [R^2, F, p, error variance]  -> stats(1) IS the R^2
%
%  Nothing is printed. You get plain arrays, which is the point: regress is
% for computing WITH the result, fitlm is for looking AT it.

%% STEP 2c: fitlm vs regress - the difference that catches people every year
%
%  THEY WANT OPPOSITE INPUTS. This is the whole difference, and it is an
%  interface difference, not a statistical one. Same estimator, same answer.
%
%     fitlm([gt BYt], rt)      ADDS the intercept itself ('Intercept' is true
%                              by default) -> pass the RAW regressors.
%                              Hand it our X and the ones column is DUPLICATED:
%                              rank deficiency, and MATLAB warns you.
%
%     regress(rt, X)           does NOT add an intercept -> pass the FULL
%                              design matrix, ones column included.
%                              Forget the ones column and you have silently
%                              fitted through the origin. NO warning at all.
%
%  So the two failure modes are not symmetric, and that asymmetry matters:
%    - getting fitlm wrong is LOUD    (duplicate constant -> rank warning)
%    - getting regress wrong is SILENT (no intercept -> plausible wrong numbers)
%
%  AND THE ARGUMENT ORDER IS REVERSED TOO:  fitlm(X, y)  but  regress(y, X).
%  Same toolbox, opposite conventions, both ways round. Check the doc every
%  time. This is not something you are supposed to remember.

%  Do the two agree? Do not take my word for it:
fprintf('\nlargest gap, fitlm vs regress: %.2e\n', max(abs(beta - b)));

%% STEP 2d: R^2, and why the formula looks nothing like the textbook
R2 = 1 - var(rt - yhat)/var(rt);

fprintf('\nOLS fit: rt = %.3f %+.3f*gt %+.3f*BY   (R^2 = %.3f)\n', ...
    beta(1), beta(2), beta(3), R2);   %  %+ so we do not print "+ -1.894"

fprintf('R^2 by hand %.6f | fitlm %.6f | regress %.6f\n', ...
    R2, mdl.Rsquared.Ordinary, stats(1));

%  Textbook:  R^2 = 1 - SSR/SST = 1 - sum(e.^2) / sum((rt-mean(rt)).^2)
%  Here:      R2  = 1 - var(rt-yhat)/var(rt)
%
% These are the SAME thing, not an approximation: var() divides both the top
% and the bottom by the same (n-1), so it cancels and the ratio is exactly
% SSR/SST. All three numbers above agree to about 1e-16.
%
%  It only works because the model HAS an intercept, which forces mean(e) = 0.
% Drop the ones column and this formula quietly lies to you - no error, just a
% plausible number.

%% (reference) UNDER THE HOOD: solving it yourself with backslash
%
%  You do not need this section to do the exercise. It is here because it is
%  what fitlm and regress are doing internally, and because building X by hand
%  is what teaches you that the intercept is just a column of ones.
%
%      beta = X \ rt;      % 3x1 - identical to what fitlm and regress returned
%      yhat = X * beta;    % 60x1
%
%  WHAT BACKSLASH IS DOING - IT IS NOT WHAT IT LOOKS LIKE.
%  X\rt does not solve X*beta = rt. That system has 60 equations and 3
%  unknowns; it has NO solution. Backslash returns the beta that makes the
%  miss as small as possible - it minimises sum((rt - X*beta).^2). MATLAB
%  sees that X is tall, and quietly switches from "solve" to "least squares"
%  (via QR). Same operator, different job, no announcement.
%
%  Note the .^2 there: square each residual, then add them up. Element-wise.
%  Writing ^2 would ask for a matrix power and is a different question
%  entirely - see L1_matrix_exercise3.
%
%  FIVE WAYS TO GET THE SAME beta. All five agree here to about 8 digits.
%  They stop agreeing when X is badly conditioned, which is the whole point.
%
%    1)  beta = X \ rt;                 <- the one to use. QR. Short and accurate
%
%    2)  beta = (X'*X) \ (X'*rt);       <- the "normal equations" from the
%                                          textbook. Correct, but forming X'X
%                                          SQUARES the conditioning: here
%                                          cond(X) = 28 becomes cond(X'X) = 804,
%                                          so it throws away about twice as many
%                                          digits. Costs nothing to avoid
%
%    3)  beta = pinv(X) * rt;           <- pseudo-inverse. Fine. It also returns
%                                          an answer when the columns are
%                                          collinear, which is either a rescue
%                                          or a cover-up depending on whether
%                                          you noticed
%
%    4)  beta = lscov(X, rt);           <- base MATLAB. The one to reach for
%                                          when you need weights, or want the
%                                          standard errors without a toolbox
%
%    5)  beta = inv(X'*X) * X'*rt;      <- DO NOT. Identical on paper, worst
%                                          numerically, and it builds an entire
%                                          matrix just to use it once.
%                                          See L1_assignment

%% STEP 3 (slide 24): scatter3 with the 'filled' option
fig = figure('Name','3D scatter + fitted plane','Color','w');
scatter3(gt, BYt, rt, 36, 'filled');

%% STEP 4 (slide 24): hold on, then build x1fit and x2fit with linspace
%  NOTHING APPEARS ON SCREEN from this section, and that is correct. It sets
% one state and creates two vectors. The picture does not change until STEP 6.

hold on;              % the slide says this explicitly: "next line, write
                      % hold on;". It arms the axes so that the NEXT plotting
                      % command ADDS to them instead of wiping them clean.

x1fit = linspace(min(gt),  max(gt),  15);   % 15 evenly spaced points on x1
x2fit = linspace(min(BYt), max(BYt), 15);   % same for x2

%% STEP 5 (slide 24): compute Zhat from the estimated parameters
[X1f, X2f] = meshgrid(x1fit, x2fit);   % the grid - this is what meshgrid was for
Zhat = beta(1) + beta(2)*X1f + beta(3)*X2f;

%% STEP 6 (slide 24): mesh(), GDP growth on x, bond yield on y, with labels
mesh(X1f, X2f, Zhat);          % <- here is where STEP 4's "hold on" pays off
grid on; box on;
xlabel('x_1 = GDP growth g_t (%)');
ylabel('x_2 = Treasury bond yield BY_t (%)');
zlabel('r_t = stock price return (%)');
title('3D scatter with fitted regression plane');
legend({'Observed (g_t, BY_t, r_t)','Fitted plane'}, 'Location','best');
view(-30, 20);

%
%  The axis orientation is a real requirement of step 6, and it is easy to get
% backwards. meshgrid(x1fit, x2fit) makes X1f vary ACROSS columns, so mesh puts
% x1fit on the x-axis and x2fit on the y-axis - GDP growth on x, bond yield on
% y, exactly as the slide asks. Swap the two arguments and the picture is
% transposed, with no error.

%  Read the geometry off the picture:
%   - b1 is the tilt of the plane in the g_t direction
%   - b2 is the tilt in the BY_t direction
%   - the VERTICAL gap from a point to the plane is that year's residual
% Rotate until you are looking straight down the BY axis: the plane becomes a
% line, and you are looking at the simple regression from Lecture 1.

%% BONUS 1 (not on the slide): how much does each regressor tilt the plane?
%
%  WHY THIS SECTION EXISTS. You have just DRAWN the plane; this reads it back
% out as numbers. A plane has exactly two tilts, one per regressor, and b1 and
% b2 ARE those two tilts. So this is the exercise, run in reverse.
%
%  THE PROBLEM IT SOLVES. You cannot compare b1 and b2 as they stand, because
% they are in different units: b1 is "per pp of GROWTH", b2 is "per pp of
% YIELD". Read at face value, the coefficients say the bond yield matters more:
%
%        |b2| = 1.894   >   |b1| = 1.240
%
% That reading is wrong. What is missing is how far each variable actually
% MOVES in this sample. Multiply each tilt by its observed range:

fprintf('\nPlane height range from g_t : %+.2f pp\n', beta(2)*(max(gt) -min(gt)));
fprintf('Plane height range from BY_t: %+.2f pp\n', beta(3)*(max(BYt)-min(BYt)));

%     range(g_t)  = 30.64 pp   ->   the plane moves  +38.01 pp
%     range(BY_t) =  5.17 pp   ->   the plane moves   -9.79 pp
%
%  THE RANKING REVERSES. Growth moves the plane about 3.9x as much as the yield
% does, even though its coefficient is the SMALLER of the two. A coefficient is
% a slope; what you usually want is a slope TIMES a distance. Same idea as a
% standardised ("beta") coefficient, done by hand.


%  Now the second half, which cuts the other way. -9.79pp is not nothing: it
% is about a quarter of the growth tilt and it is plainly visible on the
% surface. And yet the t-statistic on b2 is -0.93 - the same value as in
% Lecture 1, re-checked here. Not distinguishable from zero.
%
% Both things are true. A slope can look substantial on a plot and still be
% indistinguishable from noise, because the plot shows you the ESTIMATE and
% says nothing about its UNCERTAINTY. Eyeballing a fitted surface is a good
% way to understand a model and a bad way to test one.
% If you take one habit from today: never conclude from a picture alone,
% and never conclude from a p-value alone either.

%% BONUS 2 (not on the slide): partial dependence slices
%
%  WHY THIS SECTION EXISTS. A plane floating in 3D is genuinely hard to read,
% especially on a projector from the back of a room. So slice it: FIX the bond
% yield at one value and what is left is an ordinary 2D line showing the effect
% of growth. Do that at three different yields and you get three lines.
%
%  WHAT EACH LINE IS. "The effect of growth, HOLDING BOND YIELD FIXED." That
% phrase - controlling for - gets said constantly in econometrics and almost
% never drawn. This is the drawing. Each line is one slice through the surface
% you plotted three sections ago.
%
%  uses a 'for' loop - Lecture 3. Read it, do not worry about writing it yet.
by_q = quantile(BYt, [0.25 0.5 0.75]);
figure('Name','Partial dependence slices','Color','w');
for i = 1:numel(by_q)
    rhat_line = beta(1) + beta(2)*x1fit + beta(3)*by_q(i);
    plot(x1fit, rhat_line, 'LineWidth', 1.5); hold on;
end
grid on; box on;
xlabel('g_t (%)'); ylabel('Fitted r_t (%)');
title('Effect of g_t at different BY levels');
legend({'BY Q1','BY Median','BY Q3'}, 'Location','best');

%  THE PUNCHLINE: the three lines come out exactly PARALLEL. That is not
% something the data told us - it is something we imposed. The model has no
% interaction term, so the slope on growth is FORCED to be identical at every
% level of the bond yield. Changing BY can shift a line up or down; it can
% never tilt one.
%
% You can predict the gap before you run it. Between the Q1 and Q3 lines it is
%       b2 * (Q3 - Q1) = -1.894 * (4.46 - 3.00) = -2.77 pp
% and it is the same at EVERY value of g. That constancy IS the assumption,
% made visible.
%
%  THAT is why this picture is worth drawing: an assumption that is invisible
% in the equation is obvious the moment you plot it. Ask an assistant to "add
% an interaction term" and re-run - the lines will fan out instead.

disp('Demo complete: 3D regression + visualization.');
