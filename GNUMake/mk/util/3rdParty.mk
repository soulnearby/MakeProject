# Add thirdparty here, and enable it in self.mk

ifeq ($(__ENABLE_THIRDPARTY),1)
# CXXFLAGS += -I<include directory>
# __ELIBS  += <library, *.a>
endif