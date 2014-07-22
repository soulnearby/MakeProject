# __BUILD_TY can be : debug | release | coverage | profile
__BUILD_TY         = $(shell basename $(__BUILD_DIR))
__COMPONENT_DIR    = $(shell dirname  $(shell dirname $(__BUILD_DIR)))
__COMPONENT_NAME   = $(shell basename $(__COMPONENT_DIR))
# __ROOT is the directory which contains all the components
__ROOT             = $(shell dirname  $(__COMPONENT_DIR))

# __LIB_CC_FULLNAME : all source files except files in .../src
__LIB_CC_FULLNAME  = $(shell find $(__COMPONENT_DIR)/src/ -mindepth 2 -name *.cc -o -name *.c)
__LIB_CC_BASENAME  = $(shell for f in $(__LIB_CC_FULLNAME); do basename $$f; done;)
__LIB_DEPS         = $(__LIB_CC_BASENAME:.cc=.d)
__LIB_DEPS        := $(__LIB_DEPS:.c=.d)
__LIB_OBJS         = $(__LIB_CC_BASENAME:.cc=.o)
__LIB_OBJS        := $(__LIB_OBJS:.c=.o)

# __MAIN_CC_FULLNAME : all source files in .../src
__MAIN_CC_FULLNAME = $(shell find $(__COMPONENT_DIR)/src/ -maxdepth 1 -name *.cc -o -name *.c)
__MAIN_CC_BASENAME = $(shell for f in $(__MAIN_CC_FULLNAME); do basename $$f; done;)
__MAIN_DEPS        = $(__MAIN_CC_BASENAME:.cc=.d)
__MAIN_DEPS       := $(__MAIN_DEPS:.c=.d)
__MAIN_OBJS        = $(__MAIN_CC_BASENAME:.cc=.o)
__MAIN_OBJS       := $(__MIAN_OBJS:.c=.o)
__MAIN_APPS        = $(__MAIN_CC_BASENAME:.cc=.exe)
__MAIN_APPS       := $(__MAIN_APPS:.c=.exe)

# $(__COMPONENT_DEPS) is defined in self.mk
__COMPONENT_DEPS_UNIQUE = $(shell echo $(__COMPONENT_DEPS) | awk 'BEGIN{RS="\n| "}!a[$$0]++')
# __INCLUDE_PATH : all directories in .../src of $(__COMPONENT_DEPS_UNIQUE), except 'CVS'
__INCLUDE_PATH     = $(shell find $(addprefix $(__ROOT)/,$(addsuffix /src/,$(__COMPONENT_DEPS_UNIQUE))) -type d -not -name CVS)

# __LIBS : all libraries used in [LN] stage
__LIBS   += $(foreach c,$(__COMPONENT_DEPS),$(__ROOT)/$(c)/obj/$(__BUILD_TY)/$(c).a)

CXXFLAGS += $(addprefix -I,$(__INCLUDE_PATH))
CFLAGS   += $(addprefix -I,$(__INCLUDE_PATH))
# $(VPATH) is used for make system, resolving the prerequisites
VPATH    += $(__INCLUDE_PATH)

