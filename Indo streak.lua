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

-- === SELL REMOTE (dari spy lo) ===
local sellRemote = ReplicatedStorage:WaitForChild("Economy"):WaitForChild("ToServer"):WaitForChild("SellUnder")

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
getgenv().AutoSell = false
getgenv().SellInterval = 180  -- default 3 menit (bisa diubah lewat box)

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

-- === RAYFIELD GUI ===
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "HamzHub",
    LoadingTitle = "HamzHub Is Loading",
    LoadingSubtitle = "",
    ShowText = "HamzHub",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = false,
    },
})

local MainTab = Window:CreateTab("MAIN", 4483362458)
local PlayerTab = Window:CreateTab("PLAYER", 4483362458)

-- === BLATI (Instant Fishing SUPER CEPET + SECRET) ===
local blatiLoop
local function startBlati()
    if blatiLoop then return end
    blatiLoop = task.spawn(function()
        while getgenv().Blati do
            if sessionID and humanoid then
                throwRemote:FireServer(0, sessionID)
                task.wait(0.0001)
                minigameStarted:FireServer(sessionID)
                task.wait(0.0001)
                local successArgs = {
                    ["duration"] = math.random(7.5, 12.5),
                    ["result"] = "SUCCESS",
                    ["insideRatio"] = 0.8 + (math.random(3, 18) / 100),
                    ["catchType"] = "SECRET",
                    ["isSecret"] = true
                }
                reelFinished:FireServer(successArgs, sessionID)
                task.wait(0.0001)
            else
                task.wait(0.0001)
            end
        end
    end)
end

MainTab:CreateToggle({
    Name = "BLATI (Instant Fishing)",
    CurrentValue = false,
    Flag = "BlatiFlag",
    Callback = function(Value)
        getgenv().Blati = Value
        if Value then
            startBlati()
            local args = {
	"bd4238ec-6bbc-4523-8c63-a17356e1f130"
}
game:GetService("ReplicatedStorage"):WaitForChild("FishUI"):WaitForChild("ToServer"):WaitForChild("ToggleFavorite"):FireServer(unpack(args))
        else
            if blatiLoop then task.cancel(blatiLoop) blatiLoop = nil end
        end
    end,
})

-- === PLAYER TAB ELEMENTS ===
local jumpConnection
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpFlag",
    Callback = function(Value)
        getgenv().InfiniteJump = Value
        if Value then
            if not jumpConnection then
                jumpConnection = UserInputService.JumpRequest:Connect(function()
                    if getgenv().InfiniteJump and humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        end
    end,
})

local noclipConnection
PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipFlag",
    Callback = function(Value)
        getgenv().Noclip = Value
        if Value then
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
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
                if player.Character then
                    for _, v in pairs(player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = true end
                    end
                end
            end
        end
    end,
})

PlayerTab:CreateInput({
    Name = "WalkSpeed",
    CurrentValue = "16",
    PlaceholderText = "16",
    RemoveTextAfterFocusLost = false,
    Flag = "WalkSpeedFlag",
    Callback = function(Text)
        local value = tonumber(Text)
        if value and humanoid then
            getgenv().WalkSpeedValue = value
            humanoid.WalkSpeed = value
        end
    end,
})

PlayerTab:CreateInput({
    Name = "Sell Every (min)",
    CurrentValue = "3",
    PlaceholderText = "3",
    RemoveTextAfterFocusLost = false,
    Flag = "SellIntervalFlag",
    Callback = function(Text)
        local val = tonumber(Text)
        if val and val >= 1 and val <= 200 then
            getgenv().SellInterval = val * 60
        end
    end,
})

local autoSellLoop
local function startAutoSell()
    if autoSellLoop then return end
    autoSellLoop = task.spawn(function()
        while getgenv().AutoSell do
            if sellRemote then
                sellRemote:FireServer(1000)
            end
            task.wait(getgenv().SellInterval)
        end
    end)
end

PlayerTab:CreateToggle({
    Name = "AUTO SELL",
    CurrentValue = false,
    Flag = "AutoSellFlag",
    Callback = function(Value)
        getgenv().AutoSell = Value
        if Value then
            startAutoSell()
        else
            if autoSellLoop then task.cancel(autoSellLoop) autoSellLoop = nil end
        end
    end,
})

-- Auto update walkspeed kalau character respawn
player.CharacterAdded:Connect(function()
    task.wait(1)
    if humanoid then
        humanoid.WalkSpeed = getgenv().WalkSpeedValue
    end
end)

-- === ANTI AFK ===
local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

print("🎉 HAMZHUB GUI KEREN udah muncul bro! Tab MAIN & PLAYER siap. Cast manual 1x dulu biar Blati nyala. Gas polll 🔥")
