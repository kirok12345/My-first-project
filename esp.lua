-- ======================================================================
-- ||              VOID UI (v1.2) - LIVE EDITION                       ||
-- ||      - Добавлен улучшенный "дышащий" живой фон.                 ||
-- ||      - Бинд на клавишу [Insert] для открытия/закрытия меню.     ||
-- ======================================================================

print("[VOID]: Инициализация Live Edition...")

-- СЕРВИСЫ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ПЕРЕМЕННЫЕ
local player = Players.LocalPlayer

-- КОНФИГУРАЦИЯ ДИЗАЙНА "VOID"
local theme = {
    background = Color3.fromRGB(13, 13, 18),
    primary = Color3.fromRGB(22, 22, 28),
    accent = Color3.fromRGB(118, 75, 255),
    text_primary = Color3.fromRGB(230, 230, 230),
    text_secondary = Color3.fromRGB(150, 150, 150),
    font_main = Enum.Font.SourceSans,
    font_bold = Enum.Font.SourceSansBold,
}
local tween_info_fast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween_info_slow = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

-- ======================================================================
-- ||                      СОЗДАНИЕ ИНТЕРФЕЙСА                         ||
-- ======================================================================
local VOID_UI = Instance.new("ScreenGui")
VOID_UI.Name = "VOID_UI"
VOID_UI.ResetOnSpawn = false
VOID_UI.ZIndexBehavior = Enum.ZIndexBehavior.Global

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.fromScale(0.5, 0.48)
mainFrame.Size = UDim2.new(0, 320, 0, 150)
mainFrame.BackgroundColor3 = theme.background
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = VOID_UI

local corner = Instance.new("UICorner", mainFrame); corner.CornerRadius = UDim.new(0, 6)
local border = Instance.new("UIStroke", mainFrame); border.Color = theme.primary; border.Thickness = 2

-- ЖИВОЙ ФОН
local gridBg = Instance.new("Frame", mainFrame)
gridBg.Name = "GridBackground"
gridBg.Size = UDim2.fromScale(1, 1)
gridBg.BackgroundTransparency = 1
gridBg.ClipsDescendants = true
gridBg.ZIndex = 0
local gridLayout = Instance.new("UIGridLayout", gridBg)
gridLayout.CellSize = UDim2.fromOffset(15, 15)
gridLayout.FillDirection = Enum.FillDirection.Horizontal
local gridCells = {}
for i = 1, 400 do
    local p = Instance.new("Frame", gridBg)
    p.BackgroundColor3 = theme.primary
    p.BorderSizePixel = 0
    p.Transparency = 1
    table.insert(gridCells, p)
end

-- ЗАГОЛОВОК
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"; titleLabel.Position = UDim2.new(0.5, 0, 0, 25); titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.Size = UDim2.fromScale(1, 0); titleLabel.BackgroundTransparency = 1; titleLabel.Text = "V O I D"
titleLabel.Font = theme.font_bold; titleLabel.TextColor3 = theme.text_primary; titleLabel.TextSize = 20
titleLabel.ZIndex = 2; titleLabel.Parent = mainFrame

-- ПЕРЕКЛЮЧАТЕЛЬ
local function createToggle(parent, title, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -40, 0, 50); frame.Position = position; frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1; frame.ZIndex = 2; frame.Parent = parent

    local label = Instance.new("TextLabel", frame)
    label.Name = "Label"; label.Size = UDim2.new(0.7, 0, 1, 0); label.BackgroundTransparency = 1; label.Font = theme.font_main
    label.TextColor3 = theme.text_secondary; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = title; label.TextSize = 16

    local toggleButton = Instance.new("TextButton", frame)
    toggleButton.Name = "Toggle"; toggleButton.Size = UDim2.new(0, 50, 0, 26); toggleButton.Position = UDim2.new(1, 0, 0.5, 0)
    toggleButton.AnchorPoint = Vector2.new(1, 0.5); toggleButton.Text = ""; toggleButton.AutoButtonColor = false

    local bg = Instance.new("Frame", toggleButton); bg.Name = "Background"; bg.Size = UDim2.fromScale(1, 1); bg.BackgroundColor3 = theme.primary
    local c_bg = Instance.new("UICorner", bg); c_bg.CornerRadius = UDim.new(1, 0)
    local s_bg = Instance.new("UIStroke", bg); s_bg.Color = Color3.fromRGB(50,50,50); s_bg.Thickness = 1.5

    local knob = Instance.new("Frame", bg); knob.Name = "Knob"; knob.Size = UDim2.new(0, 20, 0, 20); knob.Position = UDim2.fromScale(0.15, 0.5)
    knob.AnchorPoint = Vector2.new(0.5, 0.5); knob.BackgroundColor3 = theme.text_secondary
    local c_knob = Instance.new("UICorner", knob); c_knob.CornerRadius = UDim.new(1, 0)
    
    local state = false
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        local target_pos = state and UDim2.fromScale(0.85, 0.5) or UDim2.fromScale(0.15, 0.5)
        local target_color = state and theme.accent or theme.text_secondary
        TweenService:Create(knob, tween_info_fast, {Position = target_pos, BackgroundColor3 = target_color}):Play()
    end)
    return label
