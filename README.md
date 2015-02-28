Wit
===

Wit is an application to trigger an external process when a file has changed
within a directory tree. The tool looks for a file in the local directory
called `.witrc`.

Example `.witrc` for Luvi:

```json
{ "run": {"make", "static"}, "exclude": {"^build"}  }
```

Build
=====

```
lit make
```
