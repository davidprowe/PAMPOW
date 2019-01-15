Function Get-PAMPOWSet {
#Next, output users in sets to psobject-
#then write command to get all sets, then create list of all users in all pam sets

		
		param(
		[string]$DisplayName,
		[string]$ObjectID,
		[string]$Creator,
		[string]$ExplicitMember,
		[string]$ComputedMember,
		[bool]$listMembers
		)
		#TODO, convert by default the member list to readable form instead of using the listmembers switch
		#todo on list members if account not found, output not found ex: admin account that was deleted out of PAM still isted as pam administrators
		
	$Pamset = get-pamset

		if ($psboundparameters.containskey('DisplayName')){
			foreach ($set in $pamset){
				if($set.displayname -like "$DisplayName"){$set
				$admingroups = $set
				}
				}

		
		}
		
				if ($psboundparameters.containskey('ObjectID')){
			foreach ($set in $pamset){
				if($set.ObjectID -like "$ObjectID"){$set
				$admingroups = $set
				}
				}

		
		}
		
				if ($psboundparameters.containskey('Creator')){
			foreach ($set in $pamset){
				if($set.Creator -like "$Creator"){$set
				$admingroups = $set
				}
				}

		
		}
		
				if ($psboundparameters.containskey('ExplicitMember')){
			foreach ($set in $pamset){
				if($set.ExplicitMember -like "$ExplicitMember"){$set
				$admingroups = $set
				}
				}

		
		}
		
				if ($psboundparameters.containskey('ComputedMember')){
			foreach ($set in $pamset){
				if($set.ComputedMember -like "$ComputedMember"){$set
				$admingroups = $set
				}
				}

		
		}
		
		if ($psboundparameters.containskey('listMembers')){
			if ($listMembers -eq $true){
				foreach ($admingroup in $admingroups){
				$userlist = get-pamuser
				foreach ($expmember in $admingroup.ExplicitMember){
								
				$userlist|foreach-object {if ($_.SourceUserResourceId -eq $expmember.guid) {
				#https://blogs.msdn.microsoft.com/powershell/2009/12/04/new-object-psobject-property-hashtable/
				write-host Computed Memberlist
				write-host $_.privaccountname
				write-host $_.sourceaccountname
				Write-host $_.sourcedisplayname
				write-host $_.sourcedescription
				write-host $_.sourceaccountsid
				write-host $_sourcedomain} }
				}
				
				foreach ($CompMember in $admingroup.ComputedMember){
				#$CompMember
				#$CompMember.guid
				
				$userlist|foreach-object {if ($_.SourceUserResourceId -eq $CompMember.guid) {
				#https://blogs.msdn.microsoft.com/powershell/2009/12/04/new-object-psobject-property-hashtable/
				write-host $_.privaccountname
				write-host $_.sourceaccountname
				Write-host $_.sourcedisplayname
				write-host $_.sourcedescription
				write-host $_.sourceaccountsid
				write-host $_sourcedomain} }
				}

				
				
				}
			
			}
			}
		
}

