--Constant Requires
local LogService = game:GetService("LogService")
local HttpService = game:GetService("HttpService")

local Util = require(script.Parent.Modules.UtilityFunctions)

--Initialize Toolbar Plugin
local Toolbar = plugin:CreateToolbar("Roblox Package Index")
local Button = Toolbar:CreateButton("Roblox Package Index", 'Run "rpi help" in the command line to get started.', "rbxassetid://4458901886")




