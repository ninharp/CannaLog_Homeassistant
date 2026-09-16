# CannaLog

CannaLog ist ein privates Grow-Tagebuch: Pflanzen, Umgebungen (Zelte, Räume, Außenbereich),
Messwerte, Aktionen und Bilder, mit Log-Export als Bericht oder PDF.

## Zugriff

Die App ist auf zwei Wegen erreichbar, beide gleichzeitig:

- **Seitenleiste (Ingress):** Eintrag „CannaLog“ in Home Assistant. Funktioniert auch
  von unterwegs über Nabu Casa oder deinen Reverse Proxy.
- **Direkter Port:** `http://<home-assistant-ip>:5000`. Praktisch als Lesezeichen auf dem
  Handy im Heimnetz. Den Port kannst du unter „Netzwerk“ ändern oder leer lassen,
  um den direkten Zugriff abzuschalten.

CannaLog hat eine eigene Benutzerverwaltung. Beim ersten Aufruf registrierst du dich einmal.

## Optionen

| Option | Standard | Bedeutung |
| --- | --- | --- |
| `secret_key` | leer | Schlüssel für Sitzungs-Cookies. Leer lassen: dann wird einmalig ein zufälliger Schlüssel erzeugt und gespeichert. |
| `allow_registration` | `true` | Neue Konten erlauben. Nach dem Anlegen deines Kontos abschalten, vor allem wenn der Port offen ist. |
| `secure_cookies` | `false` | Cookies nur über HTTPS senden. Nur einschalten, wenn **alle** Zugriffswege HTTPS nutzen, sonst klappt der Login über `http://…:5000` nicht mehr. |
| `max_upload_mb` | `20` | Maximale Größe eines Uploads in MB. |
| `debug` | `false` | Ausführlichere Logs. |

## Daten

Datenbank und Bilder liegen in `/share/cannalog/` und bleiben bei Updates und
Neuinstallation erhalten:

- `/share/cannalog/database/cannalog.db`
- `/share/cannalog/uploads/`

Fehlende Tabellen und Spalten älterer Versionen ergänzt die App beim Start automatisch.
