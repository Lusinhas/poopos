_apps="/nix/var/nix/profiles/apps"
if [ -d "${_apps}/bin" ]; then
    case ":${PATH}:" in
        *":${_apps}/bin:"*) ;;
        *) PATH="${_apps}/bin:${PATH}" ;;
    esac
    export PATH

    XDG_DATA_DIRS="${_apps}/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
fi
unset _apps

if [ -n "${XDG_DATA_DIRS:-}" ]; then
    XDG_DATA_DIRS=$(printf '%s' "$XDG_DATA_DIRS" | awk -v RS=: '$0 != "" && !seen[$0]++ { printf "%s%s", sep, $0; sep=":" }')
    export XDG_DATA_DIRS
fi