end
local functionGlitchLabel = createToggle(mainFrame, "Placeholder", UDim2.new(0.5, 0, 0.6, 0))

-- ======================================================================
-- ||                       АНИМАЦИИ И ЭФФЕКТЫ                         ||
-- ======================================================================
local function setUIVisible(visible)
    local target_pos = visible and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 0.48)
    local target_transparency = visible and 0 or 1
    if visible then mainFrame.Visible = true end
    local mainTween = TweenService:Create(mainFrame, tween_info_slow, {Position = target_pos, BackgroundTransparency = target_transparency})
    mainTween:Play()
    if not visible then mainTween.Completed:Wait(); mainFrame.Visible = false end
end

local isGlitching = false
local function playGlitch(guiObject)
    if isGlitching then return end
    isGlitching = true
    local originalText = guiObject.Text
    local randomChars = "!@#$%"
    for i = 1, 4 do
        local newText = ""
        for j = 1, #originalText do
            if math.random() > 0.6 and string.sub(originalText, j, j) ~= " " then
                newText = newText .. string.sub(randomChars, math.random(1, #randomChars), math.random(1, #randomChars))
            else
                newText = newText .. string.sub(originalText, j, j)
            end
        end
        guiObject.Text = newText
        task.wait(0.04)
    end
    guiObject.Text = originalText
    isGlitching = false
end
titleLabel.MouseEnter:Connect(function() playGlitch(titleLabel) end)
functionGlitchLabel.MouseEnter:Connect(function() playGlitch(functionGlitchLabel) end)

-- ======================================================================
-- ||                 ГЛАВНЫЙ ЦИКЛ ОБНОВЛЕНИЯ ФОНА                     ||
-- ======================================================================
RunService.Heartbeat:Connect(function(dt)
    if not mainFrame.Visible then return end
    local t = tick()
    -- Сдвиг сетки
    gridLayout.AbsoluteContentSize = Vector2.new(gridLayout.AbsoluteContentSize.X + dt * 5, gridLayout.AbsoluteContentSize.Y)
    if gridLayout.AbsoluteContentSize.X > 500 then
        gridLayout.AbsoluteContentSize = Vector2.new(0, gridLayout.AbsoluteContentSize.Y)
    end
    -- "Дыхание" сетки
    for i, cell in ipairs(gridCells) do
        cell.Transparency = 0.9 + math.sin(t * 2 + i * 0.5) * 0.05
    end
end)

-- ======================================================================
-- ||                       ИНИЦИАЛИЗАЦИЯ СИСТЕМЫ                      ||
-- ======================================================================
local function makeDraggable(guiObject)
    local dragging, dragStart, startPos = false, nil, nil
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, guiObject.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(mainFrame)

-- БИНД ДЛЯ ОТКРЫТИЯ/ЗАКРЫТИЯ МЕНЮ
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    -- Клавиша Insert используется для переключения видимости UI
    if input.KeyCode == Enum.KeyCode.Insert then
        setUIVisible(not mainFrame.Visible or mainFrame.BackgroundTransparency == 1)
    end
end)

VOID_UI.Parent = player:WaitForChild("PlayerGui")
print("[VOID]: Система активна. Нажмите [Insert], чтобы показать или скрыть меню.")
task.wait(0.5)
setUIVisible(true) -- Показываем при запуске


