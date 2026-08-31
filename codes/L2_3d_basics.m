%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 2 - 3D lines and surfaces  (slides 14-21)
%
%  HOW TO USE THIS FILE: run it ONE SECTION AT A TIME (Ctrl+Enter / Cmd+Enter).
%  Dependencies: base MATLAB only.

%% Housekeeping
clear; close all; clc;

%  TODAY'S QUESTION: a line needs PAIRS, a surface needs a GRID.
% Getting this wrong does not produce an error - it produces a picture.
% A wrong picture is much harder to notice than a wrong number.

%% ===================== PART A: A LINE IN 3D (slides 14-16) =============

x = -5:5;
y = x;                  % same length as x - required
z = (x.*y).^2;          % element-wise product, then element-wise power

fig1 = figure('Name','3D Line','Color','w');
plot3(x, y, z, 'o-','LineWidth',1.5); grid on; box on;
xlabel('x'); ylabel('y'); zlabel('z=(xy)^2');
title('plot3(x,y,z) - a LINE along x=y');
view(-20,25);

%  Count the points: 11, not 121. MATLAB paired them up element by
% element, so you only ever evaluated z at the DIAGONAL pairs
% (-5,-5), (-4,-4), ..., (5,5). The pair (-5, 5) is nowhere in this picture.
numel(z)

%  Rotate it in the figure window (the rotate3d button, or drag).
% From one angle it looks convincingly like a surface. It is a wire.

%% ===================== PART B: A SURFACE VIA meshgrid (slides 17-21) ====

x = -5:5;
y = -5:5;
[X,Y] = meshgrid(x,y);      % coordinate matrices for ALL (x,y) pairs
Z = (X.*Y).^2;

%  Look at the sizes before plotting anything:
size(x)     % 1x11  - a vector
size(X)     % 11x11 - a matrix, rows are copies of x
size(Z)     % 11x11 - one z for every (x,y) pair. 121 values, not 11.

%  The smallest possible example, to see what meshgrid actually does:
[Xs, Ys] = meshgrid([1 2 3], [10 20]);
Xs          % rows are copies of [1 2 3]
Ys          % columns are copies of [10; 20]
% Read them together, entry by entry: (1,10) (2,10) (3,10)
%                                     (1,20) (2,20) (3,20)
% Every combination, exactly once. That is the whole idea.

%% mesh vs surf
fig2 = figure('Name','3D Surface: mesh vs surf','Color','w');

subplot(1,2,1);
mesh(X,Y,Z);                          

xlabel('x'); ylabel('y'); zlabel('Z');
title('mesh(X,Y,Z)');
grid on; box on;

% - 'mesh' draws only the grid lines (a wireframe).
% - Advantage: transparent, you can see through it.
% - Useful for inspecting structure or overlaying several surfaces.

subplot(1,2,2);
surf(X,Y,Z);                         
xlabel('x'); ylabel('y'); zlabel('Z');
title('surf(X,Y,Z)');
grid on; box on;
shading interp;                       % smooth colour, removes the mesh lines
colorbar;                             % colour scale for Z

% - 'surf' fills the surface with colour patches, easier to read.
% - If 'mesh' is the skeleton, 'surf' is the tent fabric.

%% ===================== PART C: THE TRAP THAT DOES NOT ERROR =============
%  This is the most important 60 seconds of Lecture 2.
%
% In L2_2d_basics you forgot the dot on a VECTOR and MATLAB stopped you:
%     Xd^2  ->  "Incorrect dimensions for raising a matrix to a power."
%
% PREDICT: here X.*Y is 11x11. What does (X.*Y)^2 do?

Z_dotted = (X.*Y).^2;      % what we want: square each entry
Z_nodot  = (X.*Y)^2;       % forgot the dot

fprintf('Did it error?           no\n');
fprintf('Same answer?            %d\n', isequal(Z_dotted, Z_nodot));
fprintf('Z_dotted(1,1) = %g\n', Z_dotted(1,1));
fprintf('Z_nodot (1,1) = %g\n', Z_nodot(1,1));
fprintf('max |Z_dotted| = %g\n', max(abs(Z_dotted(:))));
fprintf('max |Z_nodot|  = %g\n', max(abs(Z_nodot(:))));

% NO ERROR. Because meshgrid on two vectors of equal length always returns a
% SQUARE matrix, and ^2 on a square matrix is a perfectly legal operation:
% matrix multiplication, X*X. Completely different numbers, silently.

fig3 = figure('Name','The missing dot','Color','w');
subplot(1,2,1); surf(X,Y,Z_dotted); shading interp; title('(X.*Y).^2  - correct');
xlabel('x'); ylabel('y'); colorbar;
subplot(1,2,2); surf(X,Y,Z_nodot);  shading interp; title('(X.*Y)^2  - WRONG, no error');
xlabel('x'); ylabel('y'); colorbar;

%  Both are plausible-looking surfaces. Neither MATLAB nor an assistant
% reading the code can tell you which one you meant - the code is valid either
% way. The only defence is knowing what shape your answer should be, and
% checking. Read the colorbars: one tops out at 625, the other at 2750.
%
% Note the asymmetry with the vector case: same typo, same intent, and whether
% you get a red error or a beautiful wrong picture depends only on whether
% your matrix happened to be square. That is luck, not skill.

%% ===================== PART D: VIEWING ANGLES ==========================
%  HEADS-UP: this section uses a 'for' loop, which is Lecture 3.
% Read it as English: "for each angle in this list, redraw from that angle".
% You are not expected to write this yet.

figure('Name','Views','Color','w');
surf(X,Y,Z); shading interp; colorbar;
xlabel('x'); ylabel('y'); zlabel('Z'); title('Same surface, different views');
for az = -45:30:135
    view(az, 30);
    drawnow; pause(0.4);              
end

%  Every one of those frames is the SAME data. Choosing the view angle
% is an editorial decision, exactly like choosing axis limits. When you put a
% 3D figure in a paper, you are choosing what the reader can and cannot see.

disp('Demo complete: 3D line and surface basics.');
