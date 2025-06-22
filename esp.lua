-- ======================================================================
-- ||           PHANTOM UI (v6.1) - Стабилизированная версия           ||
-- ||    Переписано для максимальной надежности и устранения ошибок.   ||
-- ||       Элегантный интерфейс с самой мощной функцией.              ||
-- ======================================================================

print("[PHANTOM UI]: Загрузка стабилизированной системы...")

-- СЕРВИСЫ
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ПЕРЕМЕННЫЕ ИГРОКА И ПЕРСОНАЖА
local player = Players.LocalPlayer
local character, humanoid, rootPart
local defaultWalkSpeed, defaultMaxHealth = 16, 100

-- СОСТОЯНИЕ (сохраняется после смерти)
local isImmortal = false

-- ОБЪЕКТЫ ДЛЯ БЕССМЕРТИЯ
local godForceField, healthChangedConnection

-- КОНФИГУРАЦИЯ ИНТЕРФЕЙСА
local theme = {
    background = Color3.fromRGB(20, 21, 24),
    primary = Color3.fromRGB(30, 31, 34),
    secondary = Color3.fromRGB(43, 44, 48),
    accent = Color3.fromRGB(90, 104, 236),
    accent_off = Color3.fromRGB(70, 70, 70),
    text_primary = Color3.fromRGB(240, 240, 240),
    text_secondary = Color3.fromRGB(160, 160, 160),
    font_main = Enum.Font.GothamSemibold,
    font_title = Enum.Font.GothamBlack,
}
local tween_info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ======================================================================
-- ||                      СОЗДАНИЕ ИНТЕРФЕЙСА                         ||
-- ======================================================================
local PhantomUI = Instance.new("ScreenGui")
PhantomUI.Name = "PhantomUI"
PhantomUI.ResetOnSpawn = false
PhantomUI.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- ОСНОВНОЕ ОКНО
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.Size = UDim2.new(0, 450, 0, 250)
mainFrame.BackgroundColor3 = theme.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = PhantomUI

-- ЭЛЕМЕНТЫ ДИЗАЙНА
local corner = Instance.new("UICorner", mainFrame); corner.CornerRadius = UDim.new(0, 8)
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"; shadow.AnchorPoint = Vector2.new(0.5, 0.5); shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.fromScale(1, 1); shadow.Image = "rbxassetid://10423922669"; shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6; shadow.ScaleType = Enum.ScaleType.Slice; shadow.SliceCenter = Rect.new(20, 20, 280, 280)
shadow.ZIndex = -1; shadow.Parent = mainFrame

-- НАВИГАЦИОННАЯ ПАНЕЛЬ СЛЕВА
local navBar = Instance.new("Frame")
navBar.Name = "NavBar"; navBar.Size = UDim2.new(0, 120, 1, 0); navBar.BackgroundColor3 = theme.primary
navBar.BorderSizePixel = 0; navBar.Parent = mainFrame
local corner_nav = Instance.new("UICorner", navBar); corner_nav.CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"; titleLabel.Size = UDim2.new(1, 0, 0, 50); titleLabel.BackgroundTransparency = 1
titleLabel.Text = "PHANTOM"; titleLabel.Font = theme.font_title; titleLabel.TextColor3 = theme.text_primary
titleLabel.TextSize = 20; titleLabel.Parent = navBar

-- КНОПКА ВКЛАДКИ "PLAYER"
local playerTabButton = Instance.new("TextButton")
playerTabButton.Name = "PlayerTabButton"; playerTabButton.Size = UDim2.new(1, -16, 0, 35); playerTabButton.Position = UDim2.new(0.5, 0, 0, 60)
playerTabButton.AnchorPoint = Vector2.new(0.5, 0); playerTabButton.BackgroundColor3 = theme.accent; playerTabButton.Text = "  Player"
playerTabButton.Font = theme.font_main; playerTabButton.TextColor3 = theme.text_primary; playerTabButton.TextXAlignment = Enum.TextXAlignment.Left
playerTabButton.TextSize = 16; playerTabButton.AutoButtonColor = false; playerTabButton.Parent = navBar
local corner_tab = Instance.new("UICorner", playerTabButton); corner_tab.CornerRadius = UDim.new(0, 6)

-- КОНТЕНТ СПРАВА
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"; contentFrame.Position = UDim2.fromOffset(120, 0); contentFrame.Size = UDim2.new(1, -120, 1, 0)
contentFrame.BackgroundColor3 = theme.background; contentFrame.BorderSizePixel = 0; contentFrame.Parent = mainFrame

-- СТРАНИЦА "PLAYER"
local playerPage = Instance.new("Frame")
playerPage.Name = "PlayerPage"; playerPage.Size = UDim2.fromScale(1, 1); playerPage.BackgroundTransparency = 1; playerPage.Parent = contentFrame

-- ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ
local function createToggle(parent, title, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -40, 0, 50); frame.Position = position; frame.AnchorPoint = Vector2.new(0.5, 0); frame.BackgroundTransparency = 1; frame.Parent = parent
    
    local label = Instance.new("TextLabel"); label.Name = "Label"; label.Size = UDim2.new(0.5, 0, 1, 0); label.BackgroundTransparency = 1
    label.Font = theme.font_main; label.TextColor3 = theme.text_primary; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = title; label.TextSize = 16; label.Parent = frame

    local toggleSwitch = Instance.new("TextButton"); toggleSwitch.Name = "Toggle"; toggleSwitch.Size = UDim2.new(0, 60, 0, 30); toggleSwitch.Position = UDim2.new(1, 0, 0.5, 0)
    toggleSwitch.AnchorPoint = Vector2.new(1, 0.5); toggleSwitch.Text = ""; toggleSwitch.AutoButtonColor = false; toggleSwitch.Parent = frame

    local bg = Instance.new("Frame", toggleSwitch); bg.Name = "Background"; bg.Size = UDim2.fromScale(1, 1); bg.BackgroundColor3 = theme.accent_off
    local corner_bg = Instance.new("UICorner", bg); corner_bg.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bg); knob.Name = "Knob"; knob.Size = UDim2.new(0, 24, 0, 24); knob.Position = UDim2.fromScale(0, 0.5)
    knob.AnchorPoint = Vector2.new(0, 0.5); knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local corner_knob = Instance.new("UICorner", knob); corner_knob.CornerRadius = UDim.new(1, 0)
    
    local function setToggleState(state, no_anim)
        local target_pos = state and UDim2.fromScale(1, 0.5) or UDim2.fromScale(0, 0.5)
        local target_anchor = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        local target_color = state and theme.accent or theme.accent_off
        if no_anim then
            knob.Position, knob.AnchorPoint, bg.BackgroundColor3 = target_pos, target_anchor, target_color
        else
            TweenService:Create(knob, tween_info, {Position = target_pos, AnchorPoint = target_anchor}):Play()
            TweenService:Create(bg, tween_info, {BackgroundColor3 = target_color}):Play()
        end
    end
    
    return toggleSwitch, setToggleState
end

local immortalityToggle, setImmortalityVisuals = createToggle(playerPage, "Бессмертие", UDim2.new(0.5, 0, 0, 20))

-- ======================================================================
-- ||                ОСНОВНОЙ МОДУЛЬ УПРАВЛЕНИЯ                        ||
-- ======================================================================

local function applyGodProtocols()
    if not humanoid or not humanoid.Parent then return end
    if not godForceField or godForceField.Parent ~= character then if godForceField then godForceField:Destroy() end; godForceField = Instance.new("ForceField", character) end
    if healthChangedConnection then healthChangedConnection:Disconnect() end
    healthChangedConnection = humanoid.HealthChanged:Connect(function() if isImmortal then humanoid.Health = humanoid.MaxHealth end end)
end

local function removeGodProtocols()
    if godForceField then godForceField:Destroy(); godForceField = nil end
    if healthChangedConnection then healthChangedConnection:Disconnect(); healthChangedConnection = nil end
    if humanoid and humanoid.Parent then humanoid.MaxHealth = defaultMaxHealth; humanoid.Health = defaultMaxHealth end
end

local function toggleImmortality()
    if not humanoid then return end
    isImmortal = not isImmortal
    setImmortalityVisuals(isImmortal)
    if isImmortal then applyGodProtocols() else removeGodProtocols() end
end

-- ======================================================================
-- ||             ГЛАВНЫЙ ЦИКЛ ОБНОВЛЕНИЯ И ОБХОДА                     ||
-- ======================================================================
RunService.Heartbeat:Connect(function()
    if not character or not character.Parent or not humanoid or humanoid.Health <= 0 then return end
    if isImmortal then
        if not godForceField or godForceField.Parent ~= character then if godForceField then godForceField:Destroy() end; godForceField = Instance.new("ForceField", character) end
        humanoid.MaxHealth = 1e9
        humanoid.Health = 1e9
    end
end)

-- ======================================================================
-- ||           ПРОТОКОЛ "ВОЗРОЖДЕНИЕ ФЕНИКСА" (ОБРАБОТКА СМЕРТИ)      ||
-- ======================================================================
local function onCharacterAdded(newChar)
    print("[PHANTOM UI]: Новый персонаж. Восстанавливаю протоколы.")
    character, humanoid, rootPart = newChar, newChar:WaitForChild("Humanoid"), newChar:WaitForChild("HumanoidRootPart")
    defaultWalkSpeed, defaultMaxHealth = humanoid.WalkSpeed, humanoid.MaxHealth
    if isImmortal then applyGodProtocols() end
    humanoid.Died:Connect(function() print("[PHANTOM UI]: Персонаж уничтожен.") removeGodProtocols() end)
end

-- ======================================================================
-- ||                       ИНИЦИАЛИЗАЦИЯ СИСТЕМЫ                      ||
-- ======================================================================
local function makeDraggable(guiObject, dragHandle)
    local dragging, dragStart, startPosition = false, nil, nil
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPosition = true, input.Position, guiObject.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainFrame, mainFrame)
immortalityToggle.MouseButton1Click:Connect(toggleImmortality)
UserInputService.InputBegan:Connect(function(input, gpe) if gpe then return end; if input.KeyCode == Enum.KeyCode.G then toggleImmortality() end end)
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

-- Устанавливаем всё в начальное состояние
setImmortalityVisuals(isImmortal, true)
PhantomUI.Parent = player:WaitForChild("PlayerGui")
print("[PHANTOM UI]: Система активна. Клавиша [G] для переключения.")


