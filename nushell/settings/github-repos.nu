source commands.nu

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

# https://github.com/kawarimidoll/gh-q
def open-github-repo [--owner: string] {
    let target_owner = if $owner == null {
        gh api user -q .login | str trim
    } else {
        $owner
    }

    let query = '
query ($owner: String!, $endCursor: String) {
  repositoryOwner(login: $owner) {
    repositories(first: 30, after: $endCursor) {
      pageInfo { hasNextPage endCursor }
      nodes { nameWithOwner }
    }
  }
}
'

    let selected = (
        gh api graphql --paginate -F $"owner=($target_owner)" -f $"query=($query)"
            -q '.data.repositoryOwner.repositories.nodes[].nameWithOwner'
        | ^fzf
        | str trim
    )

    if $selected == "" {
        return
    }

    let url = $"https://github.com/($selected)"
    print $url
    open-url $url
}