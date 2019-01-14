if(-not (Get-PSSnapin | Where-Object {$_.Name -eq 'FIMAutomation'})) 
{
	try 
	{
		Add-PSSnapin FIMAutomation -ErrorAction SilentlyContinue -ErrorVariable err		
	}
	catch 
	{
	}

	if ($err) 
    {
    	if($err[0].ToString() -imatch "has already been added") 
		{
			Write-Verbose "FIMAutomation snap-in has already been loaded." 
		}
		else
		{
			Write-Error "FIMAutomation snap-in could not be loaded." 
		}
	}
	else
	{
		Write-Verbose "FIMAutomation snap-in loaded successfully." 
	}
}

Import-Module "C:\Program Files\Microsoft Forefront Identity Manager\2010\Service\Microsoft.ResourceManagement.Automation.dll"
Import-Module FimPowerShell.psm1

Import-Module "C:\Program Files\Microsoft Forefront Identity Manager\2010\Service\PAM\PowerShell\Modules\MIMPAM\MIMPAM.psd1"