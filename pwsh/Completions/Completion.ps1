# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)

    switch (dotnet complete --position $cursorPosition "$wordToComplete") {
        Default {[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)}
    }
}

# Docker
import-Module DockerCompletion

# StarShip
Invoke-Expression (@(starship completions powershell) -join "`n")

# Github CLI
gh completion -s powershell | Join-String {
    $_ -replace " ''\)$", " ' ')" -replace "(^\s+\)\s-join\s';')", '$1 -replace ";$wordToComplete$"' -replace "(\[CompletionResult\]::new\('[\w-]+)'", '$1 '''
} -Separator "`n" | Invoke-Expression
# . C:\Users\terit\AppData\Local\Temp\ghcompBfore.ps1
# Invoke-Expression (@(gh completion -s powershell) -replace " ''\)$"," ' ')" -join "`n")


