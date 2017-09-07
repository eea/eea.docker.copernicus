# Copernicus FTP support

* Create

        $ docker-compose pull
        $ docker-compose up -d

* Build

        $ docker exec -it ftp_copernicus_1 bash
        $ buildout

* Start

        $ bin/instance fg


* Setup
    * **Add a Plone Site** within http://localhost:8080
    * Install **land.copernicus.downloads** add-on

* Test
    * HTTP: http://localhost:8080
    * FTP:  http://localhost:8021
    * Credentials: `admin / admin`
    * Go to **ZMI > Plone > files** to see ZIP files from **/data/downloads/files** Docker volume
    * Do the same with a **FTP client**
