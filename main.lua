MKplus.frames = {}
MKplus.models = {}
--TODO RELOAD EN SORTANT
MKplus.keystone_started = C_ChallengeMode.IsChallengeModeActive()

function MKplus:CreateFrames()
    MKplus:CreateMainFrame()
    MKplus:CreatePlayerFrames()
    MKplus:CreateVersusFrame()
    MKplus:CreateBossFrame()
    MKplus:CreateAffixesFrame()
end

function MKplus:CreateMainFrame()
    local main
    main = CreateFrame("Frame", nil, nil)
    main:SetSize(
        GetScreenHeight(),
        GetScreenWidth()
    )
    main:SetScale(UIParent:GetScale())
    main:SetAllPoints()
    main:Hide()
    MKplus.frames.main = main
end

--Versus texture
function MKplus:CreateVersusFrame()
    local versus_frame = CreateFrame("Frame", nil, MKplus.frames.main)
    local versus_texture = versus_frame:CreateTexture()
    versus_texture:SetTexture("Interface\\AddOns\\MKplus\\Media\\versus-t.tga")
    versus_texture:SetAllPoints()
    versus_frame:SetPoint("TOP", 0, 750)
    versus_frame:SetSize(512,512)
    versus_frame.texture = versus_texture
    MKplus.frames.versus = versus_frame
end

function MKplus:CreateAffixesFrame()
    MKplus.frames.affixes = {}
    local offset = 60
    for i = 1, 4 do
    --Role setup
        local affix_frame = CreateFrame("Frame", nil, MKplus.frames.boss)
        local affix_icon = affix_frame:CreateTexture()
        affix_icon:SetAllPoints()
        affix_frame:SetPoint("RIGHT", -340 - (i*offset), -75)
        affix_frame:SetSize(50,50)
        affix_frame:SetFrameStrata("HIGH")
        affix_frame.texture = affix_icon
        MKplus.frames.affixes[i] = affix_frame
    end
end

function MKplus:CreateBossFrame()
    local boss_frame = CreateFrame("Frame", nil, MKplus.frames.main)
    boss_frame:SetSize(300,130)
    boss_frame:SetPoint("RIGHT", 900, 0)

    --Background texture
    local background_texture = boss_frame:CreateTexture()
    background_texture:SetTexture("Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_AlphaGradient.tga")
    background_texture:SetPoint("CENTER", 0, -50)
    background_texture:SetSize(1500,150)
    background_texture:SetRotation(math.pi)
    boss_frame.texture = background_texture

    --Name text
    local name_text = boss_frame:CreateFontString(nil,"ARTWORK") 
    name_text:SetFont("Interface\\AddOns\\MKplus\\Fonts\\Rocks.ttf", 60, "OUTLINE")
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
    keylevel_text:SetFont("Interface\\AddOns\\MKplus\\Fonts\\Cabin.ttf", 60, "OUTLINE")
    keylevel_text:SetAllPoints()
    keylevel_frame.text = keylevel_text

    MKplus.frames.keystone = keylevel_frame
    MKplus.frames.boss = boss_frame
    MKplus.models.boss = boss_model
end

