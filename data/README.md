# Data

A safety net. Most datasets in this course are either built into MATLAB or
downloaded by you — but if a download fails or an account is not ready, a copy
lands here so nobody is blocked.

| File | Used in | Normally you would |
|---|---|---|
| `WB_Data.xls` | Lecture 1 | provided |
| `NelsonPlosser.csv` | Lectures 1–2 | comes with the Econometrics Toolbox |
| `bchain_MKPRU_daily.csv` | Lecture 3 | download with your own free API key |

> Use the fallback if you need it, but **try the real download first** — getting
> data in is part of the job.

---

## If you don't have the Econometrics Toolbox

`L2_3d_exercise2.m` starts with `load Data_NelsonPlosser`, which needs the
**Econometrics Toolbox**. If `ver` doesn't list it, swap that one line for:

```matlab
T      = readtable(fullfile('..','data','NelsonPlosser.csv'));
dates  = T.Year;
Data   = T{:, 2:end};                              % 111 x 14, Year dropped
series = T.Properties.VariableNames(2:end);
```

Everything after it — the `Data(51:end,:)` sample, the column numbers on the
slide — then works unchanged.

`NelsonPlosser.csv` is exported straight from the toolbox file, so the numbers
are identical: annual 1860–1970, 111 rows x 14 series, `Year` first.

**The blank cells are real.** The series do not all start in 1860 — real GNP
begins in 1909, the bond yield in 1900. Blank reads back as `NaN`, which is
what the toolbox gives you too. Do not fill them in.

> Nelson, C. R., and C. I. Plosser (1982), "Trends Versus Random Walks in
> Macroeconomic Time Series," *Journal of Monetary Economics* 10, 139–162.
