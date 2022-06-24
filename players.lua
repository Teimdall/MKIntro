local addonName, MKIntro = ...

function MKIntro:GetRoleIcon(role)
    local role_texture_id
    if role == "TANK" then
        role_texture_id = "Interface\\AddOns\\MKIntro\\Media\\Textures\\Tank.tga"
    elseif role == "HEALER" then
        role_texture_id = "Interface\\AddOns\\MKIntro\\Media\\Textures\\Healer.tga"
    else
        role_texture_id = "Interface\\AddOns\\MKIntro\\Media\\Textures\\DPS.tga"
    end
    return role_texture_id
end

function MKIntro:OnInspectUpdate(event, guid, unit, info)
    local unit_name = self.LI:GuidToUnit(guid)

    --Clear info for guid
    self:RemovePlayer(guid)

    if not info.name or not info.class then return end

    self.players[unit_name] = {}
    --Unique ID for player
    self.players[unit_name].guid = guid

    --Set name
    self.players[unit_name].name = info.name

    --Set class
    self.players[unit_name].class = info.class

    --Set Spec info
    self.players[unit_name].spec = {
        name = info.spec_name_localized,
        icon = info.spec_icon
    }

    --Set role
    self.players[unit_name].role = info.spec_role

    --Set M+ rating
    local rating = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit)
    if rating ~= nil then
        self.players[unit_name].rating = rating.currentSeasonScore
    else
        self.players[unit_name].rating = 0
    end

    self.number_of_player = self:CountPlayers()
end

function MKIntro:OnInspectRemove (event, guid)
    self:RemovePlayer(guid)
    self.number_of_player = self:CountPlayers()
end

function MKIntro:RemovePlayer(guid)
    local unit_name = self.LI:GuidToUnit(guid)
    --Clear info for guid
    if self.players[unit_name] ~= nil then
        self.players[unit_name] = nil
    end
end

function MKIntro:CountPlayers()
    local count = 0
    for k,v in pairs(self.players) do
        count = count + 1
    end
    return count
end