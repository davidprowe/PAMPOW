function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}
$basescriptPath = Get-ScriptDirectory
$thisfile = $MyInvocation.MyCommand.Name 
$FIMcmdletimports = "InstallCmdlets.ps1"
$pampowmodule = "PAMPOW.psm1"
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

<#
function Create-Module{
param (
	[object]$FilePath
	
)

function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}
#$basescriptPath = Get-ScriptDirectory
$thisfile = "imprt-PamPow.ps1"
$FIMcmdletimports = "InstallCmdlets.ps1"
$pampowmodule = "PAMPOW.psm1"

$content = @()	
$ps1s = get-childitem -path $FilePath -recurse|where-object -property 'name' -like "*.ps1"|where-object -property 'name' -ne $thisfile # |where-object -property 'name' -ne $FIMcmdletimports
    foreach($ps1 in $ps1s) {
		$content += get-content  $ps1.FullName
		}
$content | set-content "$FilePath\$pampowmodule"
Add-content -path "$FilePath\$pampowmodule" -value "Export-ModuleMember -function `"Get-*`""
Add-content -path "$FilePath\$pampowmodule" -value "Export-ModuleMember -function `"Add-*`""
Add-content -path "$FilePath\$pampowmodule" -value "Export-ModuleMember -function `"Remove-*`""
[string]$dest = (($env:PSModulePath) -split ";") -like "*Documents*"

if((Test-Path $dest) -eq 0)
{
mkdir $dest
}
Copy-Item -Path "$FilePath\$pampowmodule" -destination $dest -Recurse -Force -ErrorAction Continue
#import-module $pampowmodule
}
#>
<#
TODO: 
in new-pamgroup - if -PrivOnly parameter is specified, this command creates a representation in the MIM Service for a security group which already 
    exists in the PAM domain.  The value of the SourceDomain parameter must be the same as the PAM domain name.
	 - so code: if -privonly added use the PAM domain, do not use any other domain name
ex from new-pamgroup
-------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>$pg = New-PAMGroup -PrivOnly -SourceDomain priv.contoso.local -SourceGroupName "File Admins"
    
    Description
    
    -----------
    
    When the PrivOnly parameter is specified, this command creates a representation in the MIM Service for a security group which already 
    exists in the PAM domain.  The value of the SourceDomain parameter must be the same as the PAM domain name.

	
	TODO ; Let do by default search the priv domain for the group.  If the group does 
#>
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


<#
TODO:
List pam tenants
List tenant configurations


#>
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

<#
get-pampow user filer by, priv acctname, priv upn, priv displayname, priv accoutsid, priv user resourceid, source acctname, source displayname, source domain
how to list domains?
#>


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
	$output = get-pamrole -displayname $Role.displayname|select Displayname, Description, Approvers, Candidates
		
		$PAMRoleOutput = New-Object PSObject -Property @{
				Displayname = $output.displayname
				Description = $output.Description
				Approvers = $output.Approvers.PrivAccountname
				Candidates = $output.Candidates.PrivAccountname
						
		}
		<# 
		$PamRoleObjectCandidateOutput = @()
		write-host "Candidate list for $output.displayname is set to:"
		foreach ($c in $pamroleoutput.candidates){
				$PamRoleObjectCandidateOutput += @{
				#Displayname = $output.displayname; `
				#Description = $output.Description; `
				#Approvers =$output.Approvers.PrivAccountname; `
				CandidatePrivAccountName = $C
						}
		
		
		}
		$PamRoleObjectCandidateOutput #>
		$PAMRoleOutput	|select Displayname, description, approvers, candidates| fl
	
	
}



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
Export-ModuleMember -function "Get-*"
Export-ModuleMember -function "Add-*"
Export-ModuleMember -function "Remove-*"
