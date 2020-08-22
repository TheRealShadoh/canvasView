function Get-RFJob {
    <#
    .Synopsis
    Retrieves list of iDRAC jobs, Id, Name, JobState
    .DESCRIPTION
    Modified version of GetDeleteJobQueueREDFISH.py (Dell iDRAC-Redfish-Scripting)
    Accepts get-credential for the -Credentials parameter.
    .EXAMPLE
    Below example will prompt for the password of the user root.
        Get-RFJob -ComputerName 192.168.1.10 -Credential root

    Below example will accept get-credential information and not prompt.
        $creds = Get-Credential
        Get-RFJob -ComputerName 192.168.1.10 -Credential $creds
    #>
    param(
        [Parameter(Mandatory = $True)]
        $ComputerName,
        [Parameter(Mandatory = $True)]
        [System.Management.Automation.PSCredential]$Credential,
        $Id
    )

    Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "https://$ComputerName/redfish/v1/Managers/iDRAC.Embedded.1/Jobs"


    if ($Id -ne $null) {
        #region Retrieve single job
        $resultArray = @()
        try {
            $RawResult = Invoke-WebRequest -Uri "$uri/$Id" -Credential $credential -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers @{"Accept" = "application/json" } -UseBasicParsing
        }
        catch {
            Write-Host
            $RespErr
            return
        }

        if ($RawResult.StatusCode -eq 200) {
            $RawResult = $RawResult.Content | ConvertFrom-Json
            $resultArray += $RawResult
        }
        else {
            Write-Warning "REDFISH request failed"
        }

        $resultArray
        #endregion
    }
    else {
        #region Retrieve all jobs
        $resultArray = @()
        try {
            $RawResult = Invoke-WebRequest -Uri "$uri" -Credential $credential -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers @{"Accept" = "application/json" } -UseBasicParsing
        }
        catch {
            Write-Host
            $RespErr
            return
        }

        if ($RawResult.StatusCode -eq 200) {
            $RawResult = $RawResult.Content | ConvertFrom-Json
            foreach ($result in $RawResult.members) {
                $ResultID = ($result."@odata.id" -split "/")[-1]
                $SingleResult = Invoke-WebRequest -Uri "$uri/$ResultID" -Credential $credential -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers @{"Accept" = "application/json" } -UseBasicParsing
                $SingleResult = $SingleResult.content | ConvertFrom-Json
                $resultArray += $SingleResult
            }
        }
        else {
            Write-Warning "REDFISH request failed"
        }

        $resultArray
    }
    #endregion
}
Function Get-CanvasToken {
    <#
    .Synopsis
    .DESCRIPTION
    .EXAMPLE
    #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL
    )

    #Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "$CanvasURL/login/oauth2/auth?client_id=099&response_type=code&state=YYY&redirect_uri=rn:ietf:wg:oauth:2.0:oob"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"



    $resultArray = @()
    try {
        $RawResult = Invoke-WebRequest -Uri "$uri" -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers $headers -UseBasicParsing
    }
    catch {
        Write-Host
        $RespErr
        return
    }

    if ($RawResult.StatusCode -eq 200) {
        $RawResult = $RawResult.Content | ConvertFrom-Json
        $resultArray += $RawResult
    }
    else {
        Write-Warning "REDFISH request failed"
    }

    $resultArray

}
function Set-CanvasAuth {
    <#
        .Synopsis
        .DESCRIPTION
        .EXAMPLE
        #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL,
        $AuthToken
    )

    #Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "$CanvasURL/api/v1/courses"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer $AuthToken")



    $resultArray = @()
    try {
        $RawResult = Invoke-WebRequest -Uri "$uri" -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers $headers -UseBasicParsing
    }
    catch {
        Write-Host
        $RespErr
        return
    }

    if ($RawResult.StatusCode -eq 200) {
        $RawResult = $RawResult.Content | ConvertFrom-Json
        $resultArray += $RawResult
    }
    else {
        Write-Warning "Request failed"
    }

    $resultArray
}
function Get-CanvasCourses {
    <#
        .Synopsis
        .DESCRIPTION
        .EXAMPLE
        #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL,
        $AuthToken
    )

    #Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "$CanvasURL/api/v1/courses"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $AuthToken")
    $Body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Body.Add("include", "term")


    $resultArray = @()
    try {
        $RawResult = Invoke-WebRequest -Uri "$uri" -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Body $Body -Headers $headers -UseBasicParsing
    }
    catch {
        Write-Host
        $RespErr
        return
    }

    if ($RawResult.StatusCode -eq 200) {
        $RawResult = $RawResult.Content | ConvertFrom-Json
        $resultArray += $RawResult
    }
    else {
        Write-Warning "Request failed"
    }

    return $resultArray

}

