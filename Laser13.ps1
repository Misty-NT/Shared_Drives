Add-Type -AssemblyName PresentationFramework

Write-Host "Checking for mapped drives F: and G..." -ForegroundColor Cyan

$results = @()
$found = $false

# Check F drive
$fDrive = Get-PSDrive -Name F -ErrorAction SilentlyContinue
if ($fDrive) {
    $results += "F: drive is mapped to $($fDrive.Root)"
    Write-Host "F: drive is mapped to $($fDrive.Root)" -ForegroundColor Yellow
    $found = $true
} else {
    Write-Host "F: drive is NOT mapped" -ForegroundColor Green
}

# Check G drive
$gDrive = Get-PSDrive -Name G -ErrorAction SilentlyContinue
if ($gDrive) {
    $results += "G: drive is mapped to $($gDrive.Root)"
    Write-Host "G: drive is mapped to $($gDrive.Root)" -ForegroundColor Yellow
    $found = $true
} else {
    Write-Host "G: drive is NOT mapped" -ForegroundColor Green
}

# ===== POPUP MESSAGE =====
if ($found) {
    $message = "A connection is already using one or both drive letters:`n`n" + ($results -join "`n")
    [System.Windows.MessageBox]::Show($message, "Drive Mapping Detected", "OK", "Warning")
} else {
    $message = "No connections found using drive letters F: or G."
    [System.Windows.MessageBox]::Show($message, "No Drive Mapping Found", "OK", "Information")
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")