MKplus.unit_names = {"player", "party1", "party2", "party3", "party4"}
MKplus.number_of_player = 0
MKplus.players = {}

function MKplus:GetRoleIcon(role)
    local role_texture_id
    if role == "TANK" then
        role_texture_id = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Tank.tga"
    elseif role == "HEALER" then
        role_texture_id = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Healer.tga"
    else
        role_texture_id = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\DPS.tga"
    end
    return role_texture_id
end

function MKplus:OnInspectUpdate(event, guid, unit, info)
    local unit_name = MKplus.li:GuidToUnit(guid)

    --Clear info for guid
    MKplus:RemovePlayer(guid)

    if not info.name or not info.class then return end

    MKplus.players[unit_name] = {}
    --Unique ID for player
    MKplus.players[unit_name].guid = guid

    --Set name
    MKplus.players[unit_name].name = info.name

    --Set class
    MKplus.players[unit_name].class = info.class

    --Set Spec info
    MKplus.players[unit_name].spec = {
        name = info.spec_name_localized,
        icon = info.spec_icon
    }

    --Set role
    MKplus.players[unit_name].role = info.spec_role

    --Set M+ rating
    local rating = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit)
    if rating ~= nil then
        MKplus.players[unit_name].rating = rating.currentSeasonScore
    else
        MKplus.players[unit_name].rating = 0
    end

    MKplus.number_of_player = MKplus:CountPlayers()
end

function MKplus:OnInspectRemove (event, guid)
    MKplus:RemovePlayer(guid)
    MKplus.number_of_player = MKplus:CountPlayers()
end

function MKplus:RemovePlayer(guid)
    local unit_name = MKplus.li:GuidToUnit(guid)
    --Clear info for guid
    if MKplus.players[unit_name] ~= nil then
        MKplus.players[unit_name] = nil
    end
end

function MKplus:CountPlayers()
    local count = 0
    for k,v in pairs(MKplus.players) do
        count = count + 1
    end
    return count
end

MKplus.li = LibStub:GetLibrary("LibGroupInSpecT-1.1")
MKplus.li.RegisterCallback (MKplus, "GroupInSpecT_Update", "OnInspectUpdate")
MKplus.li.RegisterCallback (MKplus, "GroupInSpecT_Remove", "OnInspectRemove")