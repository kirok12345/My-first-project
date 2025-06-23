-- Services (Сервисы)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Player (Игрок)
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- UI Elements (Элементы UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteMenuGui"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 300) -- Размер меню
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Центрирование
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45) -- Темный фон
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 60)
MainFrame.BorderSizePixel = 2
MainFrame.CornerRadius = UDim.new(0, 8) -- Слегка округлые углы
MainFrame.Active = true -- Делает фрейм интерактивным для перетаскивания
MainFrame.Draggable = true -- Позволяет перетаскивать фрейм
MainFrame.Parent = ScreenGui

-- Добавляем тень для MainFrame (необязательно, но добавляет "премиальности")
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 10, 1, 10) -- Немного больше MainFrame
Shadow.Position = UDim2.new(0, -5, 0, -5) -- Смещение для создания тени
Shadow.Image = "rbxassetid://6207186675" -- Изображение для тени (используйте ID круглой тени из Roblox)
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ZIndex = 0 -- Должна быть под MainFrame
Shadow.ScaleType = Enum.ScaleType.Slice -- Важно для правильного отображения тени
Shadow.SliceCenter = Rect.new(10, 10, 10, 10) -- Центр для слайсинга тени
Shadow.Parent = MainFrame -- Временно делаем частью MainFrame для позиционирования, потом переместим в ScreenGui

-- Перемещаем Shadow в ScreenGui, чтобы она была под MainFrame
Shadow.Parent = ScreenGui
Shadow.ZIndex = MainFrame.ZIndex - 1 -- Убедимся, что тень под фреймом
Shadow.Position = MainFrame.Position + UDim2.new(0, 5, 0, 5) -- Сдвиг тени относительно MainFrame

-- Заголовок меню
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
TitleBar.BorderColor3 = Color3.fromRGB(60, 60, 70)
TitleBar.BorderSizePixel = 1
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Position = UDim2.new(0, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleText.Font = Enum.Font.GothamBold -- Стильный шрифт
TitleText.TextSize = 18
TitleText.Text = "ELITE CHEAT MENU"
TitleText.Parent = TitleBar

-- Кнопка закрытия/открытия (Trigger Button)
local TriggerButton = Instance.new("TextButton")
TriggerButton.Name = "TriggerButton"
TriggerButton.Size = UDim2.new(0, 80, 0, 30)
TriggerButton.Position = UDim2.new(0, 10, 0, 10) -- Позиция кнопки в левом верхнем углу экрана
TriggerButton.AnchorPoint = Vector2.new(0, 0)
TriggerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TriggerButton.BorderColor3 = Color3.fromRGB(60, 60, 70)
TriggerButton.BorderSizePixel = 1
TriggerButton.TextColor3 = Color3.fromRGB(200, 200, 200)
TriggerButton.Font = Enum.Font.GothamBold
TriggerButton.TextSize = 16
TriggerButton.Text = "Меню"
TriggerButton.CornerRadius = UDim.new(0, 5)
TriggerButton.Parent = ScreenGui

-- Параметры анимации (TweenInfo)
local tweenInfoIn = TweenInfo.new(
    0.3, -- Время анимации (секунды)
    Enum.EasingStyle.Quad, -- Стиль анимации (например, Quad, Sine, Cubic)
    Enum.EasingDirection.Out, -- Направление анимации (Out, InOut)
    0, -- Повторы
    false, -- Реверс
    0 -- Задержка
)

local tweenInfoOut = TweenInfo.new(
    0.3,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.In,
    0,
    false,
    0
)

local tweenInfoButtonHover = TweenInfo.new(
    0.1,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out,
    0,
    false,
    0
)

local tweenInfoButtonLeave = TweenInfo.new(
    0.1,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.In,
    0,
    false,
    0
)

-- Изначально меню скрыто
MainFrame.Visible = false
MainFrame.BackgroundTransparency = 1
MainFrame.Active = false
Shadow.ImageTransparency = 1

-- Функция для показа меню
local function showMenu()
    MainFrame.Visible = true
    MainFrame.Active = true -- Делаем активным для перетаскивания
    local goals = {BackgroundTransparency = 0, BorderSizePixel = 2}
    local shadowGoals = {ImageTransparency = 0.6}
    TweenService:Create(MainFrame, tweenInfoIn, goals):Play()
    TweenService:Create(Shadow, tweenInfoIn, shadowGoals):Play()
end

-- Функция для скрытия меню
local function hideMenu()
    MainFrame.Active = false -- Отключаем перетаскивание при скрытии
    local goals = {BackgroundTransparency = 1, BorderSizePixel = 0}
    local shadowGoals = {ImageTransparency = 1}
    local tween = TweenService:Create(MainFrame, tweenInfoOut, goals)
    local shadowTween = TweenService:Create(Shadow, tweenInfoOut, shadowGoals)
    
    tween.Completed:Connect(function()
        MainFrame.Visible = false
    end)
    
    tween:Play()
    shadowTween:Play()
end

-- Обработка нажатия на кнопку TriggerButton
TriggerButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        hideMenu()
    else
        showMenu()
    end
end)

