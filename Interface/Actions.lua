-------------------------------------------------------------------------------
-- CreateSellOverview Actions {{{
-------------------------------------------------------------------------------

function MBR:ConfirmChoices()
    
    if not self:HasVendorItems() then
        MerchantFrame:Hide()
        return
    end

    local WhiteListedItemsAdded = self:ProcessWhiteListedItems()
    local BlackListedItemsAdded = self:ProcessBlackListedItems()

    if WhiteListedItemsAdded > 0 then
        local WhiteItemText = WhiteListedItemsAdded == 1 and "item has" or "items have"
        MBC:Print(WhiteListedItemsAdded.." "..WhiteItemText.." been added to the vendor list.")
    end

    if BlackListedItemsAdded > 0 then
        local BlackItemText = BlackListedItemsAdded == 1 and "item won't" or "items won't"
        MBC:Print(BlackListedItemsAdded.." "..BlackItemText.." be vendored from now on.")
    end 

    self:ResetPossibleVendorItems()
    self:SellGreyItems()
    MerchantFrame:Hide()
end

function MBR:ProcessWhiteListedItems()
    local i = 0
    for k, v in ipairs(self.Session.PossibleVendorItems.WhiteListed) do
        if not self:ItemIsWhitelist(v) then
            table.insert(MoronBoxRepair_Settings.VendorItems.WhiteListed, v)
            i = i + 1
        end
    end
    return i
end

function MBR:ProcessBlackListedItems()
    local i = 0
    for k, v in ipairs(self.Session.PossibleVendorItems.BlackListed) do
        if not self:ItemIsBlacklist(v) then
            table.insert(MoronBoxRepair_Settings.VendorItems.BlackListed, v)
            i = i + 1
        end
    end
    return i
end

-------------------------------------------------------------------------------
-- Item Actions {{{
-------------------------------------------------------------------------------

function MBR:UnSelectChoice(Item)
    if self:ItemExistsInPossibleVendorItems(Item) then
        self:AddToBlacklist(Item)
    else
        self:RemoveFromBlacklist(Item)
    end
end

function MBR:AddToBlacklist(Item)
    if not Item then return end
    table.insert(self.Session.PossibleVendorItems.BlackListed, Item)
    for i, v in ipairs(self.Session.PossibleVendorItems.WhiteListed) do
        if v.Link == Item.Link then
            table.remove(self.Session.PossibleVendorItems.WhiteListed, i)
            break
        end
    end
end

function MBR:RemoveFromBlacklist(Item)
    if not Item then return end
    table.insert(self.Session.PossibleVendorItems.WhiteListed, Item)
    for i, v in ipairs(self.Session.PossibleVendorItems.BlackListed) do
        if v.Link == Item.Link then
            table.remove(self.Session.PossibleVendorItems.BlackListed, i)
            break
        end
    end
end