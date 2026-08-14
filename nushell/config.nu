source settings/git.nu
source settings/keybindings.nu

$env.config.show_banner = false

# https://memo.laughk.org/articles/2022-11-28-nushell-config-for-wezterm/
$env.config.shell_integration = (
    $env.config.shell_integration
    | items {|k, v| {$k: false}}
    | reduce {|a, b| $a | merge $b}
)

def --env "cd.." [] {
    cd ..
}

def "code." [] {
    code .
}

def "xefm." [] {
    let desktop = ($nu.home-dir | path join "Desktop")
    if $env.PWD == $desktop {
        xefm
        return
    }
    xefm --left . --right $desktop
}



# https://github.com/ajeetdsouza/zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
