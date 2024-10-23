require "util"

-- We have 'RealisticOres' as an optional dependency, so it'll update the base item icons by itself and we don't need to worry about which one to use.
-- 'deadlock-beltboxes-loaders' doesn't depend on that so it'll build it with the base icons before 'RealisticOres' changes them.
-- In either case, we rebuild the stacked icons and realistic or no, the correct ones are layered onto wooden crates.

local woodenChest = data.raw.item["wooden-chest"]
--log(serpent.block(woodenChest))

local function UpdateBaseIcon(deadlockItemRecipe, baseItem)
    local woodIcon = {icon = woodenChest.icon, icon_size = woodenChest.icon_size}
    local baseIcon = {icon = baseItem.icon, icon_size = baseItem.icon_size, icon_mipmaps = baseItem.icon_mipmaps, scale = 0.5 * 0.75}

    deadlockItemRecipe.icons = {woodIcon, baseIcon}
    deadlockItemRecipe.icon = nil
    deadlockItemRecipe.icon_size = nil
    deadlockItemRecipe.scale = nil
    deadlockItemRecipe.icon_mipmaps = nil
end

local function UpdateItemIcons(deadlockItem, baseItem)
    --log(deadlockItem.name)

    local woodIcon = {
        filename = woodenChest.icon,
        size = defines.default_icon_size, -- woodenChest.icon_size,
        scale = 0.50
    }

    --log("woodIcon:")
    --log(serpent.block(woodIcon))

    -- Setup pictures for belt icons.
    local pictureLayers = {}

    for _, picture in pairs(baseItem.pictures) do
        local newPicture = table.deepcopy(picture)
        local innerLayers = {woodIcon}

        if (newPicture.scale) then
            newPicture.scale = newPicture.scale * 0.75

            table.insert(innerLayers, newPicture)
        elseif newPicture.layers then
            -- It's got multiple inner layers.
            for _, layeredPic in pairs(newPicture.layers) do
                layeredPic.scale = layeredPic.scale * 0.75

                table.insert(innerLayers, layeredPic)
            end
        end

        local layer = {layers = innerLayers}
        table.insert(pictureLayers, layer)
    end

    --log("deadlockItem.pictures:")
    deadlockItem.pictures = pictureLayers

    --log(serpent.block(deadlockItem.pictures))

    -- Set normal icon used in inventories, alt overlays, etc.
    UpdateBaseIcon(deadlockItem, baseItem)
end

local function ReplaceStackIcons(itemName, targetDir)
    local baseItem = data.raw.item[itemName]
    UpdateItemIcons(data.raw.item["deadlock-stack-"..itemName], baseItem)
    UpdateBaseIcon(data.raw.recipe["deadlock-stacks-stack-"..itemName], baseItem)
    UpdateBaseIcon(data.raw.recipe["deadlock-stacks-unstack-"..itemName], baseItem)
end

if mods["DeadlockStacking"] or mods["deadlock-beltboxes-loaders"] then
    local oreNames = {"iron-ore", "copper-ore", "uranium-ore", "coal", "stone"}

    if mods["space-age"] then
        table.insert(oreNames, "tungsten-ore")
    end

    for _, oreName in ipairs(oreNames) do
        ReplaceStackIcons(oreName, "")
    end
end