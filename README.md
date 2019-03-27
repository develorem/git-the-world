# git-the-world
Powershell script you run from a directory, and it will recursively navigate all child folders to find git repositories, and perform the required operations (fetch, pull, status, etc).

## Usage

gittheworld.ps1 \[action\] \[path\]

Examples:

gittheworld.ps1 fetch c:\source
gittheworld.ps1 pull "c:\source"
gittheworld.ps1 "checkout -b newbranch" c:\source
