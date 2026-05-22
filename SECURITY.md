# Security policy

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security concerns.

Use GitHub's private vulnerability reporting:
**[Report a vulnerability](https://github.com/MohammedEl-sayedAhmed/latex-kit/security/advisories/new)**

You'll get an acknowledgement within ~7 days. After a fix is in place,
we'll coordinate public disclosure.

## Supported versions

`latex-kit` is a template repository — only the current `main` branch is
supported. There is no patched-old-version policy; consume the latest
template state.

## Scope

In-scope: the workflow files, the devcontainer config, the Dockerfile
references, and any helper scripts under `scripts/`.

Out-of-scope: vulnerabilities in upstream dependencies (TeX Live, LaTeX
packages, Docker base images, GitHub Actions). Please report those to
their respective maintainers.
