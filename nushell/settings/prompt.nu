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

export def remote-link [] {
    let url = (branch-web-url)
    if ($url | is-empty) {
        return ''
    }

    $url | ansi link --text '[remote]'
}