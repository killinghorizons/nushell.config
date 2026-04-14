export-env {
  $env.config = (
    $env.config?
    | default {}
    | upsert hooks { default {} }
    | upsert hooks.env_change { default {} }
    | upsert hooks.env_change.PWD { default [] }
  )
  let __zoxide_hooked = (
    $env.config.hooks.env_change.PWD | any { try { get __zoxide_hook } catch { false } }
  )
  if not $__zoxide_hooked {
    $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD | append {
      __zoxide_hook: true,
      code: {|_, dir| ^zoxide add -- $dir}
    })
  }
}
def --env --wrapped __zoxide_z [...rest: string] {
  let path = match $rest {
    [] => {'~'},
    [ '-' ] => {'-'},
    [ $arg ] if ($arg | path expand | path type) == 'dir' => {$arg}
    _ => {
      ^zoxide query --exclude $env.PWD -- ...$rest | str trim -r -c "\n"
    }
  }
  cd $path
}
def --env --wrapped __zoxide_zi [...rest:string] {
  cd $'(^zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
}

$env.config = {
    show_banner: false

    ls: {
        use_ls_colors: true
    }

    rm: {
        always_trash: false # always act as if -t was given. Can be overridden with -p
    }

    table: {
        mode: default # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
        index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
        show_empty: true # show 'empty list' and 'empty record' placeholders for command output
        padding: { left: 1, right: 1 } # a left right padding of each column in a table
        trim: {
            methodology: wrapping # wrapping or truncating
            wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
            truncating_suffix: "..." # A suffix used by the 'truncating' methodology
        }
        header_on_separator: false # show header text on separator/border line
        # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
    }


    error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "plaintext" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

    completions: {
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true    # set this to false to prevent auto-selecting completions when only one remains
        partial: true    # set this to false to prevent partial filling of the prompt
        algorithm: "prefix"    # prefix or fuzzy
        external: {
            enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
            max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
            completer: null # check 'carapace_completer' above as an example
        }
        use_ls_colors: true # set this to true to enable file/path/directory completions using LS_COLORS
    }
}

# $env.config.show_banner = false

# Alias

# @zoxide
alias z = __zoxide_z
alias zi = __zoxide_zi

alias cd = __zoxide_z
alias cdi = __zoxide_zi

# @profile
alias ep = config nu

# @neovim
alias nv = nvim
alias nvconf = nvim ~/AppData/Local/nvim

# @ls
alias ll = ls -l
alias cpr = cp -r
alias rmr = rm -r
alias rmrf = rm -rf


# @git
alias g = git
alias ga = git add
alias gc = git commit
alias gcm = git commit -m
alias gs = git status
alias gm = git merge
alias gp = git push

# @jumps
alias h = cd ~/
alias pp = cd ~/Projects

# @python
alias va = .venv/Scripts/activate
alias uvr = uv run
alias uvrp = uv run python
alias gg = uv run python
alias uvi = uv init
alias uva = uv add

# @winget
alias wi = winget install
alias wr = winget uninstall
alias wl = winget list
alias wu = winget upgrade

# @explorer
alias e = explorer.exe

# @zellij
alias zel = zellij
alias zellinuke = zellij delete-all-sessions --force

# @alacrity
alias alconf = nvim ~/AppData/Roaming/alacritty/alacritty.toml

# @cat
alias cat = bat

# @vscode
alias vsconfig = nvim ~/AppData/Roaming/Code/User/settings.json

# god
alias shutn = shutdown /s /t 0
alias reboot = shutdown /r /t 0
alias logout = shutdown /l /t 0

def lsd [] { ls | where type == dir }
def lsf [] { ls | where type == file }

def lsg [] { ls | sort-by type name -i | grid -c }

def --env cx [arg] { cd $arg; ls -l }
