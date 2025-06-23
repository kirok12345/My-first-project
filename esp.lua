-- ServerScript (внутри ServerScriptService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local immortalityStatusEvent = Instance.new("RemoteEvent")
immortalityStatusEvent.Name = "ImmortalityStatus"
immortalityStatusEvent.Parent = ReplicatedStorage

-- Таблица для отслеживания бессмертия игроков
local immortalityPlayers = {}

-- Функция для включения/выключения бессмертия
local function onImmortalityStatusChanged(player, isImmortal)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    if isImmortal then
        -- Включаем бессмертие
        immortalityPlayers[player.UserId] = true
        -- Периодически восстанавливаем здоровье до максимума
        spawn(function()
            while immortalityPlayers[player.UserId] do
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
                wait(1)  -- проверяем каждую секунду
            end
        end)
    else
        -- Выключаем бессмертие
        immortalityPlayers[player.UserId] = false
    end
end

-- Защита от манипуляций
game:GetService("Players").PlayerAdded:Connect(function(player)
    -- Когда новый игрок появляется, устанавливаем его бессмертие в выключенное состояние
    immortalityPlayers[player.UserId] = false
end)

-- Обработка события от клиента
immortalityStatusEvent.OnServerEvent:Connect(function(player, isImmortal)
    -- Проверяем, что игрок не пытается манипулировать
    if player and player.Character and player:FindFirstChild("Humanoid") then
        onImmortalityStatusChanged(player, isImmortal)
    end
end)
