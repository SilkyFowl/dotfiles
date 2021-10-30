
# VScode拡張機能ホストか判定
$parentProcess = (Get-Process -id $PID).Parent
$shouldReadProfile = $parentProcess.ProcessName -notmatch "Code" -or
$parentProcess.CommandLine -notmatch "--type=extensionHost"
if (-not $shouldReadProfile) {
    # $PROFILE読込不要なプロセスなら処理終了
    exit
}

#region Github

function Get-GithubIssueContent {
    param (
        [parameter(Mandatory,ValueFromPipeline)][uri]$URI
    )
    $i = Invoke-RestMethod "https://api.github.com/repos$($URI.PathAndQuery)"

    $sb = [System.Text.StringBuilder]::new()

    [void]$sb.Append( @"
# $($i.title)

$($i.user.login)

## Body

$($i.body)

## Comments

"@ )
    $(switch ( [math]::Floor($i.comments / 30) ) {
            0 { , 1 }
            1 { 1, 2 }
            2 { 1..3 }
            Default {
                1, $_, $_ + 1
            }
        }
    ) | ForEach-Object {
        (Invoke-RestMethod  $i.comments_url -b @{page = $_ }).GetEnumerator()
    } | ForEach-Object {
        [void]$sb.AppendLine("### $($_.user.login)`n`n$($_.created_at)`n`n$($_.body)`n")
    }
    $sb.ToString() | Set-Clipboard
}

#region 

if ($IsWindows) {
    . $PSScriptRoot/Settings/WinfowsSettings.ps1
}

# PsReadLine 設定
. $PSScriptRoot/Settings/PsReadLine.ps1

# 補完の設定
. $PSScriptRoot/Completions/Completion.ps1

