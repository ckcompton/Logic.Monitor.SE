Function Import-LMNetscanTemplate{
    Param(
        [Parameter(Mandatory)]
        [ValidateSet("vSphere","Meraki","JuniperMist","All")]
        $NetscanType,

        [Parameter(Mandatory)]
        $NetscanCollectorId,

        [Parameter(Mandatory)]
        $NetscanGroupName = "@default"
    )
    Function Import-LMvSphereNetScan{
        Param(
            $CollectorId = 1,
            $Name = "vSphere Enhanced NetScan Template",
            $Group,
            $Description = "vSphere Template based on: https://www.logicmonitor.com/support/vmware-vsphere-monitoring"
        )

        $CustomCredentials = [System.Collections.Generic.List[PSObject]]@()
        $Filters = [System.Collections.Generic.List[PSObject]]@()
        
        $Script = Invoke-RestMethod "https://raw.githubusercontent.com/stevevillardi/LogicMonitor-Dashboards/main/NetScan%20Templates/vsphere.groovy"
        
        #Default vCenter NetScan Creds/Props
        $CustomCredentials.Add([PSCustomObject]@{"vcenter.user"="logicmonitor@vsphere.local"})
        $CustomCredentials.Add([PSCustomObject]@{"vcenter.pass"="changeme"})
        $CustomCredentials.Add([PSCustomObject]@{"vcenter.hostname"="<IP Address or FQDN>"})
        $CustomCredentials.Add([PSCustomObject]@{"vcenter.displayname"="vcenter01"})
        $CustomCredentials.Add([PSCustomObject]@{"esx.user"="root"})
        $CustomCredentials.Add([PSCustomObject]@{"esx.pass"="changeme"})
        $CustomCredentials.Add([PSCustomObject]@{"rootFolder"="Customer01/VMware vSphere/vCenter01/"})
        $CustomCredentials.Add([PSCustomObject]@{"discover.esxi"="true"})
        $CustomCredentials.Add([PSCustomObject]@{"discover.vm"="true"})
        $CustomCredentials.Add([PSCustomObject]@{"view.hostAndCluster"="true"})
        $CustomCredentials.Add([PSCustomObject]@{"view.vmsAndTemplates"="true"})
        $CustomCredentials.Add([PSCustomObject]@{"view.standaloneVm"="true"})
        
        #Default vCenter NetScan Creds/Props
        $Filters.Add(
            [PSCustomObject]@{
                "attribute"="netscan.foundDNS"
                "operation"="Equal"
                "comment"="NetScan was able to discover the Virtual Machines DNS name (true or false)"
                "value"="true"
            })
        $Filters.Add([PSCustomObject]@{
                "attribute"="netscan.powerstate"
                "operation"="Equal"
                "comment"="Power state at the time that the netscan was run. Used for filtering powered off Virtual Machines from discovery."
                "value"="poweredOn"
            })
        $Filters.Add([PSCustomObject]@{
                "attribute"="vcenter.datacenter"
                "operation"="Equal"
                "comment"="Used to filter out all VMs in a specific folder/resource pool/etc. One value per filter entry."
                "value"="DataCenter01"
            })
        $Filters.Add([PSCustomObject]@{
                "attribute"="vcenter.cluster"
                "operation"="Equal"
                "comment"="vSphere Clusters whose resources you wish to discover/exclude. The default behavior is to discover/import all clusters for the targeted vCenter. One value per filter entry."
                "value"="Cluster01, Cluster02"
            })
        $Filters.Add([PSCustomObject]@{
                "attribute"="vcenter.resourcepool"
                "operation"="Equal"
                "comment"="Resource pools, whose resources you wish to discover/exclude.The Default behavior discovers/imports all vCenter Resource Pools as Resource Groups and all VMs as Resources. One value per filter entry."
                "value"="Prod, MissionCritical"
            })
        $Filters.Add([PSCustomObject]@{
                "attribute"="vcenter.folder"
                "operation"="NotEqual"
                "comment"="vCenter Folders, whose resources you wish to discover/exclude. The Default behavior discovers/imports all vCenter Folders as Resource Groups and all VMs as Resources. One value per filter entry."
                "value"="vCLS"
            })
        $Filters.Add([PSCustomObject]@{
                "attribute"="vcenter.hostname"
                "operation"="RegexNotMatch"
                "comment"="ESXi Hosts or Virtual Machines you want to discover or exclude. The Default behavior discovers or imports all vCenter ESXi Hosts and VMs as Resources. One value per filter entry."
                "value"=".*[Tt]est.*"
            })
        $Filters.Add([PSCustomObject]@{
                "attribute"="vcenter.tags"
                "operation"="NotEqual"
                "comment"="Resources you want to discover or exclude based on tags of format category.tag. The Default behavior ignores the values of VM tags. One value per filter entry."
                "value"="dev, test, nomonitoring"
            })

        New-LMEnhancedNetScan `
            -CollectorId $CollectorId `
            -Name $Name `
            -NetScanGroupName $Group `
            -CustomCredentials $CustomCredentials `
            -Filters $Filters `
            -Description $Description `
            -GroovyScript $Script.Replace("©","")
    }

    Function Import-LMMerakiNetScan{
        Param(
            $CollectorId = 1,
            $Name = "Meraki Enhanced NetScan Template",
            $Group,
            $Description = "Meraki Template based on: https://www.logicmonitor.com/support/cisco-meraki-monitoring"
        )

        $CustomCredentials = [System.Collections.Generic.List[PSObject]]@()
        $Filters = [System.Collections.Generic.List[PSObject]]@()
        
        $Script = Invoke-RestMethod "https://raw.githubusercontent.com/stevevillardi/LogicMonitor-Dashboards/main/NetScan%20Templates/meraki.groovy"
        
        #Default Meraki NetScan Creds/Props
        $CustomCredentials.Add([PSCustomObject]@{"meraki.api.org"="<Org Id>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.api.key"="<changeme>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.snmp.community.pass"="<changeme>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.snmp.security"="<username>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.snmp.auth"="<SHA or MD5>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.snmp.authToken.pass"="<changeme>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.snmp.priv"="<AES128 or DES>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.snmp.privToken.pass"="<changeme>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.api.org.folder"="<optional>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.api.org.name"="<optional>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.api.org.networks"="<optional>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.api.org.collector.networks.csv"="<optional>"})
        $CustomCredentials.Add([PSCustomObject]@{"meraki.service.url"="<optional>"})
        
        #Default Meraki NetScan Creds/Props
        $Filters.Add(
            [PSCustomObject]@{
                "attribute"="meraki.productType"
                "operation"="Equal"
                "comment"="Import this type of Meraki devices"
                "value"="appliance"
            })
        $Filters.Add(
            [PSCustomObject]@{
                "attribute"="meraki.tags"
                "operation"="Equal"
                "comment"="Import devices with this Meraki Dashboard tag"
                "value"="production"
            })
        $Filters.Add(
            [PSCustomObject]@{
                "attribute"="meraki.serial"
                "operation"="Equal"
                "comment"="Import a device that has this Meraki serial number"
                "value"="Q1AB-2CD3-EFGH"
            })
        $Filters.Add(
            [PSCustomObject]@{
                "attribute"="meraki.firmware"
                "operation"="Equal"
                "comment"="Import Meraki devices having this firmware version"
                "value"="switch-16-4"
            })
        $Filters.Add(
            [PSCustomObject]@{
                "attribute"="meraki.api.network.name"
                "operation"="Equal"
                "comment"="Import devices in this Meraki Network"
                "value"="Store 105"
            })

        New-LMEnhancedNetScan `
            -CollectorId $CollectorId `
            -Name $Name `
            -NetScanGroupName $Group `
            -CustomCredentials $CustomCredentials `
            -Filters $Filters `
            -Description $Description `
            -GroovyScript $Script.Replace("©","")
    }

    Function Import-LMJuniperNetScan{
        Param(
            $CollectorId = 1,
            $Name = "Juniper Mist Enhanced NetScan Template",
            $Group,
            $Description = "Juniper Mist Template based on: https://www.logicmonitor.com/support/juniper-mist-monitoring"
        )

        $CustomCredentials = [System.Collections.Generic.List[PSObject]]@()
        $Filters = [System.Collections.Generic.List[PSObject]]@()
        
        $Script = Invoke-RestMethod "https://raw.githubusercontent.com/stevevillardi/LogicMonitor-Dashboards/main/NetScan%20Templates/juniper-mist.groovy"
        
        #Default Meraki NetScan Creds/Props
        $CustomCredentials.Add([PSCustomObject]@{"mmist.api.org"="<Org Id>"})
        $CustomCredentials.Add([PSCustomObject]@{"mist.api.key"="<changeme>"})
        $CustomCredentials.Add([PSCustomObject]@{"mist.api.org.folder"="<optional>"})
        $CustomCredentials.Add([PSCustomObject]@{"mist.api.org.name"="<optional>"})
        $CustomCredentials.Add([PSCustomObject]@{"mist.api.org.sites"="<optional>"})
        $CustomCredentials.Add([PSCustomObject]@{"mist.api.org.collector.sites.csv"="<optional>"})
        $CustomCredentials.Add([PSCustomObject]@{"mist.api.url"="<optional>"})
        
        #Default Meraki NetScan Creds/Props
        $Filters.Add(
            [PSCustomObject]@{
                "attribute"="mist.api.org.site.name"
                "operation"="Equal"
                "comment"="Comma-separated names of sites you want to include or exclude. By default (without this filter), the NetScan imports all sites as Resource Groups. Site names with spaces must include a backslash before the space"
                "value"="Site\ For\ APs, SiteD, Site\ 23"
            })
        $Filters.Add(
            [PSCustomObject]@{
                "attribute"="mist.device.type"
                "operation"="Equal"
                "comment"="Comma-separated names of device types that the NetScan will include or exclude, depending on the operation setting.  By default (without this filter), the NetScan imports all device types. Valid device types are: ap, switch, and gateway."
                "value"="switch"
            })

        New-LMEnhancedNetScan `
            -CollectorId $CollectorId `
            -Name $Name `
            -NetScanGroupName $Group `
            -CustomCredentials $CustomCredentials `
            -Filters $Filters `
            -Description $Description `
            -GroovyScript $Script.Replace("©","")
    }

    If ($(Get-LMAccountStatus).Valid) {
        
        If($NetscanGroupName){
            $GroupName = Get-LMNetscanGroup -Name $NetscanGroupName
            If(!$GroupName) {
                $Group = (New-LMNetscanGroup -Name $NetscanGroupName).Name
            }
        }

        Switch($NetscanType){
            "vSphere"       {Import-LMvSphereNetScan -CollectorId $NetscanCollectorId -Group $NetscanGroupName}
            "Meraki"        {Import-LMJuniperNetScan -CollectorId $NetscanCollectorId -Group $NetscanGroupName}
            "JuniperMist"   {Import-LMMerakiNetScan -CollectorId $NetscanCollectorId -Group $NetscanGroupName}
            default         {
                Import-LMvSphereNetScan -CollectorId $NetscanCollectorId -Group $NetscanGroupName
                Import-LMJuniperNetScan -CollectorId $NetscanCollectorId -Group $NetscanGroupName
                Import-LMMerakiNetScan -CollectorId $NetscanCollectorId -Group $NetscanGroupName
            }
        }

    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}