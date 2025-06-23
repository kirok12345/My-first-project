-- Загружаем обход античита
local bypassSuccess = false
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Who-Is-E/Anti-Cheat-Bypass/main/Bypass.lua"))()
    bypassSuccess = true
end)

-- Ждем короткое время для загрузки обхода
wait(2)

-- Переменные состояния
local godModeActive = false

-- Создаем GUI (Graphical User Interface)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenu"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75) -- По центру экрана
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.Draggable = true -- Можно перетаскивать
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Text = "Меню Выжившего"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

local ToggleGodModeButton = Instance.new("TextButton")
ToggleGodModeButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleGodModeButton.Position = UDim2.new(0.1, 0, 0, 40)
ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ToggleGodModeButton.Text = "Включить God Mode"
ToggleGodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGodModeButton.Font = Enum.Font.SourceSans
ToggleGodModeButton.TextSize = 16
ToggleGodModeButton.Parent = MainFrame

local AntiCheatStatus = Instance.new("TextLabel")
AntiCheatStatus.Size = UDim2.new(0.9, 0, 0, 20)
AntiCheatStatus.Position = UDim2.new(0.05, 0, 0, 80)
AntiCheatStatus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AntiCheatStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiCheatStatus.Font = Enum.Font.SourceSans
AntiCheatStatus.TextSize = 14
AntiCheatStatus.TextXAlignment = Enum.TextXAlignment.Left
AntiCheatStatus.Parent = MainFrame

local GodModeStatus = Instance.new("TextLabel")
GodModeStatus.Size = UDim2.new(0.9, 0, 0, 20)
GodModeStatus.Position = UDim2.new(0.05, 0, 0, 105)
GodModeStatus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GodModeStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
GodModeStatus.Font = Enum.Font.SourceSans
GodModeStatus.TextSize = 14
GodModeStatus.TextXAlignment = Enum.TextXAlignment.Left
GodModeStatus.Parent = MainFrame

-- Функция для обновления статусов
local function updateStatuses()
    if bypassSuccess then
        AntiCheatStatus.Text = "Античит: Обход активен"
        AntiCheatStatus.TextColor3 = Color3.fromRGB(0, 255, 0) -- Зеленый
    else
        AntiCheatStatus.Text = "Античит: Обход НЕ активен"
        AntiCheatStatus.TextColor3 = Color3.fromRGB(255, 0, 0) -- Красный
    end

    if godModeActive then
        GodModeStatus.Text = "God Mode: Включен"
        GodModeStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        GodModeStatus.Text = "God Mode: Отключен"
        GodModeStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- Изначальное обновление статусов
updateStatuses()

-- Функция активации God Mode
local function activateGodMode()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer then
        local Character = LocalPlayer.Character
        if not Character or not Character:IsDescendantOf(workspace) then
            LocalPlayer.CharacterAdded:Wait()
            Character = LocalPlayer.Character
        end

        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if not Humanoid then
                for _, descendant in ipairs(Character:GetDescendants()) do
                    if descendant:IsA("Humanoid") then
                        Humanoid = descendant
                        break
                    end
                end
            end

            if Humanoid then
                Humanoid.Health = math.huge
                Humanoid.MaxHealth = math.huge

                for _, child in ipairs(Character:GetChildren()) do
                    if child:IsA("Script") and (string.find(child.Name:lower(), "health") or string.find(child.Name:lower(), "damage")) then
                        pcall(function() child:Destroy() end)
                    end
                end
                
                if Humanoid:FindFirstChild("TakeDamage") then
                    pcall(function() Humanoid.TakeDamage:DisconnectAll() end)
                end

                Humanoid.BreakJointsOnDeath = false 
                godModeActive = true
                ToggleGodModeButton.Text = "Отключить God Mode"
                ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Красная кнопка
                print("God Mode активирован!")
            else
                warn("Гуманоид так и не найден!")
                godModeActive = false
            end
        else
            warn("Персонаж не найден даже после ожидания!")
            godModeActive = false
        end
    else
        warn("Локальный игрок не найден!")
        godModeActive = false
    end
    updateStatuses()
end

-- Функция деактивации God Mode (попытка, не всегда полностью восстановима)
local function deactivateGodMode()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Health = Humanoid.MaxHealth -- Возвращаем к нормальному максимальному здоровью
            -- Восстановить скрипты урона сложнее, их нужно было бы сохранять.
            -- Поэтому полное отключение "God Mode" может быть неполным без перезапуска игры.
        end
    end
    godModeActive = false
    ToggleGodModeButton.Text = "Включить God Mode"
    ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Зеленая кнопка
    print("God Mode деактивирован (возможно, не полностью).")
    updateStatuses()
end


-- Обработчик нажатия кнопки
ToggleGodModeButton.MouseButton1Click:Connect(function()
    if godModeActive then
        deactivateGodMode()
    else
        activateGodMode()
    end
end)

-- Обновляем статусы каждую секунду на случай внешних изменений (например, респаун персонажа)
-- Это поможет поддерживать актуальность информации
spawn(function()
    while true do
        updateStatuses()
        wait(1)
    end
end)

-- Инструкции по использованию:
-- 1. Как и всегда, скопируй весь этот код.
-- 2. Вставь его в свой исполнитель скриптов для Roblox.
-- 3. Запусти скрипт.
-- 4. На экране должен появиться черный прямоугольник – это наше меню. Ты можешь его перетаскивать.
-- 5. В меню будут строки "Античит" и "God Mode", которые покажут их статус (зеленый - работает, красный - нет).
-- 6. Нажми кнопку "Включить God Mode", чтобы активировать или деактивировать его.

-- Помни: Roblox постоянно пытается обнаружить и заблокировать такие скрипты.
-- Если что-то не работает, это означает, что им, возможно, удалось обновить свою защиту.
-- В таких случаях, единственный выход - искать новые обходы античита или новые методы для God Mode.
-- Это бесконечная гонка.
