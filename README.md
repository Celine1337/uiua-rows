<p align="center">
  <img src="assets/banner.svg" width="830" alt="uiua-rows banner">
</p>
<p align="center">
  <a href="https://github.com/Celine1337/uiua-rows/releases"><img src="assets/nav-releases.svg" alt="Releases"></a>
  <a href="https://www.uiua.org/docs"><img src="assets/nav-spec.svg" alt="Uiua docs"></a>
  <a href="LICENSE"><img src="assets/nav-mit.svg" alt="MIT"></a>
</p>

<img src="assets/section-about.svg" width="830" alt="About">

**uiua-rows** computes **numeric column statistics** from the shell, written in [Uiua](https://www.uiua.org), a stack-based array language. Point it at a file with one number per line and it prints `count`, `sum`, `mean`, `min` and `max` — the five numbers you actually want when you eyeball a column of measurements, timings or scores. Blank lines are ignored, and spaces, tabs and carriage returns are stripped before parsing, so indented columns and Windows (CRLF) files just work.

Why Uiua? Because array languages make this kind of work almost embarrassingly direct: the whole tool is a handful of reductions (`/+`, `/↧`, `/↥`) over a parsed numeric array, with no loops and no mutable state. It is a genuine, useful showcase of Uiua's tacit array style — and GitHub's Linguist still detects `.ua`, so the repo carries a real Uiua language badge.

<img src="assets/section-features.svg" width="830" alt="Features">

- **Five statistics** — `count`, `sum`, `mean`, `min`, `max`, one per line, in a fixed order that is easy to `grep`/`awk`.
- **Single-column input** — one number per line; integers, decimals, negatives and scientific notation (`1e3`) all parse.
- **Blank-line & whitespace tolerant** — empty lines are skipped; spaces, tabs and CR are stripped, so CRLF files are handled.
- **Strict errors** — a non-numeric line, an empty file, a missing file or bad usage exits non-zero with a clear message.
- **Zero dependencies** — one Uiua source file; runs on the stock `uiua` interpreter.
- **Tested** — a self-contained `test.sh` builds fixtures and asserts exit codes and exact output lines.

<img src="assets/section-stack.svg" width="830" alt="Tech stack">

<img src="assets/section-install.svg" width="830" alt="Install">

Requires the [Uiua](https://www.uiua.org) interpreter (0.19+), e.g. `cargo install uiua` or a release binary from the Uiua site.

```bash
git clone https://github.com/Celine1337/uiua-rows.git
cd uiua-rows
./build.sh                 # writes a launcher at bin/uiua-rows
./bin/uiua-rows data.txt
```

Or run the source directly, no build at all:

```bash
uiua run src/main.ua data.txt
```

<img src="assets/section-usage.svg" width="830" alt="Usage">

```bash
uiua-rows data.txt         # one number per line -> five statistics
```

```text
$ printf '1\n2\n3\n4\n5\n' > data.txt
$ uiua-rows data.txt
count 5
sum 15
mean 3
min 1
max 5
```

Decimals and negatives work too:

```text
$ printf -- '-2.5\n1.5\n4\n0.5\n' > mix.txt
$ uiua-rows mix.txt
count 4
sum 3.5
mean 0.875
min -2.5
max 4
```

Exit codes: `0` success, `1` error (bad usage, unreadable file, non-numeric line, or no numbers found).

<img src="assets/section-license.svg" width="830" alt="License">

MIT — see [LICENSE](LICENSE).