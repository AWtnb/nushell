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

export def remote-link [] {
    let url = (remote-web-url)
    if ($url | is-empty) {
        return ''
    }

    $url | ansi link --text '[remote]'
}