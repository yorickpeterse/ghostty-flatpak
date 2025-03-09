#!/usr/bin/env fish

set archive "ghostty-source.tar.gz"
set dir ghostty-source
set url 'https://github.com/ghostty-org/ghostty/releases/download/tip/ghostty-source.tar.gz'
set lock "build.zig.zon2json-lock"

mkdir -p tmp

if ! test -d "tmp/$dir"
    cd tmp
    curl --location --output "$archive" "$url"
    tar -xf "$archive"
    cd ..
end

cd "tmp/$dir"

set deps (
    cat "$lock" |
    jq --raw-output 'keys[] as $k | .[$k] | ($k + " " + .name + " " + .url)' |
    sort -k 2,2
)

for line in $deps
    echo $line | read hash name url

    if string match --regex --quiet '^git\+http' $url
        echo $url | string sub --start 5 | read --delimiter '#' url ref
        set url (string replace --regex '\/\?ref=.+' '' $url)

        echo "- name: $name-$ref"
        echo "  type: git"
        echo "  url: $url"
        echo "  commit: $ref"
        echo "  dest: ghostty/vendor/p/$hash"
    else
        if ! test -f "$hash.dep"
            curl --silent --fail --show-error --location "$url" --output "$hash.dep"
        end

        set sha (sha256sum "$hash.dep"| awk '{print $1}')

        echo "- name: $name"
        echo "  type: archive"
        echo "  url: $url"
        echo "  sha256: $sha"
        echo "  dest: ghostty/vendor/p/$hash"
    end
end
