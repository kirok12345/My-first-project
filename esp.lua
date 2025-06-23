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
local menuCollapsed = false -- Новая переменная для состояния сворачивания
local originalSize = UDim2.new(0, 200, 0, 150) -- Исходный размер фрейма
local collapsedSize = UDim2.new(0, 200, 0, 30) -- Размер в свернутом состоянии

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

-- Заголовок, который будет также использоваться для перетаскивания и сворачивания
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Text = "Меню Выжившего (Клик для сворачивания)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18 -- Чуть меньше, чтобы уместилось
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
CloseButton.Parent = Title -- Размещаем на заголовке

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

-- Функция деактивации God Mode
local function deactivateGodMode()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Health = Humanoid.MaxHealth -- Возвращаем к нормальному максимальному здоровью
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

-- Перетаскивание меню
local dragging = false
local dragStart = Vector2.new(0,0)
local startPos = UDim2.new(0,0,0,0)

Title.MouseButton1Down:Connect(function(x, y)
    dragging = true
    dragStart = Vector2.new(x, y)
    startPos = MainFrame.Position
    -- Не позволяем перетаскивать, если меню свернуто, чтобы клик на заголовок сворачивал его
    if menuCollapsed then dragging = false return end 
end)

Title.MouseButton1Up:Connect(function()
    dragging = false
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Сворачивание/разворачивание меню по клику на заголовок
Title.MouseButton1Click:Connect(function()
    if not dragging then -- Убедимся, что это был клик, а не начало перетаскивания
        if menuCollapsed then
            -- Развернуть меню
            MainFrame.Size = originalSize
            ToggleGodModeButton.Visible = true
            AntiCheatStatus.Visible = true
            GodModeStatus.Visible = true
            menuCollapsed = false
            Title.Text = "Меню Выжившего (Клик для сворачивания)"
        else
            -- Свернуть меню
            MainFrame.Size = collapsedSize
            ToggleGodModeButton.Visible = false
            AntiCheatStatus.Visible = false
            GodModeStatus.Visible = false
            menuCollapsed = true
            Title.Text = "Меню Выжившего (Клик для разворачивания)"
        end
    end
end)


-- Обновляем статусы каждую секунду на случай внешних изменений (например, респаун персонажа)
spawn(function()
    while true do
        updateStatuses()
        wait(1)
    end
end)
