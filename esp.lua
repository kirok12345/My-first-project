-- Это локальный скрипт, он должен находиться в StarterPlayerScripts или StarterGui
-- Локальные скрипты выполняются на клиенте (компьютере игрока)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenu"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false -- Важно: GUI не будет исчезать при смерти/возрождении игрока

-- Создаем основную рамку меню
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MenuFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 350) -- Размер 250x350 пикселей
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -175) -- Центрируем по экрану
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Темный фон
mainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true -- Для перетаскивания
mainFrame.Draggable = true -- Для перетаскивания
mainFrame.Parent = screenGui

-- Создаем рамку для вкладок (слева)
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Name = "TabButtons"
tabButtonsFrame.Size = UDim2.new(0, 80, 1, 0) -- Ширина 80, высота 100% от родителя
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Еще темнее фон
tabButtonsFrame.BorderSizePixel = 0
tabButtonsFrame.Parent = mainFrame

-- Создаем рамку для содержимого вкладок (справа)
local tabContentFrame = Instance.new("Frame")
tabContentFrame.Name = "TabContent"
tabContentFrame.Size = UDim2.new(1, -80, 1, 0) -- 100% ширины минус 80 пикселей для кнопок, 100% высоты
tabContentFrame.Position = UDim2.new(0, 80, 0, 0) -- Смещаем на ширину кнопок
tabContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Чуть светлее фон
tabContentFrame.BorderSizePixel = 0
tabContentFrame.Parent = mainFrame

-- Функция для создания кнопки вкладки
local function createTabButton(name, yPosition)
    local button = Instance.new("TextButton")
    button.Name = name .. "TabButton"
    button.Size = UDim2.new(1, 0, 0, 40) -- Ширина 100%, высота 40 пикселей
    button.Position = UDim2.new(0, 0, 0, yPosition)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Parent = tabButtonsFrame
    return button
end

-- Функция для создания панели содержимого вкладки
local function createTabPanel(name)
    local panel = Instance.new("Frame")
    panel.Name = name .. "Panel"
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.Position = UDim2.new(0, 0, 0, 0)
    panel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    panel.BorderSizePixel = 0
    panel.Visible = false -- Изначально невидима
    panel.Parent = tabContentFrame
    return panel
end

-- Создаем вкладки и их панели
local tabs = {}
local currentActivePanel = nil

local function activateTab(panel)
    if currentActivePanel then
        currentActivePanel.Visible = false
    end
    panel.Visible = true
    currentActivePanel = panel
end

-- Вкладка "Player"
local playerTabButton = createTabButton("Player", 0)
local playerPanel = createTabPanel("Player")
tabs["Player"] = {button = playerTabButton, panel = playerPanel}

playerTabButton.MouseButton1Click:Connect(function()
    activateTab(playerPanel)
end)

-- Создаем другие вкладки (пока пустые, для демонстрации)
local movementTabButton = createTabButton("Movement", 40)
local movementPanel = createTabPanel("Movement")
tabs["Movement"] = {button = movementTabButton, panel = movementPanel}

movementTabButton.MouseButton1Click:Connect(function()
    activateTab(movementPanel)
end)

local worldTabButton = createTabButton("World", 80)
local worldPanel = createTabPanel("World")
tabs["World"] = {button = worldTabButton, panel = worldPanel}

worldTabButton.MouseButton1Click:Connect(function()
    activateTab(worldPanel)
end)

-- Активируем вкладку "Player" по умолчанию
activateTab(playerPanel)

------------------------------------------------------------------------------------------------------------------------
-- ФУНКЦИИ ДЛЯ ВКЛАДКИ "PLAYER"
------------------------------------------------------------------------------------------------------------------------

-- Функция Fly (полёт)
local isFlying = false
local flySpeed = 100 -- Скорость полета, можно настроить

local function toggleFly()
    if not Character or not Humanoid or not RootPart then
        warn("Character components not found for Fly function.")
        return
    end

    isFlying = not isFlying

    if isFlying then
        -- Отключаем гравитацию для полета
        Humanoid.Sit = true -- Сажаем гуманоида, чтобы отключить некоторые физические взаимодействия
        RootPart.Anchored = true -- Закрепляем RootPart
        Humanoid.PlatformStand = true -- Дополнительно для лучшего контроля
        
        -- Создаем или получаем BodyVelocity для управления полетом
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge) -- Максимальная сила
        bodyVel.Parent = RootPart

        -- Отслеживаем ввод для управления полетом
        local connection = nil
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end

            local currentVel = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera
            local cameraCFrame = camera.CFrame

            if input.KeyCode == Enum.KeyCode.W then
                currentVel = currentVel + cameraCFrame.LookVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.S then
                currentVel = currentVel - cameraCFrame.LookVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.A then
                currentVel = currentVel - cameraCFrame.RightVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.D then
                currentVel = currentVel + cameraCFrame.RightVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.Space then
                currentVel = currentVel + Vector3.new(0, flySpeed, 0)
            elseif input.KeyCode == Enum.KeyCode.Q then
                currentVel = currentVel - Vector3.new(0, flySpeed, 0)
            end
            bodyVel.Velocity = currentVel
        end)

        -- Отключаем отслеживание ввода, когда полёт выключается
        RootPart.AncestryChanged:Connect(function()
            if not RootPart.Parent and connection then
                connection:Disconnect()
            end
        })

        -- Обновляем текст кнопки
        flyButton.Text = "Fly: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Зеленый
    else
        -- Возвращаем нормальное состояние
        if RootPart:FindFirstChildOfClass("BodyVelocity") then
            RootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
        end
        Humanoid.Sit = false
        RootPart.Anchored = false
        Humanoid.PlatformStand = false

        -- Обновляем текст кнопки
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Красный
    end
end

-- Кнопка Fly
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyToggle"
flyButton.Size = UDim2.new(0.9, 0, 0, 35) -- Ширина 90%, высота 35 пикселей
flyButton.Position = UDim2.new(0.05, 0, 0, 10) -- Отступ 5% от левого края, 10 пикселей от верха панели
flyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Красный (выключен)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 18
flyButton.Parent = playerPanel

flyButton.MouseButton1Click:Connect(toggleFly)


-- Кнопка Teleport to me (телепортация к себе)
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportToMe"
teleportButton.Size = UDim2.new(0.9, 0, 0, 35)
teleportButton.Position = UDim2.new(0.05, 0, 0, 55) -- Ниже кнопки Fly
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 100, 150) -- Синий
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "Teleport to me"
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 18
teleportButton.Parent = playerPanel

teleportButton.MouseButton1Click:Connect(function()
    -- Получаем текущую позицию RootPart игрока
    local currentPos = RootPart.CFrame.Position
    -- Телепортируем игрока на эту же позицию, но чуть выше (чтобы не застрять в полу)
    RootPart.CFrame = CFrame.new(currentPos.X, currentPos.Y + 5, currentPos.Z)
    -- Сбрасываем любую скорость
    RootPart.Velocity = Vector3.new(0,0,0)
    RootPart.RotVelocity = Vector3.new(0,0,0)
    print("Teleported player to self's current position (slightly above).") -- Для отладки в окне Output
end)


-- Обработка возрождения персонажа для функций, зависящих от него
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    -- Если был включен полет, выключаем его при возрождении, чтобы избежать багов
    if isFlying then
        isFlying = false
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)
