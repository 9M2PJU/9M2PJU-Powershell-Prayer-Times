Write-Host " ####   ##   ##    ####   ######      ####   ##  ##  "
Write-Host " ##  ##  ### ###   ##  ##   ##  ##      ##    ##  ##  "
Write-Host " ##  ##  #######       ##   ##  ##      ##    ##  ##  "
Write-Host "  #####  ## # ##      ##    ##  ##      ##    ##  ##  "
Write-Host "     ##  ##   ##     ##     #####       ##    ##  ##  "
Write-Host "    ##   ##   ##    ##      ##      ##  ##    ##  ##  "
Write-Host "  ###    ##   ##   ######  ###       ####      ####   "
Write-Host "                                                      "
Write-Host "9M2PJU Powershell Prayer Times v1.0"
Write-Host ""

function Get-UserLocation {
    $url = "http://ip-api.com/json/"
    $location = Invoke-RestMethod -Uri $url
    if ($location) {
        return @{ latitude = $location.lat; longitude = $location.lon }
    } else {
        Write-Error "Could not retrieve location data."
        exit
    }
}


function Get-PrayerTimes {
    param (
        [float]$latitude,
        [float]$longitude
    )

    $params = @{
        "Fajr" = 20
        "Isha" = 18
    }

    $apiUrl = "https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=17"

    $response = Invoke-RestMethod -Uri $apiUrl -Method Get

    if ($response.code -eq 200) {
        $timings = $response.data.timings
        return $timings
    } else {
        Write-Error "Error retrieving prayer times: $($response.status)"
        exit
    }
}


$location = Get-UserLocation
$latitude = $location.latitude
$longitude = $location.longitude


$prayerTimes = Get-PrayerTimes -latitude $latitude -longitude $longitude


$currentDate = Get-Date -Format "dddd, MMMM dd, yyyy"


Write-Host "Prayer Times for ${currentDate}:"
Write-Host "Fajr: $($prayerTimes.Fajr)"
Write-Host "Dhuhr: $($prayerTimes.Dhuhr)"
Write-Host "Asr: $($prayerTimes.Asr)"
Write-Host "Maghrib: $($prayerTimes.Maghrib)"
Write-Host "Isha: $($prayerTimes.Isha)"


Read-Host -Prompt "Press Enter to exit"
