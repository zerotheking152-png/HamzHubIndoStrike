-- FISHZAR Pulau Nelayan Auto Fish + Kavo UI
-- Jalankan di executor seperti Delta, Fluxus, dll

local RS = game:GetService("ReplicatedStorage")
local FishingSys = RS:WaitForChild("FishingSystem")

local CleanupCast   = FishingSys:WaitForChild("CleanupCast")
local FishGiver     = FishingSys:WaitForChild("FishGiver")
local ReplicatePull = FishingSys:WaitForChild("ReplicatePullAlert")
local CastRepli     = FishingSys:WaitForChild("CastReplication")

-- Setting posisi cast (ganti sesuai spot lo, contoh dari spill sebelumnya)
local CAST_POSITION = Vector3.new(-135.43, 3.43, 300.94)
local HOOK_OFFSET   = Vector3.new(-11.45, 5, -11.18)
local ROD_NAME      = "Basic Rod"
local CAST_POWER    = 11.93  -- dari spill lo

local AUTO_FISH = false
local STATUS_TEXT = "Idle"

local function safeFire(remote, ...)
    pcall(function()
        remote:FireServer(...)
    end)
end

local function castRod()
    STATUS_TEXT = "Casting..."
    
    safeFire(CleanupCast)
    wait(0.3)
    
    safeFire(CastRepli, CAST_POSITION, HOOK_OFFSET, ROD_NAME, CAST_POWER)
    
    wait(math.random(4, 10))  -- tunggu bite (random biar natural)
    
    safeFire(ReplicatePull, "rbxassetid://76503247176490")
    
    local giverArgs = { hookPosition = CAST_POSITION }
    safeFire(FishGiver, giverArgs)
    
    STATUS_TEXT = "Fish claimed! Waiting..."
    wait(1.5)
end

-- Loop auto fish
spawn(function()
    while true do
        if AUTO_FISH then
            pcall(castRod)
        end
        wait(2)  -- delay antispam
    end
end)

-- LOAD KAVO UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("FISHZAR Pulau Nelayan Auto", "DarkTheme")  -- tema lain: LightTheme, Sentinel, Ocean, Midnight, dll

local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Auto Fishing Controls")

MainSection:NewToggle("Auto Fish", "Nyala/Mati auto fishing", function(state)
    AUTO_FISH = state
    if state then
        STATUS_TEXT = "Auto Fishing: ON"
    else
        STATUS_TEXT = "Auto Fishing: OFF"
    end
end)

MainSection:NewButton("Manual Cast (Test)", "Coba lempar sekali", function()
    castRod()
end)

MainSection:NewLabel("Status: ")
local StatusLabel = MainSection:NewLabel(STATUS_TEXT)  -- update manual nanti

-- Optional: Update label setiap detik (Kavo ga support auto update label gampang, jadi manual)
spawn(function()
    while wait(1) do
        -- Kalo mau update status real-time, bisa recreate label atau pake notify
        -- Untuk simple, pake Library:Notify aja pas change
    end
end)

MainSection:NewLabel("Spot Cast: x="..math.floor(CAST_POSITION.X)..", y="..math.floor(CAST_POSITION.Y)..", z="..math.floor(CAST_POSITION.Z))
MainSection:NewLabel("Delay per cycle: \~6-14 detik")

-- Extra Tab kalo mau tambah fitur nanti
local ExtraTab = Window:NewTab("Extra")
ExtraTab:NewSection("Coming Soon: Auto Sell, TP Spot, dll")

print("GUI FISHZAR nyala bro! Tekan RightShift buat hide/show")

-- Optional: Notify selamat datang
Library:Notify("FISHZAR Auto Loaded!", "Auto Fish ready. Toggle di GUI ya!", 5)
