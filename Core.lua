local addonName, MKIntro = ...

LibStub("AceAddon-3.0"):NewAddon(MKIntro, "MKIntro", "AceConsole-3.0", "AceEvent-3.0")

function MKIntro:OnInitialize()
    self.debug = false

    self.LI = LibStub:GetLibrary("LibGroupInSpecT-1.1")

    self.LI.RegisterCallback (MKIntro, "GroupInSpecT_Update", "OnInspectUpdate")
    self.LI.RegisterCallback (MKIntro, "GroupInSpecT_Remove", "OnInspectRemove")

    self:RegisterEvents()

    self.frames = {}
    self.animations = {}
    self.models = {}

    self.keystone_started = false

    self.unit_names = {"player", "party1", "party2", "party3", "party4"}
    self.number_of_player = 0
    self.players = {}

    MKIntro:CreateFrames()
    MKIntro:CreateAnimations()
end

function MKIntro:OnEnable()
	-- Called when the addon is enabled
end

function MKIntro:OnDisable()
	-- Called when the addon is disabled
end

function MKIntro:CreateFrames()
    self:CreateMainFrame()
    self:CreatePlayerFrames()
    self:CreateVersusFrame()
    self:CreateBossFrame()
    self:CreateAffixesFrame()
end

function MKIntro:CreateMainFrame()
    local main
    main = CreateFrame("Frame", nil, nil)
    main:SetSize(
        GetScreenHeight(),
        GetScreenWidth()
    )
    main:SetScale(UIParent:GetScale())
    main:SetAllPoints()
    main:Hide()
    self.frames.main = main
end

--Versus texture
function MKIntro:CreateVersusFrame()
    local versus_frame = CreateFrame("Frame", nil, self.frames.main)
    local versus_texture = versus_frame:CreateTexture()
    versus_texture:SetTexture("Interface\\AddOns\\MKIntro\\Media\\Textures\\Versus.tga")
    versus_texture:SetAllPoints()
    versus_frame:SetPoint("TOP", 0, 750)
    versus_frame:SetSize(512,512)
    versus_frame.texture = versus_texture
    self.frames.versus = versus_frame
end

function MKIntro:CreateAffixesFrame()
    self.frames.affixes = {}
    local offset = 60
    for i = 1, 4 do
    --Role setup
        local affix_frame = CreateFrame("Frame", nil, self.frames.boss)
        local affix_icon = affix_frame:CreateTexture()
        affix_icon:SetAllPoints()
        affix_frame:SetPoint("RIGHT", -340 - (i*offset), -75)
        affix_frame:SetSize(50,50)
        affix_frame:SetFrameStrata("HIGH")
        affix_frame.texture = affix_icon
        self.frames.affixes[i] = affix_frame
    end
end

function MKIntro:CreateBossFrame()
    local boss_frame = CreateFrame("Frame", nil, self.frames.main)
    boss_frame:SetSize(300,130)
    boss_frame:SetPoint("RIGHT", 900, 0)

    --Background texture
    local background_texture = boss_frame:CreateTexture()
    background_texture:SetTexture("Interface\\AddOns\\MKIntro\\Media\\Textures\\Square_AlphaGradient.tga")
    background_texture:SetPoint("CENTER", 0, -50)
    background_texture:SetSize(1500,150)
    background_texture:SetRotation(math.pi)
    boss_frame.texture = background_texture

    --Name text
    local name_text = boss_frame:CreateFontString(nil,"ARTWORK") 
    name_text:SetFont("Interface\\AddOns\\MKIntro\\Media\\Fonts\\Rocks.ttf", 60, "OUTLINE")
    name_text:SetPoint("RIGHT", -400, -10)
    boss_frame.text = name_text

    --Boss actor frame
    local boss_model = CreateFrame("PlayerModel", nil, boss_frame)
    boss_model:SetPoint("BOTTOMRIGHT", 0, -59)
    boss_model:SetCamera(2)
    boss_model:SetRotation(-0.78)
    boss_model:SetPortraitZoom(0.3)
    boss_model:SetSize(500,700)

    local keylevel_frame = CreateFrame("Frame", nil, boss_frame)
    keylevel_frame:SetPoint("RIGHT", -725, -50)
    keylevel_frame:SetSize(100,50)

    local keylevel_text = keylevel_frame:CreateFontString(nil,"ARTWORK")
    keylevel_text:SetFont("Interface\\AddOns\\MKIntro\\Media\\Fonts\\Cabin.ttf", 60, "OUTLINE")
    keylevel_text:SetAllPoints()
    keylevel_frame.text = keylevel_text

    self.frames.keystone = keylevel_frame
    self.frames.boss = boss_frame
    self.models.boss = boss_model
