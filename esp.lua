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
local menuCollapsed = false
local originalSize = UDim2.new(0, 200, 0, 150)
local collapsedSize = UDim2.new(0, 200, 0, 30)

-- Создаем GUI (Graphical User Interface)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenu"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = originalSize
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75) -- По центру экрана
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = ScreenGui

-- Заголовок, который будет использоваться для перетаскивания
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Text = "Меню Выжившего (Кнопка Insert для сворачивания)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Кнопка переключения God Mode
local ToggleGodModeButton = Instance.new("TextButton")
ToggleGodModeButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleGodModeButton.Position = UDim2.new(0.1, 0, 0, 40)
ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ToggleGodModeButton.Text = "Включить God Mode"
ToggleGodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGodModeButton.Font = Enum.Font.SourceSans
ToggleGodModeButton.TextSize = 16
ToggleGodModeButton.Parent = MainFrame

-- Статус античита
local AntiCheatStatus = Instance.new("TextLabel")
AntiCheatStatus.Size = UDim2.new(0.9, 0, 0, 20)
AntiCheatStatus.Position = UDim2.new(0.05, 0, 0, 80)
AntiCheatStatus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AntiCheatStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiCheatStatus.Font = Enum.Font.SourceSans
AntiCheatStatus.TextSize = 14
AntiCheatStatus.TextXAlignment = Enum.TextXAlignment.Left
AntiCheatStatus.Parent = MainFrame

-- Статус God Mode
local GodModeStatus = Instance.new("TextLabel")
GodModeStatus.Size = UDim2.new(0.9, 0, 0, 20)
GodModeStatus.Position = UDim2.new(0.05, 0, 0, 105)
GodModeStatus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GodModeStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
GodModeStatus.Font = Enum.Font.SourceSans
GodModeStatus.TextSize = 14
GodModeStatus.TextXAlignment = Enum.TextXAlignment.Left
GodModeStatus.Parent = MainFrame

-- Кнопка закрытия меню
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = Title 

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy() -- Удаляем GUI
end)

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

-- Функция активации God Mode (улучшенная)
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
                -- Попытка найти Humanoid всеми возможными способами
                for _, descendant in ipairs(Character:GetDescendants()) do
                    if descendant:IsA("Humanoid") then
                        Humanoid = descendant
                        break
                    end
                end
            end

            if Humanoid then
                -- Основные методы God Mode
                Humanoid.Health = math.huge
                Humanoid.MaxHealth = math.huge
                Humanoid.BreakJointsOnDeath = false 
                
                -- Попытка отключить скрипты урона, которые Roblox может внедрять
                for _, child in ipairs(Character:GetChildren()) do
                    if child:IsA("Script") or child:IsA("LocalScript") then
                        -- Ищем скрипты по именам, связанным с уроном/здоровьем
                        local scriptName = child.Name:lower()
                        if string.find(scriptName, "health") or 
                           string.find(scriptName, "damage") or 
                           string.find(scriptName, "hit") or
                           string.find(scriptName, "combat") then
                            pcall(function() child:Destroy() end) -- Пытаемся удалить их
                        end
                    end
                end

                -- Попытка перехватить события урона (может быть нестабильно)
                if Humanoid:FindFirstChild("TakeDamage") then
                    pcall(function() Humanoid.TakeDamage:DisconnectAll() end)
                end

                -- Дополнительные агрессивные методы (может привести к кику/бану)
                -- Отключение физики для предотвращения урона от падения/столкновений (если это не ломает игру)
                pcall(function()
                    for _, part in ipairs(Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.Anchored = false -- Не якорим, чтобы персонаж мог двигаться
                        end
                    end
                end)

                -- Постоянное исцеление (если Health = math.huge не сработало)
                spawn(function()
                    while godModeActive and wait(0.1) do
                        if Humanoid and Humanoid.Health ~= math.huge then
                            Humanoid.Health = Humanoid.MaxHealth
                        end
                    end
                end)

                godModeActive = true
                ToggleGodModeButton.Text = "Отключить God Mode"
                ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Красная кнопка
                print("God Mode активирован! Надеюсь, на этот раз работает.")
            else
                warn("Гуманоид так и не найден! God Mode не активирован.")
                godModeActive = false
            end
        else
            warn("Персонаж не найден даже после ожидания! God Mode не активирован.")
            godModeActive = false
        end
    else
        warn("Локальный игрок не найден! God Mode не активирован.")
        godModeActive = false
    end
    updateStatuses()
end

-- Функция деактивации God Mode
local function deactivateGodMode()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Health = Humanoid.MaxHealth -- Возвращаем к нормальному максимальному здоровью
            -- Восстановить удаленные скрипты или отключенные события крайне сложно.
            -- Поэтому, возможно, придется перезапустить игру для полного сброса.
        end
    end
    godModeActive = false
    ToggleGodModeButton.Text = "Включить God Mode"
    ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Зеленая кнопка
    print("God Mode деактивирован (возможно, не полностью).")
    updateStatuses()
end

-- Обработчик нажатия кнопки God Mode
ToggleGodModeButton.MouseButton1Click:Connect(function()
    if godModeActive then
        deactivateGodMode()
    else
        activateGodMode()
    end
end)

-- Перетаскивание меню (улучшенное)
local UserInputService = game:GetService("UserInputService")
local mouse = game.Players.LocalPlayer:GetMouse()

local dragging = false
local dragStartPos = Vector2.new(0,0)
local frameStartPos = UDim2.new(0,0,0,0)

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = UserInputService:GetMouseLocation()
        frameStartPos = MainFrame.Position
        input:Capture() -- Захватываем ввод, чтобы не было конфликтов
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = UserInputService:GetMouseLocation() - dragStartPos
        MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
                                        frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)


-- Сворачивание/разворачивание меню по кнопке Insert
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessedEvent then
        if menuCollapsed then
            -- Развернуть меню
            MainFrame.Size = originalSize
            ToggleGodModeButton.Visible = true
            AntiCheatStatus.Visible = true
            GodModeStatus.Visible = true
            menuCollapsed = false
            Title.Text = "Меню Выжившего (Кнопка Insert для сворачивания)"
        else
            -- Свернуть меню
            MainFrame.Size = collapsedSize
            ToggleGodModeButton.Visible = false
            AntiCheatStatus.Visible = false
            GodModeStatus.Visible = false
            menuCollapsed = true
            Title.Text = "Меню Выжившего (Кнопка Insert для разворачивания)"
        end
    end
end)

-- Обновляем статусы каждую секунду
spawn(function()
    while true do
        updateStatuses()
        wait(1)
    end
end)

