MAKEFLAGS += -r
include config.mk
MAKEFLAGS += -r


VARS_BASE/ := BUILD_DIR EXECS MODULES TARGETS INCLUDE_DIRS TARGET_EXECS\
EXEC_MODULES INCLUDE_DIRS CC CXX CPP CFLAGS CXXFLAGS CPPFLAGS LINK LINKFLAGS\
AR ARFLAGS C_EXTENSIONS CXX_EXTENSIONS OM_NOCHECK OM_NOECHO OM_COLORS\
OM_DETAILED_PRINT 

# helper func
# 1: needle(s)
# 2: haystack
contains-any/2/ =\
$(if $(strip $(foreach n,$1,\
  $(foreach hw,$2,$(if $(subst $n,,$(hw)),,Y)))),Y,)


PHONY := $(PHONY)
PHONY += all showconf
ifeq ($(findstring showconf,$(MAKECMDGOALS)),showconf)
print/ := Y
$(foreach v,$(VARS_BASE/),$(info |$v : $($v)))
$(info )
all: showconf
else
ifeq ($(call contains-any/2/,clean purge cleanobj cleanmod cleandep cleanbin,$(MAKECMDGOALS)),Y)
all:
else
print/ :=
all: $(TARGETS)
endif
endif

include $(INC_DEPS)

# const
F/ :=
T/ := T
empty/ :=
space/ :=$(empty/) $(empty/)
tab/ :=$(empty/)	
define nl/:=


endef

# sane defaults
# TARGET_EXECS/t
TARGET_EXECS ?= $(EXECS)

# EXEC_MODULES/t/e
EXEC_MODULES ?= $(MODULES)

# INCLUDE_DIRS/t/e/m
INCLUDE_DIRS ?= -I./

# LINK/t/e
LINK ?= $(CXX) $$$$^ -o $$$$@

# LINKFLAGS/t/e
LINKFLAGS ?=$(space/)

ifeq ($(origin CC),default)
CC := gcc
endif
CC ?= gcc

ifeq ($(origin CXX),default)
CXX := g++
endif
CXX ?= g++

ifeq ($(origin CPP),default)
CPP := $(CC) -E
endif
CPP ?= $(CC) -E

ifeq ($(origin CFLAGS),default)
CFLAGS :=$(space/)
endif
CFLAGS ?=$(space/)

ifeq ($(origin CXXFLAGS),default)
CXXFLAGS :=$(space/)
endif
CXXFLAGS ?=$(space/)

ifeq ($(origin CPPFLAGS),default)
CPPFLAGS :=$(space/)
endif
CPPLAGS ?=$(space/)

ifeq ($(origin ARFLAGS),default)
ARFLAGS := rcs
endif
ARFLAGS ?= rcs

C_EXTENSIONS       ?= c
CXX_EXTENSIONS     ?= cpp




# pretty print
ifeq ($(OM_COLORS),)
print/tcol/ := $(space/)
print/ecol/ := $(space/)
print/mcol/ := $(space/)
print/ocol/ := $(space/)
print/rcol/ := $(space/)
echo_AR/    := @echo -e 'AR       $$@'
echo_CC/    := @echo -e 'CC       $$@'
echo_CXX/   := @echo -e 'CXX      $$@'
echo_GENDEP := @echo -e 'GENDEP   $$@'
echo_LINK/  := @echo -e 'LINK     $$@'
else
print/tcol/ != echo -en '\e[1;31m'
print/ecol/ != echo -en '\e[1;35m'
print/mcol/ != echo -en '\e[1;32m'
print/ocol/ != echo -en '\e[1;36m'
print/rcol/ != echo -en '\e[0m'
echo_AR/    := @echo -e 'AR       \e[1;32m$$@\e[0m'
echo_CC/    := @echo -e 'CC       \e[1;36m$$@\e[0m'
echo_CXX/   := @echo -e 'CXX      \e[1;36m$$@\e[0m'
echo_GENDEP := @echo -e 'GENDEP   \e[0;33m$$@\e[0m'
echo_LINK/  := @echo -e 'LINK     \e[1;35m$$@\e[0m'
endif

ifneq ($(OM_DETAILED_PRINT),)
echo_AR/    += '     ($$^)'
echo_CC/    += '     ($$^)'
echo_CXX/   += '     ($$^)'
echo_GENDEP += '     ($$^)'
echo_LINK/  += '     ($$^)'
endif

