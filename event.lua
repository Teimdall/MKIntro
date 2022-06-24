function MKplus:PopulateFrames()
    for index, unit in ipairs(MKplus.unit_names) do
        MKplus:PopulatePlayerFrame(unit)
    end

    local keystone = MKplus:GetActiveKeystoneInfo()
    MKplus:PopulateBossFrame(keystone)
end

function MKplus:GetActiveKeystoneInfo()
    local keystone = {}

    keystone.map_id = C_ChallengeMode.GetActiveChallengeMapID()
    local name, _, _, _, _ = C_ChallengeMode.GetMapUIInfo(keystone.map_id)
    keystone.name = name

    local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
    keystone.level = level

    keystone.affixes = {}
    for i, affixID in ipairs(affixes) do
        keystone.affixes[i] = {}
        keystone.affixes[i].name, _, keystone.affixes[i].fileid = C_ChallengeMode.GetAffixInfo(affixID)
    end

    return keystone
end

function MKplus:ShowFrame()
    UIParent:Hide()
    MKplus.frames.main:Show()
    for index, affix in ipairs(MKplus.frames.affixes) do
        affix:Hide()
    end
    for index, affix in ipairs(MKplus:GetActiveKeystoneInfo().affixes) do
        MKplus.frames.affixes[index]:Show()
    end
end

function MKplus:HideFrame()
    UIParent:Show()
    MKplus.frames.main:Hide()
end

function MKplus:OnChallengeStart()
    if MKplus.keystone_started then return end
    MKplus.keystone_started = true
    MKplus:PopulateFrames()
    MKplus:ShowFrame()
    MKplus:PlayAnimations()
    C_Timer.After(6, function(self)
        MKplus:HideFrame()
        MKplus:ResetFramesPositionsFromAnimations()
    end)
end

function MKplus:PlayAnimations()
    for index, unit in ipairs(MKplus.unit_names) do
        MKplus.animations.groups.players[unit]:Play()
        PlaySoundFile("Interface\\AddOns\\MKplus\\Media\\whoosh.mp3", "master")
    end
    C_Timer.After(MKplus.animations.duration*2, function(self)
        MKplus.animations.groups.boss.group:Play()
        PlaySoundFile("Interface\\AddOns\\MKplus\\Media\\whoosh.mp3", "master")

        C_Timer.After(MKplus.animations.duration*2, function(self)
            MKplus.animations.groups.versus.group:Play()
            PlaySoundFile("Interface\\AddOns\\MKplus\\Media\\announcer.mp3", "master")
        end)
    end)
end

function MKplus:ResetState()
    MKplus.keystone_started = false
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHALLENGE_MODE_START")
--f:RegisterEvent("PLAYER_STOPPED_MOVING")
f:RegisterEvent("CHALLENGE_MODE_COMPLETED")
f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_SLOTTED")

f:SetScript("OnEvent", function(self, event, ...)
    if event == "CHALLENGE_MODE_START" then -- or "PLAYER_STOPPED_MOVING" then
        MKplus:OnChallengeStart()
    elseif event == "CHALLENGE_MODE_COMPLETED" or event == "ON_CHALLENGE_MODE_RESET" or "CHALLENGE_MODE_START" or "CHALLENGE_MOD_KEYSTONE_SLOTTED" then
        MKplus:ResetState()
    end
end)