local PathfindingService = game:GetService("PathfindingService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local gui = script.Parent
local frameIntro = gui:WaitForChild("FrameIntro")
local frameKey = gui:WaitForChild("FrameKey")
local frameMenu = gui:WaitForChild("FrameMenu")


local KEY = "nazamganteng"
local checkpointsFolder = workspace:WaitForChild("Checkpoints") -- folder isi checkpoint
local checkpoints = checkpointsFolder:GetChildren()
table.sort(checkpoints, function(a, b) return tonumber(a.Name) < tonumber(b.Name) end)

local currentCheckpoint = 1
local walking = false


frameIntro.Visible = true
frameKey.Visible = false
frameMenu.Visible = false


task.delay(2, function()
    frameIntro.Visible = false
    frameKey.Visible = true
end)


frameKey.LanjutButton.MouseButton1Click:Connect(function()
    local inputKey = frameKey.KeyBox.Text
    if inputKey == KEY then
        frameKey.Visible = false
        frameMenu.Visible = true
    else
        frameKey.KeyBox.Text = "Key salah!"
    end
end)


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


frameMenu.StartButton.MouseButton1Click:Connect(function()
    if not walking and currentCheckpoint <= #checkpoints then
        walkToCheckpoint(checkpoints[currentCheckpoint])
        currentCheckpoint += 1
    end
end)
