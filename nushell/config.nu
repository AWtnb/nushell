# config.nu

source settings/keybindings.nu

# https://memo.laughk.org/articles/2022-11-28-nushell-config-for-wezterm/
$env.config.shell_integration = (
    $env.config.shell_integration
    | items {|k, v| {$k: false}}
    | reduce {|a, b| $a | merge $b}
)

def --env "cd.." [] {
    cd ..
}


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


