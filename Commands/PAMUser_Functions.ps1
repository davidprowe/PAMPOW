function Remove-PAMPOWUserFromRole
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
			exit}
	}
	
	$Candidates = $Role.Candidates
    $CandidateList = @()
		
    foreach($Candidate in $Candidates)
    {
        if ($Candidate.PrivUserResourceId -ne $User.PrivUserResourceId)
        {
            $CandidateList += $Candidate
        }
    }
    Set-PAMRole -Role $Role -Candidates $CandidateList | Out-Null
}

function Add-PAMPOWUserToRole
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
	
    $Candidates = $Role.Candidates + $user
    Set-PAMRole -Role $Role -Candidates $Candidates | Out-Null
}


