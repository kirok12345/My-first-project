-- Это локальный скрипт, он должен находиться в StarterPlayerScripts или StarterGui
-- Локальные скрипты выполняются на клиенте (компьютере игрока)

-- Создаем ScreenGui, который будет содержать все наши элементы GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalGUI"
screenGui.Parent = game.Players.LocalPlayer.PlayerGui
screenGui.ResetOnSpawn = false -- Важно: GUI не будет исчезать при смерти/возрождении игрока

-- Создаем основную рамку (Frame) для нашего окна GUI
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 300, 0, 250) -- Фиксированный размер 300x250 пикселей
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125) -- Центрируем по экрану (0.5 - половина, а -150/-125 - смещение на половину ширины/высоты для точного центрирования)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Темно-серый фон
mainFrame.BorderColor3 = Color3.fromRGB(70, 70, 70) -- Более светлая рамка
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

-- Создаем верхнюю панель для перетаскивания и заголовка
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30) -- 100% ширины родителя, высота 30 пикселей
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Чуть светлее, чем основной фон
titleBar.Parent = mainFrame

-- Добавляем текст заголовка
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleLabel.BackgroundTransparency = 1 -- Прозрачный фон, чтобы видеть фон TitleBar
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст
titleLabel.Text = "Мое крутое GUI"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextScaled = false -- Не масштабируем, чтобы размер был фиксированным
titleLabel.Parent = titleBar

-- Логика перетаскивания окна GUI
local dragging = false
local dragStart = Vector2.new(0, 0)
local initialPosition = UDim2.new(0, 0, 0, 0)

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        initialPosition = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(initialPosition.X.Scale, initialPosition.X.Offset + delta.X,
                                        initialPosition.Y.Scale, initialPosition.Y.Offset + delta.Y)
    end
end)


-- Добавляем метку для отображения вводимого текста
local displayLabel = Instance.new("TextLabel")
displayLabel.Name = "DisplayLabel"
displayLabel.Size = UDim2.new(0.9, 0, 0, 40) -- Ширина 90%, высота 40 пикселей
displayLabel.Position = UDim2.new(0.05, 0, 0, 40) -- Отступ 5% от левого края, 40 пикселей от верха рамки
displayLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
displayLabel.TextColor3 = Color3.fromRGB(200, 200, 200) -- Светло-серый текст
displayLabel.Text = "Привет, мир!"
displayLabel.Font = Enum.Font.SourceSans
displayLabel.TextSize = 18
displayLabel.TextWrapped = true
displayLabel.TextXAlignment = Enum.TextXAlignment.Center -- Выравнивание текста по центру
displayLabel.TextYAlignment = Enum.TextYAlignment.Center -- Выравнивание текста по центру
displayLabel.Parent = mainFrame

-- Добавляем текстовое поле для ввода
local inputTextBox = Instance.new("TextBox")
inputTextBox.Name = "InputBox"
inputTextBox.Size = UDim2.new(0.9, 0, 0, 30)
inputTextBox.Position = UDim2.new(0.05, 0, 0, 90) -- Ниже метки
inputTextBox.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
inputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputTextBox.PlaceholderText = "Введи что-нибудь здесь..."
inputTextBox.Text = ""
inputTextBox.Font = Enum.Font.SourceSans
inputTextBox.TextSize = 16
inputTextBox.TextXAlignment = Enum.TextXAlignment.Left -- Выравнивание текста по левому краю
inputTextBox.Parent = mainFrame

-- Добавляем кнопку для обновления текста и изменения цвета
local updateButton = Instance.new("TextButton")
updateButton.Name = "UpdateButton"
updateButton.Size = UDim2.new(0.4, 0, 0, 30) -- Ширина 40%, высота 30 пикселей
updateButton.Position = UDim2.new(0.05, 0, 0, 130) -- Ниже текстового поля
updateButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215) -- Синяя кнопка
updateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
updateButton.Text = "Обновить текст"
updateButton.Font = Enum.Font.SourceSansBold
updateButton.TextSize = 18
updateButton.Parent = mainFrame

-- Добавляем ползунок (Slider) для изменения прозрачности
local transparencySlider = Instance.new("TextButton") -- Используем TextButton как основу для слайдера
transparencySlider.Name = "TransparencySlider"
transparencySlider.Size = UDim2.new(0.9, 0, 0, 20)
transparencySlider.Position = UDim2.new(0.05, 0, 0, 180) -- Ниже кнопки
transparencySlider.BackgroundColor3 = Color3.fromRGB(90, 90, 90) -- Цвет трека слайдера
transparencySlider.Text = "" -- Без текста
transparencySlider.Parent = mainFrame

local sliderHandle = Instance.new("Frame") -- Ручка ползунка
sliderHandle.Name = "SliderHandle"
sliderHandle.Size = UDim2.new(0, 10, 1, 0) -- Ширина 10 пикселей, высота 100% от родителя
sliderHandle.Position = UDim2.new(0, 0, 0, 0) -- Изначально слева
sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 180, 255) -- Голубой цвет ручки
sliderHandle.Parent = transparencySlider

local isDraggingSlider = false
local minX = 0
local maxX = transparencySlider.AbsoluteSize.X - sliderHandle.AbsoluteSize.X

sliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingSlider = true
    end
end)

sliderHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingSlider = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDraggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouseX = input.Position.X
        local sliderX = transparencySlider.AbsolutePosition.X
        local newX = math.clamp(mouseX - sliderX - sliderHandle.Size.X.Offset / 2, minX, maxX)

        sliderHandle.Position = UDim2.new(0, newX, 0, 0)

        -- Вычисляем прозрачность на основе положения ручки
        local transparency = newX / maxX
        mainFrame.BackgroundTransparency = transparency
        titleBar.BackgroundTransparency = transparency
        displayLabel.BackgroundTransparency = transparency
        inputTextBox.BackgroundTransparency = transparency
        updateButton.BackgroundTransparency = transparency
        transparencySlider.BackgroundTransparency = transparency
        sliderHandle.BackgroundTransparency = transparency
    end
end)


-- Функционал кнопки
local currentTextColorIndex = 1
local textColors = {
    Color3.fromRGB(255, 255, 255), -- Белый
    Color3.fromRGB(255, 0, 0),     -- Красный
    Color3.fromRGB(0, 255, 0),     -- Зеленый
    Color3.fromRGB(0, 0, 255)      -- Синий
}

updateButton.MouseButton1Click:Connect(function()
    -- Обновляем текст метки на основе введенного в текстовое поле
    if inputTextBox.Text ~= "" then
        displayLabel.Text = "Введено: " .. inputTextBox.Text
    else
        displayLabel.Text = "Пожалуйста, введите текст!"
    end

    -- Изменяем цвет текста метки по кругу
    currentTextColorIndex = currentTextColorIndex + 1
    if currentTextColorIndex > #textColors then
        currentTextColorIndex = 1
    end
    displayLabel.TextColor3 = textColors[currentTextColorIndex]
end)
