node-http-splitter
==================

HTTP traffic splitter implemented on Node.js platform. May be someday it will become a fully functional reverse proxy.

Config file example:
```shell
$ cat ./config.json
{
  "server": {
    "port": 80
  },
  "forwards": {
    "default": 9000,
    "wiki.example.com": 9010,
    "blog.example.com": 9020,
    "git.example.com": 9030,
  }
}
```
