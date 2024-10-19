-------------------------------------------------------------------------------
-- InterFace Frame {{{
-------------------------------------------------------------------------------

MBR = CreateFrame("Frame", "MoronBoxRepair", UIParent)

-------------------------------------------------------------------------------
-- The Stored Variables {{{
-------------------------------------------------------------------------------

MBR.DefaultOptions = {
    VendorSettings = {
        AutoOpenInteraction = true,
        AutoRepair = true,
        AutoSellGrey = true,
        AutoBlackListMats = true
    },
    VendorItems = {
        WhiteListed = {},
        BlackListed = {}
    }
}

-------------------------------------------------------------------------------
-- Local Variables {{{
-------------------------------------------------------------------------------

MBR.Session = {
    PossibleVendorItems = {
        WhiteListed = {},
        BlackListed = {}
    },
    ItemsToSkip = {
        ["Skinning Knife"] = true,
        ["Salt Shaker"] = true,
        ["Mining Pick"] = true,
        ["Blacksmith Hammer"] = true,
        ["Arclight Spanner"] = true,
        ["Gyromatic Micro-Adjustor"] = true,
        ["Flash Powder"] = true,
        ["Wild Thornroot"] = true,
        ["Ironwood Seed"] = true,
        ["Sacred Candle"] = true,
        ["Ankh"] = true,
        ["Arcane Powder"] = true,
        ["Rune of Portals"] = true,
        ["Symbol of Kings"] = true,
        ["Symbol of Divinity"] = true
    },
    ItemsToSell = {
        ["Raptor Hide"] = true,
        ["Thick Hide"] = true,
    }
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
    if event == "ADDON_LOADED" and arg1 == self:GetName() then
        self:SetupSavedVariables()
    elseif event == "MERCHANT_SHOW" then
        self:SellGreyItems()
        self:RepairItems()
    elseif event == "MERCHANT_CLOSE" or event == "GOSSIP_CLOSED" then
        self:ResetPossibleVendorItems()       
    elseif event == "GOSSIP_SHOW" then
        self:OpenVendorOrBank()
    end
end

MBR:SetScript("OnEvent", MBR.OnEvent)

function MBR:SetupSavedVariables()
    if not MoronBoxRepair_Settings then
        MoronBoxRepair_Settings = {}
    end

    local function InitializeDefaults(defaults, settings)
        for k, v in pairs(defaults) do
            if type(v) == "table" then
                if settings[k] == nil then
                    settings[k] = {}
                end
                InitializeDefaults(v, settings[k])
            else
                if settings[k] == nil then
                    settings[k] = v
                end
            end
        end
    end

    InitializeDefaults(self.DefaultOptions, MoronBoxRepair_Settings)
end

function MBR:ResetToDefaults()
    MoronBoxRepair_Settings = self.DefaultOptions
    self:ResetPossibleVendorItems()
    ReloadUI()
end

-------------------------------------------------------------------------------
-- Core Action Code {{{
-------------------------------------------------------------------------------

function MBR:RepairItems()

    if not MoronBoxRepair_Settings.VendorSettings.AutoRepair or CanMerchantRepair() ~= 1 then 
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

    if not MoronBoxRepair_Settings.VendorSettings.AutoSellGrey then 
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

                -- Other skip conditions
                local isPotion = isConsumable and itemSubType == "Potion"
                local isHerb = isTradeGoods and itemSubType == "Herb"
                local isLeather = isTradeGoods and itemSubType == "Leather"
                local isCloth = isTradeGoods and itemSubType == "Cloth"
                local isMiningItem = isTradeGoods and itemSubType == "Metal & Stone"
                local isFood = isConsumable and (itemSubType == "Food" or itemSubType == "Drink" or itemSubType == "Food & Drink")

                -- Skip if it's meets other skip criteria
                local isSellable = not (isPotion or isHerb or isLeather or isCloth or isMiningItem or isFood)

                -- Skip items that are in the skip list or are not sellable
                if not self.Session.ItemsToSkip[itemName] and itemSellPrice > 0 then

                    -- Sell gray items
                    if isGreyItem then

                        totalPrice = totalPrice + (itemSellPrice * itemCount)
                        amountSold = amountSold + itemCount
                        itemsSold = itemsSold + 1
                        UseContainerItem(i, y)

                    -- Sell white items
                    elseif isWhiteItem then

                        if self.Session.ItemsToSell[itemName] then

                            totalPrice = totalPrice + (itemSellPrice * itemCount)
                            amountSold = amountSold + itemCount
                            itemsSold = itemsSold + 1
                            UseContainerItem(i, y)

                        -- Skip items that should not be sold
                        elseif isSellable or not MoronBoxRepair_Settings.VendorSettings.AutoBlackListMats then

                            if self:ItemIsWhitelist({ Link = itemLink }) then
                                
                                totalPrice = totalPrice + (itemSellPrice * itemCount)
                                amountSold = amountSold + itemCount
                                itemsSold = itemsSold + 1
                                UseContainerItem(i, y)

                            elseif not self:ItemIsBlacklist({ Link = itemLink }) 
                                and not self:ItemIsWhitelist({ Link = itemLink }) 
                                and not self:ItemExistsInPossibleVendorItems({ Link = itemLink }) then

                                table.insert(self.Session.PossibleVendorItems.WhiteListed, {
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
    end

    if self:HasVendorItems() then
        self:CreateSellOverview()
    end

    if itemsSold > 0 then
        MBC:Print("Total items sold: "..itemsSold.." ("..amountSold.." in total) for a combined price of "..GetCoinTextureString(totalPrice))
    end
end

function MBR:OpenVendorOrBank()
    if MoronBoxRepair_Settings.VendorSettings.AutoOpenInteraction then
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