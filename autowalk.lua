-- Anti duplicate
if getgenv().NazamHubLoaded then return end
getgenv().NazamHubLoaded = true

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--=====================--
--  AUDIO SETUP
--=====================--
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://10894413175" -- ganti dengan ID musik
sound.Looped = true
sound.Volume = 1
sound.Parent = game:GetService("SoundService")

--=====================--
--  INTRO ANIMATION
--=====================--
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

local function tweenTransparency(obj, target, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = target})
    tween:Play()
    tween.Completed:Wait()
end

--=====================--
--  KEY FRAME
--=====================--
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0,400,0,250)
keyFrame.Position = UDim2.new(0.5,-200,0.5,-125)
keyFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
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
keyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
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

--=====================--
--  MENU FRAME
--=====================--
local menuFrame = Instance.new("Frame", gui)
menuFrame.Size = UDim2.new(0,400,0,300)
menuFrame.Position = UDim2.new(0.5,-200,0.5,-150)
menuFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
menuFrame.Visible = false
menuFrame.Active = true
menuFrame.Draggable = true
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0,15)
local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Color = Color3.fromRGB(0,200,255)
menuStroke.Thickness = 2

-- Menu Label
local menuLabel = Instance.new("TextLabel", menuFrame)
menuLabel.Size = UDim2.new(1,0,0,60)
menuLabel.Text = "Menu Utama"
menuLabel.BackgroundTransparency = 1
menuLabel.TextColor3 = Color3.fromRGB(255,255,255)
menuLabel.Font = Enum.Font.GothamBold
menuLabel.TextScaled = true

-- General Info / Tulisan Umum
local generalLabel = Instance.new("TextLabel", menuFrame)
generalLabel.Size = UDim2.new(0.9,0,0,40)
generalLabel.Position = UDim2.new(0.05,0,0.1,0)
generalLabel.Text = "Selamat Datang di Nazam Hub!"
generalLabel.BackgroundTransparency = 1
generalLabel.TextColor3 = Color3.fromRGB(0,200,255)
generalLabel.Font = Enum.Font.Gotham
generalLabel.TextScaled = true

local versionLabel = Instance.new("TextLabel", menuFrame)
versionLabel.Size = UDim2.new(0.9,0,0,30)
versionLabel.Position = UDim2.new(0.05,0,0.2,0)
versionLabel.Text = "Versi: 1.0"
versionLabel.BackgroundTransparency = 1
versionLabel.TextColor3 = Color3.fromRGB(255,255,255)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextScaled = true

-- Music Button
local musicBtn = Instance.new("TextButton", menuFrame)
musicBtn.Size = UDim2.new(0.8,0,0,50)
musicBtn.Position = UDim2.new(0.1,0,0.7,0)
musicBtn.Text = "Stop Music"
musicBtn.Font = Enum.Font.GothamBold
musicBtn.TextScaled = true
musicBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
musicBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", musicBtn).CornerRadius = UDim.new(0,8)

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

--=====================--
--  REOPEN BUTTON
--=====================--
local reopenBtn = Instance.new("TextButton", gui)
reopenBtn.Size = UDim2.new(0,120,0,30)
reopenBtn.Position = UDim2.new(0.5,-60,0,5)
reopenBtn.Text = "Open Menu"
reopenBtn.BackgroundColor3 = Color3.fromRGB(0,200,255)
reopenBtn.TextColor3 = Color3.fromRGB(255,255,255)
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.Visible = false
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0,6)

--=====================--
--  OUTSIDE CLICK CLOSE
--=====================--
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

--=====================--
--  KEY SYSTEM
--=====================--
local KEY = "nazamganteng"
local keyEntered = false

keyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        keyEntered = true
        keyFrame.Visible = false
        menuFrame.Visible = true
        reopenBtn.Visible = false
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
