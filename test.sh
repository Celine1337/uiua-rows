#!/usr/bin/env bash
# Self-contained test suite for uiua-rows. Requires only the uiua interpreter.
set -uo pipefail
cd "$(dirname "$0")"
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
command -v uiua >/dev/null 2>&1 || { echo "FAIL: uiua not found on PATH"; exit 1; }
./build.sh >/dev/null
ROWS="./bin/uiua-rows"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0
ok(){ pass=$((pass+1)); }
bad(){ fail=$((fail+1)); echo "FAIL: $1"; }
# assert exit code and an output substring
check(){ # name expected_exit expected_substring actual_exit actual_out
  local name="$1" want_rc="$2" want="$3" rc="$4" out="$5"
  if [ "$rc" != "$want_rc" ]; then bad "$name (exit $rc, want $want_rc)"; return; fi
  if [ -n "$want" ] && ! printf '%s' "$out" | grep -qF -- "$want"; then
    bad "$name (output missing '$want')"; return
  fi
  ok
}
# assert an exact output line is present
line(){ # name expected_line actual_out
  if printf '%s\n' "$3" | grep -qxF -- "$2"; then ok; else bad "$1 (no exact line '$2')"; fi
}

printf '1\n2\n3\n4\n5\n' > "$TMP/n5.txt"
out=$($ROWS "$TMP/n5.txt"); rc=$?
check "1..5 runs" 0 "count 5" "$rc" "$out"
line "count is 5" "count 5" "$out"
line "sum is 15" "sum 15" "$out"
line "mean is 3" "mean 3" "$out"
line "min is 1" "min 1" "$out"
line "max is 5" "max 5" "$out"
[ "$out" = "$(printf 'count 5\nsum 15\nmean 3\nmin 1\nmax 5')" ] && ok || bad "full report matches"

printf -- '-2.5\n1.5\n4\n\n0.5\n' > "$TMP/mix.txt"
out=$($ROWS "$TMP/mix.txt"); rc=$?
check "negatives/decimals run" 0 "count 4" "$rc" "$out"
line "decimal sum" "sum 3.5" "$out"
line "decimal mean" "mean 0.875" "$out"
line "negative min" "min -2.5" "$out"
line "decimal max" "max 4" "$out"

printf '\n\n3\n \n\t\n7\n\n' > "$TMP/blank.txt"
out=$($ROWS "$TMP/blank.txt"); rc=$?
check "blank lines ignored" 0 "count 2" "$rc" "$out"
line "blank-line sum" "sum 10" "$out"

printf '1\r\n2\r\n3\r\n' > "$TMP/crlf.txt"
out=$($ROWS "$TMP/crlf.txt"); rc=$?
check "CRLF handled" 0 "count 3" "$rc" "$out"
line "CRLF sum" "sum 6" "$out"

printf '42\n' > "$TMP/one.txt"
out=$($ROWS "$TMP/one.txt"); rc=$?
check "single value runs" 0 "count 1" "$rc" "$out"
line "single mean" "mean 42" "$out"
line "single min=max" "min 42" "$out"

out=$($ROWS 2>&1); rc=$?
check "no args errors" 1 "usage: uiua-rows" "$rc" "$out"

out=$($ROWS "$TMP/nonexistent.txt" 2>&1); rc=$?
check "missing file errors" 1 "" "$rc" "$out"

printf '1\nabc\n' > "$TMP/bad.txt"
out=$($ROWS "$TMP/bad.txt" 2>&1); rc=$?
check "non-numeric errors" 1 "" "$rc" "$out"

: > "$TMP/empty.txt"
out=$($ROWS "$TMP/empty.txt" 2>&1); rc=$?
check "empty file errors" 1 "no numbers in file" "$rc" "$out"

echo "----------------------------------------"
echo "uiua-rows: $pass passed, $fail failed"
[ "$fail" -eq 0 ] && echo "ALL CHECKS PASSED" || exit 1