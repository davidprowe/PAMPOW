function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}
$basescriptPath = Get-ScriptDirectory
$thisfile = $MyInvocation.MyCommand.Name 


#do a get-childitem -recurse - filteype .ps1 | foreach import via script like below.
get-childitem -path $basescriptpath -recurse|where-object -property 'name' -like "*.ps1"|where-object -property 'name' -ne $thisfile |`
    Foreach-object {
        .($_.FullName) 
    }

	
Add-PSSnapin FIMAutomation -ErrorAction SilentlyContinue -ErrorVariable err		
Import-Module "C:\Program Files\Microsoft Forefront Identity Manager\2010\Service\Microsoft.ResourceManagement.Automation.dll"
Import-Module FimPowerShell.psm1
Import-Module "C:\Program Files\Microsoft Forefront Identity Manager\2010\Service\PAM\PowerShell\Modules\MIMPAM\MIMPAM.psd1"