-- Обработка наведения на кнопки для анимации (пример для TriggerButton)
TriggerButton.MouseEnter:Connect(function()
    TweenService:Create(TriggerButton, tweenInfoButtonHover, {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
end)

TriggerButton.MouseLeave:Connect(function()
    TweenService:Create(TriggerButton, tweenInfoButtonLeave, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
end)

-- Добавление вкладок меню (пример)
local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(0.25, 0, 1, -30) -- 25% ширины, минус высота TitleBar
TabFrame.Position = UDim2.new(0, 0, 0, 30)
TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- Более темный фон для вкладок
TabFrame.BorderColor3 = Color3.fromRGB(40, 40, 50)
TabFrame.BorderSizePixel = 1
TabFrame.Parent = MainFrame

local TabHolder = Instance.new("UIListLayout") -- Для автоматического размещения кнопок
TabHolder.Padding = UDim.new(0, 5)
TabHolder.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabHolder.VerticalAlignment = Enum.VerticalAlignment.Top
TabHolder.FillDirection = Enum.FillDirection.Vertical
TabHolder.Parent = TabFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0.75, 0, 1, -30) -- 75% ширины, минус высота TitleBar
ContentFrame.Position = UDim2.new(0.25, 0, 0, 30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45) -- Такой же фон как у MainFrame
ContentFrame.BorderColor3 = Color3.fromRGB(50, 50, 60)
ContentFrame.BorderSizePixel = 1
ContentFrame.Parent = MainFrame

-- Функция для создания кнопки вкладки
local function createTabButton(name, parentFrame)
    local button = Instance.new("TextButton")
    button.Name = name .. "Tab"
    button.Size = UDim2.new(0.9, 0, 0, 30) -- Ширина 90% от родителя, высота 30px
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.BorderColor3 = Color3.fromRGB(55, 55, 65)
    button.BorderSizePixel = 1
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Text = name
    button.CornerRadius = UDim.new(0, 5)
    button.Parent = parentFrame

    -- Анимации наведения
    button.MouseEnter:Connect(function()
        TweenService:Create(button, tweenInfoButtonHover, {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, tweenInfoButtonLeave, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
    end)
    
    return button
end

-- Создаем примеры вкладок
local mainTab = createTabButton("Главная", TabFrame)
local settingsTab = createTabButton("Настройки", TabFrame)
local aboutTab = createTabButton("О нас", TabFrame)

-- Здесь можно добавить логику для переключения содержимого ContentFrame в зависимости от выбранной вкладки
-- Например, создайте отдельные фреймы для каждой вкладки внутри ContentFrame и управляйте их видимостью.

print("Elite UI Loaded!")
