source prompt.jalon.nu

def remote-web-url [] {
    let rst = (do { git --no-optional-locks remote get-url origin } | complete)
    if $rst.exit_code != 0 {
        return ''
    }

    $rst.stdout
    | str trim
    | str replace -r '^git@([^:]+):' 'https://$1/'
    | str replace -r '^ssh://git@([^/]+)/' 'https://$1/'
    | str replace -r '\.git$' ''
}

def current-branch [] {
    let rst = (do { git --no-optional-locks branch --show-current } | complete)
    if $rst.exit_code != 0 {
        return ''
    }

    $rst.stdout | str trim
}

def branch-web-url [] {
    let url = (remote-web-url)
    if ($url | is-empty) {
        return ''
    }

    let branch = (current-branch)
    if ($branch | is-empty) {
        return $url
    }

    $'($url)/tree/($branch)'
}

def git-link [] {
    let styled = (full-git-style)
    if ($styled | is-empty) {
        return ''
    }

    let url = (branch-web-url)
    if ($url | is-empty) {
        return $styled
    }

    $url | ansi link --text $styled
}

export def custom-left-prompt [modules: list] {
    let others = ($modules | where {|name| $name != 'full-git' })
    let dir = (exec-module 'dir')
    let git = (git-link)
    let rest = (par-left-prompt $others)

    $'(ansi reset)($dir) ($git) ($rest)'
}