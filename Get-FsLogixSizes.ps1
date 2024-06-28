function Get-FsLogixSizes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ComputerName
    )

    if (-not $Creds) {
        $Creds = Get-Credential
    }

    $Volumes = Invoke-Command -ComputerName $ComputerName -ScriptBlock { Get-Volume } -Credential $Creds

    $Volumes | Where-Object { ($_.FileSystemLabel -Match 'O365-') -or ($_.FileSystemLabel -Match 'Profile-') } | ForEach-Object {
        [PSCustomObject]@{
            Container = $_.FileSystemLabel
            Size      = [math]::Round( ($_.Size / 1GB), 2 )
            Free      = [math]::Round( ($_.SizeRemaining / 1GB), 2 )

        }
    }
}
