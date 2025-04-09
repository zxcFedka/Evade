if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId ~= 9872472334 then return end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Evade Hub", -- Changed Name
    Icon = 0,
    LoadingTitle = "Suka Hub",
    LoadingSubtitle = "by zxcFedka + community", -- Updated Subtitle to include community
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Big Hub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

local player = game.Players.LocalPlayer
local PlayerGui = player.PlayerGui

local MainTab = Window:CreateTab("General", nil) -- Changed Tab Name to "General" for better fit
local VisualTab = Window:CreateTab("Visuals") -- Added Visuals Tab
local GameTab = Window:CreateTab("Game") -- Added Game Tab
local ConfigsTab = Window:CreateTab("Settings") -- Added Settings Tab

local EvadeSector = MainTab:CreateSection("Character") -- Kept "Character" Section Name
local VisualsSector = VisualTab:CreateSection("Visuals") -- Visuals Section
local CreditsSector = MainTab:CreateSection("Credits") -- Kept Credits Section Name
local GameUtilSector = GameTab:CreateSection("Utils") -- Game Utils Section
local WorldSector = GameTab:CreateSection("World") -- World Settings Section
local ConfigsSector = ConfigsTab:CreateSection("Config") -- Configs Section, can rename if needed


getgenv().Settings = {
    moneyfarm = false,
    afkfarm = false,
    NoCameraShake = false,
    Downedplayeresp = false,
    AutoRespawn = false,
    TicketFarm = false,
    Speed = 1450, -- Initial Speed from the script
    Jump = 3,    -- Initial JumpPower from the script
    reviveTime = 3,
    DownedColor = Color3.fromRGB(255,0,0),
    PlayerColor = Color3.fromRGB(255,170,0),

    stats = {
        TicketFarm = {
            earned = nil,
            duration = 0
        },
        TokenFarm = {
            earned = nil,
            duration = 0
        }
    }
}

local WalkSpeedSlider = EvadeSector:CreateSlider({ -- Using Rayfield Slider
    Name = "Speed",
    Range = {1450, 12000}, -- From the provided script
    Increment = 100,      -- From the provided script
    Suffix = " studs/s", -- Added Suffix for clarity
    CurrentValue = Settings.Speed,
    Flag = "WalkSpeedSlider", -- Unique Flag
    Callback = function(Value)
        Settings.Speed = Value
    end
})


local JumpPowerSlider = EvadeSector:CreateSlider({ -- Using Rayfield Slider
    Name = "JumpPower",
    Range = {3, 20},      -- From the provided script
    Increment = 1,       -- From the provided script
    Suffix = " Power",   -- Added Suffix for clarity
    CurrentValue = Settings.Jump,
    Flag = "JumpPowerSlider", -- Unique Flag
    Callback = function(Value)
        Settings.Jump = Value
    end
})

WorldSector:CreateButton({ -- Rayfield Button
    Name = 'Full Bright',
    Callback = function()
       	game.Lighting.Brightness = 4
		game.Lighting.FogEnd = 100000
		game.Lighting.GlobalShadows = false
        game.Lighting.ClockTime = 12
    end
})

WorldSector:CreateToggle({ -- Rayfield Toggle
    Name = 'No Camera Shake',
    CurrentValue = Settings.NoCameraShake,
    Flag = "NoCameraShakeToggle", -- Unique Flag
    Callback = function(State)
        Settings.NoCameraShake = State
    end
})

GameUtilSector:CreateToggle({ -- Rayfield Toggle
    Name = 'Fast Revive',
    CurrentValue = false, -- Initial state, can be set based on Settings.reviveTime if needed
    Flag = "FastReviveToggle", -- Unique Flag
    Callback = function(State)
        if State then
            workspace.Game.Settings:SetAttribute("ReviveTime", 2.2)
        else
            workspace.Game.Settings:SetAttribute("ReviveTime", Settings.reviveTime)
        end
    end
})

EvadeSector:CreateToggle({ -- Rayfield Toggle
    Name = 'Auto Respawn',
    CurrentValue = Settings.AutoRespawn,
    Flag = "AutoRespawnToggle", -- Unique Flag
    Callback = function(State)
        Settings.AutoRespawn = State
    end
})

