-- Anti duplicate
if getgenv().NazamHubLoaded then return end
getgenv().NazamHubLoaded = true

-- Services
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Config Auto-Run
local speed = 16
local jumpHeight = 50
local checkpointFolder = workspace:FindFirstChild("Checkpoints")
local delayOnObstacle = 0.5

--=====================--
-- GUI SETUP
--=====================--
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function tweenTransparency(obj, target, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = target})
    tween:Play()
    tween.Completed:Wait()
end

-- Intro
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
keyFrame.Size = UDim2.new(0,400,0,250)
keyFrame.Position = UDim2.new(0.5,-200,0.5,-125)
keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
keyFrame.Visible = false
keyFrame.Active = true
keyFrame.Draggable = true
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,15)
local keyStroke = Instance.new("UIStroke", keyFrame)
keyStroke.Color = Color3.fromRGB(0,200,255)
keyStroke.Thickness = 2

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,50)
keyBox.Position = UDim2.new(0.1,0,0.3,0)
keyBox.PlaceholderText = "Masukkan Key..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextScaled = true
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,8)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0.8,0,0,50)
keyBtn.Position = UDim2.new(0.1,0,0.65,0)
keyBtn.Text = "Lanjut"
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
keyBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,8)

-- Menu Frame
local menuFrame = Instance.new("Frame", gui)
menuFrame.Size = UDim2.new(0,400,0,300)
menuFrame.Position = UDim2.new(0.5,-200,0.5,-150)
menuFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0,15)
local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Color = Color3.fromRGB(0,200,255)
menuStroke.Thickness = 2

local menuLabel = Instance.new("TextLabel", menuFrame)
menuLabel.Size = UDim2.new(1,0,0,60)
menuLabel.Text = "Menu Utama"
menuLabel.BackgroundTransparency = 1
menuLabel.TextColor3 = Color3.fromRGB(255,255,255)
menuLabel.Font = Enum.Font.GothamBold
menuLabel.TextScaled = true

local startBtn = Instance.new("TextButton", menuFrame)
startBtn.Size = UDim2.new(0.8,0,0,50)
startBtn.Position = UDim2.new(0.1,0,0.7,0)
startBtn.Text = "Start Walk"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextScaled = true
startBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
startBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,8)

local reopenBtn = Instance.new("TextButton", gui)
reopenBtn.Size = UDim2.new(0,120,0,30)
reopenBtn.Position = UDim2.new(0.5,-60,0,5)
reopenBtn.Text = "Open Menu"
reopenBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
reopenBtn.TextColor3 = Color3.fromRGB(255,255,255)
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.Visible = false
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0,6)

-- Key system
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

-- Close menu click luar
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

-- Intro animation
task.spawn(function()
    tweenTransparency(introText, 0, 1)
    task.wait(1.5)
    tweenTransparency(introText, 1, 1)
    introFrame:Destroy()
    keyFrame.Visible = true
end)

-- Auto-run functions
local function detectObstacle(distance)
    distance = distance or 5
    local rayOrigin = rootPart.Position + Vector3.new(0,2,0)
    local rayDirection = rootPart.CFrame.LookVector * distance
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    return Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
end

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
        if wp.Action == Enum.PathWaypointAction.Jump then
            if detectObstacle() then task.wait(delayOnObstacle) end
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        humanoid:MoveTo(wp.Position)
        humanoid.MoveToFinished:Wait()
    end
end

local function autoRunCheckpoints()
    if not checkpointFolder then return end
    local checkpoints = {}
    for _, cp in ipairs(checkpointFolder:GetChildren()) do table.insert(checkpoints, cp) end
    table.sort(checkpoints, function(a,b) return a.Name < b.Name end)
    for _, cp in ipairs(checkpoints) do
        moveToTarget(cp.Position)
        task.wait(0.2)
    end
end

startBtn.MouseButton1Click:Connect(function()
    autoRunCheckpoints()
end)
