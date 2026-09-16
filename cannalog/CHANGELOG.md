# Changelog

## [1.1.0] - 2026-09-16

### Behoben
- Ingress und direkter Port funktionieren jetzt gleichzeitig. Der Präfix kommt aus dem
  `X-Ingress-Path`-Header (nur vom Ingress-Proxy akzeptiert), Redirects sind echte
  HTTP-Redirects statt JavaScript-Weiterleitungen.
- Login über `http://…:5000` scheiterte an `Secure`-Cookies und am falschen Cookie-Pfad.
- Eigener Cookie-Name, damit sich CannaLog nicht mit anderen Ingress-Apps die Sitzung teilt.
- Pflanzenaktionen ließen sich nicht bearbeiten (Redirect vor der Berechtigungsprüfung).
- Logout führte im Ingress auf die Home-Assistant-Startseite.
- Beim Löschen von Pflanzen/Umgebungen blieben Log-Einträge und Messwerte verwaist.
- CSRF-Token wurden im Klartext ins Log geschrieben; Debug-Ausgaben entfernt.
- Hochgeladene Bilder waren ohne Login abrufbar.

### Geändert
- Basis-Image Alpine 3.23, aktuelle Flask/WTForms/WeasyPrint-Versionen, `requirements.txt`.
- Nur noch aarch64 und amd64 (Home Assistant unterstützt die 32-Bit-Plattformen nicht mehr).
- Neue Optionen `allow_registration` und `secure_cookies`; `secret_key` wird bei leerem
  Wert automatisch erzeugt. Die Option `insecure` entfällt.
- Port 5000 ist standardmäßig aktiv; Watchdog über `/healthz`.
- Fehlende Datenbankspalten werden beim Start ergänzt.
- Versionsnummer im Footer kommt aus der App-Version.

## [1.0.1] - 2025-09-14
- Erste lauffähige Add-on-Version.
