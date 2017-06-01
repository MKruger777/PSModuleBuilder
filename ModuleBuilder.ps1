
$env:modulename = "PSModuleBuilder"
$env:ModuleVersion = "1.0.0.0"
$env:Author = "Morné Kruger"
$env:ProjectRoot = Get-ScriptDirectory
$env:artifactroot =  "$env:ProjectRoot\BuildArtifacts"
$env:DeployRootDir = "c:\Program Files\WindowsPowerShell\Modules"


function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  $ExecutionPath = Split-Path $Invocation.MyCommand.Path
  return $ExecutionPath
}

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
    if ((Get-Module $env:modulename))
    {
        Write-Host "Module $env:modulename is allready loaded and will be removed ..."
        Remove-Module $env:modulename
    } 

    Import-Module -name "$env:DeployRootDir\$env:ModuleName\$env:ModuleName.psm1" -Force #orig command -RequiredVersion $env:ModuleVersion 
    Write-Host "done!" -ForegroundColor Green
}

Clean-BuildEnvironment
Build-Module
Deploy-Module
Load-Module