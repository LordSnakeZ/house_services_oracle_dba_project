#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════════════════╗
# ║ @Autores:       Chávez Mejía Luis Héctor                             ║
# ║                 Sánchez Sánchez Santiago                              ║
# ║ @Fecha creación: 10/06/2025                                           ║
# ║ @Descripción:    Configura la tarea CRON para ejecutar la simulación   ║
# ║                  de carga diaria del proyecto                         ║
# ╚═══════════════════════════════════════════════════════════════════════╝

# Comprueba si ya existe la tarea CRON para s-17-cron_simulacion_carga.sh
if crontab -l | grep -q "s-17-cron_simulacion_carga.sh"; then
  echo "La tarea CRON ya está configurada."
  crontab -l | grep "s-17-cron_simulacion_carga.sh"
  exit 0
fi

# Añade un comentario descriptivo al crontab
#Revisar Ruta: comprueba si el path al script de simulación coincide (/unam/bda/scripts/...)
(crontab -l 2>/dev/null; echo "# Simulación diaria de carga - Proyecto BDA") | crontab -

# Programa la ejecución diaria a las 20:00 horas
# Revisa que la ruta al script sea correcta en el entorno de producción
#Revisar Ruta: /unam/bda/scripts/s-17-cron_simulacion_carga.sh
(crontab -l 2>/dev/null; echo "0 20 * * * /unam/bda/scripts/s-17-cron_simulacion_carga.sh") | crontab -

echo "Configuración CRON agregada para ejecutar diariamente a las 20:00"
