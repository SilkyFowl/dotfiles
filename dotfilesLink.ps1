New-Item -it SymbolicLink -p $HOME/.config -ta $HOME/dotfiles/.config

if ($IsWindows) {
    New-Item -it SymbolicLink -p $HOME/Documents/Microsoft.VSCode_profile.ps1 -ta  $HOME/dotfiles/pwsh/Microsoft.VSCode_profile.ps1
    New-Item -it SymbolicLink -p $HOME/Documents\PowerShell\profile.ps1 -t  $HOME/dotfiles/pwsh/profile.ps1
    
    New-Item -it SymbolicLink -p $HOME/Documents/PowerShell/Settings -ta  $HOME/dotfiles/pwsh/Settings
    New-Item -it SymbolicLink -p $HOME/Documents/PowerShell/Completions -ta  $HOME/dotfiles/pwsh/Completions
}
