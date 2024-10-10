-------------------------------------------------------------------------------
-- InterFace Frame {{{
-------------------------------------------------------------------------------

MBR = CreateFrame("Frame", "MoronBoxRepair", UIParent)

-------------------------------------------------------------------------------
-- The Stored Variables {{{
-------------------------------------------------------------------------------

MBR.DefaultOptions = { -- Saved Variables default settings, ours are called MoronBoxRepair_Settings
    AutoOpenVendor = true,
    AutoRepair = true,
    AutoSellGrey = true,
    AllowedVendorItems = {}, -- Here the items that CAN be vendored.
    BlackListedVendorItems = {} -- There are the items that can't
}

-------------------------------------------------------------------------------
-- Local Variables {{{
-------------------------------------------------------------------------------

MBR.Session = {
    PossibleVendorItems = {} -- These are the items that are local and not stored
}

-------------------------------------------------------------------------------
-- Core Event Code {{{
-------------------------------------------------------------------------------

MBR:RegisterEvent("ADDON_LOADED")
MBR:RegisterEvent("MERCHANT_SHOW")
MBR:RegisterEvent("MERCHANT_CLOSE")
MBR:RegisterEvent("GOSSIP_SHOW")
MBR:RegisterEvent("GOSSIP_CLOSED")

function MBR:OnEvent(event)
    if event == "ADDON_LOADED" and arg1 == MBR:GetName() then
        MBR:SetupSavedVariables()
    elseif event == "MERCHANT_SHOW" then
        MBR:SellGreyItems()
        MBR:RepairItems()
    elseif event == "MERCHANT_CLOSE" or event == "GOSSIP_CLOSED" then
        MBR.Session.PossibleVendorItems = {}        
    elseif event == "GOSSIP_SHOW" then
        MBR:OpenVendorOrBank()
    end
end

MBR:SetScript("OnEvent", MBR.OnEvent)

function MBR:SetupSavedVariables()
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

function MBR:RepairItems()

    if not MoronBoxRepair_Settings.AutoRepair or CanMerchantRepair() ~= 1 then 
        return 
    end

    local repairAllCost, canRepair = GetRepairAllCost()

    if repairAllCost > 0 then
        if canRepair == 1 then
            RepairAllItems()
            MBC:Print("Your items have been repaired for: "..GetCoinTextureString(repairAllCost))
            return
        end

        MBC:Print("You don't have enough money for repairs!")
    end
end

function MBR:SellGreyItems()

    if not MoronBoxRepair_Settings.AutoSellGrey then 
        return 
    end

    local totalPrice, amountSold, itemsSold = 0, 0, 0

    for i = 0, 4 do
        for y = 1, GetContainerNumSlots(i) do
            local currentItemLink = GetContainerItemLink(i, y)

            if currentItemLink then
                -- Get item info
                local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(currentItemLink)
                local _, itemCount = GetContainerItemInfo(i, y)

                -- Identify items to skip
                local isGreyItem = itemRarity == 0
                local isWhiteItem = itemRarity == 1
                local isTradeGoods = itemType == "Trade Goods"
                local isConsumable = itemType == "Consumable"
                local isQuestItem = itemType == "Quest"
                local isHearthStone =  itemName == "Hearthstone"
                local isPotion = isConsumable and itemSubType == "Potion"
                local isHerb = isTradeGoods and itemSubType == "Herb"
                local isLeather = isTradeGoods and itemSubType == "Leather"
                local isCloth = isTradeGoods and itemSubType == "Cloth"
                local isFood = isConsumable and (itemSubType == "Food" or itemSubType == "Drink" or itemSubType == "Food & Drink")
                local isSpecialWeapon = itemType == "Weapon" and itemSubType == "Miscellaneous"

                -- Skip items that should not be sold
                if not (isQuestItem or isHearthStone or isPotion or isHerb or isLeather or isCloth or isFood or isSpecialWeapon) then

                    -- Sell gray items
                    if isGreyItem and itemSellPrice > 0 then

                        totalPrice = totalPrice + (itemSellPrice * itemCount)
                        amountSold = amountSold + itemCount
                        itemsSold = itemsSold + 1
                        UseContainerItem(i, y)

                    elseif isWhiteItem then

                        if MBR:ItemExistsInAllowed({ Link = itemLink }) then

                            totalPrice = totalPrice + (itemSellPrice * itemCount)
                            amountSold = amountSold + itemCount
                            itemsSold = itemsSold + 1
                            UseContainerItem(i, y)
    
                        elseif not MBR:ItemIsBlacklist({ Link = itemLink }) 
                            and not MBR:ItemExistsInAllowed({ Link = itemLink }) 
                            and not MBR:ItemExistsInPossibleVendorItems({ Link = itemLink }) then
  
                            table.insert(MBR.Session.PossibleVendorItems, {
                                Name = itemName,
                                Link = itemLink,
                                Icon = itemTexture
                            })
                        end
                    end
                end
            end
        end
    end

    if #MBR.Session.PossibleVendorItems > 0 then
        MBR:CreateSellOverview()
    end

    if itemsSold > 0 then
        MBC:Print("Total items sold: "..itemsSold.." ("..amountSold.." in total) for a combined price of "..GetCoinTextureString(totalPrice))
    end
end

function MBR:OpenVendorOrBank()
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