#!/bin/sh
docker-compose -f docker-compose.yml up -d plone
docker-compose -f docker-compose.yml exec plone bash
