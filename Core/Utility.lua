-------------------------------------------------------------------------------
-- Helpers Functions SavedVariables {{{
-------------------------------------------------------------------------------

function MBR:ItemIsWhitelist(Item)
    if not Item then return end
    for _, v in ipairs(MoronBoxRepair_Settings.VendorItems.WhiteListed) do
        if v.Link == Item.Link then
            return true
        end
    end
    return false
end

function MBR:ItemIsBlacklist(Item)
    if not Item then return end
    for i, v in ipairs(MoronBoxRepair_Settings.VendorItems.BlackListed) do
        if v.Link == Item.Link then
            return true
        end
    end
    return false
end

function MBR:ItemExistsInPossibleVendorItems(Item)
    if not Item then return end
    for _, v in ipairs(self.Session.PossibleVendorItems.WhiteListed) do
        if v.Link == Item.Link then
            return true
        end
    end
    return false
end

-------------------------------------------------------------------------------
-- Helpers Session Storage {{{
-------------------------------------------------------------------------------

function MBR:HasVendorItems()
    return (next(self.Session.PossibleVendorItems.WhiteListed) ~= nil or next(self.Session.PossibleVendorItems.BlackListed) ~= nil)
end

function MBR:ResetPossibleVendorItems()
    self.Session.PossibleVendorItems = {
        WhiteListed = {},
        BlackListed = {}
    }
end