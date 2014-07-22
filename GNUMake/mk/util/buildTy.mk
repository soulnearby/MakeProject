ifeq ($(__BUILD_TY),debug)
CXXFLAGS += -g
CFLAGS += -g
endif

ifeq ($(__BUILD_TY),coverage)
CXXFLAGS += -g -fprofile-arcs -ftest-coverage
CFLAGS += -g -fprofile-arcs -ftest-coverage
endif

ifeq ($(__BUILD_TY),profile)
CXXFLAGS += -ltcmalloc -lprofiler
CFLAGS += -ltcmalloc -lprofiler
endif

ifeq ($(__BUILD_TY),release)
CXXFLAGS += -O3
CFLAGS += -O3
endif