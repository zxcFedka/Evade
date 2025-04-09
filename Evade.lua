if not game.PlaceId == 9872472334 then return end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Evade",
    Icon = 0,
    LoadingTitle = "Suka Hub",
    LoadingSubtitle = "by zxcFedka",
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

local MainTab = Window:CreateTab("Home", nil)
local MineSection = MainTab:CreateSection("Main")
MineSection:Set("Main")

MainTab:CreateDivider()

local GuiEnabled = true

function Gui()
    for i,gui in PlayerGui:GetChildren() do
        print(gui)
        gui.Enabled = not gui.Enabled
    end

    GuiEnabled = not GuiEnabled
end

local Toggle = MainTab:CreateToggle({
    Name = "Gui",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        Gui()
    end,
 })

 local Keybind = MainTab:CreateKeybind({
    Name = "Gui bind",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Keybind)

        Toggle:Set(GuiEnabled)
        Gui()
    end,
 })

MainTab:CreateDivider()

local Slider = MainTab:CreateSlider({
    Name = "Speed boost)))))))))))))))",
    Range = {0, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        print(Value)
    end,
 })