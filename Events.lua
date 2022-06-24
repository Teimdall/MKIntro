local addonName, MKIntro = ...

function MKIntro:OnChallengeStart(event)
    if self.keystone_started then return end

    self.keystone_started = true
    self:PopulateFrames()
    self:ShowFrame()
    self:PlayAnimations()

    C_Timer.After(6, function()
        self:HideFrame()
        self:ResetFramesPositionsFromAnimations()
    end)
end

function MKIntro:ResetState()
    self.keystone_started = false
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
            if self.ADB.profile.general.sound.enabled then
                PlaySoundFile("Interface\\AddOns\\MKIntro\\Media\\Sounds\\announcer.mp3", "master")
            end
        end)
    end)
end

function MKIntro:RegisterEvents()
    self:RegisterEvent("CHALLENGE_MODE_START", "OnChallengeStart")
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED", "ResetState")
    self:RegisterEvent("CHALLENGE_MODE_KEYSTONE_SLOTTED", "ResetState")
end

