-------------------------------------------------------------------------------
-- General Setting Window {{{
-------------------------------------------------------------------------------

function MBR:GeneralSettingWindow()
    
    local SettingsFrame = MBC:CreateGeneralWindow(UIParent, "Moron Box Repair", 500, 400)
    SettingsFrame.ReturnButton:SetScript("OnClick", function()
        SettingsFrame:Hide()
        MBC:CreateSettingsWindow()
    end)

    SettingsFrame.CloseButton:SetScript("OnClick", function()
        SettingsFrame:Hide()
    end)

    local Description = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    Description:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 20, -60)
    Description:SetWidth(SettingsFrame:GetWidth() - 40)
    Description:SetJustifyH("LEFT")
    Description:SetHeight(0)
    Description:SetWordWrap(true)
    Description:SetText(
        MBC:ApplyTextColor("MoronBoxRepair", MBC.COLORS.Highlight) ..
        MBC:ApplyTextColor(" is a lightweight bag cleaner addon that automatically repairs gear when needed.", MBC.COLORS.Text)
    )

    SettingsFrame.Description = Description
    MBC:ApplyCustomFont(Description, 15)

    local FrameHeight = SettingsFrame:GetHeight()
    local LineWidth = SettingsFrame:GetWidth() - 60
    local OffsetY = FrameHeight * 0.5 - 105
    
    MBC:CreateLine(SettingsFrame, LineWidth, 1, 0, OffsetY, MBC.COLORS.LineColor)

    local AutoOpenVendorCheckbox = MBC:CreateCustomCheckbox(SettingsFrame, MoronBoxRepair_Settings.AutoOpenVendor)
    AutoOpenVendorCheckbox:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 45, -120)

    local AutoOpenVendorLabel = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AutoOpenVendorLabel:SetPoint("LEFT", AutoOpenVendorCheckbox, "RIGHT", 15, 0)  
    AutoOpenVendorLabel:SetText(MBC:ApplyTextColor("Enable Auto Open Vendor & Bankers", MBC.COLORS.Text))  
    MBC:ApplyCustomFont(AutoOpenVendorLabel, 14)

    AutoOpenVendorCheckbox:SetScript("OnClick", function(self)
        MoronBoxRepair_Settings.AutoOpenVendor = (self:GetChecked() == 1)  
    end)

    local AutoRepairCheckbox = MBC:CreateCustomCheckbox(SettingsFrame, MoronBoxRepair_Settings.AutoRepair)
    AutoRepairCheckbox:SetPoint("TOPLEFT", AutoOpenVendorCheckbox, "BOTTOMLEFT", 0, -15)

    local AutoRepairLabel = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AutoRepairLabel:SetPoint("LEFT", AutoRepairCheckbox, "RIGHT", 15, 0) 
    AutoRepairLabel:SetText(MBC:ApplyTextColor("Enable Auto Repair", MBC.COLORS.Text))  
    MBC:ApplyCustomFont(AutoRepairLabel, 14)

    AutoRepairCheckbox:SetScript("OnClick", function(self)
        MoronBoxRepair_Settings.AutoRepair = (self:GetChecked() == 1)  
    end)

    local AutoSellGreyCheckbox = MBC:CreateCustomCheckbox(SettingsFrame, MoronBoxRepair_Settings.AutoSellGrey)
    AutoSellGreyCheckbox:SetPoint("TOPLEFT", AutoRepairCheckbox, "BOTTOMLEFT", 0, -15)

    local AutoSellGreyLabel = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AutoSellGreyLabel:SetPoint("LEFT", AutoSellGreyCheckbox, "RIGHT", 15, 0)  
    AutoSellGreyLabel:SetText(MBC:ApplyTextColor("Enable Auto Sell Grey Items", MBC.COLORS.Text))  
    MBC:ApplyCustomFont(AutoSellGreyLabel, 14)

    AutoSellGreyCheckbox:SetScript("OnClick", function(self)
        MoronBoxRepair_Settings.AutoSellGrey = (self:GetChecked() == 1) 
    end)
    
    return SettingsFrame
end

-------------------------------------------------------------------------------
-- Confirm Frame {{{
-------------------------------------------------------------------------------

function MBR:CreatePopOpenFrame(Parent)
    if not Parent then return end

    local PopOpenFrame = MBC:CreateFrame(Parent, MBC.BACKDROPS.Basic, Parent:GetWidth(), 200)
    PopOpenFrame:SetBackdropColor(unpack(MBC.COLORS.FrameBackground))
    PopOpenFrame:SetPoint("BOTTOM", Parent, "TOP", 0, 0)
    Parent.PopOpenFrame = PopOpenFrame

    local Description = PopOpenFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    Description:SetPoint("CENTER", PopOpenFrame, "CENTER", 0, 45)
    Description:SetWidth(PopOpenFrame:GetWidth() - 40)
    Description:SetJustifyH("LEFT")
    Description:SetJustifyV("MIDDLE")
    Description:SetWordWrap(true)
    Description:SetText(
        MBC:ApplyTextColor("These items haven't been sold before. Review them carefully and choose which ones should be auto-sold in the future.\n", MBC.COLORS.Text) ..
        MBC:ApplyTextColor("Your selections will be saved, and those items will ", MBC.COLORS.Text) ..
        MBC:ApplyTextColor("always", MBC.COLORS.Highlight) ..
        MBC:ApplyTextColor(" be kept from auto-selling.", MBC.COLORS.Text)
    )

    local DescriptionTwo = PopOpenFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    DescriptionTwo:SetPoint("CENTER", PopOpenFrame, "CENTER", 0, -15)
    DescriptionTwo:SetWidth(PopOpenFrame:GetWidth() - 40)
    DescriptionTwo:SetJustifyH("LEFT")
    DescriptionTwo:SetJustifyV("MIDDLE")
    DescriptionTwo:SetWordWrap(true)
    DescriptionTwo:SetText(
        MBC:ApplyTextColor("Certain items, like ", MBC.COLORS.Text) ..
        MBC:ApplyTextColor("cloth", MBC.COLORS.Highlight) .. 
        MBC:ApplyTextColor(", ", MBC.COLORS.Text) ..
        MBC:ApplyTextColor("leather", MBC.COLORS.Highlight) ..
        MBC:ApplyTextColor(", ", MBC.COLORS.Text) ..
        MBC:ApplyTextColor("potions", MBC.COLORS.Highlight) ..
        MBC:ApplyTextColor(", and ", MBC.COLORS.Text) ..
        MBC:ApplyTextColor("quest items", MBC.COLORS.Highlight) ..
        MBC:ApplyTextColor(", will always be excluded from auto-selling.", MBC.COLORS.Text)
    )

    local DescriptionThree = PopOpenFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    DescriptionThree:SetPoint("CENTER", PopOpenFrame, "CENTER", 0, -60)
    DescriptionThree:SetWidth(PopOpenFrame:GetWidth() - 40)
    DescriptionThree:SetJustifyH("LEFT")
    DescriptionThree:SetJustifyV("MIDDLE")
    DescriptionThree:SetWordWrap(true)
    DescriptionThree:SetText(
        "|TInterface\\AddOns\\MoronBoxCore\\Media\\Icons\\RedMinus.tga:22:22:0:0:64:64:4:60:4:60|t" .. 
        MBC:ApplyTextColor(" : Auto Vendor     ", MBC.COLORS.Text) ..
        "|TInterface\\AddOns\\MoronBoxCore\\Media\\Icons\\GreenPlus.tga:22:22:0:0:64:64:4:60:4:60|t" ..
        MBC:ApplyTextColor(" : Never Vendor", MBC.COLORS.Text)
    )
    
    MBC:ApplyCustomFont(Description, 15)
    MBC:ApplyCustomFont(DescriptionTwo, 15)
    MBC:ApplyCustomFont(DescriptionThree, 15)
    PopOpenFrame:Hide()

    function PopOpenFrame:UpdatePoints()
        self:ClearAllPoints()
        self:SetPoint("BOTTOM", Parent, "TOP", 0, 0)
    end

    return PopOpenFrame
end

function MBR:CreateSellPopup()

    local SettingsFrame = MBC:CreateGeneralWindow(UIParent, "Moron Box Repair", 500, 600)    
    SettingsFrame.ReturnButton:SetNormalTexture("Interface\\AddOns\\MoronBoxCore\\Media\\Icons\\ShowTooltip.tga")
    SettingsFrame.ReturnButton:SetPushedTexture("Interface\\AddOns\\MoronBoxCore\\Media\\Icons\\ShowTooltip.tga")    

    local ScrollFrame = CreateFrame("ScrollFrame", "SellItemsScrollFrame", SettingsFrame)
    ScrollFrame:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 20, -95)
    ScrollFrame:SetPoint("BOTTOMRIGHT", SettingsFrame, "BOTTOMRIGHT", -30, 85)

    local ScrollChild = CreateFrame("Frame", "SellItemsScrollChild", ScrollFrame)
    ScrollChild:SetSize(ScrollFrame:GetWidth(), 1)
    ScrollFrame:SetScrollChild(ScrollChild)
    
    ScrollFrame:EnableMouseWheel(true)
    ScrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local current = self:GetVerticalScroll()
        local maxScroll = self:GetVerticalScrollRange()
        local newScroll = math.max(0, math.min(current - (delta * 20), maxScroll))
        self:SetVerticalScroll(newScroll)
    end)

    local PopOpenFrame = MBR:CreatePopOpenFrame(SettingsFrame)

    SettingsFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        PopOpenFrame:UpdatePoints()
    end)

    SettingsFrame.ReturnButton:SetScript("OnClick", function()
        MBC:ToggleFrame(SettingsFrame.PopOpenFrame)
        PopOpenFrame:UpdatePoints()
    end)

    SettingsFrame.CloseButton:SetScript("OnClick", function()
        MBR.Session.PossibleVendorItems = {} 
        MerchantFrame:Hide()
        SettingsFrame:Hide()
        PopOpenFrame:Hide()
    end)

    local Description = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    Description:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 20, -60)
    Description:SetWidth(SettingsFrame:GetWidth() - 40)
    Description:SetJustifyH("CENTER")
    Description:SetJustifyV("MIDDLE")
    Description:SetWordWrap(true)
    Description:SetText(
        "|TInterface\\AddOns\\MoronBoxCore\\Media\\Icons\\RedMinus.tga:22:22:0:0:64:64:4:60:4:60|t" .. 
        MBC:ApplyTextColor(" : Auto Vendor     ", MBC.COLORS.Text) ..
        "|TInterface\\AddOns\\MoronBoxCore\\Media\\Icons\\GreenPlus.tga:22:22:0:0:64:64:4:60:4:60|t" ..
        MBC:ApplyTextColor(" : Never Vendor", MBC.COLORS.Text)
    )
    SettingsFrame.Description = Description
    MBC:ApplyCustomFont(Description, 15)

    local FrameHeight = SettingsFrame:GetHeight()
    local LineWidth = SettingsFrame:GetWidth() - 60
    local OffsetY = FrameHeight * 0.5 - 85

    MBC:CreateLine(SettingsFrame, LineWidth, 1, 0, OffsetY, MBC.COLORS.LineColor)

    local totalItemHeight = MBR:SellItems(ScrollChild)
    ScrollChild:SetHeight(totalItemHeight)

    local function OnMerchantFrameHide()
        if SettingsFrame:IsVisible() then
            SettingsFrame:Hide()
        end
    end

    MerchantFrame:HookScript("OnHide", OnMerchantFrameHide)

    local ConfirmButton = MBC:CreateButton(SettingsFrame, 150, 35, "Confirm")
    ConfirmButton:SetPoint("CENTER", SettingsFrame, "BOTTOM", 0, 60)
    
    ConfirmButton:SetScript("OnClick", function()

        if #MBR.Session.PossibleVendorItems == 0 then
            MerchantFrame:Hide()
            return
        end
    
        MBC:Print("Adding items to allowed to vendor list...")

        local ItemsAdded = 0
        for _, Item in ipairs(MBR.Session.PossibleVendorItems) do
            if not MBR:ItemExistsInAllowed(Item) then
                table.insert(MoronBoxRepair_Settings.AllowedVendorItems, Item)
                ItemsAdded = ItemsAdded + 1
            end
        end
        
        if ItemsAdded > 0 then
            MBC:Print(ItemsAdded.." items have been added to the allowed to vendor list.")
        end
    
        MBR.Session.PossibleVendorItems = {}
        MBR:SellGreyItems()
        MerchantFrame:Hide()
    end)

    return SettingsFrame
