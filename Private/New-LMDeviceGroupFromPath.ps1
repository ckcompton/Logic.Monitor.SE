Function New-LMDeviceGroupFromPath {
    Param (
        [String]$Path,

        [String]$PreviousGroupId
    )
    
    If($PreviousGroupId){
        $GroupId = (Get-LMDeviceGroup -Filter "name -eq '$Path' -and parentId -eq '$PreviousGroupId'").Id
        If(!$GroupId){
            $GroupId = (New-LMDeviceGroup -Name $Path -ParentGroupId $PreviousGroupId).Id
        }
        return $GroupId
    }
    Else{
        $GroupId = (Get-LMDeviceGroup -Filter "name -eq '$Path' -and parentId -eq '1'").Id
        If(!$GroupId){
            $GroupId = (New-LMDeviceGroup -Name $Path -ParentGroupId 1).Id
        }
        return $GroupId
    }
}
