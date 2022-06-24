local addonName, MKIntro = ...

local defaults = {
    profile = {
		debug = {
            enabled = false,
            dungeon = {
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
            keystone = {
                map_id = 123,
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
        }
	}
}

function MKIntro:InitOptions()
    local options = {
        type = "group",
        name = "MKIntro",
        args = {}
    }

    options.args.debug = {
        name = "Debug Mode",
        handler = self,
        type = "group",
        order = 2,
        args = {
            debug = {
                type = "toggle",
                name = "Debug Mode",
                desc = nil,
                get = function(info) return self.ADB.profile.debug.enabled end,
                set = function(info, value)
                    if value then
                        MKIntro:EnableDebugMode()
                    else
                        MKIntro:DisableDebugMode()
                    end
                end
            },
            model = {
                type = "input",
                name = "Model",
                desc = "The model id to display in debug mode for boss frame",
                usage = "<file id of boss>",
                get = function(info) return self.ADB.profile.debug.dungeon.boss.model_id end,
                set = function(info, value) self.ADB.profile.debug.dungeon.boss.model_id = value end
            }
        }
    }

    self.ADB = LibStub("AceDB-3.0"):New(addonName .. "DB", defaults)

    local config = LibStub("AceConfig-3.0")
    local dialog = LibStub("AceConfigDialog-3.0")

    config:RegisterOptionsTable("MKIntro", options)
    self.options = dialog:AddToBlizOptions("MKIntro", options.name)
    config:RegisterOptionsTable("MKIntro-DebugMode", options.args.debug)
	dialog:AddToBlizOptions("MKIntro-DebugMode", options.args.debug.name, "MKIntro")
end