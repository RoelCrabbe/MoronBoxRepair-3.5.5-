-------------------------------------------------------------------------------
-- General Setting Window {{{
-------------------------------------------------------------------------------

function MBC:CreateLine(Parent, Width, Height, OffsetX, OffsetY, Color)
    local Line = Parent:CreateTexture(nil, "ARTWORK")
    Line:SetSize(Width, Height)  -- Set width and height of the line

    -- Position the line centered around the parent frame, with specified offsets
    Line:SetPoint("CENTER", Parent, "CENTER", OffsetX, OffsetY)

    Line:SetTexture(1, 1, 1, 1)  -- Set a default white texture
    Line:SetVertexColor(unpack(Color))  -- Set the color (RGBA format)
    
    return Line
end


function MBR:GeneralSettingWindow()
    
    local SettingsFrame = MBC:CreateFrame(UIParent, MBC.BACKDROPS.Basic, 500, 600)
    SettingsFrame:SetBackdropColor(unpack(MBC.COLORS.FrameBackground))

    local Title = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    Title:SetText(MBC:ApplyTextColor("Moron Box Repair", MBC.COLORS.Title))
    Title:SetPoint("TOP", SettingsFrame, "TOP", 0, -10)
    SettingsFrame.Title = Title
    MBC:ApplyCustomFont(Title, 30)

    local ReturnButton = MBC:ReturnButton(SettingsFrame, 20, 20)
    SettingsFrame.ReturnButton = ReturnButton

    ReturnButton:SetScript("OnClick", function()
        
    end)

    local CloseButton = MBC:CloseButton(SettingsFrame, 20, 20)
    SettingsFrame.CloseButton = CloseButton

    CloseButton:SetScript("OnClick", function()
        SettingsFrame:Hide()
    end)

    local Description = SettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    Description:SetPoint("TOPLEFT", SettingsFrame, "TOPLEFT", 20, -60)
    Description:SetWidth(SettingsFrame:GetWidth() - 40)  -- Subtract padding
    Description:SetJustifyH("LEFT")
    Description:SetHeight(0)  -- Auto-adjust height based on content
    Description:SetWordWrap(true)  -- Enable word wrapping
    Description:SetText(
        MBC:ApplyTextColor("MoronBoxRepair", MBC.COLORS.Highlight) ..
        MBC:ApplyTextColor(" is a lightweight bag cleaner addon that automatically repairs gear when needed.", MBC.COLORS.Text)
    )

    SettingsFrame.Description = Description
    MBC:ApplyCustomFont(Description, 15)

    local LineWidth = SettingsFrame:GetWidth() - 60
    local OffsetY = (SettingsFrame:GetHeight() / 2) - 105

    MBC:CreateLine(SettingsFrame, LineWidth, 1, 0, OffsetY, MBC.COLORS.LineColor)














    MBC:CreateLine(SettingsFrame, LineWidth, 1, 0, -(OffsetY + 64), MBC.COLORS.LineColor)
    MBC:CreateAddonGroupText(SettingsFrame)

    MBC:MakeMoveable(SettingsFrame)
    
    return SettingsFrame
end

-- function MerchantFrame:CreateRepairButton()
--     self.AutoRepairButton, UpdateRepairButtonAppearance = MBC:CreateToggleButton(self, "Auto Repair", MoronBoxRepair_Settings.AutoRepair, 125)
--     self.AutoRepairButton:SetPoint("CENTER", self, "TOP", -50, -53)

--     self.AutoRepairButton:SetScript("OnClick", function()
--         MoronBoxRepair_Settings.AutoRepair = not MoronBoxRepair_Settings.AutoRepair
--         UpdateRepairButtonAppearance(MoronBoxRepair_Settings.AutoRepair)
--         MBR_RepairItems()
--     end)
-- end

-- function MerchantFrame:CreateSellButton()
--     self.AutoSellGreyButton, UpdateSellButtonAppearance = MBC:CreateToggleButton(self, "Auto SellGray", MoronBoxRepair_Settings.AutoSellGrey, 125)
--     self.AutoSellGreyButton:SetPoint("CENTER", self, "TOP", 85, -53)

--     self.AutoSellGreyButton:SetScript("OnClick", function()
--         MoronBoxRepair_Settings.AutoSellGrey = not MoronBoxRepair_Settings.AutoSellGrey
--         UpdateSellButtonAppearance(MoronBoxRepair_Settings.AutoSellGrey)
--         MBR_SellGreyItems()
--     end)
-- end

-- Description:SetText(
--     MBC:ApplyTextColor("MoronBoxRepair", MBC:COLORS.Highlight) ..
--     MBC:ApplyTextColor(" is a lightweight bag cleaner addon that automatically repairs gear when needed.", MBC:COLORS.Text) .. 
--     "\n" .. 
--     MBC:ApplyTextColor("This addon is part of the ", MBC:COLORS.Text) ..
--     MBC:ApplyTextColor("MoronBox", MBC:COLORS.Highlight) ..
--     MBC:ApplyTextColor(" addon group, designed for efficient multiboxing.", MBC:COLORS.Text)
-- )