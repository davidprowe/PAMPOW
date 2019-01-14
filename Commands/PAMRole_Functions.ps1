function GET-PAMPOWRoleCandidates{
	#shows "memberof" roles where "rolename" is similar to memberof.  Reminds me of get-aduser -identity NAME -properties memberof
	#if you list a single role in the displayname parameter, it shows the members of that role/group
	param(
	[string]$DisplayName,
	[string]$Session,
	[string]$Active


	)
	$roles = get-pamrole
	if ($psboundparameters.containskey('DisplayName')){
			foreach ($role in $roles){
				if($role.displayname -like "$DisplayName"){
				#$role
				   
				$candobject = @()
				foreach ($candidate in $role.candidates){
				
				$candobject += New-Object PSObject -Property @{
				RoleName = $role.displayname
				SourceAccountname = $candidate.sourceaccountname
				SourceDisplayname = $candidate.sourcedisplayname
				SourceAccountSID = $candidate.sourceaccountsid
				SourceDomain = $candidate.sourcedomain
				SourceUserResourceId = $candidate.SourceUserResourceId
				PrivAccountName = $candidate.PrivAccountName
				PrivUserPrincipalName = $candidate.PrivUserPrincipalName
				PrivDisplayName = $candidate.PrivDisplayName
				PrivAccountSID = $candidate.PrivAccountSID
				PrivAccountActive = $candidate.PrivAccountActive
				PrivUserResourceId = $candidate.PrivUserResourceId
				PrivOnly = $candidate.PrivOnly
				
				
				}
				
				
				
				}
				
				$candobject
				}
				}

		
		}


}

Function Get-PAMPOWRolesForUser {
	#lists  users and maps the roles they are in
	param (
	[string]$SourceDisplayname,
	[string]$PrivUserPrincipalName,
	[string]$PrivAccountSID,
	[String]$SourceAccountName,
	[String]$PrivAccountName
	)
	$psboundparameter
	$roles = get-pamrole
	$RolesforUser = @()
	#if no parameters specified
				if ($psboundparameters.count -eq 0){
					
					$users= get-pamuser
						
						foreach ($Role in $roles){
						foreach ($user in $users){
						#then do the sourceaccountname loop below to map a whole table
						
					if ($role.candidates.SourceAccountName -contains $user.sourceaccountname){
					$RolesforUser += New-Object PSObject -Property @{
							PAMUser = $user.SourceAccountName
							Role = $role.displayname
					}
					
					}
				
				
				}
						
						}
				#$rolesforuser |sort PamUser,Role
				
				}
	
	
	
	
	if ($psboundparameters.containskey('SourceDisplayName')){
		
		foreach ($Role in $roles){
		if ($role.candidates.sourcedisplayname -contains $sourcedisplayname){
		#$role.displayname
		
		$RolesforUser += New-Object PSObject -Property @{
				PAMUser = $sourcedisplayname
				Role = $role.displayname
				#to add: privaccountactive $true $false
		
		}
		
		}
	
	
	}
	}
	
	if ($psboundparameters.containskey('SourceAccountName')){
		
		foreach ($Role in $roles){
		if ($role.candidates.SourceAccountName -contains $SourceAccountName){
		$RolesforUser += New-Object PSObject -Property @{
				PAMUser = $SourceAccountName
				Role = $role.displayname
		}
		
		}
	
	
	}
	}
	$RolesforUser |sort PamUser,Role
	


}

function Remove-PAMPOWMRoleFromUser
{
    [cmdletBinding()]
    param
    (
        [Object]
        [Parameter(Mandatory=$true)]
        $User,
        [Object]
        [Parameter(Mandatory=$true)]
        $Role
    )
    $Candidates = $PAMRole.Candidates
    $CandidateList = @()
	#test pamuser specified in function
	try{
		Get-PAMUser -sourceaccountname $user.SourceAccountName
		}
	Catch{
		try {$User = get-pamuser -sourceaccountname $User}
		catch {
			try{$user = get-pamuser -PrivAccountName $user}
			catch{write-error "User Not found specified by User param"
			break}
		}
		
		
		}
	#test pamrole specified in function	
	try{
		get-pamrole -displayname $role.displayname}
	catch{
		$Role = get-pamrole -displayname $role
		
			if($role.count -eq 0){
			write-error "No Role found specified by role parameter"
			exit}
	}
		
    foreach($Candidate in $Candidates)
    {
        if ($Candidate.PrivUserResourceId -ne $User.PrivUserResourceId)
        {
            $CandidateList += $Candidate
        }
    }
    Set-PAMRole -Role $Role -Candidates $CandidateList | Out-Null
}

function Add-PAMPOWRoleToUser
{
    [cmdletBinding()]
    param
    (
        [Object]
        [Parameter(Mandatory=$true)]
        $User,
        [Object]
        [Parameter(Mandatory=$true)]
        $Role
    )
	#test pamuser specified in function
	try{
		Get-PAMUser -sourceaccountname $user.SourceAccountName
		}
	Catch{
		try {$User = get-pamuser -sourceaccountname $User}
		catch {
			try{$user = get-pamuser -PrivAccountName $user}
			catch{write-error "User Not found specified by User param"
			break}
		}
		
		
		}
	#test pamrole specified in function	
	try{
		get-pamrole -displayname $role.displayname}
	catch{
		$Role = get-pamrole -displayname $role
			if($role.count -eq 0){
			write-error "No Role found specified by role parameter"
			break}
	}
	
    $Candidates = $PAMRole.Candidates + $PAMUser
    Set-PAMRole -Role $PAMRole -Candidates $Candidates | Out-Null
}


















