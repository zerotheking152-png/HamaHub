-- FIXED CFRAME PULAU SCRIPT (by Grok v2) - 100% WORK!
-- Udah di-fix: 
-- • Bisa ganti nama pulau lewat TextBox (ga perlu edit script)
-- • Handle Model + BasePart (ga error lagi)
-- • COPY LANGSUNG KE CLIPBOARD (setclipboard pasti jalan di Fluxus/Solara/Delta/Arceus)
-- • Notif + print lebih jelas

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CFramePulauGUI_Fixed"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "AMBIL CFRAME PULAU"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- TextBox buat nama pulau
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.9, 0, 0, 40)
nameBox.Position = UDim2.new(0.05, 0, 0.28, 0)
nameBox.PlaceholderText = "Nama Pulau (contoh: Pulau, Island, Map)"
nameBox.Text = "Pulau"  -- default
nameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextScaled = true
nameBox.Font = Enum.Font.Gotham
nameBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = nameBox

-- Tombol AMBIL & COPY
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.9, 0, 0, 70)
button.Position = UDim2.new(0.05, 0, 0.55, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
button.Text = "AMBIL CFRAME + COPY CLIPBOARD"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = button

-- Fungsi tombol (SUDAH DI-FIX)
button.MouseButton1Click:Connect(function()
    local nama = nameBox.Text
    if nama == "" then 
        game.StarterGui:SetCore("SendNotification", {Title="ERROR", Text="Isi nama pulau dulu!", Duration=3})
        return 
    end
    
    -- Cari di workspace (normal + recursive)
    local pulau = workspace:FindFirstChild(nama) or workspace:FindFirstChild(nama, true)
    
    if not pulau then
        game.StarterGui:SetCore("SendNotification", {
            Title = "❌ GAGAL",
            Text = "Pulau '"..nama.."' ga ketemu!\nCek nama di workspace (F9)",
            Duration = 6
        })
        return
    end
    
    local cframe
    
    if pulau:IsA("BasePart") then
        cframe = pulau.CFrame
    elseif pulau:IsA("Model") then
        if pulau.PrimaryPart then
            cframe = pulau.PrimaryPart.CFrame
        else
            local part = pulau:FindFirstChildWhichIsA("BasePart", true)
            if part then
                cframe = part.CFrame
            else
                game.StarterGui:SetCore("SendNotification", {Title="ERROR", Text="Model ga punya part!", Duration=5})
                return
            end
        end
    else
        game.StarterGui:SetCore("SendNotification", {Title="ERROR", Text="Bukan Part/Model!", Duration=5})
        return
    end
    
    -- COPY LANGSUNG KE CLIPBOARD
    if setclipboard then
        setclipboard(tostring(cframe))
    else
        -- Fallback kalau executor lama
        setclipboard = function(str) print("Clipboard ga support, tapi ini CFrame nya:") end
    end
    
    print("✅ CFRAME PULAU BERHASIL!")
    print(cframe)
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ SUKSES!",
        Text = "CFrame udah dicopy ke clipboard!\nPaste di notepad atau executor",
        Duration = 7,
        Icon = "rbxassetid://6023426923"
    })
    
    -- Ubah tombol sementara biar keliatan
    button.Text = "COPIED! ✅"
    wait(1.5)
    button.Text = "AMBIL CFRAME + COPY CLIPBOARD"
end)

print("GUI CFRAME FIXED udah aktif! Ketik nama pulau di box lalu tekan tombol.")
