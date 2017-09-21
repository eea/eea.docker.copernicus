# Docker Orchestration for Copernicus Land Monitoring/In Situ

## Installation

1. Install [Docker](https://www.docker.com/).

2. Install [Docker Compose](https://docs.docker.com/compose/).

3. Install [Rancher Compose](http://www.rancher.com)

## Usage

### Development

In order to be able to edit source-code on your machine using your favorite editor, without having to do it inside a Docker container, you'll have to create a new user on your laptop with `uid=500` and use this user for development:

    $ useradd -u 500 zope-www
    $ usermod -a -G docker zope-www
    $ sudo su - zope-www

Now get the source code:

    $ git clone https://github.com/eea/eea.docker.copernicus.git
    $ cd eea.docker.copernicus/devel/land
    $ docker-compose -f source-code.yml up

Start the application:

    $ docker-compose up

Within your favorite browser head to http://localhost:8080,
add a Plone site and install the following add-ons:
* `EEA Plone buildout profile`
* `Copernicus Theme`
* `Land Copernicus Content-Types`

Now you are ready to develop Plone Add-ons within `src` folder:

    $ ls -l src/

Once you're done editing, restart the application and test your changes:

    $ docker-compose restart


### Deployment

[How To Upgrade Copernicus (Land & InSitu)](https://taskman.eionet.europa.eu/projects/copernicus-land-monitoring-service/wiki/HowToUpgradeCopernicus)
