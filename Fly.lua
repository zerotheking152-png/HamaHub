-- FLY SCRIPT HP (Mobile Friendly) FULL GUI - by Grok
-- Work di Fluxus, Solara, Delta, dll (PC & HP)
-- Joystick HP buat maju/mundur/kiri/kanan + tombol UP/DOWN buat naik/turun

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Tunggu character
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Variabel fly
local flying = false
local flyConnection = nil
local bodyGyro = nil
local currentSpeed = 50
local ascending = false
local descending = false

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyHPGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 420)
frame.Position = UDim2.new(0.5, -160, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "FLY SCRIPT HP"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 70)
toggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleButton.Text = "START FLY"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleButton

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.45, 0, 0, 40)
speedLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = frame

-- + Button
local plusButton = Instance.new("TextButton")
plusButton.Size = UDim2.new(0.2, 0, 0, 40)
plusButton.Position = UDim2.new(0.55, 0, 0.35, 0)
plusButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
plusButton.Text = "+"
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plusButton.TextScaled = true
plusButton.Font = Enum.Font.GothamBold
plusButton.Parent = frame
local pCorner = Instance.new("UICorner"); pCorner.Parent = plusButton

-- - Button
local minusButton = Instance.new("TextButton")
minusButton.Size = UDim2.new(0.2, 0, 0, 40)
minusButton.Position = UDim2.new(0.78, 0, 0.35, 0)
minusButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
minusButton.Text = "-"
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minusButton.TextScaled = true
minusButton.Font = Enum.Font.GothamBold
minusButton.Parent = frame
local mCorner = Instance.new("UICorner"); mCorner.Parent = minusButton

-- UP Button (hold)
local upButton = Instance.new("TextButton")
upButton.Size = UDim2.new(0.42, 0, 0, 80)
upButton.Position = UDim2.new(0.05, 0, 0.52, 0)
upButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
upButton.Text = "UP\n(NAIK)"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.TextScaled = true
upButton.Font = Enum.Font.GothamBold
upButton.Parent = frame
local upCorner = Instance.new("UICorner"); upCorner.Parent = upButton

-- DOWN Button (hold)
local downButton = Instance.new("TextButton")
downButton.Size = UDim2.new(0.42, 0, 0, 80)
downButton.Position = UDim2.new(0.53, 0, 0.52, 0)
downButton.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
downButton.Text = "DOWN\n(TURUN)"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.TextScaled = true
downButton.Font = Enum.Font.GothamBold
downButton.Parent = frame
local downCorner = Instance.new("UICorner"); downCorner.Parent = downButton

-- Update speed label
local function updateSpeed()
	speedLabel.Text = "Speed: " .. currentSpeed
end

-- Speed control
plusButton.MouseButton1Click:Connect(function()
	currentSpeed = math.min(currentSpeed + 10, 500)
	updateSpeed()
end)

minusButton.MouseButton1Click:Connect(function()
	currentSpeed = math.max(currentSpeed - 10, 10)
	updateSpeed()
end)

-- Hold UP & DOWN
upButton.MouseButton1Down:Connect(function() ascending = true end)
upButton.MouseButton1Up:Connect(function() ascending = false end)

downButton.MouseButton1Down:Connect(function() descending = true end)
downButton.MouseButton1Up:Connect(function() descending = false end)

-- Fungsi utama FLY
local function toggleFly()
	flying = not flying
	
	if flying then
		-- SETUP FLY
		humanoid.PlatformStand = true
		humanoid.AutoRotate = false
		
		if not bodyGyro then
			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			bodyGyro.P = 10000
			bodyGyro.Parent = rootPart
		end
		
		flyConnection = RunService.Heartbeat:Connect(function()
			if not flying or not rootPart or not humanoid then return end
			
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			
			local moveDir = humanoid.MoveDirection
			local vert = 0
			if ascending then vert = vert + currentSpeed end
			if descending then vert = vert - currentSpeed end
			
			rootPart.AssemblyLinearVelocity = moveDir * currentSpeed + Vector3.new(0, vert, 0)
		end)
		
		toggleButton.Text = "STOP FLY"
		toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		
		game.StarterGui:SetCore("SendNotification", {
			Title = "✅ FLY ON",
			Text = "Joystick HP buat arah\nTahan UP/DOWN buat naik/turun",
			Duration = 6
		})
		
	else
		-- STOP FLY
		if flyConnection then
			flyConnection:Disconnect()
			flyConnection = nil
		end
		if bodyGyro then
			bodyGyro:Destroy()
			bodyGyro = nil
		end
		if humanoid then
			humanoid.PlatformStand = false
			humanoid.AutoRotate = true
		end
		if rootPart then
			rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		end
		
		toggleButton.Text = "START FLY"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		
		game.StarterGui:SetCore("SendNotification", {
			Title = "🛑 FLY OFF",
			Text = "Mendarat aman bro!",
			Duration = 3
		})
	end
end

toggleButton.MouseButton1Click:Connect(toggleFly)

-- Handle respawn (kalau mati)
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	rootPart = newChar:WaitForChild("HumanoidRootPart")
	if flying then
		game.StarterGui:SetCore("SendNotification", {
			Title = "Respawn",
			Text = "Toggle fly lagi ya (OFF dulu trus ON)",
			Duration = 5
		})
	end
end)

updateSpeed()
print("🚀 Fly GUI HP udah aktif! Tekan START FLY dan terbang kemana-mana bro!")
