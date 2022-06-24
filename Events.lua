local addonName, MKIntro = ...

function MKIntro:PopulateFrames()
    for index, unit in ipairs(self.unit_names) do
        self:PopulatePlayerFrame(unit)
    end

    local keystone = self:GetActiveKeystoneInfo()
    self:PopulateBossFrame(keystone)
end

function MKIntro:GetActiveKeystoneInfo()
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

function MKIntro:ShowFrame()
    UIParent:Hide()
    self.frames.main:Show()
    for index, affix in ipairs(self.frames.affixes) do
        affix:Hide()
    end
    for index, affix in ipairs(self:GetActiveKeystoneInfo().affixes) do
        self.frames.affixes[index]:Show()
    end
end

function MKIntro:HideFrame()
    UIParent:Show()
    self.frames.main:Hide()
end

function MKIntro:OnChallengeStart()
    if MKIntro.keystone_started or not C_ChallengeMode.IsChallengeModeActive() then return end

    MKIntro.keystone_started = true
    MKIntro:PopulateFrames()
    MKIntro:ShowFrame()
    MKIntro:PlayAnimations()

    C_Timer.After(6, function()
        MKIntro:HideFrame()
        MKIntro:ResetFramesPositionsFromAnimations()
    end)
end

function MKIntro:ResetState()
    MKIntro.keystone_started = false
end

function MKIntro:PlayAnimations()
    for index, unit in ipairs(self.unit_names) do
        self.animations.groups.players[unit]:Play()
        PlaySoundFile("Interface\\AddOns\\MKIntro\\Media\\Sounds\\whoosh.mp3", "master")
    end
    C_Timer.After(self.animations.duration*2, function()
        self.animations.groups.boss.group:Play()
        PlaySoundFile("Interface\\AddOns\\MKIntro\\Media\\Sounds\\whoosh.mp3", "master")

        C_Timer.After(self.animations.duration*2, function()
            self.animations.groups.versus.group:Play()
            PlaySoundFile("Interface\\AddOns\\MKIntro\\Media\\Sounds\\announcer.mp3", "master")
        end)
    end)
end

function MKIntro:RegisterEvents()
    if self.debug then
        self:RegisterEvent("PLAYER_STOPPED_MOVING", self.OnChallengeStart)
    end

    self:RegisterEvent("CHALLENGE_MODE_START", self.OnChallengeStart)
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED", self.ResetState)
    self:RegisterEvent("CHALLENGE_MODE_KEYSTONE_SLOTTED", self.ResetState)
end

