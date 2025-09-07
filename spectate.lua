-- Anti duplicate
if getgenv().SpecTeleportLoaded then return end
getgenv().SpecTeleportLoaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Spectate & Teleport"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 200, 255)

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    reopenBtn.Visible = true
end)

-- Floating reopen button
local reopenBtn = Instance.new("TextButton", gui)
reopenBtn.Size = UDim2.new(0,100,0,30)
reopenBtn.Position = UDim2.new(0.5,-50,0,5)
reopenBtn.Text = "Open Menu"
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.TextColor3 = Color3.fromRGB(255,255,255)
reopenBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0,6)
reopenBtn.Visible = false
reopenBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    reopenBtn.Visible = false
end)

-- Player List Frame
local listFrame = Instance.new("ScrollingFrame", frame)
listFrame.Size = UDim2.new(1, -20, 1, -50)
listFrame.Position = UDim2.new(0, 10, 0, 45)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 6
listFrame.CanvasSize = UDim2.new(0,0,0,0)

-- UIListLayout
local layout = Instance.new("UIListLayout", listFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

-- Variables
local currentSpectateTarget = nil
local isSpectating = false

-- Function to update player list
local function refreshPlayerList()
    listFrame:ClearAllChildren()
    listFrame.CanvasSize = UDim2.new(0,0,0,0)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton", listFrame)
            btn.Size = UDim2.new(1,0,0,30)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
            
            btn.MouseButton1Click:Connect(function()
                currentSpectateTarget = plr
                isSpectating = true
            end)
        end
    end
    task.wait(0.1)
    listFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end

-- Refresh player list on join/leave
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- Teleport Button
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(0.8,0,0,35)
tpBtn.Position = UDim2.new(0.1,0,0.85,0)
tpBtn.Text = "Teleport to Target"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,6)

tpBtn.MouseButton1Click:Connect(function()
    if currentSpectateTarget and currentSpectateTarget.Character and currentSpectateTarget.Character:FindFirstChild("HumanoidRootPart") then
        humanoidRootPart.CFrame = currentSpectateTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    else
        warn("Target tidak valid!")
    end
end)

-- Spectate loop
RunService.RenderStepped:Connect(function()
    if isSpectating and currentSpectateTarget and currentSpectateTarget.Character and currentSpectateTarget.Character:FindFirstChild("HumanoidRootPart") then
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = currentSpectateTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0,5,10)
    else
        camera.CameraType = Enum.CameraType.Custom
    end
end)
