function Get-ForestDomainControllers 
{
    (Get-ADForest).Domains | ForEach-Object {
        Get-ADDomainController -Discover -DomainName $_ -ForceDiscover
    }
}

function Get-ForestComputers ($Properties="Name")
{
    (Get-ADForest).Domains | ForEach-Object {
        ((Get-ADDomainController -Discover -DomainName $_ -ForceDiscover).HostName)[0] | ForEach-Object {
            Get-ADComputer -Filter * -Server $_ -Properties $Properties
        }       
    }
}

function Get-ForestGroups ($Properties="Name")
{
    (Get-ADForest).Domains | ForEach-Object {
        ((Get-ADDomainController -Discover -DomainName $_ -ForceDiscover).HostName)[0] | ForEach-Object {
            Get-ADGroup -Filter * -Server $_ -Properties $Properties
        }       
    }
}

function Get-ForestUsers ($Properties="Name")
{
    (Get-ADForest).Domains | ForEach-Object {
        ((Get-ADDomainController -Discover -DomainName $_ -ForceDiscover).HostName)[0]  | ForEach-Object {
            Get-ADUser -Filter * -Server $_ -Properties $Properties
        }
    }    
}

function Get-ForestComputerObjects ($Properties="Name")
{
    Get-ADObject -Filter 'ObjectClass -eq "computer"' -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268" -Properties $Properties
}

function Get-ForestUserObjects ($Properties="Name")
{
    Get-ADObject -Filter 'ObjectClass -eq "user"' -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268" -Properties $Properties
}

function Get-ForestObjects
{
    param (
        [Parameter(Mandatory=$true)]
        [string]$filter,
        [string]$Properties="Name"
    )
    Get-ADObject $filter -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268" -Properties $Properties
}

Export-ModuleMember -Function * -Variable * -Cmdlet *
