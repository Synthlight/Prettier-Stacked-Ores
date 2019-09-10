require "util"

-- Deadlock's Stacking Beltboxes
-- Deadlock's Stacking Beltboxes & Compact Loaders
if mods["DeadlockStacking"] or mods["deadlock-beltboxes-loaders"] then
    local realisticOreNames = {"iron-ore", "copper-ore", "uranium-ore"}
    local nonRealisticOreNames = {"coal", "stone"}

    local function replaceStackIcon(somethingWithIcon, itemName, targetDir)
        if not somethingWithIcon then return end

        basePath = "__Prettier-Stacked-Ores__/graphics/icons/mip/"..targetDir
        baseIcon = basePath..itemName

        somethingWithIcon.icon = baseIcon..".png"
        somethingWithIcon.icon_size = 64
        somethingWithIcon.icons = nil
        somethingWithIcon.icon_mipmaps = 4
        somethingWithIcon.pictures = {
            { size = 64, filename = baseIcon..".png",   scale = 0.25, mipmap_count = 4 },
            { size = 64, filename = baseIcon.."-1.png", scale = 0.25, mipmap_count = 4 },
            { size = 64, filename = baseIcon.."-2.png", scale = 0.25, mipmap_count = 4 },
            { size = 64, filename = baseIcon.."-3.png", scale = 0.25, mipmap_count = 4 }
        }
    end

    local function replaceStackIcons(itemName, targetDir)
        replaceStackIcon(data.raw.item["deadlock-stack-"..itemName], itemName, targetDir)
        replaceStackIcon(data.raw.recipe["deadlock-stacks-stack-"..itemName], itemName, targetDir)
        replaceStackIcon(data.raw.recipe["deadlock-stacks-unstack-"..itemName], itemName, targetDir)
    end

    for _, oreName in ipairs(nonRealisticOreNames) do
        replaceStackIcons(oreName, "")
    end

    if mods["RealisticOres"] then
        for _, oreName in ipairs(realisticOreNames) do
            replaceStackIcons(oreName, "realistic/")
        end
    else
        for _, oreName in ipairs(realisticOreNames) do
            replaceStackIcons(oreName, "base/")
        end
    end
end