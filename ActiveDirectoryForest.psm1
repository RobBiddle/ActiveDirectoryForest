function Get-ForestComputers
{
    (Get-ADForest).Domains | ForEach-Object {
        ((Get-ADDomainController -Discover -DomainName $_ -ForceDiscover).HostName)[0] | ForEach-Object {
            Get-ADComputer -Filter * -Server $_
        }       
    }
}

function Get-ForestUsers
{
    (Get-ADForest).Domains | ForEach-Object {
        ((Get-ADDomainController -Discover -DomainName $_ -ForceDiscover).HostName)[0]  | ForEach-Object {
            Get-ADUser -Filter * -Server $_
        }
    }    
}

function Get-ForestComputerObjects
{
    Get-ADObject -Filter 'ObjectClass -eq "computer"' -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268"
}

function Get-ForestUserObjects
{
    Get-ADObject -Filter 'ObjectClass -eq "user"' -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268"
}

function Get-ForestObjects
{
    param (
        [Parameter(Mandatory=$true)]
        [string]$filter
    )
    Get-ADObject $filter -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268"
}

Export-ModuleMember -Function * -Variable * -Cmdlet *
