-------------------------------------------------------------------------------
-- Helper Functions {{{
-------------------------------------------------------------------------------

function MBR:ItemIsBlacklist(Item)
    if not Item then return end
    for _, BlacklistItem in ipairs(MoronBoxRepair_Settings.VendorItems.BlackListed) do
        if BlacklistItem.Link == Item.Link then
            return true
        end
    end
    return false
end

function MBR:AddToBlacklist(Item)
    if not Item then return end
    table.insert(MoronBoxRepair_Settings.VendorItems.BlackListed, Item)
    for i, allowedItem in ipairs(MBR.Session.PossibleVendorItems.WhiteListed) do
        if allowedItem.Link == Item.Link then
            table.remove(MBR.Session.PossibleVendorItems.WhiteListed, i)
            break
        end
    end
end

function MBR:RemoveFromBlacklist(Item)
    if not Item then return end
    table.insert(MBR.Session.PossibleVendorItems.WhiteListed, Item)
    for i, allowedItem in ipairs(MoronBoxRepair_Settings.VendorItems.BlackListed) do
        if allowedItem.Link == Item.Link then
            table.remove(MoronBoxRepair_Settings.VendorItems.BlackListed, i)
            break
        end
    end
end

function MBR:ItemIsWhitelist(Item)
    if not Item then return end
    for _, AllowedItem in ipairs(MoronBoxRepair_Settings.VendorItems.WhiteListed) do
        if AllowedItem.Link == Item.Link then
            return true
        end
    end
    return false
end

function MBR:ItemExistsInPossibleVendorItems(Item)
    if not Item then return end
    for _, vendorItem in ipairs(MBR.Session.PossibleVendorItems.WhiteListed) do
        if vendorItem.Link == Item.Link then
            return true
        end
    end
    return false
end
