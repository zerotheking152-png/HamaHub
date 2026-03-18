-- Script CFrame Pulau (by Grok buat lu)
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CFramePulauGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Corner biar cantik
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.4, 0)
title.BackgroundTransparency = 1
title.Text = "AMBIL CFRAME PULAU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Tombol AMBIL CFRAME
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.9, 0, 0.4, 0)
button.Position = UDim2.new(0.05, 0, 0.55, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.Text = "AMBIL CFRAME PULAU"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

-- Fungsi tombol
button.MouseButton1Click:Connect(function()
    -- GANTI NAMA INI KALAU PULAU LU BEDA NAMA!!!
    local pulau = workspace:FindFirstChild("Pulau") -- atau workspace.Pulau atau workspace.Island
    
    if pulau and pulau:IsA("BasePart") or pulau:IsA("Model") then
        local cframe = pulau.CFrame
        
        -- Tampil di console + notif
        print("✅ CFRAME PULAU DIDAPET:")
        print(cframe)
        
        -- Copy otomatis ke clipboard (kalau lu pake executor seperti Fluxus, Solara, dll)
        if setclipboard then
            setclipboard(tostring(cframe))
            game.StarterGui:SetCore("SendNotification", {
                Title = "SUKSES!",
                Text = "CFrame Pulau udah dicopy ke clipboard!",
                Duration = 5,
                Icon = "rbxassetid://6023426923"
            })
        else
            -- Kalau ga ada setclipboard, tampil di GUI
            title.Text = "CFrame: " .. tostring(cframe)
            game.StarterGui:SetCore("SendNotification", {
                Title = "CFRAME DIDAPET",
                Text = "Cek console (F9) buat full CFrame",
                Duration = 5
            })
        end
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "ERROR",
            Text = "Pulau ga ketemu! Ganti nama di script jadi nama pulau lu",
            Duration = 5
        })
    end
end)

print("GUI CFrame Pulau udah aktif! Tekan tombol 'AMBIL CFRAME PULAU'")
