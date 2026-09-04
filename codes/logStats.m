% --- File: logStats.m ---
function [lx, dlx] = logStats(x)
% Return log(x) and first difference of log(x)
lx = log(x);
dlx = diff(lx);
end
