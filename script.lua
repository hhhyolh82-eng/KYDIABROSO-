-- KYDIABROSO Script Hub | Build A Boat For Treasure
-- Version: 2.2 | GitHub Edition | Full Working
-- Optimized for loadstring hosting

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- State Manager
local KState = {
	AutoFarmCoins = false,
	AutoFarmXP = false,
	AutoCollectResources = false,
	InfiniteMaterials = false,
	AutoRepair = false,
	Fly = false,
	Speed = false,
	Noclip = false,
	FlySpeed = 100,
	WalkSpeed = 50,
	JumpPower = 50,
	CoinFarmDelay = 5,
}

-- Utility Functions
local function SafeGUID()
	return HttpService:GenerateGUID(false):sub(1, 8)
end

local function GetCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoidAndHRP()
	local char = GetCharacter()
	return char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KYDIABROSO_" .. SafeGUID()
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 212, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(123, 47, 252))
})
Gradient.Transparency = NumberSequence.new(0.93, 0.93)
Gradient.Rotation = 135
Gradient.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 212, 255)
Stroke.Thickness = 1.2
Stroke.Transparency = 0.5
Stroke.Parent = MainFrame

-- Glass overlay
local Glass = Instance.new("Frame")
Glass.Size = UDim2.new(1, 0, 1, 0)
Glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Glass.BackgroundTransparency = 0.94
Glass.BorderSizePixel = 0
Glass.ZIndex = 2
Glass.Parent = MainFrame
Instance.new("UICorner", Glass).CornerRadius = UDim.new(0, 14)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.Position = UDim2.new(0, 0, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "KYDIABROSO"
Title.TextColor3 = Color3.fromRGB(0, 212, 255)
Title.TextSize = 26
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 5
Title.Parent = MainFrame

-- Glow effect
local Glow = Instance.new("TextLabel")
Glow.Size = Title.Size
Glow.Position = Title.Position + UDim2.new(0, 0, 0, 1)
Glow.BackgroundTransparency = 1
Glow.Text = "KYDIABROSO"
Glow.TextColor3 = Color3.fromRGB(123, 47, 252)
Glow.TextSize = 26
Glow.Font = Enum.Font.GothamBold
Glow.TextTransparency = 0.75
Glow.ZIndex = 4
Glow.Parent = MainFrame

-- Close button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 32, 0, 32)
Close.Position = UDim2.new(1, -38, 0, 6)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.TextSize = 24
Close.Font = Enum.Font.GothamBold
Close.ZIndex = 6
Close.Parent = MainFrame

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Tab System
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(1, -20, 0, 36)
TabButtons.Position = UDim2.new(0, 10, 0, 48)
TabButtons.BackgroundTransparency = 1
TabButtons.ZIndex = 5
TabButtons.Parent = MainFrame

local TabBtnLayout = Instance.new("UIListLayout")
TabBtnLayout.FillDirection = Enum.FillDirection.Horizontal
TabBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabBtnLayout.Padding = UDim.new(0, 8)
TabBtnLayout.Parent = TabButtons

local TabContent = Instance.new("Frame")
TabContent.Size = UDim2.new(1, -20, 1, -94)
TabContent.Position = UDim2.new(0, 10, 0, 88)
TabContent.BackgroundTransparency = 1
TabContent.ZIndex = 5
TabContent.Parent = MainFrame

local Tabs = {}

-- Tab Creator
local function CreateTab(name, icon)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0, 108, 1, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
	Btn.BackgroundTransparency = 0.3
	Btn.Text = icon .. " " .. name
	Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	Btn.TextSize = 12
	Btn.Font = Enum.Font.GothamSemibold
	Btn.BorderSizePixel = 0
	Btn.ZIndex = 6
	Btn.Parent = TabButtons
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

	local Frame = Instance.new("ScrollingFrame")
	Frame.Name = name
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.ScrollBarThickness = 3
	Frame.ScrollBarImageColor3 = Color3.fromRGB(0, 212, 255)
	Frame.Visible = false
	Frame.ZIndex = 5
	Frame.Parent = TabContent

	local List = Instance.new("UIListLayout")
	List.Padding = UDim.new(0, 8)
	List.Parent = Frame

	Tabs[name] = {Button = Btn, Frame = Frame}

	Btn.MouseButton1Click:Connect(function()
		for _, t in pairs(Tabs) do
			t.Frame.Visible = false
			t.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
			t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
		end
		Frame.Visible = true
		Btn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
		Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)

	return Frame
