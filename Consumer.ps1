
using module "C:\Program Files\WindowsPowerShell\Modules\ClassesModule\ClassesModule.psm1"

$Dehlia = [Person]::new("Hotsaus", 32);
Write-Host $Dehlia.Greet(); 

$Maple = [Tree]::new('Maple', 10);
$Pine = [Tree]::new('Pine', 50);
$Birk = [Tree]::new('Birk', 20);

Write-Host  "Name = "$Maple.Species
Write-Host  "Name = "$Pine.Species
Write-Host  "Name = "$Birk.Species 

$Server = [Server]::new();
Write-Host  $Server.Start();
Write-Host  $Server.Stop();
