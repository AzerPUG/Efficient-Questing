if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end

AZP.VersionControl.EfficientQuesting = 9
AZP.EfficientQuesting = {}

local dash = " - "
local name = "Efficient Questing"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZP.VersionControl.EfficientQuesting)

function AZP.GU.VersionControl:EfficientQuesting()
    return AZPGUQuestEfficiencyVersion
end

function AZP.GU.OnLoad:EfficientQuesting(self)
    AZP.EfficientQuesting:initializeConfig()
    AZP.EfficientQuesting:ChangeOptionsText()

    local OptionsHeader = QuestEfficiencySubPanel:CreateFontString("OptionsHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsHeader:SetText(promo)
    OptionsHeader:SetWidth(QuestEfficiencySubPanel:GetWidth())
    OptionsHeader:SetHeight(QuestEfficiencySubPanel:GetHeight())
    OptionsHeader:SetPoint("TOP", 0, -10)

    local defaultBehaviour = QuestFrame:GetScript("OnShow")
    QuestFrame:SetScript("OnShow", function() 
        defaultBehaviour()
        AZP.EfficientQuesting:SelectMostExpensive()
    end)

    local defaultCompleteButtonBehaviour = QuestFrameCompleteQuestButton:GetScript("OnShow")
    QuestFrameCompleteQuestButton:SetScript("OnShow", function(...)
        defaultCompleteButtonBehaviour(...)
        AZPAddonHelper:DelayedExecution(0.5, function() AZP.EfficientQuesting:SelectMostExpensive() end)
    end)
end

function AZP.EfficientQuesting:SelectMostExpensive()
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

function AZP.EfficientQuesting:initializeConfig()
    if AGUCheckedData == nil then
        AGUCheckedData = initialConfig
    end
end

function AZP.OnEvent:EfficientQuesting(event, ...)
end

function AZP.EfficientQuesting:ChangeOptionsText()
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
        "AzerPUG's Efficient Questing does not have options yet.\n" ..
        "For feature requests visit our Discord Server!"
    )
end