end

-- Toggle Creator
local function CreateToggle(parent, text, key)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 42)
	Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 40)
	Frame.BackgroundTransparency = 0.35
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.65, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.TextSize = 14
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 7
	Label.Parent = Frame

	local ToggleBg = Instance.new("TextButton")
	ToggleBg.Size = UDim2.new(0, 46, 0, 24)
	ToggleBg.Position = UDim2.new(1, -56, 0.5, -12)
	ToggleBg.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
	ToggleBg.BorderSizePixel = 0
	ToggleBg.Text = ""
	ToggleBg.ZIndex = 7
	ToggleBg.Parent = Frame
	Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 20, 0, 20)
	Circle.Position = UDim2.new(0, 2, 0.5, -10)
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.BorderSizePixel = 0
	Circle.ZIndex = 8
	Circle.Parent = ToggleBg
	Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

	local isOn = KState[key]

	local function Update()
		if isOn then
			TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 212, 255)}):Play()
			TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
		else
			TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 75)}):Play()
			TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
		end
		KState[key] = isOn
	end

	Update()
	ToggleBg.MouseButton1Click:Connect(function()
		isOn = not isOn
		Update()
	end)
end

-- Slider Creator
local function CreateSlider(parent, text, min, max, default, key, suffix)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 58)
	Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 40)
	Frame.BackgroundTransparency = 0.35
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 0, 22)
	Label.Position = UDim2.new(0, 12, 0, 4)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.TextSize = 13
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 7
	Label.Parent = Frame

	local ValueLbl = Instance.new("TextLabel")
	ValueLbl.Size = UDim2.new(0.3, 0, 0, 22)
	ValueLbl.Position = UDim2.new(0.7, -10, 0, 4)
	ValueLbl.BackgroundTransparency = 1
	ValueLbl.Text = tostring(default) .. (suffix or "")
	ValueLbl.TextColor3 = Color3.fromRGB(0, 212, 255)
	ValueLbl.TextSize = 13
	ValueLbl.Font = Enum.Font.GothamBold
	ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
	ValueLbl.ZIndex = 7
	ValueLbl.Parent = Frame

	local SliderBg = Instance.new("Frame")
	SliderBg.Size = UDim2.new(1, -24, 0, 6)
	SliderBg.Position = UDim2.new(0, 12, 0, 38)
	SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
	SliderBg.BorderSizePixel = 0
	SliderBg.ZIndex = 7
	SliderBg.Parent = Frame
	Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	Fill.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
	Fill.BorderSizePixel = 0
	Fill.ZIndex = 8
	Fill.Parent = SliderBg
	Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

	local Hitbox = Instance.new("TextButton")
	Hitbox.Size = UDim2.new(1, 0, 1, 14)
	Hitbox.Position = UDim2.new(0, 0, 0, -7)
	Hitbox.BackgroundTransparency = 1
	Hitbox.Text = ""
	Hitbox.ZIndex = 9
	Hitbox.Parent = SliderBg

	local dragging = false

	local function Update(input)
		local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + (max - min) * pos)
		KState[key] = val
		ValueLbl.Text = tostring(val) .. (suffix or "")
		Fill.Size = UDim2.new(pos, 0, 1, 0)
	end

	Hitbox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			Update(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			Update(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- Button Creator
local function CreateButton(parent, text, callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 42)
	Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 40)
	Frame.BackgroundTransparency = 0.35
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 1, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 230)
	Btn.BackgroundTransparency = 0.65
	Btn.BorderSizePixel = 0
	Btn.Text = text
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 14
	Btn.Font = Enum.Font.GothamBold
	Btn.ZIndex = 7
	Btn.Parent = Frame
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.35}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.65}):Play()
	end)
	Btn.MouseButton1Click:Connect(callback)
end

-- ==================== TABS ====================

-- Tab: Farm
local FarmTab = CreateTab("Фарм", "⚡")
CreateToggle(FarmTab, "Автофарм монет", "AutoFarmCoins")
CreateSlider(FarmTab, "Задержка фарма", 1, 20, 5, "CoinFarmDelay", " (0.1с)")
CreateToggle(FarmTab, "Автофарм опыта", "AutoFarmXP")
CreateToggle(FarmTab, "Автосбор ресурсов", "AutoCollectResources")

