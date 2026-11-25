
-- NINJA DEMON MTN
-- Pour ton propre jeu Roblox Studio
-- StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NinjaDemonMTN"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local WHITE = Color3.new(1,1,1)
local BLACK = Color3.new(0,0,0)
local RED = Color3.fromRGB(255,0,0)

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius)
    c.Parent = obj
end

local function outline(obj)
    local s = Instance.new("UIStroke")
    s.Color = WHITE
    s.Thickness = 1
    s.Parent = obj
end

-- MENU
local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(270,390)
menu.Position = UDim2.new(0.5,-135,0.5,-195)
menu.BackgroundColor3 = BLACK
menu.Parent = gui
round(menu,12)
outline(menu)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "NINJA DEMON"
title.TextColor3 = WHITE
title.Font = Enum.Font.GothamBlack
title.TextSize = 19
title.Parent = menu

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-12,0,22)
status.Position = UDim2.fromOffset(6,358)
status.BackgroundTransparency = 1
status.Text = "READY"
status.TextColor3 = WHITE
status.TextSize = 10
status.Font = Enum.Font.Gotham
status.Parent = menu

local function makeBox(placeholder,y)
    local b = Instance.new("TextBox")
    b.Size = UDim2.fromOffset(130,27)
    b.Position = UDim2.fromOffset(126,y)
    b.BackgroundColor3 = BLACK
    b.TextColor3 = WHITE
    b.PlaceholderColor3 = WHITE
    b.PlaceholderText = placeholder
    b.Text = ""
    b.TextSize = 12
    b.Font = Enum.Font.Gotham
    b.ClearTextOnFocus = false
    b.Parent = menu
    round(b,6)
    outline(b)
    return b
end

