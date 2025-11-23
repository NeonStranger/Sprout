-- utils/utils.lua
local Utils = {}

local SCREEN_WIDTH = love.graphics.getWidth()
local SCREEN_HEIGHT = love.graphics.getHeight()

function Utils.getDistance(ax, ay, bx, by)
    return math.sqrt((bx - ax)^2 + (by - ay)^2)
end

function Utils.centered(width, height)

    return SCREEN_WIDTH / 2 - width / 2, SCREEN_HEIGHT / 2 - height / 2
end

return Utils
