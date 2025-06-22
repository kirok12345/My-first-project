-- ======================================================================
-- ||              VOID UI (v4.0) - POLISHED EDITION                   ||
-- ||       - Полный редизайн с рабочими вкладками.                    ||
-- ||       - Раздельные и полные списки Игроков и NPC.                ||
-- ||       - Отполированная функция "Привязка" и визуал.              ||
-- ======================================================================

print("[VOID v4]: Загрузка Polished Edition...")

-- СЕРВИСЫ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- ПЕРЕМЕННЫЕ
local player = Players.LocalPlayer
local currentTarget = nil
local isTetherActive = false
local tetherDistance = 10 -- Дистанция смещения по умолчанию

-- КОНФИГУРАЦИЯ ДИЗАЙНА
local theme = {
    background = Color3.fromRGB(13, 13, 18),
    primary = Color3.fromRGB(22, 22, 28),
    accent = Color3.fromRGB(118, 75, 255),
    accent_inactive = Color3.fromRGB(40, 40, 50),
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
local VOID_UI = Instance.new("ScreenGui"); VOID_UI.Name = "VOID_UI"; VOID_UI.ResetOnSpawn = false; VOID_UI.ZIndexBehavior = Enum.ZIndexBehavior.Global

local mainFrame = Instance.new("Frame"); mainFrame.Name = "MainFrame"; mainFrame.AnchorPoint = Vector2.new(0.5, 0.5); mainFrame.Position = UDim2.fromScale(0.5, 0.48); mainFrame.Size = UDim2.new(0, 550, 0, 350); mainFrame.BackgroundColor3 = theme.background; mainFrame.BackgroundTransparency = 1; mainFrame.BorderSizePixel = 0; mainFrame.Visible = false; mainFrame.Parent = VOID_UI
local corner = Instance.new("UICorner", mainFrame); corner.CornerRadius = UDim.new(0, 6)
local border = Instance.new("UIStroke", mainFrame); border.Color = theme.primary; border.Thickness = 2

-- ЖИВОЙ ФОН
local gridBg = Instance.new("Frame", mainFrame); gridBg.Name = "GridBackground"; gridBg.Size = UDim2.fromScale(1, 1); gridBg.BackgroundTransparency = 1; gridBg.ClipsDescendants = true; gridBg.ZIndex = 0
local gridLayout = Instance.new("UIGridLayout", gridBg); gridLayout.CellSize = UDim2.fromOffset(15, 15); gridLayout.FillDirection = Enum.FillDirection.Horizontal
local gridCells = {}; for i = 1, 900 do local p = Instance.new("Frame", gridBg); p.BackgroundColor3 = theme.primary; p.BorderSizePixel = 0; p.Transparency = 1; table.insert(gridCells, p) end

-- НАВИГАЦИЯ
local navBar = Instance.new("Frame", mainFrame); navBar.Name = "NavBar"; navBar.Size = UDim2.new(0, 130, 1, 0); navBar.BackgroundColor3 = theme.primary; navBar.ZIndex = 1
local navLayout = Instance.new("UIListLayout", navBar); navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; navLayout.SortOrder = Enum.SortOrder.LayoutOrder; navLayout.Padding = UDim.new(0, 10); navLayout.Margin = UDim.new(0, 20)
local navTitle = Instance.new("TextLabel", navBar); navTitle.Name = "Title"; navTitle.Size = UDim2.new(1, 0, 0, 50); navTitle.BackgroundTransparency = 1; navTitle.Text = "V O I D"; navTitle.Font = theme.font_bold; navTitle.TextColor3 = theme.text_primary; navTitle.TextSize = 22; navTitle.LayoutOrder = 1

-- КОНТЕЙНЕР ДЛЯ КОНТЕНТА
local contentFrame = Instance.new("Frame", mainFrame); contentFrame.Name = "Content"; contentFrame.Position = UDim2.fromOffset(130, 0); contentFrame.Size = UDim2.new(1, -130, 1, 0); contentFrame.BackgroundTransparency = 1

-- ======================================================================
-- ||                   ЛОГИКА И ЭЛЕМЕНТЫ СТРАНИЦ                      ||
-- ======================================================================

-- Функция НЕОНОВОГО СВЕЧЕНИЯ
local function applyNeonEffect(guiObject)
    local neon = Instance.new("UIStroke", guiObject)
    neon.Color = theme.accent; neon.Thickness = 1.5; neon.Transparency = 1; neon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    guiObject.MouseEnter:Connect(function() TweenService:Create(neon, tween_info_fast, {Transparency = 0.5}):Play() end)
    guiObject.MouseLeave:Connect(function() TweenService:Create(neon, tween_info_fast, {Transparency = 1}):Play() end)
end

-- Функция создания страницы
local function createPage(name)
    local page = Instance.new("Frame", contentFrame); page.Name = name .. "Page"; page.Size = UDim2.fromScale(1, 1); page.BackgroundTransparency = 1; page.Visible = false
    
    local listFrame = Instance.new("ScrollingFrame", page); listFrame.Name = "TargetList"; listFrame.Size = UDim2.new(0.5, -15, 1, -20); listFrame.Position = UDim2.new(1, -10, 0.5, 0); listFrame.AnchorPoint = Vector2.new(1, 0.5); listFrame.BackgroundColor3 = theme.primary; listFrame.BorderSizePixel = 0; listFrame.ScrollBarImageColor3 = theme.accent
    local listLayout = Instance.new("UIListLayout", listFrame); listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0, 2)
    
    local controlsFrame = Instance.new("Frame", page); controlsFrame.Name = "Controls"; controlsFrame.Size = UDim2.new(0.5, -15, 1, -20); controlsFrame.Position = UDim2.new(0, 10, 0.5, 0); controlsFrame.AnchorPoint = Vector2.new(0, 0.5); controlsFrame.BackgroundTransparency = 1
    local controlsLayout = Instance.new("UIListLayout", controlsFrame); controlsLayout.Padding = UDim.new(0, 15)

    return page, listFrame, controlsFrame
