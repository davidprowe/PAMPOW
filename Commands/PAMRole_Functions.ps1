#going to chgange this one to get-pampowrole - add candidates to 
function GET-PAMPOWRole{
	#shows "memberof" roles where "rolename" is similar to memberof.  Reminds me of get-aduser -identity NAME -properties memberof
	#if you list a single role in the displayname parameter, it shows the members of that role/group
	#need - create new object almost exact output to get-pamrole, just change output of candidates list to candidatesprivacctsid and candidatesprivaccountname and privaccountdisplayname
	param(
	[string]$RoleID,
	[string]$Displayname,
	[string]$Session,
	[string]$Active,
	[int]$TTL
	#right now only seconds works[]$TimeFunction 3600 is 1 hr 28800 is 8 hr... so on
	#todo:eq, lt, ge...

	)
	
	$roles = get-pamrole
	if ($psboundparameters.containskey('RoleID')){
			foreach ($role in $roles){
				if($role.RoleID -like "$RoleID"){
				#$role
				   $grp = $role
				}
				}

		$grp
		}
	if ($psboundparameters.containskey('TTL')){
	$grp = @()
			foreach ($role in $roles){
				if($role.TTL -eq "$TTL"){
				#$role report back all groups with proper ttl
				   $grp += $role
				}
				}

		$grp
		}	
		
	


}




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
	<#
	TODO - add search functions for the function parameters:$PrivAccountSID, SourceAccountName, PrivAccountName
	#>
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



<#
TODO:
New-pamrole -privileges switch has to point to a full stored value of a pamgroup.  Change it so that it only has to have a groups priv account sid, source account sid, or source account name or priv display name
When new-pamrole is created, by default the creator creating the role is added to the candidate list.  By default on the new script, remove this user from candidacy - call function: remove-pampowuserfromrole -user $env:USERNAME -role ($displayname)
#>
















