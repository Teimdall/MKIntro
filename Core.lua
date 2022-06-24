local addonName, MKIntro = ...

addonName = "MKIntro"
LibStub("AceAddon-3.0"):NewAddon(MKIntro, addonName, "AceConsole-3.0", "AceEvent-3.0")
MKIntro.L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

MKIntro.LGI = LibStub:GetLibrary("LibGroupInSpecT-1.1")

function MKIntro:OnInitialize()
    self.LGI.RegisterCallback (MKIntro, "GroupInSpecT_Update", "OnInspectUpdate")
    self.LGI.RegisterCallback (MKIntro, "GroupInSpecT_Remove", "OnInspectRemove")

    self.frames = {}
    self.animations = {}
    self.models = {}

    self.keystone_started = false
    self.unit_names = {"player", "party1", "party2", "party3", "party4"}
    self.number_of_player = 0
    self.players = {}

    self:InitOptions()
    self:InitDebugMode()

    self:SetupDisplay()
    self:RegisterEvents()
end

function MKIntro:InitDebugMode()
    local dungeon_name = "PF"
    self.debug = {}
    self.debug.dungeon = self.dungeons[dungeon_name]
    self.debug.keystone = {
        map_id = self.dungeons[dungeon_name].zone_id,
        name = "Debug Mode",
        level = 15,
        affixes = {
            {
                fileid = ({C_ChallengeMode.GetAffixInfo(117)})[3]
            },
            {
                fileid = ({C_ChallengeMode.GetAffixInfo(11)})[3]
            },
            {
                fileid = ({C_ChallengeMode.GetAffixInfo(124)})[3]
            }
        }
    }

    if self.ADB.profile.debug.enabled then
        self:EnableDebugMode()
    end
end

function MKIntro:IsDebugModeEnabled()
    return self.ADB.profile.debug.enabled
end

function MKIntro:EnableDebugMode()
    self.ADB.profile.debug.enabled = true
    self:RegisterEvent("PLAYER_STOPPED_MOVING", "OnChallengeStart")
end

function MKIntro:DisableDebugMode()
    self.ADB.profile.debug.enabled = false
    self:UnregisterEvent("PLAYER_STOPPED_MOVING")
end

function MKIntro:OnEnable()
	-- Called when the addon is enabled
end

function MKIntro:OnDisable()
	-- Called when the addon is disabled
end

function MKIntro:PopulateFrames()
    for index, unit in ipairs(self.unit_names) do
        self:PopulatePlayerFrame(unit)
    end

    self:PopulateBossFrame(self:GetActiveKeystoneInfo())
end

function MKIntro:PopulatePlayerFrame(unit)
    local player = self.players[unit]
    if player == nil or player == {} then return end

    --Set background color
    local background_texture = self.frames.players[unit].main.texture
    local color = C_ClassColor.GetClassColor(player.class)
    background_texture:SetGradientAlpha("HORIZONTAL", color.r, color.g, color.b, 0.5, color.r, color.g, color.b, 1.0)

    --Set player name
    local name_text = self.frames.players[unit].main.text
    name_text:SetTextColor(color.r, color.g, color.b, 1.0)
    name_text:SetText(player.name)

    --Set player portrait
    self.frames.players[unit].portrait:SetUnit(unit)

    --Set player role
    self.frames.players[unit].role.texture:SetTexture(self:GetRoleIcon(player.role))

    --Set player spec (name and icon)
    self.frames.players[unit].spec.text.text:SetText(player.spec.name)
    self.frames.players[unit].spec.icon.texture:SetTexture(player.spec.icon)

    --Set player rating
    self.frames.players[unit].rating.text:SetText(player.rating)
    local r, g, b = C_ChallengeMode.GetDungeonScoreRarityColor(player.rating):GetRGB()
    self.frames.players[unit].rating.text:SetTextColor(r, g, b, 1.0)
end

function MKIntro:PopulateBossFrame(keystone)
    local dungeon = self:GetDungeonFromZoneId(keystone.map_id)
    self.frames.boss.texture:SetGradientAlpha("HORIZONTAL", dungeon.color.r/255, dungeon.color.g/255, dungeon.color.b/255, 0.5, dungeon.color.r/255, dungeon.color.g/255, dungeon.color.b/255, 1.0)

    self.models.boss:SetDisplayInfo(dungeon.boss.model_id)
    self.models.boss:SetPosition(dungeon.boss.portrait.position.x, dungeon.boss.portrait.position.y, dungeon.boss.portrait.position.z)
    self.models.boss:SetPortraitZoom(dungeon.boss.portrait.zoom)

    self.frames.boss.text:SetText(keystone.name)
    self.frames.keystone.text:SetText( "+" .. keystone.level)
    local level_color = self:GetKeystoneLevelColor(keystone.level)
    self.frames.keystone.text:SetTextColor(level_color.r, level_color.g, level_color.b, level_color.a)

    self:PopulateAffixes(keystone)
end

function MKIntro:PopulateAffixes(keystone)
    for i, affix in ipairs(keystone.affixes) do
        self.frames.affixes[i].texture:SetTexture(affix.fileid)
    end
end