$files = (Get-ChildItem -Filter *.csv -Recurse E:\Downloads\twitch-leaks-part-one\twitch-payouts\all_revenues\)

Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""

$start = Get-Date
[double] $secondsRemaining = 0

for ($i = 0; $i -lt $files.Count; $i++) {
    $file = $files[$i]
    $percent = (($i + 1) * 100 / $files.Count)
    Write-Progress -Activity "Importing Twitch Files" -Status "$([int] $percent)% - $($file.FullName)" -PercentComplete $percent -SecondsRemaining $secondsRemaining
    mongoimport.exe /d twitch /c all_revenues /fieldFile:twitch-importfile.cfg /columnsHaveTypes /parseGrace:skipField /type:csv /file $($file.FullName) /quiet
    # mongoimport.exe /d twitch /c all_revenues /headerline /type:csv /parseGrace:skipField /file $($file.FullName)

    $secondsElapsed = (Get-Date) - $start
    $secondsRemaining = ($secondsElapsed.TotalSeconds / ($i + 1)) * ($files.Count - ($i + 1))
}

# mongoimport.exe /d twitch /c test /fieldFile:twitch-importfile.cfg /columnsHaveTypes /type:csv /parseGrace:skipField /file $($files.Full)