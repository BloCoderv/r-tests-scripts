-- LocalScript — Painel + Click Teleport (tudo em um)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- ========= GUI / Painel =========
local gui = Instance.new("ScreenGui")
gui.Name = "PlayerPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 360)
frame.Position = UDim2.new(0.5, -130, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 15)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = frame

-- Helper p/ campos numéricos
local function createPropertyControl(name, default, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -10, 0, 30)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.Text = name
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.6, -20, 0, 30)
    box.Position = UDim2.new(0.4, 10, 0, posY)
    box.Text = tostring(default)
    box.TextScaled = true
    box.ClearTextOnFocus = false
    box.BackgroundColor3 = Color3.fromRGB(50,50,50)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Parent = frame

    return box
end

-- Campos básicos
local walkBox = createPropertyControl("Speed", 16, 10)
local jumpBox = createPropertyControl("Jump", 50, 50)
local hipBox  = createPropertyControl("HipHeight", 2, 90)
local gravBox = createPropertyControl("Gravity", 196, 130)
local fovBox  = createPropertyControl("FOV", 70, 170)

-- Botões
local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(1, -20, 0, 30)
applyButton.Position = UDim2.new(0, 10, 0, 210)
applyButton.Text = "Aplicar Configurações"
applyButton.TextScaled = true
applyButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
applyButton.TextColor3 = Color3.fromRGB(255,255,255)
applyButton.Parent = frame

local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(1, -20, 0, 30)
resetButton.Position = UDim2.new(0, 10, 0, 250)
resetButton.Text = "Resetar Valores"
resetButton.TextScaled = true
resetButton.BackgroundColor3 = Color3.fromRGB(100,50,150)
resetButton.TextColor3 = Color3.fromRGB(255,255,255)
resetButton.Parent = frame

local respawnButton = Instance.new("TextButton")
respawnButton.Size = UDim2.new(1, -20, 0, 30)
respawnButton.Position = UDim2.new(0, 10, 0, 290)
respawnButton.Text = "Respawn"
respawnButton.TextScaled = true
respawnButton.BackgroundColor3 = Color3.fromRGB(50,120,200)
respawnButton.TextColor3 = Color3.fromRGB(255,255,255)
respawnButton.Parent = frame

local godButton = Instance.new("TextButton")
godButton.Size = UDim2.new(0.5, -15, 0, 30)
godButton.Position = UDim2.new(0, 10, 0, 330)
godButton.Text = "GodMode: OFF"
godButton.TextScaled = true
godButton.BackgroundColor3 = Color3.fromRGB(200,100,50)
godButton.TextColor3 = Color3.fromRGB(255,255,255)
godButton.Parent = frame

local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.5, -15, 0, 30)
noclipButton.Position = UDim2.new(0.5, 5, 0, 330)
noclipButton.Text = "Noclip: OFF"
noclipButton.TextScaled = true
noclipButton.BackgroundColor3 = Color3.fromRGB(50,200,100)
noclipButton.TextColor3 = Color3.fromRGB(255,255,255)
noclipButton.Parent = frame

-- Estados
local godMode = false
local noclip = false

-- Aplicar/Reset
local function applySettings()
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local speed = tonumber(walkBox.Text)
        local jump  = tonumber(jumpBox.Text)
        local hip   = tonumber(hipBox.Text)
        local grav  = tonumber(gravBox.Text)
        local fov   = tonumber(fovBox.Text)
        if speed then humanoid.WalkSpeed = speed end
        if jump  then humanoid.JumpPower = jump end
        if hip   then humanoid.HipHeight = hip end
        if grav  then Workspace.Gravity = grav end
        if fov and Workspace.CurrentCamera then
            Workspace.CurrentCamera.FieldOfView = fov
        end
    end
end

local function resetSettings()
    walkBox.Text, jumpBox.Text, hipBox.Text, gravBox.Text, fovBox.Text =
        "16", "50", "2", "196", "70"
    applySettings()
end

applyButton.MouseButton1Click:Connect(applySettings)
resetButton.MouseButton1Click:Connect(resetSettings)
respawnButton.MouseButton1Click:Connect(function()
    player:LoadCharacter()
end)

godButton.MouseButton1Click:Connect(function()
    godMode = not godMode
    godButton.Text = godMode and "GodMode: ON" or "GodMode: OFF"
end)

noclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipButton.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

closeButton.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- Loop GodMode + Noclip
RunService.Stepped:Connect(function()
    local char = Players.LocalPlayer.Character
    if not char then return end

    if godMode then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end

    if noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Tecla para abrir/fechar GUI
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- ========= Tool: Click Teleport =========
local function ensureTeleportTool()
    local backpack = player:WaitForChild("Backpack")

    -- Evitar duplicar a ferramenta
    local existing = backpack:FindFirstChild("Click Teleport")
        or (player.Character and player.Character:FindFirstChild("Click Teleport"))
    if existing then existing:Destroy() end

    local teleportTool = Instance.new("Tool")
    teleportTool.Name = "Click Teleport"
    teleportTool.RequiresHandle = false
    teleportTool.CanBeDropped = false
    teleportTool.Parent = backpack

    local mouse = player:GetMouse()
    teleportTool.Activated:Connect(function()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local hitCF = mouse.Hit
        if not hitCF then return end
        local targetPos = hitCF.Position

        -- Raycast para "assentar" no chão e evitar cair/bugar
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}

        local origin = targetPos + Vector3.new(0, 150, 0)
        local result = Workspace:Raycast(origin, Vector3.new(0, -1000, 0), params)

        local finalPos
        if result then
            finalPos = result.Position + Vector3.new(0, 3, 0)
        else
            -- Se não achou chão, tenta mesmo assim com offset
            finalPos = targetPos + Vector3.new(0, 3, 0)
        end

        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(finalPos, finalPos + Workspace.CurrentCamera.CFrame.LookVector)
    end)
end

-- Criar a Tool agora e sempre que renascer
ensureTeleportTool()
player.CharacterAdded:Connect(function()
    task.wait(0.25)
    ensureTeleportTool()
    applySettings()
end)
