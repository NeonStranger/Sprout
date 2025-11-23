-- main.lua
-- Entry point for the game

-- Core modules
local WORLD = require("core.world")
local Player = require("core.player")
local Inventory = require("core.inventory")
local PLANTING = require("core.planting")
local TOOLS = require("core.tools")


-- UI
local UI = require("ui.ui")
local BUTTONS = require("ui.buttons")

function love.load()

    love.graphics.setFont(love.graphics.newFont(12))
    WORLD.init()
    Player.init()
    PLANTING.init()
    Inventory.init()
    
end

function love.update(dt)
    Player.update(dt)
    PLANTING.update(dt)
end

function love.draw()
    WORLD.render()
    PLANTING.render()
    Player.render()
    UI.render()
    Inventory.render()
end

function love.mousepressed(x,y,b)
    Inventory.mousePressed(x,y,b)
    Player.mousePressed(x,y,b)
end

function love.mousereleased(x, y, b)
    Inventory.mouseReleased(x,y,b)
end

function love.keypressed(key)
    Inventory.keyPressed(key)
end

function love.wheelmoved(x, y)
    Player.wheelScroll(y)
end