end

function MKIntro:CreatePlayerFrames()
    self.frames.players = {}

    local posY = -120
    for index, unit in ipairs(self.unit_names) do
        self.frames.players[unit] = {}

        local player_frame = CreateFrame("Frame", nil, self.frames.main)
        player_frame:SetSize(-800,130)
        player_frame:SetPoint("TOPLEFT", 0, posY)

        --Background texture
        local background_texture = player_frame:CreateTexture()
        background_texture:SetTexture("Interface\\AddOns\\MKIntro\\Media\\Textures\\Square_AlphaGradient.tga")
        background_texture:SetPoint("CENTER", 0, 0)
        background_texture:SetSize(900,120)
        player_frame.texture = background_texture   

        --Name text
        local name_text = player_frame:CreateFontString(nil,"ARTWORK")
        name_text:SetFont("Interface\\AddOns\\MKIntro\\Media\\Fonts\\MK4.ttf", 50, "OUTLINE")
        name_text:SetPoint("LEFT", 270, 30)
        player_frame.text = name_text

        --Portrait frame
        local portrait = CreateFrame("PlayerModel", nil, player_frame)
        portrait:SetPoint("BOTTOMLEFT", 0, 5)
        portrait:SetSize(250,160)
        portrait:SetPortraitZoom(0.9)
        portrait:SetRotation(0.261799)
        self.frames.players[unit].portrait = portrait

        --Role setup
        local role_frame = CreateFrame("Frame", nil, player_frame)
        local role_icon = role_frame:CreateTexture()
        role_icon:SetPoint("CENTER", 0, 0)
        role_icon:SetSize(60, 60)
        role_frame:SetPoint("BOTTOMLEFT", 20, -7.5)
        role_frame:SetSize(24,24)
        role_frame:SetFrameStrata("HIGH")
        role_frame.texture = role_icon
        self.frames.players[unit].role = role_frame

        --Spec setup
        --Spec setup text
        local text_spec_frame = CreateFrame("Frame", nil, player_frame)
        local text_spec = text_spec_frame:CreateFontString(nil,"ARTWORK") 
        text_spec:SetFont("Interface\\AddOns\\MKIntro\\Media\\Fonts\\Cabin.ttf", 25, "OUTLINE")
        text_spec:SetPoint("LEFT", 0, 0)
        text_spec_frame:SetPoint("LEFT", 310, -20)
        text_spec_frame:SetSize(100,40)
        text_spec_frame.text = text_spec
        --Spec setup icon
        local icon_spec_frame = CreateFrame("Frame", nil, player_frame)
        local spec_icon = icon_spec_frame:CreateTexture()
        spec_icon:SetPoint("LEFT", 0, 0)
        spec_icon:SetSize(30, 30)
        icon_spec_frame:SetPoint("LEFT", 270, -20)
        icon_spec_frame:SetSize(50,50)
        icon_spec_frame.texture = spec_icon

        self.frames.players[unit].spec = {
            text = text_spec_frame,
            icon = icon_spec_frame
        }

        --M+ rating setup
        local rating_frame = CreateFrame("Frame", nil, player_frame)
        local rating_text = rating_frame:CreateFontString(nil,"ARTWORK") 
        rating_text:SetFont("Interface\\AddOns\\MKIntro\\Media\\Fonts\\Cabin.ttf", 25, "OUTLINE")
        rating_text:SetPoint("LEFT", 0, 0)
        rating_frame:SetPoint("LEFT", 550, -20)
        rating_frame:SetSize(100,50)
        rating_frame.text = rating_text
        self.frames.players[unit].rating = rating_frame

        self.frames.players[unit].main = player_frame

        posY = posY-180
    end
end

