#!/bin/sh

MKDOCS_ROOT="$(pwd)"
export MKDOCS_ROOT

cd /_mkdocs/bin
exec gulp
