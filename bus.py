#!/usr/bin/env python

from bottle import route, request, run, template, install, static_file
from bottle.ext import sqlalchemy
from sqlalchemy import create_engine, Column, Integer, Sequence, String, Enum, ForeignKey, Date, Time
from sqlalchemy.dialects import postgresql
from sqlalchemy.ext.declarative import declarative_base
from geoalchemy2 import Geometry

import bmemcache_plugin

import json
import os

# Guess if we are running on Heroku at the moment
HEROKU = True if os.environ.get("DATABASE_URL", None) else False
DEBUG = not HEROKU
DATABASE_URL = os.environ.get("DATABASE_URL", 'postgresql://kjntea_omsysv:35deb151@spacialdb.com:9999/kjntea_omsysv')
MEMCACHEDCLOUD_SERVERS = os.environ.get('MEMCACHEDCLOUD_SERVERS', 'localhost:11211').split(',')

Base = declarative_base()
engine = create_engine(DATABASE_URL, echo=DEBUG)

plugin = sqlalchemy.Plugin(
    engine, # SQLAlchemy engine created with create_engine function.
    Base.metadata, # SQLAlchemy metadata, required only if create=True.
    keyword='db', # Keyword used to inject session database in a route (default 'db').
    create=True, # If it is true, execute `metadata.create_all(engine)` when plugin is applied (default False).
)

install(plugin)

plugin = bmemcache_plugin.Plugin(
    MEMCACHEDCLOUD_SERVERS,
    os.environ.get('MEMCACHEDCLOUD_USERNAME', None),
    os.environ.get('MEMCACHEDCLOUD_PASSWORD', None)
)

install(plugin)

class BusStop(Base):
    __tablename__ = 'BusStops'

    id = Column(Integer, Sequence('busstops_id_seq'), primary_key=True)
    name = Column(String(50), nullable=False)
    location = Column(Geometry('POINT'), nullable=False)

    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return "<BusStop('%s', '%s', '%s')>" % (self.id, self.name, self.location)

    def __str__(self):
        return "BusStop('%s', '%s', '%s')" % (self.id, self.name, self.location)


class DepartureTime(Base):
    __tablename__ = "Departures"

    id = Column(Integer, Sequence('departures_id_seq'), primary_key=True)
    timetable = Column(ForeignKey('Timetables.id'), nullable=False)
    valid_days = Column(postgresql.ARRAY(String), nullable=False)
    time = Column(Time(), nullable=False)
    bus = Column(String(50), nullable=False)


class Timetable(Base):
    __tablename__ = "Timetables"

    id = Column(Integer, Sequence('timetables_id_seq'), primary_key=True)
    route = Column(ForeignKey('Routes.id'), nullable=False)
    name = Column(String(100), nullable=False)
    valid_from = Column(Date, nullable=False)
    valid_to = Column(Date, nullable=False)


class Route(Base):
    __tablename__ = "Routes"

    id = Column(Integer, Sequence('routes_id_seq'), primary_key=True)
    name = Column(String(100), nullable=False)

    def __str__(self):
        return "Route('%s', '%s')" % (self.id, self.name)

@route('/addstop')
def addstop(db):
    query = request.query.decode()
    name = query['name']
    lat = float(query['lat'])
    lon = float(query['lon'])

    stop = BusStop(name)
    stop.location = 'POINT(%s %s)' % (lon, lat)

    if DEBUG:
        db.add(stop)

    return "Stop: " + str(stop)

@route('/addtimetable')
def add_timetable(db):
    query = request.query.decode()

    name = query['name']
    route = query['route']
    valid_from = ['valid_from']
    valid_to = ['valid_to']

@route('/addroute')
def add_route(db):
    query = request.query.decode()

    name = query['name']

    route = Route(name=name)

    if DEBUG:
        db.add(route)
        db.flush()

    return "Route: %s" % route

@route('/routes')
def get_routes(db):
    query = db.query(Route.id, Route.name)

    routes = []
    for route in query:
        temp = {'id': route.id,
                'name': route.name
                }
        routes.append(temp)

    return {'routes': routes}

@route('/stops')
def getstops(db):

    request_data = request.query.decode()
    if 'lon' in request_data and 'lat' in request_data:
        location = (request.query.decode()['lon'], request.query.decode()['lat'])
        location = 'POINT(%s %s)' % location
    else:
        location = None

    query = db.query(BusStop.id,
                     BusStop.name,
                     BusStop.location.ST_AsGeoJSON().label('geo')
                     )

    if location:
        query = query.add_columns(
                BusStop.location.ST_Distance_Sphere(location).label('distance')
                ).order_by('distance')

    stops = []

    for stop in query:
        print stop
        stop_dict = {'id': stop.id,
                     'name': stop.name,
                     'location': latlon_json(stop.geo)
                     }
        if location:
            stop_dict['distance'] = stop.distance

        stops.append(stop_dict)

    return {"bus_stops": stops}

@route('/nearest')
def getnearestsop(db, mc):
    location = (float(request.query.decode()['lon']), float(request.query.decode()['lat']))
    location = 'POINT({:.4f} {:.5f})'.format(*location)

    stop = mc.get("USERLOC:" + location)
    if not stop:
        stop = db.query(BusStop.id,
                         BusStop.name,
                         BusStop.location.ST_AsGeoJSON().label('geo'),
                         BusStop.location.ST_Distance_Sphere(location).label('distance')
                         ).order_by('distance').first()

        mc.set("USERLOC:" + location, stop)

    return {'id': stop.id,
            'name': stop.name,
            'distance': stop.distance,
            'location': latlon_json(stop.geo)
            }

@route('/delete')
def deleteallstops(db):
    if DEBUG:
        db.query(BusStop).delete()

@route('/')
def show_home():
    return template('main')

@route('/static/<path:path>')
def callback(path):
    return static_file(path, root="./static/")

def latlon_json(geoStr):
    geoJSON = json.loads(geoStr)
    cords = geoJSON['coordinates']
    return {'lon': cords[0], 'lat': cords[1]}

if HEROKU:
    run(host='0.0.0.0', port=int(os.environ.get("PORT", 5000)), server='gunicorn', workers=4)
else:
    run(host='0.0.0.0', port=8080, debug=True, reloader=True)
