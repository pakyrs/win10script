##Windows 10 basic software installer + debloater + customization, more features to be added.
    
    Write-Host "Disabling Feedback..."
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null

		Write-Host "Disabling Tailored Experiences..."
	If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
		New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1

		Write-Host "Disabling Advertising ID..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1

		Write-Host "Disabling Error reporting..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null

		Write-Host "Stopping and disabling Diagnostics Tracking Service..."
	Stop-Service "DiagTrack" -WarningAction SilentlyContinue
	Set-Service "DiagTrack" -StartupType Disabled

	  Write-Host "Stopping and disabling WAP Push Service..."
	Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
	Set-Service "dmwappushservice" -StartupType Disabled

	  Write-Host "Disabling Shared Experiences..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableCdp" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableMmx" -Type DWord -Value 0

##Windows10 Apps Bloatware remover
$Bloatware = @(
       
      "Microsoft.BingFinance"
      "Microsoft.BingSports"
       "Microsoft.GetHelp"
       "Microsoft.Getstarted"
       "Microsoft.Messaging"
       "Microsoft.MicrosoftSolitaireCollection"
       "Microsoft.NetworkSpeedTest" 
       "Microsoft.WindowsFeedbackHub"
       "Microsoft.ZuneMusic"
       "Microsoft.ZuneVideo"
       "Microsoft.News"
       "*Microsoft.MSPaint*"
       #"Microsoft.Microsoft3DViewer"
       #"Microsoft.3DBuilder"
       #"Microsoft.AppConnector"
       #"Microsoft.BingNews"
       #"Microsoft.BingTranslator"
       #"Microsoft.BingWeather"
       #"Microsoft.WindowsMaps"
       #"Microsoft.WindowsSoundRecorder"
       #"Microsoft.SkypeApp"
       #"Microsoft.StorePurchaseApp"
       #"Microsoft.Wallet"
       #"Microsoft.Whiteboard"
       #"Microsoft.WindowsAlarms"
       #"microsoft.windowscommunicationsapps"
       #"Microsoft.Print3D"
       #"Microsoft.Office.Lens"
       #"Microsoft.Office.Sway"
       #"Microsoft.OneConnect"
       #"Microsoft.People"
       #"*Microsoft.BingWeather*"
       #"*Microsoft.Advertising.Xaml_10.1712.5.0_x64__8wekyb3d8bbwe*"
       #"*Microsoft.Advertising.Xaml_10.1712.5.0_x86__8wekyb3d8bbwe*"
       #"*Microsoft.MicrosoftStickyNotes*"
       #"*Microsoft.Windows.Photos*"
       #"*Microsoft.WindowsCalculator*"
       #"*Microsoft.WindowsStore*"

       #Sponsored Windows 10 AppX Apps
       "*EclipseManager*"
       "*ActiproSoftwareLLC*"
       "*Duolingo-LearnLanguagesforFree*"
       "*PandoraMediaInc*"
       "*CandyCrush*"
       "*BubbleWitch3Saga*"
       "*Wunderlist*"
       "*Flipboard*"
       "*Twitter*"
       "*Facebook*"
       "*Royal Revolt*"
       "*Sway*"
       "*Speed Test*"
       "*Dolby*"
       "*Viber*"
       "*ACGMediaPlayer*"
       "*Netflix*"
       "*OneCalendar*"
       "*LinkedInforWindows*"
       "*Hulu*"
       "*HuluLLC.HuluPlus*"
       "*HiddenCity*"
       "*HiddenCityMysteryofShadows*"
       "*828B5831.HiddenCityMysteryofShadows*"
       "*Dolby*"
       "*DolbyLaboratories.DolbyAccess*"
       "*AdobePhotoshopExpress*"
       "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
       "*ROBLOXCORPORATION.ROBLOX*" 
       "2FE3CB00.PicsArt-PhotoStudio"
       "46928bounde.EclipseManager"
       "4DF9E0F8.Netflix"
       "613EBCEA.PolarrPhotoEditorAcademicEdition"
       "6Wunderkinder.Wunderlist"
       "7EE7776C.LinkedInforWindows"
       "9E2F88E3.Twitter"
       "A278AB0D.DisneyMagicKingdoms"
       "A278AB0D.MarchofEmpires"
       "ActiproSoftwareLLC.562882FEEB491"
       "CAF9E577.Plex"  
       "ClearChannelRadioDigital.iHeartRadio"
       "D52A8D61.FarmVille2CountryEscape"
       "D5EA27B7.Duolingo-LearnLanguagesforFree"
       "DB6EA5DB.CyberLinkMediaSuiteEssentials"
       "DolbyLaboratories.DolbyAccess"
       "DolbyLaboratories.DolbyAccess"
       "Drawboard.DrawboardPDF"
       "Facebook.Facebook"
       "Fitbit.FitbitCoach"
       "Flipboard.Flipboard"
       "GAMELOFTSA.Asphalt8Airborne"
       "KeeperSecurityInc.Keeper"
       "NORDCURRENT.COOKINGFEVER"
       "PandoraMediaInc.29680B314EFC2"
       "Playtika.CaesarsSlotsFreeCasino"
       "ShazamEntertainmentLtd.Shazam"
       "SlingTVLLC.SlingTV"
       "SpotifyAB.SpotifyMusic"
       "TheNewYorkTimes.NYTCrossword"
       "ThumbmunkeysLtd.PhototasticCollage"
       "TuneIn.TuneInRadio"
       "WinZipComputing.WinZipUniversal"
       "XINGAG.XING"
       "flaregamesGmbH.RoyalRevolt2"
       "king.com.*"
       "king.com.BubbleWitch3Saga"
       "king.com.CandyCrushSaga"
       "king.com.CandyCrushSodaSaga"

   )
   foreach ($Bloat in $Bloatware) {
       Get-AppxPackage -Name $Bloat| Remove-AppxPackage
       Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
       Write-Host "Trying to remove $Bloat."
   }

	##Customization
	Write-Host "Hiding Task View button..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

	Write-Host "Changing default Explorer view to This PC..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
		
	Write-Host "Removing Cortana button from Taskbar"
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
		
        Write-Host "Turn off fast startup - Hibernation"
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 0

        #Password Never to expire
	wmic Useraccount set PasswordExpires=false
	
	
