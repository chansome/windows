function Get-Uptime {
    $WMI = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction SilentlyContinue

    if ($WMI) {
        $LastBootUpTime = $WMI.LastBootUpTime
        [TimeSpan]$Uptime = New-TimeSpan $LastBootUpTime (Get-Date)

        [PSCustomObject]@{
            Days    = $Uptime.days
            Hours   = $Uptime.hours
            Minutes = $Uptime.minutes
        }
    }
    else {
        'Bad WMI'
    }
}

function Invoke-GetUptime {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$ComputerName
    )

    if (-not $Creds) {
        $Creds = Get-Credential
    }

    try {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock ${function:Get-Uptime} -Credential $Creds -ErrorAction Stop | 
            Select-Object PSComputerName, Days, Hours, Minutes
    }
    catch {
        $_.Exception.Message
    }
}

Invoke-GetUptime -ComputerName
