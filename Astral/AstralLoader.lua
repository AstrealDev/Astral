--[[
	Loads in Astral and unpacks things
--]]

--// Set a random seed for math.random()
math.randomseed(tick());

--// Get services
local RS					= game:GetService("ReplicatedStorage");
local SSS					= game:GetService("ServerScriptService");
local SPR					= game:GetService("StarterPlayer");

--// Parent the Astral head folder to server script service
script.Parent.Parent 		= SSS;

--// Used to access all contents of Astral
_G.Astral 					= {};

--// Loop through all contents of Astral
for _, object in pairs(script:GetChildren()) do
	--// Create a reference to every object
	_G.Astral[object.Name] 	= object;
end

--// Get a local reference to _G.Astral
local Astral 				= _G.Astral;

--// Unpack the client
Astral.Client.Parent 		= SPR.StarterPlayerScripts;

--// Create a folder which will store events & functions
local AstralRSFolder		= Instance.new("Folder", RS);
AstralRSFolder.Name			= "Astral";
Astral.Events.Parent 		= AstralRSFolder;
Astral.Functions.Parent		= AstralRSFolder;

--// Load UIs
Astral.UI.MessageUI.Parent	= game.StarterGui;

--// Require the core
local AstralCore			= require(Astral.Core.CoreHandler);

--// Require the StringAPI
local StringAPI				= require(Astral.API.StringAPI);

--// Load the core
local sessionID				= StringAPI:genRandomString(30);
AstralCore:Load(sessionID);