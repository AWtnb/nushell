def fz-ghq [] {
    let selected = (ghq list | fzf);
    if ($selected | is-not-empty) {
        return (ghq root | str trim | path join $selected)
    }
}


# https://github.com/AWtnb/okini
def bm [] {
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
        name: move_word_right_ctrl_n
        modifier: control
        keycode: char_n
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: HistoryHintWordComplete
        }
    },
    {
        name: wrap_in_bracket
        modifier: none
        keycode: "char_["
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {
                edit: insertstring
                value: "[]"
            }
            { send: Left }
        ]
    },
    {
        name: wrap_in_single_quote
        modifier: shift
        keycode: "char_'"
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {
                edit: insertstring
                value: "''"
            }
            { send: Left }
        ]
    },
    {
        name: wrap_in_double_quote
        modifier: shift
        keycode: 'char_"'
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {
                edit: insertstring
                value: '""'
            }
            { send: Left }
        ]
    },
    {
        name: wrap_in_parenthesis
        modifier: shift
        keycode: "char_("
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {
                edit: insertstring
                value: "()"
            }
            { send: Left }
        ]
    },
    {
        name: fuzzy_ghq
        modifier: control
        keycode: char_g
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "cd (fz-ghq)"
        }
    },
    {
        name: fuzzy_okini
        modifier: control
        keycode: char_b
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "cd (bm)"
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
    {
        name: open_vscode
        modifier: alt
        keycode: char_v
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "code ."
        }
    },
]

$env.config.keybindings = (
    $env.config.keybindings
    | prepend $custom_bindings
    | uniq-by name
)