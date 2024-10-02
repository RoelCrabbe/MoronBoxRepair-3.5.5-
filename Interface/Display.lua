-------------------------------------------------------------------------------
-- Frame Names {{{
-------------------------------------------------------------------------------

local _G, _M = getfenv(0), {}
setfenv(1, setmetatable(_M, {__index=_G}))

function MBR:CreateWindows()
    MerchantFrame:CreateRepairButton()
    MerchantFrame:CreateSellButton()
end

-------------------------------------------------------------------------------
-- Option Checkbox {{{
-------------------------------------------------------------------------------

function MerchantFrame:CreateRepairButton()
    self.AutoRepairButton, UpdateRepairButtonAppearance = MBC:CreateToggleButton(self, "Auto Repair", MoronBoxRepair_Settings.AutoRepair, 125)
    self.AutoRepairButton:SetPoint("CENTER", self, "TOP", -50, -53)

    self.AutoRepairButton:SetScript("OnClick", function()
        MoronBoxRepair_Settings.AutoRepair = not MoronBoxRepair_Settings.AutoRepair
        UpdateRepairButtonAppearance(MoronBoxRepair_Settings.AutoRepair)
        MBR_RepairItems()
    end)
end

function MerchantFrame:CreateSellButton()
    self.AutoSellGreyButton, UpdateSellButtonAppearance = MBC:CreateToggleButton(self, "Auto SellGray", MoronBoxRepair_Settings.AutoSellGrey, 125)
    self.AutoSellGreyButton:SetPoint("CENTER", self, "TOP", 85, -53)

    self.AutoSellGreyButton:SetScript("OnClick", function()
        MoronBoxRepair_Settings.AutoSellGrey = not MoronBoxRepair_Settings.AutoSellGrey
        UpdateSellButtonAppearance(MoronBoxRepair_Settings.AutoSellGrey)
        MBR_SellGreyItems()
    end)
end

function MBR:GeneralWindow()
    Print("Fuck this shit")
end

-- Description:SetText(
--     MBC:ApplyTextColor("MoronBoxRepair", MBC:COLORS.Highlight) ..
--     MBC:ApplyTextColor(" is a lightweight bag cleaner addon that automatically repairs gear when needed.", MBC:COLORS.Text) .. 
--     "\n" .. 
--     MBC:ApplyTextColor("This addon is part of the ", MBC:COLORS.Text) ..
--     MBC:ApplyTextColor("MoronBox", MBC:COLORS.Highlight) ..
--     MBC:ApplyTextColor(" addon group, designed for efficient multiboxing.", MBC:COLORS.Text)
-- )