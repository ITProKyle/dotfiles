#!/usr/bin/env bash
deduped_path=$(echo -n "${PATH}" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}');
export PATH="${deduped_path}";
unset deduped_path;
