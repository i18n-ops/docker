#!/usr/bin/env coffee

> zx/globals:
  @3-/uridir

< default main = =>
  ROOT = uridir(import.meta)
  cd ROOT

  await $"ls #{ROOT}"
  await $'pwd'
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()
