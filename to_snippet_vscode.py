#!/usr/bin/env python

import re

boundary_space_re = re.compile(r'^\s+')

lout = []

for line in open("snippet_in.txt"):
    line = line.strip("\n")
    search = boundary_space_re.search(line)
    rep = ''

    if search:
        for r in range(len(search.group()) - 1):
            rep += r'  '  # one tab length

    line = line.strip().replace('\\', '\\\\').replace(
        '"', '\\"'
    ).replace('$', '\\\\$')

    lout.append('"' + rep + line + '"')

body = '[\n' + ',\n'.join(lout) + '\n]'

prefix = """
{
  "name": {
    "prefix": [""],
    "body": %s,
    "description": ""
  }
}
""".strip()
open("snippet_out.json", "w").write(prefix % body)
