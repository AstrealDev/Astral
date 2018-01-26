local RS				= game:GetService("ReplicatedStorage");
local SSS				= game:GetService("ServerScriptService");
local SPR				= game:GetService("StarterPlayer");
local PLS				= game:GetService("Players");

local player			= PLS.LocalPlayer;

wait();

local RS_Astral			= RS:FindFirstChild("Astral");
local EventsFolder		= RS_Astral:FindFirstChild("Events");
local MessageEvent		= EventsFolder:FindFirstChild("Message");

local MessageUI			= player.PlayerGui:WaitForChild("MessageUI");

if (RS_Astral == nil) then
	repeat
		wait();
	until RS:FindFirstChild("Astral") ~= nil;
	RS_Astral = RS:FindFirstChild("Astral");
	if (RS_Astral == nil) then
		script.Disabled = true;
	end
end

if (EventsFolder == nil) then
	repeat
		wait();
	until RS_Astral:FindFirstChild("Events") ~= nil;
	EventsFolder = RS_Astral:FindFirstChild("Events");
	if (EventsFolder == nil) then
		script.Disabled = true;
	end
end

if (MessageEvent == nil) then
	MessageEvent = Instance.new("RemoteEvent", EventsFolder);
	MessageEvent.Name = "Message";
end

MessageEvent.OnClientEvent:Connect(function(request, ...)
	if (string.lower(request) == "sendmessage") then
		local args								= {...};
		
		local players							= args[1] or {};
		local message							= args[2] or "ASTRAL_MESSAGE_EVENT_ERROR";
		local timeout							= args[3] or 3;
		
		for _, _player in pairs(PLS:GetPlayers()) do
			for _, _tabPlayer in pairs(players) do
				if (string.lower(_player.Name) == string.lower(_tabPlayer)) then
					local _MessageUI						= _player.PlayerGui:FindFirstChild("MessageUI");
					_MessageUI.MessageFrame.Position		= UDim2.new(0, 0, -1, 0);
					_MessageUI.Enabled						= true;
					_MessageUI.MessageFrame.Message.Text	= message;
					_MessageUI.MessageFrame:TweenPosition(UDim2.new(0, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 3);
					wait(timeout);
					_MessageUI.MessageFrame:TweenPosition(UDim2.new(0, 0, 1.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 3);
					wait(1);
					_MessageUI.Enabled						= false;
				end
			end
		end
	end
end)