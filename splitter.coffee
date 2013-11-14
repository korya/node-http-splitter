bouncy = require 'bouncy'
url = require 'url'

# We would like to reread the configuration upon change.
# Simplest solution -- read it once in a while (when needed)
class Config
  CACHE_TIME = 5.0 # 5 seconds
  constructor: (@file = './config.json') ->
    @last_read_uptime = -CACHE_TIME
    @get()
  get: ->
    time_elapsed = process.uptime() - @last_read_uptime
    if time_elapsed > CACHE_TIME
      # XXX Hacky? Yes, but it's just a json file.
      file_path = @file.split '/'
      file_name = file_path[file_path.length - 1]
      for m of require.cache
        module_path = m.split '/'
        module_name = module_path[module_path.length - 1]
        if module_name == file_name
          delete require.cache[m]
      @json = require @file
      @last_read_uptime = process.uptime()
    return @json

forward_port_get = (conf, host) ->
  hostname = url.parse('http://' + host).hostname
  forwards = conf.get().forwards
  forward = forwards[hostname] || forwards['default']
  console.log "Splitter: Redirect #{hostname} to #{forward}"
  forward

conf = new Config()
server = bouncy (req, res, bounce) ->
  bounce forward_port_get conf, req.headers.host

server.listen conf.get().server.port
console.log "Splitter: listening on #{conf.get().server.port}"
