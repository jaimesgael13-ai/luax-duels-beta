-- KILL SWITCH
local KILL_SWITCH_URL =
	"https://raw.githubusercontent.com/jaimesgael13-ai/luax-duels-beta/main/kill_switch.txt"

local ok, status = pcall(function()
	return game:HttpGet(KILL_SWITCH_URL)
end)

if not ok or string.lower(status):gsub("%s+", "") ~= "true" then
	warn("LUAX DUELS is currently disabled.")
	return
end
-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- REMOVE OLD GUI
if CoreGui:FindFirstChild("LUAX_DUELS") then
	CoreGui.LUAX_DUELS:Destroy()
end

-- COLORS
local red = Color3.fromRGB(255,0,80)
local purple = Color3.fromRGB(170,0,255)

-- MAIN GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "LUAX_DUELS"
ScreenGui.IgnoreGuiInset = true

-- TOP FRAME
local TopFrame = Instance.new("Frame", ScreenGui)
TopFrame.Size = UDim2.new(0,220,0,80)
TopFrame.Position = UDim2.new(0.5,-110,0,25)
TopFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner", TopFrame)

local TopStroke = Instance.new("UIStroke", TopFrame)
TopStroke.Thickness = 2

task.spawn(function()
	local t=0
	while true do
		t+=0.01
		TopStroke.Color = red:Lerp(purple, math.abs(math.sin(t)))
		RunService.RenderStepped:Wait()
	end
end)

-- TITLE
local Title = Instance.new("TextLabel", TopFrame)
Title.Size = UDim2.new(1,0,0.4,0)
Title.BackgroundTransparency = 1
Title.Text = "LUAX DUELS"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255,255,255)

-- FPS / PING
local StatsLabel = Instance.new("TextLabel", TopFrame)
StatsLabel.Position = UDim2.new(0,0,0.4,0)
StatsLabel.Size = UDim2.new(1,0,0.6,0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.TextSize = 15

task.spawn(function()
	local t=0
	while true do
		t+=0.02
		StatsLabel.TextColor3 = red:Lerp(purple, math.abs(math.sin(t)))
		RunService.RenderStepped:Wait()
	end
end)

local frameCount = 0
local lastTime = os.clock()
RunService.RenderStepped:Connect(function()
	frameCount += 1
	if os.clock() - lastTime >= 1 then
		local fps = frameCount
		frameCount = 0
		lastTime = os.clock()
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		StatsLabel.Text = "FPS: "..fps.." | PING: "..ping.."ms"
	end
end)

-- MAIN MENU
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,220,0,260)
MainFrame.Position = UDim2.new(0.5,-110,0.4,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local MenuStroke = Instance.new("UIStroke", MainFrame)
MenuStroke.Thickness = 2
task.spawn(function()
	local t=0
	while true do
		t+=0.01
		MenuStroke.Color = red:Lerp(purple, math.abs(math.sin(t)))
		RunService.RenderStepped:Wait()
	end
end)

-- MENU TITLE
local MenuTitle = Instance.new("TextLabel", MainFrame)
MenuTitle.Size = UDim2.new(1,0,0,40)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "LUAX DUELS"
MenuTitle.Font = Enum.Font.GothamBlack
MenuTitle.TextSize = 18
MenuTitle.TextColor3 = Color3.fromRGB(255,255,255)

-- BUTTON MAKER
local function MakeButton(text, y)
	local btn = Instance.new("TextButton", MainFrame)
	btn.Size = UDim2.new(1,-20,0,35)
	btn.Position = UDim2.new(0,10,0,y)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,35)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	Instance.new("UICorner", btn)
	return btn
end

-- TOGGLES
local AutoBat = false
local SpinBot = false

-- AUTO BAT BUTTON
local AutoBatBtn = MakeButton("AUTO BAT : OFF", 60)
AutoBatBtn.MouseButton1Click:Connect(function()
	AutoBat = not AutoBat
	AutoBatBtn.Text = "AUTO BAT : "..(AutoBat and "ON" or "OFF")
end)

-- SPINBOT BUTTON
local SpinBtn = MakeButton("SPINBOT : OFF", 105)
SpinBtn.MouseButton1Click:Connect(function()
	SpinBot = not SpinBot
	SpinBtn.Text = "SPINBOT : "..(SpinBot and "ON" or "OFF")
end)

-- COPY DISCORD BUTTON
local DiscordBtn = MakeButton("COPY DISCORD", 150)
DiscordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/EFYdtbE54")
	DiscordBtn.Text = "COPIED!"
	task.wait(1)
	DiscordBtn.Text = "COPY DISCORD"
end)

-- TOGGLE MENU BUTTON
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,45,0,45)
ToggleBtn.Position = UDim2.new(0,20,0.25,0)
ToggleBtn.Text = "LD"
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 14
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15,15,20)
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-------------------------
-- SPINBOT
-------------------------
local SpinForce
task.spawn(function()
	while true do
		task.wait(0.05)
		if SpinBot and LocalPlayer.Character then
			if not SpinForce then
				SpinForce = Instance.new("BodyAngularVelocity")
				SpinForce.MaxTorque = Vector3.new(0, math.huge, 0)
				SpinForce.AngularVelocity = Vector3.new(0, 25, 0)
				SpinForce.Parent = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
			end
		elseif SpinForce then
			SpinForce:Destroy()
			SpinForce = nil
		end
	end
end)

-------------------------
-- AUTO BAT (STABLE)
-------------------------
task.spawn(function()
	while true do
		task.wait(0.15)
		if AutoBat and LocalPlayer.Character then
			local char = LocalPlayer.Character
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not hum then continue end

			local bat = char:FindFirstChild("Bat") or LocalPlayer.Backpack:FindFirstChild("Bat")
			if bat and bat:IsA("Tool") then
				if bat.Parent ~= char then
					hum:EquipTool(bat)
				end
				if bat.Enabled then
					bat:Activate()
				end
			end
		end
	end
end)
