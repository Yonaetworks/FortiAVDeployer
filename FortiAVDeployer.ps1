#Se intenta identificar el servicio de FortiClient corriendo en el equipo.
try {

    $isInstalled = Get-Service -Name "FCT_SecSvr" -ErrorAction Stop

#Si no se encuentra se agrega valor "No Encontrado"
}catch {

    $isInstalled = "No Encontrado"
}

#Se guardan valores de interes para realizar los posteriormente.
$hostname = hostname
$date = Get-Date

if ($isInstalled.Name -eq "FCT_SecSvr") {
    
    #Si esta instalado se dispara instalacion de tarea de registro

    [system.Diagnostics.Process]::Start('iexplore','fabricagent://ems?inviteCode=**TOKEN DE INVITACION, GENERADO POR EL LINK EN FORTICLIENT EMS**')
    
    #Se instalan logs para dar seguimiento a las tareas realizadas
    $log = $hostname + "," + $date + "," + "Registration"
    #Especificar ruta deseada para los logs
    $logpath = "" + $hostname + ".csv"
    Add-Content $logpath $log

}else {                                                                    
    
    #Si no está instalado se crea una tarea para el registro de la aplicacion
    
    Unregister-ScheduledTask -TaskName "FortiClient-Registration" -Confirm:$false
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\ProtocolExecute" -Name fabricagent -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\ProtocolExecute\fabricagent" -Name 'WarnOnOpen' -Value 0 -PropertyType DWord -Force
    $timespan = New-TimeSpan -Minutes 60
    $trigger1 = New-ScheduledTaskTrigger -Daily -At 8:00am
    $trigger2 = New-ScheduledTaskTrigger -Once -At 8:00am -RepetitionInterval $timespan
    $trigger1.Repetition = $trigger2.Repetition
    $arguments = "-Command &{[system.Diagnostics.Process]::Start('iexplore','fabricagent://ems?inviteCode=**TOKEN DE INVITACION, GENERADO POR EL LINK EN FORTICLIENT EMS**')}"
    $action = New-ScheduledTaskAction -Execute powershell -Argument $arguments
    Register-ScheduledTask -Action $action -Trigger $trigger1 -TaskPath "FortiClient" -TaskName "FortiClient-Registration" -User "ADMIN-USER" -Password "ADMIN-PASSWORD" -Description "Tarea para registro de FortiClient EMS"

    #Se instalan logs para dar seguimiento a la tarea realizada
    $log = $hostname + "," + $date + "," + "Install"
    
    #Especificar ruta deseada para los logs
    $logpath = "" + $hostname + ".csv"
    Add-Content $logpath $log

    #Se dispara proceso de instalacion de FortiClient         
    $params = '/i', 'RUTA DEL MSI',
          'REBOOT=ReallySuppress', '/qn',
          'TRANSFORMS=**RUTA DEL MST**'

    $p = Start-Process 'msiexec.exe' -ArgumentList $params -NoNewWindow -Wait -PassThru   
    $p.ExitCode
}
