local addonName, MKIntro = ...

MKIntro.dungeons = {
    ["DoS"]={
        zone_id = 377,
        boss = {
            model_id = 96358,
            portrait = {
                zoom = 0.3,
                position = {
                    x = 0,
                    y = 0,
                    z = 0
                }
            }
        },
        color = { r="114", g="28", b="172" }
    },
    ["HoA"]={
        zone_id = 378,
        boss = {
            model_id = 95103,
            portrait = {
                zoom = 0.45,
                position = {
                    x = 0.45,
                    y = -0.25,
                    z = -0.15
                }
            }
        },
        color = { r="247", g="24", b="33" }
    },
    ["MoTS"]={
        zone_id = 375,
        boss = {
            model_id = 95809,
            portrait = {
                zoom = 0.65,
                position = {
                    x = 2,
                    y = 5,
                    z = -0.5
                }
            }
        },
        color = { r="80", g="142", b="189" }
    },
    ["PF"]={
        zone_id = 379,
        boss = {
            model_id = 95794,
            portrait = {
                zoom = 0.8,
                position = {
                    x = 0,
                    y = 0.1,
                    z = 0
                }
            }
        },
        color = { r="57", g="171", b="104" }
    },
    ["SD"]={
        zone_id = 380,
        boss = {
            model_id = 95721,
            portrait = {
                zoom = 0.75,
                position = {
                    x = 0,
                    y = 0.2,
                    z = 0
                }
            }
        },
        color = { r="206", g="32", b="33" }
    },
    ["SoA"]={
        zone_id = 381,
        boss = {
            model_id = 95665,
            portrait = {
                zoom = 0.7,
                position = {
                    x = 0,
                    y = 0.2,
                    z = -0.1
                }
            }
        },
        color = { r="88", g="198", b="253" }
    },
    ["NW"]={
        zone_id = 376,
        boss = {
            model_id = 96085,
            portrait = {
                zoom = 0.65,
                position = {
                    x = 0,
                    y = 0,
                    z = -0.1
                }
            }
        },
        color = { r="32", g="139", b="103" }
    },
    ["ToP"]={
        zone_id = 382,
        boss = {
            model_id = 96078,
            portrait = {
                zoom = 0.8,
                position = {
                    x = 0,
                    y = 0.3,
                    z = 0
                }
            }
        },
        color = { r="41", g="112", b="63" }
    },
    ["STRT"]={
        zone_id = 391,
        boss = {
            model_id = 99094,
            portrait = {
                zoom = 0.5,
                position = {
                    x = 0,
                    y = 0,
                    z = 0
                }
            }
        },
        color = { r="132", g="208", b="240" }
    },
    ["GMBT"]={
        zone_id = 392,
        boss = {
            model_id = 100737,
            portrait = {
                zoom = 0.5,
                position = {
                    x = 0.25,
                    y = 0.25,
                    z = 0
                }
            }
        },
        color = { r="132", g="208", b="240" }
    }
}

function MKIntro:GetDungeonFromZoneId(id)
    for index in pairs(self.dungeons) do
        if self.dungeons[index].zone_id == id then
            return self.dungeons[index]
        end
    end
end