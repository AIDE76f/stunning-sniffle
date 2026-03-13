-- الخدمات الأساسية المطلوبة
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- دالة جعل العنصر قابل للسحب
-- ==========================================
local function makeDraggable(guiObject)

    local dragging = false
    local dragStart
    local startPos

    guiObject.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

        end

    end)

    guiObject.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end

    end)

    guiObject.InputChanged:Connect(function(input)

        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then

            local delta = input.Position - dragStart

            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )

        end

    end)

end

-- ==========================================
-- ScreenGui
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProPlayerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ==========================================
-- Main Frame
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,250,0,190)
mainFrame.Position = UDim2.new(0.5,-125,0.4,-95)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,12)
frameCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70,70,80)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,0,0,40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ لوحة التحكم"
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

-- ==========================================
-- زر السرعة
-- ==========================================
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0,210,0,45)
speedButton.Position = UDim2.new(0.5,-105,0,55)
speedButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
speedButton.Text = "تفعيل السرعة (2x)"
speedButton.TextColor3 = Color3.fromRGB(255,255,255)
speedButton.Font = Enum.Font.GothamSemibold
speedButton.TextSize = 15
speedButton.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0,8)
speedCorner.Parent = speedButton

speedButton.MouseEnter:Connect(function()
    TweenService:Create(speedButton,TweenInfo.new(0.15),{Size = UDim2.new(0,215,0,47)}):Play()
end)

speedButton.MouseLeave:Connect(function()
    TweenService:Create(speedButton,TweenInfo.new(0.15),{Size = UDim2.new(0,210,0,45)}):Play()
end)

-- ==========================================
-- زر اظهار الانتقال
-- ==========================================
local tpModeButton = Instance.new("TextButton")
tpModeButton.Size = UDim2.new(0,210,0,45)
tpModeButton.Position = UDim2.new(0.5,-105,0,115)
tpModeButton.BackgroundColor3 = Color3.fromRGB(40,40,50)
tpModeButton.Text = "إظهار زر الانتقال"
tpModeButton.TextColor3 = Color3.fromRGB(200,200,200)
tpModeButton.Font = Enum.Font.GothamSemibold
tpModeButton.TextSize = 15
tpModeButton.Parent = mainFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0,8)
tpCorner.Parent = tpModeButton

-- ==========================================
-- زر الانتقال
-- ==========================================
local executeTpButton = Instance.new("TextButton")
executeTpButton.Size = UDim2.new(0,200,0,55)
executeTpButton.Position = UDim2.new(0.5,-100,0.85,0)
executeTpButton.BackgroundColor3 = Color3.fromRGB(255,50,50)
executeTpButton.Text = "🎯 انتقال خلف الأقرب"
executeTpButton.TextColor3 = Color3.fromRGB(255,255,255)
executeTpButton.Font = Enum.Font.GothamBold
executeTpButton.TextSize = 18
executeTpButton.Visible = false
executeTpButton.Parent = screenGui

local tpCorner2 = Instance.new("UICorner")
tpCorner2.CornerRadius = UDim.new(0,27)
tpCorner2.Parent = executeTpButton

-- ==========================================
-- المتغيرات
-- ==========================================
local isSpeedBoosted = false
local isTpModeActive = false
local defaultSpeed = 16
local boostedSpeed = 32

-- ==========================================
-- زر السرعة
-- ==========================================
speedButton.MouseButton1Click:Connect(function()

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then

        isSpeedBoosted = not isSpeedBoosted

        if isSpeedBoosted then
            humanoid.WalkSpeed = boostedSpeed
            speedButton.Text = "إلغاء السرعة"
            speedButton.BackgroundColor3 = Color3.fromRGB(255,170,0)
        else
            humanoid.WalkSpeed = defaultSpeed
            speedButton.Text = "تفعيل السرعة (2x)"
            speedButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
        end
    end
end)

-- ==========================================
-- اظهار زر الانتقال
-- ==========================================
tpModeButton.MouseButton1Click:Connect(function()

    isTpModeActive = not isTpModeActive
    executeTpButton.Visible = isTpModeActive

    if isTpModeActive then
        tpModeButton.Text = "إخفاء زر الانتقال"
        tpModeButton.BackgroundColor3 = Color3.fromRGB(80,200,80)
        tpModeButton.TextColor3 = Color3.fromRGB(255,255,255)
    else
        tpModeButton.Text = "إظهار زر الانتقال"
        tpModeButton.BackgroundColor3 = Color3.fromRGB(40,40,50)
        tpModeButton.TextColor3 = Color3.fromRGB(200,200,200)
    end
end)

-- ==========================================
-- الانتقال خلف اقرب لاعب + التأثير الأبيض
-- ==========================================
executeTpButton.MouseButton1Click:Connect(function()

    local myCharacter = player.Character
    if not myCharacter then return end

    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in pairs(Players:GetPlayers()) do

        if otherPlayer ~= player and otherPlayer.Character then

            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")

            if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then

                local distance = (myRoot.Position - otherRoot.Position).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = otherPlayer
                end

            end
        end
    end

    if nearestPlayer and nearestPlayer.Character then

        local targetRoot = nearestPlayer.Character.HumanoidRootPart
        local positionBehind = targetRoot.CFrame * CFrame.new(0,0,5)

        myRoot.CFrame = CFrame.new(positionBehind.Position,targetRoot.Position)

        -- التأثير الأبيض
        local flash = Instance.new("ColorCorrectionEffect")
        flash.Brightness = 1
        flash.Parent = game.Lighting

        TweenService:Create(flash,TweenInfo.new(0.5),{Brightness = 0}):Play()

        game.Debris:AddItem(flash,0.5)

    end
end)

-- ==========================================
-- جعل العناصر قابلة للسحب
-- ==========================================
makeDraggable(mainFrame)
makeDraggable(executeTpButton)

-- ==========================================
-- الحفاظ على السرعة بعد respawn
-- ==========================================
player.CharacterAdded:Connect(function(character)

    local humanoid = character:WaitForChild("Humanoid")

    if humanoid and isSpeedBoosted then
        humanoid.WalkSpeed = boostedSpeed
    end
end)
