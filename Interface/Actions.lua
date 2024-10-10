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

    if WhiteListedItemsAdded > 0 or BlackListedItemsAdded > 0 then
        local WhiteItemText = WhiteListedItemsAdded == 1 and "item has" or "items have"
        local BlackItemText = BlackListedItemsAdded == 1 and "item won't" or "items won't"
        MBC:Print(
            (WhiteListedItemsAdded > 0 and (WhiteListedItemsAdded.." "..WhiteItemText.." been added to the vendor list.") or "") ..
            (WhiteListedItemsAdded > 0 and BlackListedItemsAdded > 0 and " " or "") ..
            (BlackListedItemsAdded > 0 and (BlackListedItemsAdded.." "..BlackItemText.." be vendored from now on.") or "")
        )
    end    

    self:ResetPossibleVendorItems()
    self:SellGreyItems()
    MerchantFrame:Hide()
end

function MBR:ProcessWhiteListedItems()
    local ItemsAdded = 0
    for _, Item in ipairs(self.Session.PossibleVendorItems.WhiteListed) do
        if not self:ItemExistsInAllowed(Item) then
            table.insert(MoronBoxRepair_Settings.VendorItems.WhiteListed, Item)
            ItemsAdded = ItemsAdded + 1
        end
    end
    return ItemsAdded
end

function MBR:ProcessBlackListedItems()
    local ItemsAdded = 0
    for _, Item in ipairs(self.Session.PossibleVendorItems.BlackListed) do
        if not self:ItemIsBlacklist(Item) then
            table.insert(MoronBoxRepair_Settings.VendorItems.BlackListed, Item)
            ItemsAdded = ItemsAdded + 1
        end
    end
    return ItemsAdded
end