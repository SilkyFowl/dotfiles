using namespace Microsoft.PowerShell

# # https://qiita.com/AWtnb/items/5551fcc762ed2ad92a81#履歴管理
Set-PSReadlineOption -HistoryNoDuplicates

# # https://qiita.com/AWtnb/items/5551fcc762ed2ad92a81#単語区切り
Set-PSReadLineOption -WordDelimiters ";:,.[]{}()/\|^&*-=+'`" !?@#$%&_<>「」（）『』『』［］、，。：；／`u{2015}`u{2013}`u{2014}"


Set-PSReadLineKeyHandler -Key "`"", "'" -BriefDescription "smartQuotation" -LongDescription "Put quotation marks and move the cursor between them or put marks around the selection" -ScriptBlock {
    param($key, $arg)
    $mark = $key.KeyChar

    $selectionStart = $null
    $selectionLength = $null
    [PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
    $line = $null
    $cursor = $null
    [PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($selectionStart -ne -1) {
        [PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $mark + $line.SubString($selectionStart, $selectionLength) + $mark)
        [PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
        return
    }

    if ($line[$cursor] -eq $mark) {
        [PSConsoleReadLine]::SetCursorPosition($cursor + 1)
        return
    }

    $nMark = [regex]::Matches($line, $mark).Count
    if ($nMark % 2 -eq 1) {
        [PSConsoleReadLine]::Insert($mark)
    } else {
        [PSConsoleReadLine]::Insert($mark + $mark)
        [PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        [PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
}

Set-PSReadLineKeyHandler -Key "alt+w" -BriefDescription "WrapLineByParenthesis" -LongDescription "Wrap the entire line and move the cursor after the closing parenthesis or wrap selected string" -ScriptBlock {
    $selectionStart = $null
    $selectionLength = $null
    [PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
    $line = $null
    $cursor = $null
    [PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($selectionStart -ne -1) {
        [PSConsoleReadLine]::Replace($selectionStart, $selectionLength, "(" + $line.SubString($selectionStart, $selectionLength) + ")")
        [PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    } else {
        [PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
        [PSConsoleReadLine]::EndOfLine()
    }
}

Remove-PSReadlineKeyHandler "tab"
Set-PSReadLineKeyHandler -Key "tab" -BriefDescription "smartNextCompletion" -LongDescription "insert closing parenthesis in forward completion of method" -ScriptBlock {
    [PSConsoleReadLine]::TabCompleteNext()
    $line = $null
    $cursor = $null
    [PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[($cursor - 1)] -eq "(") {
        if ($line[$cursor] -ne ")") {
            [PSConsoleReadLine]::Insert(")")
            [PSConsoleReadLine]::BackwardChar()
        }
    }
}


Remove-PSReadlineKeyHandler "shift+tab"
Set-PSReadLineKeyHandler -Key "shift+tab" -BriefDescription "smartPreviousCompletion" -LongDescription "insert closing parenthesis in backward completion of method" -ScriptBlock {
    [PSConsoleReadLine]::TabCompletePrevious()
    $line = $null
    $cursor = $null
    [PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[($cursor - 1)] -eq "(") {
        if ($line[$cursor] -ne ")") {
            [PSConsoleReadLine]::Insert(")")
            [PSConsoleReadLine]::BackwardChar()
        }
    }
}
#endregion


# プロファイルの再読み込み
Set-PSReadLineKeyHandler -Key "alt+r" -BriefDescription "reloadPROFILE" -LongDescription "reloadPROFILE" -ScriptBlock {
    [PSConsoleReadLine]::RevertLine()
    [PSConsoleReadLine]::Insert('<#SKIPHISTORY#> . $PROFILE')
    [PSConsoleReadLine]::AcceptLine()
}

# # 直前に使用した変数を利用する
Set-PSReadLineKeyHandler -Key "alt+a" -BriefDescription "yankLastArgAsVariable" -LongDescription "yankLastArgAsVariable" -ScriptBlock {
    [PSConsoleReadLine]::Insert("$")
    [PSConsoleReadLine]::YankLastArg()
    $line = $null
    $cursor = $null
    [PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($line -match '\$\$') {
        $newLine = $line -replace '\$\$', "$"
        [PSConsoleReadLine]::Replace(0, $line.Length, $newLine)
    }
}

# # クリップボード内容を変数に格納する
Set-PSReadLineKeyHandler -Key "ctrl+V" -BriefDescription "setClipString" -LongDescription "setClipString" -ScriptBlock {
    $command = "<#SKIPHISTORY#> get-clipboard | sv CLIPPING"
    [PSConsoleReadLine]::RevertLine()
    [PSConsoleReadLine]::Insert($command)
    [PSConsoleReadLine]::AddToHistory('$CLIPPING ')
    [PSConsoleReadLine]::AcceptLine()
}

# Predictation関連
if ($PSVersionTable.PSVersion -ge '7.2.0-preview') {
    Set-PSReadLineOption -PredictionSource History
} else {
    Set-PSReadLineOption -PredictionSource History
}
if ([Console]::WindowHeight -ge 15 -and [Console]::WindowWidth -ge 54) {
   # Set-PSReadLineOption -PredictionViewStyle ListView
} else {
   # Set-PSReadLineOption -PredictionViewStyle InlineView
}
Set-PSReadLineOption -Colors @{InlinePrediction = [ConsoleColor]::DarkBlue }

Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function ForwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+b" -Function BackwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo
Set-PSReadLineKeyHandler -Key Ctrl+UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+DownArrow -Function HistorySearchForward

# キャプチャ
Set-PSReadLineKeyHandler -Key Alt+c -Function CaptureScreen

# スクロール
Set-PSReadLineKeyHandler -Key PageDown -Function ScrollDisplayDown
Set-PSReadLineKeyHandler -Key PageUp -Function ScrollDisplayUp
Set-PSReadLineKeyHandler -Key Ctrl+PageDown -Function ScrollDisplayDownLine
Set-PSReadLineKeyHandler -Key Ctrl+PageUp -Function ScrollDisplayUpLine
Set-PSReadLineKeyHandler -Key End -Function ScrollDisplayToCursor
Set-PSReadLineKeyHandler -Key Home -Function ScrollDisplayTop
# Windows Terminalの場合
if (Test-Path env:\WT_SESSION) {
    Set-PSReadLineKeyHandler -Key PageDown -Function ScrollDisplayDown
    Set-PSReadLineKeyHandler -Key PageUp -Function ScrollDisplayUp
    # Set-PSReadLineKeyHandler -Key Ctrl+PageDown -BriefDescription ScrollDisplayDownLineA -ScriptBlock {
    #     $Host.UI.Write("`e[1S`eI")
    # }
    # Set-PSReadLineKeyHandler -Key Ctrl+PageUp -BriefDescription ScrollDisplayUpLineA -ScriptBlock {

    #     $Host.UI.Write("`e[HUpdate!!`e[1T`eI")
    # }
    Set-PSReadLineKeyHandler -Key End -Function ScrollDisplayToCursor
    Set-PSReadLineKeyHandler -Key Home -Function ScrollDisplayTop
}