function MKIntro:ResetFramesPositionsFromAnimations()
    for index, unit in ipairs(self.unit_names) do
        local point, relativeTo, relativePoint, xOfs, yOfs = self.frames.players[unit].main:GetPoint(1)
        self.frames.players[unit].main:SetPoint(
            "TOPLEFT",
            xOfs-self.animations.groups.players.xoffset,
            yOfs-self.animations.groups.players.yoffset
        )
    end

    local point, relativeTo, relativePoint, xOfs, yOfs = self.frames.boss:GetPoint(1)
    self.frames.boss:SetPoint(
        "RIGHT",
        xOfs-self.animations.groups.boss.xoffset,
        yOfs-self.animations.groups.boss.yoffset
    )

    point, relativeTo, relativePoint, xOfs, yOfs = self.frames.versus:GetPoint(1)
    self.frames.versus:SetPoint(
        "TOP",
        xOfs-self.animations.groups.versus.xoffset,
        yOfs-self.animations.groups.versus.yoffset
    )
end

function MKIntro:CreateAnimations()
    self.animations = {
        groups = {
            players = {
                xoffset = 800,
                yoffset = 0
            },
            boss = {
                xoffset = -900,
                yoffset = 0
            },
            versus = {
                xoffset = 0,
                yoffset = -1000
            }
        },
        duration = 0.33
    }

    --Players animation
    for index, unit in ipairs(self.unit_names) do
        self.animations.groups.players[unit] = self.frames.players[unit].main:CreateAnimationGroup()
        local animation = self.animations.groups.players[unit]:CreateAnimation("Translation")

        animation:SetDuration(self.animations.duration)
        animation:SetOffset(self.animations.groups.players.xoffset, self.animations.groups.players.yoffset)

        animation:SetScript("OnUpdate", function(ev, elapsed)
            if ev:IsDone() then
                local point, relativeTo, relativePoint, xOfs, yOfs = self.frames.players[unit].main:GetPoint(1)
                self.frames.players[unit].main:SetPoint(
                    "TOPLEFT",
                    xOfs+self.animations.groups.players.xoffset,
                    yOfs+self.animations.groups.players.yoffset)
            end
        end)
    end

    --Boss animation
    self.animations.groups.boss.group = self.frames.boss:CreateAnimationGroup()
    local boss_animation = self.animations.groups.boss.group:CreateAnimation("Translation")

    boss_animation:SetDuration(self.animations.duration)
    boss_animation:SetOffset(self.animations.groups.boss.xoffset, self.animations.groups.boss.yoffset)

    boss_animation:SetScript("OnUpdate", function(ev, elapsed)
        if ev:IsDone() then
            local point, relativeTo, relativePoint, xOfs, yOfs = self.frames.boss:GetPoint(1)
            self.frames.boss:SetPoint(
                "RIGHT",
                xOfs+self.animations.groups.boss.xoffset,
                yOfs+self.animations.groups.boss.yoffset
            )
        end
    end)

    --Versus animation
    self.animations.groups.versus.group = self.frames.versus:CreateAnimationGroup()
    local versus_animation = self.animations.groups.versus.group:CreateAnimation("Translation")

    versus_animation:SetDuration(self.animations.duration)
    versus_animation:SetOffset(self.animations.groups.versus.xoffset, self.animations.groups.versus.yoffset)

    versus_animation:SetScript("OnUpdate", function(ev, elapsed)
        if ev:IsDone() then
            local point, relativeTo, relativePoint, xOfs, yOfs = self.frames.versus:GetPoint(1)
            self.frames.versus:SetPoint(
                "TOP",
                xOfs+self.animations.groups.versus.xoffset,
                yOfs+self.animations.groups.versus.yoffset
            )

            if self.debug then
                self.keystone_started = false
            end
        end
    end)
    
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

function MKIntro:GetKeystoneLevelColor(key_level)
    local index = 0
    if key_level >= 2 and key_level < 6 then
        index = 1
    elseif key_level >= 6 and key_level < 11 then
        index = 2
    elseif key_level >= 11 and key_level < 16 then
        index = 3
    elseif key_level >= 16 and key_level < 21 then
        index = 4
    elseif key_level >= 21 and key_level < 26 then
        index = 5
    else
        index = 6
    end

    return ITEM_QUALITY_COLORS[index]
end