function MKplus:CreatePlayerFrames()
    MKplus.frames.players = {}

    local posY = -120
    for index, unit in ipairs(MKplus.unit_names) do
        MKplus.frames.players[unit] = {}

        local player_frame = CreateFrame("Frame", nil, MKplus.frames.main)
        player_frame:SetSize(-800,130)
        player_frame:SetPoint("TOPLEFT", 0, posY)

        --Background texture
        local background_texture = player_frame:CreateTexture()
        background_texture:SetTexture("Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_AlphaGradient.tga")
        background_texture:SetPoint("CENTER", 0, 0)
        background_texture:SetSize(900,120)
        player_frame.texture = background_texture   

        --Name text
        local name_text = player_frame:CreateFontString(nil,"ARTWORK")
        name_text:SetFont("Interface\\AddOns\\MKplus\\Fonts\\MK4.ttf", 50, "OUTLINE")
        name_text:SetPoint("LEFT", 270, 30)
        player_frame.text = name_text

        --Portrait frame
        local portrait = CreateFrame("PlayerModel", nil, player_frame)
        portrait:SetPoint("BOTTOMLEFT", 0, 5)
        portrait:SetSize(250,160)
        portrait:SetPortraitZoom(0.9)
        portrait:SetRotation(0.261799)
        MKplus.frames.players[unit].portrait = portrait

        --Role setup
        local role_frame = CreateFrame("Frame", nil, player_frame)
        local role_icon = role_frame:CreateTexture()
        role_icon:SetPoint("CENTER", 0, 0)
        role_icon:SetSize(60, 60)
        role_frame:SetPoint("BOTTOMLEFT", 20, -7.5)
        role_frame:SetSize(24,24)
        role_frame:SetFrameStrata("HIGH")
        role_frame.texture = role_icon
        MKplus.frames.players[unit].role = role_frame

        --Spec setup
        --Spec setup text
        local text_spec_frame = CreateFrame("Frame", nil, player_frame)
        local text_spec = text_spec_frame:CreateFontString(nil,"ARTWORK") 
        text_spec:SetFont("Interface\\AddOns\\MKplus\\Fonts\\Cabin.ttf", 25, "OUTLINE")
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

        MKplus.frames.players[unit].spec = {}
        MKplus.frames.players[unit].spec.text = text_spec_frame
        MKplus.frames.players[unit].spec.icon = icon_spec_frame

        --M+ rating setup
        local rating_frame = CreateFrame("Frame", nil, player_frame)
        local rating_text = rating_frame:CreateFontString(nil,"ARTWORK") 
        rating_text:SetFont("Interface\\AddOns\\MKplus\\Fonts\\Cabin.ttf", 25, "OUTLINE")
        rating_text:SetPoint("LEFT", 0, 0)
        rating_frame:SetPoint("LEFT", 550, -20)
        rating_frame:SetSize(100,50)
        rating_frame.text = rating_text
        MKplus.frames.players[unit].rating = rating_frame

        MKplus.frames.players[unit].main = player_frame

        posY = posY-180
    end

    --f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_SLOTTED")
    --f:SetScript("OnEvent", function(self, event, ...)
        --UIParent:Hide()
        --f:Show()
        --C_Timer.After(5, function(self)
            --UIParent:Show()
            --f:Hide()
        --end)
    --end)
end

function MKplus:ResetFramesPositionsFromAnimations()
    for index, unit in ipairs(MKplus.unit_names) do
        local point, relativeTo, relativePoint, xOfs, yOfs = MKplus.frames.players[unit].main:GetPoint(1)
        MKplus.frames.players[unit].main:SetPoint(
            "TOPLEFT",
            xOfs-MKplus.animations.groups.players.xoffset,
            yOfs-MKplus.animations.groups.players.yoffset
        )
    end

    local point, relativeTo, relativePoint, xOfs, yOfs = MKplus.frames.boss:GetPoint(1)
    MKplus.frames.boss:SetPoint(
        "RIGHT",
        xOfs-MKplus.animations.groups.boss.xoffset,
        yOfs-MKplus.animations.groups.boss.yoffset
    )

    point, relativeTo, relativePoint, xOfs, yOfs = MKplus.frames.versus:GetPoint(1)
    MKplus.frames.versus:SetPoint(
        "TOP",
        xOfs-MKplus.animations.groups.versus.xoffset,
        yOfs-MKplus.animations.groups.versus.yoffset
    )
end

