local World = require("core/world")

local Planting = {}

-- Internal storage for all planted crops
local plantedCrops = {}

-- Crop definitions
Planting.cropDefinitions = {
    parsnip = {
        name = "Parsnip",
        growthTimes = {0.1, 0.11}, -- minutes per stage
        sprites = {love.graphics.newImage("assets/images/parsnip.png")},              -- sprite list per growth stage
        harvestItem = "parsnip",
        harvestQuantity = 2,
        regrows = false
    }
}

--==[ Initialization ]==--

function Planting.init()
    -- Reserved for future use
end

--==[ Core Logic ]==--

-- Places a seed if no plant exists at that tile
function Planting.place(cropType, ax, ay)
    for _, plant in ipairs(plantedCrops) do
        if plant.x == ax and plant.y == ay then
            print("occupied")
            return false -- Tile already occupied
        end
    end

    table.insert(plantedCrops, {
        cropType = cropType,
        x = ax,
        y = ay,
        plantedAt = love.timer.getTime(),
        stage = 1,
        grown = false
    })

    return true
end

-- Removes a plant at given grid position
function Planting.removeAt(x, y)
    for i, plant in ipairs(plantedCrops) do
        if plant.x == x and plant.y == y then
            table.remove(plantedCrops, i)
            return true
        end
    end
    return false
end

-- Checks if plant at tile is fully grown
function Planting.isGrownAt(x, y)
    for _, plant in ipairs(plantedCrops) do
        if plant.x == x and plant.y == y then
            local def = Planting.cropDefinitions[plant.cropType]
            local maxStage = #def.growthTimes + 1
            return plant.stage == maxStage, plant
        end
    end
    return false, nil
end

--==[ Growth Update ]==--

function Planting.update(dt)
    local now = love.timer.getTime()

    for _, plant in ipairs(plantedCrops) do
        if plant.grown then goto continue end

        local def = Planting.cropDefinitions[plant.cropType]
        local minutesElapsed = (now - plant.plantedAt) / 60
        local newStage = plant.stage

        for i, time in ipairs(def.growthTimes) do
            if minutesElapsed >= time then
                newStage = i + 1
            end
        end

        if newStage > #def.growthTimes then
            newStage = #def.growthTimes + 1
            plant.grown = true
        end

        if newStage ~= plant.stage then
            plant.stage = newStage
        end

        ::continue::
    end
end

--==[ Rendering ]==--

function Planting.render()
    for _, plant in ipairs(plantedCrops) do
        local def = Planting.cropDefinitions[plant.cropType]
        local sprite = def.sprites[plant.stage]

        if sprite then
            love.graphics.draw(
                sprite,
                (plant.x - 1) * World.tileSize,
                (plant.y - 1) * World.tileSize
            )
        end
    end
end

return Planting
