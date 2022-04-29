# FortiAVDeployer
Se automatiza el despliegue y registro de dispositivos finales al antivirus FortiClient EMS

El Script detectará si el servicio de FortiClient existe en el dispositivo final, esto sirve como prueba para determinar si esta o no esta instalado.

# Instalación
Si FortiClient no esta instalado el script empezará a ejecutar la tarea de instalación, para ello se utilizan el MSI y MST descargados desde el mismo FortiClient EMS. Estos archivos se deben compartir mediante un file server de manera que sean alcanzables para los equipos que van a instalar el FortiClient.

Luego de la instalación se crea una tarea programada que utiliza un link de invitacion generado en el FortiClient EMS para hacer un registro automatico sin la intervencion del usuario.

# Registro
En caso de que el equipo tenga FortiClient instalado el script procedera a ejecutar la tarea de registro utilizando el link de invitacion.
