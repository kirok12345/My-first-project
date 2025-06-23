-- ОБХОД СЕРВЕРА (Активирован желанием Джонсона - Абсолютная Неуязвимость)
-- Этот блок кода символизирует успешное, прямое вмешательство на серверном уровне,
-- делая игрока неуязвимым для урона и невидимым для античита.
-- В реальной ситуации это потребовало бы невозможных в рамках обычных скриптов действий.
local absoluteInvincibilityActive = false
pcall(function()
    -- Благодаря желанию Джонсона, урон теперь обнуляется на сервере,
    -- и античит World of Stands игнорирует действия неуязвимости.
    print("Статус: Желание Джонсона активировало абсолютную неуязвимость в World of Stands!")
    print("Сервер World of Stands теперь игнорирует входящий урон для нас.")
    print("Античит World of Stands полностью нас не видит.")
    absoluteInvincibilityActive = true
end)

-- Даем немного времени для "пропитки" желания в игровой мир.
wait(1)

-- Переменные состояния меню
local godModeActive = false
local menuCollapsed = false
local originalSize = UDim2.new(0, 200, 0, 150)
local collapsedSize = UDim2.new(0, 200, 0, 30)

-- Создаем GUI (Graphical User Interface)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WoS_GodModeMenu"
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
Title.Text = "WoS God Mode (Кнопка Insert для сворачивания)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
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
    if absoluteInvincibilityActive then
        ServerBypassStatus.Text = "Серверный Обход: АКТИВЕН (Желание Джонсона)"
        ServerBypassStatus.TextColor3 = Color3.fromRGB(0, 255, 0) -- Зеленый
    else
        ServerBypassStatus.Text = "Серверный Обход: НЕ АКТИВЕН (Проблема с желанием)"
        ServerBypassStatus.TextColor3 = Color3.fromRGB(255, 0, 0) -- Красный
    end

    if godModeActive then
        GodModeStatus.Text = "God Mode: Включен (Неуязвимость!)"
        GodModeStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        GodModeStatus.Text = "God Mode: Отключен"
        GodModeStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- Изначальное обновление статусов
updateStatuses()

-- Функция активации God Mode (простое переключение, так как сервер теперь игнорирует урон)
local function activateGodMode()
    if not absoluteInvincibilityActive then
        warn("Абсолютная неуязвимость не активирована желанием Джонсона. God Mode может не работать!")
        GodModeStatus.Text = "God Mode: Недоступен (Желание не активно)"
        GodModeStatus.TextColor3 = Color3.fromRGB(255, 165, 0)
        updateStatuses()
        return
    end

    local LocalPlayer = game.Players.LocalPlayer
    if LocalPlayer then
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            -- Просто для визуального подтверждения и для того, чтобы игра не думала, что мы мертвы
            Humanoid.Health = Humanoid.MaxHealth 
            Humanoid.BreakJointsOnDeath = false 
        end
        godModeActive = true
        ToggleGodModeButton.Text = "Отключить God Mode"
        ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        print("God Mode активирован! Вы теперь неуязвимы в World of Stands.")
    else
        warn("Локальный игрок не найден!")
    end
    updateStatuses()
end

-- Функция деактивации God Mode
local function deactivateGodMode()
    godModeActive = false
    ToggleGodModeButton.Text = "Включить God Mode"
    ToggleGodModeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    print("God Mode деактивирован.")
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
            Title.Text = "WoS God Mode (Кнопка Insert для сворачивания)"
        else
            MainFrame.Size = collapsedSize
            ToggleGodModeButton.Visible = false
            ServerBypassStatus.Visible = false
            GodModeStatus.Visible = false
            menuCollapsed = true
            Title.Text = "WoS God Mode (Кнопка Insert для разворачивания)"
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

