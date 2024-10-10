
function MBR:ConfirmChoices()
    if #MBR.Session.PossibleVendorItems == 0 then
        MerchantFrame:Hide()
        return
    end

    local ItemsAdded = 0
    for _, Item in ipairs(MBR.Session.PossibleVendorItems) do
        if not MBR:ItemExistsInAllowed(Item) then
            table.insert(MoronBoxRepair_Settings.AllowedVendorItems, Item)
            ItemsAdded = ItemsAdded + 1
        end
    end
    
    if ItemsAdded > 0 then
        local ItemText = ItemsAdded == 1 and "item has" or "items have"
        MBC:Print(ItemsAdded.." "..ItemText.." been added to the vendor list.")
    end

    MBR.Session.PossibleVendorItems = {}
    MBR:SellGreyItems()
    MerchantFrame:Hide()
end