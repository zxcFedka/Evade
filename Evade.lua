if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId ~= 9872472334 then return end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Evade",
    Icon = 0,
    LoadingTitle = "Suka Hub",
    LoadingSubtitle = "by zxcFedka",
    Theme = "Default",
    -- ... (остальные настройки окна Rayfield) ...
})

local player = game.Players.LocalPlayer
local PlayerGui = player.PlayerGui
local RunService = game:GetService("RunService")

-- --- Переменные и функции для GUI ---
local GuiEnabled = false
function ToggleGuiVisibility()
    -- ... (код скрытия/показа GUI как раньше) ...
    GuiEnabled = not GuiEnabled
end

-- --- Переменные и функции для Speed Boost ---
local SpeedBoostActive = false
local maxWalkSpeed = 50       -- Максимальная скорость (лимит)
local boostAcceleration = 2   -- !! НОВОЕ: Насколько увеличивать скорость за кадр к лимиту
local originalSpeed = 16      -- Стандартная скорость

-- ... (Функции GetOriginalSpeed, SetupCharacterSpeedHandling как раньше) ...
-- Важно: GetOriginalSpeed должна вызываться когда буст ВЫКЛЮЧЕН, чтобы получить реальную базовую скорость

local function SetupCharacterSpeedHandling(character)
    local humanoid = character:WaitForChild("Humanoid")
    task.wait(0.2)
    GetOriginalSpeed()
    humanoid.Died:Connect(function()
        originalSpeed = 16
    end)
end

if player.Character then
    SetupCharacterSpeedHandling(player.Character)
end
player.CharacterAdded:Connect(SetupCharacterSpeedHandling)

local Toggle2 -- Объявим заранее для доступа в ToggleSpeedBoost
local MaxSpeedSlider -- Объявим заранее
local AccelerationSlider -- Объявим заранее

function ToggleSpeedBoost()
    SpeedBoostActive = not SpeedBoostActive
    if SpeedBoostActive then
        GetOriginalSpeed() -- Попытка получить базовую скорость перед активацией
    end
    if Toggle2 then
        Toggle2:Set(SpeedBoostActive)
    end
end

-- --- Создание UI ---
local MainTab = Window:CreateTab("Home", nil)
-- ... (Код для GUI Toggle UI как раньше) ...

-- --- Speed Boost UI ---
MainTab:CreateDivider()

Toggle2 = MainTab:CreateToggle({ -- Теперь присваиваем объявленной переменной
    Name = "Speed Boost (Cap + Accel)",
    CurrentValue = SpeedBoostActive,
    Flag = "SpeedBoostToggle_V2", -- Уникальный флаг
    Callback = function(Value)
        ToggleSpeedBoost()
    end,
})

Keybind2 = MainTab:CreateKeybind({ -- Можно оставить старое имя Keybind2
    Name = "Speed Boost Bind",
    CurrentKeybind = "X",
    HoldToInteract = false,
    Flag = "SpeedBoostKeybind_V2", -- Уникальный флаг
    Callback = function(Keybind)
        ToggleSpeedBoost()
    end,
})

MaxSpeedSlider = MainTab:CreateSlider({ -- Присваиваем объявленной переменной
    Name = "Max Speed Cap",
    Range = {16, 150},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = maxWalkSpeed,
    Flag = "MaxSpeedSlider_V2", -- Уникальный флаг
    Callback = function(Value)
        maxWalkSpeed = Value
    end,
 })

-- !! НОВЫЙ СЛАЙДЕР !!
AccelerationSlider = MainTab:CreateSlider({
    Name = "Boost Acceleration",
    Range = {0.1, 10}, -- Диапазон ускорения (подбирается экспериментально)
    Increment = 0.1,
    Suffix = " speed/frame", -- Примерный суффикс
    CurrentValue = boostAcceleration,
    Flag = "BoostAccelerationSlider", -- Уникальный флаг
    Callback = function(Value)
        boostAcceleration = Value
    end,
 })


-- --- Основной цикл обновления скорости ---
RunService.Heartbeat:Connect(function(dt) -- Получаем dt (delta time)
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then return end -- Выходим, если нет гуманоида

    if SpeedBoostActive then
        local currentSpeed = Humanoid.WalkSpeed
        if currentSpeed < maxWalkSpeed then
            -- Увеличиваем скорость, но не выше лимита
            -- Используем dt для независимости от FPS: boostAcceleration * 60 * dt
            -- где 60 - это базовая частота кадров, к которой мы приводим ускорение.
            -- Или проще: просто добавляем значение, настроенное слайдером.
            local accelerationAmount = boostAcceleration -- Можете умножить на dt * 60, если хотите frame-rate independence
            local newSpeed = currentSpeed + accelerationAmount
            Humanoid.WalkSpeed = math.min(newSpeed, maxWalkSpeed) -- Применяем ускоренную скорость, но не выше капа
        -- else
             -- Если скорость уже равна или выше капа, можно ничего не делать,
             -- или принудительно установить кап: Humanoid.WalkSpeed = maxWalkSpeed
             -- Оставим пока без действия, чтобы меньше конфликтовать
        end
    else
        -- Если буст выключен, возвращаем оригинальную скорость
        if Humanoid.WalkSpeed ~= originalSpeed then
            -- Возможно, стоит добавить проверку, не была ли скорость изменена игрой?
            -- Но для простоты - просто возвращаем к запомненной оригинальной.
            Humanoid.WalkSpeed = originalSpeed
        end
    end
end)

print("Suka Hub (v2: Accel Boost) Loaded for Evade")