function MKplus:CreateAnimations()
    MKplus.animations = {
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
    for index, unit in ipairs(MKplus.unit_names) do
        MKplus.animations.groups.players[unit] = MKplus.frames.players[unit].main:CreateAnimationGroup()
        local animation = MKplus.animations.groups.players[unit]:CreateAnimation("Translation")

        animation:SetDuration(MKplus.animations.duration)
        animation:SetOffset(MKplus.animations.groups.players.xoffset, MKplus.animations.groups.players.yoffset)

        animation:SetScript("OnUpdate", function(self, elapsed)
            if self:IsDone() then
                local point, relativeTo, relativePoint, xOfs, yOfs = MKplus.frames.players[unit].main:GetPoint(1)
                MKplus.frames.players[unit].main:SetPoint(
                    "TOPLEFT",
                    xOfs+MKplus.animations.groups.players.xoffset,
                    yOfs+MKplus.animations.groups.players.yoffset)
            end
        end)
    end

    --Boss animation
    MKplus.animations.groups.boss.group = MKplus.frames.boss:CreateAnimationGroup()
    local boss_animation = MKplus.animations.groups.boss.group:CreateAnimation("Translation")

    boss_animation:SetDuration(MKplus.animations.duration)
    boss_animation:SetOffset(MKplus.animations.groups.boss.xoffset, MKplus.animations.groups.boss.yoffset)

    boss_animation:SetScript("OnUpdate", function(self, elapsed)
        if self:IsDone() then
            local point, relativeTo, relativePoint, xOfs, yOfs = MKplus.frames.boss:GetPoint(1)
            MKplus.frames.boss:SetPoint(
                "RIGHT",
                xOfs+MKplus.animations.groups.boss.xoffset,
                yOfs+MKplus.animations.groups.boss.yoffset
            )
        end
    end)

    --Versus animation
    MKplus.animations.groups.versus.group = MKplus.frames.versus:CreateAnimationGroup()
    local versus_animation = MKplus.animations.groups.versus.group:CreateAnimation("Translation")

    versus_animation:SetDuration(MKplus.animations.duration)
    versus_animation:SetOffset(MKplus.animations.groups.versus.xoffset, MKplus.animations.groups.versus.yoffset)

    versus_animation:SetScript("OnUpdate", function(self, elapsed)
        if self:IsDone() then
            local point, relativeTo, relativePoint, xOfs, yOfs = MKplus.frames.versus:GetPoint(1)
            MKplus.frames.versus:SetPoint(
                "TOP",
                xOfs+MKplus.animations.groups.versus.xoffset,
                yOfs+MKplus.animations.groups.versus.yoffset
            )
        end
    end)
    
end

function MKplus:PopulatePlayerFrame(unit)
    local player = MKplus.players[unit]
    if player == nil or player == {} then return end

    --Set background color
    local background_texture = MKplus.frames.players[unit].main.texture
    local color = C_ClassColor.GetClassColor(player.class)
    background_texture:SetGradientAlpha("HORIZONTAL", color.r, color.g, color.b, 0.5, color.r, color.g, color.b, 1.0)

    --Set player name
    local name_text = MKplus.frames.players[unit].main.text
    name_text:SetTextColor(color.r, color.g, color.b, 1.0)
    name_text:SetText(player.name)

    --Set player portrait
    MKplus.frames.players[unit].portrait:SetUnit(unit)

    --Set player role
    MKplus.frames.players[unit].role.texture:SetTexture(MKplus:GetRoleIcon(player.role))

    --Set player spec (name and icon)
    MKplus.frames.players[unit].spec.text.text:SetText(player.spec.name)
    MKplus.frames.players[unit].spec.icon.texture:SetTexture(player.spec.icon)

    --Set player rating
    MKplus.frames.players[unit].rating.text:SetText(player.rating)
    local r, g, b = C_ChallengeMode.GetDungeonScoreRarityColor(player.rating):GetRGB()
    MKplus.frames.players[unit].rating.text:SetTextColor(r, g, b, 1.0)
end

function MKplus:PopulateBossFrame(keystone)
    local dungeon = MKplus:GetDungeonFromZoneId(keystone.map_id)
    MKplus.frames.boss.texture:SetGradientAlpha("HORIZONTAL", dungeon.color.r/255, dungeon.color.g/255, dungeon.color.b/255, 0.5, dungeon.color.r/255, dungeon.color.g/255, dungeon.color.b/255, 1.0)

    MKplus.models.boss:SetDisplayInfo(dungeon.boss.model_id)
    MKplus.models.boss:SetPosition(dungeon.boss.portrait.position.x, dungeon.boss.portrait.position.y, dungeon.boss.portrait.position.z)
    MKplus.models.boss:SetPortraitZoom(dungeon.boss.portrait.zoom)

    MKplus.frames.boss.text:SetText(keystone.name)
    MKplus.frames.keystone.text:SetText( "+" .. keystone.level)

    MKplus:PopulateAffixes(keystone)
end

function MKplus:PopulateAffixes(keystone)
    for i, affix in ipairs(keystone.affixes) do
        MKplus.frames.affixes[i].texture:SetTexture(affix.fileid)
    end
end

MKplus:CreateFrames()
MKplus:CreateAnimations()