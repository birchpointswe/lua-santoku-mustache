local env = {
  name = "santoku-mustache",
  version = "2.1.0-1",
  license = "MIT",
  public = true,
  dependencies = {
    "lua == 5.1",
    "santoku >= 2.0.0, < 3.0.0",
  },
  vendor = {
    {
      file = "deps/mustach/mustach-1.2.10.tar.gz",
      url = "https://gitlab.com/jobol/mustach/-/archive/1.2.10/mustach-1.2.10.tar.gz",
      sha256 = "95a2a351e748db9eeb98f40ba8bfbf010c1c6d2e725d31a3c7e602526d05bf90",
    },
  },
  cflags = {
    "-I$(shell luarocks show santoku --rock-dir)/include/",
    "-I$(PWD)/deps/mustach/mustach-1.2.10/",
  },
  ldflags = {
    "$(PWD)/deps/mustach/mustach-1.2.10/libmustach.a"
  },
  test = {
    wasm = {
      ldflags = {
        "-sALLOW_TABLE_GROWTH=1",
        "-sEMULATE_FUNCTION_POINTER_CASTS=1"
      }
    }
  }
}

env.homepage = "https://github.com/birchpointswe/lua-" .. env.name
env.tarball = env.name .. "-" .. env.version .. ".tar.gz"
env.download = env.homepage .. "/releases/download/" .. env.version .. "/" .. env.tarball

return { env = env }
