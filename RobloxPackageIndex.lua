local LogService = game:GetService("LogService")
local HttpService = game:GetService("HttpService")

--Create Toolbar
local toolbar = plugin:CreateToolbar("Roblox Package Index")

local button = toolbar:CreateButton("Roblox Package Index", 'Run "rpi help" in the command line to get started.', "rbxassetid://4458901886")

--"Clear Output" function (Adds empty lines)
--[[
ARGS:
lines - number: Number of empty lines
]]--
local function clearOutput(lines)
	print(("\n"):rep(lines)) 
end

--Install Package Function
--[[
ARGS:
pkgName - string: Package Name
ver - number: Version
]]--
local function installPackage(pkgName, ver)
	--Check for package name
	if (pkgName == nil) then
		warn('[RPI]-[ERROR]: No package name found, aborting...')
		return "failed"
	end
	
	--The code for instalation
	local Install = nil

	warn('[RPI]-[INSTALL]: Searching for "'.. pkgName ..'" at version "'.. ver ..'" in the Roblox Package Index...')
	
	--Check for Package Existance
	local function checkPackage()
		local check = pcall(function()
			local Branch = HttpService:GetAsync("https://raw.githubusercontent.com/ErikMCM/RobloxPackageIndex/"..pkgName.."/Main.lua")
		end)
		
		return check		
	end
	
	--Check for Package Version Existance
	local function checkPackageVer()
		local check = pcall(function()
			local PackageVer = HttpService:GetAsync("https://raw.githubusercontent.com/ErikMCM/RobloxPackageIndex/"..pkgName.."/v".. ver .."/Main.lua")
		end)

		return check		
	end
	
	--Package Existance Check
	if checkPackage() == false then
		warn('[RPI]-[ERROR]: Package not found, aborting...')
		return "failed"
	end
	
	--If the version isnt latest, check the version and set install to that version
	if (ver ~= "latest") then
		if checkPackageVer() == false then
			warn('[RPI]-[ERROR]: Package "'.. pkgName..'" was found, but the version "'..ver..'" was not. Aborting...')
			return "failed"
		end
		
		Install = HttpService:GetAsync("https://raw.githubusercontent.com/ErikMCM/RobloxPackageIndex/"..pkgName.."/v".. ver .."/Main.lua")
	else 
		--Sets install to the latest version not in a folder
		Install = HttpService:GetAsync("https://raw.githubusercontent.com/ErikMCM/RobloxPackageIndex/"..pkgName.."/Main.lua")
	end
	
	--Notifies that the Package was found
	warn('[RPI]-[INSTALL]: Package "'..pkgName..'" was found at version "'..ver..'".')
	
	--Checking for ServerScriptService/RPI_Modules/<PackageName>
	if not (game.ServerScriptService:FindFirstChild("RPI_Modules")) then
		local folder = Instance.new("Folder", game.ServerScriptService)
		folder.Name = "RPI_Modules"
	end
	
	if not (game.ServerScriptService.RPI_Modules:FindFirstChild(pkgName)) then
		local folder = Instance.new("Folder", game.ServerScriptService.RPI_Modules)
		folder.Name = pkgName
	end
	
	--Notifies installation is occuring
	warn('[RPI]-[INSTALL]: Installing...')
	
	--Clears all items in old folder for that package
	game.ServerScriptService.RPI_Modules[pkgName]:ClearAllChildren()
	--Creates the module script + sets it's source
	local module = Instance.new("ModuleScript", game.ServerScriptService.RPI_Modules[pkgName])
	module.Name = "Main"
	module.Source = Install
	
	--Notifies completed installation
	warn('[RPI]-[INSTALL]: Complete!')
	warn('[RPI]-[INSTALL]: Successfully installed "'..pkgName..'" at version "'..ver..'"!')
end

--MessageOut happens when a command in the toolbar is ran
LogService.MessageOut:Connect(function(Message, Type)
	if string.find(Message, "^rpi") then
		warn("[RPI]-[IGNORE]: Ignore the Roblox Studio Error above, Roblox doesn't have official support for Custom Studio Command Bar commands.")
		clearOutput(25)
		--Stops at the : in the error that gets reported to log service | no package name or option will have :
		local placement = string.split(tostring(string.find(Message, ":")), " ")
		local finalMessage = string.sub(Message, 1, tonumber(placement[1]) - 1)
		local Arguments = string.split(finalMessage, " ")

		--Variables for options
		local ver = "latest"
		local pkgName = nil


		--Checks if the command regards installation
		if Arguments[2] == "install" or Arguments[2] == "i" then
			--Checks if the command regards options
			if Arguments[3] == "-v" then
				--We check if the 4th args is a number for the version
				if tonumber(Arguments[4]) then
					ver = Arguments[4]
				end
				
			--Arguments 3 isnt a command, so its a package @latest
			elseif Arguments[3] ~= nil then
				pkgName = Arguments[3]
			end
			
			--Arguments 5 will only happen if there's options, set it to the package name
			if Arguments[5] then
				pkgName = Arguments[5]
			end
			
			--Install the package
			installPackage(pkgName, ver)
		end

		--Checks if the command regards help
		if Arguments[2] == "help" or Arguments[2] == "h" then
			warn("[RPI]-[HELP]:\nHello there! Welcome to the wonderful world of the Roblox Package Index. All packages on the Roblox Package Index have been reviewed by offical moderators to make sure no scripts are harmful to your games.\n\nCommands:\nrpi install [Package Name]")
		end
	end
end)
