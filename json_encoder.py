import json, datetime, bottle
class MyJsonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime.datetime):
            return str(obj.isoformat())
        elif isinstance(obj, datetime.date):
            return str(obj.isoformat())
        return json.JSONEncoder.default(self, obj)

Plugin = bottle.JSONPlugin(json_dumps=lambda s: json.dumps(s, cls=MyJsonEncoder))
