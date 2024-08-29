local _, ns = ...
local u = ns.util

-- https://github.com/Gethe/wow-ui-source/blob/c0f3b4f1794953ba72fa3bc5cd25a6f2cdd696a1/Interface/AddOns/Blizzard_SharedXMLBase/Mixin.lua#L6
local setmetatable, Mixin = setmetatable, Mixin

-- https://github.com/Gethe/wow-ui-source/blob/c0f3b4f1794953ba72fa3bc5cd25a6f2cdd696a1/Interface/AddOns/Blizzard_SharedXMLBase/TableUtil.lua
function u.CopyTables(...)
  local copy = {}
  local t
  for i=1,select("#", ...) do
    t = select(i, ...)
    if t then
      for k, v in pairs(t) do
        copy[k] = v;
      end
    end
  end
	return copy;
end

function u.MergeTable(destination, source)
  for k, v in pairs(source) do
    destination[k] = v;
  end
    return destination
end

function u.Class(parent, fn, defaults)
  local c = {}

  -- define the constructor
  function c:new(o)
    local onLoad = o.onLoad
    o.onLoad = nil
    if defaults then u.CopyTables(defaults, o) end
    o = parent and parent:new(o) or (o or {})
    Mixin(o, parent or {}, c)
    setmetatable(o, self)
    self.__index = self
    fn(o)
    if parent and parent.onLoad then parent.onLoad(o) end
    if c.onLoad then c.onLoad(o) end
    if onLoad then onLoad(o) end
    return o
  end

  return c
end

-- return a new table by transforming each value by the given function
function u.ToMap(t, f)
  local r, x = {}, #t
  for i=1,x do r[t[i]] = f(t[i]) end
  return r
end
