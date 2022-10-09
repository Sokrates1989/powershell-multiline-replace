Set-Location "C:\Path\to\powershell-multiline-replace\test"

$file_names = (Get-ChildItem).Name

$oldCode = [Regex]::Escape(@"
    
    <TextView
        android:layout_weight="1"
        android:layout_width="wrap_content"
        android:layout_height="0dp"/>
"@) -replace ( '((\\ )|(\\t))+' , '\s+' ) -replace ( '(\\r)?\\n' , '\r?\n' )


$newCode = @"

    AnythingNew
    
    <TextView
        android:layout_weight="1"
        android:layout_width="wrap_content"
        android:layout_height="0dp"/>
"@

foreach ($name in $file_names)
{
    # After adding -replace ( '((\\ )|(\\t))+' , '\s+' ) -replace ( '(\\r)?\\n' , '\r?\n' ) the code works.

    # Attempt 1: trying to find the code
    Write-Host $name
    $ret_string = (Get-Content -raw -Path $name | Select-String $oldCode -AllMatches | % { $_.matches}).count
    Write-Host $ret_string

    # Attempt 2: trying to actually replace the string
    $fileContent = Get-Content $name -Raw
    Write-Host $fileContent
    $newFileContent = $fileContent -replace $oldCode, $newCode
    Write-Host $newFileContent

    # Attempt 3: another try to replace the string
    ((Get-Content -Path $name -Raw) -replace $oldCode, $newCode) | Set-Content -Path $name

    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")