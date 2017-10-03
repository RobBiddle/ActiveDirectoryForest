function Get-ForestDomainControllers 
{
    (Get-ADForest).Domains | ForEach-Object {
        Get-ADDomainController -Discover -DomainName $_ -ForceDiscover
    }
}

function Get-ForestComputers
{
    param (
        #[Parameter(Mandatory=$true)]
        [string]$filter="*",
        [string]$Properties="Name"
    )
    (Get-ADForest).Domains | ForEach-Object {
        ((Get-ADDomainController -Discover -DomainName $_ -ForceDiscover).HostName)[0] | ForEach-Object {
            Get-ADComputer -Filter $filter -Server $_ -Properties $Properties
        }       
    }
}

function Get-ForestGroups
{
    param (
        #[Parameter(Mandatory=$true)]
        [string]$filter="*",
        [string]$Properties="Name"
    )
    (Get-ADForest).Domains | ForEach-Object {
        ((Get-ADDomainController -Discover -DomainName $_ -ForceDiscover).HostName)[0] | ForEach-Object {
            Get-ADGroup -Filter $filter -Server $_ -Properties $Properties
        }       
    }
}

function Get-ForestUsers
{
    param (
        #[Parameter(Mandatory=$true)]
        [string]$filter="*",
        [string]$Properties="Name"
    )
    (Get-ADForest).Domains | ForEach-Object {
        ((Get-ADDomainController -Discover -DomainName $_ -ForceDiscover).HostName)[0]  | ForEach-Object {
            Get-ADUser -Filter $filter -Server $_ -Properties $Properties
        }
    }    
}

function Get-ForestComputerObjects
{
    param (
        #[Parameter(Mandatory=$true)]
        [string]$filter='ObjectClass -eq "computer"',
        [string]$Properties="Name"
    )
    Get-ADObject -Filter $filter -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268" -Properties $Properties
}

function Get-ForestUserObjects
{
    param (
        #[Parameter(Mandatory=$true)]
        [string]$filter='ObjectClass -eq "user"',
        [string]$Properties="Name"
    )
    Get-ADObject -Filter $filter -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268" -Properties $Properties
}

function Get-ForestObjects
{
    param (
        #[Parameter(Mandatory=$true)]
        [string]$filter="*",
        [string]$Properties="Name"
    )
    Get-ADObject -Filter $filter -SearchBase "$((Get-ADDomain (Get-ADForest).Name).DistinguishedName)" -server "$(((Get-ADForest).GlobalCatalogs)[0]):3268" -Properties $Properties
}

Export-ModuleMember -Function * -Variable * -Cmdlet *
