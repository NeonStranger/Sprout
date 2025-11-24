-- core/items.lua
local Items = {}

Items["parsnip_seed"] = {
    name = "Parsnip Seeds",
    type = "seed",
    cropType = "parsnip",
    description = "Plant these in spring. Takes 4 days.",
    icon = love.graphics.newImage("assets/images/parsnip.png"),
    stackable = true,
    maxStack = 99,
    price = 20
}

Items["parsnip"] = {
    
    name = "Parsnip",
    description = "Freshly harvested parsnip.",
    icon = love.graphics.newImage("assets/images/parsnip.png"),
    type = "crop",
    stackable = true,
    maxStack = 99,
    price = 35

}

Items["hoe"] = {
    name = "Hoe",
    type = "hoe",
    description = "Used to till soil.",
    icon = love.graphics.newImage("assets/images/hoe.png"),
    stackable = false,
    maxStack = 1,
    price = 100
}

return Items
