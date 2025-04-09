-- Проверка PlaceId и загрузка Rayfield (как в первом скрипте)
if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId ~= 9872472334 then return end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

-- Создание окна Rayfield (как в первом скрипте)
local Window = Rayfield:CreateWindow({
    Name = "Evade Helper", -- Немного изменил название
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
    -- Можно оставить другие настройки из getgenv(), если они нужны для чего-то еще,
    -- но для скорости/прыжка используются только эти два.
}

-- --- Логика переключения GUI (из первого скрипта) ---
local GuiEnabled = true -- Начинаем с видимого GUI (или false, если хочешь скрытое)

function ToggleGuiVisibility()
    -- Итерируем по основным GUI в PlayerGui
    for i, gui in pairs(PlayerGui:GetChildren()) do
        -- Проверяем, что это ScreenGui и не сам Rayfield
        if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" then
             pcall(function() -- Используем pcall для безопасности
                 -- Инвертируем видимость
                 -- Учтем ResetOnSpawn, чтобы не сломать GUI, которые должны быть видимы
                 if gui.Enabled and gui.ResetOnSpawn == false then
                    gui.Enabled = false
                 elseif not gui.Enabled then
                    gui.Enabled = true
                 end
             end)
        end
    end
    GuiEnabled = not GuiEnabled -- Обновляем состояние флага
end

-- --- Создание UI ---
local MainTab = Window:CreateTab("Home", nil)
local ControlsSection = MainTab:CreateSection("Controls")

-- --- Элементы управления GUI Toggle (из первого скрипта) ---
ControlsSection:CreateDivider()

local ToggleGui = ControlsSection:CreateToggle({
    Name = "Toggle Game Gui",
    CurrentValue = GuiEnabled, -- Используем текущее состояние
    Flag = "GuiToggle", -- Уникальный флаг
    Callback = function(Value)
        -- Value здесь - новое состояние переключателя (true/false)
        -- Нам нужно просто вызвать нашу функцию переключения
        ToggleGuiVisibility()
        -- Rayfield сам обновит визуальное состояние переключателя,
        -- но нам нужно синхронизировать нашу переменную GuiEnabled
        GuiEnabled = Value
    end,
 })

 local KeybindGui = ControlsSection:CreateKeybind({
    Name = "Gui Toggle Bind",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "GuiKeybind", -- Уникальный флаг
    Callback = function(Keybind)
        ToggleGuiVisibility()
        ToggleGui:Set(GuiEnabled) -- Обновляем состояние кнопки в UI
    end,
 })

-- --- Элементы управления Speed/Jump (новый метод) ---
ControlsSection:CreateDivider()
local SpeedJumpSection = MainTab:CreateSection("Movement")

local WalkSpeedSlider = SpeedJumpSection:CreateSlider({
    Name = "Speed",
    Range = {16, 150},     -- Установи свой желаемый диапазон
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = Settings.Speed, -- Используем значение из getgenv()
    Flag = "HookSpeedSlider",      -- Уникальный флаг
    Callback = function(Value)
        Settings.Speed = Value     -- Обновляем значение в getgenv()
    end
})

local JumpPowerSlider = SpeedJumpSection:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},    -- Установи свой желаемый диапазон
    Increment = 1,
    Suffix = " power",
    CurrentValue = Settings.Jump, -- Используем значение из getgenv()
    Flag = "HookJumpSlider",     -- Уникальный флаг
    Callback = function(Value)
        Settings.Jump = Value    -- Обновляем значение в getgenv()
    end
})

-- --- Механизм изменения скорости/прыжка через hookmetamethod (из второго скрипта) ---
local old_namecall
old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Перехватываем ТОЛЬКО нужный вызов
    if not checkcaller() and tostring(self) == "Communicator" and method == "InvokeServer" and args[1] == "update" then
        -- Возвращаем значения из наших настроек
        return Settings.Speed, Settings.Jump
    end

    -- Для всех остальных вызовов - выполняем оригинальный код
    return old_namecall(self, ...)
end))

-- --- УДАЛЕНО: Старая логика Speed Boost из первого скрипта ---
-- Весь код связанный с Toggle2, Keybind2, MaxSpeedSlider, AccelerationSlider
-- Функции ToggleSpeedBoost, GetOriginalSpeed, SetupCharacterSpeedHandling
-- Переменные SpeedBoostActive, maxWalkSpeed, boostAcceleration, originalSpeed
-- И цикл RunService.Heartbeat, который менял Humanoid.WalkSpeed

print("Evade Helper (GUI Toggle + Hook Speed) Loaded")