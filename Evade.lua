if not game:IsLoaded() then game.Loaded:Wait() end -- Добавим на всякий случай ожидание загрузки игры
if game.PlaceId ~= 9872472334 then return end

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
local RunService = game:GetService("RunService")

-- --- Переменные и функции для GUI ---
local GuiEnabled = false -- Начнем с выключенного состояния

function ToggleGuiVisibility()
    -- Вместо перебора всех, найдем основные GUI Evade (если известны имена)
    -- Пример (имена могут быть другие!):
    local mainGui = PlayerGui:FindFirstChild("MainUI") -- Или как он там называется
    local otherGui = PlayerGui:FindFirstChild("GameHUD")
    if mainGui then mainGui.Enabled = not mainGui.Enabled end
    if otherGui then otherGui.Enabled = not otherGui.Enabled end

    -- Если имена неизвестны, можно вернуться к перебору, но с осторожностью
    -- for i, gui in pairs(PlayerGui:GetChildren()) do
    --     if gui:IsA("ScreenGui") and gui.Name ~= "Rayfield" then -- Исключаем сам Rayfield
    --          pcall(function() -- Используем pcall для безопасности
    --              gui.Enabled = not gui.Enabled
    --          end)
    --     end
    -- end

    GuiEnabled = not GuiEnabled -- Обновляем состояние
end

-- --- Переменные и функции для Speed Boost ---
local SpeedBoostActive = false
local maxWalkSpeed = 50 -- Начальное значение максимальной скорости (можно настроить)
local originalSpeed = 16 -- Стандартная скорость

local function GetOriginalSpeed()
    -- Эта функция пытается получить базовую скорость игрока.
    -- Важно вызывать ее, когда игрок не под действием буста.
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        -- Если буст сейчас активен, мы не можем получить *чистую* оригинальную скорость.
        -- Вернем стандартную или последнее известное значение.
        if not SpeedBoostActive then
             originalSpeed = Humanoid.WalkSpeed
             -- Доп. проверка: если скорость ненормально высокая, сбросить к 16
             if originalSpeed > 30 then -- Пороговое значение, можно изменить
                 -- print("Warning: Detected high speed, potentially from game mechanics. Resetting base speed reference to 16.")
                 originalSpeed = 16
             end
        -- else -- Если буст активен, не обновляем originalSpeed
             -- print("Speed boost is active, cannot update original speed now.")
        end
    else
        originalSpeed = 16 -- Если гуманоида нет, сбрасываем на стандарт
    end
    -- print("Current originalSpeed reference:", originalSpeed)
end

local function SetupCharacterSpeedHandling(character)
    local humanoid = character:WaitForChild("Humanoid")
    task.wait(0.2) -- Небольшая задержка для инициализации
    GetOriginalSpeed() -- Получаем скорость после появления

    humanoid.Died:Connect(function()
        -- print("Player died, resetting original speed reference to 16")
        originalSpeed = 16 -- Сброс при смерти
    end)

    -- Можно добавить слежение за изменением скорости ИЗВНЕ нашего скрипта, но это сложнее.
    -- humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    --     -- Если скорость изменилась НЕ из-за нашего скрипта и НЕ из-за Heartbeat
    --     -- Можно попытаться обновить originalSpeed, но это рискованно.
    --     -- Пока оставим GetOriginalSpeed при спавне/переключении буста.
    -- end)
end

-- Инициализация и обработка респавна
if player.Character then
    SetupCharacterSpeedHandling(player.Character)
end
player.CharacterAdded:Connect(SetupCharacterSpeedHandling)


function ToggleSpeedBoost()
    SpeedBoostActive = not SpeedBoostActive
    -- print("Speed Boost Toggled:", SpeedBoostActive)

    -- При выключении, Heartbeat вернет скорость к originalSpeed.
    -- При включении, Heartbeat начнет применять maxWalkSpeed.
    -- Можно попытаться получить актуальную originalSpeed перед включением:
    if SpeedBoostActive then
        GetOriginalSpeed()
    end

    -- Обновляем UI (Toggle2 должен быть определен ниже)
    if Toggle2 then -- Убедимся, что Toggle2 уже создан
        Toggle2:Set(SpeedBoostActive)
    end
