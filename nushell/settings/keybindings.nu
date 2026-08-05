def fz-ghq [] {
    let selected = (ghq list | fzf);
    if ($selected | is-not-empty) {
        return (ghq root | str trim | path join $selected)
    }
}

let keybind_fuzzy_ghq = {
    name: fuzzy_ghq
    modifier: control
    keycode: char_g
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: executehostcommand
        cmd: "cd (fz-ghq)"
    }
}

# https://github.com/AWtnb/okini
def fz-okini [] {
    let selected = (okini --list | fzf);
    if ($selected | is-not-empty) {
        let path = okini --search $selected
        if ($path | is-not-empty)  {
            return $path
        }
    }
}

let keybind_fuzzy_okini = {
    name: fuzzy_okini
    modifier: control
    keycode: char_b
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: executehostcommand
        cmd: "cd (fz-okini)"
    }
}

let keybind_reload_condfig = {
    name: reload_config
    modifier: alt
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: {
        send: executehostcommand
        cmd: "source $nu.config-path"
    }
}

$env.config.keybindings = (
    $env.config.keybindings
    | prepend $keybind_reload_condfig
    | prepend $keybind_fuzzy_okini
    | prepend $keybind_fuzzy_ghq
    | uniq-by name
)