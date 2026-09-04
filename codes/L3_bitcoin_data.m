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

% Ask the server for the MKPRU series as CSV, then tidy it inside MATLAB.
%
%  sprintf fills in a template. The two %s are placeholders, replaced IN ORDER
% by tableCode and apiKey. Building the address this way keeps the key in one
% variable instead of in the middle of a string you might read out or paste.
%
%  Read the finished URL in pieces:
%    /api/v3/datatables/   the Tables API. The older /datasets/ endpoint is a
%                          different service and answers in a different shape.
%    QDL/BCHAIN            WHICH table: publisher QDL, table BCHAIN.
%    .csv                  the format to send back. Ask for .json instead and
%                          readtable below would have nothing it can parse.
%    ?code=MKPRU           a FILTER, applied on the server. MKPRU is BCHAIN's
%                          name for MarKet PRice Usd - the average price of
%                          one bitcoin in dollars across the major exchanges.
%                          BCHAIN holds many other series (transaction counts,
%                          hash rate, fees); asking for this one code means
%                          the rest is never downloaded.
%    &api_key=...          the credential. Everything after the ? is a query
%                          string, and & is what joins one parameter to the next.
url = sprintf(['https://data.nasdaq.com/api/v3/datatables/%s.csv?', ...
               'code=MKPRU&api_key=%s'], tableCode, apiKey);

%  weboptions holds the SETTINGS for the request, kept separate from the
% address itself:
%    'Timeout',30   give up after 30 seconds. The default is 5, which a table
%                   this size can genuinely exceed on a slow connection.
%    'Accept'       the format we are willing to receive back.
%    'User-Agent'   how we identify ourselves to the server. Some servers
%                   refuse clients they do not recognise, so we claim to be
%                   an ordinary browser.
opts  = weboptions('Timeout',30,'HeaderFields',{'Accept' 'text/csv'; 'User-Agent' 'Mozilla/5.0'});

%  tempname hands back a fresh unused path in the system temp folder, a
% different one every call. We are about to write a file we do not want to
% keep, and this guarantees it cannot land on top of something of yours.
tmp   = [tempname,'.csv'];

%  websave DOWNLOADS TO A FILE and returns where it put it. Its cousin webread
% would hand you the contents as a variable instead. We want a file: readtable
% is built to read files, and a file on disk can be opened and LOOKED AT on
% the day the parsing goes wrong.
%
%  This is the line that fails when anything is wrong - no internet, rejected
% key, server down. Read the HTTP code in the error: 403 means the key was
% refused, 404 means the address is wrong, a timeout means neither.
websave(tmp, url, opts);

%  Now the file becomes a table. 'TextType','string' asks for string arrays
% rather than the older cell-of-char, which is why T.code=="MKPRU" further
% down can be written with == and just work.
T = readtable(tmp, 'TextType','string');

%  Column names arrive spelled the way the server spells them, and a name
% containing a space or a dash cannot be typed as T.name. makeValidName
% repairs them. Here they are already clean, so nothing changes today - it is
% here so the script survives the day the provider adds a column called
% 'last updated'.
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
% count. 