EvadeSector:CreateButton({ -- Rayfield Button
    Name = 'Respawn',
    Callback = function()
        game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
    end
})


FarmsTab = Window:CreateTab("Farms") -- Farms Tab
local FarmsSector = FarmsTab:CreateSection("Farms") -- Farms Section
local FarmStatsSector = FarmsTab:CreateSection("Stats") -- Farm Stats Section

FarmsSector:CreateToggle({ -- Rayfield Toggle
    Name = 'Money Farm',
    CurrentValue = Settings.moneyfarm,
    Flag = "MoneyFarmToggle", -- Unique Flag
    Callback = function(State)
        Settings.moneyfarm = State
    end
})

FarmsSector:CreateToggle({ -- Rayfield Toggle
    Name = 'Afk Farm',
    CurrentValue = Settings.afkfarm,
    Flag = "AfkFarmToggle", -- Unique Flag
    Callback = function(State)
        Settings.afkfarm = State
    end
})

VisualsSector:CreateToggle({ -- Rayfield Toggle for ESP Enable
    Name = 'Enable Esp',
    CurrentValue = Esp.Enabled,
    Flag = "EspEnableToggle", -- Unique Flag
    Callback = function(State)
        Esp.Enabled = State
    end
})

VisualsSector:CreateToggle({ -- Rayfield Toggle for Bot ESP
    Name = 'Bot Esp',
    CurrentValue = Esp.NPCs,
    Flag = "BotEspToggle", -- Unique Flag
    Callback = function(State)
        Esp.NPCs = State
    end
})

VisualsSector:CreateToggle({ -- Rayfield Toggle for Ticket ESP
    Name = 'Ticket Esp',
    CurrentValue = Esp.TicketEsp,
    Flag = "TicketEspToggle", -- Unique Flag
    Callback = function(State)
        Esp.TicketEsp = State
    end
})

VisualsSector:CreateToggle({ -- Rayfield Toggle for Downed Player ESP
    Name = 'Downed Player Esp',
    CurrentValue = Settings.Downedplayeresp,
    Flag = "DownedPlayerEspToggle", -- Unique Flag
    Callback = function(State)
        Settings.Downedplayeresp = State
    end
})

VisualsSector:CreateToggle({ -- Rayfield Toggle for Boxes ESP
    Name = 'Boxes',
    CurrentValue = Esp.Boxes,
    Flag = "BoxesEspToggle", -- Unique Flag
    Callback = function(State)
        Esp.Boxes = State
    end
})

VisualsSector:CreateToggle({ -- Rayfield Toggle for Tracers ESP
    Name = 'Tracers',
    CurrentValue = Esp.Tracers,
    Flag = "TracersEspToggle", -- Unique Flag
    Callback = function(State)
        Esp.Tracers = State
    end
})

VisualsSector:CreateToggle({ -- Rayfield Toggle for Players ESP
    Name = 'Players',
    CurrentValue = Esp.Players,
    Flag = "PlayersEspToggle", -- Unique Flag
    Callback = function(State)
        Esp.Players = State
    end
})

VisualsSector:CreateToggle({ -- Rayfield Toggle for Distance ESP
    Name = 'Distance',
    CurrentValue = Esp.Distance,
    Flag = "DistanceEspToggle", -- Unique Flag
    Callback = function(State)
        Esp.Distance = State
    end
})

VisualsSector:CreateColorpicker({ -- Rayfield Colorpicker for Player Color
    Name = "Player Color",
    DefaultColor = Settings.PlayerColor,
    Flag = "PlayerColorPicker", -- Unique Flag
    Callback = function(Color)
        Settings.PlayerColor = Color
    end
})

VisualsSector:CreateColorpicker({ -- Rayfield Colorpicker for Downed Player Color
    Name = "Downed Player Color",
    DefaultColor = Settings.DownedColor,
    Flag = "DownedPlayerColorPicker", -- Unique Flag
    Callback = function(Color)
        Settings.DownedColor = Color
    end
})

