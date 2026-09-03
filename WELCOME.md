# Welcome — before the first session

Dear all,

We start on **[DATE]** at **[TIME]** in **[ROOM]**. Please arrive with MATLAB already installed
and working — we go straight into writing code, and installing it in the room costs us most of
the first hour.

**1. Get the software**

- Go to the [Dauphine MathWorks portal](https://www.mathworks.com/academia/tah-portal/universite-paris-dauphine-31082069.html) and click **Sign in to get started**
- Create a [MathWorks account](https://mathworks.com/accesslogin/createProfile.do) **using your Dauphine
  email address** — that address is what links you to the university licence
- Download and install from the License Center
- *If that does not work:* [MyDauphine](https://my.dauphine.fr) (switch the site to English) → **Software**,
  and activate with the university key *(sent to you separately by email — please do not post it publicly)*

**2. Tick these two toolboxes during installation** ← the step people miss

When the installer asks which products to install, make sure both of these are selected:

- **Statistics and Machine Learning Toolbox**
- **Econometrics Toolbox**

Your licence covers every toolbox, but the installer only installs the ones you tick. We use
functions from both in the first session and in Assignment 1.

**3. Check it worked**

Open MATLAB, type `ver` in the Command Window, press Enter. You should see both toolboxes in
the list. If you don't, you can add them later via **Home → Add-Ons → Get Add-Ons** — no
reinstall needed.

**4. Register a free API key (needed for session 3)**

Lecture 3's assignment uses Bitcoin price data from Nasdaq Data Link. Please register a **free
API key** before then — it takes two minutes:

<https://data.nasdaq.com/databases/BCHAIN>

**Keep your key private.** Do not paste it into anything you share and do not commit it to a
public repository. If you cannot get one in time, a backup copy of the data is in
[`data/`](data/) — but try the real download first, getting data in is part of the job.

**If you get stuck:** the online version at <https://matlab.mathworks.com> works in a browser
with your MathWorks account and needs no installation. It is a perfectly good fallback for the
first session — but please still try the desktop install, as you will want it later.

**5. One more thing.** You may use AI assistants in this course. There is one condition, and we
will talk about it properly in session 1: *you must be able to explain any line you submit.*
Come with whatever tools you normally use.

No preparation is needed beyond the install. No prior programming experience is assumed — the
group will range from "never coded" to "writes Python daily", and the course is built for that.

See you on [DATE],
Julia

---

See you soon,
Julia
