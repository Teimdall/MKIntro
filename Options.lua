local addonName, MKIntro = ...

function MKIntro:InitOptions()

    local options = {
        name = addonName,
        handler = self,
        type = "group",
        args = {
            debug = {
                type = "toggle",
                name = "Debug Mode",
                desc = nil,
                get = function(info) return MKIntro.debug.enabled end,
                set = function(info, value) 
                    if value then
                        MKIntro:EnableDebugMode()
                    else
                        MKIntro:DisableDebugMode()
                    end
                end
            }
        }
    }

    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)
	self.options = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, addonName)
end