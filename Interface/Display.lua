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
    AutoOpenVendorLabel:SetText(MBC:ApplyTextColor("Enable Auto Open Vendor", MBC.COLORS.Text))  
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