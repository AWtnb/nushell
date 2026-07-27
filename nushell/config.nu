# config.nu
#
# Installed by:
# version = "0.113.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# https://memo.laughk.org/articles/2022-11-28-nushell-config-for-wezterm/
$env.config.shell_integration = (
    $env.config.shell_integration
    | items {|k, v| {$k: false}}
    | reduce {|a, b| $a | merge $b}
)


def hello [] {
    "Hello, World!"
}

def fuzzy-ghq-code [] {
    let selected = (ghq list | fzf);
    if ($selected | is-not-empty) {
        code (ghq root | str trim | path join $selected)
    }
}

let keybind_fuzzy_ghq_code = {
    name: fuzzy_ghq_code
    modifier: control_shift
    keycode: char_g
    mode: [emacs, vi_normal, vi_insert]
    event: [
        {
            send: executehostcommand
            cmd: "fuzzy-ghq-code"
        }
    ]
}

let keybind_reload_condfig = {
    name: reload_config
    modifier: alt
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: [
        {
            send: executehostcommand
            cmd: "source $nu.config-path"
        }
    ]
}

$env.config.keybindings = (
    $env.config.keybindings
    | prepend $keybind_reload_condfig
    | prepend $keybind_fuzzy_ghq_code
    | uniq-by name
)

# https://github.com/ajeetdsouza/zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu

# https://www.nushell.sh/cookbook/custom_completers.html
def "nu-complete zoxide path" [context: string] {
    let parts = $context | str trim --left | split row " " | skip 1 | each { str lowercase }
    let completions = (
        ^zoxide query --list --exclude $env.PWD -- ...$parts
            | lines
            | each { |dir|
                if ($parts | length) <= 1 {
                    $dir
                } else {
                    let dir_lower = $dir | str lowercase
                    let rem_start = $parts | drop 1 | reduce --fold 0 { |part, rem_start|
                        ($dir_lower | str index-of --range $rem_start.. $part) + ($part | str length)
                    }
                    {
                        value: ($dir | str substring $rem_start..),
                        description: $dir
                    }
                }
            })
    {
        options: {
            sort: false,
            completion_algorithm: substring,
            case_sensitive: false,
        },
        completions: $completions,
    }
}

def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
  __zoxide_z ...$rest
}


