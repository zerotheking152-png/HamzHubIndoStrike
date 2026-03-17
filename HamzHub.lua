-- INDO STRIKE HMZ HUB - FLUENT STYLE CUSTOM (No External Load) 2026
-- Execute di executor lo

local Players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- REMOTES
local throwRemote = rs:WaitForChild("Fishing_RemoteThrow")
local fishing = rs:WaitForChild("Fishing")
local toServer = fishing:WaitForChild("ToServer")
local minigameStarted = toServer:WaitForChild("MinigameStarted")
local reelFinished = toServer:WaitForChild("ReelFinished")

-- SESSION ID HOOK
local sessionID = nil
hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if self == throwRemote and getnamecallmethod() == "FireServer" then
        local args = {...}
        if typeof(args[2]) == "string" and #args[2] > 20 then sessionID = args[2] end
    end
    return oldNamecall(self, ...)
end))

getgenv().AutoFish = false
getgenv().Blati = false

-- === GUI UTAMA (Mirip Fluent) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title HMZ
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Text = '<font color="rgb(0,162,255)">H</font><font color="rgb(255,215,0)">M</font><font color="rgb(255,50,50)">Z</font>  HUB'
Title.TextScaled = true
Title.RichText = true
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = MainFrame

-- Auto Fish Toggle
local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0.9, 0, 0, 55)
AutoBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
AutoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AutoBtn.Text = "Auto Fish: OFF"
AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoBtn.TextScaled = true
AutoBtn.Font = Enum.Font.GothamSemibold
AutoBtn.Parent = MainFrame
local AutoCorner = Instance.new("UICorner"); AutoCorner.CornerRadius = UDim.new(0,12); AutoCorner.Parent = AutoBtn

-- Blati Toggle
local BlatiBtn = Instance.new("TextButton")
BlatiBtn.Size = UDim2.new(0.9, 0, 0, 55)
BlatiBtn.Position = UDim2.new(0.05, 0, 0.52, 0)
BlatiBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BlatiBtn.Text = "Blati: OFF"
BlatiBtn.TextColor3 = Color3.fromRGB(255,255,255)
BlatiBtn.TextScaled = true
BlatiBtn.Font = Enum.Font.GothamSemibold
BlatiBtn.Parent = MainFrame
local BlatiCorner = Instance.new("UICorner"); BlatiCorner.CornerRadius = UDim.new(0,12); BlatiCorner.Parent = BlatiBtn

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9, 0, 0, 40)
Status.Position = UDim2.new(0.05, 0, 0.75, 0)
Status.BackgroundTransparency = 1
Status.Text = "Cast manual 1x dulu pake rod!"
Status.TextColor3 = Color3.fromRGB(255, 200, 0)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = MainFrame

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -50, 0, 10)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = MainFrame
local MinCorner = Instance.new("UICorner"); MinCorner.Parent = MinimizeBtn

-- === HMZ MINI ICON (pojok) ===
local HMZMini = Instance.new("Frame")
HMZMini.Size = UDim2.new(0, 130, 0, 45)
HMZMini.Position = UDim2.new(1, -150, 1, -70)
HMZMini.BackgroundColor3 = Color3.fromRGB(20,20,20)
HMZMini.Visible = false
HMZMini.Parent = ScreenGui
local HMZCorner = Instance.new("UICorner"); HMZCorner.CornerRadius = UDim.new(0,20); HMZCorner.Parent = HMZMini
local HMZStroke = Instance.new("UIStroke"); HMZStroke.Color = Color3.fromRGB(100,100,255); HMZStroke.Thickness = 2; HMZStroke.Parent = HMZMini

local HMZText = Instance.new("TextLabel")
HMZText.Size = UDim2.new(1,0,1,0)
HMZText.BackgroundTransparency = 1
HMZText.Text = '<font color="rgb(0,162,255)">H</font><font color="rgb(255,215,0)">M</font><font color="rgb(255,50,50)">Z</font>'
HMZText.RichText = true
HMZText.TextScaled = true
HMZText.Font = Enum.Font.GothamBlack
HMZText.Parent = HMZMini

-- Draggable both
local function makeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end
makeDraggable(MainFrame)
makeDraggable(HMZMini)

-- === LOGIC ===
local autoLoop
local function toggleAutoFish(on)
    getgenv().AutoFish = on
    if on then
        AutoBtn.Text = "Auto Fish: ON"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoLoop = task.spawn(function()
            while getgenv().AutoFish do
                if sessionID then
                    throwRemote:FireServer(0, sessionID)
                    task.wait(0.7)
                    minigameStarted:FireServer(sessionID)
                    task.wait(0.3)
                    local args = {["duration"] = math.random(7.5,12.5), ["result"] = "SUCCESS", ["insideRatio"] = 0.8 + math.random(3,18)/100}
                    reelFinished:FireServer(args, sessionID)
                    task.wait(1.5)
                else
                    task.wait(0.5)
                end
            end
        end)
    else
        AutoBtn.Text = "Auto Fish: OFF"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        if autoLoop then task.cancel(autoLoop) end
    end
end

AutoBtn.MouseButton1Click:Connect(function() toggleAutoFish(not getgenv().AutoFish) end)

BlatiBtn.MouseButton1Click:Connect(function()
    getgenv().Blati = not getgenv().Blati
    if getgenv().Blati then
        BlatiBtn.Text = "Blati: ON"
        BlatiBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        BlatiBtn.Text = "Blati: OFF"
        BlatiBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    HMZMini.Visible = true
end)

HMZMini.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        MainFrame.Visible = true
        HMZMini.Visible = false
    end
end)

print("✅ HMZ Hub CUSTOM FLUENT STYLE loaded! Cast manual 1x dulu ya bro")
