#!/bin/sh

cd "$1"
exec mkdocs build --site-dir="$2"