cmd_SILENT/ := $(if $(OM_NOECHO),@,)

#---------------------------MAKEFILE : BECOME HASKELL---------------------------
# func

# 1: string
# ret: $(T/) if empty, else $(F/)
# not/1/=$(if $1,$(F/),$(T/))

# 1: str1
# 2: str2
# ret: str1 if str1 == str2 else $(F/)
string-strip-eq/2/ =$(if $(subst $(strip $1),,$(strip $2)),$(F/),$(strip $1)) 
string-eq/2/ =$(if $(subst |$1|,,|$2|),$(F/),$1)

# 1: dir
# 2: wildcard
rwildcard/2/ =$(strip\
$(foreach d,\
  $(wildcard $1*),\
  $(call rwildcard/2/,$d/,$2) $(filter $(subst *,%,$2),$d)))

# Delete trailing slash
del_trel_slash/1/ = $(1:%/=%)

# Delete trailing slashes
del_trel_slashes/1/ =\
$(or\
  $(call string-eq/2/,$(call del_trel_slash/1/,$1),$1),\
  $(call del_trel_slashes/1/,$(call del_trel_slash/1/,$1)))

# ret $1 | error and abort
bind-join-var/1/ =\
$(or\
  $($1),\
  $(if $(call string-strip-eq/2/,undefined,$(origin $($1))),\
    $($1),\
    $(error Could not bind var '$1$2')))

# ret $(1/2) | (rules for 1)
bind-join-var/2/ =\
$(or\
  $($(call del_trel_slashes/1/,$1/$2)),\
  $(call bind-join-var/1/,$1,/$2$3))

