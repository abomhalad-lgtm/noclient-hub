local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

print("[HUB] Loading client interface...")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoClientHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "OpenToggle"
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -22)
toggleBtn.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
toggleBtn.Text = "⚡"
toggleBtn.TextColor3 = Color3.fromRGB(0, 195, 255)
toggleBtn.TextSize = 20
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Active = true
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.5, 0)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(0, 170, 255)
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleBtn

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 460, 0, 500)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(0, 150, 255)
frameStroke.Thickness = 2
frameStroke.Parent = mainFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(18, 24, 40)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "🌐 NOCLIENT HUB v4.0 | EXECUTOR"
title.TextColor3 = Color3.fromRGB(0, 225, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

local cmdInput = Instance.new("TextBox")
cmdInput.Size = UDim2.new(0.9, 0, 0, 38)
cmdInput.Position = UDim2.new(0.05, 0, 0, 55)
cmdInput.PlaceholderText = "اكتب اسم اللاعب هنا ثم اضغط الزر..."
cmdInput.Text = ""
cmdInput.BackgroundColor3 = Color3.fromRGB(20, 28, 48)
cmdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
cmdInput.PlaceholderColor3 = Color3.fromRGB(120, 150, 180)
cmdInput.Font = Enum.Font.Gotham
cmdInput.TextSize = 13
cmdInput.Parent = mainFrame

local cmdCorner = Instance.new("UICorner")
cmdCorner.CornerRadius = UDim.new(0, 8)
cmdCorner.Parent = cmdInput

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0.9, 0, 0, 380)
scroll.Position = UDim2.new(0.05, 0, 0, 105)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
scroll.Parent = mainFrame

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.48, 0, 0, 42)
grid.CellPadding = UDim2.new(0.04, 0, 0.02, 0)
grid.Parent = scroll

grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 15)
end)

local isOpen = true
local function toggleUI()
	isOpen = not isOpen
	mainFrame.Visible = isOpen
end

toggleBtn.MouseButton1Click:Connect(toggleUI)
closeBtn.MouseButton1Click:Connect(toggleUI)

local function sendRemote(remoteName, ...)
	print("[HUB] Sending request payload...")
	local remotesFolder = ReplicatedStorage:FindFirstChild("HackerServicesRemotes")
	if remotesFolder then
		local remote = remotesFolder:FindFirstChild(remoteName)
		if remote then
			remote:FireServer(...)
			print("[HUB] Payload dispatched successfully.")
		else
			warn("[HUB] Target endpoint not found.")
		end
	else
		warn("[HUB] Container missing.")
	end
end

local function parseAndExecute(txt, isChat)
	txt = string.gsub(txt, "^%s*(.-)%s*$", "%1")
	if txt == "" then return end

	if isChat then
		if string.sub(txt, 1, 1) == ";" then
			txt = string.sub(txt, 2)
		else
			return
		end
	else
		if string.sub(txt, 1, 1) == ";" then
			txt = string.sub(txt, 2)
		end
	end

	local args = string.split(txt, " ")
	local cmd = string.lower(args[1] or "")
	local arg1 = args[2] or ""
	local arg2 = args[3] or ""
	local arg3 = args[4] or ""

	print("[HUB] Executing command opcode:", cmd)

	if cmd == "kill" then
		sendRemote("Service_KillPlayer", arg1)
	elseif cmd == "bring" then
		sendRemote("Service_BringPlayer", arg1)
	elseif cmd == "fling" then
		sendRemote("Service_FlingPlayer", arg1)
	elseif cmd == "freeze" then
		sendRemote("Service_FreezePlayer", arg1)
	elseif cmd == "explode" then
		sendRemote("Service_ExplodePlayer", arg1)
	elseif cmd == "ff" then
		sendRemote("Service_ForceField", arg1)
	elseif cmd == "kick" then
		sendRemote("Service_KickPlayer", arg1, arg2)
	elseif cmd == "ban" then
		sendRemote("Service_BanPlayer", arg1, arg2)
	elseif cmd == "outfit" then
		sendRemote("Service_ChangeOutfit", arg1, arg2)
	elseif cmd == "hp" then
		sendRemote("Service_SetHealth", arg1, arg2)
	elseif cmd == "time" then
		local timeNum = tonumber(arg1)
		if timeNum then
			local isClient = string.lower(arg2) == "client" or string.lower(arg3) == "client"
			if isClient then
				Lighting.ClockTime = timeNum
			else
				sendRemote("Service_SetLighting", tostring(timeNum))
			end
		end
	end
end

LocalPlayer.Chatted:Connect(function(msg)
	parseAndExecute(msg, true)
end)

cmdInput.FocusLost:Connect(function(enter)
	if enter then
		parseAndExecute(cmdInput.Text, false)
		cmdInput.Text = ""
	end
end)

local function createButton(cmdName, btnLabel)
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = Color3.fromRGB(18, 26, 44)
	btn.Text = btnLabel
	btn.TextColor3 = Color3.fromRGB(0, 210, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = scroll

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 6)
	bCorner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		if cmdInput.Text == "" then
			cmdInput.Text = cmdName .. " "
			cmdInput:CaptureFocus()
		else
			parseAndExecute(cmdName .. " " .. cmdInput.Text, false)
			cmdInput.Text = ""
		end
	end)
end

createButton("kill", "Kill")
createButton("bring", "Bring")
createButton("fling", "Fling")
createButton("freeze", "Freeze")
createButton("explode", "Explode")
createButton("ff", "ForceField")
createButton("kick", "Kick")
createButton("ban", "Ban")
createButton("outfit", "Outfit")
createButton("time", "Time")