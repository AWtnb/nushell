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
    if $env.PWD == $desktop {
        xefm
        return
    }
    xefm --left . --right $desktop
}

def sls [
    pattern: string
    --ignore-case(-i)
] {
    let pat = if $ignore_case { $"(?i)($pattern)" } else { $pattern }

    $in | each { |it|
        let path = if ($it | describe) == "string" { $it } else { $it.name }

        open --raw $path
        | lines
        | enumerate
        | where item =~ $pat
        | each { |row| {file: $path, line: ($row.index + 1), text: $row.item} }
    }
    | flatten
}

# https://github.com/ajeetdsouza/zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
