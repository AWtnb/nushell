source commands.nu

def open-git-remotes [--owner: string] {
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
        gh api graphql --paginate -F $"owner=($target_owner)" -f $"query=($query)" -q '.data.repositoryOwner.repositories.nodes[].nameWithOwner' err> nul
      | ^fzf --multi
      | lines
      | each { |line| $line | str trim }
      | where {|line| $line != "" }
    )

    if ($selected | is-empty) {
        return
    }

    for repo in $selected {
      let url = $"https://github.com/($repo)"
      print $url
      open-url $url
    }
}