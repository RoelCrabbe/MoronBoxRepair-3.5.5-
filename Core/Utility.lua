-------------------------------------------------------------------------------
-- Helper Functions {{{
-------------------------------------------------------------------------------

function MBR:ItemIsBlacklist(Item)
    if not Item then return end
    for _, BlacklistItem in ipairs(MoronBoxRepair_Settings.BlackListedVendorItems) do
        if BlacklistItem.Link == Item.Link then
            return true
        end
    end
    return false
end

function MBR:AddToBlacklist(Item)
    if not Item then return end
    table.insert(MoronBoxRepair_Settings.BlackListedVendorItems, Item)
    for i, allowedItem in ipairs(MBR.Session.PossibleVendorItems) do
        if allowedItem.Link == Item.Link then
            table.remove(MBR.Session.PossibleVendorItems, i)
            break
        end
    end
end

function MBR:RemoveFromBlacklist(Item)
    if not Item then return end
    table.insert(MBR.Session.PossibleVendorItems, Item)
    for i, allowedItem in ipairs(MoronBoxRepair_Settings.BlackListedVendorItems) do
        if allowedItem.Link == Item.Link then
            table.remove(MoronBoxRepair_Settings.BlackListedVendorItems, i)
            break
        end
    end
end

function MBR:ItemExistsInAllowed(Item)
    if not Item then return end
    for _, AllowedItem in ipairs(MoronBoxRepair_Settings.AllowedVendorItems) do
        if AllowedItem.Link == Item.Link then
            return true
        end
    end
    return false
end