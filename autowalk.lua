--// Services
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoWalkGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1

-- Shadow
local shadow = Instance.new("ImageLabel", frame)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ZIndex = 0

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Auto Walk"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(0, 200, 255) -- biru cerah
title.ZIndex = 2

-- Start Button
local startButton = Instance.new("TextButton", frame)
startButton.Size = UDim2.new(0.8, 0, 0, 40)
startButton.Position = UDim2.new(0.1, 0, 0.5, -20)
startButton.Text = "Start Walk"
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 20
startButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
startButton.TextColor3 = Color3.fromRGB(20, 20, 20)
startButton.AutoButtonColor = true
startButton.ZIndex = 2
startButton.BackgroundTransparency = 0.05
startButton.BorderSizePixel = 0

-- Hover effect
startButton.MouseEnter:Connect(function()
    startButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
startButton.MouseLeave:Connect(function()
    startButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    startButton.TextColor3 = Color3.fromRGB(20, 20, 20)
end)

--// Logic
local checkpointsFolder = workspace:FindFirstChild("Checkpoints")
if not checkpointsFolder then
    warn("❌ Tidak ada folder 'Checkpoints' di workspace!")
end

local checkpoints = checkpointsFolder and checkpointsFolder:GetChildren() or {}
table.sort(checkpoints, function(a, b)
    return tonumber(a.Name) < tonumber(b.Name)
end)

local function getChar()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hum, hrp
end

local function walkToCheckpoint(cp)
    local _, hum, hrp = getChar()
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 10,
        AgentMaxSlope = 45
    })

    path:ComputeAsync(hrp.Position, cp.Position)

    if path.Status == Enum.PathStatus.Complete then
        print("🚶 Menuju checkpoint:", cp.Name)
        for _, waypoint in ipairs(path:GetWaypoints()) do
            hum:MoveTo(waypoint.Position)
            hum.MoveToFinished:Wait()
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                hum.Jump = true
            end
        end
    else
        warn("❌ Path gagal dibuat ke checkpoint: " .. cp.Name)
    end
end

-- Start walk button
startButton.MouseButton1Click:Connect(function()
    task.spawn(function()
        for i, cp in ipairs(checkpoints) do
            walkToCheckpoint(cp)
        end
        print("✅ Semua checkpoint selesai!")
    end)
end)

-- Respawn handling
player.CharacterAdded:Connect(function()
    print("🔄 Respawn terdeteksi → jalankan lagi tombol start.")
end)