end

function MBR:SellItems(Parent)
    if not Parent then return end

    local Height = 0
    for Num, Item in ipairs(MBR.Session.PossibleVendorItems) do
        if Item.Icon and Item.Link then

            local ItemFrame = MBC:CreateFrame(Parent, MBC.BACKDROPS.Blizz_Border, Parent:GetWidth() * 0.66, 45)
            ItemFrame:SetPoint("TOP", Parent, "TOP", 0, -Height)

            local ItemIcon = MBC:CreateItemIcon(ItemFrame, Item, 37, 37)
            ItemFrame.ItemIcon = ItemIcon

            local ItemName = ItemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            ItemName:SetPoint("CENTER", ItemFrame, "CENTER", 0, 0)
            ItemName:SetText(Item.Name)
            MBC:ApplyCustomFont(ItemName, 15)
            ItemFrame.ItemName = ItemName

            local UnSelectButton = MBC:ToggleButton(ItemFrame, 24, 24)
            ItemFrame.UnSelectButton = UnSelectButton

            ItemIcon:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                GameTooltip:SetHyperlink(Item.Link)
                GameTooltip:Show()
            end)

            ItemIcon:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)

            UnSelectButton:SetScript("OnClick", function(self)
                if MBR:ItemIsBlacklist(Item) then
                    MBR:RemoveFromBlacklist(Item)
                else
                    MBR:AddToBlacklist(Item)
                end
                UnSelectButton.UpdateButtonIcon(Item)
            end)

            Height = Height + 45
        end
    end

    return Height
end