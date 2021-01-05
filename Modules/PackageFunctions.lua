local HttpService = game:GetService("HttpService")

local module = {}

--[[**
	<description>
	Checks if GitHub branch for the Package Name exists
	</description>
	<parameter name = "PackageName">
	[STRING] - The name of the package to check
	</parameter>
	<returns>
	[BOOL] - true if the Package was found, false if the package was not found
	</returns>
**--]]
module.CheckPackageExistance = function(PackageName)
	local check = pcall(function()
		local Branch = HttpService:GetAsync("https://raw.githubusercontent.com/ErikMCM/RobloxPackageIndex/"..PackageName.."/RPI_Project.lua")
	end)

	return check		
end

module.CheckPackageVersionExistance = function(PackageName, PackageVersion)
	local check = pcall(function()
		local PackageVer = HttpService:GetAsync("https://raw.githubusercontent.com/ErikMCM/RobloxPackageIndex/"..PackageName.."/v".. PackageVersion .."/Main.lua")
	end)

	return check	
end

return module
