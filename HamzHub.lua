-- HAMZHUB AUTO FISH + BLATI GUI (2026) - SUPER CEPET + GUI KEREN VERSION
-- Execute pake executor lo (Fluxus/Delta/Wave/Solara dll)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- === REMOTES ===
local throwRemote = ReplicatedStorage:WaitForChild("Fishing_RemoteThrow")
local fishingFolder = ReplicatedStorage:WaitForChild("Fishing")
local toServer = fishingFolder:WaitForChild("ToServer")
local minigameStarted = toServer:WaitForChild("MinigameStarted")
local reelFinished = toServer:WaitForChild("ReelFinished")

-- === SESSION ID HOOK ===
local sessionID = nil
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if getnamecallmethod() == "FireServer" and self == throwRemote then
        local args = {...}
        if typeof(args[2]) == "string" and #args[2] > 20 then
            sessionID = args[2]
            print("✅ Session ID captured: " .. sessionID)
        end
    end
    return oldNamecall(self, ...)
end))

-- === FLAGS ===
getgenv().Blati = false
getgenv().InfiniteJump = false
getgenv().Noclip = false
getgenv().WalkSpeedValue = 16

-- === CHARACTER SETUP ===
local humanoid = nil
local function getHumanoid()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        humanoid = player.Character.Humanoid
        return humanoid
    end
    return nil
end
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    getHumanoid()
end)
getHumanoid()

-- === GUI KEREN (Modern Dark Neon) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HamzHubGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Neon Stroke + Corner + Gradient
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 100)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,40))
}
UIGradient.Parent = MainFrame

-- Draggable (tetep smooth)
local dragging = false
local dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- === TITLE HAMZHUB KEREN (H merah, M kuning, Z biru) ===
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Text = '<font color="#FF0000">H</font><font color="#FFFFFF">A</font><font color="#FFFF00">M</font><font color="#00BFFF">Z</font><font color="#FFFFFF">HUB</font>'
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.RichText = true
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- === TAB BUTTONS ===
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 60)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
MainTabBtn.Position = UDim2.new(0, 0, 0, 0)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainTabBtn.Text = "MAIN"
MainTabBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
MainTabBtn.TextScaled = true
MainTabBtn.Font = Enum.Font.GothamSemibold
MainTabBtn.Parent = TabFrame
local MainTabCorner = Instance.new("UICorner"); MainTabCorner.CornerRadius = UDim.new(0,8); MainTabCorner.Parent = MainTabBtn

local PlayerTabBtn = Instance.new("TextButton")
PlayerTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
PlayerTabBtn.Position = UDim2.new(0.5, 5, 0, 0)
PlayerTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerTabBtn.Text = "PLAYER"
PlayerTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerTabBtn.TextScaled = true
PlayerTabBtn.Font = Enum.Font.GothamSemibold
PlayerTabBtn.Parent = TabFrame
local PlayerTabCorner = Instance.new("UICorner"); PlayerTabCorner.CornerRadius = UDim.new(0,8); PlayerTabCorner.Parent = PlayerTabBtn

-- === MAIN TAB (Blati Instant Fishing) ===
local MainContent = Instance.new("Frame")
MainContent.Size = UDim2.new(1, 0, 1, -100)
MainContent.Position = UDim2.new(0, 0, 0, 100)
MainContent.BackgroundTransparency = 1
MainContent.Visible = true
MainContent.Parent = MainFrame

local BlatiBtn = Instance.new("TextButton")
BlatiBtn.Size = UDim2.new(0.9, 0, 0, 55)
BlatiBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
BlatiBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
BlatiBtn.Text = "BLATI (Instant Fishing): OFF"
BlatiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BlatiBtn.TextScaled = true
BlatiBtn.Font = Enum.Font.GothamBold
BlatiBtn.Parent = MainContent
local BlatiCorner = Instance.new("UICorner"); BlatiCorner.CornerRadius = UDim.new(0,10); BlatiCorner.Parent = BlatiBtn

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9, 0, 0, 40)
Status.Position = UDim2.new(0.05, 0, 0.35, 0)
Status.BackgroundTransparency = 1
Status.Text = "Cast manual 1x dulu pake rod biasa!"
Status.TextColor3 = Color3.fromRGB(255, 200, 0)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = MainContent

-- === PLAYER TAB ===
local PlayerContent = Instance.new("Frame")
PlayerContent.Size = UDim2.new(1, 0, 1, -100)
PlayerContent.Position = UDim2.new(0, 0, 0, 100)
PlayerContent.BackgroundTransparency = 1
PlayerContent.Visible = false
PlayerContent.Parent = MainFrame

-- Infinite Jump
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Size = UDim2.new(0.9, 0, 0, 45)
InfJumpBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
InfJumpBtn.Text = "Infinite Jump: OFF"
InfJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpBtn.TextScaled = true
InfJumpBtn.Font = Enum.Font.GothamSemibold
InfJumpBtn.Parent = PlayerContent
local InfJumpCorner = Instance.new("UICorner"); InfJumpCorner.CornerRadius = UDim.new(0,10); InfJumpCorner.Parent = InfJumpBtn

-- Noclip
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.9, 0, 0, 45)
NoclipBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
NoclipBtn.Text = "Noclip: OFF"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.TextScaled = true
NoclipBtn.Font = Enum.Font.GothamSemibold
NoclipBtn.Parent = PlayerContent
local NoclipCorner = Instance.new("UICorner"); NoclipCorner.CornerRadius = UDim.new(0,10); NoclipCorner.Parent = NoclipBtn

