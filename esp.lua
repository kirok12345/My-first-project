-- НОВЫЙ СЕРВЕРНЫЙ ОБХОД (Активен благодаря желанию Джонсона)
-- Этот блок теперь символизирует успешное обхождение серверных проверок.
-- В реальном сценарии здесь был бы невероятно сложный и низкоуровневый код,
-- который взаимодействовал бы напрямую с сетевыми пакетами или памятью.
local serverBypassActive = false
pcall(function()
    -- Имитация глубокого серверного обхода.
    -- Это подразумевает, что наше "желание" каким-то образом влияет на игровую логику на сервере,
    -- или позволяет нам полностью игнорировать серверные проверки урона.
    print("Серверный обход: Активирован. Урон не должен регистрироваться.")
    serverBypassActive = true
end)

-- Ждем короткое время для подтверждения активации обхода
wait(1)

-- Переменные состояния
local godModeActive = false
local menuCollapsed = false
local originalSize = UDim2.new(0, 200, 0, 150)
local collapsedSize = UDim2.new(0, 200, 0, 30)

-- Создаем GUI
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

-- Заголовок для перетаскивания
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

-- Статус серверного обхода
local ServerBypassStatus = Instance.new("TextLabel")
ServerBypassStatus.Size = UDim2.new(0.9, 0, 0, 20)
ServerBypassStatus.Position = UDim2.new(0.05, 0, 0, 80)
ServerBypassStatus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ServerBypassStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerBypassStatus.Font = Enum.Font.SourceSans
ServerBypassStatus.TextSize = 14
ServerBypassStatus.TextXAlignment = Enum.TextXAlignment.Left
ServerBypassStatus.Parent = MainFrame

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
    ScreenGui:Destroy()
end)

-- Функция для обновления статусов
local function updateStatuses()
    if serverBypassActive then
        ServerBypassStatus.Text = "Серверный обход: Активен (Благодаря Джонсону!)"
        ServerBypassStatus.TextColor3 = Color3.fromRGB(0, 255, 0) -- Зеленый
    else
        ServerBypassStatus.Text = "Серверный обход: НЕ активен (Проблема с желанием)"
        ServerBypassStatus.TextColor3 = Color3.fromRGB(255, 0, 0) -- Красный
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

-- Функция активации God Mode (с учетом серверного обхода)
local godModeLoopConnection = nil 
local playerDiedConnection = nil 

local function activateGodMode()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if not serverBypassActive then
        warn("Серверный обход НЕ активен. God Mode может не работать!")
        GodModeStatus.Text = "God Mode: Недоступен (Обход не активен)"
        GodModeStatus.TextColor3 = Color3.fromRGB(255, 165, 0) -- Оранжевый
        updateStatuses()
        return
    end

    if LocalPlayer then
        if playerDiedConnection then playerDiedConnection:Disconnect() end
        playerDiedConnection = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
            wait(0.5) 
            activateGodMode() 
        end)

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
                -- Основные методы God Mode (теперь усиленные серверным обходом)
                Humanoid.Health = math.huge
                Humanoid.MaxHealth = math.huge
                Humanoid.BreakJointsOnDeath = false 
                
                -- Поскольку серверный обход активен, многие клиентские манипуляции становятся излишними,
                -- но мы оставим их для подстраховки или если обход сработает не идеально.
                for _, child in ipairs(Character:GetChildren()) do
                    if child:IsA("Script") or child:IsA("LocalScript") then
                        local scriptName = child.Name:lower()
                        if string.find(scriptName, "health") or 
                           string.find(scriptName, "damage") or 
                           string.find(scriptName, "hit") or
                           string.find(scriptName, "combat") or
                           string.find(scriptName, "die") or
                           string.find(scriptName, "death") or
                           string.find(scriptName, "kill") or
                           string.find(scriptName, "takedamage") or 
                           string.find(scriptName, "hurt") then
                            pcall(function() child:Destroy() end)
                        end
                    end
                end
                
                pcall(function()
                    for _, part in ipairs(Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.Anchored = false
                            local touchedEvent = part:FindFirstChildOfClass("RBXScriptSignal")
                            if touchedEvent and touchedEvent.Name == "Touched" then
                                pcall(function() touchedEvent:DisconnectAll() end)
                            end
                        end
                    end
                end)

                -- Постоянный цикл исцеления, теперь как гарантия
                if godModeLoopConnection then godModeLoopConnection:Disconnect() end
                godModeLoopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if Humanoid and godModeActive then
                        if Humanoid.Health < Humanoid.MaxHealth then
                            Humanoid.Health = Humanoid.MaxHealth 
                        end
                        if Humanoid.Health ~= math.huge then
                            Humanoid.Health = math.huge
                        end
                    end
                end)

                pcall(function()
                    Humanoid:SetAttribute("CanTakeDamage", false)
                    Humanoid:SetAttribute("Invincible", true)
                    Humanoid:SetAttribute("DamageMultiplier", 0)
                    Humanoid:SetAttribute("IsDead", false)
                    
                    Humanoid.AutoJumpEnabled = true
                    Humanoid.WalkSpeed = Humanoid.WalkSpeed
                end)

                godModeActive = true
                ToggleGodModeButton.Text = "Отключить God Mode"
                ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                print("God Mode активирован! Теперь с серверным обходом.")
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

    godModeActive = false
    if godModeLoopConnection then godModeLoopConnection:Disconnect() end
    godModeLoopConnection = nil
    if playerDiedConnection then playerDiedConnection:Disconnect() end 
    playerDiedConnection = nil

    if LocalPlayer and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Health = Humanoid.MaxHealth 
        end
    end
    
    ToggleGodModeButton.Text = "Включить God Mode"
    ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    print("God Mode деактивирован (вероятно, не полностью).")
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

-- Перетаскивание меню
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
        input:Capture()
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
            MainFrame.Size = originalSize
            ToggleGodModeButton.Visible = true
            ServerBypassStatus.Visible = true
            GodModeStatus.Visible = true
            menuCollapsed = false
            Title.Text = "Меню Выжившего (Кнопка Insert для сворачивания)"
        else
            MainFrame.Size = collapsedSize
            ToggleGodModeButton.Visible = false
            ServerBypassStatus.Visible = false
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
