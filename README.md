<p align="center">
  <img src="assets/logo.svg" alt="latex-kit" width="320"/>
</p>

# latex-kit

A clone-and-go LaTeX project. Same repo compiles four ways with **zero
changes**: inside a Docker devcontainer, with a native TeX Live, on Overleaf,
and with Docker from the host.

## Start a new project

Click **"Use this template"** on GitHub, name your repo, clone it, and pick
one path below.

---

## Path A — Devcontainer (no host TeX install needed)

For when you don't want to install TeX Live on every machine you use.

**One-time per machine:** install Docker + VS Code + the
`ms-vscode-remote.remote-containers` extension.

**Then:**

```bash
git clone <your-new-repo>
cd <your-new-repo>
code .
```

VS Code shows *"Reopen in Container"* — click it. First run pulls the
`texlive/texlive:TL2025-historic` image (~1.5 GB, cached for all future
projects). Open `main.tex`, press **Ctrl+Alt+B** to build, **Ctrl+Alt+V**
to view the PDF.

---

## Path B — Native local install (faster builds, full offline)

**One-time per machine** (Linux). Installs TeX Live 2025-historic — same
release as the devcontainer and Overleaf, so all three paths produce
byte-identical PDFs. It goes into `~/texlive/2025`, so no sudo is needed
(`--scheme=full` needs ~9.4 GB):

```bash
HISTORIC=https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2025/tlnet-final
cd /tmp && wget "$HISTORIC/install-tl-unx.tar.gz"
tar -xzf install-tl-unx.tar.gz && cd install-tl-*/
perl ./install-tl --no-interaction --scheme=full -repository "$HISTORIC" -texdir "$HOME/texlive/2025"
echo 'export PATH="$HOME/texlive/2025/bin/x86_64-linux:$PATH"' >> ~/.profile
echo 'export TEX_NATIVE=1' >> ~/.profile   # scripts/tex (VS Code, make) uses this TeX Live, not Docker
# Log out + back in.
code --install-extension James-Yu.latex-workshop
```

**Per project:**

```bash
git clone <your-new-repo>
cd <your-new-repo>
code .                           # build with Ctrl+Alt+B
# or from CLI:
latexmk -pdf main.tex
```

---

## Path C — Overleaf (browser, no install)

```bash
zip -r project.zip . -x ".git/*" ".vscode/*" ".devcontainer/*" "*.aux" "*.log" "*.fls" "*.fdb_latexmk" "*.out" "*.synctex.gz" "*.toc" "main.pdf"
```

Overleaf web → **New Project → Upload Project →** drop `project.zip`.
It auto-detects `main.tex` and the `.latexmkrc`.

---

## Path D — Docker from the host (no TeX install, no container editor)

For a machine with Docker where you'd rather not install TeX Live or run VS
Code inside a container. `make` and VS Code stay on the host, and every TeX
command runs in the image named in `.texlive-image` through `scripts/tex`, as
your user (no root-owned files).

**One-time per machine** (Debian/Ubuntu):

```bash
./scripts/setup
```

It checks for and installs what's missing: `make`, Docker (usable without
sudo), the TeX Live image (~2.6 GB), and the LaTeX Workshop extension if VS
Code is installed. It asks before anything that needs sudo;
`./scripts/setup --check` only reports.

**Per project:**

```bash
make             # build main.pdf (engine and options come from .latexmkrc)
make clean       # remove aux files, keep the PDF
code .           # Ctrl+Alt+B builds through the same image
```

Other repos can use the same setup: copy `scripts/tex`, `scripts/setup` and
`.texlive-image` unchanged, and put that repo's image in `.texlive-image`.

---

## VS Code shortcuts (Paths A, B & D)

| Shortcut | Action |
|---|---|
| `Ctrl+Alt+B` | Build |
| `Ctrl+Alt+V` | View PDF in side tab |
| `Ctrl+Alt+J` | Jump from source → PDF (SyncTeX) |
| Double-click PDF | Jump from PDF → source |

Auto-build on save is enabled by default.

## CLI commands

```bash
latexmk -pdf main.tex     # build (default — pdflatex)
latexmk -xelatex main.tex # build with XeLaTeX
latexmk -c                # remove aux files (keep PDF)
latexmk -C                # remove everything except sources
```

Path D runs the same commands through Docker: `make`, `make clean`,
`make distclean`, or any TeX command as `scripts/tex <command>`.

## Layout

```
main.tex                 # entry point — edit this
sections/                # \input{}-ed parts of main.tex
  introduction.tex
  conclusion.tex
figures/                 # images for \includegraphics{...}
references.bib           # bibliography (commented-out in main.tex)
.latexmkrc               # build config (honored locally + on Overleaf)
Makefile                 # make / make clean via scripts/tex (Path D)
.texlive-image           # TeX Live image scripts/tex runs (Path D)
.devcontainer/           # Docker image config (Path A)
.vscode/                 # editor settings + recommended extensions
.github/                 # CI workflows + PR template + Dependabot
.gitignore               # ignores *.aux, *.log, the built main.pdf, etc.
assets/logo.svg          # repo logo (embedded at top of README)
scripts/                 # setup + tex (Path D), demo GIF helper
```

## CI / CD (GitHub Actions)

Three workflows ship with the template — they run automatically once the
repo is pushed to GitHub:

| Workflow | Trigger | What it does |
|---|---|---|
| **Build PDF** | every PR; pushes to `main` except docs-only (`*.md`, `assets/`) | Compiles `main.tex` inside `texlive/texlive:TL2025-historic`. Uploads `main.pdf` as a workflow artifact (download from the Actions tab). |
| **Release PDF** | tag `v*` (e.g. `git tag v1.0 && git push --tags`) | Builds and publishes a GitHub Release named after the tag, with the PDF attached. |
| **Lint LaTeX** | every PR touching `*.tex` | Runs `chktex` over all `.tex` files. Advisory — never blocks merging. |

Dependabot keeps the Action versions current (monthly checks, opens PRs).

## Customize

- **Title / author** — edit the top of `main.tex`.
- **Add a section** — drop `sections/foo.tex`, add `\input{sections/foo}` in `main.tex`.
- **Enable bibliography** — uncomment `\bibliographystyle` + `\bibliography` lines near the bottom of `main.tex`, then `\cite{key}` from `references.bib`.
- **Switch compiler** — in `.latexmkrc`: `$pdf_mode = 5;` (xelatex) or `4` (lualatex), and remove the `$pdflatex = ...` line.

## Overleaf compatibility rules

These are baked in — keep them when you add files:

- Main `.tex` stays at the project root (Overleaf requires this).
- All `\input{...}` and `\includegraphics{...}` paths are relative to the root.
- Custom `.cls` / `.sty` / fonts live inside the repo (Overleaf can't see outside).
- No build scripts at compile time — anything beyond `latexmk` goes in `.latexmkrc`.

## Contributing & security

- [CONTRIBUTING.md](CONTRIBUTING.md) — branch + PR workflow, style notes.
- [SECURITY.md](SECURITY.md) — how to report vulnerabilities privately.
- Issue templates live in [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/).

## License

[MIT](LICENSE) © Mohammed El-sayed Ahmed