-- Tab: Build
local BuildTab = CreateTab("Билд", "🏗️")
CreateToggle(BuildTab, "Бесконечные материалы", "InfiniteMaterials")
CreateToggle(BuildTab, "Авто-чинка корабля", "AutoRepair")
CreateButton(BuildTab, "Автопостройка корабля", function()
	pcall(function()
		local tool = GetCharacter():FindFirstChildOfClass("Tool")
		if tool then
			local event = tool:FindFirstChild("BuildEvent") or tool:FindFirstChild("PlaceBlock")
			if event then
				local mouse = LocalPlayer:GetMouse()
				event:FireServer(mouse.Hit.Position, CFrame.new())
			end
		end
	end)
end)
CreateButton(BuildTab, "Мгновенная установка блоков", function()
	pcall(function()
		local tool = GetCharacter():FindFirstChildOfClass("Tool")
		if tool then
			local event = tool:FindFirstChild("BuildEvent") or tool:FindFirstChild("PlaceBlock")
			if event then
				local mouse = LocalPlayer:GetMouse()
				event:FireServer(mouse.Hit.Position, CFrame.new())
			end
		end
	end)
end)

-- Tab: Transport
local TransTab = CreateTab("Транспорт", "🚀")
CreateToggle(TransTab, "Fly (Полет)", "Fly")
CreateSlider(TransTab, "Скорость полета", 10, 500, 100, "FlySpeed", "")
CreateToggle(TransTab, "Speed (Скорость)", "Speed")
CreateSlider(TransTab, "Множитель скорости", 10, 200, 50, "WalkSpeed", "")
CreateSlider(TransTab, "Jump Power", 10, 200, 50, "JumpPower", "")
CreateToggle(TransTab, "Noclip", "Noclip")
CreateButton(TransTab, "Телепорт на старт", function()
	pcall(function()
		local spawnLoc = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Start")
		if spawnLoc and spawnLoc:IsA("BasePart") then
			local _, hrp = GetHumanoidAndHRP()
			hrp.CFrame = spawnLoc.CFrame + Vector3.new(0, 5, 0)
		end
	end)
end)
CreateButton(TransTab, "Телепорт к финишу", function()
	pcall(function()
		local _, hrp = GetHumanoidAndHRP()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj.Name:lower():find("treasure") or obj.Name:lower():find("chest") or obj.Name:lower():find("endzone") then
				if obj:IsA("BasePart") then
					hrp.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
					break
				end
			end
		end
	end)
end)

-- Tab: Settings
local SetTab = CreateTab("Настройки", "⚙️")
CreateButton(SetTab, "Сбросить все функции", function()
	for k, v in pairs(KState) do
		if type(v) == "boolean" then
			KState[k] = false
		end
	end
end)

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -10, 0, 90)
Info.BackgroundTransparency = 1
Info.Text = "KYDIABROSO v2.2\nBuild A Boat For Treasure\nGitHub Edition\nУправление полетом: W/A/S/D | Space | LShift"
Info.TextColor3 = Color3.fromRGB(140, 140, 160)
Info.TextSize = 12
Info.Font = Enum.Font.Gotham
Info.TextWrapped = true
Info.ZIndex = 6
Info.Parent = SetTab

-- Activate first tab
local firstTab = true
for _, tab in pairs(Tabs) do
	if firstTab then
		tab.Frame.Visible = true
		tab.Button.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
		tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		firstTab = false
	end
end

-- ==================== FEATURE LOGIC ====================

-- Fly System
local FlyBV, FlyBG, FlyConn

local function StartFly()
	if FlyBV then FlyBV:Destroy() end
	if FlyBG then FlyBG:Destroy() end

	local _, hrp = GetHumanoidAndHRP()
	FlyBV = Instance.new("BodyVelocity")
	FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	FlyBV.Velocity = Vector3.zero
	FlyBV.Parent = hrp

	FlyBG = Instance.new("BodyGyro")
	FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	FlyBG.P = 9e4
	FlyBG.Parent = hrp

	FlyConn = RunService.RenderStepped:Connect(function()
		if not KState.Fly then return end
		local cam = Camera
		local dir = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, 1, 0) end

		if dir.Magnitude > 0 then dir = dir.Unit * KState.FlySpeed end
		FlyBV.Velocity = dir
		FlyBG.CFrame = cam.CFrame
	end)
end

local function StopFly()
	if FlyConn then FlyConn:Disconnect() end
	if FlyBV then FlyBV:Destroy() end
	if FlyBG then FlyBG:Destroy() end
	FlyConn, FlyBV, FlyBG = nil, nil, nil
