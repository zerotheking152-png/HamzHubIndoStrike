-- hamzHub v1.0
-- By: anjay
-- Game: Fishzar (Fishing System Exploit)
-- Fitur: Blati = Instant Fishing (Auto Pull + Precalc + Cleanup)
-- Cara pakai: Inject pake executor (Synapse, Fluxus, dll), jalankan script ini

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "hamzHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 320, 0, 180)
MainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.Text = "hamzHub - Fishzar"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local BlatiButton = Instance.new("TextButton")
BlatiButton.Size = UDim2.new(0.9, 0, 0, 50)
BlatiButton.Position = UDim2.new(0.05, 0, 0.35, 0)
BlatiButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
BlatiButton.Text = "Blati OFF"
BlatiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BlatiButton.TextScaled = true
BlatiButton.Font = Enum.Font.GothamBold
BlatiButton.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- ==================== BLATI LOGIC ====================
local autoFishing = false
local fishingConnection = nil

local function doInstantFish()
	-- Kode yang lo kasih tadi (ReplicatePullAlert + PrecalcFish + CleanupCast)
	local args = {
		"rbxassetid://76503247176490"
	}
	
	-- ReplicatePullAlert
	local pullRemote = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("ReplicatePullAlert")
	pullRemote:FireServer(unpack(args))
	
	-- PrecalcFish
	local precalc = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("PrecalcFish")
	precalc:InvokeServer()
	
	-- CleanupCast
	local cleanup = ReplicatedStorage:WaitForChild("FishingSystem"):WaitForChild("CleanupCast")
	cleanup:FireServer()
end

BlatiButton.MouseButton1Click:Connect(function()
	autoFishing = not autoFishing
	
	if autoFishing then
		BlatiButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		BlatiButton.Text = "Blati ON (Instant Fishing)"
		StatusLabel.Text = "Status: Blati ACTIVE - Auto Fishing"
		
		fishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
			if autoFishing then
				doInstantFish()
			end
		end)
	else
		BlatiButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		BlatiButton.Text = "Blati OFF"
		StatusLabel.Text = "Status: Ready"
		
		if fishingConnection then
			fishingConnection:Disconnect()
			fishingConnection = nil
		end
	end
end)

-- ==================== NOTIF & INFO ====================
print("✅ hamzHub loaded! Klik Blati buat instant fishing auto.")
print("⚠️  Jangan terlalu cepet, kasih delay kecil biar ga kena rate limit.")

-- Auto destroy kalau player leave (optional)
player.CharacterRemoving:Connect(function()
	ScreenGui:Destroy()
end)
