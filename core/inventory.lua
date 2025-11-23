-- Item stacking, hotbar, inventory UI
local Items = require("core.items")
local Utils = require("utils.utils")

local TILE_SIZE = 64
local ROWS, COLS = 5, 5 -- Main inventory grid dimensions
local HOTBAR_HEIGHT = 600

local SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getWidth(), love.graphics.getHeight()


local slot_bg = love.graphics.newImage("assets/images/slot_bg.png")

local Inventory = {
    
    Slots = {
        { id = "hoe", count = 1 },
        { id = "parsnip_seed", count = 10 },
    },              -- All inventory slots

    currentSlot = 1,
    maxSlots = 30,           -- 5 hotbar + 25 inventory
    maxStack = 99,

    isDragging = false,      -- True if dragging an item
    draggedSlot = nil,       -- Index of slot being dragged
    draggedItem = nil,        -- Data of the dragged item

    enabled = false,

}
print("Inventory module loaded:", Inventory)

function Inventory.init()

end

function Inventory.getSlots()
    return Inventory.Slots
end

function Inventory.addItem(itemId, amount)
    amount = amount or 1

    -- 🔁 Try stacking first
    for i, slot in pairs(Inventory.Slots) do
        if slot.id == itemId and slot.count < Items[itemId].maxStack then
            local space = Items[itemId].maxStack - slot.count
            local toAdd = math.min(space, amount)
            slot.count = slot.count + toAdd
            amount = amount - toAdd
            if amount <= 0 then return true end
        end
    end

    -- ➕ If still not done, create new stacks
    for i = 1, Inventory.maxSlots do
        if not Inventory.Slots[i] then
            Inventory.Slots[i] = {
                id = itemId,
                count = math.min(amount, Items[itemId].maxStack)
            }
            amount = amount - Inventory.Slots[i].count
            if amount <= 0 then return true end
        end
    end

    return false
end
-- function Remove Iem


function Inventory.getHeldItem(isPlayer)
    
    if isPlayer ~= nil then
        print("Current slot is " .. Inventory.currentSlot) --Debug
        --print(Items[Inventory.Slots[Inventory.currentSlot].id].name) --Debug
    end

    local slot = Inventory.Slots[Inventory.currentSlot]
    if slot and slot.id then
        return Items[slot.id]
    end
    return nil
    
end
-- 🔍 Maps mouse to a slot index in the inventory grid
local function getSlotFromMouse(x, y)

    local startX = SCREEN_WIDTH / 2 - (COLS * TILE_SIZE) / 2
    local startY = SCREEN_HEIGHT / 2 - (ROWS * TILE_SIZE) / 2

    for index = 1, 5 do

        startX = love.graphics.getWidth() / 2 - (TILE_SIZE * 5) / 2
        local goalX = math.floor((x - startX) / TILE_SIZE) + 1

        if goalX == index and y > HOTBAR_HEIGHT and y < HOTBAR_HEIGHT + TILE_SIZE then

            local slot = Inventory.Slots[index]
            return index, slot

        end
    end

    if Inventory.enabled then

        local col = math.floor((x - startX) / TILE_SIZE) + 1
        local row = math.floor((y - startY) / TILE_SIZE) + 1

        local index = 6
        for j = 1, 5 do
            for i = 1, 5 do
                if i == col and j == row then
                    return index, Inventory.Slots[index]
                end
                index = index + 1
            end
        end

    end
    


end

function Inventory.findSameItem(itemId)
    for i = 6, Inventory.maxSlots do
        local slot = Inventory.Slots[i]
        if slot ~= nil and slot[1] == itemId and slot[2] < ITEMS[itemId].maxStack then
            return slot, i
        end
    end
    return nil
end

function Inventory.findSameHotbarItem(itemId)
    for i = 1, 5 do
        local slot = Inventory.Slots[i]
        if slot ~= nil and slot[1] == itemId and slot[2] < ITEMS[itemId].maxStack then
            return slot, i
        end
    end
    return nil
end

function Inventory.getEmptySlot()
    
    for i = 6 , Inventory.maxSlots do
        local slot = Inventory.Slots[i]

        if slot == nil then
            return i
        end
    end


