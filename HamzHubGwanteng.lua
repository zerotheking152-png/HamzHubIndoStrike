-- INDO STRIKE AUTO FISH - RAYFIELD UI + HMZ MINIMIZE (2026)
-- Paling work bro, executor apa pun support

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === REMOTES & HOOK ===
local rs = game:GetService("ReplicatedStorage")
local throwRemote = rs:WaitForChild("Fishing_RemoteThrow")
local fishing = rs:WaitForChild("Fishing")
local toServer = fishing:WaitForChild("ToServer")
local minigameStarted = toServer:WaitForChild("MinigameStarted")
local reelFinished = toServer:WaitForChild("ReelFinished")

local sessionID = nil
hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if self == throwRemote and getnamecallmethod() == "FireServer" then
        local args = {...}
        if typeof(args[2]) == "string" and #args[2] > 20 then
            sessionID = args[2]
        end
    end
    return oldNamecall(self, ...)
end))

-- === RAYFIELD WINDOW ===
local Window = Rayfield:CreateWindow({
    Name = "HMZ Hub | Indo Strike",
    LoadingTitle = "HMZ Hub",
    LoadingSubtitle = "Auto Fish Instant",
    ConfigurationSaving = { Enabled = false },
    Discord = "",
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458) -- icon bebas

local AutoFishToggle = MainTab:CreateToggle({
    Name = "Auto Fish (Instant Catch)",
    CurrentValue = false,
    Flag = "AutoFishFlag",
    Callback = function(Value)
        getgenv().AutoFish = Value
        if Value then
            if not sessionID then
                Rayfield:Notify({
                    Title = "⚠️ Info",
                    Content = "Cast manual 1x pake rod biasa dulu biar sessionID ke-capture!",
                    Duration = 6,
                    Image = 4483362458
                })
            end
            task.spawn(function()
                while getgenv().AutoFish do
                    if sessionID then
                        throwRemote:FireServer(0, sessionID)
                        task.wait(0.7)
                        minigameStarted:FireServer(sessionID)
                        task.wait(0.3)
                        local successArgs = {
                            ["duration"] = math.random(7.5, 12.5),
                            ["result"] = "SUCCESS",
                            ["insideRatio"] = 0.8 + (math.random(3,18)/100)
                        }
                        reelFinished:FireServer(successArgs, sessionID)
                        task.wait(1.5)
                    else
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

local BlatiToggle = MainTab:CreateToggle({
    Name = "Blati Mode",
    CurrentValue = false,
    Flag = "BlatiFlag",
    Callback = function(Value)
        getgenv().Blati = Value
        Rayfield:Notify({Title = "Blati", Content = Value and "ON 🔥" or "OFF", Duration = 3})
        -- Tambahin logic remote Blati lo di sini nanti
    end
})

-- === CUSTOM MINIMIZE HMZ ===
local HMZFrame = Instance.new("Frame")
HMZFrame.Size = UDim2.new(0, 130, 0, 50)
HMZFrame.Position = UDim2.new(1, -160, 1, -80)
HMZFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HMZFrame.Visible = false
HMZFrame.Parent = game.Players.LocalPlayer.PlayerGui
Instance.new("UICorner", HMZFrame).CornerRadius = UDim.new(0, 20)

local HMZLabel = Instance.new("TextLabel")
HMZLabel.Size = UDim2.new(1,0,1,0)
HMZLabel.BackgroundTransparency = 1
HMZLabel.Text = '<font color="rgb(0,162,255)">H</font><font color="rgb(255,215,0)">M</font><font color="rgb(255,50,50)">Z</font>'
HMZLabel.RichText = true
HMZLabel.TextScaled = true
HMZLabel.Font = Enum.Font.GothamBlack
HMZLabel.Parent = HMZFrame

-- Draggable + Click to restore
local dragging = false
HMZFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = HMZFrame.Position
    end
end)
HMZFrame.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        HMZFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function() dragging = false end)

HMZLabel.MouseButton1Click:Connect(function()
    Window:Restore()
    HMZFrame.Visible = false
end)

-- Tombol Minimize di Rayfield
MainTab:CreateButton({
    Name = "Minimize to HMZ Icon",
    Callback = function()
        Window:Minimize()
        HMZFrame.Visible = true
    end
})

Rayfield:Notify({
    Title = "✅ HMZ Hub Loaded!",
    Content = "Cast manual 1x dulu pake rod biasa. Klik Auto Fish setelah itu.",
    Duration = 8
})

print("🎉 Rayfield HMZ siap! Auto Fish pake script lo yang asli.")
