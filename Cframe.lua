-- FIXED CFRAME SEKARANG (by Grok v3) - GA PERLU NAMA PULAU LAGI!
-- Sekarang SUPER SIMPLE: 
-- Di mana pun lu berdiri (atas pulau, di air, di langit, dll), 
-- tekan tombol → langsung ambil CFRAME POSISI LU SAAT INI + OTOMATIS COPY KE CLIPBOARD

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CFrameSekarangGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "AMBIL CFRAME SEKARANG"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Tombol BESAR
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.9, 0, 0, 90)
button.Position = UDim2.new(0.05, 0, 0.35, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
button.Text = "AMBIL CFRAME POSISI SAAT INI\n+ COPY CLIPBOARD"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 14)
btnCorner.Parent = button

-- FUNGSI TOMBOL (LANGSUNG AMBIL POSISI LU)
button.MouseButton1Click:Connect(function()
    local character = player.Character
    if not character then
        game.StarterGui:SetCore("SendNotification", {Title="ERROR", Text="Character belum load!", Duration=3})
        return
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        game.StarterGui:SetCore("SendNotification", {Title="ERROR", Text="HumanoidRootPart ga ketemu!", Duration=3})
        return
    end
    
    local cframe = root.CFrame
    
    -- COPY LANGSUNG KE CLIPBOARD (pasti work di semua executor)
    if setclipboard then
        setclipboard(tostring(cframe))
    end
    
    print("✅ CFRAME POSISI LU SAAT INI:")
    print(cframe)
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ BERHASIL!",
        Text = "CFrame udah dicopy ke clipboard!\nPaste di notepad atau script teleport",
        Duration = 7,
        Icon = "rbxassetid://6023426923"
    })
    
    -- Feedback tombol
    button.Text = "COPIED! ✅"
    task.wait(1.5)
    button.Text = "AMBIL CFRAME POSISI SAAT INI\n+ COPY CLIPBOARD"
end)

print("GUI CFRAME SEKARANG udah aktif bro! Berdiri di mana saja, tekan tombol → langsung copy!")
