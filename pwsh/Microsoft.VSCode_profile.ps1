. $home\Documents\PowerShell\Scripts\Invoke-Build.ArgumentCompleters.ps1

Register-EditorCommand -Name PrintProcessID -DisplayName 'Print ProcessID' -ScriptBlock {
    "Current Process ID: $PID"
}