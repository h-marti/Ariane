Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class ActiveWindows {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@

$a = [ActiveWindows]::GetForegroundWindow()
Get-Process | Where-Object { $_.mainwindowhandle -eq $a } | Stop-Process