function spice = addChili(spice, target, caution)
%ADDCHILI  Add chili, closing part of the gap to the spice level you want.
%
%   spice = addChili(spice, target, caution)
%
%   You can always add spice to a curry. You can never take it back out.
%   So a careful cook does not jump straight to the target -- they close
%   only part of the gap, taste again, and repeat.
%
%   caution = 0.5  means "close half the remaining distance each time"
%   caution = 1.0  means "go straight there and hope"
%
%   Writing functions like this one is Lecture 4. Today you only use it.
%
%   Example:
%       addChili(0, 7, 0.5)    % -> 3.5, half way to a target spice level of 7

spice = spice + caution * (target - spice);

end
