if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end

AZP.VersionControl["Efficient Questing"] = 18
if AZP.EfficientQuesting == nil then AZP.EfficientQuesting = {} end
if AZP.EfficientQuesting.Events == nil then AZP.EfficientQuesting.Events = {} end

local AZPEQSelfOptionPanel = nil
local EventFrame, UpdateFrame = nil, nil
local HaveShowedUpdateNotification = false
local optionHeader = "|cFF00FFFFEfficient Questing|r"

function AZP.EfficientQuesting:OnLoadBoth()
    local defaultCompleteButtonBehaviour = QuestFrameCompleteQuestButton:GetScript("OnShow")
    QuestFrameCompleteQuestButton:SetScript("OnShow", function(...)
        defaultCompleteButtonBehaviour(...)
        AZP.EfficientQuesting:DelayedExecution(0.5, function() AZP.EfficientQuesting:SelectMostExpensive() end)
    end)
end

function AZP.EfficientQuesting:OnLoadCore()
    AZP.OptionsPanels:RemovePanel("Efficient Questing")
    AZP.OptionsPanels:Generic("Efficient Questing", optionHeader, function (frame)
        AZP.EfficientQuesting:FillOptionsPanel(frame)
    end)
end

function AZP.EfficientQuesting:OnLoadSelf()
    C_ChatInfo.RegisterAddonMessagePrefix("AZPVERSIONS")
    EventFrame = CreateFrame("Frame")
    EventFrame:SetScript("OnEvent", function(...) AZP.EfficientQuesting:OnEvent(...) end)
    EventFrame:RegisterEvent("CHAT_MSG_ADDON")
    EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

    UpdateFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    UpdateFrame:SetPoint("CENTER", 0, 250)
    UpdateFrame:SetSize(400, 200)
    UpdateFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    UpdateFrame:SetBackdropColor(0.25, 0.25, 0.25, 0.80)
    UpdateFrame.header = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalHuge")
    UpdateFrame.header:SetPoint("TOP", 0, -10)
    UpdateFrame.header:SetText("|cFFFF0000AzerPUG's Efficient Questing is out of date!|r")

    UpdateFrame.text = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
    UpdateFrame.text:SetPoint("TOP", 0, -40)
    UpdateFrame.text:SetText("Error!")

    UpdateFrame:Hide()

    local UpdateFrameCloseButton = CreateFrame("Button", nil, UpdateFrame, "UIPanelCloseButton")
    UpdateFrameCloseButton:SetWidth(25)
    UpdateFrameCloseButton:SetHeight(25)
    UpdateFrameCloseButton:SetPoint("TOPRIGHT", UpdateFrame, "TOPRIGHT", 2, 2)
    UpdateFrameCloseButton:SetScript("OnClick", function() UpdateFrame:Hide() end )

    AZPEQSelfOptionPanel = CreateFrame("FRAME", nil)
    AZPEQSelfOptionPanel.name = optionHeader
    InterfaceOptions_AddCategory(AZPEQSelfOptionPanel)
    AZPEQSelfOptionPanel.header = AZPEQSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPEQSelfOptionPanel.header:SetPoint("TOP", 0, -10)
    AZPEQSelfOptionPanel.header:SetText(optionHeader)

    AZPEQSelfOptionPanel.footer = AZPEQSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPEQSelfOptionPanel.footer:SetPoint("TOP", 0, -300)
    AZPEQSelfOptionPanel.footer:SetText(
        "|cFF00FFFFAzerPUG Links:\n" ..
        "Website: www.azerpug.com\n" ..
        "Discord: www.azerpug.com/discord\n" ..
        "Twitch: www.twitch.tv/azerpug\n|r"
    )
    AZP.EfficientQuesting.FillOptionsPanel(AZPEQSelfOptionPanel)

    local defaultBehaviour = QuestFrame:GetScript("OnShow")
    QuestFrame:SetScript("OnShow", function()
        defaultBehaviour()
        AZP.EfficientQuesting:SelectMostExpensive()
    end)
end

function AZP.EfficientQuesting:FillOptionsPanel(frameToFill)
end

function AZP.EfficientQuesting:DelayedExecution(delayTime, delayedFunction)
	local frame = CreateFrame("Frame")
	frame.start_time = GetServerTime()
	frame:SetScript("OnUpdate",
		function(self)
			if GetServerTime() - self.start_time > delayTime then
				self:SetScript("OnUpdate", nil)
				delayedFunction()
				self:Hide()
			end
		end
	)
	frame:Show()
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

function AZP.EfficientQuesting:ShareVersion()    -- Change DelayedExecution to native WoW Function.
    local versionString = string.format("|EQ:%d|", AZP.VersionControl["Efficient Questing"])
    AZP.EfficientQuesting:DelayedExecution(10, function()
        if UnitInBattleground("player") ~= nil then
            -- BG stuff?
        else
            if IsInGroup() then
                if IsInRaid() then
                    C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"RAID", 1)
                else
                    C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"PARTY", 1)
                end
            end
            if IsInGuild() then
                C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"GUILD", 1)
            end
        end
    end)
end

function AZP.EfficientQuesting:ReceiveVersion(version)
    if version > AZP.VersionControl["Efficient Questing"] then
        if (not HaveShowedUpdateNotification) then
            HaveShowedUpdateNotification = true
            UpdateFrame:Show()
            UpdateFrame.text:SetText(
                "Please download the new version through the CurseForge app.\n" ..
                "Or use the CurseForge website to download it manually!\n\n" .. 
                "Newer Version: v" .. version .. "\n" .. 
                "Your version: v" .. AZP.VersionControl["Efficient Questing"]
            )
        end
    end
end

function AZP.EfficientQuesting:GetSpecificAddonVersion(versionString, addonWanted)
    local pattern = "|([A-Z]+):([0-9]+)|"
    local index = 1
    while index < #versionString do
        local _, endPos = string.find(versionString, pattern, index)
        local addon, version = string.match(versionString, pattern, index)
        index = endPos + 1
        if addon == addonWanted then
            return tonumber(version)
        end
    end
end

function AZP.EfficientQuesting:OnEvent(self, event, ...)
    if event == "CHAT_MSG_ADDON" then
        local prefix, payload, _, sender = ...
        if prefix == "AZPVERSIONS" then
            local version = AZP.EfficientQuesting:GetSpecificAddonVersion(payload, "EQ")
            if version ~= nil then
                AZP.EfficientQuesting:ReceiveVersion(version)
            end
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        AZP.EfficientQuesting:ShareVersion()
    end
end

if not IsAddOnLoaded("AzerPUGsCore") then
    AZP.EfficientQuesting:OnLoadSelf()
end

AZP.SlashCommands["EQ"] = function()
    if EfficientQuestingSelfFrame ~= nil then EfficientQuestingSelfFrame:Show() end
end

AZP.SlashCommands["eq"] = AZP.SlashCommands["EQ"]
AZP.SlashCommands["quest"] = AZP.SlashCommands["EQ"]
AZP.SlashCommands["efficient questing"] = AZP.SlashCommands["EQ"]