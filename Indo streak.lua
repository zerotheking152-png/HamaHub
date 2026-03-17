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
            if player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = true end
                end
            end
        end
    end
end)

WSSetBtn.MouseButton1Click:Connect(function()
    local value = tonumber(WSBox.Text)
    if value and humanoid then
        getgenv().WalkSpeedValue = value
        humanoid.WalkSpeed = value
        print("✅ WalkSpeed di-set ke " .. value)
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if humanoid then
        humanoid.WalkSpeed = getgenv().WalkSpeedValue
    end
end)

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local UserInputService = game:GetService("UserInputService")

local mainFrame = YourMainFrame

local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
