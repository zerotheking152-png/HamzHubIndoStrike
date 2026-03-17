-- FISHZAR Auto Fish + GUI BUATAN SENDIRI (No Library, Pure Roblox)
-- Paste langsung ke executor bro, pasti muncul!

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local FishingSys = RS:WaitForChild("FishingSystem")

local CleanupCast   = FishingSys:WaitForChild("CleanupCast")
local FishGiver     = FishingSys:WaitForChild("FishGiver")
local ReplicatePull = FishingSys:WaitForChild("ReplicatePullAlert")
local CastRepli     = FishingSys:WaitForChild("CastReplication")

-- Setting cast (ganti sendiri kalo mau spot lain)
local CAST_POS = Vector3.new(-135.43, 3.43, 300.94)
local HOOK_OFFSET = Vector3.new(-11.45, 5, -11.18)
local ROD_NAME = "Basic Rod"
local CAST_POWER = 11.93

local AUTO_FISH = false

local function safeFire(remote, ...)
    pcall(function() remote:FireServer(...) end)
end

local function castRod()
    safeFire(CleanupCast)
    wait(0.3)
    safeFire(CastRepli, CAST_POS, HOOK_OFFSET, ROD_NAME, CAST_POWER)
    wait(math.random(4, 10))
    safeFire(ReplicatePull, "rbxassetid://76503247176490")
    safeFire(FishGiver, {hookPosition = CAST_POS})
    wait(1.5)
end

-- ================== GUI BUATAN SENDIRI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishzarHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🐟 FISHZAR AUTO"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Text = "AUTO FISH: OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame

local ManualBtn = Instance.new("TextButton")
ManualBtn.Size = UDim2.new(0.9, 0, 0, 40)
ManualBtn.Position = UDim2.new(0.05, 0, 0, 110)
ManualBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
ManualBtn.Text = "Manual Cast (Test)"
ManualBtn.TextColor3 = Color3.new(1,1,1)
ManualBtn.TextScaled = true
ManualBtn.Font = Enum.Font.Gotham
ManualBtn.Parent = MainFrame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9, 0, 0, 30)
Status.Position = UDim2.new(0.05, 0, 0, 155)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = MainFrame

-- Drag support (udah ada di Frame.Draggable = true)

-- Logic Toggle
ToggleBtn.MouseButton1Click:Connect(function()
    AUTO_FISH = not AUTO_FISH
    if AUTO_FISH then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        ToggleBtn.Text = "AUTO FISH: ON"
        Status.Text = "Status: Auto Fishing ON"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleBtn.Text = "AUTO FISH: OFF"
        Status.Text = "Status: Auto Fishing OFF"
    end
end)

-- Manual Cast
ManualBtn.MouseButton1Click:Connect(function()
    Status.Text = "Status: Manual Cast..."
    castRod()
    Status.Text = "Status: Cast selesai!"
    wait(1)
    Status.Text = AUTO_FISH and "Status: Auto Fishing ON" or "Status: Idle"
end)

-- Loop auto
spawn(function()
    while true do
        if AUTO_FISH then
            pcall(function()
                Status.Text = "Status: Casting..."
                castRod()
                Status.Text = "Status: Dapet ikan! ✅"
            end)
        end
        wait(2)
    end
end)

print("✅ GUI BUATAN SENDIRI muncul bro! Drag frame-nya, toggle auto fish sekarang!")