end

-- --- Создание UI ---
local MainTab = Window:CreateTab("Home", nil)
local MineSection = MainTab:CreateSection("Main")
-- MineSection:Set("Main") -- Эта строка не нужна, CreateSection уже задает заголовок

-- --- GUI Toggle UI ---
MainTab:CreateDivider()

local ToggleGui = MainTab:CreateToggle({
    Name = "Toggle Game Gui",
    CurrentValue = GuiEnabled, -- Синхронизируем с начальным состоянием
    Flag = "GuiToggle", -- Уникальный флаг
    Callback = function(Value)
        ToggleGuiVisibility()
        -- Не нужно устанавливать Value обратно, Rayfield делает это
    end,
 })

 local KeybindGui = MainTab:CreateKeybind({
    Name = "Gui Toggle Bind",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "GuiKeybind", -- Уникальный флаг
    Callback = function(Keybind)
        ToggleGuiVisibility()
        ToggleGui:Set(GuiEnabled) -- Обновляем состояние кнопки
    end,
 })

-- --- Speed Boost UI ---
MainTab:CreateDivider()

local Toggle2 = MainTab:CreateToggle({ -- Определяем Toggle2 здесь
    Name = "Speed Boost Cap",
    CurrentValue = SpeedBoostActive,
    Flag = "SpeedBoostToggle", -- Уникальный флаг
    Callback = function(Value)
        ToggleSpeedBoost()
        -- Value уже передан Rayfield'ом, повторно устанавливать не надо
    end,
})

local Keybind2 = MainTab:CreateKeybind({
    Name = "Speed Boost Bind",
    CurrentKeybind = "X",
    HoldToInteract = false,
    Flag = "SpeedBoostKeybind", -- Уникальный флаг
    Callback = function(Keybind)
        ToggleSpeedBoost()
        -- Toggle2:Set(SpeedBoostActive) -- ToggleSpeedBoost уже обновляет кнопку
    end,
})

local MaxSpeedSlider = MainTab:CreateSlider({
    Name = "Max Speed Cap",
    Range = {16, 150}, -- Диапазон: от стандартной до высокой скорости
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = maxWalkSpeed, -- Используем переменную
    Flag = "MaxSpeedSlider", -- Уникальный флаг
    Callback = function(Value)
        maxWalkSpeed = Value
        -- print("Max Speed set to:", maxWalkSpeed)
        -- Не нужно применять сразу, Heartbeat сделает это, если буст активен
    end,
 })

-- --- Основной цикл обновления скорости ---
RunService.Heartbeat:Connect(function()
    if not SpeedBoostActive then
        -- Если буст выключен, проверяем, нужно ли вернуть скорость к оригинальной
        local Character = player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid and Humanoid.WalkSpeed ~= originalSpeed then
            -- Доп. проверка: не устанавливать скорость, если она выше originalSpeed, но ниже чем был наш maxSpeed?
            -- Это сложно, т.к. игра могла сама ее поднять.
            -- Самый простой вариант - всегда возвращать к originalSpeed при выключении буста.
            -- print("Heartbeat: Boost OFF, resetting speed to original:", originalSpeed)
            Humanoid.WalkSpeed = originalSpeed
        end
        return -- Выходим, если буст неактивен
    end

    -- Если буст активен:
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        if Humanoid.WalkSpeed < maxWalkSpeed then
             -- print("Heartbeat: Boost ON, speed", Humanoid.WalkSpeed, "< max", maxWalkSpeed, ". Setting speed.")
             Humanoid.WalkSpeed = maxWalkSpeed
             print(maxWalkSpeed)
        -- else
             -- print("Heartbeat: Boost ON, speed", Humanoid.WalkSpeed, ">= max", maxWalkSpeed, ". No change.")
        end
    end
end)

print("Suka Hub Loaded for Evade")