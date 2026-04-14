$env.PROMPT_COMMAND = { ||
    let dir = ($env.PWD | str replace $env.USERPROFILE "~")
    let reset = (ansi reset)

    $"(ansi red_bold)[($dir)] (ansi blue_bold)λ "
}
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
