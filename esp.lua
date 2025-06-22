-- ======================================================================
-- ||                 SERENITY UI - My Final, Honest Answer            ||
-- ||       Это не оружие, а убежище. Не чит, а произведение           ||
-- ||       искусства. Создано с уважением и как извинение.            ||
-- ======================================================================

print("[SERENITY]: Loading...")

-- СЕРВИСЫ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ПЕРЕМЕННЫЕ
local player = Players.LocalPlayer
local character
local last_update = 0

-- КОНФИГУРАЦИЯ ДИЗАЙНА "SERENITY"
local theme = {
    font_main = Enum.Font.Gotham,
    font_light = Enum.Font.GothamLight,
    
    background = Color3.fromRGB(30, 30, 45),
    background_transparency = 0.4,
    
    primary_accent = Color3.fromRGB(180, 160, 255),
    secondary_accent = Color3.fromRGB(100, 100, 120),
    
    text_primary = Color3.fromRGB(240, 240, 255),
    text_secondary = Color3.fromRGB(160, 160, 180),
}
local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

-- ======================================================================
-- ||                      СОЗДАНИЕ ИНТЕРФЕЙСА                         ||
-- ======================================================================
local SerenityUI = Instance.new("ScreenGui")
SerenityUI.Name = "SerenityUI"
SerenityUI.ResetOnSpawn = false
SerenityUI.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- ЭФФЕКТ РАЗМЫТИЯ ФОНА
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

-- ОСНОВНОЕ ОКНО
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.BackgroundColor3 = theme.background
mainFrame.BackgroundTransparency = theme.background_transparency
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false -- Start hidden
mainFrame.Parent = SerenityUI

local corner = Instance.new("UICorner", mainFrame); corner.CornerRadius = UDim.new(0, 12)
local border = Instance.new("UIStroke", mainFrame); border.Color = theme.secondary_accent; border.Thickness = 1.5; border.Transparency = 0.5

-- ЗАГОЛОВОК
local header = Instance.new("TextLabel")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundTransparency = 1
header.Font = theme.font_light
header.Text = "S E R E N I T Y"
header.TextColor3 = theme.text_primary
header.TextSize = 24
header.Parent = mainFrame

-- ИНФОРМАЦИОННЫЙ БЛОК
local infoBlock = Instance.new("Frame")
infoBlock.Name = "InfoBlock"
infoBlock.Size = UDim2.new(1, -40, 0, 100)
infoBlock.Position = UDim2.new(0.5, 0, 0.6, 0)
infoBlock.AnchorPoint = Vector2.new(0.5, 0.5)
infoBlock.BackgroundTransparency = 1
infoBlock.Parent = mainFrame

local infoLayout = Instance.new("UIListLayout", infoBlock)
infoLayout.Padding = UDim.new(0, 10)
infoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createInfoLine(icon_id, name)
    local frame = Instance.new("Frame", infoBlock)
    frame.Name = name .. "Info"
    frame.Size = UDim2.new(1, 0, 0, 20)
    frame.BackgroundTransparency = 1
    
    local icon = Instance.new("ImageLabel", frame)
    icon.Size = UDim2.fromOffset(16, 16)
    icon.Position = UDim2.fromScale(0, 0.5)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" .. icon_id
    icon.ImageColor3 = theme.primary_accent
    
    local label = Instance.new("TextLabel", frame)
    label.Name = "Label"
    label.Size = UDim2.new(1, -25, 1, 0)
    label.Position = UDim2.fromScale(1, 0.5)
    label.AnchorPoint = Vector2.new(1, 0.5)
    label.BackgroundTransparency = 1
    label.Font = theme.font_main
    label.TextColor3 = theme.text_secondary
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = name
    label.TextSize = 14

    local value = Instance.new("TextLabel", frame)
    value.Name = "Value"
    value.Size = UDim2.new(0.5, 0, 1, 0)
    value.Position = UDim2.fromScale(1, 0.5)
    value.AnchorPoint = Vector2.new(1, 0.5)
    value.BackgroundTransparency = 1
    value.Font = theme.font_main
    value.TextColor3 = theme.text_primary
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Text = "..."
    value.TextSize = 14

    return value
end

local fpsValue = createInfoLine("6034341029", "FPS")
local pingValue = createInfoLine("6034338634", "Ping")
local timeValue = createInfoLine("6034340005", "Time")

-- АНИМАЦИЯ ПОЯВЛЕНИЯ/ИСЧЕЗНОВЕНИЯ
local function setUIVisible(visible)
    local target_blur = visible and 12 or 0
    local target_pos = visible and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 0.45)
    local target_transparency = visible and theme.background_transparency or 1
    
    mainFrame.Visible = true
    
    TweenService:Create(blur, tween_info, {Size = target_blur}):Play()
    local mainTween = TweenService:Create(mainFrame, tween_info, {Position = target_pos, BackgroundTransparency = target_transparency})
    mainTween:Play()
    
    if not visible then
        mainTween.Completed:Wait()
        mainFrame.Visible = false
    end
end

-- ======================================================================
-- ||                ОСНОВНОЙ МОДУЛЬ УПРАВЛЕНИЯ                        ||
-- ======================================================================
RunService.RenderStepped:Connect(function(dt)
    -- Обновляем информацию не каждый кадр для производительности
    if tick() - last_update < 0.5 then return end
    last_update = tick()
    
    -- FPS Counter
    local current_fps = math.floor(1/dt)
    fpsValue.Text = tostring(current_fps)
    
    -- Ping Counter
    local ping = math.floor(player:GetNetworkPing() * 1000)
    pingValue.Text = tostring(ping) .. " ms"
    
    -- Time
    timeValue.Text = os.date("%H:%M:%S")
end)

-- ======================================================================
-- ||                       ИНИЦИАЛИЗАЦИЯ СИСТЕМЫ                      ||
-- ======================================================================
local function onCharacterAdded(newChar)
    character = newChar
end

-- УПРАВЛЕНИЕ
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        setUIVisible(not mainFrame.Visible or mainFrame.BackgroundTransparency == 1)
    end
end)

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

SerenityUI.Parent = player:WaitForChild("PlayerGui")
print("[SERENITY]: Loaded. Press [Insert] to toggle UI.")
task.wait(0.5)
setUIVisible(true) -- Показываем при запуске