# ret $(1/2/3) | $(1//3) (rules for 2)
bind-join-var/3/ =\
$(or\
  $($(call del_trel_slashes/1/,$1/$2/$3)),\
  $($(call del_trel_slashes/1/,$1//$3)),\
  $(call bind-join-var/2/,$1,$2,/$3$4))

# ret $(1/2/3/4) | $(1//3/4) | $(1/2//4 1///4) | (rules for 3)
bind-join-var/4/ =\
$(or\
  $($(call del_trel_slashes/1/,$1/$2/$3/$4)),\
  $($(call del_trel_slashes/1/,$1//$3/$4)),\
  $($(call del_trel_slashes/1/,$1/$2//$4)),\
  $($(call del_trel_slashes/1/,$1///$4)),\
  $(call bind-join-var/3/,$1,$2,$3,/$4$5))

# ret $(1/2/3/4/5) | $(1//3/4/5) | $(1/2//4/5) | $(1///4/5) | $(1/2/3//5)
#     | $(1//3//5) | $(1/2///5) | $(1////5) | (rules for 4)
bind-join-var/5/ =\
$(or\
  $($(call del_trel_slashes/1/,$1/$2/$3/$4/$5)),\
  $($(call del_trel_slashes/1/,$1//$3/$4/$5)),\
  $($(call del_trel_slashes/1/,$1/$2//$4/$5)),\
  $($(call del_trel_slashes/1/,$1///$4/$5)),\
  $($(call del_trel_slashes/1/,$1/$2/$3//$5)),\
  $($(call del_trel_slashes/1/,$1//$3//$5)),\
  $($(call del_trel_slashes/1/,$1/$2///$5)),\
  $($(call del_trel_slashes/1/,$1////$5)),\
  $(call bind-join-var/4/,$1,$2,$3,$4,/$5))


# 1: val
# 2: name
# ret: $(F/) if ok, else error and abort
enoslash/2/ = \
$(if $(strip $(call string-strip-eq/2/,$(subst /,,$1),$1)),$(F/),\
  $(error Value in '$2' contains a slash: '$1'))

# check
ifeq ($(OM_NOCHECK),)
$(foreach t,$(TARGETS),$(call enoslash/2/,$t,TARGETS))
$(foreach e,$(EXECS),$(call enoslash/2/,$e,EXECS))
$(foreach m,$(MODULES),$(call enoslash/2/,$m,MODULES))
endif
#------------DECLARATIVE MAKEFILES ARE BORING EMBRACE THE FUNCTIONS------------#

#--------------MY MAKEFILE HAS MORE GENERICS THAN POB RIKE'S BABY--------------#
# build/procedures

# Generate rules for target
# 1: target
define B_TARGET/1/ =
$(if $(print/),$(info * Target '$(print/tcol/)$1$(print/rcol/)')\
  $(foreach v,$(VARS_BASE/),$(if $($v/$1),\
  $(info $(space/)   |$v : $($v/$1)))))
$(eval target_execs/ := $(call bind-join-var/2/,TARGET_EXECS,$1))
$(eval PHONY += $1)
$(eval $1 : $(target_execs/:%=$(BUILD_DIR)$1/%) | $(BUILD_DIR)$1/)
$(eval $(BUILD_DIR)$1/ : ;mkdir -p $$@)
$(foreach e,$(target_execs/),\
  $(call B_EXEC/2/,$1,$e))
$(if $(print/),$(info ))
endef

# Generate rules for exec
# 1: target
# 2: exec
define B_EXEC/2/ =
$(if $(print/),$(info $(space/)     Exec\
'$(print/ecol/)$(BUILD_DIR)$1/$2$(print/rcol/)')\
  $(foreach v,$(VARS_BASE/),$(if $($v/$1/$2),\
  $(info $(space/)       |$v : $($v/$1/$2)))))
$(eval exec_modules/ := $(call bind-join-var/3/,EXEC_MODULES,$1,$2))
$(eval linkflags/ := $(call bind-join-var/3/,LINKFLAGS,$1,$2))
$(eval link/ := $(call bind-join-var/3/,LINK,$1,$2))
$(eval dest_dir/ := $(BUILD_DIR)$1/)
$(eval generated_bin/ += $(dest_dir/)$2)
$(eval $(dest_dir/)$2 : $(exec_modules/:%=$(BUILD_DIR)$1/%.a)\
  | $(dest_dir/)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(echo_LINK/)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(link/) $(linkflags/)\
  )
$(foreach m,$(exec_modules/),\
  $(call B_MODULE/3/,$t,$e,$m))
endef

# Generate rules for module
# 1: target
# 2: exec
# 3: module
define B_MODULE/3/ =
$(if $(print/),$(info $(space/)         Module\
'$(print/mcol/)$(BUILD_DIR)$1/$3.a$(print/rcol/)')\
  $(foreach v,$(VARS_BASE/),$(if $($v/$1/$2/$3),\
  $(info $(space/)           |$v : $($v/$1/$2/$3)))))
$(eval c_srcs/ := $(foreach ext,$(C_EXTENSIONS),$(call rwildcard/2/,$3/,*.$(ext))))
$(eval cxx_srcs/ := $(foreach ext,$(CXX_EXTENSIONS),$(call rwildcard/2/,$3/,*.$(ext))))
$(eval ar/ := $(call bind-join-var/4/,AR,$1,$2,$3))
$(eval arflags/ := $(call bind-join-var/4/,ARFLAGS,$1,$2,$3))
$(eval dest_dir/ := $(BUILD_DIR)$1/)
$(eval generated_mod/ += $(dest_dir/)$3.a)
$(eval $(dest_dir/)$3.a : $(c_srcs/:%=$(BUILD_DIR)$1/%.o)\
  $(cxx_srcs/:%=$(BUILD_DIR)$1/%.o)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(echo_AR/)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(ar/) $(arflags/) $$@ $$?)
$(foreach f,$(c_srcs/),\
  $(call B_OBJ_C/4/,$1,$2,$3,$f))
$(foreach f,$(cxx_srcs/),\
  $(call B_OBJ_CXX/4/,$1,$2,$3,$f))
endef

# Generate rules for C Objects
# 1: target
# 2: exec
# 3: module
# 4: file
define B_OBJ_C/4/ =
$(if $(print/),$(info $(space/)             OBJ\
'$(print/ocol/)$(BUILD_DIR)$1/$4.o$(print/rcol/)'))
$(eval cc/ := $(call bind-join-var/4/,CC,$1,$2,$3))
$(eval cppflags/ := $(call bind-join-var/4/,CPPFLAGS,$1,$2,$3))
$(eval cflags/ := $(call bind-join-var/4/,CFLAGS,$1,$2,$3))
$(eval inc_dirs/ := $(call bind-join-var/4/,INCLUDE_DIRS,$1,$2,$3))
$(eval dest_dir/ := $(BUILD_DIR)$1/$(dir $4))
$(eval generated_obj/ += $(BUILD_DIR)$1/$4.o)
$(eval $(BUILD_DIR)$1/$4.o : $4 $(BUILD_DIR)$1/$4.d | $(dest_dir/)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(echo_CC/)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(cc/) $(cflags/) $(cppflags/) $(inc_dirs/) -c -o $$@ $$<$(nl/)\
)
$(call B_OBJ_C/XX_GENDEP/4/,$1,$2,$3,$4)
endef

# Generate rules for CXX Objects
# 1: target
# 2: exec
# 3: module
# 4: file
define B_OBJ_CXX/4/ =
$(if $(print/),$(info $(space/)             OBJ '$(BUILD_DIR)$1/$4.o'))
$(eval cxx/ := $(call bind-join-var/4/,CXX,$1,$2,$3))
$(eval cppflags/ := $(call bind-join-var/4/,CPPFLAGS,$1,$2,$3))
$(eval cxxflags/ := $(call bind-join-var/4/,CXXFLAGS,$1,$2,$3))
$(eval inc_dirs/ := $(call bind-join-var/4/,INCLUDE_DIRS,$1,$2,$3))
$(eval dest_dir/ := $(BUILD_DIR)$1/$(dir $4))
$(eval generated_obj/ += $(BUILD_DIR)$1/$4.o)
$(eval $(BUILD_DIR)$1/$4.o : $4 $(BUILD_DIR)$1/$4.d | $(dest_dir/)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(echo_CXX/)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(cxx/) $(cxxflags/) $(cppflags/) $(inc_dirs/) -c -o $$@ $$<$(nl/)\
)
$(call B_OBJ_C/XX_GENDEP/4/,$1,$2,$3,$4)
endef

# Generate rules for dependency creation
# 1: target
# 2: exec
# 3: module
# 4: file
define B_OBJ_C/XX_GENDEP/4/ =
$(eval cpp/ := $(call bind-join-var/4/,CPP,$1,$2,$3))
$(eval cppflags/ := $(call bind-join-var/4/,CPPFLAGS,$1,$2,$3))
$(eval inc_dirs/ := $(call bind-join-var/4/,INCLUDE_DIRS,$1,$2,$3))
$(eval dest_dir/ := $(BUILD_DIR)$1/$(dir $4))
$(eval generated_dep/ += $(BUILD_DIR)$1/$4.d)
$(eval INC_DEPS/$1/ += $(BUILD_DIR)$1/$4.d)
$(eval $(BUILD_DIR)$1/$4.d : $4 | $(dest_dir/)$(nl/)$(tab/)\
  $(echo_GENDEP)$(nl/)$(tab/)\
  $(cmd_SILENT/)$(cpp/) $(cppflags/) $(inc_dirs/) -MM -MF $$@ -MQ $$@ -MQ $$(@:.d=.o) $$<\
  )
endef

# init build
$(foreach t,$(TARGETS),\
  $(call B_TARGET/1/,$t))

$(BUILD_DIR) : ; @mkdir -p $@
$(BUILD_DIR)%/ : ; @mkdir -p $@

ifeq ($(MAKECMDGOALS),)
include $(foreach t,$(TARGETS),$(INC_DEPS/$t/))
else
ifneq ($(call contains-any/2/,clean purge cleanobj cleanmod cleandep cleanbin,$(MAKECMDGOALS)),Y)
# Shitty heuristic but it works
include $(foreach g,$(MAKECMDGOALS),\
  $(INC_DEPS/$(strip $(foreach t,$(TARGETS),\
    $(call string-strip-eq/2/,\
      $(patsubst $(BUILD_DIR)$t%,$t,$g),\
      $t)))/))
endif
endif

PHONY += clean purge cleanobj cleanmod cleandep cleanbin

cleandep:
	$(foreach d,$(generated_dep/),$(RM) $d$(nl/)$(tab/))

cleanobj:
	$(foreach o,$(generated_obj/),$(RM) $o$(nl/)$(tab/))

cleanmod:
	$(foreach m,$(generated_mod/),$(RM) $m$(nl/)$(tab/))

cleanbin:
	$(foreach m,$(generated_bin/),$(RM) $m$(nl/)$(tab/))

clean: cleandep cleanobj cleanmod cleanbin

# Did you just assume my OS
purge:
	rm -rf $(BUILD_DIR)

.PHONY : $(PHONY)
