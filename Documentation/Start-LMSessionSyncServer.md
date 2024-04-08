---
external help file: Logic.Monitor.SE-help.xml
Module Name: Logic.Monitor.SE
online version:
schema: 2.0.0
---

# Start-LMSessionSyncServer

## SYNOPSIS
This function starts a session synchronization server for Logic Monitor.

## SYNTAX

```
Start-LMSessionSyncServer [-EnableRequestLogging] [-EnableErrorLogging]
```

## DESCRIPTION
The Start-LMSessionSyncServer function starts a Pode server that is used to synchronize sessions for Logic Monitor. 
It uses a secret vault to store session details.
If the vault does not exist, it creates one. 
The function also provides options to enable request logging and error logging.

## EXAMPLES

### EXAMPLE 1
```
Start-LMSessionSyncServer -EnableRequestLogging -EnableErrorLogging
```

This command starts the session synchronization server with request logging and error logging enabled.

## PARAMETERS

### -EnableRequestLogging
A switch to control whether request logging is enabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableErrorLogging
A switch to control whether error logging is enabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None. You cannot pipe objects to Start-LMSessionSyncServer.
## OUTPUTS

### The function does not return any output. It writes messages to the host to indicate the status of the server and the secret vault.
## NOTES
The function throws an error if it fails to unlock the secret vault with the provided credentials.

## RELATED LINKS
