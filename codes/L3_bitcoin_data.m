%% Course: Introduction to MATLAB Programming
%  Author: Julia M. Schmidt
%  September 2026
%  Lecture 3 - STEP 1 of the assignment: download and clean Bitcoin data
%  (slide 29)
%
%  Run this ONCE to produce bchain_MKPRU_daily.csv, then work in
%  L3_assignment_3.m. You do not need to re-download every time.
%
%  NEEDS: internet + your own free API key from
%         https://data.nasdaq.com/databases/BCHAIN
%

clear; close all; clc;

%% 0) Download BCHAIN table, then filter locally
%
%  API KEY - READ THIS FIRST.
%  You need your OWN free key. Register here, it takes two minutes:
%      https://data.nasdaq.com/databases/BCHAIN
%
%  KEEP IT OUT OF THE FILE. Put it in a separate file called nasdaq_key.m
%  containing exactly one line:
%
%      apiKey = 'your_key_here';
%
%  The .gitignore in this repo already blocks that filename, so it cannot be
%  committed by accident. This is not bureaucracy: a key pasted into a script
%  is a key you will eventually push to a public repository, and keys in
%  public repositories are found within minutes by automated scrapers.

if exist('nasdaq_key','file') == 2
    nasdaq_key;                    % defines apiKey, and is never committed
else
    apiKey = '';                   % <- last resort: paste here, do NOT commit
end

% Fail early and clearly rather than 30 seconds later with an HTTP error:
if isempty(apiKey) || any(strcmp(apiKey, {'KEY','YOUR_API_KEY','your_key_here'}))
    error(['No API key found. Create nasdaq_key.m with one line: ' ...
           'apiKey = ''your_key_here'';  (free key, two minutes: ' ...
           'https://data.nasdaq.com/databases/BCHAIN). ' ...
           'No key yet? You are not blocked - use the ready-made ' ...
           'data/bchain_MKPRU_daily.csv and go straight to ' ...
           'L3_assignment_3.m.']);
end

%  A downloaded file is a dependency you do not control. It can change,
% rate-limit, or disappear. That is why we SAVE a clean copy below and work
% from the copy: your analysis must still run next week.
tableCode = 'QDL/BCHAIN';              % BCHAIN table (Tables API)

% Pull the whole BCHAIN table as CSV, then filter inside MATLAB.
url = sprintf(['https://data.nasdaq.com/api/v3/datatables/%s.csv?', ...
               'code=MKPRU&api_key=%s'], tableCode, apiKey);

opts  = weboptions('Timeout',30,'HeaderFields',{'Accept' 'text/csv'; 'User-Agent' 'Mozilla/5.0'});
tmp   = [tempname,'.csv'];
websave(tmp, url, opts);

T = readtable(tmp, 'TextType','string');
T.Properties.VariableNames = matlab.lang.makeValidName(T.Properties.VariableNames);  % code,date,value

%% 1) CLEAN + FILTER + SAVE (DAILY)
%
%  IMPORTANT for the assignment: the downloaded table has columns
%   code | date | value
% NOT a column called MKPRU. Slide 30 says "plot d.MKPRU" - that only works
% AFTER the rename below. If you skipped this file, d.MKPRU does not exist.

% Strip quotes from code; enforce uppercase
T.code = upper(strtrim(erase(string(T.code), '"')));

% Parse dates (your preview looked ISO; handle both)
dt = strtrim(erase(string(T.date), '"'));
try
    T.date = datetime(dt,'InputFormat','yyyy-MM-dd');
catch
    T.date = datetime(dt,'InputFormat','dd-MMM-yyyy');
end

% Ensure numeric value
if ~isnumeric(T.value), T.value = str2double(string(T.value)); end

% Keep MKPRU only (should already be), sort asc
T = sortrows(T(T.code=="MKPRU",:), 'date', 'ascend');

% Drop zeros/negatives (they’re placeholders at the very start)
T = T(T.value > 0 & ~isnan(T.value), :);

% Save a clean daily CSV with just date,value
MKPRU_daily = T(:, {'date','value'});
MKPRU_daily.Properties.VariableNames = {'date','MKPRU'};
writetable(MKPRU_daily, 'bchain_MKPRU_daily.csv');
fprintf('Saved %d daily rows to bchain_MKPRU_daily.csv\n', height(MKPRU_daily));
fprintf('Range: %s .. %s\n', datestr(MKPRU_daily.date(1)), datestr(MKPRU_daily.date(end)));

%  Look at what you saved before trusting it: first date, last date, row
% count. Import, then LOOK - same habit as Lecture 1.