end

-- Noclip
local NoclipConn
local function StartNoclip()
	NoclipConn = RunService.Stepped:Connect(function()
		if KState.Noclip then
			for _, part in pairs(GetCharacter():GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)
end

local function StopNoclip()
	if NoclipConn then NoclipConn:Disconnect() end
	NoclipConn = nil
	for _, part in pairs(GetCharacter():GetDescendants()) do
		if part:IsA("BasePart") then part.CanCollide = true end
	end
end

-- AutoFarm Coins
task.spawn(function()
	while true do
		if KState.AutoFarmCoins then
			pcall(function()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if not KState.AutoFarmCoins then break end
					if obj.Name:lower():find("coin") or obj.Name:lower():find("gold") then
						if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
							local _, hrp = GetHumanoidAndHRP()
							firetouchinterest(hrp, obj, 0)
							firetouchinterest(hrp, obj, 1)
							task.wait(KState.CoinFarmDelay / 10)
						end
					end
				end
			end)
		end
		task.wait(0.5)
	end
end)

-- AutoFarm XP
task.spawn(function()
	while true do
		if KState.AutoFarmXP then
			pcall(function()
				local _, hrp = GetHumanoidAndHRP()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if not KState.AutoFarmXP then break end
					if obj.Name:lower():find("xp") or obj.Name:lower():find("exp") then
						if obj:IsA("BasePart") then
							hrp.CFrame = obj.CFrame
							task.wait(0.3)
						end
					end
				end
			end)
		end
		task.wait(1)
	end
end)

-- Auto Collect Resources
task.spawn(function()
	while true do
		if KState.AutoCollectResources then
			pcall(function()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if not KState.AutoCollectResources then break end
					if obj.Name:lower():find("wood") or obj.Name:lower():find("stone") or obj.Name:lower():find("block") then
						if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
							local _, hrp = GetHumanoidAndHRP()
							firetouchinterest(hrp, obj, 0)
							firetouchinterest(hrp, obj, 1)
							task.wait(0.2)
						end
					end
				end
			end)
		end
		task.wait(0.5)
	end
end)

-- Infinite Materials
task.spawn(function()
	while true do
		if KState.InfiniteMaterials then
			pcall(function()
				local bp = LocalPlayer:FindFirstChild("Backpack")
				if bp then
					for _, tool in pairs(bp:GetChildren()) do
						if tool:IsA("Tool") and tool:FindFirstChild("Amount") then
							tool.Amount.Value = 9999
						end
					end
				end
				for _, tool in pairs(GetCharacter():GetChildren()) do
					if tool:IsA("Tool") and tool:FindFirstChild("Amount") then
						tool.Amount.Value = 9999
					end
				end
			end)
		end
		task.wait(1)
	end
end)

-- Auto Repair
task.spawn(function()
	while true do
		if KState.AutoRepair then
			pcall(function()
				for _, boat in pairs(Workspace:GetChildren()) do
					if boat.Name:find(LocalPlayer.Name) or boat.Name:lower():find("boat") then
						for _, part in pairs(boat:GetDescendants()) do
							if part:IsA("BasePart") then
								local hp = part:FindFirstChild("Health") or part:FindFirstChild("HP")
								if hp and hp:IsA("NumberValue") then hp.Value = 100 end
							end
						end
					end
				end
			end)
		end
		task.wait(2)
	end
end)

-- State Monitor
task.spawn(function()
	while ScreenGui and ScreenGui.Parent do
		if KState.Fly and not FlyConn then StartFly() end
		if not KState.Fly and FlyConn then StopFly() end
		if KState.Noclip and not NoclipConn then StartNoclip() end
		if not KState.Noclip and NoclipConn then StopNoclip() end

		local hum = select(1, GetHumanoidAndHRP())
		if KState.Speed then
			hum.WalkSpeed = KState.WalkSpeed
		else
			hum.WalkSpeed = 16
		end
		hum.JumpPower = KState.JumpPower

		task.wait(0.3)
	end
end)

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	if KState.Fly then StartFly() end
	if KState.Noclip then StartNoclip() end
end)

-- Drag UI
local drag, dragStart, startPos = false, nil, nil

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		drag = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		drag = false
	end
end)

-- Open animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
	Size = UDim2.new(0, 520, 0, 360),
	Position = UDim2.new(0.5, -260, 0.5, -180)
}):Play()

print("[KYDIABROSO] Loaded successfully | GitHub Edition v2.2")
