Import-Module .\modules\Get-CanvasApi.psm1 -Force
$nl = [System.Environment]::NewLine
$canvasURL= "https://sdhc.instructure.com" # Set to your canvas URL
$sensitiveAuth = "" # Put OAUTH token here

$info = Get-CanvasInfo -CanvasURL $canvasURL -AuthToken $sensitiveAuth

cls
Write-Host "Name: $($info.name)" -ForegroundColor Green
Write-Host "Canvas Student ID: $($info.StudentID)" -ForegroundColor Green
$nl
Write-Host "Course List" -ForegroundColor Yellow
$nl
$info.courses.keys
$nl
Write-Host "Assignments" -ForegroundColor Yellow
$nl
$page = $info.courses.GetEnumerator() | % {$_.value.assignments} | Sort-Object -Property DueDate | ConvertTo-Html
$page | Out-File .\page.html -Force
Invoke-Item .\page.html