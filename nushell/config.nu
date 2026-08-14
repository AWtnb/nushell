source settings/keybindings.nu

$env.config.show_banner = false

# https://memo.laughk.org/articles/2022-11-28-nushell-config-for-wezterm/
$env.config.shell_integration = (
    $env.config.shell_integration
    | items {|k, v| {$k: false}}
    | reduce {|a, b| $a | merge $b}
)

def --env "cd.." [] {
    cd ..
}

def "code." [] {
    code .
}

def "xefm." [] {
    let desktop = ($nu.home-dir | path join "Desktop")
    if $env.PWD == $desktop {
        xefm
        return
    }
    xefm --left . --right $desktop
}


def open-url [url: string] {
    match $nu.os-info.name {
        "macos" => { ^open $url }
        "windows" => { ^cmd.exe /c start $url }
        _ => { ^xdg-open $url }
    }
}

def open-git-remote [remote: string = "origin"] {
    let target_section = $"[remote \"($remote)\"]"

    let lines = (open .git/config --raw | lines)

    mut in_section = false
    mut url = ""

    for line in $lines {
        let trimmed = ($line | str trim)

        if ($trimmed | str starts-with "[") {
            $in_section = ($trimmed == $target_section)
            continue
        }

        if $in_section and ($trimmed | str starts-with "url") {
            $url = ($trimmed | split row "=" | skip 1 | str join "=" | str trim)
            break
        }
    }

    if $url == "" {
        print $"Remote '($remote)' not found."
        return
    }

    let web_url = if ($url | str starts-with "git@") {
        $url | str replace -r '^git@([^:]+):(.*)\.git$' 'https://$1/$2'
    } else {
        $url | str replace -r '\.git$' ''
    }

    print $web_url
    open-url $web_url
}

def open-remote-repo [] {
    let repos = (gh repo list --limit 1000 --json nameWithOwner,url | from json)

    if ($repos | is-empty) {
        print "nothing found."
        return
    }

    let selected = (
        $repos
        | each { |r| $r.nameWithOwner }
        | str join "\n"
        | ^fzf
        | str trim
    )

    if $selected == "" {
        return
    }

    let url = ($repos | where nameWithOwner == $selected | get url.0)

    print $url
    open-url $url
}

# https://github.com/ajeetdsouza/zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
