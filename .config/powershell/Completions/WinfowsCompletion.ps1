# Docker
import-Module DockerCompletion

# StarShip
Invoke-Expression (@(starship completions powershell) -join "`n")

# Github CLI
gh completion -s powershell | Join-String {
    $_ -replace " ''\)$", " ' ')" -replace "(^\s+\)\s-join\s';')", '$1 -replace ";$wordToComplete$"' -replace "(\[CompletionResult\]::new\('[\w-]+)'", '$1 '''
} -Separator "`n" | Invoke-Expression
