Set-ExecutionPolicy Bypass -Scope Process -Force

$LocalTempDir = $env:TEMP
$ChromeInstallerPath = Join-Path $LocalTempDir "chrome_installer.exe"

Invoke-WebRequest -Uri "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $ChromeInstallerPath

$process = Start-Process -FilePath $ChromeInstallerPath -ArgumentList "/silent", "/install" -PassThru
$process.WaitForExit()

Remove-Item $ChromeInstallerPath -Force -ErrorAction SilentlyContinue