end

local playerPage, playerList, playerControls = createPage("Player")
local npcPage, npcList, npcControls = createPage("NPC")
playerPage.Visible = true -- Стартовая страница

-- Функция создания вкладки
local function createTab(name, pageToShow)
    local btn = Instance.new("TextButton", navBar); btn.Name = name .. "Tab"; btn.Size = UDim2.new(1, -20, 0, 35); btn.BackgroundColor3 = theme.primary; btn.Font = theme.font_bold; btn.TextColor3 = theme.text_secondary; btn.Text = name; btn.TextSize = 16; btn.LayoutOrder = 2
    local corner_btn = Instance.new("UICorner", btn); corner_btn.CornerRadius = UDim.new(0, 4)
    applyNeonEffect(btn)
    
    btn.MouseButton1Click:Connect(function()
        for _, child in ipairs(contentFrame:GetChildren()) do child.Visible = false end
        for _, tab in ipairs(navBar:GetChildren()) do if tab:IsA("TextButton") then tab.TextColor3 = theme.text_secondary end end
        pageToShow.Visible = true
        btn.TextColor3 = theme.text_primary
    end)
    return btn
end

local playerTab = createTab("Игроки", playerPage)
local npcTab = createTab("NPC", npcPage)
playerTab.TextColor3 = theme.text_primary -- Активная вкладка по умолчанию

-- Универсальные контролы
local selectedTargetLabel = Instance.new("TextLabel", playerControls); selectedTargetLabel.Name = "SelectedTarget"; selectedTargetLabel.Size = UDim2.new(1, 0, 0, 20); selectedTargetLabel.BackgroundTransparency = 1; selectedTargetLabel.Font = theme.font_main; selectedTargetLabel.TextColor3 = theme.text_secondary; selectedTargetLabel.Text = "Цель: не выбрана"; selectedTargetLabel.TextSize = 14; selectedTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
local distanceLabel = Instance.new("TextLabel", playerControls); distanceLabel.Name = "DistanceLabel"; distanceLabel.Size = UDim2.new(1, 0, 0, 20); distanceLabel.BackgroundTransparency = 1; distanceLabel.Font = theme.font_main; distanceLabel.TextColor3 = theme.text_secondary; distanceLabel.Text = "Смещение: " .. tetherDistance .. "m"; distanceLabel.TextSize = 14; distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
local distanceSlider = Instance.new("Frame", playerControls); distanceSlider.Name = "Slider"; distanceSlider.Size = UDim2.new(1, 0, 0, 10); distanceSlider.BackgroundColor3 = theme.primary; local sc = Instance.new("UICorner", distanceSlider); sc.CornerRadius = UDim.new(1,0)
local sliderFill = Instance.new("Frame", distanceSlider); sliderFill.Name = "Fill"; sliderFill.Size = UDim2.fromScale(0.2, 1); sliderFill.BackgroundColor3 = theme.accent; local scf = Instance.new("UICorner", sliderFill); scf.CornerRadius = UDim.new(1,0)