CreditsSector:CreateLabel({Text = "Developed By xCLY And batusd"}) -- Rayfield Label
CreditsSector:CreateLabel({Text = "UI Lib: Jans Lib"}) -- Rayfield Label
CreditsSector:CreateLabel({Text = "ESP Lib: Kiriot"}) -- Rayfield Label
ConfigsSector:CreateConfigSystem() -- Rayfield Config System

local TypeLabelC5 = FarmStatsSector:CreateLabel({Text = 'Auto Farm Stats'}) -- Rayfield Label
local DurationLabelC5 = FarmStatsSector:CreateLabel({Text = 'Duration: 0'}) -- Rayfield Label
local EarnedLabelC5 = FarmStatsSector:CreateLabel({Text = 'Earned: 0'}) -- Rayfield Label
--local TicketsLabelC5 = FarmStats:CreateLabel('Total Tickets:'..localplayer:GetAttribute('Tickets'))

local WorkspacePlayers = game:GetService("Workspace").Game.Players;
local Players = game:GetService('Players');
local localplayer = Players.LocalPlayer;

local FindAI = function()
    for _,v in pairs(WorkspacePlayers:GetChildren()) do
        if not Players:FindFirstChild(v.Name) then
            return v
        end
    end
end


local GetDownedPlr = function()
    for i,v in pairs(WorkspacePlayers:GetChildren()) do
        if v:GetAttribute("Downed") then
            return v
        end
    end
end

--Shitty Auto farm 🥶💀🤡💀🤡💀🤡
local revive = function()
    local downedplr = GetDownedPlr()
    if downedplr ~= nil and downedplr:FindFirstChild('HumanoidRootPart') then
        task.spawn(function()
            while task.wait() do
                if localplayer.Character then
                    workspace.Game.Settings:SetAttribute("ReviveTime", 2.2)
                    localplayer.Character:FindFirstChild('HumanoidRootPart').CFrame = CFrame.new(downedplr:FindFirstChild('HumanoidRootPart').Position.X, downedplr:FindFirstChild('HumanoidRootPart').Position.Y + 3, downedplr:FindFirstChild('HumanoidRootPart').Position.Z)
                    task.wait()
                    game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(tostring(downedplr), false)
                    task.wait(4.5)
                    game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(tostring(downedplr), true)
                    game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(tostring(downedplr), true)
                    game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer:FireServer(tostring(downedplr), true)
                    break
                end
            end
        end)
    end
end

--Kiriot
Esp:AddObjectListener(WorkspacePlayers, {
    Color =  Color3.fromRGB(255,0,0),
    Type = "Model",
    PrimaryPart = function(obj)
        local hrp = obj:FindFirstChild('HRP')
        while not hrp do
            wait()
            hrp = obj:FindFirstChild('HRP')
        end
        return hrp
    end,
    Validator = function(obj)
        return not game.Players:GetPlayerFromCharacter(obj)
    end,
    CustomName = function(obj)
        return '[AI] '..obj.Name
    end,
    IsEnabled = "NPCs",
})

--[[Esp:AddObjectListener(game:GetService("Workspace").Game.Effects.Tickets, {
    CustomName = "Ticket",
    Color = Color3.fromRGB(41,180,255),
    IsEnabled = "TicketEsp"
})]]

--Tysm CJStylesOrg
Esp.Overrides.GetColor = function(char)
   local GetPlrFromChar = Esp:GetPlrFromChar(char)
   if GetPlrFromChar then
       if Settings.Downedplayeresp and GetPlrFromChar.Character:GetAttribute("Downed") then
           return Settings.DownedColor
       end
   end
   return Settings.PlayerColor
end

local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local Args = {...}
    local method = getnamecallmethod()
    if tostring(self) == 'Communicator' and method == "InvokeServer" and Args[1] == "update" then
        return Settings.Speed, Settings.Jump
    end
    return old(self,...)
end))

local formatNumber = (function(value) -- //Credits: https://devforum.roblox.com/t/formatting-a-currency-label-to-include-commas/413670/3
	value = tostring(value)
	return value:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end)

function Format(Int) -- // Credits: https://devforum.roblox.com/t/converting-secs-to-hsec/146352
	return string.format("%02i", Int)
end

