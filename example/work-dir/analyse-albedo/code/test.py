#!/bin/env python

echo "This scripts demonstrate how to import local function from a directory next to the current script. This directory may be a symlink."

import myfunc
import myfunc.foo
from myfunc.foo import add
print(add(5,4))