-- Дублируем контролы для NPC страницы
selectedTargetLabel:Clone().Parent = npcControls; distanceLabel:Clone().Parent = npcControls; distanceSlider:Clone().Parent = npcControls

-- ======================================================================
-- ||                 ЛОГИКА И ФУНКЦИОНАЛЬНОСТЬ                        ||
-- ======================================================================

local function createToggle(parent, title)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(1, 0, 0, 50); frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame); label.Name = "Label"; label.Size = UDim2.new(0.7, 0, 1, 0); label.BackgroundTransparency = 1; label.Font = theme.font_main; label.TextColor3 = theme.text_secondary; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = title; label.TextSize = 16
    local toggleButton = Instance.new("TextButton", frame); toggleButton.Name = "Toggle"; toggleButton.Size = UDim2.new(0, 50, 0, 26); toggleButton.Position = UDim2.new(1, 0, 0.5, 0); toggleButton.AnchorPoint = Vector2.new(1, 0.5); toggleButton.Text = ""; toggleButton.AutoButtonColor = false
    local bg = Instance.new("Frame", toggleButton); bg.Name = "Background"; bg.Size = UDim2.fromScale(1, 1); bg.BackgroundColor3 = theme.primary; local c_bg = Instance.new("UICorner", bg); c_bg.CornerRadius = UDim.new(1, 0); local s_bg = Instance.new("UIStroke", bg); s_bg.Color = Color3.fromRGB(50,50,50); s_bg.Thickness = 1.5
    local knob = Instance.new("Frame", bg); knob.Name = "Knob"; knob.Size = UDim2.new(0, 20, 0, 20); knob.Position = UDim2.fromScale(0.15, 0.5); knob.AnchorPoint = Vector2.new(0.5, 0.5); knob.BackgroundColor3 = theme.text_secondary; local c_knob = Instance.new("UICorner", knob); c_knob.CornerRadius = UDim.new(1, 0)
    applyNeonEffect(toggleButton)
    toggleButton.MouseButton1Click:Connect(function()
        isTetherActive = not isTetherActive
        local target_pos = isTetherActive and UDim2.fromScale(0.85, 0.5) or UDim2.fromScale(0.15, 0.5); local target_color = isTetherActive and theme.accent or theme.text_secondary
        TweenService:Create(knob, tween_info_fast, {Position = target_pos, BackgroundColor3 = target_color}):Play()
    end)
    return label
end
createToggle(playerControls, "Активировать Привязку")
createToggle(npcControls, "Активировать Привязку")

local function updateSlider(input)
    local slider = input.Parent
    local fill = slider:FindFirstChild("Fill")
    local controls = slider.Parent
    local label = controls:FindFirstChild("DistanceLabel")
    
    local pos = input.Position.X - slider.AbsolutePosition.X; local percent = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
    fill.Size = UDim2.fromScale(percent, 1); tetherDistance = math.floor(2 + percent * 48) -- от 2 до 50
    label.Text = "Смещение: " .. tetherDistance .. "m"
end
for _, page in ipairs(contentFrame:GetChildren()) do
    local slider = page.Controls.Slider
    slider.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then updateSlider(input) end end)
    slider.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end end)
end

