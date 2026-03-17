-- FISHZAR Pulau Nelayan Auto Fish + RAYFIELD UI (Versi Fix 2026)
-- Paste langsung ke executor!

local RS = game:GetService("ReplicatedStorage")
local FishingSys = RS:WaitForChild("FishingSystem", 5)

local CleanupCast   = FishingSys:WaitForChild("CleanupCast")
local FishGiver     = FishingSys:WaitForChild("FishGiver")
local ReplicatePull = FishingSys:WaitForChild("ReplicatePullAlert")
local CastRepli     = FishingSys:WaitForChild("CastReplication")

local CAST_POSITION = Vector3.new(-135.43, 3.43, 300.94)
local HOOK_OFFSET   = Vector3.new(-11.45, 5, -11.18)
local ROD_NAME      = "Basic Rod"
local CAST_POWER    = 11.93

local AUTO_FISH = false

local function safeFire(remote, ...)
    pcall(function() remote:FireServer(...) end)
end

local function castRod()
    safeFire(CleanupCast)
    wait(0.3)
    safeFire(CastRepli, CAST_POSITION, HOOK_OFFSET, ROD_NAME, CAST_POWER)
    wait(math.random(4, 10))
    safeFire(ReplicatePull, "rbxassetid://76503247176490")
    safeFire(FishGiver, {hookPosition = CAST_POSITION})
    wait(1.5)
end

spawn(function()
    while true do
        if AUTO_FISH then pcall(castRod) end
        wait(2)
    end
end)

-- ================== RAYFIELD UI ==================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "FISHZAR Auto Farm",
    LoadingTitle = "HamzHub Fishzar",
    LoadingSubtitle = "by Grok",
    ConfigurationSaving = {Enabled = true, FolderName = "FishzarHub", FileName = "Config"}
})

local MainTab = Window:CreateTab("Main", 4483362458)
local Controls = MainTab:CreateSection("Auto Fishing")

local Toggle = Controls:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        AUTO_FISH = Value
        Rayfield:Notify({Title = "FISHZAR", Content = Value and "Auto nyala bro! 🐟" or "Auto mati", Duration = 3})
    end
})

Controls:CreateButton({
    Name = "Manual Cast (Test)",
    Callback = function()
        castRod()
        Rayfield:Notify({Title = "Manual Cast", Content = "Lempar kail sukses!", Duration = 2})
    end
})

Controls:CreateLabel("Status: Waiting for toggle...")
Controls:CreateLabel("Spot: "..math.floor(CAST_POSITION.X)..", "..math.floor(CAST_POSITION.Y)..", "..math.floor(CAST_POSITION.Z))

Rayfield:Notify({
    Title = "FISHZAR Loaded!",
    Content = "GUI muncul bro! Toggle Auto Fish sekarang",
    Duration = 5,
    Image = 4483362458
})

print("✅ FISHZAR Rayfield GUI nyala! Kalau masih ga muncul, cek executor log (F9)")
