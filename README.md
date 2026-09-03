# Introduction to MATLAB Programming

**Université Paris Dauphine-PSL** — Master Quantitative Economics · Master International Affairs and Development
Instructor: [Julia M. Schmidt](https://julia-m-schmidt.github.io/) · September 2026

Everything for the course lives here: slides, code, and a data folder in case a download fails.

---

## Why this course exists

An assistant can write every line of MATLAB in this course. You know that, and so do I.

What is scarce is **being able to tell whether the output is right.**

Next year, and in a PhD, you will not write MATLAB from scratch. You will *read* it — a Dynare
file, a replication package, a co-author's script, something an assistant produced in four
seconds. Someone has to open it and say *"this line is wrong."*

That is the skill. That is what this course certifies. AI made it more valuable, not less.

---

## Using AI in this course

> **Use whatever tools you want, on one condition: you must be able to explain any line you
> submit, and I may ask you to.**

Each assignment ends with a short **AI log** — 2–3 lines:

- what you asked
- what it got wrong
- how you found out

It is not graded. *"It got nothing wrong"* is a perfectly good answer — **if** you say how you
checked.

### Which assistant?

Whichever you like. Two notes on access, since they come up:

- **MATLAB Copilot** (built into MATLAB) is covered by the university licence, but **not** by a
  personal *Student* or *Home* licence, and it needs **R2025a or newer**. Sign in to your
  MathWorks account through the
  [Dauphine portal](https://www.mathworks.com/academia/tah-portal/universite-paris-dauphine-31082069.html)
  to link it.
- **GitHub Copilot** is unrelated to the university licence — it is free for students via
  [GitHub Education](https://education.github.com/).

Neither is required. Nothing in this course needs an assistant to complete.

---

## What's in here

| Folder | Contents |
|---|---|
| [`lecture_slides/`](lecture_slides/) | One PDF per session |
| [`codes/`](codes/) | The `.m` files we work through in class |
| [`data/`](data/) | Backup datasets, in case a download fails |

**Material is uploaded after each session, not before.** Several files ask you to predict what
a line will do before you run it, and that only works if you have not already read the answer.

---

## Before the first session

### 1. Install MATLAB

- Go to the [Dauphine MathWorks portal](https://www.mathworks.com/academia/tah-portal/universite-paris-dauphine-31082069.html) → **Sign in to get started**
- Create a [MathWorks account](https://mathworks.com/accesslogin/createProfile.do) **using your Dauphine
  email address** — that address is what links you to the university licence
- Download the installer from the License Center and run it
- *Alternative route:* [MyDauphine](https://my.dauphine.fr) (switch the site to English) → **Software**,
  which gives you the same licence via an activation key

### 2. Tick these two toolboxes during installation ← the step people miss

- **Statistics and Machine Learning Toolbox**
- **Econometrics Toolbox**

Your licence covers every toolbox, but **the installer only installs the ones you tick.** We use
both in the first session and in Assignment 1.

### 3. Check it worked

Type `ver` in the Command Window and press Enter. Both toolboxes should appear in the list. If
they don't, add them later via **Home → Add-Ons → Get Add-Ons** — no reinstall needed.

### 4. Register a free API key (needed for session 3)

Lecture 3 uses Bitcoin price data from Nasdaq Data Link. Registering takes two minutes:

**<https://data.nasdaq.com/databases/BCHAIN>**

**Keep your key private.** Do not paste it into anything you share, and do not commit it to a
public repository — including this one, if you fork it. Put it in a separate file and keep that
file out of version control (this repo's `.gitignore` already blocks the usual names).

### No installation? No problem for one session

<https://matlab.mathworks.com> runs MATLAB in a browser with your MathWorks account. It is a
fine fallback for session 1, but you will want the desktop version later.

---

## How to use the code files

Run them **one section at a time** — `Ctrl+Enter` (Windows/Linux) or `Cmd+Enter` (Mac).
Sections are separated by `%%`.

**Do not press "Run".** Several files contain lines that are *designed* to fail, so that you can
read the error and understand it. Running the whole file stops at the first one.

Two conventions in the files:

- `PREDICT` — a question. Answer it before running the line.
- A line marked as deliberately broken is deliberately broken. It is not a mistake.

**Copy-pasting code out of a PDF is unreliable.** Underscores in particular often do not
survive: `load Data_NelsonPlosser` can arrive as `load Data NelsonPlosser`, which fails with a
confusing message. Use the files in [`codes/`](codes/), or type the line out.

---

## Assessment

- **4 assignments**, one per session — started in class, finished at home
- **All four are handed in together at the end of the course.** No weekly deadline
- Each one is **a single commented `.m` file** — not a report. Your explanation goes in the comments
- **The in-class exercises are not handed in.** They are practice. Get them wrong freely
- Extra credit for thinking creatively — asking a good question of the data counts

### One rule

> **Your file must run from top to bottom on my computer.**

If it doesn't run, I can't mark it. Which means: no paths that only exist on your laptop, no
missing data files, and a seed wherever randomness matters.

Easy self-check: type `clear`, then run your file from the top. If it only works the second
time, something is wrong.

---

## Getting the files

**Just want the files?** Green **Code** button → **Download ZIP**.

**Want updates as they appear?** Clone it, then `git pull` after each session:

```bash
git clone https://github.com/julia-m-schmidt/intro-to-matlab-dauphine.git
cd intro-to-matlab-dauphine
git pull        # after each session
```

---

## Questions

Bring them to class, or email me: `julia.schmidt [at] dauphine.psl.eu`

If you're stuck on an error, paste the **full message**, not a summary of it. The message
usually names its own fix — reading it carefully is half of what this course is about.
