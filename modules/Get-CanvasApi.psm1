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
    $Body.Add("include", @("term","syllabus_body","current_grading_period_scores"))

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
                    Details = $null
                    AssignmentID = $_.plannable.id
                    DueDate = $_.plannable.due_at
                    Submitted = $_.submissions.submitted
                    Graded = $_.submissions.graded
                    Late = $_.submissions.late
                    Link = $null
                }
                if($assignmentObject.dueDate){
                    $assignmentObject.dueDate = [datetime]$assignmentObject.dueDate
                }
                $details = Get-CanvasAssignmentDetails -CanvasURL $CanvasURL -AuthToken $AuthToken -AssignmentURL $_.html_url
                $assignmentObject.link = $details.html_url
                $assignmentObject.Details = $details.message
                $hash.Courses.$($course.name)."Assignments".add($assignmentObject)
            }
        }
    }

    return $hash
}

function Get-CanvasAssignmentDetails {
    <#
        .Synopsis
        .DESCRIPTION
        .EXAMPLE
        #>
    param(
        [Parameter(Mandatory = $True)]
        $CanvasURL,
        $AuthToken,
        $AssignmentURL
    )

    #Set-IgnoreSSLCertificates
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    # URI setting
    $uri = "$CanvasURL/api/v1$AssignmentURL"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept", "application/json")
    $headers.Add("Authorization", "Bearer $AuthToken")
    $Body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

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

