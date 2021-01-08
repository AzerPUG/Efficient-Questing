local GlobalAddonName, AGU = ...

local initialConfig = AGU.initialConfig

local AZPGUQuestEfficiencyVersion = 7
local dash = " - "
local name = "GameUtility" .. dash .. "QuestEfficiency"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPGUQuestEfficiencyVersion)

local addonMain = LibStub("AceAddon-3.0"):NewAddon("GameUtility-QuestEfficiency", "AceConsole-3.0")

function AZP.GU.VersionControl:QuestEfficiency()
    return AZPGUQuestEfficiencyVersion
end

function AZP.GU.OnLoad:QuestEfficiency(self)
    addonMain:initializeConfig()
    addonMain:ChangeOptionsText()

    local OptionsHeader = QuestEfficiencySubPanel:CreateFontString("OptionsHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsHeader:SetText(promo)
    OptionsHeader:SetWidth(QuestEfficiencySubPanel:GetWidth())
    OptionsHeader:SetHeight(QuestEfficiencySubPanel:GetHeight())
    OptionsHeader:SetPoint("TOP", 0, -10)

    local defaultBehaviour = QuestFrame:GetScript("OnShow")
    QuestFrame:SetScript("OnShow", function() 
        defaultBehaviour()
        addonMain:SelectMostExpensive()
    end)

    local defaultCompleteButtonBehaviour = QuestFrameCompleteQuestButton:GetScript("OnShow")
    QuestFrameCompleteQuestButton:SetScript("OnShow", function(...)
        defaultCompleteButtonBehaviour(...)
        AZPAddonHelper:DelayedExecution(0.5, function() addonMain:SelectMostExpensive() end)
    end)
end

function addonMain:SelectMostExpensive()
    local numRewardChoices = GetNumQuestChoices()
    if numRewardChoices > 1 then
        local mostExpensiveChoice = 1
        local _, _, _, _, _, _, _, _, _, _, mostExpensiveValue = GetItemInfo(GetQuestItemLink("choice", 1))
        for i = 2, numRewardChoices do
            local _, _, _, _, _, _, _, _, _, _, sellPrice = GetItemInfo(GetQuestItemLink("choice", i))
            if sellPrice > mostExpensiveValue then
                mostExpensiveChoice = i
                mostExpensiveValue = sellPrice
            end
        end
        
        if mostExpensiveChoice == 1 then
            QuestInfoRewardsFrameQuestInfoItem1:Click()
        elseif mostExpensiveChoice == 2 then
            QuestInfoRewardsFrameQuestInfoItem2:Click()
        elseif mostExpensiveChoice == 3 then
            QuestInfoRewardsFrameQuestInfoItem3:Click()
        elseif mostExpensiveChoice == 4 then
            QuestInfoRewardsFrameQuestInfoItem4:Click()
        end
            
    end
end

function addonMain:initializeConfig()
    if AGUCheckedData == nil then
        AGUCheckedData = initialConfig
    end
end

function AZP.GU.OnEvent:QuestEfficiency(self, event, ...)
end

function addonMain:ChangeOptionsText()
    QuestEfficiencySubPanelPHTitle:Hide()
    QuestEfficiencySubPanelPHText:Hide()
    QuestEfficiencySubPanelPHTitle:SetParent(nil)
    QuestEfficiencySubPanelPHText:SetParent(nil)

    local QuestEfficiencySubPanelHeader = QuestEfficiencySubPanel:CreateFontString("QuestEfficiencySubPanelHeader", "ARTWORK", "GameFontNormalHuge")
    QuestEfficiencySubPanelHeader:SetText(promo)
    QuestEfficiencySubPanelHeader:SetWidth(QuestEfficiencySubPanel:GetWidth())
    QuestEfficiencySubPanelHeader:SetHeight(QuestEfficiencySubPanel:GetHeight())
    QuestEfficiencySubPanelHeader:SetPoint("TOP", 0, -10)

    local QuestEfficiencySubPanelText = QuestEfficiencySubPanel:CreateFontString("QuestEfficiencySubPanelText", "ARTWORK", "GameFontNormalHuge")
    QuestEfficiencySubPanelText:SetWidth(QuestEfficiencySubPanel:GetWidth())
    QuestEfficiencySubPanelText:SetHeight(QuestEfficiencySubPanel:GetHeight())
    QuestEfficiencySubPanelText:SetPoint("TOPLEFT", 0, -50)
    QuestEfficiencySubPanelText:SetText(
        "AzerPUG-GameUtility-QuestEfficiency does not have options yet.\n" ..
        "For feature requests visit our Discord Server!"
    )
end