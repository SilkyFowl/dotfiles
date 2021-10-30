New-Item -it SymbolicLink -p $HOME/.config -ta $HOME/dotfiles/.config

if ($IsWindows) {
    New-Item -it SymbolicLink -p $HOME/Documents/PowerShell/profile.ps1 -ta  $HOME/dotfiles/.config/powershell/profile.ps1
    New-Item -it SymbolicLink -p $HOME/Documents/PowerShell/Microsoft.VSCode_profile.ps1 -ta  $HOME/dotfiles/.config/powershell/Microsoft.VSCode_profile.ps1
    
    New-Item -it SymbolicLink -p $HOME/Documents/PowerShell/Settings -ta  $HOME/dotfiles/.config/powershell/Settings
    New-Item -it SymbolicLink -p $HOME/Documents/PowerShell/Completions -ta  $HOME/dotfiles/.config/powershell/Completions
}
