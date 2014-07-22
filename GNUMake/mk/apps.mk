__APP_MK_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
# $(__COMPONENT_DEPS) is defined in self.mk
include $(__BUILD_DIR)/../self.mk
include $(__APP_MK_DIR)/util/vars.mk
include $(__APP_MK_DIR)/util/buildTy.mk
include $(__APP_MK_DIR)/util/3rdParty.mk

__MK_DEPS = $(__BUILD_DIR)/Makefile $(__BUILD_DIR)/../self.mk \
            $(__APP_MK_DIR)/util/vars.mk $(__APP_MK_DIR)/util/buildTy.mk $(__APP_MK_DIR)/util/3rdParty.mk \
            $(__APP_MK_DIR)/apps.mk $(__APP_MK_DIR)/common.mk

__PHONY_LIBS = $(addsuffix .plibs,$(__COMPONENT_DEPS_UNIQUE))
all : $(__PHONY_LIBS)
	@$(MAKE) -C $(__BUILD_DIR) apps
# using "%.plibs", for parallel for all related components
%.plibs :
	@$(MAKE) -C $(__ROOT)/$(subst .plibs,,$@)/obj/$(__BUILD_TY) lib

__ARCHIVE    = $(__BUILD_DIR)/$(__COMPONENT_NAME).a
lib : $(__ARCHIVE) 
$(__ARCHIVE) : $(__LIB_OBJS) $(__MK_DEPS)
	@echo -e "\033[32;49;1m[AR]  $@\033[39;49;0m"; \
	rm -f $@; \
	ar rcs $@ $^;

# $(__MAIN_APPS) is "xx.exe"
apps : $(__MAIN_APPS)
# using "%.exe", for parallel
%.exe : %.o $(__LIBS) $(__MK_DEPS)
	@echo -e "\033[32;49;1m[LN]  $@\033[39;49;0m";
	@$(CXX) $(CXXFLAGS) -o $@ $< $(__LIBS) $(__ELIBS)

# include dependency files, contain lines as : "xx.o xx.d : xx.cc xx.hh"
-include $(__LIB_DEPS)
-include $(__MAIN_DEPS)

# "set -e" : shell will exit immediately if the cmd fails.
# "-MM" : This omits prerequisites on system header files.
# "sed ..." : (xx.o : xx.cc xx.hh) ==> (xx.o xx.d : xx.cc xx.hh)
%.d: %.cc $(__MK_DEPS)
	@echo -e "\033[32;49;1m[DEP] [$(__COMPONENT_NAME)] $@\033[39;49;0m"
	@set -e; \
	$(CXX) $(CXXFLAGS) -MM $< | \
	sed 's,\(.*\)\.o[ :]*,\1.o $@ : ,g' > $@;

%.d: %.c $(__MK_DEPS)
	@echo -e "\033[32;49;1m[DEP] [$(__COMPONENT_NAME)] $@\033[39;49;0m"
	@set -e; \
	$(CC) $(CFLAGS) -MM $< | \
	sed 's,\(.*\)\.o[ :]*,\1.o $@ : ,g' > $@;

%.o: %.cc $(__MK_DEPS)
	@echo -e "\033[32;49;1m[CXX] [$(__COMPONENT_NAME)] $@\033[39;49;0m"
	@set -e; \
	$(CXX) $(CXXFLAGS) -c -o $@ $<;

%.o: %.c $(__MK_DEPS)
	@echo -e "\033[32;49;1m[CC]  [$(__COMPONENT_NAME)] $@\033[39;49;0m"
	@set -e; \
	$(CC) $(CFLAGS) -c -o $@ $<;	

.PHONY : apps lib apps