end

function Inventory.getEmptyHotbarSlot()
    print("starting indexing")
    
    for i = 1 , 5 do
        local slot = Inventory.Slots[i]

        if slot == nil then
            print("Slot " .. i .. " is nil")
            return i
        end
    end

end

----- INPUT -----


function Inventory.mousePressed(x, y, button)
    if button == 1 and not Inventory.isDragging then
        
        local index, slot = getSlotFromMouse(x,y)
        
        if not index or not slot then return end
        if not love.keyboard.isDown("lshift") then

            if index and slot then
            
                Inventory.isDragging = true
                Inventory.draggedSlot = index
                Inventory.draggedItem = slot
            
            end
        
        else

            local goalSlot_i

            if index <= 5 then -- Check if src is hotbar or inv
                goalSlot_i = Inventory.getEmptySlot()
            else
                goalSlot_i = Inventory.getEmptyHotbarSlot()
            end
        
            if goalSlot_i ~= nil then

                Inventory.Slots[goalSlot_i] = slot
                Inventory.Slots[index] = nil

            end
        end
    end
            


    

end

function Inventory.mouseReleased(x,y,button)
    if button == 1 and Inventory.isDragging then
        local i = getSlotFromMouse(x, y)
        if i then
            Inventory.Slots[Inventory.draggedSlot], Inventory.Slots[i] =
            Inventory.Slots[i], Inventory.draggedItem
        end
        Inventory.isDragging = false
        Inventory.draggedSlot = nil
        Inventory.draggedItem = nil
    end
end

function Inventory.keyPressed(key)

    if key == "e" then
        Inventory.enabled = not Inventory.enabled
    end
    local num = tonumber(key)
    if num and num >= 1 and num <= 5 then
        Inventory.currentSlot = num
    end

end

----- RENDERING -----

function Inventory.renderHotbar()
    local startX = love.graphics.getWidth() / 2 - (TILE_SIZE * 5) / 2
    for i = 1, 5 do


        local x = startX + (i - 1) * TILE_SIZE
        local y = HOTBAR_HEIGHT
        love.graphics.draw(slot_bg, x, y)

        if Inventory.isDragging and Inventory.draggedSlot == i then goto continue end

        local slot = Inventory.Slots[i]
        if slot then
            local item = Items[slot.id]
            love.graphics.draw(item.icon, x, y)
            if slot.count > 1 then
                love.graphics.print(slot.count, x + 32, y + 32) -- hotbar
            end
        end

        ::continue::
    end
end

function Inventory.render()

    local held = Inventory.getHeldItem()

    love.graphics.print("Held Slot: " .. tostring(Inventory.currentSlot), 10, 10)

    if held then
        love.graphics.print("Holding: " .. held.name, 10, 30)
    else
        love.graphics.print("Nothing held", 10, 30)
    end


    if Inventory.enabled then 
        local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
        local startX = screenW / 2 - (COLS * TILE_SIZE) / 2
        local startY = screenH / 2 - (ROWS * TILE_SIZE) / 2
        local index = 6 -- Skip hotbar (1-5)

        for row = 1, ROWS do
            for col = 1, COLS do

                local x = startX + (col - 1) * TILE_SIZE
                local y = startY + (row - 1) * TILE_SIZE
                local slot = Inventory.Slots[index]

                love.graphics.draw(slot_bg, x,y)

                if Inventory.isDragging and Inventory.draggedSlot == index then goto continue end

                if slot and (not (Inventory.isDragging and Inventory.draggedSlot == index)) then
                    local item = Items[slot.id]
                    love.graphics.draw(item.icon, x, y)
                    if slot.count > 1 then
                        love.graphics.print(slot.count, x + 32, y + 32)
                    end
                end

                ::continue::
                index = index + 1

            end
        end

    end

    Inventory.renderHotbar()

    -- 🖱️ Dragging preview
    if Inventory.isDragging and Inventory.draggedItem then
        local mx, my = love.mouse.getPosition()
        local icon = Items[Inventory.draggedItem.id].icon
        love.graphics.draw(icon, mx - TILE_SIZE / 2, my - TILE_SIZE / 2)
    end

    
end





return Inventory
