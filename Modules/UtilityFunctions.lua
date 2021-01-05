local module = {}

--[[**
	<description>
	Sends empty lines for the amount of times specified in argument "Lines"
	</description>
	<parameter name = "Lines">
	[INT] - Number of empty lines to be logged
	</parameter>
**--]]
module.ClearOutput = function(Lines)
	--Repeats new line for specified times
	print(("\n"):rep(Lines)) 
end

--[[**
	<description>
	[WARNING: DOES NOT CHECK IF THE RPI_PROJECT MODULE SCRIPT EXISTS, IT CREATES A NEW MODULE SCRIPT] Creates the RPI_Project Module Script in ServerScriptService
	</description>
**--]]
module.CreateRPIProject = function()
	--Creates the RPI_Project Module Script and Sets it's parent and name
	local RPIProject = Instance.new("ModuleScript", game.ServerScriptService)
	RPIProject.Name = "RPI_Project"
	
	--Sets the RPI_Project Module Script to the Source of the template found in /Assets/RPI_Project_Template
	RPIProject.Source = script.Parent.Parent.Assets.RPI_Project_Template.Source
end

return module
