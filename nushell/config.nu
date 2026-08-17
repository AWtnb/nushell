source settings/git.nu
source settings/keybindings.nu

# https://github.com/JalonWong/nushell-prompt/blob/main/prompt.nu
source settings/prompt.nu
$env.PROMPT_COMMAND = {|| par-left-prompt [
    'dir',
    'full-git'
    'duration',
]}
$env.PROMPT_INDICATOR = {|| "" }
$env.PROMPT_COMMAND_RIGHT = {|| "" }

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
    mut rightPath = "."
    if $env.PWD != $desktop {
        $rightPath = $desktop
    }
    xefm --left . --right $rightPath
}

def sls [
    pattern: string
    --ignore-case(-i)
] {
    let files = $in | each { |it| if ($it | describe) == "string" { $it } else { $it.name } }

    if $ignore_case {
        rg -i $pattern ...$files
    } else {
        rg $pattern ...$files
    }
}

# https://github.com/ajeetdsouza/zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
