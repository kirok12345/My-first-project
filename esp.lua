-- ======================================================================
-- ||           PROJECT CHIMERA (FINAL) - THE ULTIMATUM                ||
-- ||       Это не скрипт. Это аномалия. Конец пути.                   ||
-- ||       Абсолютный максимум технологии клиентского обхода.         ||
-- ======================================================================

print("[CHIMERA]: Инициализация аномальной системы... ЗАГРУЗКА ЯДРА.")

-- СЕРВИСЫ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
local player = Players.LocalPlayer
local character, humanoid
local isGodProtocolActive = false
local originalNamecall

-- ИНТЕРФЕЙС "ХИМЕРЫ"
local theme = {
    background = Color3.fromRGB(10, 10, 10),
    primary = Color3.fromRGB(20, 20, 20),
    accent = Color3.fromRGB(255, 10, 80),
    text_primary = Color3.fromRGB(0, 255, 130),
    text_secondary = Color3.fromRGB(100, 100, 100),
    font_main = Enum.Font.Code,
}
local ChimeraUI = Instance.new("ScreenGui"); ChimeraUI.Name = "ChimeraUI"; ChimeraUI.ResetOnSpawn = false; ChimeraUI.ZIndexBehavior = Enum.ZIndexBehavior.Global

local mainFrame = Instance.new("Frame"); mainFrame.Name = "MainFrame"; mainFrame.AnchorPoint = Vector2.new(0.5, 0.5); mainFrame.Position = UDim2.fromScale(0.5, 0.5); mainFrame.Size = UDim2.new(0, 600, 0, 400); mainFrame.BackgroundColor3 = theme.background; mainFrame.BorderSizePixel = 0; mainFrame.Parent = ChimeraUI
local corner = Instance.new("UICorner", mainFrame); corner.CornerRadius = UDim.new(0, 2)
local border = Instance.new("UIStroke", mainFrame); border.Color = theme.primary; border.Thickness = 2

-- ======================================================================
-- ||                        UI КОМПОНЕНТЫ                              ||
-- ======================================================================
local header = Instance.new("TextLabel", mainFrame); header.Name = "Header"; header.Size = UDim2.new(1, 0, 0, 30); header.BackgroundTransparency = 1; header.Text = "P R O J E C T  C H I M E R A // Anomaly Intervention System"; header.Font = theme.font_main; header.TextColor3 = theme.text_secondary; header.TextSize = 14

local logFrame = Instance.new("ScrollingFrame", mainFrame); logFrame.Name = "LogFrame"; logFrame.Position = UDim2.new(0.5, 0, 0.55, 0); logFrame.AnchorPoint = Vector2.new(0.5, 0.5); logFrame.Size = UDim2.new(1, -20, 1, -110); logFrame.BackgroundColor3 = theme.primary; logFrame.BorderSizePixel = 0; logFrame.CanvasSize = UDim2.new(0, 0, 0, 0); logFrame.ScrollBarImageColor3 = theme.accent
local listLayout = Instance.new("UIListLayout", logFrame); listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0, 2)

local statusFrame = Instance.new("Frame", mainFrame); statusFrame.Name = "StatusFrame"; statusFrame.Position = UDim2.new(0.5, 0, 0, 40); statusFrame.Size = UDim2.new(1, -20, 0, 50); statusFrame.BackgroundTransparency = 1
local statusLayout = Instance.new("UIListLayout", statusFrame); statusLayout.FillDirection = Enum.FillDirection.Horizontal; statusLayout.VerticalAlignment = Enum.VerticalAlignment.Center; statusLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; statusLayout.SortOrder = Enum.SortOrder.LayoutOrder; statusLayout.Padding = UDim.new(0, 10)

local function createStatus(text)
    local frame = Instance.new("Frame", statusFrame); frame.Size = UDim2.new(0, 130, 0, 30); frame.BackgroundTransparency = 1
    local indicator = Instance.new("Frame", frame); indicator.Name = "Indicator"; indicator.Size = UDim2.new(0, 10, 0, 10); indicator.Position = UDim2.new(0, 0, 0.5, 0); indicator.AnchorPoint = Vector2.new(0, 0.5); indicator.BackgroundColor3 = theme.text_secondary
    local corner_ind = Instance.new("UICorner", indicator); corner_ind.CornerRadius = UDim.new(1, 0)
    local label = Instance.new("TextLabel", frame); label.Name = "Label"; label.Size = UDim2.new(1, -15, 1, 0); label.Position = UDim2.new(1, 0, 0.5, 0); label.AnchorPoint = Vector2.new(1, 0.5); label.BackgroundTransparency = 1; label.Text = text; label.Font = theme.font_main; label.TextColor3 = theme.text_secondary; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Right
    return indicator
end
local aegisStatus = createStatus("AEGIS SHIELD")
local prometheusStatus = createStatus("PROMETHEUS CORE")
local kairosStatus = createStatus("KAIROS JITTER")
local metastasisStatus = createStatus("METASTASIS HOOK")

