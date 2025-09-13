# Home Assistant Add-on: CannaLog

## About

CannaLog ist eine moderne, private Web-App zur Verwaltung von Pflanzen, Umgebungen, Messwerten, Aktionen und Bildern – optimiert für Desktop und Smartphone. Die Anwendung basiert auf Flask, SQLAlchemy und Bootstrap und bietet ein intuitives, responsives Dashboard für Grow- und Pflanzenprojekte.

## Features

- Pflanzen- und Umgebungsverwaltung mit Bildern und Notizen
- Logbuch für Messwerte (z.B. Temperatur, Feuchtigkeit, pH, EC, Licht, etc.)
- Aktionen-Log für Pflanzen (z.B. Gießen, Düngen, Umtopfen)
- Bild-Upload für Pflanzen und Umgebungen
- Auswahl von Vorschaubildern
- Responsive UI für Desktop und Mobile
- Zwei-Schritt-Bestätigung beim Löschen von Umgebungen mit Pflanzen
- Übersichtliche Dashboards und Detailansichten

## Installation

1. Add this repository to your Home Assistant Supervisor add-on store
2. Install the "CannaLog" add-on
3. Configure the add-on (see configuration section)
4. Start the add-on
5. Access CannaLog through the Home Assistant sidebar

## Configuration

### Option: `secret_key`

The secret key used for session management and security. Change this to a random, secure value for production use.

### Option: `debug`

Set to `true` to enable debug mode. Only recommended for development/troubleshooting.

```yaml
secret_key: "your-very-secret-key-here"
debug: false
```

## Data Persistence

All data (database and uploaded images) is stored in the `/share/cannalog/` directory, which is persistent across add-on updates and restarts.

- Database: `/share/cannalog/database/cannalog.db`
- Uploads: `/share/cannalog/uploads/`

## Accessing CannaLog

Once the add-on is running, CannaLog will be accessible through the Home Assistant sidebar. The application provides a complete plant management interface directly within your Home Assistant installation.

## Support

For issues and feature requests, please visit the [GitHub repository](https://github.com/ninharp/CannaLog_Homeassistant).

Original CannaLog application by [ninharp](https://github.com/ninharp/CannaLog).