function convertToHMS(Seconds)
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return Format(Hours).."H "..Format(Minutes).."M "..Format(Seconds)..'S'
end

task.spawn(function()
    while task.wait(1) do
        --if Settings.TicketFarm then
        --    Settings.stats.TicketFarm.duration += 1
        --end
        if Settings.moneyfarm then
            Settings.stats.TokenFarm.duration += 1
        end
    end
end)

--local gettickets = localplayer:GetAttribute('Tickets')
local GetTokens = localplayer:GetAttribute('Tokens')

localplayer:GetAttributeChangedSignal('Tickets'):Connect(function()
    --local tickets = tostring(gettickets - localplayer:GetAttribute('Tickets'))
    --local cleanvalue = string.split(tickets, "-")
    Settings.stats.TicketFarm.earned = cleanvalue[2]
end)

localplayer:GetAttributeChangedSignal('Tokens'):Connect(function()
    local tokens = tostring(GetTokens - localplayer:GetAttribute('Tokens'))
    local cleanvalue = string.split(tokens, "-")
    print(cleanvalue[2])
    Settings.stats.TokenFarm.earned = cleanvalue[2]
end)

localplayer:GetAttributeChangedSignal('Tokens'):Connect(function()
    local tokens = tostring(GetTokens - localplayer:GetAttribute('Tokens'))
    local cleanvalue = string.split(tokens, "-")
    print(cleanvalue[2])
    Settings.stats.TokenFarm.earned = cleanvalue[2]
end)

task.spawn(function()
    while task.wait() do
        if Settings.TicketFarm then
            TypeLabelC5:Set('Ticket Farm')
            DurationLabelC5:Set('Duration:'..convertToHMS(Settings.stats.TicketFarm.duration))
            EarnedLabelC5:Set('Earned:'.. formatNumber(Settings.stats.TicketFarm.earned))
            --TicketsLabelC5:Set('Total Tickets: '..localplayer:GetAttribute('Tickets'))

            if game.Players.LocalPlayer:GetAttribute('InMenu') ~= true and localplayer:GetAttribute('Dead') ~= true then
                for i,v in pairs(game:GetService("Workspace").Game.Effects.Tickets:GetChildren()) do
                    localplayer.Character.HumanoidRootPart.CFrame = CFrame.new(v:WaitForChild('HumanoidRootPart').Position)
                end
            else
                task.wait(2)
                game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
            end
            if localplayer.Character and localplayer.Character:GetAttribute("Downed") then
                game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
                task.wait(2)
            end
        end
    end
end)


task.spawn(function()
    while task.wait() do
        if Settings.AutoRespawn then
             if localplayer.Character and localplayer.Character:GetAttribute("Downed") then
                game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
             end
        end

        if Settings.NoCameraShake then
            localplayer.PlayerScripts.CameraShake.Value = CFrame.new(0,0,0) * CFrame.new(0,0,0)
        end
        if Settings.moneyfarm then
            TypeLabelC5:Set('Money Farm')
            DurationLabelC5:Set('Duration:'..convertToHMS(Settings.stats.TokenFarm.duration))
            EarnedLabelC5:Set('Earned:'.. formatNumber(Settings.stats.TokenFarm.earned))
            --TicketsLabelC5:Set('Total Tokens: '..formatNumber(localplayer:GetAttribute('Tokens')))

            if localplayer:GetAttribute("InMenu") and localplayer:GetAttribute("Dead") ~= true then
                game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
            end
            if localplayer.Character and localplayer.Character:GetAttribute("Downed") then
                game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
                task.wait(3)
            else
                revive()
                task.wait(1)
            end

        end
        if Settings.moneyfarm == false and Settings.afkfarm and localplayer.Character:FindFirstChild('HumanoidRootPart') ~= nil then
            localplayer.Character:FindFirstChild('HumanoidRootPart').CFrame = CFrame.new(6007, 7005, 8005)
        end
    end
end)

--Infinite yield's Anti afk
local GC = getconnections or get_signal_cons
	if GC then
		for i,v in pairs(GC(localplayer.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end
	else
		localplayer.Idled:Connect(function()
			local VirtualUser = game:GetService("VirtualUser")
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end

print("Evade Hub Loaded")