function Get-CanvasCourseStudent {
    <#
        .Synopsis
        .DESCRIPTION
        .EXAMPLE
        #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL,
        $AuthToken,
        [Parameter(Mandatory = $True)]
        $CourseID,
        $StudentID = "self"
    )

    #Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "$CanvasURL/api/v1/courses/$courseID/users/$StudentID"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $AuthToken")


    $resultArray = @()
    try {
        $RawResult = Invoke-WebRequest -Uri "$uri" -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers $headers -UseBasicParsing
    }
    catch {
        Write-Host
        $RespErr
        return
    }

    if ($RawResult.StatusCode -eq 200) {
        $RawResult = $RawResult.Content | ConvertFrom-Json
        $resultArray += $RawResult
    }
    else {
        Write-Warning "Request failed"
    }

    return $resultArray

}

function Get-CanvasStudent {
    <#
        .Synopsis
        .DESCRIPTION
        .EXAMPLE
        #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL,
        $AuthToken,
        $StudentID = "self"
    )

    #Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "$CanvasURL/api/v1/users/$StudentID"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $AuthToken")

    $resultArray = @()
    try {
        $RawResult = Invoke-WebRequest -Uri "$uri" -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers $headers -UseBasicParsing
    }
    catch {
        Write-Host
        $RespErr
        return
    }

    if ($RawResult.StatusCode -eq 200) {
        $RawResult = $RawResult.Content | ConvertFrom-Json
        $resultArray += $RawResult
    }
    else {
        Write-Warning "Request failed"
    }

    return $resultArray

}
function Get-CanvasCourseAssignment {
    <#
        .Synopsis
        .DESCRIPTION
        .EXAMPLE
        #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL,
        $AuthToken,
        $CourseID
    )

    #Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "$CanvasURL/api/v1/courses/$CourseID/assignments"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $AuthToken")


    $resultArray = @()
    try {
        $RawResult = Invoke-WebRequest -Uri "$uri" -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers $headers -UseBasicParsing
    }
    catch {
        Write-Host
        $RespErr
        return
    }

    if ($RawResult.StatusCode -eq 200) {
        $RawResult = $RawResult.Content | ConvertFrom-Json
        $resultArray += $RawResult
    }
    else {
        Write-Warning "Request failed"
    }

    return $resultArray

}

function Get-CanvasPlanner {
    <#
        .Synopsis
        .DESCRIPTION
        .EXAMPLE
        #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL,
        $AuthToken,
        $StudentID = "self"
    )

    #Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "$CanvasURL/api/v1/users/$StudentID/planner/items"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $AuthToken")

    $resultArray = @()

    try {
        $RawResult = Invoke-WebRequest -Uri "$uri" -Method Get -ContentType 'application/json' -ErrorVariable RespErr -Headers $headers -UseBasicParsing
    }
    catch {
        Write-Host
        $RespErr
        return
    }

    if ($RawResult.StatusCode -eq 200) {
        $RawResult = $RawResult.Content | ConvertFrom-Json
        $resultArray += $RawResult
    }
    else {
        Write-Warning "Request failed"
    }

    return $resultArray

}

function Get-CanvasInfo {
    <#
        .Synopsis
        .DESCRIPTION
        .EXAMPLE
        #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL,
        $AuthToken,
        $StudentID = "self"
    )
    $student = Get-CanvasStudent -CanvasURL $canvasURL -AuthToken $AuthToken
    $courses = Get-CanvasCourses -CanvasURL $canvasURL -AuthToken $AuthToken
    $planner = Get-CanvasPlanner -CanvasURL $canvasURL -AuthToken $AuthToken -StudentID $StudentID #| Select id, name

    $hash = @{
        "Name"      = $student.name
        "StudentID" = $student.id
        "Avatar"    = $student.avatar_url
        "Courses"   = @{}
    }
    Foreach ($course in $courses) {
        $hash.Courses.Add($course.name,@{})
        $hash.Courses.$($course.name).add("Name", $course.name)
        $hash.Courses.$($course.name).add("CourseID", $course.id)
        $hash.Courses.$($course.name).add("Assignments",$(New-Object -TypeName "System.Collections.ArrayList"))
        $courseAssignments = $planner.Where( { $_.course_ID -eq $course.id })
        if($courseAssignments){
            $courseAssignments | ForEach-Object {
                $assignmentObject = [PSCustomObject]@{
                    Class = $course.Name
                    Title = $_.plannable.title
                    AssignmentID = $_.plannable.id
                    Submitted = $_.submissions.submitted
                    Graded = $_.submissions.graded
                    Late = $_.submissions.late
                }
                $hash.Courses.$($course.name)."Assignments".add($assignmentObject)
            }
        }
    }

    return $hash

}