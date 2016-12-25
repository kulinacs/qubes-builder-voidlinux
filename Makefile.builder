ifeq ($(DIST),voidlinux)
     VOIDLINUX_PLUGIN_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
     DISTRIBUTION := voidlinux
     BUILDER_MAKEFILE = $(VOIDLINUX_PLUGIN_DIR)Makefile.voidlinux
     TEMPLATE_SCRIPTS = $(VOIDLINUX_PLUGIN_DIR)scripts
endif