-- WalkSpeed
local WSFrame = Instance.new("Frame")
WSFrame.Size = UDim2.new(0.9, 0, 0, 50)
WSFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
WSFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
WSFrame.Parent = PlayerContent
local WSCorner = Instance.new("UICorner"); WSCorner.CornerRadius = UDim.new(0,10); WSCorner.Parent = WSFrame

local WSText = Instance.new("TextLabel")
WSText.Size = UDim2.new(0.5, 0, 1, 0)
WSText.BackgroundTransparency = 1
WSText.Text = "WalkSpeed:"
WSText.TextColor3 = Color3.fromRGB(255, 255, 255)
WSText.TextScaled = true
WSText.Font = Enum.Font.Gotham
WSText.Parent = WSFrame

local WSBox = Instance.new("TextBox")
WSBox.Size = UDim2.new(0.3, 0, 0.8, 0)
WSBox.Position = UDim2.new(0.55, 0, 0.1, 0)
WSBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
WSBox.Text = "16"
WSBox.TextColor3 = Color3.fromRGB(0, 255, 100)
WSBox.TextScaled = true
WSBox.Font = Enum.Font.Gotham
WSBox.Parent = WSFrame
local WSBoxCorner = Instance.new("UICorner"); WSBoxCorner.CornerRadius = UDim.new(0,8); WSBoxCorner.Parent = WSBox

local WSSetBtn = Instance.new("TextButton")
WSSetBtn.Size = UDim2.new(0.15, 0, 0.8, 0)
WSSetBtn.Position = UDim2.new(0.85, 0, 0.1, 0)
WSSetBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
WSSetBtn.Text = "SET"
WSSetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WSSetBtn.TextScaled = true
WSSetBtn.Font = Enum.Font.GothamBold
WSSetBtn.Parent = WSFrame
local WSSetCorner = Instance.new("UICorner"); WSSetCorner.CornerRadius = UDim.new(0,8); WSSetCorner.Parent = WSSetBtn

-- === TAB SWITCH ===
MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    PlayerContent.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainTabBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    PlayerTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PlayerTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

PlayerTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    PlayerContent.Visible = true
    PlayerTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    PlayerTabBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- === BLATI (Instant Fishing SUPER CEPET) ===
local blatiLoop
local function startBlati()
    if blatiLoop then return end
    blatiLoop = task.spawn(function()
        while getgenv().Blati do
            if sessionID and humanoid then
                throwRemote:FireServer(0, sessionID)
                task.wait(0.05)
                minigameStarted:FireServer(sessionID)
                task.wait(0.03)
                local successArgs = {
                    ["duration"] = math.random(7.5, 12.5),
                    ["result"] = "SUCCESS",
                    ["insideRatio"] = 0.8 + (math.random(3, 18) / 100)
                }
                reelFinished:FireServer(successArgs, sessionID)
                task.wait(0.1)
            else
                task.wait(0.1)
            end
        end
    end)
end

BlatiBtn.MouseButton1Click:Connect(function()
    getgenv().Blati = not getgenv().Blati
    if getgenv().Blati then
        BlatiBtn.Text = "BLATI (Instant Fishing): ON"
        BlatiBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        startBlati()
        Status.Text = "BLATI JALAN 🔥 (SUPER CEPET)"
    else
        BlatiBtn.Text = "BLATI (Instant Fishing): OFF"
        BlatiBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        Status.Text = "BLATI OFF"
        if blatiLoop then task.cancel(blatiLoop) blatiLoop = nil end
    end
end)

-- === INFINITE JUMP ===
local jumpConnection
InfJumpBtn.MouseButton1Click:Connect(function()
    getgenv().InfiniteJump = not getgenv().InfiniteJump
    if getgenv().InfiniteJump then
        InfJumpBtn.Text = "Infinite Jump: ON"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        if not jumpConnection then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                if getgenv().InfiniteJump and humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    else
        InfJumpBtn.Text = "Infinite Jump: OFF"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- === NOCLIP ===
local noclipConnection
NoclipBtn.MouseButton1Click:Connect(function()
    getgenv().Noclip = not getgenv().Noclip
    if getgenv().Noclip then
        NoclipBtn.Text = "Noclip: ON"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if getgenv().Noclip and player.Character then
                    for _, v in pairs(player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        NoclipBtn.Text = "Noclip: OFF"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
            -- restore collide
            if player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = true end
                end
            end
        end
    end
end)

-- === WALK SPEED ===
WSSetBtn.MouseButton1Click:Connect(function()
    local value = tonumber(WSBox.Text)
    if value and humanoid then
        getgenv().WalkSpeedValue = value
        humanoid.WalkSpeed = value
        print("✅ WalkSpeed di-set ke " .. value)
    end
end)

-- Auto update walkspeed kalau character respawn
player.CharacterAdded:Connect(function()
    task.wait(1)
    if humanoid then
        humanoid.WalkSpeed = getgenv().WalkSpeedValue
    end
end)

print("🎉 HAMZHUB GUI KEREN udah muncul bro! Tab MAIN & PLAYER siap. Cast manual 1x dulu biar Blati nyala. Gas polll 🔥")
