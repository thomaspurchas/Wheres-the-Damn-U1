#!/usr/bin/env python

from bottle import route, request, run, template, install, static_file
from bottle.ext import sqlalchemy
from sqlalchemy import create_engine, Column, Integer, Sequence, String, Enum, ForeignKey, Date, Time, UniqueConstraint
from sqlalchemy.orm import relationship, backref
from sqlalchemy.dialects import postgresql
from sqlalchemy.ext.declarative import declarative_base
from geoalchemy2 import Geography

import bmemcache_plugin
import json_encoder

import json
import os
import datetime

DAYS = ['SUN', 'MON', 'TUE', 'WED', 'THUR', 'FRI', 'SAT']

# Guess if we are running on Heroku at the moment
HEROKU = True if os.environ.get("DATABASE_URL", None) else False
DEBUG = not HEROKU
DATABASE_URL = os.environ.get("DATABASE_URL", 'postgresql://kjntea_omsysv:35deb151@spacialdb.com:9999/kjntea_omsysv')
MEMCACHEDCLOUD_SERVERS = os.environ.get('MEMCACHEDCLOUD_SERVERS', 'localhost:11211').split(',')

Base = declarative_base()
engine = create_engine(DATABASE_URL, echo=DEBUG, pool_recycle=3600)

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

install(json_encoder.Plugin)

class BusStop(Base):
    __tablename__ = 'BusStops'

    id = Column(Integer, Sequence('busstops_id_seq'), primary_key=True)
    name = Column(String(50), nullable=False)
    location = Column(Geography('POINT', srid=4326), nullable=False)

    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return "<BusStop('%s', '%s', '%s')>" % (self.id, self.name, self.location)

    def __str__(self):
        return "BusStop('%s', '%s', '%s')" % (self.id, self.name, self.location)


class DepartureTime(Base):
    __tablename__ = "Departures"

    id = Column(Integer, Sequence('departures_id_seq'), primary_key=True)
    timetable_id = Column(ForeignKey('Timetables.id'), nullable=False)
    bus_stop_id = Column(ForeignKey('BusStops.id'), nullable=False)
    valid_days = Column(postgresql.ARRAY(String), nullable=False)
    time = Column(Time(), nullable=False)
    destination = Column(String(50))

    timetable = relationship("Timetable", backref=backref('departure_times', order_by=id))
    bus_stop = relationship("BusStop", backref=backref('departure_times', order_by=id))

    __table_args__ = (
        UniqueConstraint('timetable_id', 'time', 'destination', 'valid_days'),
        )

    def to_JSON(self):
        return {
            'id': self.id,
            'timetable': self.timetable_id,
            'route_number': self.timetable.route.number,
            'destination': self.destination,
            'time': self.time,
            'valid_days': self.valid_days
        }


class Timetable(Base):
    __tablename__ = "Timetables"

    id = Column(Integer, Sequence('timetables_id_seq'), primary_key=True)
    route_id = Column(ForeignKey('Routes.id'), nullable=False)
    name = Column(String(100), nullable=False)
    valid_from = Column(Date, nullable=False)
    valid_to = Column(Date, nullable=False)

    route = relationship("Route", backref=backref('timetables', order_by=id))

    def to_JSON(self):
        return {
            'id': self.id,
            'route': self.route.id,
            'route_number': self.route.number,
            'name': self.name,
            'valid_from': self.valid_from,
            'valid_to': self.valid_to
        }

class Route(Base):
    __tablename__ = "Routes"

    id = Column(Integer, Sequence('routes_id_seq'), primary_key=True)
    name = Column(String(100), nullable=False)
    number = Column(String(5), nullable=False)

    def __str__(self):
        return "Route('%s', '%s', '%s')" % (self.id, self.name, self.number)

    def to_JSON(self):
        return {
            'id': self.id,
            'name': self.name,
            'number': self.number
        }

@route('/addstop')
def add_stop(db):
    query = request.query.decode()
    name = query['name']
    lat = float(query['lat'])
    lon = float(query['lon'])

    stop = BusStop(name)
    stop.location = 'POINT(%s %s)' % (lon, lat)

    if DEBUG:
        db.add(stop)

    return "Stop: " + str(stop)

@route('/adddeparture')
def add_departure_time(db):
    query = request.query.decode()
    timetable = db.query(Timetable).filter_by(id=query['timetable']).one()
    valid_days = query['days'].split(',')
    time = query['time'] + " Europe/London"
    destination = query.get('dest', None)
    stop = db.query(BusStop).filter_by(id=query['stop']).one()

    if valid_days == ['WEEK']:
        valid_days = ['MON', 'TUE', 'WED', 'THUR', 'FRI']
    elif valid_days == ['END']:
        valid_days = ['SAT', 'SUN']
    else:
        valid_days = [day.upper().strip() for day in valid_days if day.upper().strip() in DAYS]

    dt = DepartureTime(
        timetable=timetable,
        valid_days=valid_days,
        time=time,
        destination=destination,
        bus_stop=stop
    )

    if DEBUG:
        db.add(dt)
        db.flush()

    return {'departure_time': dt.to_JSON()}

@route('/departures')
def get_departures(db):
    departures = [d.to_JSON() for d in db.query(DepartureTime)]

    return {"departures": departures}

@route('/addtimetable')
def add_timetable(db):
    query = request.query.decode()

    name = query['name']
    route = query['route']
    valid_from = query['valid_from']
    valid_to = query['valid_to']

    route = db.query(Route).filter_by(id=route).one()

    t_table = Timetable(
        name=name,
        route=route,
        valid_from=valid_from,
        valid_to=valid_to
    )

    if DEBUG:
        db.add(t_table)
        db.flush()

    return {'timetable': t_table.to_JSON()}

@route('/timetables')
def get_timetables(db):
    t_tables = [t.to_JSON() for t in db.query(Timetable)]

    return {"timetable": t_tables}

@route('/addroute')
def add_route(db):
    query = request.query.decode()

    name = query['name']
    number = query['number']

    route = Route(name=name, number=number)

    if DEBUG:
        db.add(route)
        db.flush()

    return "Route: %s" % route

@route('/routes')
def get_routes(db):
    query = db.query(Route)

    routes = [route.to_JSON() for route in query]

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
                BusStop.location.ST_Distance(location).label('distance')
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
                         BusStop.location.ST_Distance(location).label('distance')
                         ).order_by('distance').first()

        mc.set("USERLOC:" + location, stop)

    # Quick botch to use the Gate house times for engineering
    stop_id = 8 if stop.id == 9 else stop.id

    now_time = datetime.datetime.utcnow().time()
    bus = mc.get("USERSTOP:" +  str(stop_id) + "USERTIME:" + now_time.strftime("%H%M"))
    if not bus:
        bus = db.query(DepartureTime).filter_by(bus_stop_id=stop_id).\
                                      filter(DepartureTime.time >= now_time).\
                                      order_by('time').first()

        if bus:
            bus = bus.to_JSON()

        mc.set("USERSTOP:" +  str(stop_id) + "USERTIME:" + now_time.strftime("%H%M"), bus)

    return {
            'stop': {
                'id': stop.id,
                'name': stop.name,
                'distance': stop.distance,
                'location': latlon_json(stop.geo)
                },
            'next_bus': bus
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

if __name__ == "__main__":
    print 'DEBUG =', DEBUG
    if HEROKU:
        run(host='0.0.0.0', port=int(os.environ.get("PORT", 5000)), server='gunicorn', workers=4)
    else:
        run(host='0.0.0.0', port=8080, debug=True, reloader=True)
