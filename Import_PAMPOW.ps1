function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}
$basescriptPath = Get-ScriptDirectory
$thisfile = $MyInvocation.MyCommand.Name 
$FIMcmdletimports = "InstallCmdlets.ps1"
$PAMPOWName = "PAMPOW"
$pampowmodule = "$PAMPOWName.psm1"
$pampowfolder = "$PAMPOWName"
<#
write-host ":::::::::::::::::::::::::::"
write-host "Scripts not yet a module.  To import copy and paste the following"
#do a get-childitem -recurse - filteype .ps1 | foreach import via script like below.
#cat all functions into one module file psm1, import via import-module
# rename files to psm1, Import-Module "$PSScriptRoot\dir\"

get-childitem -path $basescriptpath -recurse|where-object -property 'name' -like "*.ps1"|where-object -property 'name' -ne $thisfile |`
    Foreach-object {
        
		write-host ". $($_.FullName)" 
		#.($_.FullName) 
    }
	
	#>


$content = @()	
$ps1s = get-childitem -path $FilePath -recurse|where-object -property 'name' -like "*.ps1"|where-object -property 'name' -ne $thisfile # |where-object -property 'name' -ne $FIMcmdletimports
    foreach($ps1 in $ps1s) {
		$content += get-content  $ps1.FullName
		}
$content | set-content "$FilePath\$pampowmodule"
Add-content -path "$FilePath\$pampowmodule" -value "Export-ModuleMember -function `"Get-PAMPOW*`""
Add-content -path "$FilePath\$pampowmodule" -value "Export-ModuleMember -function `"Add-PAMPOW*`""
Add-content -path "$FilePath\$pampowmodule" -value "Export-ModuleMember -function `"Remove-PAMPOW*`""
[string]$dest = (($env:PSModulePath) -split ";") -like "*Documents*"

	if((Test-Path $dest) -eq 0)
		{
		mkdir $dest
		}
	if((Test-Path $dest\$pampowfolder) -eq 0)
		{
		mkdir $dest\$pampowfolder
		}
[string]$dest =  "$dest\$pampowfolder"
Copy-Item -Path "$FilePath\$pampowmodule" -destination $dest -Recurse -Force -ErrorAction Continue
import-module $pampowmodule
Get-Command -Module PAMPOW

