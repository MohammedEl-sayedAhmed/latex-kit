# Contributing to latex-kit

Thanks for your interest. Quick notes on how the template is maintained.

## Setup

Follow whichever of the three paths in [README.md](README.md) fits you:
**Devcontainer (A)**, **native TeX Live (B)**, or **Overleaf upload (C)**.

Devcontainer is the smoothest for one-off PRs — no host install needed.

## Workflow

The `main` branch is protected, so all changes go through pull requests:

1. Fork or create a branch off `main`.
2. Make your changes.
3. Push to your branch and open a PR against `main`.
4. The **Build PDF** workflow runs automatically. It must finish green.
5. The PR squash-merges (linear history is enforced).

Trivial fixes (typos, README clarifications) are fine as a one-commit PR.

## Style

- `main.tex` stays at the project root — Overleaf compatibility depends on it.
- Use paths relative to the project root in `\input{...}` /
  `\includegraphics{...}` (no `../..` traversal).
- Keep the [Overleaf compatibility rules](README.md#overleaf-compatibility-rules)
  intact when you add files.
- Commit prefix is appreciated but not required: `feat:`, `fix:`, `docs:`,
  `ci:`, `chore:`.

## Filing issues

Use the templates in [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/).
For security issues, see [SECURITY.md](SECURITY.md) instead.
