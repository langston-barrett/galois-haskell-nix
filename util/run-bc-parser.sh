#!/usr/bin/env bash


f="${1%.*}"

echo "Disassembling $f..."
ls "$f"
llvm-disasm "$f"
if ! llvm-disasm "$f" &> "$f.log"; then
  if ! grep "not implemented" "$f.log" &> /dev/null; then
      echo "FAILURE: $f"
      grep -C 10 'from:' "$f.log" || cat "$f.log"

      llvm-dis "$f"
      llvm-bcanalyzer -dump "$f" > "$f.xml"
  else
    rm "$f.log"
  fi
else
  rm "$f.log"
fi
