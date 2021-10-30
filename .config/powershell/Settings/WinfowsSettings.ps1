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

# StarShipの起動
Invoke-Expression (&starship init powershell)
$starshipPrompt = (Get-Item Function:\prompt).ScriptBlock


function prompt {

    # 出力結果
    $out = [System.Text.StringBuilder]::new()


    # StarShip
    try {
        $out.Append((Invoke-Command $starshipPrompt )) > $null
    } catch {
        (Get-Process -id $PID).CommandLine 2>&1 >> Temp:/starshipPromptError.log
        Write-Error $_ 2>&1 >> Temp:/starshipPromptError.log
    }

    # 出力
    $out.ToString()
}