local function makeLabel(text,y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.fromOffset(110,27)
    l.Position = UDim2.fromOffset(12,y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = WHITE
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = menu
end

local function makeButton(text,y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-30,0,27)
    b.Position = UDim2.fromOffset(15,y)
    b.BackgroundColor3 = BLACK
    b.TextColor3 = WHITE
    b.Text = text
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = menu
    round(b,6)
    outline(b)
    return b
end

-- WALKSPEED
makeLabel("WalkSpeed",42)
local speedBox = makeBox("Valeur",42)

speedBox.FocusLost:Connect(function()
    local value = tonumber(speedBox.Text)
    local hum = player.Character and
        player.Character:FindFirstChildOfClass("Humanoid")

    if value and hum then
        hum.WalkSpeed = math.clamp(value,0,100)
        status.Text = "WALKSPEED : "..value
    else
        status.Text = "VALEUR INVALIDE"
    end
end)

-- POWER JUMP
makeLabel("PowerJump",76)
local jumpBox = makeBox("Valeur",76)

jumpBox.FocusLost:Connect(function()
    local value = tonumber(jumpBox.Text)
    local hum = player.Character and
        player.Character:FindFirstChildOfClass("Humanoid")

    if value and hum then
        hum.UseJumpPower = true
        hum.JumpPower = math.clamp(value,0,200)
        status.Text = "JUMP : "..value
    else
        status.Text = "VALEUR INVALIDE"
    end
end)

-- TELEPORTATION
makeLabel("TP Player",110)
local playerBox = makeBox("Pseudo",110)
local tpButton = makeButton("TP SET PLAYER",145)

tpButton.Activated:Connect(function()
    local search = string.lower(playerBox.Text)
    local target

    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player and
        string.sub(string.lower(p.Name),1,#search) == search
        and search ~= "" then
            if target then
                status.Text = "PSEUDO IMPRECIS"
                return
            end
            target = p
        end
    end

    local root = player.Character and
        player.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = target and target.Character and
        target.Character:FindFirstChild("HumanoidRootPart")

    if root and targetRoot then
        root.CFrame = targetRoot.CFrame * CFrame.new(0,0,3)
        status.Text = "TP : "..target.Name
    else
        status.Text = "JOUEUR INTROUVABLE"
    end
end)

-- ESP TOUS LES JOUEURS
local espOn = false
local espObjects = {}
local espConnections = {}

local function clearESP(p)
    local objects = espObjects[p]
    if objects then
        for _,obj in ipairs(objects) do
            obj:Destroy()
        end
        espObjects[p] = nil
    end
end

local function addESP(p)
    clearESP(p)
    if not espOn or p == player then return end

    local char = p.Character
    local head = char and char:FindFirstChild("Head")
    if not char or not head then return end

    local h = Instance.new("Highlight")
    h.Adornee = char
    h.FillColor = RED
    h.FillTransparency = 0.78
    h.OutlineColor = RED
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = gui

    local tag = Instance.new("BillboardGui")
    tag.Adornee = head
    tag.Size = UDim2.fromOffset(100,18)
    tag.StudsOffset = Vector3.new(0,2.4,0)
    tag.AlwaysOnTop = true
    tag.Parent = gui

    local name = Instance.new("TextLabel")
    name.Size = UDim2.fromScale(1,1)
    name.BackgroundTransparency = 1
    name.Text = p.Name
    name.TextColor3 = WHITE
    name.TextStrokeTransparency = 0
    name.TextSize = 10
    name.Font = Enum.Font.GothamBold
    name.Parent = tag

    espObjects[p] = {h,tag}
end

local function watchPlayer(p)
    if p == player then return end

    if espConnections[p] then
        espConnections[p]:Disconnect()
    end

    espConnections[p] = p.CharacterAdded:Connect(function()
        task.wait(1)
        if espOn then addESP(p) end
    end)

    if espOn then addESP(p) end
end

local espButton = makeButton("ESP OFF",180)

espButton.Activated:Connect(function()
    espOn = not espOn

    if espOn then
        espButton.Text = "ESP ON"
        status.Text = "ESP : TOUS LES JOUEURS"

        for _,p in ipairs(Players:GetPlayers()) do
            watchPlayer(p)
        end
    else
        espButton.Text = "ESP OFF"

        for p in pairs(espObjects) do
            clearESP(p)
        end

        for p,c in pairs(espConnections) do
            c:Disconnect()
            espConnections[p] = nil
        end

        status.Text = "ESP DESACTIVE"
    end
end)

Players.PlayerAdded:Connect(watchPlayer)

Players.PlayerRemoving:Connect(function(p)
    clearESP(p)
    if espConnections[p] then
        espConnections[p]:Disconnect()
        espConnections[p] = nil
    end
end)

-- NOCLIP
local noclipOn = false
local oldCollision = {}
local noclipConnection

local noclipButton = makeButton("NOCLIP OFF",215)

local function restoreCollision()
    for part,value in pairs(oldCollision) do
        if part and part.Parent then
            part.CanCollide = value
        end
    end
    table.clear(oldCollision)
end

noclipButton.Activated:Connect(function()
    noclipOn = not noclipOn

    if noclipOn then
        noclipButton.Text = "NOCLIP ON"

        noclipConnection = RunService.Stepped:Connect(function()
            local char = player.Character
            if not char then return end

            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if oldCollision[part] == nil then
                        oldCollision[part] = part.CanCollide
                    end
                    part.CanCollide = false
                end
            end
        end)
    else
        noclipButton.Text = "NOCLIP OFF"
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        restoreCollision()
    end
end)

-- INFINITE JUMP
local infiniteJump = false
local jumpButton = makeButton("INF JUMP OFF",250)

jumpButton.Activated:Connect(function()
    infiniteJump = not infiniteJump
    jumpButton.Text = infiniteJump and "INF JUMP ON" or "INF JUMP OFF"
end)

UIS.JumpRequest:Connect(function()
    if not infiniteJump then return end

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- FERMER
local closeButton = makeButton("FERMER",285)
closeButton.Activated:Connect(function()
    menu.Visible = false
end)

-- BOUTON FLOTTANT ND
local floating = Instance.new("TextButton")
floating.Size = UDim2.fromOffset(42,42)
floating.Position = UDim2.new(0,15,0.65,0)
floating.BackgroundColor3 = BLACK
floating.Text = "ND"
floating.TextColor3 = WHITE
floating.Font = Enum.Font.GothamBlack
floating.TextSize = 16
floating.Parent = gui
round(floating,50)
outline(floating)

-- BOUTON DEPLACABLE
local dragging = false
local moved = false
local dragStart
local startPosition
local activeInput

floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        moved = false
        dragStart = input.Position
        startPosition = floating.Position
        activeInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and
    (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart
        if delta.Magnitude > 6 then moved = true end

        floating.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == activeInput then
        dragging = false
        activeInput = nil
    end
end)

floating.Activated:Connect(function()
    if not moved then
        menu.Visible = not menu.Visible
    end
end)

-- NETTOYAGE AU CHANGEMENT DE PERSONNAGE
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if noclipOn then
        restoreCollision()
    end
end)

print("NINJA DEMON MTN READY")
