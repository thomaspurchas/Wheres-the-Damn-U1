#!/usr/bin/env python
#
# -*- mode:python; sh-basic-offset:4; indent-tabs-mode:nil; coding:utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

import bmemcached
import inspect


class MemcachePlugin(object):

    name = 'bmemcache'

    def __init__(self, servers=['localhost:11211', ],
                 username=None,
                 password=None,
                 keyword='mc'
                 ):

        self.servers = servers
        self.username = username
        self.password = password
        self.keyword = keyword

    def setup(self, app):
        for other in app.plugins:
            if not isinstance(other, MemcachePlugin):
                continue
            if other.keyword == self.keyword:
                raise PluginError("Found another memcache plugin with "\
                        "conflicting settings (non-unique keyword).")

    def apply(self, callback, context):
        conf = context['config'].get('memcache') or {}
        self.servers = conf.get('servers', self.servers)
        self.keyword = conf.get('keyword', self.keyword)
        self.username = conf.get('username', self.username)
        self.password = conf.get('password', self.password)

        args = inspect.getargspec(context['callback'])[0]
        if self.keyword not in args:
            return callback

        def wrapper(*args, **kwargs):
            mc = bmemcached.Client(servers=self.servers,
                username=self.username,
                password=self.password
                )
            kwargs[self.keyword] = mc
            rv = callback(*args, **kwargs)
            return rv
        return wrapper

Plugin = MemcachePlugin
