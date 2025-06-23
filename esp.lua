-- РИСКОВАННЫЙ "ПРИЗРАЧНЫЙ РЕЖИМ" (NO-CLIP)
-- Не гарантирует 100% защиту от урона, но позволяет избегать его, проходя сквозь объекты.
-- Высокий риск обнаружения и бана!

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Переменные состояния меню
local noClipActive = false
local menuCollapsed = false
local originalSize = UDim2.new(0, 200, 0, 150)
local collapsedSize = UDim2.new(0, 200, 0, 30)

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WoS_GhostMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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
Title.Text = "WoS Призрачный Режим (Insert)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Кнопка переключения No-Clip
local ToggleNoClipButton = Instance.new("TextButton")
ToggleNoClipButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleNoClipButton.Position = UDim2.new(0.1, 0, 0, 40)
ToggleNoClipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ToggleNoClipButton.Text = "Включить No-Clip"
ToggleNoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleNoClipButton.Font = Enum.Font.SourceSans
ToggleNoClipButton.TextSize = 16
ToggleNoClipButton.Parent = MainFrame

-- Статус No-Clip
local NoClipStatus = Instance.new("TextLabel")
NoClipStatus.Size = UDim2.new(0.9, 0, 0, 20)
NoClipStatus.Position = UDim2.new(0.05, 0, 0, 80)
NoClipStatus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NoClipStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipStatus.Font = Enum.Font.SourceSans
NoClipStatus.TextSize = 14
NoClipStatus.TextXAlignment = Enum.TextXAlignment.Left
NoClipStatus.Parent = MainFrame

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
    if noClipActive then
        NoClipStatus.Text = "No-Clip: Включен (Осторожно!)"
        NoClipStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        NoClipStatus.Text = "No-Clip: Отключен"
        NoClipStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- Изначальное обновление статусов
updateStatuses()

-- Функция активации No-Clip
local function activateNoClip()
    local Character = LocalPlayer.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    -- Отключение столкновений для всех частей тела
    pcall(function()
        for _, part in ipairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        Humanoid.WalkSpeed = 40 -- Увеличиваем скорость для удобства перемещения сквозь объекты
    end)
    
    noClipActive = true
    ToggleNoClipButton.Text = "Отключить No-Clip"
    ToggleNoClipButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    print("No-Clip активирован.")
    updateStatuses()
end

-- Функция деактивации No-Clip
local function deactivateNoClip()
    local Character = LocalPlayer.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    -- Восстановление столкновений (может быть не 100% надежным)
    pcall(function()
        for _, part in ipairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        Humanoid.WalkSpeed = 16 -- Возвращаем стандартную скорость
    end)

    noClipActive = false
    ToggleNoClipButton.Text = "Включить No-Clip"
    ToggleNoClipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    print("No-Clip деактивирован.")
    updateStatuses()
end

-- Обработчик нажатия кнопки No-Clip
ToggleNoClipButton.MouseButton1Click:Connect(function()
    if noClipActive then
        deactivateNoClip()
    else
        activateNoClip()
    end
end)

-- Перетаскивание меню (как в предыдущих версиях)
local UserInputService = game:GetService("UserInputService")
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
            ToggleNoClipButton.Visible = true
            NoClipStatus.Visible = true
            menuCollapsed = false
            Title.Text = "WoS Призрачный Режим (Insert)"
        else
            MainFrame.Size = collapsedSize
            ToggleNoClipButton.Visible = false
            NoClipStatus.Visible = false
            menuCollapsed = true
            Title.Text = "WoS Призрачный Режим (Insert для разворачивания)"
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
