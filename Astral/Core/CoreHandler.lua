local CoreHandler		= {};

local RS	= game:GetService("ReplicatedStorage");
local SSS	= game:GetService("ServerScriptService");
local SPR	= game:GetService("StarterPlayer");
local PLS	= game:GetService("Players");

local Astral;
local Settings;
local Str;
local MessageEvent;

math.randomseed(tick());

--// A function to test if the script requiring the core is client sided
function isLocal()
	if (PLS.LocalPlayer == nil) then
		return false;
	end
	return true;
end

--// A function used to send a warning message
function cWarn(message)
	warn("----------------------------------------\n" .. message .. "\n----------------------------------------\n");
end

--// Loads the core
function CoreHandler:Load(sessionID)
	--// Check to see if this method is being called locally
	if (isLocal()) then
		cWarn("Can't use CoreHandler locally!");
		return;
	end
	
	--// Set Astral's sessionID to the passed sessionID
	_G.Astral.__sessionID 	= sessionID;
	
	--// Assume _G.Astral has been defined
	Astral 					= _G.Astral;
	
	--// Set the settings, and apis
	Settings 				= require(Astral.Settings);
	Str 					= require(Astral.API.StringAPI);
	
	--// Set the message event
	MessageEvent			= Astral.Events.Message;
	
	--// A local function used for getting a player via a string
	local function GetPlayerViaString(exec, str)
		local final = {};
		if (Str:Low(str) ~= "all" and Str:Low(str) ~= "others" and Str:Low(str) ~= "random" and Str:Low(str) ~= "me") then
			for _, _player in pairs(PLS:GetPlayers()) do
				if (Str:Low(Str:Sub(_player.Name, 1, Str:Len(str))) == Str:Low(str)) then
					return {_player};
				end
			end
		elseif (Str:Low(str) == "all") then
			for _, _player in pairs(PLS:GetPlayers()) do
				table.insert(final, _player);
			end
		elseif (Str:Low(str) == "others") then
			for _, _player in pairs(PLS:GetPlayers()) do
				if (_player.UserId ~= exec.UserId) then
					table.insert(final, _player);
				end
			end
		elseif (Str:Low(str) == "me") then
			table.insert(final, exec);
		elseif (Str:Low(str) == "random") then
			table.insert(final, PLS:GetPlayers()[math.random(1, #PLS:GetPlayers())]);
		end
		return final;
	end
	
	--// A local function for checking a player's rank
	local function GetPlayerRank(_player)
		for _identity, _rank in pairs(Settings.RankedUsers or {}) do
			if (tonumber(_identity) ~= nil) then
				if (_player.UserId == _identity) then
					return _rank or 0;
				end
			else
				if (_player.Name == _identity) then
					return _rank or 0;
				end
			end
		end
		return 0;
	end
	
	--// A local function used for reloading the chat events
	local function ChatEventReload()
		for _, player in pairs(PLS:GetPlayers()) do
			player.Chatted:Connect(function(message)
				
				local CommandRun;
				local MessageSplit = {};
				local CommandBody = Str:Match(message, "^" .. (Settings.Prefix or ":") .. "(.*)") or Str:Match(message, "^/e " .. (Settings.Prefix or ":") .. "(.*)")
				
				if (CommandBody ~= nil and CommandBody ~= "" and CommandBody ~= " ") then
					print(CommandBody);
					
					for index in string.gmatch(CommandBody, "%S+") do
						table.insert(MessageSplit, index);
					end
					
					for _, _CommandModule in pairs(Astral.Commands:GetChildren()) do
						local _Command		= require(_CommandModule);
						for _, _UsageStr in pairs(_Command.Usages or {}) do
							if (Str:Low(MessageSplit[1]) == Str:Low(_UsageStr)) then
								CommandRun = _Command;
							end
						end
					end
				end
				
				if (CommandRun ~= nil) then
					local FinalizedArguments	= {};
					
					for _index, _FormattedArg in pairs(CommandRun.ArgsFormat) do
						if (MessageSplit[_index + 1] ~= nil) then
							if (Str:Low(_FormattedArg) == "p") then
								local _AttemptedPlayer = GetPlayerViaString(player, MessageSplit[_index + 1]);
								table.insert(FinalizedArguments, _AttemptedPlayer);
							elseif (Str:Low(_FormattedArg) == "s") then
								table.insert(FinalizedArguments, MessageSplit[_index + 1]);
							elseif (Str:Low(_FormattedArg) == "n") then
								table.insert(FinalizedArguments, tonumber(MessageSplit[_index + 1]));
							elseif (Str:Low(_FormattedArg) == "pt") then
								local _Tab = {};
								for _index2 in string.gmatch(MessageSplit[_index + 1], "[^%" .. (Settings.Separator or ",") .. "]+") do
									table.insert(_Tab, GetPlayerViaString(player, _index2));
								end
								table.insert(FinalizedArguments, _Tab);
							elseif (Str:Low(_FormattedArg) == "nt") then
								local _Tab = {};
								for _index2 in string.gmatch(MessageSplit[_index + 1], "[^%" .. (Settings.Separator or ",") .. "]+") do
									table.insert(_Tab, tonumber(_index2));
								end
								table.insert(FinalizedArguments, _Tab);
							elseif (Str:Low(_FormattedArg) == "st") then
								local _Tab = {};
								for _index2 in string.gmatch(MessageSplit[_index + 1], "[^%" .. (Settings.Separator or ",") .. "]+") do
									table.insert(_Tab, _index2);
								end
								table.insert(FinalizedArguments, _Tab);
							end
						else
							if (#FinalizedArguments >= CommandRun.RequiredArgs) then
								break;
							end
						end
					end
					
					if (#FinalizedArguments >= CommandRun.RequiredArgs) then
						CommandRun.Execute(player, unpack(FinalizedArguments));
					else
						MessageEvent:FireClient(player,
							"sendmessage",
							{player.Name},
							"Incorrect usage! Correct usage is: " .. (Settings.Prefix or ":") .. CommandRun.UsageString,
							3
						);
					end
				end
			end)
		end
	end
	
	--// Reload the chat events upon a player joining
	PLS.PlayerAdded:Connect(function(player)
		ChatEventReload();
	end)
	
	--// Reload the chat events upon a player leaving
	PLS.PlayerRemoving:Connect(function(player)
		ChatEventReload();
	end)
end

--// A function used to disconnect Astral
function CoreHandler:Close(sessionID)
	--// Check to see if this method is being called locally
	if (isLocal()) then
		return;
	else
		cWarn("Can't use CoreHandler locally!");
	end
	
	--// Make sure the sessionID passed is correct
	if (sessionID == Astral.__sessionID) then
		cWarn("Astral's core has been\nclosed / disconnected!");
		function self:Load()
			cWarn("Astral's core has been\nclosed / disconnected\nmaking the CoreHandler\nobselete.");
		end
	end
end

return CoreHandler;