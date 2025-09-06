
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frameIntro = Instance.new("Frame")
frameIntro.Size = UDim2.new(0, 300, 0, 150)
frameIntro.Position = UDim2.new(0.5, -150, 0.5, -75)
frameIntro.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frameIntro.Parent = gui

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(1, 0, 1, 0)
introText.Text = "Selamat datang!"
introText.TextColor3 = Color3.fromRGB(255,255,255)
introText.BackgroundTransparency = 1
introText.Parent = frameIntro

local frameKey = Instance.new("Frame")
frameKey.Size = UDim2.new(0, 300, 0, 150)
frameKey.Position = UDim2.new(0.5, -150, 0.5, -75)
frameKey.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
frameKey.Visible = false
frameKey.Parent = gui

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -20, 0, 30)
keyBox.Position = UDim2.new(0, 10, 0, 40)
keyBox.PlaceholderText = "Masukkan key..."
keyBox.Parent = frameKey

local lanjutButton = Instance.new("TextButton")
lanjutButton.Size = UDim2.new(0, 100, 0, 30)
lanjutButton.Position = UDim2.new(0.5, -50, 1, -40)
lanjutButton.Text = "Lanjut"
lanjutButton.Parent = frameKey

local frameMenu = Instance.new("Frame")
frameMenu.Size = UDim2.new(0, 300, 0, 150)
frameMenu.Position = UDim2.new(0.5, -150, 0.5, -75)
frameMenu.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
frameMenu.Visible = false
frameMenu.Parent = gui

local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0, 120, 0, 40)
startButton.Position = UDim2.new(0.5, -60, 0.5, -20)
startButton.Text = "Start Walk"
startButton.Parent = frameMenu

local KEY = "nazamganteng"
task.delay(2, function()
    frameIntro.Visible = false
    frameKey.Visible = true
end)
lanjutButton.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        frameKey.Visible = false
        frameMenu.Visible = true
    else
        keyBox.Text = "Key salah!"
    end
end)


local PathfindingService = game:GetService("PathfindingService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local checkpointsFolder = workspace:WaitForChild("Checkpoints")
local checkpoints = checkpointsFolder:GetChildren()
table.sort(checkpoints, function(a, b) return tonumber(a.Name) < tonumber(b.Name) end)

local currentCheckpoint = 1
local walking = false

local function walkToCheckpoint(cp)
    if not cp or walking then return end
    walking = true

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 10,
        AgentMaxSlope = 45
    })

    path:ComputeAsync(hrp.Position, cp.Position)

    if path.Status == Enum.PathStatus.Complete then
        for _, waypoint in ipairs(path:GetWaypoints()) do
            hum:MoveTo(waypoint.Position)
            hum.MoveToFinished:Wait()
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                hum.Jump = true
            end
        end
    else
        warn("Path gagal dibuat ke checkpoint: " .. cp.Name)
    end

    walking = false
end

startButton.MouseButton1Click:Connect(function()
    if not walking and currentCheckpoint <= #checkpoints then
        walkToCheckpoint(checkpoints[currentCheckpoint])
        currentCheckpoint += 1
    end
end)
