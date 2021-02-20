##Windows 10 basic software installer + debloater + customization, more features to be added.
##Chocolatey install
Write-Host "Installing Chocolatey"
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y

##Chocolatey app List
Write-Host "Installing Base Apps"
choco install vlc -y
choco install 7zip.install -y
choco install googlechrome -y
choco install firefox -y
choco install notepadplusplus -y
#choco install putty -y
Write-Host "Installing Runtimes"
choco install vcredist140 -y
choco install adobeair -y
choco install dotnetfx -y
choco install silverlight -y
Write-Host "Installing Commercial Apps"
choco install adobereader -y
choco install shutup10 -y
choco install googleearthpro -y
choco install zoom -y
choco install office365business -y
choco install microsoft-teams.install -y
choco install vscode -y
choco install sketchbook -y #WW only
#choco install slack -y #TMH only
#choco install sonos-controller -y #TMH only

##Enable NET3.5 for legacy products (Bentley)
Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3"

##Windows Privacy Settings with O&O Shutup NEED REVIEWING THIS List
    Write-Host "Running O&O Shutup with Recommended Settings"
	Import-Module BitsTransfer
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/pakyrs/win10script/master/ooshutup10.cfg" -Destination ooshutup10.cfg
	Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
	./OOSU10.exe ooshutup10.cfg /quiet

##Windows Telemetry
    Write-Host "Disabling Telemetry..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
    
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
		
	 	## Write-Host "Hiding People icon..."
	 ##	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
	 ##		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
	 ##	}
	 ##	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0

	 	## Write-Host "Showing all tray icons..."
	 ##	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0


##VFX for performance - TBC
    #Write-Host "Adjusting visual effects for performance..."
	#Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 0
	#Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 0
	#Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))
	#Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0
	#Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 0
	#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 0
	#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 0
	#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Type DWord -Value 0
	#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 3
	#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 0

#More to follow
##Creative Cloud is not silent, please sign in and also deploy with trial PS IN IL ACDC (might need reboot)
choco install adobe-creative-cloud -y
