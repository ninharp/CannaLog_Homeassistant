# CannaLog für Home Assistant

![Logo](logo.png)

Home-Assistant-App (früher „Add-on“) für [CannaLog](https://github.com/ninharp/CannaLog),
ein privates Grow-Tagebuch für Pflanzen, Umgebungen, Messwerte, Aktionen und Bilder.

- Zugriff über die Seitenleiste (Ingress) **und** direkt über Port 5000
- Log-Export als Bericht oder PDF
- Daten dauerhaft in `/share/cannalog/`
- aarch64 (Raspberry Pi 4/5, Green, Yellow) und amd64

## Installation

[![Repository hinzufügen](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fninharp%2FCannaLog_HomeAssistant)

1. Einstellungen → Apps → App-Store → ⋮ → Repositories →
   `https://github.com/ninharp/CannaLog_HomeAssistant` hinzufügen
2. „CannaLog“ installieren und starten
3. In der Seitenleiste „CannaLog“ öffnen und ein Konto registrieren

Optionen und Details: [cannalog/DOCS.md](cannalog/DOCS.md)

## Entwicklung

App-Code und Image-Build liegen in [ninharp/CannaLog](https://github.com/ninharp/CannaLog).
Dieses Repository enthält nur die App-Definition; Home Assistant lädt das fertige Image
`ghcr.io/ninharp/{arch}-cannalog-addon` aus der GitHub Container Registry.
