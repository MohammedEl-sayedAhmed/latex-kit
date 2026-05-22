# Recording the README demo GIF

Step-by-step for capturing the "clone → reopen in container → build" flow.
Resulting GIF goes at `assets/demo.gif` and is embedded at the top of the
README.

Requirements: Linux desktop with GNOME (Wayland or X11), Docker installed,
VS Code with the *Dev Containers* extension.

## 1. Prep (do once, before recording)

```bash
# Pre-pull the texlive image so the recording skips the 5-min download
docker pull texlive/texlive:TL2025-historic

# Wipe any leftover demo clone so the recording shows a fresh `git clone`
rm -rf ~/Repos/latex-kit-demo

# Optional: close unrelated windows, set a clean desktop background
# Resize your terminal to roughly 1100x600 (looks good as a 900px-wide GIF)
```

## 2. Start the screen recorder

GNOME 46+ built-in recorder, no install needed:

1. Press **`Print Screen`** (or `Ctrl+Alt+Shift+R`).
2. Floating screenshot bar appears at the bottom. Click the **camcorder
   icon** (right side, next to the camera).
3. Click **Selection** (region) or **Screen** (full).
4. Click the big **Record** button.

The recording starts immediately; a red dot appears in the top status bar.
There's no hard length limit on GNOME 46+.

## 3. The shot list (aim for 30-60 seconds total)

Run these in a terminal at a deliberate pace — viewers should be able to
read each command before the next one fires.

```bash
git clone https://github.com/MohammedEl-sayedAhmed/latex-kit.git latex-kit-demo
cd latex-kit-demo
code .
```

Then in VS Code:

1. Toast appears: *"Folder contains a Dev Container configuration"* →
   click **Reopen in Container**.
2. Wait ~5–15 sec for the container to attach. Bottom-left status bar
   shows `Dev Container: LaTeX (TeX Live 2025)` in green when ready.
3. In the Explorer panel, click **`main.tex`**.
4. Press **`Ctrl+Alt+B`** to build (~2-3 sec).
5. Press **`Ctrl+Alt+V`** to open the PDF in a side tab.

## 4. Stop the recording

Click the red dot in the top status bar. The recording auto-saves to
`~/Videos/Screencasts/Screencast from <timestamp>.webm`.

## 5. Convert to an optimized GIF

```bash
cd ~/Repos/latex-kit

# Glob picks up the most recent screencast; quote the path if needed
./scripts/make-demo-gif.sh ~/Videos/Screencasts/Screencast\ from*.webm

# Or pass an explicit path:
# ./scripts/make-demo-gif.sh "~/Videos/Screencasts/Screencast from 2026-05-23.webm" assets/demo.gif 900
```

The script does a two-pass `ffmpeg` palette-generation, drops fps to 12,
scales to 900px wide. Output lands at `assets/demo.gif`. Expect 1-3 MB.

If the GIF is over ~10 MB (GitHub README will be sluggish):

- Shorten the recording (re-record, keep under 60 s)
- Lower the width: `./scripts/make-demo-gif.sh <input> assets/demo.gif 700`
- Or lower the fps in `make-demo-gif.sh` (change `fps=12` to `fps=10`)

## 6. Embed in the README + push

Add this right under the logo block at the top of `README.md`:

```markdown
<p align="center">
  <img src="assets/demo.gif" alt="latex-kit demo: clone → devcontainer → build" width="900"/>
</p>
```

Then:

```bash
git add assets/demo.gif README.md
git commit -m "docs: add demo GIF showing clone → devcontainer → build flow"
git push origin main
```

## Re-record any time

Everything is idempotent — re-run the steps and the new GIF overwrites
`assets/demo.gif`. The README reference doesn't change.
