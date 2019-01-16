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