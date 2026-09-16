# Changelog

## [1.2.0] - 2026-09-16

### Geändert
- Neue Oberfläche: Übersicht nach Umgebung mit Phasenleiste, Tag-Zähler, letzter Aktion und
  aktuellem Klima; Detailseiten mit Logbuch als Zeitleiste und echten Messwerten statt Symbolen.
- Schnellleiste am Handy für Aktion, Messung und Foto; alle Formulare fürs Handy überarbeitet.
- Kein Bootstrap und keine CDN-Abhängigkeit mehr, die Oberfläche lädt auch ohne Internet.
- Bericht neu aufgebaut, PDF enthält jetzt alle Pflanzen der Umgebung, wenn keine gewählt ist.
- Nach dem Speichern geht es zurück zur Pflanze bzw. Umgebung statt zur Übersicht.
- Lampen und Maße einer Umgebung sind optional (z. B. für draußen), weitere Lampen lassen sich hinzufügen.

### Behoben
- Leere Notizen wurden als „None“ angezeigt.
- Messungen lassen sich jetzt auch aus der Bearbeitung heraus löschen.

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
