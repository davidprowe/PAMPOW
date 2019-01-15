function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}
$basescriptPath = Get-ScriptDirectory
$thisfile = $MyInvocation.MyCommand.Name 
write-host ":::::::::::::::::::::::::::"
write-host "Scripts not yet a module.  To import copy and paste the following"
#do a get-childitem -recurse - filteype .ps1 | foreach import via script like below.
get-childitem -path $basescriptpath -recurse|where-object -property 'name' -like "*.ps1"|where-object -property 'name' -ne $thisfile |`
    Foreach-object {
        
		write-host ". $($_.FullName)" 
		#.($_.FullName) 
    }

	
