source commands.nu

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
        name: insert_glob_pattern
        modifier: alt
        keycode: "char_:"
        mode: [emacs, vi_normal, vi_insert]
        event: {
            edit: insertstring
            value: "**/*"
        }
    }
    {
        name: fuzzy_ghq
        modifier: control
        keycode: char_g
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "fz-ghq"
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
            value: ($env.HOMEDRIVE | path join $env.HOMEPATH | path join "Desktop\\")
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