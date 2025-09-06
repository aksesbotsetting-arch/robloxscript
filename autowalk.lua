-- Anti duplicate
if getgenv().NazamHubLoaded then
    return
else
    getgenv().NazamHubLoaded = true
end

--// GUI Script By Nazam
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)

-- Musik
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://10894413175" -- << ganti dengan ID musik Roblox
sound.Looped = true
sound.Volume = 5
sound.Parent = game:GetService("SoundService")
sound:Play()

-- Fungsi animasi fade
local TweenService = game:GetService("TweenService")
local function fade(obj, targetTransparency, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time), {TextTransparency = targetTransparency})
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
keyFrame.Size = UDim2.new(0,400,0,250)
keyFrame.Position = UDim2.new(0.5,-200,0.5,-125)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
keyFrame.Visible = false
keyFrame.Active = true
keyFrame.Draggable = true

Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,15)
local keyShadow = Instance.new("UIStroke", keyFrame)
keyShadow.Thickness = 2
keyShadow.Color = Color3.fromRGB(0,200,255)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,50)
keyBox.Position = UDim2.new(0.1,0,0.3,0)
keyBox.PlaceholderText = "Masukkan Key..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextScaled = true
keyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0.8,0,0,50)
keyBtn.Position = UDim2.new(0.1,0,0.65,0)
keyBtn.Text = "Lanjut"
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
keyBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Menu Frame
local menuFrame = Instance.new("Frame", gui)
menuFrame.Size = UDim2.new(0,400,0,300)
menuFrame.Position = UDim2.new(0.5,-200,0.5,-150)
menuFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true

Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0,15)
local menuShadow = Instance.new("UIStroke", menuFrame)
menuShadow.Thickness = 2
menuShadow.Color = Color3.fromRGB(0,200,255)

local menuLabel = Instance.new("TextLabel", menuFrame)
menuLabel.Size = UDim2.new(1,0,0,60)
menuLabel.Text = "Menu Utama"
menuLabel.BackgroundTransparency = 1
menuLabel.TextColor3 = Color3.fromRGB(255,255,255)
menuLabel.Font = Enum.Font.GothamBold
menuLabel.TextScaled = true

-- Tombol Musik
local musicBtn = Instance.new("TextButton", menuFrame)
musicBtn.Size = UDim2.new(0.8,0,0,50)
musicBtn.Position = UDim2.new(0.1,0,0.7,0)
musicBtn.Text = "Stop Music"
musicBtn.Font = Enum.Font.GothamBold
musicBtn.TextScaled = true
musicBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
musicBtn.TextColor3 = Color3.fromRGB(255,255,255)

local isPlaying = true
musicBtn.MouseButton1Click:Connect(function()
    if isPlaying then
        sound:Stop()
        musicBtn.Text = "Play Music"
        isPlaying = false
    else
        sound:Play()
        musicBtn.Text = "Stop Music"
        isPlaying = true
    end
end)

-- Reopen button (floating)
local reopenButton = Instance.new("TextButton", gui)
reopenButton.Size = UDim2.new(0,100,0,30)
reopenButton.Position = UDim2.new(0.5,-50,0,5)
reopenButton.Text = "Open Menu"
reopenButton.BackgroundColor3 = Color3.fromRGB(0,200,255)
reopenButton.TextColor3 = Color3.fromRGB(255,255,255)
reopenButton.Font = Enum.Font.GothamBold
reopenButton.Visible = false
reopenButton.Active = true
reopenButton.Draggable = true

-- Tutup menu dengan klik luar
local function closeMenuWhenOutsideClick(frame)
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UIS:GetMouseLocation()
            local absPos = frame.AbsolutePosition
            local absSize = frame.AbsoluteSize
            if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X
                and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                frame.Visible = false
                reopenButton.Visible = true
            end
        end
    end)
end
closeMenuWhenOutsideClick(menuFrame)

-- Logika intro
task.spawn(function()
    fade(introText, 0, 0) -- mulai invisible
    fade(introText, 0, 0.5)
    fade(introText, 0, 1)
    fade(introText, 0, 2)
    introText.TextTransparency = 1
    introFrame:Destroy()
    keyFrame.Visible = true
end)

-- Sistem key
local KEY = "nazamganteng"
local keyEntered = false
keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        keyEntered = true
        keyFrame.Visible = false
        menuFrame.Visible = true
    else
        keyBox.Text = "❌ Key salah!"
    end
end)

-- Buka menu lagi
reopenButton.MouseButton1Click:Connect(function()
    if keyEntered then
        reopenButton.Visible = false
        menuFrame.Visible = true
    else
        reopenButton.Visible = false
        keyFrame.Visible = true
    end
end)
