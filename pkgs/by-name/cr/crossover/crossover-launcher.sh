#!@shell@
set -eu

# Writable per-user root; CrossOver's equivalent of Wine's WINEPREFIX.
: "${CX_DEVELOP_ROOT:=${XDG_DATA_HOME:-$HOME/.local/share}/crossover}"
export CX_DEVELOP_ROOT

# Setting CX_DEVELOP_ROOT makes CrossOver skip its own sys.path setup.
PYTHONPATH="@out@/lib/python${PYTHONPATH:+:$PYTHONPATH}"
export PYTHONPATH

# CrossOver verifies its licence by running the `openssl` command, but the
# package only ships the library. Without the binary the signature check fails
# and CrossOver falls back to demo mode.
PATH="@openssl@/bin${PATH:+:$PATH}"
export PATH

# Link the read-only install in, but keep etc/ writable for the licence/config.
mkdir -p "$CX_DEVELOP_ROOT/etc"
for entry in @out@/*; do
  name=${entry##*/}
  if [ "$name" = etc ]; then
    continue
  fi
  if [ -L "$CX_DEVELOP_ROOT/$name" ] || [ ! -e "$CX_DEVELOP_ROOT/$name" ]; then
    ln -sfn "$entry" "$CX_DEVELOP_ROOT/$name"
  fi
done

exec -a "$0" "@out@/bin/.@prog@-unwrapped" "$@"
