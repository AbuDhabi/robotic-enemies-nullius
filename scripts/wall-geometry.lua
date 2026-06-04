-- Adapted from Castra Prime (GPL-3.0). Pure geometry for enemy base walls.

local function createPoint(x, y)
  return { x = x, y = y }
end

local function negateYCoordinates(points)
  local transformed = {}
  for _, p in ipairs(points) do
    table.insert(transformed, createPoint(p.x, -p.y))
  end
  return transformed
end

local function restoreYCoordinates(points)
  local restored = {}
  for _, p in ipairs(points) do
    table.insert(restored, createPoint(p.x, -p.y))
  end
  return restored
end

local function orientation(p, q, r)
  local val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
  if val == 0 then return 0
  elseif val > 0 then return 1
  else return 2
  end
end

local function distanceSquared(p1, p2)
  return (p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2
end

local function sortByPolarAngle(points, start)
  table.sort(points, function(a, b)
    local o = orientation(start, a, b)
    if o == 0 then
      return distanceSquared(start, a) < distanceSquared(start, b)
    else
      return o == 2
    end
  end)
end

local function grahamScan(points)
  local n = #points
  local ymin = points[1].y
  local min = 1
  for i = 2, n do
    local y = points[i].y
    if (y < ymin) or (y == ymin and points[i].x < points[min].x) then
      ymin = points[i].y
      min = i
    end
  end

  points[1], points[min] = points[min], points[1]
  local start = points[1]

  sortByPolarAngle(points, start)

  local stack = { points[1], points[2], points[3] }
  for i = 4, n do
    while #stack >= 2 and orientation(stack[#stack - 1], stack[#stack], points[i]) ~= 2 do
      table.remove(stack)
    end
    table.insert(stack, points[i])
  end

  return stack
end

local function subtractPoints(p1, p2)
  return { x = p1.x - p2.x, y = p1.y - p2.y }
end

local function addPoints(p1, p2)
  return { x = p1.x + p2.x, y = p1.y + p2.y }
end

local function multiplyPoint(p, s)
  return { x = p.x * s, y = p.y * s }
end

local function vectorLength(v)
  return math.sqrt(v.x * v.x + v.y * v.y)
end

local function normalizeVector(v)
  local length = vectorLength(v)
  return { x = v.x / length, y = v.y / length }
end

local function outwardNormal(p1, p2)
  local edge = subtractPoints(p2, p1)
  return normalizeVector({ x = -edge.y, y = edge.x })
end

local function expandConvexHull(polygon, N)
  local expandedPolygon = {}
  local numVertices = #polygon
  for i = 1, numVertices do
    local prevIndex = (i - 2) % numVertices + 1
    local nextIndex = i % numVertices + 1
    local normal1 = outwardNormal(polygon[prevIndex], polygon[i])
    local normal2 = outwardNormal(polygon[i], polygon[nextIndex])
    local translation = multiplyPoint(normalizeVector(addPoints(normal1, normal2)), N)
    translation = { x = math.floor(translation.x + 0.5), y = math.floor(translation.y + 0.5) }
    table.insert(expandedPolygon, addPoints(polygon[i], translation))
  end
  return expandedPolygon
end

local function plotLine(x0, y0, x1, y1)
  local points = {}
  local dx = x1 - x0
  local dy = y1 - y0
  local nx = math.abs(dx)
  local ny = math.abs(dy)
  local sign_x = dx > 0 and 1 or -1
  local sign_y = dy > 0 and 1 or -1

  local px, py = x0, y0
  table.insert(points, { x = px, y = py })

  local ix, iy = 0, 0
  while ix < nx or iy < ny do
    if (0.5 + ix) / nx < (0.5 + iy) / ny then
      px = px + sign_x
      ix = ix + 1
    else
      py = py + sign_y
      iy = iy + 1
    end
    table.insert(points, { x = px, y = py })
  end

  return points
end

return {
  createPoint = createPoint,
  negateYCoordinates = negateYCoordinates,
  restoreYCoordinates = restoreYCoordinates,
  grahamScan = grahamScan,
  expandConvexHull = expandConvexHull,
  plotLine = plotLine,
}
