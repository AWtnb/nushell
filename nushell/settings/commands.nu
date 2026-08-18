def --env fz-ghq [] {
    let root = (ghq root | str trim)
    let result = (ghq list | fzf --expect="ctrl-i" | lines)

    if ($result | is-empty) {
        return
    }

    let key = ($result | first)
    let selected = ($result | skip 1 | first)

    if ($selected | is-empty) {
        return
    }

    let path = ($root | path join $selected)

    if ($key == "ctrl-i") {
        code $path
        return
    }

    cd $path
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

def open-url [url: string] {
    match $nu.os-info.name {
        "macos" => { ^open $url }
        "windows" => { ^cmd.exe /c start $url }
        _ => { ^xdg-open $url }
    }
}


def --env "cd.." [] {
    cd ..
}

def --env cdc [] {
    cd (clip paste)
}

def "code." [] {
    code .
}

def "xefm." [] {
    let desktop = ($nu.home-dir | path join "Desktop")
    mut rightPath = "."
    if $env.PWD != $desktop {
        $rightPath = $desktop
    }
    xefm --left . --right $rightPath
}

def sls [
    pattern: string
    --ignore-case(-i)
] {
    let files = $in | each { |it| if ($it | describe) == "string" { $it } else { $it.name } }
    let flags = if $ignore_case { [-i --color=always] } else { [--color=always] }

    $files
    | chunks 100
    | each { |chunk|
        let result = (do { rg ...$flags $pattern ...$chunk } | complete)
        if (0 == $result.exit_code) { $result.stdout } else { "" }
    }
    | where { |it| ("" != $it) }
    | str join ""
    | print --raw
}