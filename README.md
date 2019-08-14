# overmake
An overly generic Makefile that is a program in it's own right.

* Should be able to build any C/C++ project with multiple source dirs.

* Tracks dependencies for each source file.

* Supports multiple executables.

* Supports multiple targets/configurations.

* Supports tuning configuration for each target/executable/source dir.

* Now with 10% more bloat!

* clang-tidy checks, and clang-format+astyle formatting!

* Prints nice tree of config!

See `config.mk` for options.

Requires GNU Make, tested under v4.2.1.
