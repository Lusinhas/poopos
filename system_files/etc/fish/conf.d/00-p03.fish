for _p in /nix/var/nix/profiles/apps/bin \
         /nix/var/nix/profiles/default/bin \
         $HOME/.nix-profile/bin
    if test -d $_p; and not contains $_p $fish_user_paths
        fish_add_path --global --prepend $_p
    end
end
set -e _p

if test -d /nix/var/nix/profiles/apps/share
    set -gx XDG_DATA_DIRS /nix/var/nix/profiles/apps/share $XDG_DATA_DIRS
end

if set -q XDG_DATA_DIRS
    set -l deduped
    for dir in (string split : -- $XDG_DATA_DIRS)
        if test -n "$dir"; and not contains -- $dir $deduped
            set -a deduped $dir
        end
    end
    set -gx XDG_DATA_DIRS (string join : $deduped)
end

if status is-interactive
    set -g fish_greeting

    if type -q eza
        alias ls 'eza --icons'
        alias ll 'eza -l --icons --git'
        alias la 'eza -la --icons --git'
        alias lt 'eza --tree --level=2 --icons'
        alias tree 'eza --tree --icons'
    end
    type -q bat; and alias cat 'bat'
    type -q rg; and alias grep 'rg'
    type -q btop; and alias top 'btop'; and alias htop 'btop'

    type -q starship; and starship init fish | source
    type -q zoxide; and zoxide init --cmd cd fish | source
    type -q atuin; and atuin init fish | source
    type -q fzf; and fzf --fish | source

    if status is-login; and not set -q SSH_TTY; and type -q fastfetch
        fastfetch
    end
end
