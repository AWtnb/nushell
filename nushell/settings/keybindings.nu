
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