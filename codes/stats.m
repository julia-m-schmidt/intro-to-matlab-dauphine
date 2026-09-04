% --- File: stats.m ---
function [valMin,valMax,V] = stats(x)
% Basic stats of a numeric vector
valMin = min(x);
valMax = max(x);
V = var(x);
end