-- ======================================================================
-- ||                СИСТЕМА ЛОГИРОВАНИЯ И УПРАВЛЕНИЯ                  ||
-- ======================================================================
local function addLog(subsystem, message, color)
    if #logFrame:GetChildren() > 50 then logFrame:GetChildren()[2]:Destroy() end
    local logLabel = Instance.new("TextLabel"); logLabel.Name = "Log"; logLabel.Size = UDim2.new(1, -10, 0, 14); logLabel.BackgroundTransparency = 1
    logLabel.Font = theme.font_main; logLabel.Text = `[${subsystem}] >> ${message}`; logLabel.TextXAlignment = Enum.TextXAlignment.Left
    logLabel.TextColor3 = color or theme.text_primary; logLabel.TextSize = 12; logLabel.Parent = logFrame
    logFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

local function setStatus(indicator, isActive)
    local color = isActive and theme.text_primary or theme.text_secondary
    TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
end

-- ======================================================================
-- ||                  ЯДРО СИСТЕМЫ "ХИМЕРА"                           ||
-- ======================================================================
local function hookNamecall()
    if not humanoid then addLog("METASTASIS", "Hook failed: Humanoid not found.", theme.accent); return end
    local mt = getrawmetatable(humanoid)
    if not mt then addLog("METASTASIS", "Hook failed: Metatable is nil.", theme.accent); return end
    originalNamecall = mt.__namecall
    
    local newNamecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        -- Мы перехватываем все, что может нанести урон
        if method == "TakeDamage" or method == "takeDamage" then
            addLog("METASTASIS", "Blocked incoming damage call.", theme.accent)
            return -- БЛОКИРУЕМ ВЫЗОВ
        end
        return originalNamecall(self, ...)
    end)
    
    setreadonly(mt, false)
    mt.__namecall = newNamecall
    setreadonly(mt, true)
    addLog("METASTASIS", "Core hook established on Humanoid.", theme.text_primary)
    setStatus(metastasisStatus, true)
end

local function unhookNamecall()
    if not humanoid or not originalNamecall then return end
    local mt = getrawmetatable(humanoid)
    if mt then
        setreadonly(mt, false)
        mt.__namecall = originalNamecall
        setreadonly(mt, true)
    end
    addLog("METASTASIS", "Core hook released.", theme.text_secondary)
    setStatus(metastasisStatus, false)
end

local function activateGodProtocol()
    if not humanoid then return end
    isGodProtocolActive = true
    addLog("SYSTEM", "GOD PROTOCOL: ACTIVE", theme.accent)
    hookNamecall()
    setStatus(aegisStatus, true); setStatus(prometheusStatus, true); setStatus(kairosStatus, true)
end

local function deactivateGodProtocol()
    isGodProtocolActive = false
    addLog("SYSTEM", "GOD PROTOCOL: INACTIVE", theme.text_secondary)
    unhookNamecall()
    -- Отключаем все эффекты
    if humanoid and humanoid.Parent then humanoid.MaxHealth = humanoid.MaxHealth end -- Reset MaxHealth
    setStatus(aegisStatus, false); setStatus(prometheusStatus, false); setStatus(kairosStatus, false)
end

-- ======================================================================
-- ||                ПРОТОКОЛ "ВОЗРОЖДЕНИЕ ФЕНИКСА"                    ||
-- ======================================================================
local function onCharacterAdded(newChar)
    addLog("SYSTEM", "New host detected. Re-initializing protocols...", theme.text_secondary)
    character, humanoid = newChar, newChar:WaitForChild("Humanoid")
    if isGodProtocolActive then activateGodProtocol() end
    humanoid.Died:Connect(function() addLog("SYSTEM", "Host terminated. Awaiting respawn.", theme.accent) end)
end

-- ======================================================================
-- ||                          ГЛАВНЫЙ ЦИКЛ                            ||
-- ======================================================================
RunService.Heartbeat:Connect(function(dt)
    if not isGodProtocolActive or not humanoid or humanoid.Health <= 0 then return end
    
    -- AEGIS SHIELD: Постоянное силовое поле
    if not character:FindFirstChildOfClass("ForceField") then
        Instance.new("ForceField", character)
        addLog("AEGIS", "Shield integrity restored.", theme.text_primary)
    end
    
    -- PROMETHEUS CORE: Агрессивная регенерация
    humanoid.MaxHealth = 1e9
    if humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
        addLog("PROMETHEUS", "Health anomaly corrected.", theme.text_primary)
    end
    
    -- KAIROS JITTER: Сетевой шум
    rootPart.CFrame = rootPart.CFrame * CFrame.new(0, math.sin(tick() * 20) * 0.005, 0)
end)

-- ======================================================================
-- ||                         ИНИЦИАЛИЗАЦИЯ                            ||
-- ======================================================================
local function makeDraggable(gui) local d,s,p=false,nil,nil;gui.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then d,s,p=true,i.Position,gui.Position;i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then d=false end end)end end);UserInputService.InputChanged:Connect(function(i)if d and i.UserInputType==Enum.UserInputType.MouseMovement then local t=i.Position-s;gui.Position=UDim2.new(p.X.Scale,p.X.Offset+t.X,p.Y.Scale,p.Y.Offset+t.Y)end end)end
makeDraggable(mainFrame)
UserInputService.InputBegan:Connect(function(i,g) if g then return end; if i.KeyCode==Enum.KeyCode.G then if isGodProtocolActive then deactivateGodProtocol() else activateGodProtocol() end end end)
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

ChimeraUI.Parent = player:WaitForChild("PlayerGui")
addLog("SYSTEM", "Chimera is online. Press [G] to activate God Protocol.", theme.text_secondary)


