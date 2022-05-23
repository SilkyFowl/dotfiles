# 環境変数を最適化
$env:Path = ($env:Path -split ';' | Sort-Object -Unique) -notmatch '^$' -join ';'

# wslのエイリアス
Set-Alias ubu ubuntu

function Clear-WslCache {
    wsl -u root -d Ubuntu sysctl -w vm.drop_caches=3
    wsl -u root -d docker-desktop sysctl -w vm.drop_caches=3 
}

# Windows <-> Wsl
function Switch-DockerDemon {
    & "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon
}

# Launcher
function code-portable {
    & "$(scoop prefix vscode-portable)\code.exe"
}

# レジストリ割り当て
@(
    @{Name = 'HKCC'; PSProvider = 'Registry'; Root = 'HKEY_CURRENT_CONFIG'; }
    @{Name = 'HKCR'; PSProvider = 'Registry'; Root = 'HKEY_CLASSES_ROOT'; }
    @{Name = 'HKU'; PSProvider = 'Registry'; Root = 'HKEY_USERS'; }
).where{
    -not (Test-path "$($_.name):")
}.foreach{
    New-PSDrive @_ > $null
}

function ConvertTo-ShortPath {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        $target
    )
    $fso = New-Object -ComObject Scripting.FileSystemObject
    if (Test-Path $target -PathType Container) {
        $fso.GetFolder($target).ShortPath
    } else {
        $fso.GetFile($target).ShortPath
    }
}

Set-Alias toShortPath ConvertTo-ShortPath