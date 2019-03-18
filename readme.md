# Basis Setup für Wordpress mit Composer und Docker

Dieses Repo dient als Boilerplate für neue Wordpress Installationen, die entwicklerfreundlich und "hoffentlich" einfach zu deployen sind.
Es werden natürlich wie so oft diverse Annahmen angenommen.

Es ist eine laufende Instanz vom Traefik-DNS Projekt am Laufen.
Sollte letzteres noch nicht der Fall sein, ist hier die (Anleitung)[https://gitlab.com/talentplatforms/docker-images/traefik-dns]


## Was ist Composer?

Composer ist ein Paketmanager für PHP, ähnlich wie Bundler in der Ruby-Welt.
Die gebräuchlichsten Commands sind:

```
composer install -n
composer update -n
```
Mehr Information gibt es auf der offiziellen (Composer-Seite)[https://getcomposer.org/doc/]

Wordpress verwendet eine eigenes Repository für die Themes und Plugins.
Dieses könnt ihr unter https://wpackagist.org/ finden.

## Struktur

Die Struktur im laufenden Betrieb sieht wie folgt aus:

```
.
├── app
│   └── WORDPRESS_FILES FROM MOUNT
├── data
│   ├── db
│   ├── docker
│   │    ├── webpack
│   │    │    ├── Dockerfile
│   │    │    └── entrypoint.sh
│   │    └── wordpress
│   │         ├── Dockerfile
│   │         └── files
│   └── mysql_init
├── .env-example
├── .gitignore
├── composer.local.json
├── docker-compose.yml
└── readme.md
```

Der `app` Ordner beinhaltet während des Betriebs die eigentlichen Wordpress Dateien.
Diese leben im Kontext des Containers. Änderungen an Dateien hier sind nur von temporärer Wirkung!

`composer.local.json` ist der Punkt, an dem die projektspezifischen Pakete eingetragen werden.
Letztere werden im Kontext der Build-Routine mit den Standardpaketen des Images gemerged.

`data` per Konvention, leben hier Daten, die sonst nirgendwoe so richtig hingehören und so was wie Daten :D.

`data/db`: Mount-Punkt für die MySQL-Datenbank, der zur Laufzeit erzeugt wird. Hier liegen eure Daten aus der Datenbank.

`data/docker`: Die eingesetzten Docker-Images sind hier verortet. z.B. Wordpress oder Webpack. Für eine besseres Verständnis, einfach mal reinschauen.

`data/mysql_init` wird vom mysql-Service verwendet um die Datenbank mit bestehenden Daten zu initialisieren.

`.env.example` dient als Beispiel welche Umgebungsvariablen verwendet werden können.

## Env
Damit unser Setup funktioniert, müssen wir eine Reihe von Umgebungsvariablen setzen.

```
# mysql params
# hierzu muss man vermutlich nicht so viel sagen ;)
MYSQL_ROOT_PASSWORD=1234_change_me
MYSQL_DATABASE=wp_database
MYSQL_USER=wp_database_user
MYSQL_PASSWORD=wp_database_user_password

# all wordpress db settings
WORDPRESS_DB_HOST=db # der Name des Docker Services: https://docs.docker.com/v17.09/engine/userguide/networking/#bridge-networks
WORDPRESS_DB_NAME=wp_database # gleicher Wert wie $MYSQL_DATABASE
WORDPRESS_DB_USER=wp_database_user # gleicher Wert wie $MYSQL_USER
WORDPRESS_DB_PASSWORD=wp_database_user_password # gleicher Wert wie $MYSQL_PASSWORD
WORDPRESS_TABLE_PREFIX=wp_ # Präfix für die Tabellen in der Datenbank

WORDPRESS_HOME=https://example.com # Setzt WP_HOME in der wp-config
WORDPRESS_HTML_ERRORS=1 # Setzt ein Flag aus der ini_set('html_errors', FLAG); mögliche Werte true oder false
WORDPRESS_DEBUG=1 # setzt WP_DEBUG Werte: true | false, bzw 1 | 0
WORDPRESS_AUTO_UPDATE_CORE=0 # soll der Wordpress Core automatisch geupdated werden? Vermutlich nein
WORDPRESS_ENV=development # In welcher Umgebung befinden wir uns? Hat Auswirkungen auf die installierten Plugins siehe: wordpress/files/app/composer.json (require-dev)

# these settings are needed by the installation process
WORDPRESS_ADMIN_NAME=admin@example.com # Name des Admins
WORDPRESS_ADMIN_PASSWORD=1234_please_change_me! # Password des Admins
WORDPRESS_ADMIN_EMAIL=admin@example.com # Mail-Adresse des Admins
WORDPRESS_TITLE=Mein erstes Wordpress :) # Der Titel der Wordpress-Seite
WORDPRESS_THEME=twentynineteen # Das Theme welches aktiviert werden soll, bspw. tpde-blog
WORDPRESS_LANG=de_DE # Die Sprache in der Wordpress zur Verfügung stehen soll
```

### Best Practices

Die Werte der Datenbank Variablen sollten in der Regel wie folgt aussehen:
Projektname: blog.talentplatforms.de
Short: blogtpde

```
MYSQL_DATABASE=blogtpde_db
MYSQL_USER=blogtpde_user
WORDPRESS_TABLE_PREFIX=blogtpde_
```

## Setup

1. Kopier die `.env-example` Datei und benenne als `.env`.
2. Setzte deine gewünschten Umgebungsvariablen in dieser Datei.
3. Mach ggf. Anpassung an der `docker-compose.yml`.
4. Pakete in der `composer.local.json`hinzufügen. Pakete sind hier zufinden: https://wpackagist.org/
5. `docker-compose up`
6. Warten.
7. ???
8. https://DEIN-ERSTES-WORDPRESS.localhost


## Production

Um das ganze Projekt in einer Produktionsumgebung verwenden zu können,
führe einfach folgenden Befehl aus:

`docker-composer -f docker-compose.prod.yml up`
