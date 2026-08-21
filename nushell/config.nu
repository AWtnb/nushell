source settings/github-repos.nu
source settings/keybindings.nu
source settings/commands.nu

# https://github.com/nushell/nu_scripts/tree/main/modules/prompt
# https://github.com/JalonWong/nushell-prompt/blob/main/prompt.nu
source settings/prompt.nu
$env.PROMPT_COMMAND = {|| par-left-prompt [
    "dir",
    "full-git"
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

# https://github.com/ajeetdsouza/zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
