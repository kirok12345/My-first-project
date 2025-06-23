-- LocalScript (внутри StarterPlayerScripts)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ImmortalityMenu"

-- Создание кнопки для активации бессмертия
local immortalityButton = Instance.new("TextButton")
immortalityButton.Parent = screenGui
immortalityButton.Size = UDim2.new(0, 200, 0, 50)
immortalityButton.Position = UDim2.new(0.5, -100, 0.8, -25)
immortalityButton.Text = "Включить бессмертие"
immortalityButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

local immortalityEnabled = false

-- Функция для активации/деактивации бессмертия
local function toggleImmortality()
    immortalityEnabled = not immortalityEnabled

    if immortalityEnabled then
        immortalityButton.Text = "Выключить бессмертие"
        -- Оповещаем сервер о включении бессмертия
        game.ReplicatedStorage.ImmortalityStatus:FireServer(true)
    else
        immortalityButton.Text = "Включить бессмертие"
        -- Оповещаем сервер о выключении бессмертия
        game.ReplicatedStorage.ImmortalityStatus:FireServer(false)
    end
end

-- Подключаемся к событию нажатия кнопки
immortalityButton.MouseButton1Click:Connect(toggleImmortality)
