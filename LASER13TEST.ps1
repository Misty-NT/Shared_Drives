Add-Type -AssemblyName PresentationFramework

$drive = "F:"
$newPath = "\\AT-FS1\FDrive"
$username = "Accutech\misty"

Write-Host "Checking F: drive..." -ForegroundColor Cyan

# Check existing mapping
$existing = cmd /c "net use" | Where-Object { $_ -match "F:" }

if ($existing) {
    $message = "F: is already mapped.`n`n$existing`n`nDo you want to replace it with:`n$newPath ?"
    $result = [System.Windows.MessageBox]::Show($message, "Drive Already In Use", "YesNo", "Warning")

    if ($result -ne "Yes") {
        Write-Host "User chose not to overwrite. Exiting..." -ForegroundColor Red
        return
    }

    net use $drive /delete /yes | Out-Null
    Start-Sleep -Seconds 1
}

# ===== PASSWORD PROMPT ONLY =====
$securePassword = Read-Host "Enter password for $username" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
$password = $credential.GetNetworkCredential().Password

Write-Host "Mapping F: drive..." -ForegroundColor Cyan

# Map drive
$mapResult = cmd /c "net use $drive $newPath /user:$username $password /persistent:yes"

Write-Host $mapResult

# Verify mapping
$verify = cmd /c "net use" | Where-Object { $_ -match "F:" }

if ($verify) {
    Write-Host "SUCCESS: F: mapped." -ForegroundColor Green

    [System.Windows.MessageBox]::Show(
        "F: drive successfully mapped to $newPath",
        "Success",
        "OK",
        "Information"
    ) | Out-Null
}
else {
    Write-Host "FAILED: Drive did not map." -ForegroundColor Red

    [System.Windows.MessageBox]::Show(
        "Drive mapping failed.`n`n$mapResult",
        "Error",
        "OK",
        "Error"
    ) | Out-Null
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")