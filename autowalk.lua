-- Anti duplicate
if getgenv().NazamHubLoaded then return end
getgenv().NazamHubLoaded = true

-- Services
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Config
local speed = 16
local jumpHeight = 50
local delayOnObstacle = 0.5

-- Checkpoints
local checkpointFolder = workspace:FindFirstChild("Checkpoints")
if not checkpointFolder then
    warn("Folder Checkpoints tidak ditemukan!")
    return
end

-- Urutkan checkpoints
local checkpoints = {}
for _, cp in ipairs(checkpointFolder:GetChildren()) do
    if cp.Name:match("^POS%d+$") then
        table.insert(checkpoints, cp)
    end
end
table.sort(checkpoints, function(a,b)
    return tonumber(a.Name:match("%d+")) < tonumber(b.Name:match("%d+"))
end)

-- Tentukan checkpoint saat ini
local currentCheckpointIndex = 1

--=====================--
-- GUI Setup
--=====================--
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Tween function
local function tweenTransparency(obj, target, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = target})
    tween:Play()
    tween.Completed:Wait()
end

-- Intro Frame
local introFrame = Instance.new("Frame", gui)
introFrame.Size = UDim2.new(1,0,1,0)
introFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local introText = Instance.new("TextLabel", introFrame)
introText.Size = UDim2.new(1,0,1,0)
introText.BackgroundTransparency = 1
introText.Text = "By Nazam"
introText.TextColor3 = Color3.fromRGB(0,200,255)
introText.Font = Enum.Font.GothamBold
introText.TextScaled = true
introText.TextTransparency = 1

-- Key Frame
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0,350,0,220)
keyFrame.Position = UDim2.new(0.5,-175,0.5,-110)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
keyFrame.Visible = false
keyFrame.Active = true
keyFrame.Draggable = true
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,12)
local keyStroke = Instance.new("UIStroke", keyFrame)
keyStroke.Color = Color3.fromRGB(0,200,255)
keyStroke.Thickness = 2

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,45)
keyBox.Position = UDim2.new(0.1,0,0.3,0)
keyBox.PlaceholderText = "Masukkan Key..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextScaled = true
keyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,8)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0.8,0,0,45)
keyBtn.Position = UDim2.new(0.1,0,0.65,0)
keyBtn.Text = "Lanjut"
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
keyBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,8)

-- Menu Frame
local menuFrame = Instance.new("Frame", gui)
menuFrame.Size = UDim2.new(0,360,0,260)
menuFrame.Position = UDim2.new(0.5,-180,0.5,-130)
menuFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0,12)
local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Color = Color3.fromRGB(0,200,255)
menuStroke.Thickness = 2

-- Menu Label
local menuLabel = Instance.new("TextLabel", menuFrame)
menuLabel.Size = UDim2.new(1,0,0,50)
menuLabel.Text = "Menu Utama"
menuLabel.BackgroundTransparency = 1
menuLabel.TextColor3 = Color3.fromRGB(255,255,255)
menuLabel.Font = Enum.Font.GothamBold
menuLabel.TextScaled = true

-- Close Button
local closeBtn = Instance.new("TextButton", menuFrame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

closeBtn.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
    reopenBtn.Visible = true
end)

-- Floating Reopen Button
local reopenBtn = Instance.new("TextButton", gui)
reopenBtn.Size = UDim2.new(0,100,0,30)
reopenBtn.Position = UDim2.new(0.5,-50,0,5)
reopenBtn.Text = "Open Menu"
reopenBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
reopenBtn.TextColor3 = Color3.fromRGB(255,255,255)
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.Visible = false
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0,6)

-- Key System
local KEY = "nazamganteng"
local keyEntered = false

keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        keyEntered = true
        keyFrame.Visible = false
        menuFrame.Visible = true
    else
        keyBox.Text = "❌ Key Salah!"
    end
end)

reopenBtn.MouseButton1Click:Connect(function()
    reopenBtn.Visible = false
    if keyEntered then
        menuFrame.Visible = true
    else
        keyFrame.Visible = true
    end
end)

-- Close menu when clicking outside
local function closeMenuWhenOutsideClick(frame)
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = frame.AbsolutePosition
            local absSize = frame.AbsoluteSize
            if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                    mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                frame.Visible = false
                reopenBtn.Visible = true
            end
        end
    end)
end
closeMenuWhenOutsideClick(menuFrame)
closeMenuWhenOutsideClick(keyFrame)

-- Intro Animation
task.spawn(function()
    tweenTransparency(introText, 0, 1)
    task.wait(1.2)
    tweenTransparency(introText, 1, 1)
    introFrame:Destroy()
    keyFrame.Visible = true
end)

--=====================--
-- Auto-Run Pathfinding
--=====================--
local function detectObstacle(distance)
    distance = distance or 5
    local rayOrigin = rootPart.Position + Vector3.new(0,2,0)
    local rayDirection = rootPart.CFrame.LookVector * distance
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    return Workspace:Raycast(ray
        --=====================--
-- Auto-Run Pathfinding (lanjutan)
--=====================--
local function moveToTarget(targetPosition)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = jumpHeight,
        AgentMaxSlope = 45
    })
    path:ComputeAsync(rootPart.Position, targetPosition)
    for _, wp in ipairs(path:GetWaypoints()) do
        local obstacle = detectObstacle()
        if obstacle then task.wait(delayOnObstacle) end
        humanoid:MoveTo(wp.Position)
        if wp.Action == Enum.PathWaypointAction.Jump then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        humanoid.MoveToFinished:Wait()
    end
end

-- Fungsi auto-run antar checkpoint
local function autoRunBetween(startIndex, endIndex)
    if startIndex ~= currentCheckpointIndex then
        warn("Tidak bisa mulai dari checkpoint ini. Harus sesuai urutan!")
        return
    end
    for i = startIndex, endIndex do
        local cp = checkpoints[i]
        moveToTarget(cp.Position)
        currentCheckpointIndex = i + 1
    end
    print("Sampai tujuan! Klik tombol selanjutnya untuk lanjut.")
end

-- Generate tombol otomatis sesuai urutan checkpoint
for i = 1, #checkpoints-1 do
    local btn = Instance.new("TextButton", menuFrame)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0.1 + 0.12*(i-1),0)
    btn.Text = checkpoints[i].Name .. " - " .. checkpoints[i+1].Name
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(0,200,255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        local startIndex = i
        local endIndex = i+1
        autoRunBetween(startIndex, endIndex)
    end)
end

