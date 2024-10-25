-------------------------------------------------------------------------------
-- General Setting Window {{{
-------------------------------------------------------------------------------

function MBR:GeneralSettingWindow()

    local SettingsFrame = MBC:CreateGeneralWindow(UIParent, MBR:SL("Moron Box Repair"), 500, 450)
    local FrameHeight = SettingsFrame:GetHeight()
    local LineWidth = SettingsFrame:GetWidth() - 60

    local Description = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    Description:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 20, -60)
    Description:SetWidth(SettingsFrame:GetWidth() - 40)
    Description:SetJustifyH("LEFT")
    Description:SetHeight(0)
    Description:SetWordWrap(true)
    Description:SetText(MBR:SL("Intro"))

    local OffsetY = FrameHeight * 0.5 - 105
    MBC:CreateLine(SettingsFrame, LineWidth, 1, 0, OffsetY, MBC.COLORS.LineColor)

    local AutoOpenVendorCheckbox = MBC:CreateCustomCheckbox(SettingsFrame, MoronBoxRepair_Settings.VendorSettings.AutoOpenInteraction)
    AutoOpenVendorCheckbox:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 45, -120)

    local AutoOpenVendorLabel = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AutoOpenVendorLabel:SetPoint("LEFT", AutoOpenVendorCheckbox, "RIGHT", 15, 0)  
    AutoOpenVendorLabel:SetText(MBR:SL("Auto Open Vendor Label"))  
    MBC:ApplyCustomFont(AutoOpenVendorLabel, MBC.Font.DefaultSize)

    local AutoRepairCheckbox = MBC:CreateCustomCheckbox(SettingsFrame, MoronBoxRepair_Settings.VendorSettings.AutoRepair)
    AutoRepairCheckbox:SetPoint("TOPLEFT", AutoOpenVendorCheckbox, "BOTTOMLEFT", 0, -15)

    local AutoRepairLabel = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AutoRepairLabel:SetPoint("LEFT", AutoRepairCheckbox, "RIGHT", 15, 0) 
    AutoRepairLabel:SetText(MBR:SL("Auto Repair Label"))  
    MBC:ApplyCustomFont(AutoRepairLabel, MBC.Font.DefaultSize)

    local AutoSellGreyCheckbox = MBC:CreateCustomCheckbox(SettingsFrame, MoronBoxRepair_Settings.VendorSettings.AutoSellGrey)
    AutoSellGreyCheckbox:SetPoint("TOPLEFT", AutoRepairCheckbox, "BOTTOMLEFT", 0, -15)

    local AutoSellGreyLabel = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AutoSellGreyLabel:SetPoint("LEFT", AutoSellGreyCheckbox, "RIGHT", 15, 0)  
    AutoSellGreyLabel:SetText(MBR:SL("Auto Sell Grey Label"))  
    MBC:ApplyCustomFont(AutoSellGreyLabel, MBC.Font.DefaultSize)

    local AutoBlackListMatsCheckbox = MBC:CreateCustomCheckbox(SettingsFrame, MoronBoxRepair_Settings.VendorSettings.AutoBlackListMats)
    AutoBlackListMatsCheckbox:SetPoint("TOPLEFT", AutoSellGreyCheckbox, "BOTTOMLEFT", 45, -15)

    local AutoBlackListMatsLabel = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AutoBlackListMatsLabel:SetPoint("LEFT", AutoBlackListMatsCheckbox, "RIGHT", 15, 0)  
    AutoBlackListMatsLabel:SetText(MBR:SL("Auto Black List Mats Label"))  
    MBC:ApplyCustomFont(AutoBlackListMatsLabel, MBC.Font.DefaultSize)

    local ResetSavedVariables = MBC:CreateButton(SettingsFrame, MBC.Button.Fit, MBC.Button.Large, "Reset to Defaults")
    ResetSavedVariables:SetPoint("CENTER", SettingsFrame, "BOTTOM", 0, 60)

    MBC:ApplyCustomFont(Description, MBC.Font.DefaultSize)

    AutoOpenVendorCheckbox:SetScript("OnClick", function(self)
        MoronBoxRepair_Settings.VendorSettings.AutoOpenInteraction = (self:GetChecked() == 1)  
    end)

    AutoRepairCheckbox:SetScript("OnClick", function(self)
        MoronBoxRepair_Settings.VendorSettings.AutoRepair = (self:GetChecked() == 1)  
    end)

    AutoSellGreyCheckbox:SetScript("OnClick", function(self)
        MoronBoxRepair_Settings.VendorSettings.AutoSellGrey = (self:GetChecked() == 1)
        if not MoronBoxRepair_Settings.VendorSettings.AutoSellGrey then
            MoronBoxRepair_Settings.VendorSettings.AutoBlackListMats = false
            AutoBlackListMatsCheckbox:SetChecked(false)
        end
    end)

    AutoBlackListMatsCheckbox:SetScript("OnClick", function(self)
        MoronBoxRepair_Settings.VendorSettings.AutoBlackListMats = (self:GetChecked() == 1)
        if MoronBoxRepair_Settings.VendorSettings.AutoBlackListMats then
            MoronBoxRepair_Settings.VendorSettings.AutoSellGrey = true
            AutoSellGreyCheckbox:SetChecked(true)
        end
    end)

    ResetSavedVariables:SetScript("OnClick", function()
        MBC:CustomPopup(MBR:SL("Reset Settings"), function() MBR:ResetToDefaults() end, nil)
    end)

    SettingsFrame.ReturnButton:SetScript("OnClick", function()
        MBC:HideFrameIfShown(SettingsFrame)
        MBC:CreateSettingsWindow()
    end)

    SettingsFrame.CloseButton:SetScript("OnClick", function()
        MBC:HideFrameIfShown(SettingsFrame)
    end)

    SettingsFrame.Description = Description
    SettingsFrame.AutoOpenInteractionCheckbox = AutoOpenVendorCheckbox
    SettingsFrame.AutoRepairCheckbox = AutoRepairCheckbox
    SettingsFrame.AutoSellGreyCheckbox = AutoSellGreyCheckbox

    return SettingsFrame
end

-------------------------------------------------------------------------------
-- Confirm Frame {{{
-------------------------------------------------------------------------------

function MBR:CreatePopOpenFrame(Parent)
    if not Parent then return end

    local PopOpenFrame = MBC:CreateFrame(Parent, MBC.BACKDROPS.Basic, Parent:GetWidth(), 190)
    PopOpenFrame:SetPoint("BOTTOM", Parent, "TOP", 0, 0)

    local Description = PopOpenFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    Description:SetPoint("CENTER", PopOpenFrame, "CENTER", 0, 0)
    Description:SetWidth(PopOpenFrame:GetWidth() - 40)
    Description:SetJustifyH("LEFT")
    Description:SetJustifyV("MIDDLE")
    Description:SetWordWrap(true)
    Description:SetText(MBR:SL("New Items Found")..MBR:SL("Icon Explanation"))

    function PopOpenFrame:UpdatePoints()
        self:ClearAllPoints()
        self:SetPoint("BOTTOM", Parent, "TOP", 0, 0)
    end

    MBC:ApplyCustomFont(Description, MBC.Font.DefaultSize)
    MBC:HideFrameIfShown(PopOpenFrame)

    Parent.PopOpenFrame = PopOpenFrame
    Parent.Description = Description

    return PopOpenFrame
end

function MBR:CreateSellOverview()

    local SettingsFrame = MBC:CreateGeneralWindow(UIParent, "Moron Box Repair", 500, 600)
    SettingsFrame.ReturnButton:SetNormalTexture("Interface\\AddOns\\MoronBoxCore\\Media\\Icons\\ShowTooltip.tga")
    SettingsFrame.ReturnButton:SetPushedTexture("Interface\\AddOns\\MoronBoxCore\\Media\\Icons\\ShowTooltip.tga")
    
    local FrameHeight = SettingsFrame:GetHeight()
    local LineWidth = SettingsFrame:GetWidth() - 60

    local ScrollFrame = CreateFrame("ScrollFrame", "SellItemsScrollFrame", SettingsFrame)
    ScrollFrame:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 20, -95)
    ScrollFrame:SetPoint("BOTTOMRIGHT", SettingsFrame, "BOTTOMRIGHT", -30, 85)

    local ScrollChild = CreateFrame("Frame", "SellItemsScrollChild", ScrollFrame)
    ScrollChild:SetSize(ScrollFrame:GetWidth(), 1)
    ScrollFrame:SetScrollChild(ScrollChild)
    ScrollFrame:EnableMouseWheel(true)

    local PopOpenFrame = MBR:CreatePopOpenFrame(SettingsFrame)

    local Description = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    Description:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 20, -60)
    Description:SetWidth(SettingsFrame:GetWidth() - 40)
    Description:SetJustifyH("CENTER")
    Description:SetJustifyV("MIDDLE")
    Description:SetWordWrap(true)
    Description:SetText(MBR:SL("Icon Explanation"))

    local OffsetY = FrameHeight * 0.5 - 85
    MBC:CreateLine(SettingsFrame, LineWidth, 1, 0, OffsetY, MBC.COLORS.LineColor)

    local ItemHeight = MBR:SellItems(ScrollChild)
    ScrollChild:SetHeight(ItemHeight)

    local ConfirmButton = MBC:CreateButton(SettingsFrame, MBC.Button.Fit, MBC.Button.Large, "Confirm")
    ConfirmButton:SetPoint("CENTER", SettingsFrame, "BOTTOM", 0, 60)

    MBC:ApplyCustomFont(Description, MBC.Font.DefaultSize)

    SettingsFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        PopOpenFrame:UpdatePoints()
    end)

    SettingsFrame.ReturnButton:SetScript("OnClick", function(self)
        MBC:ToggleFrame(PopOpenFrame)
        PopOpenFrame:UpdatePoints()
    end)

    SettingsFrame.CloseButton:SetScript("OnClick", function(self)
        MBR:ResetPossibleVendorItems()
        MBC:HideFrameIfShown(MerchantFrame)
        MBC:HideFrameIfShown(SettingsFrame)
        MBC:HideFrameIfShown(PopOpenFrame)
    end)

    ScrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local current = self:GetVerticalScroll()
        local maxScroll = self:GetVerticalScrollRange()
        local newScroll = math.max(0, math.min(current - (delta * 20), maxScroll))
        self:SetVerticalScroll(newScroll)
    end)

    ConfirmButton:SetScript("OnClick", function(self)
        MBR:ConfirmChoices()
    end)

    MerchantFrame:HookScript("OnHide", function(self)
        MBC:HideFrameIfShown(SettingsFrame)
    end)

    SettingsFrame.ScrollFrame = ScrollFrame
    SettingsFrame.ScrollFrame.ScrollChild = ScrollChild
    SettingsFrame.PopOpenFrame = PopOpenFrame
    SettingsFrame.ConfirmButton = ConfirmButton
    SettingsFrame.Description = Description

    return SettingsFrame
