## 1.4
###### Bug Fixes:
**Build-LMDataModel**: 
- Fix bug causing datasource group name to export as null even when a group name was present on the model device.

###### Enhancements:
**Build-LMDataModel**: 
- Running without the **-Debug** parameter will now display export progress.
- Added *privToken* and *authToken* to list of restricted properties for export
- Properties starting with *auto.snmp* and *auto.network* will be excluded from export by default
- *Null* properties will not longer be included in model export
- *&* is an invalid PushMetric instance name character and will be replaced with an *underscore* when part of an instance name

**Invoke-LMDataModelRunner**: 
- Added Multi-threading support for datasource submission. Previously only models were multi threaded but you can now use the switch **-MultiThreadDatasourceSubmission** to submit datasources in parellel. This switch will use the same **-ConcurrencyLimit** parameter that is used for processing data models.

**Submit-LMDataModel**: 
- Remove parameter support for **-ModelJson** as its not needed since it already accepts the model object
- If no data is found for a data point that is part of a model reply, it will now default to generating random data based on estimated metric type. Previously the behavior was to jus default to a value of 0.

###### New Commands:
**Submit-LMDataModelConccurent**: 
- New command to allow submitting datasources in a multi thread fashion similar to how **Invoke-LMModelRunner** multi threads model submission. Because this command runs in multiple threads it requires **-Account** and **-BearerToken parameters** to be set so each thread can connect to the required portal.