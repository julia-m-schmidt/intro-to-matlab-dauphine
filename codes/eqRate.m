% --- File: eqRate.m ---
function r = eqRate(rAnnual, period)
 % Equivalent periodic rate given annual rate rAnnual
 switch lower(string(period))
     case "monthly"
         r = (1+rAnnual)^(1/12) - 1;
     case "quarterly"
         r = (1+rAnnual)^(1/4) - 1;
     case "semiannual"
         r = (1+rAnnual)^(1/2) - 1;
     otherwise
         error('Unknown period. Use monthly|quarterly|semiannual.');
end
end