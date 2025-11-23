local TILES = require("assets.tiles") -- must return table with .grass, .soil images

local World = {}

World.tileSize = 64
World.width = 30
World.height = 16
World.tiles = {} -- 2D grid: tiles[x][y] = { type = "grass" }

-- Initialize grid with grass
function World.init()
    for x = 1, World.width do
        World.tiles[x] = {}
        for y = 1, World.height do
            World.tiles[x][y] = { type = "grass" }
        end
    end
end

-- Converts pixel to grid (1-indexed)
function World.toGrid(px, py)
    return math.floor(px / World.tileSize) + 1, math.floor(py / World.tileSize) + 1
end

-- Converts grid to pixel
function World.toPixel(gridX, gridY)
    return (gridX - 1) * World.tileSize, (gridY - 1) * World.tileSize
end

-- Returns tile at pixel coordinate
function World.getTileAt(px, py)
    local gx, gy = World.toGrid(px, py)
    return World.tiles[gx] and World.tiles[gx][gy] or nil
end

-- Returns tile at grid coordinate
function World.getTile(gx, gy)
    return World.tiles[gx] and World.tiles[gx][gy] or nil
end

function World.setTile(gx, gy, tileType)
    if World.tiles[gx] and World.tiles[gx][gy] then
        World.tiles[gx][gy].type = tileType
    end
end

function World.render()
    for x = 1, World.width do
        for y = 1, World.height do
            local tile = World.tiles[x][y]
            local img = nil

            if tile.type == "grass" then
                img = TILES.grass
            elseif tile.type == "soil" then
                img = TILES.soil
            end

            if img then
                local px, py = World.toPixel(x, y)
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(img, px, py)
            end
        end
    end
end

return World
