<#
TODO: get list of active PAM requests
#>

Function Get-PAMPOWRequest {
	<#
	TODO: In request, map creator ID to the Privaccountname, map role ID to the role displayname
	#>
	[cmdletBinding()]
    param
    (
        [Object]$User,
        [Object]$Role,
		<#
		.PARAMETER Status
		When specified, will return the Active sessions as output
		#>
		[Parameter()]
		[ValidateSet('Active','Closed','Expired','Pending','Rejected')]
		[string[]]$Status
		
    )
	if (!$psboundparameters.containskey('User')){
					#get-pamrequest -all doesnt work. working around
					if ($psboundparameters.containskey('Status')){
					$str = "-"+$status
					$str = "Get-PAMRequest $str -User (Get-pamuser)"
					iex $str
						#then do the sourceaccountname loop below to map a whole table
						break
					}
					else{
					Get-PAMRequest -All -User (Get-PAMUser)
						#then do the sourceaccountname loop below to map a whole table
						break
					}
					
					}
				
		#test pamuser specified in function
		if ($psboundparameters.containskey('User')){
			try{
				$user = Get-PAMUser -sourceaccountname $user.SourceAccountName
				}
			Catch{
				try {$User = get-pamuser -sourceaccountname $User}
				catch {
					try{$user = get-pamuser -PrivAccountName $user}
					catch{write-error "User Not found specified by User param"
					break}
				}
				
				
				}
				
				if ($psboundparameters.containskey('Status')){
				write-host contains user and status
					$str = "-"+$status
					$str = "Get-PAMRequest $str -User (Get-pamuser)"
					iex $str
						#then do the sourceaccountname loop below to map a whole table
						break
					}
				else {
				write-host contains user but not status
				get-pamrequest -user $user
				}
					
					
		}
}