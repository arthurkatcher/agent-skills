#!/usr/bin/env bash
# Library docs via the context7 REST API. No key needed.
#   docs.sh search <query>                      -> library ids (e.g. /expressjs/express, /pallets/flask)
#   docs.sh get <library-id> <topic> [tokens]   -> focused snippets for that topic (default 2500 tokens)
# Use only when an API surface is uncertain or something fails. Read the error first.
set -e
cmd="$1"; shift || true
case "$cmd" in
  search)
    curl -s -m 15 "https://context7.com/api/v1/search?query=$(printf %s "$*" | sed 's/ /%20/g')" \
      | python3 -c 'import sys,json; [print(r["id"], "|", r["title"], "|", r.get("totalSnippets",0), "snippets") for r in json.load(sys.stdin).get("results",[])[:8]]'
    ;;
  get)
    lib="${1#/}"; topic="$2"; tokens="${3:-2500}"
    [ -n "$lib" ] && [ -n "$topic" ] || { echo "usage: docs.sh get <library-id> <topic> [tokens]"; exit 1; }
    curl -s -m 20 "https://context7.com/api/v1/${lib}?type=txt&topic=$(printf %s "$topic" | sed 's/ /%20/g')&tokens=${tokens}"
    ;;
  *) echo "usage: docs.sh search <query> | docs.sh get <library-id> <topic> [tokens]"; exit 1 ;;
esac
