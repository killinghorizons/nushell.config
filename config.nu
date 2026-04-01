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

$env.config.show_banner = false
# Alias

# @zoxide
alias z = __zoxide_z
alias zi = __zoxide_zi

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
alias gs = git status
alias gm = git merge

# @jumps
alias h = cd ~/
alias pp = cd ~/Projects

# @python
alias va = .venv/Scripts/activate

def lsd [] { ls | where type == dir }
def lsf [] { ls | where type == file }

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
