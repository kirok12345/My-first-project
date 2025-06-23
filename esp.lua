-- Это локальный скрипт, он должен находиться в StarterPlayerScripts или StarterGui
-- Локальные скрипты выполняются на клиенте (компьютере игрока)

-- Создаем ScreenGui, который будет содержать все наши элементы GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyAwesomeGUI"
screenGui.Parent = game.Players.LocalPlayer.PlayerGui -- Привязываем GUI к игроку

-- Создаем Frame (рамку) для группировки элементов
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.3, 0, 0.4, 0) -- Размер: 30% ширины экрана, 40% высоты экрана
mainFrame.Position = UDim2.new(0.35, 0, 0.3, 0) -- Позиция: 35% от левого края, 30% от верхнего края
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Темно-серый фон
mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0) -- Черная рамка
mainFrame.BorderSizePixel = 2
mainFrame.Active = true -- Делаем рамку активной, чтобы можно было перетаскивать (не реализовано в этом примере)
mainFrame.Draggable = true -- Делаем рамку перетаскиваемой (не реализовано в этом примере)
mainFrame.Parent = screenGui

-- Создаем TextLabel (метку) для отображения текста
local myLabel = Instance.new("TextLabel")
myLabel.Name = "InfoLabel"
myLabel.Size = UDim2.new(0.9, 0, 0.2, 0) -- Размер: 90% ширины родителя, 20% высоты родителя
myLabel.Position = UDim2.new(0.05, 0, 0.1, 0) -- Позиция: 5% от левого края родителя, 10% от верхнего края родителя
myLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Серый фон
myLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст
myLabel.Text = "Привет, введи что-нибудь!" -- Изначальный текст
myLabel.Font = Enum.Font.SourceSansBold
myLabel.TextSize = 24
myLabel.TextScaled = true -- Автоматически подстраивать размер текста под размер метки
myLabel.TextWrapped = true -- Переносить текст по словам
myLabel.Parent = mainFrame

-- Создаем TextBox (текстовое поле) для ввода текста
local myTextBox = Instance.new("TextBox")
myTextBox.Name = "InputField"
myTextBox.Size = UDim2.new(0.9, 0, 0.15, 0)
myTextBox.Position = UDim2.new(0.05, 0, 0.4, 0)
myTextBox.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
myTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
myTextBox.PlaceholderText = "Введи текст здесь..." -- Подсказка в поле ввода
myTextBox.Text = "" -- Изначально пустое
myTextBox.Font = Enum.Font.SourceSans
myTextBox.TextSize = 20
myTextBox.TextScaled = true
myTextBox.TextWrapped = true
myTextBox.Parent = mainFrame

-- Создаем TextButton (кнопку) для выполнения действия
local myButton = Instance.new("TextButton")
myButton.Name = "ActionButton"
myButton.Size = UDim2.new(0.6, 0, 0.15, 0)
myButton.Position = UDim2.new(0.2, 0, 0.7, 0) -- Центруем кнопку по горизонтали в рамках
myButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Синий цвет кнопки
myButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст
myButton.Text = "Обновить текст"
myButton.Font = Enum.Font.SourceSansBold
myButton.TextSize = 24
myButton.TextScaled = true
myButton.Parent = mainFrame

-- Подключаем функцию к событию нажатия кнопки
myButton.MouseButton1Click:Connect(function()
    -- Когда кнопка нажата, берем текст из TextBox и обновляем TextLabel
    myLabel.Text = myTextBox.Text
end)

-- Это для того, чтобы GUI не исчезал при возрождении игрока
screenGui.ResetOnSpawn = false
