-- INDO STRIKE HMZ HUB - FLUENT UI + MINIMIZE HMZ (H Biru - M Kuning - Z Merah)
-- Execute di Fluxus/Delta/Wave/Solara dll

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- === REMOTES & HOOK SESSION ID ===
local rs = game:GetService("ReplicatedStorage")
local throwRemote = rs:WaitForChild("Fishing_RemoteThrow")
local fishing = rs:WaitForChild("Fishing")
local toServer = fishing:WaitForChild("ToServer")
local minigameStarted = toServer:WaitForChild("MinigameStarted")
local reelFinished = toServer:WaitForChild("ReelFinished")

local sessionID = nil
local oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if getnamecallmethod() == "FireServer" and self == throwRemote then
        local args = {...}
        if typeof(args[2]) == "string" and #args[2] > 20 then
            sessionID = args[2]
        end
    end
    return oldNamecall(self, ...)
end))

-- === FLUENT WINDOW ===
local Window = Fluent:CreateWindow({
    Title = "HMZ Hub | Indo Strike",
    SubTitle = "Auto Fish + Blati",
    TabWidth = 180,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift  -- tekan RightShift juga bisa minimize
})

local MainTab = Window:AddTab({ Title = "Main Features" })

-- === AUTO FISH TOGGLE ===
local AutoFishEnabled = false
local autoFishLoop = nil

MainTab:AddToggle("AutoFish", {
    Title = "Auto Fish (Instant Catch)",
    Default = false,
    Callback = function(Value)
        AutoFishEnabled = Value
        if Value then
            if not sessionID then
                Fluent:Notify({
                    Title = "Info",
                    Content = "Cast manual 1x pake rod dulu biar sessionID ke-capture!",
                    Duration = 5
                })
            end
            autoFishLoop = task.spawn(function()
                while AutoFishEnabled do
                    if sessionID then
                        throwRemote:FireServer(0, sessionID)
                        task.wait(0.7)
                        minigameStarted:FireServer(sessionID)
                        task.wait(0.3)
                        
                        local successArgs = {
                            ["duration"] = math.random(7.5, 12.5),
                            ["result"] = "SUCCESS",
                            ["insideRatio"] = 0.8 + (math.random(3, 18) / 100)
                        }
                        reelFinished:FireServer(successArgs, sessionID)
                        task.wait(1.5)
                    else
                        task.wait(0.5)
                    end
                end
            end)
        else
            if autoFishLoop then task.cancel(autoFishLoop) end
        end
    end
})

-- === BLATI TOGGLE (siap diisi nanti) ===
MainTab:AddToggle("Blati", {
    Title = "Blati Mode",
    Default = false,
    Callback = function(Value)
        if Value then
            Fluent:Notify({Title = "Blati", Content = "Blati ON! (tambahin logic remote lo di sini)", Duration = 3})
            -- <<< TEMPAT LOGIC BLATI LO NANTI >>>
        else
            Fluent:Notify({Title = "Blati", Content = "Blati OFF", Duration = 3})
        end
    end
})

-- === MINIMIZE BUTTON + CUSTOM HMZ UI ===
MainTab:AddButton({
    Title = "Minimize to HMZ Icon",
    Description = "Klik ini → GUI ilang, tinggal HMZ kecil",
    Callback = function()
        Window:Minimize()
        HMZFrame.Visible = true
    end
})

-- === CUSTOM MINIMIZE UI (HMZ) ===
local HMZFrame = Instance.new("Frame")
HMZFrame.Size = UDim2.new(0, 120, 0, 40)
HMZFrame.Position = UDim2.new(1, -140, 1, -60)
HMZFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
HMZFrame.BorderSizePixel = 0
HMZFrame.Visible = false
HMZFrame.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Corner + Stroke biar keren
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = HMZFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 2
Stroke.Parent = HMZFrame

-- Tulisan HMZ (H Biru, M Kuning, Z Merah)
local HMZLabel = Instance.new("TextLabel")
HMZLabel.Size = UDim2.new(1, 0, 1, 0)
HMZLabel.BackgroundTransparency = 1
HMZLabel.Text = '<font color="rgb(0,162,255)">H</font><font color="rgb(255,215,0)">M</font><font color="rgb(255,50,50)">Z</font>'
HMZLabel.TextScaled = true
HMZLabel.RichText = true
HMZLabel.Font = Enum.Font.GothamBold
HMZLabel.TextColor3 = Color3.new(1,1,1)
HMZLabel.Parent = HMZFrame

-- Draggable HMZ
local dragging = false
HMZFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = HMZFrame.Position
    end
end)
HMZFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        HMZFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Klik HMZ → Restore GUI
HMZLabel.MouseButton1Click:Connect(function()
    Window:Restore()
    HMZFrame.Visible = false
end)

Fluent:Notify({
    Title = "HMZ Hub Loaded!",
    Content = "Cast manual 1x dulu biar Auto Fish jalan. Minimize pake tombol atau RightShift.",
    Duration = 6
})

print("🎉 HMZ Fluent GUI siap! H Biru - M Kuning - Z Merah")