end

function MBR:SellItems(Parent)
    if not Parent then return end

    local Height = 0
    for Num, Item in ipairs(MBR.Session.PossibleVendorItems.WhiteListed) do
        if Item.Icon and Item.Link then

            local ItemFrame = MBC:CreateFrame(Parent, MBC.BACKDROPS.Basic, Parent:GetWidth() * 0.75, 45)
            ItemFrame:SetPoint("TOP", Parent, "TOP", 0, -Height)

            local ItemIcon = MBC:CreateItemIcon(ItemFrame, Item, 40, 40)
            local ItemName = ItemFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            ItemName:SetPoint("CENTER", ItemFrame, "CENTER", 0, 0)
            ItemName:SetText(Item.Name)

            local UnSelectButton = MBC:ToggleButton(ItemFrame, 24, 24)
            MBC:ApplyCustomFont(ItemName, MBC.Font.DefaultSize)

            ItemIcon:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                GameTooltip:SetHyperlink(Item.Link)
                GameTooltip:Show()
            end)

            ItemIcon:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)

            UnSelectButton:SetScript("OnClick", function(self)
                MBR:UnSelectChoice(Item)
                UnSelectButton.UpdateButtonIcon(Item)
            end)

            ItemFrame.ItemIcon = ItemIcon
            ItemFrame.ItemName = ItemName
            ItemFrame.UnSelectButton = UnSelectButton

            Height = Height + 50
        end
    end

    return Height
end