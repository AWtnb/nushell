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

let custom_bindings = [
    {
        name: fuzzy_okini
        modifier: control
        keycode: char_b
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "cd (fz-okini)"
        }
    },
    {
        name: reload_config
        modifier: alt
        keycode: char_r
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "source $nu.config-path"
        }
    },
    {
        name: insert_desktop_path
        modifier: alt
        keycode: char_i
        mode: [emacs, vi_normal, vi_insert]
        event: {
            edit: insertstring
            value: ($env.HOMEDRIVE | path join $env.HOMEPATH | path join "Desktop")
        }
    },
    {
        name: insert_pipe
        modifier: alt
        keycode: char_l
        mode: [emacs, vi_normal, vi_insert]
        event: {
            edit: insertstring
            value: "|"
        }
    },
]

$env.config.keybindings = (
    $env.config.keybindings
    | prepend $custom_bindings
    | uniq-by name
)