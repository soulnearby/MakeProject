# Global Env-Var : __BUILD_DIR
__BUILD_TY         = $(shell basename $(__BUILD_DIR))
__COMPONENT_DIR    = $(shell dirname  $(shell dirname $(__BUILD_DIR)))
__COMPONENT_NAME   = $(shell basename $(__COMPONENT_DIR))
__ROOT             = $(shell dirname  $(__COMPONENT_DIR))

include $(__COMPONENT_DIR)/obj/self.mk

all : 
	@$(MAKE) -C $(__BUILD_DIR) -f $(__ROOT)/GNUMake/mk/apps.mk all

apps :
	@$(MAKE) -C $(__BUILD_DIR) -f $(__ROOT)/GNUMake/mk/apps.mk apps

lib :
	@$(MAKE) -C $(__BUILD_DIR) -f $(__ROOT)/GNUMake/mk/apps.mk lib
 
clean :
	@find $(__BUILD_DIR)/../ -name "*.deps" | xargs rm -rf;
	@find $(__BUILD_DIR) -name "*.d" -o -name "*.o" -o -name "*.a" -o -name "*.exe" -o -name "*.gcda" -o -name "*.gcno" | xargs rm -rf
	@echo -e "\033[32;49;1m[Clean] $(__COMPONENT_NAME)\033[39;49;0m"

cleans :
	@for c in $(__COMPONENT_DEPS); \
	do \
		find $(__ROOT)/$$c/obj/ -name "*.deps" | xargs rm -rf; \
		find $(__ROOT)/$$c/obj/$(__BUILD_TY) -name "*.d" -o -name "*.o" -o -name "*.a" -o -name "*.exe" -o -name "*.gcda" -o -name "*.gcno" | xargs rm -rf ; \
		echo -e "\033[32;49;1m[Clean] $$c\033[39;49;0m" ; \
	done;

.PHONY : all apps lib clean cleans
