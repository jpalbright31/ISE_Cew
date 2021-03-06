Function Get-AlignedText {
<#
        .SYNOPSIS
        Uses the Highlighted Text to Align based on the = delimiter - For Splatting
         
        .DESCRIPTION
        Uses the Highlighted Text to Align based on the = delimiter - For Splatting
        
        .EXAMPLE
        $psise.CurrentFile.Editor.InsertText((Get-AlignedText -Text $psISE.CurrentFile.Editor.SelectedText -Delimiter '='))
                        
        .NOTES
        AUTHOR
        Dave Wyatt
        LICENSE
        MIT 
        
      #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [string[]]
        $Text,

        [string]
        $Delimiter = '='
    )

    $rightmostIndex = -1

    $lines =
    foreach ($string in $Text)
    {
        foreach ($line in $string -split '\r?\n')
        {
            $position = $line.IndexOf($Delimiter)
            if ($position -gt $rightmostIndex) { $rightmostIndex = $position }

            [pscustomobject] @{
                Line     = $line
                Position = $position
            }
        }
    }

    @(
        foreach ($line in $lines)
        {
            if ($line.Position -ge 0 -and $line.Position -lt $rightmostIndex)
            {
                "{0}{1,$($rightmostIndex - $line.Position)}{2}" -f $line.Line.SubString(0, $line.Position), ' ', $line.Line.SubString($line.Position)
            }
            else
            {
                $line.Line
            }
        }
    ) -join "`r`n"

}