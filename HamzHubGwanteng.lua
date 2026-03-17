-- AUTO FISH INDO STRIKE - SUPER CEPAT (Instant Reel Max Speed 2026)
-- Execute di Fluxus/Delta/Wave/Solara dll

local rs = game:GetService("ReplicatedStorage")
local throwRemote = rs:WaitForChild("Fishing_RemoteThrow")
local fishing = rs:WaitForChild("Fishing")
local toServer = fishing:WaitForChild("ToServer")
local minigameStarted = toServer:WaitForChild("MinigameStarted")
local reelFinished = toServer:WaitForChild("ReelFinished")

local sessionID = nil

-- HOOK sessionID (cast manual 1x dulu)
hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == throwRemote and method == "FireServer" then
        local args = {...}
        if typeof(args[2]) == "string" and #args[2] > 20 then
            sessionID = args[2]
            print("✅ Session ID captured: " .. sessionID)
        end
    end
    return oldNamecall(self, ...)
end))

getgenv().AutoFish = true  -- ganti false buat stop

print("🚀 SUPER FAST Auto Fish ON! Cast manual 1x pake rod biasa dulu!")

task.spawn(function()
    while getgenv().AutoFish do
        if sessionID then
            -- CAST super cepat
            throwRemote:FireServer(0, sessionID)
            
            task.wait(0.2)  -- minimal umpan masuk
            
            -- MINIGAME langsung
            minigameStarted:FireServer(sessionID)
            
            task.wait(0.1)  -- minimal delay
            
            -- INSTANT REEL SUCCESS
            local successArgs = {
                ["duration"] = math.random(7, 13),
                ["result"] = "SUCCESS",
                ["insideRatio"] = 0.82 + (math.random(5, 15) / 100)
            }
            
            reelFinished:FireServer(successArgs, sessionID)
            
            task.wait(0.4)  -- cooldown minimal (bisa turunin lagi ke 0.3 kalo server lo kuat, tapi risk kick lebih tinggi)
        else
            task.wait(0.1)  -- cek cepet kalo belum dapet ID
        end
    end
    print("⛔ SUPER FAST Auto Fish OFF")
end)
