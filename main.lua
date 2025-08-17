-- LocalScript — Invisibilidade com botão

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Criar GUI mínima
local gui = Instance.new("ScreenGui")
gui.Name = "InvisibleToggleGui"
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Text = "Invisible: OFF"
button.Parent = gui

-- Estado invisível
local invisible = false

-- Função para atualizar transparência
local function updateInvisibility()
    local char = player.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = invisible and 1 or 0
            part.CanCollide = not invisible  -- opcional: atravessar objetos
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = invisible and 1 or 0
        elseif part:IsA("Accessory") then
            if part:FindFirstChild("Handle") then
                part.Handle.Transparency = invisible and 1 or 0
            end
        end
    end
end

-- Botão alterna invisibilidade
button.MouseButton1Click:Connect(function()
    invisible = not invisible
    button.Text = invisible and "Invisible: ON" or "Invisible: OFF"
    updateInvisibility()
end)

-- Mantém invisível ao renascer
player.CharacterAdded:Connect(function()
    task.wait(0.1)
    if invisible then
        updateInvisibility()
    end
end)
