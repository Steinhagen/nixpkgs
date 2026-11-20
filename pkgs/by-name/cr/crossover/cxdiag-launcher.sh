#!@shell@
# cxdiag and cxdiag64 are separate 32- and 64-bit diagnostics, but the
# package's generic wrapper puts both bitnesses' GStreamer plugin directories
# on GST_PLUGIN_SYSTEM_PATH_1_0 (for win32 bottle support). Keep only the
# matching plugins here so GStreamer does not warn about the other bitness.
export GST_PLUGIN_SYSTEM_PATH_1_0="@gstPlugins@"

exec -a "$0" "@out@/bin/.@prog@-wrapped-real" "$@"
