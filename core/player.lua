local World = require("core.world")
local Inventory = require("core.inventory")
local Items = require("core.items")
local Planting = require("core.planting")


local Player = {
    x = 100,
    y = 100,
    speed = 160,
    facingDirection = 1,         -- up, down, left, right
    gold = 5,
    image = love.graphics.newImage("assets/images/character.png")

}

local TILE_SIZE = World.tileSize
local INTERACT_DISTANCE = 96

function Player.init()

end

function Player.update(dt)
    local moveX, moveY = 0, 0

    if love.keyboard.isDown("w") then moveY = -1; Player.facing = "up" end
    if love.keyboard.isDown("s") then moveY = 1;  Player.facing = "down" end
    if love.keyboard.isDown("a") then moveX = -1; Player.facing = "left" end
    if love.keyboard.isDown("d") then moveX = 1;  Player.facing = "right" end

    -- Sprinting
    local effectiveSpeed = love.keyboard.isDown("lshift") and 260 or Player.speed
    Player.x = Player.x + moveX * effectiveSpeed * dt
    Player.y = Player.y + moveY * effectiveSpeed * dt
end

function Player.render()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Player.image, Player.x, Player.y)
end


-- Get the grid tile in front of the player
local function getFacingTile()
    local px, py = Player.x + 32, Player.y + 64 -- feet center
    local tx, ty = px, py

    if Player.facing == 1 then ty = ty - TILE_SIZE
    elseif Player.facing == 2 then ty = ty + TILE_SIZE
    elseif Player.facing == 3 then tx = tx - TILE_SIZE
    elseif Player.facing == 4 then tx = tx + TILE_SIZE
    end

    return World.getTileAt(tx, ty)
end

-- Called on left click or space
function Player.interact()
    local tile = getFacingTile()
    if not tile then return end

    local selectedItem = Inventory.getHeldItem()
    print(selectedItem.name)
    -- Example logic for hoe usage
    if selectedItem and selectedItem.type == "hoe" then
        print("hoe hoe hoe")
        if tile.type == "grass" then
            tile.type = "soil"
        end

    elseif selectedItem and selectedItem.type == "seed" and tile.type == "soil" then
        local canPlace = Planting.place(selectedItem.id, gridX, gridY)
        if canPlace then
            Inventory.remove(selectedSlot.id, 1)
        end
    end

end

function Player.mousePressed(x,y,b)

    if Player.inInventory then return end

    Player.interact()
    
    -- Handle planting
    
    -- ✅ Handle harvesting regardless of selected item
    --[[
    if tile.type == "soil" then
        local isGrown, plant = Planting.isGrownAt(gridX, gridY)
        if isGrown then
            local def = Planting.plantData[plant.type]
            Inventory.add(def.harvestItem, def.harvestQuantity)
            Planting.removeAt(gridX, gridY)
            tile.type = "grass"
        end
    end
]]
end

return Player
