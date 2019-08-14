# Directory to build in
BUILD_DIR := build/
# Binaries
EXECS := a b
# Available modules (subdirs in the root dir)
MODULES := mod1 mod2 debug cxx_mod
# Targets
# Warning: reserved phony targets:
# showconf all clean purge cleanobj cleanmod cleandep cleanbin
TARGETS := tdebug release
# Additional include dirs
INCLUDE_DIRS := -I./

# see next section
TARGET_EXECS := a b
TARGET_EXECS/tdebug := a
EXEC_MODULES//a := mod1
EXEC_MODULES//b := mod2 cxx_mod
EXEC_MODULES/release/a := mod1 debug


# Per target/exec/module configuration vars
#
# VAR/TARGET/EXEC/MODULE
# Note: VAR/, VAR/target/, VAR//exec/ etc. (trailing slash) are invalid.
# The trailing slash is used in all internal vars and functions.
#
# Note: Any variable already user-set (from the command line,
#  included makefiles...) will overwrite the default.
#
# Example:
#  CFLAGS/debug  := -g
#  CFLAGS///math := -O3
#  CFLAGS/debug//math :=
#  CFLAGS/testing//math := -O2
# More specific versions take precedence
# Using the above CFLAGS definitions:
#  The 'debug' target will be compiled with $(CC) -g, except for
#  the math module, which will compiled with $(CC)
#  The math module will be compiled with $(CC) -O2 for the testing target
#  The math module will be compiled with $(CC) -O3 in the rest of cases
#
# Note: to override an implicitly 'inherited' variable, just write an empty
#  declaration. To explicitly 'inherit' a variable in a more specific version,
#  just include it in the declaration:
#    VAR/target//module := $(VAR/target) other_value
#
# The precedence rules are:
# First:  VAR/TARGET/EXEC/MODULE
#         VAR//EXEC/MODULE
#         VAR/TARGET//MODULE
#         VAR///MODULE
#         (rules for Second)
# Second: VAR/TARGET/EXEC
#         VAR//EXEC (rules for Third)
# Third:  VAR/TARGET
#         (rules for Fourth)
# Fourth: VAR

# TARGET_EXECS/t
# Execs to build for target t
# Default: $(EXECS)

# EXEC_MODULES/t/e
# Modules needed to build exec e for target t
# Default: $(MODULES)

# INCLUDE_DIRS/t/e/m
# Additional include directories. Passed literally to the compiler
# Default: -I./

# CC/t/e/m
# What program to use to generate c objects
# Default: gcc

# CXX/t/e/m
# What program to use to generate cxx objects
# Default: g++

# CPP/t/e/m
# What program to use to preprocess c/cxx files
# Default: $(CC) -E

# CFLAGS/t/e/m CXXFLAGS/t/e/m CPPFLAGS/t/e/m
# flags for $(CC), $(CXX), $(CPP) respectively
# Defaults: none

# LINK/t/e
# What program to use to generate executable
# Default: $(CXX) $^ -o $@

# LINKFLAGS/t/e
# flags for $(LINK)
# Default: none

# AR/t/e/m
# What program to use to generate .a static libs
# Default: Make default

# ARFLAGS/t/e/m
# flags for $(AR)
# Default: rcs



# Additional

# C_EXTENSIONS
# Default: C_EXTENSIONS       := c

# CXX_EXTENSIONS
# Default: CXX_EXTENSIONS     := cpp

# Check for trailing slashes in TARGETS, MODULES and EXECS?
# (no checks could cause unknown behaviour)
# Set to any value to disable checks
# OM_NOCHECK := true

# Should we (not) echo commands
OM_NOECHO := true

# Should we use colors?
# requires `echo -e`, uses ANSI escape codes
OM_COLORS := true

# Should we show what a file depends on?
# OM_DETAILED_PRINT := true
