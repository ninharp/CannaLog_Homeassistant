# CannaLog Home Assistant Add-on

![Logo](https://raw.githubusercontent.com/ninharp/CannaLog/main/app/static/assets/logo.png)

A Home Assistant add-on for the CannaLog plant management application.

## About

CannaLog ist eine moderne, private Web-App zur Verwaltung von Pflanzen, Umgebungen, Messwerten, Aktionen und Bildern – optimiert für Desktop und Smartphone. Diese Add-on-Version bringt CannaLog direkt in deine Home Assistant Installation mit vollständiger Ingress-Unterstützung.

## Features

- 🌱 Pflanzen- und Umgebungsverwaltung
- 📊 Messwerte-Logging (Temperatur, Feuchtigkeit, pH, EC, etc.)
- 📝 Aktionen-Log für Pflanzen (Gießen, Düngen, Umtopfen)
- 📸 Bild-Upload und -verwaltung
- 📱 Responsive Design für Desktop und Mobile
- 🔗 Vollständige Home Assistant Integration mit Ingress
- 📂 Persistente Datenspeicherung

## Installation

1. Füge dieses Repository zu deinen Home Assistant Add-on Repositories hinzu
2. Installiere das "CannaLog" Add-on
3. Konfiguriere das Add-on nach deinen Wünschen
4. Starte das Add-on
5. Greife über die Home Assistant Seitenleiste auf CannaLog zu

## Konfiguration

```yaml
secret_key: "dein-sehr-geheimer-schluessel"
debug: false
```

## Datenpersistenz

Alle Daten werden im `/share/cannalog/` Verzeichnis gespeichert und bleiben bei Updates erhalten.

## Original Repository

Basiert auf: [CannaLog by ninharp](https://github.com/ninharp/CannaLog)