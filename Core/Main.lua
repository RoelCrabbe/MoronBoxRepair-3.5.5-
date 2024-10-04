-------------------------------------------------------------------------------
-- InterFace Frame {{{
-------------------------------------------------------------------------------

MBR = CreateFrame("Frame", "MoronBoxRepair", UIParent)

-------------------------------------------------------------------------------
-- The Stored Variables {{{
-------------------------------------------------------------------------------

MBR.DefaultOptions = {
    AutoOpenVendor = true,
    AutoRepair = true,
    AutoSellGrey = true
}

-------------------------------------------------------------------------------
-- Core Event Code {{{
-------------------------------------------------------------------------------

MBR:RegisterEvent("ADDON_LOADED")
MBR:RegisterEvent("MERCHANT_SHOW")
MBR:RegisterEvent("GOSSIP_SHOW")

function MBR:OnEvent(event)
    if event == "ADDON_LOADED" and arg1 == MBR:GetName() then
        SetupSavedVariables()
    elseif event == "MERCHANT_SHOW" then
        MBR_SellGreyItems()
        MBR_RepairItems()
    elseif event == "GOSSIP_SHOW" then
        if MoronBoxRepair_Settings.AutoOpenVendor then
            for i = 1, GetNumGossipOptions() do
                local GossipText, GossipType = GetGossipOptions(i)

                if GossipType == "vendor" or GossipType == "banker" or 
                    (GossipText and (GossipText:find("I want to browse") or GossipText:find("I would like to check"))) then
                    SelectGossipOption(i)
                    MBC:Print("Opening "..CapitalizeFirstLetter(GossipType).."!")
                    break
                end
            end
        end
    end
end

MBR:SetScript("OnEvent", MBR.OnEvent)

function SetupSavedVariables()
    if not MoronBoxRepair_Settings then
        MoronBoxRepair_Settings = {}
    end

    for key, value in InTable(MBR.DefaultOptions) do
        if MoronBoxRepair_Settings[key] == nil then
            MoronBoxRepair_Settings[key] = value
        end
    end
end

-------------------------------------------------------------------------------
-- Core Action Code {{{
-------------------------------------------------------------------------------

function MBR_RepairItems()

    if not MoronBoxRepair_Settings.AutoRepair or CanMerchantRepair() ~= 1 then 
        return 
    end

    local repairAllCost, canRepair = GetRepairAllCost()

    if repairAllCost > 0 then
        if canRepair == 1 then
            RepairAllItems()
            Print("Your items have been repaired for: "..GetCoinTextureString(repairAllCost))
            return
        end

        Print("You don't have enough money for repairs!")
    end
end

function MBR_SellGreyItems()

    if not MoronBoxRepair_Settings.AutoSellGrey then 
        return 
    end

    local totalPrice, amountSold, itemsSold = 0, 0, 0

    for i = 0, 4 do
        for y = 1, GetContainerNumSlots(i) do
            local currentItemLink = GetContainerItemLink(i, y)

            if ( currentItemLink ) then
                local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(currentItemLink)
                local _, itemCount = GetContainerItemInfo(i, y)

                if ( itemRarity == 0 and itemSellPrice ~= 0 ) then
                    totalPrice = totalPrice + (itemSellPrice * itemCount)
                    amountSold = amountSold + itemCount
                    itemsSold = itemsSold + 1

                    Print("Sold: "..currentItemLink.." (x"..itemCount..") for "..GetCoinTextureString(itemSellPrice * itemCount))
                    UseContainerItem(i, y)
                end
            end
        end
    end

    if itemsSold > 1 then
        Print("Total items sold: "..itemsSold.." ("..amountSold.." in total) for a combined price of "..GetCoinTextureString(totalPrice))
    end
end