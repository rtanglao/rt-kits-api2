#!/bin/bash
grep download-and-install_1 $1 | wc -l
grep privacy-and- $1 | wc -l
grep "customize;" $1 | wc -l
grep "fix-problems" $1 | wc -l
grep "tips;" $1 | wc -l
grep "bookmarks;" $1 | wc -l
grep "cookies;" $1 | wc -l
grep "tabs;" $1 | wc -l
grep "websites;" $1 | wc -l
grep "sync;" $1 | wc -l
grep "other;" $1 | wc -l