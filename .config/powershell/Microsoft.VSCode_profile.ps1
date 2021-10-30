Register-EditorCommand -Name PrintProcessID -DisplayName 'Print ProcessID' -ScriptBlock {
    "Current Process ID: $PID"
}