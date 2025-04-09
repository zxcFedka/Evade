-- Проверка PlaceId и загрузка Rayfield (как в первом скрипте)
if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId ~= 9872472334 then return end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

-- Создание окна Rayfield (как в первом скрипте)
local Window = Rayfield:CreateWindow({
    Name = "Evade Helper",
    Icon = 0,
    LoadingTitle = "Suka Hub Lite",
    LoadingSubtitle = "by zxcFedka",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Big Hub Lite"
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
local RunService = game:GetService("RunService")

-- --- Таблица настроек из второго скрипта (только для скорости/прыжка) ---
getgenv().Settings = {
    Speed = 16, -- Начальное значение скорости (стандартное)
    Jump = 50,   -- Начальное значение силы прыжка (стандартное)
}

-- --- Логика переключения GUI (из первого скрипта) ---
local GuiEnabled = true -- Начинаем с видимого GUI (или false, если хочешь скрытое)

function ToggleGuiVisibility()
    for i, gui in pairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" then
             pcall(function()
                 if gui.Enabled and gui.ResetOnSpawn == false then
                    gui.Enabled = false
                 elseif not gui.Enabled then
                    gui.Enabled = true
                 end
             end)
        end
    end
    -- Обновляем GuiEnabled *после* переключения, чтобы отразить новое состояние
    local anyGuiVisible = false
    for i, gui in pairs(PlayerGui:GetChildren()) do
         if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" and gui.Enabled then
             anyGuiVisible = true
             break
         end
    end
    GuiEnabled = anyGuiVisible -- Устанавливаем в true, если хотя бы один GUI видим
end

-- --- Создание UI ---
local MainTab = Window:CreateTab("Home", nil)

-- --- Секция управления GUI ---
local ControlsSection = MainTab:CreateSection("Controls")

local ToggleGui = MainTab:CreateToggle({
    Name = "Toggle Game Gui",
    CurrentValue = GuiEnabled,
    Flag = "GuiToggle",
    Callback = function(Value)
        ToggleGuiVisibility()
        -- После вызова ToggleGuiVisibility, обновим состояние кнопки,
        -- так как GuiEnabled обновляется внутри той функции
        -- ToggleGui:Set(GuiEnabled)
    end,
 })

 local KeybindGui = MainTab:CreateKeybind({
    Name = "Gui Toggle Bind",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "GuiKeybind",
    Callback = function(Keybind)
        ToggleGuiVisibility()
    end,
 })

-- <<<< ИСПРАВЛЕНИЕ: Разделитель создается в ТАБЕ, а не в секции >>>>
MainTab:CreateDivider()

-- --- Секция управления Speed/Jump ---
local SpeedJumpSection = MainTab:CreateSection("Movement")

local WalkSpeedSlider = MainTab:CreateSlider({
    Name = "Speed",
    Range = {16, 150},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = Settings.Speed,
    Flag = "HookSpeedSlider",
    Callback = function(Value)
        Settings.Speed = Value
    end
})

local JumpPowerSlider = MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},
    Increment = 1,
    Suffix = " power",
    CurrentValue = Settings.Jump,
    Flag = "HookJumpSlider",
    Callback = function(Value)
        Settings.Jump = Value
    end
})

-- --- Механизм изменения скорости/прыжка через hookmetamethod (из второго скрипта) ---
local old_namecall
old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and tostring(self) == "Communicator" and method == "InvokeServer" and args[1] == "update" then
        return Settings.Speed, Settings.Jump
    end

    return old_namecall(self, ...)
end))

print("Evade Helper (GUI Toggle + Hook Speed) Loaded - UI Corrected")