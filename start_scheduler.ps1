
$start_time = New-JobTrigger -Daily -At 6:00PM

$cred = Get-Credential Yaska

$o = New-ScheduledJobOption -RunElevated

Register-ScheduledJob -Name start_scheduler -FilePath .\install_firefox.ps1 -Trigger $start_time -Credential $cred -ScheduledJobOption $o