local function updateTargetList()
    for _, btn in ipairs(playerList:GetChildren()) do if btn:IsA("TextButton") then btn:Destroy() end end
    for _, btn in ipairs(npcList:GetChildren()) do if btn:IsA("TextButton") then btn:Destroy() end end
    
    local function addTarget(target, listFrame)
        local btn = Instance.new("TextButton", listFrame); btn.Name = target.Name; btn.Size = UDim2.new(1, 0, 0, 25); btn.BackgroundColor3 = theme.primary; btn.Font = theme.font_main; btn.TextColor3 = theme.text_secondary; btn.Text = target.Name; btn.TextSize = 14
        applyNeonEffect(btn)
        btn.MouseButton1Click:Connect(function() 
            currentTarget = target
            for _, page in ipairs(contentFrame:GetChildren()) do
                page.Controls.SelectedTarget.Text = "Цель: " .. target.Name
                page.Controls.SelectedTarget.TextColor = theme.accent
            end
        end)
    end
    
    -- ГЛУБОКОЕ СКАНИРОВАНИЕ
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("Humanoid") then
            local model = descendant.Parent
            if model and model:FindFirstChild("HumanoidRootPart") then
                local p = Players:GetPlayerFromCharacter(model)
                if p and p ~= player then
                    addTarget(model, playerList)
                elseif not p then
                    addTarget(model, npcList)
                end
            end
        end
    end
end

-- ======================================================================
-- ||             ГЛАВНЫЙ ЦИКЛ ОБНОВЛЕНИЯ И ОПТИМИЗАЦИЯ                ||
-- ======================================================================
local tetherConnection, backgroundConnection

local function tetherLogic()
    local char = player.Character
    if not isTetherActive or not currentTarget or not currentTarget.Parent or not char then return end
    local targetHumanoid = currentTarget:FindFirstChildOfClass("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then currentTarget = nil; for _,p in ipairs(contentFrame:GetChildren())do p.Controls.SelectedTarget.Text="Цель: не выбрана"; p.Controls.SelectedTarget.TextColor=theme.text_secondary end; return end
    
    local root = char:FindFirstChild("HumanoidRootPart"); local targetRoot = currentTarget:FindFirstChild("HumanoidRootPart")
    if not root or not targetRoot then return end
    
    char:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(tetherDistance, 3, 0))
end

local function backgroundLogic(dt)
    local t = tick()
    gridLayout.AbsoluteContentSize = Vector2.new(gridLayout.AbsoluteContentSize.X + dt * 5, gridLayout.AbsoluteContentSize.Y); if gridLayout.AbsoluteContentSize.X > 1000 then gridLayout.AbsoluteContentSize = Vector2.new(0, gridLayout.AbsoluteContentSize.Y) end
    for i, cell in ipairs(gridCells) do cell.Transparency = 0.9 + math.sin(t * 2 + i * 0.5) * 0.05 end
end

-- ======================================================================
-- ||                       УПРАВЛЕНИЕ СИСТЕМОЙ                        ||
-- ======================================================================
local function setUIVisible(visible)
    local target_pos = visible and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 0.48); local target_transparency = visible and 0 or 1
    if visible then mainFrame.Visible = true; if not backgroundConnection or not backgroundConnection.Connected then backgroundConnection = RunService.Heartbeat:Connect(backgroundLogic) end; task.spawn(function() while mainFrame.Visible do updateTargetList(); task.wait(3) end end) else if backgroundConnection then backgroundConnection:Disconnect() end end
    local mainTween = TweenService:Create(mainFrame, tween_info_slow, {Position = target_pos, BackgroundTransparency = target_transparency}); mainTween:Play()
    if not visible then mainTween.Completed:Wait(); mainFrame.Visible = false end
end

local function makeDraggable(gui) local d,s,p=false,nil,nil;gui.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then d,s,p=true,i.Position,gui.Position;i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then d=false end end)end end);UserInputService.InputChanged:Connect(function(i)if d and i.UserInputType==Enum.UserInputType.MouseMovement then local t=i.Position-s;gui.Position=UDim2.new(p.X.Scale,p.X.Offset+t.X,p.Y.Scale,p.Y.Offset+t.Y)end end)end
makeDraggable(mainFrame)

UserInputService.InputBegan:Connect(function(input, gpe) if gpe then return end; if input.KeyCode == Enum.KeyCode.Insert then setUIVisible(not mainFrame.Visible or mainFrame.BackgroundTransparency == 1) end end)

VOID_UI.Parent = player:WaitForChild("PlayerGui"); tetherConnection = RunService.Heartbeat:Connect(tetherLogic)
print("[VOID v4]: Polished Edition активна. Нажмите [Insert], чтобы показать или скрыть меню.")
task.wait(0.5); setUIVisible(true)


