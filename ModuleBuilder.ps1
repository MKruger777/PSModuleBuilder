
$env:modulename = "ClassesModule"
$env:ModuleVersion = "1.0.0.0"
$env:Author = "Morné Kruger"
$env:artifactroot = "C:\dev\PowerShell\classes\clsBuilder\BuildArtifacts"
$env:ProjectRoot = "C:\dev\PowerShell\classes\clsBuilder"
$env:DeployRootDir = "c:\Program Files\WindowsPowerShell\Modules"

function Clean-BuildEnvironment 
{
    Write-Host "Cleaning module ..."
    $lines
    #create empty folder for module build task, delete any existing data
    if (get-module $env:modulename){remove-module $env:modulename -Force}
    If (test-path "$env:artifactroot\$env:modulename") {
        Remove-Item "$env:artifactroot\$env:modulename" -Force -Recurse
    }
    new-item -Path $env:artifactroot -name $env:ModuleName -ItemType Directory | out-null
    Write-Host "done!" -ForegroundColor Green
}

function Build-Module
{
    Write-Host "Building module ..."
    $lines
    $Scripts = Get-ChildItem "$env:ProjectRoot\ModuleParts\Classes" -Filter *.ps1 -Recurse
    $FunctionstoExport = $(get-childitem "$env:ProjectRoot\ModuleParts\CmdLets").name.replace('.ps1','')
    $Scripts | get-content | out-file -FilePath "$env:artifactroot\$env:ModuleName\$env:ModuleName.psm1"
    
    copy-item "$env:projectroot\ClassesModule.psd1" "$env:artifactroot\$env:modulename\$env:modulename.psd1"
    
    #Update module manifest
    $modulemanifestdata = @{
        Author = $env:Author
        Copyright = "(c) $((get-date).Year) $env:Author. All rights reserved."
        Path = "$env:artifactroot\$env:ModuleName\$env:ModuleName.psd1"
        FunctionsToExport = $FunctionstoExport
        RootModule = "$env:ModuleName.psm1"
        ModuleVersion = $env:ModuleVersion
    }
    Update-ModuleManifest @modulemanifestdata
    Write-Host "done!" -ForegroundColor Green
}

function Deploy-Module
{
    Write-Host "Starting deploying module ..."
    If (test-path "$env:DeployRootDir\$env:modulename") 
    {
        Remove-Item "$env:DeployRootDir\$env:modulename" -Force -Recurse
    }
    Copy-Item -Path "$env:artifactroot\$env:ModuleName\" -Destination "$env:DeployRootDir\$env:modulename" -recurse -Force
    Write-Host "done!" -ForegroundColor Green
}

function Load-Module
{
    Write-Host "Loading module ..."
    $ModuleName = "ClassesModule"
    if ((Get-Module $ModuleName))
    {
        Write-Host "Module $ModuleName is allready loaded and will be removed ..."
        Remove-Module $ModuleName
    } 

    Import-Module -name "$env:DeployRootDir\$env:ModuleName\$env:ModuleName.psm1" -Force #orig command -RequiredVersion $env:ModuleVersion 
    Write-Host "done!" -ForegroundColor Green
}

Clean-BuildEnvironment
Build-Module
Deploy-Module
Load-Module