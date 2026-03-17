-- INDO STRIKE AUTO FISH + BLATI GUI (2026) - SUPER CEPET VERSION
-- Execute pake executor lo (Fluxus/Delta/Wave/Solara dll)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
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
getgenv().AutoFish = false
getgenv().Blati = false

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IndoStrikeGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Draggable (SUDAH DI-FIX BIAR BISA DIGESER KEMANA AJA, MOUSE KELUAR FRAME PUN TETEP NGIKUT)
local dragging = false
local dragStart = nil
local startPos = nil

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
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "INDO STRIKE AUTO"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local AutoFishBtn = Instance.new("TextButton")
AutoFishBtn.Size = UDim2.new(0.9, 0, 0, 45)
AutoFishBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
AutoFishBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
AutoFishBtn.Text = "Auto Fish: OFF"
AutoFishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFishBtn.TextScaled = true
AutoFishBtn.Font = Enum.Font.GothamSemibold
AutoFishBtn.Parent = MainFrame

local BlatiBtn = Instance.new("TextButton")
BlatiBtn.Size = UDim2.new(0.9, 0, 0, 45)
BlatiBtn.Position = UDim2.new(0.05, 0, 0.62, 0)
BlatiBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
BlatiBtn.Text = "Blati: OFF"
BlatiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BlatiBtn.TextScaled = true
BlatiBtn.Font = Enum.Font.GothamSemibold
BlatiBtn.Parent = MainFrame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.88, 0)
Status.BackgroundTransparency = 1
Status.Text = "Cast manual 1x dulu pake rod biasa!"
Status.TextColor3 = Color3.fromRGB(255, 200, 0)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = MainFrame

-- === TOGGLE LOGIC ===
local autoFishLoop

local function startAutoFish()
    if autoFishLoop then return end
    autoFishLoop = task.spawn(function()
        while getgenv().AutoFish do
            if sessionID then
                throwRemote:FireServer(0, sessionID)
                task.wait(0.05)   -- SUPER CEPET (dari 0.7)
                minigameStarted:FireServer(sessionID)
                task.wait(0.03)   -- SUPER CEPET (dari 0.3)
                
                local successArgs = {
                    ["duration"] = math.random(7.5, 12.5),
                    ["result"] = "SUCCESS",
                    ["insideRatio"] = 0.8 + (math.random(3, 18) / 100)
                }
                reelFinished:FireServer(successArgs, sessionID)
                task.wait(0.1)    -- SUPER CEPET (dari 1.5)
            else
                task.wait(0.1)
            end
        end
    end)
end

AutoFishBtn.MouseButton1Click:Connect(function()
    getgenv().AutoFish = not getgenv().AutoFish
    if getgenv().AutoFish then
        AutoFishBtn.Text = "Auto Fish: ON"
        AutoFishBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        startAutoFish()
        Status.Text = "Auto Fish JALAN 🔥 (SUPER CEPET)"
    else
        AutoFishBtn.Text = "Auto Fish: OFF"
        AutoFishBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        Status.Text = "Auto Fish OFF"
        if autoFishLoop then task.cancel(autoFishLoop) autoFishLoop = nil end
    end
end)

BlatiBtn.MouseButton1Click:Connect(function()
    getgenv().Blati = not getgenv().Blati
    if getgenv().Blati then
        BlatiBtn.Text = "Blati: ON"
        BlatiBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("🔥 Blati MODE ON (tambahin logic Blati lo di sini)")
        -- <<< TAMBAHIN CODE BLATI LO DI SINI NANTI >>>
    else
        BlatiBtn.Text = "Blati: OFF"
        BlatiBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

print("🎉 GUI Indo Strike SUPER CEPET udah muncul! Cast manual 1x dulu biar sessionID ke-capture. Mancing sekarang gila cepetnya bro!")
