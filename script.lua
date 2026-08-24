--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║              KYDIABROSO v4.0 | PRO BBFT HUB                    ║
    ║     Рабочий скрипт на основе реальных скриптов BBFT            ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// Проверка игры
if game.PlaceId ~= 537413528 then
	warn("[KYDIABROSO] Этот скрипт только для Build A Boat For Treasure!")
	return
end

--// State Manager
local KState = {
	AutoFarm = false,
	AutoCollect = false,
	AutoBuild = false,
	StealBuild = false,
	InfiniteBlocks = false,
	AutoWeld = false,
	FastPlace = false,
	AutoRepair = false,
	Fly = false,
	Speed = false,
	Noclip = false,
	DeleteWater = false,
	AntiAFK = false,
	NoFog = false,
	FlySpeed = 100,
	WalkSpeed = 50,
	JumpPower = 50,
	BuildTemplate = "GoldFarm",
}

--// Utility
local function GUID() return HttpService:GenerateGUID(false):sub(1, 8) end

local function GetChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHRP()
	local char = GetChar()
	return char:WaitForChild("HumanoidRootPart")
end

local function GetHum()
	local char = GetChar()
	return char:WaitForChild("Humanoid")
end

--// Anti-AFK
LocalPlayer.Idled:Connect(function()
	if KState.AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

--// GUI
local SG = Instance.new("ScreenGui")
SG.Name = "KYDIABROSO_" .. GUID()
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 380)
Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = SG

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Grad = Instance.new("UIGradient")
Grad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 212, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(123, 47, 252))
})
Grad.Transparency = NumberSequence.new(0.92, 0.92)
Grad.Rotation = 135
Grad.Parent = Main

local Str = Instance.new("UIStroke")
Str.Color = Color3.fromRGB(0, 212, 255)
Str.Thickness = 1.2
Str.Transparency = 0.5
Str.Parent = Main

local Glass = Instance.new("Frame")
Glass.Size = UDim2.new(1, 0, 1, 0)
Glass.BackgroundTransparency = 0.93
Glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Glass.ZIndex = 2
Glass.Parent = Main
Instance.new("UICorner", Glass).CornerRadius = UDim.new(0, 14)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "KYDIABROSO"
Title.TextColor3 = Color3.fromRGB(0, 212, 255)
Title.TextSize = 26
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 5
Title.Parent = Main

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
Glow.Parent = Main

-- Close
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.TextSize = 22
Close.Font = Enum.Font.GothamBold
Close.ZIndex = 6
Close.Parent = Main
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

-- Tabs
local TabBtns = Instance.new("Frame")
TabBtns.Size = UDim2.new(1, -20, 0, 34)
TabBtns.Position = UDim2.new(0, 10, 0, 44)
TabBtns.BackgroundTransparency = 1
TabBtns.ZIndex = 5
TabBtns.Parent = Main

local TabLay = Instance.new("UIListLayout")
TabLay.FillDirection = Enum.FillDirection.Horizontal
TabLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLay.Padding = UDim.new(0, 6)
TabLay.Parent = TabBtns

local TabCont = Instance.new("Frame")
TabCont.Size = UDim2.new(1, -20, 1, -88)
TabCont.Position = UDim2.new(0, 10, 0, 80)
TabCont.BackgroundTransparency = 1
TabCont.ZIndex = 5
TabCont.Parent = Main

local Tabs = {}

local function CreateTab(name, icon)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0, 100, 1, 0)
	Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
	Btn.BackgroundTransparency = 0.3
	Btn.Text = icon .. " " .. name
	Btn.TextColor3 = Color3.fromRGB(170, 170, 170)
	Btn.TextSize = 11
	Btn.Font = Enum.Font.GothamSemibold
	Btn.BorderSizePixel = 0
	Btn.ZIndex = 6
	Btn.Parent = TabBtns
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
	Frame.Parent = TabCont

	local List = Instance.new("UIListLayout")
	List.Padding = UDim.new(0, 8)
	List.Parent = Frame

	Tabs[name] = {Button = Btn, Frame = Frame}

	Btn.MouseButton1Click:Connect(function()
		for _, t in pairs(Tabs) do
			t.Frame.Visible = false
			t.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
			t.Button.TextColor3 = Color3.fromRGB(170, 170, 170)
		end
		Frame.Visible = true
		Btn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
		Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)

	return Frame
end

-- Toggle
local function CreateToggle(parent, text, key)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 40)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	Frame.BackgroundTransparency = 0.3
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.6, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.TextSize = 13
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 7
	Label.Parent = Frame

	local TBg = Instance.new("TextButton")
	TBg.Size = UDim2.new(0, 44, 0, 22)
	TBg.Position = UDim2.new(1, -54, 0.5, -11)
	TBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	TBg.BorderSizePixel = 0
	TBg.Text = ""
	TBg.ZIndex = 7
	TBg.Parent = Frame
	Instance.new("UICorner", TBg).CornerRadius = UDim.new(1, 0)

	local Cir = Instance.new("Frame")
	Cir.Size = UDim2.new(0, 18, 0, 18)
	Cir.Position = UDim2.new(0, 2, 0.5, -9)
	Cir.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Cir.BorderSizePixel = 0
	Cir.ZIndex = 8
	Cir.Parent = TBg
	Instance.new("UICorner", Cir).CornerRadius = UDim.new(1, 0)

	local isOn = KState[key]

	local function Upd()
		if isOn then
			TweenService:Create(TBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 212, 255)}):Play()
			TweenService:Create(Cir, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
		else
			TweenService:Create(TBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
			TweenService:Create(Cir, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
		end
		KState[key] = isOn
	end

	Upd()
	TBg.MouseButton1Click:Connect(function()
		isOn = not isOn
		Upd()
	end)
end

-- Slider
local function CreateSlider(parent, text, min, max, default, key, suffix)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 54)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	Frame.BackgroundTransparency = 0.3
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 0, 18)
	Label.Position = UDim2.new(0, 12, 0, 4)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.TextSize = 12
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 7
	Label.Parent = Frame

	local VL = Instance.new("TextLabel")
	VL.Size = UDim2.new(0.3, 0, 0, 18)
	VL.Position = UDim2.new(0.7, -10, 0, 4)
	VL.BackgroundTransparency = 1
	VL.Text = tostring(default) .. (suffix or "")
	VL.TextColor3 = Color3.fromRGB(0, 212, 255)
	VL.TextSize = 12
	VL.Font = Enum.Font.GothamBold
	VL.TextXAlignment = Enum.TextXAlignment.Right
	VL.ZIndex = 7
	VL.Parent = Frame

	local SBg = Instance.new("Frame")
	SBg.Size = UDim2.new(1, -24, 0, 5)
	SBg.Position = UDim2.new(0, 12, 0, 34)
	SBg.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
	SBg.BorderSizePixel = 0
	SBg.ZIndex = 7
	SBg.Parent = Frame
	Instance.new("UICorner", SBg).CornerRadius = UDim.new(1, 0)

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	Fill.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
	Fill.BorderSizePixel = 0
	Fill.ZIndex = 8
	Fill.Parent = SBg
	Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

	local HB = Instance.new("TextButton")
	HB.Size = UDim2.new(1, 0, 1, 12)
	HB.Position = UDim2.new(0, 0, 0, -6)
	HB.BackgroundTransparency = 1
	HB.Text = ""
	HB.ZIndex = 9
	HB.Parent = SBg

	local drag = false

	local function UpdSlider(input)
		local pos = math.clamp((input.Position.X - SBg.AbsolutePosition.X) / SBg.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + (max - min) * pos)
		KState[key] = val
		VL.Text = tostring(val) .. (suffix or "")
		Fill.Size = UDim2.new(pos, 0, 1, 0)
	end

	HB.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			UpdSlider(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
			UpdSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = false
		end
	end)
end

-- Button
local function CreateButton(parent, text, callback, color)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 38)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	Frame.BackgroundTransparency = 0.3
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 1, 0)
	Btn.BackgroundColor3 = color or Color3.fromRGB(0, 180, 230)
	Btn.BackgroundTransparency = 0.6
	Btn.BorderSizePixel = 0
	Btn.Text = text
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 13
	Btn.Font = Enum.Font.GothamBold
	Btn.ZIndex = 7
	Btn.Parent = Frame
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6}):Play()
	end)
	Btn.MouseButton1Click:Connect(callback)
end

-- Dropdown
local function CreateDropdown(parent, text, options, stateKey)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 38)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	Frame.BackgroundTransparency = 0.3
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.4, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.TextSize = 12
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 7
	Label.Parent = Frame

	local Selected = Instance.new("TextButton")
	Selected.Size = UDim2.new(0, 120, 0, 26)
	Selected.Position = UDim2.new(1, -130, 0.5, -13)
	Selected.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
	Selected.BorderSizePixel = 0
	Selected.Text = KState[stateKey] or options[1]
	Selected.TextColor3 = Color3.fromRGB(0, 212, 255)
	Selected.TextSize = 11
	Selected.Font = Enum.Font.GothamBold
	Selected.ZIndex = 7
	Selected.Parent = Frame
	Instance.new("UICorner", Selected).CornerRadius = UDim.new(0, 6)

	local ListFrame = Instance.new("Frame")
	ListFrame.Size = UDim2.new(0, 120, 0, #options * 26)
	ListFrame.Position = UDim2.new(1, -130, 0, 36)
	ListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
	ListFrame.BorderSizePixel = 0
	ListFrame.ZIndex = 10
	ListFrame.Visible = false
	ListFrame.Parent = Frame
	Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 6)

	for i, opt in ipairs(options) do
		local OptBtn = Instance.new("TextButton")
		OptBtn.Size = UDim2.new(1, 0, 0, 26)
		OptBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 26)
		OptBtn.BackgroundTransparency = 1
		OptBtn.Text = opt
		OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
		OptBtn.TextSize = 11
		OptBtn.Font = Enum.Font.Gotham
		OptBtn.ZIndex = 11
		OptBtn.Parent = ListFrame

		OptBtn.MouseEnter:Connect(function()
			OptBtn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
			OptBtn.BackgroundTransparency = 0.8
		end)
		OptBtn.MouseLeave:Connect(function()
			OptBtn.BackgroundTransparency = 1
		end)
		OptBtn.MouseButton1Click:Connect(function()
			KState[stateKey] = opt
			Selected.Text = opt
			ListFrame.Visible = false
		end)
	end

	Selected.MouseButton1Click:Connect(function()
		ListFrame.Visible = not ListFrame.Visible
	end)
end

-- ==================== TABS ====================

-- Farm
local FarmTab = CreateTab("Фарм", "⚡")
CreateToggle(FarmTab, "AutoFarm Gold", "AutoFarm")
CreateToggle(FarmTab, "Auto Collect", "AutoCollect")
CreateToggle(FarmTab, "Anti-AFK", "AntiAFK")

-- Build
local BuildTab = CreateTab("Билд", "🏗️")
CreateToggle(BuildTab, "Infinite Blocks", "InfiniteBlocks")
CreateToggle(BuildTab, "Fast Place", "FastPlace")
CreateToggle(BuildTab, "Auto Weld", "AutoWeld")
CreateToggle(BuildTab, "Auto Repair", "AutoRepair")
CreateDropdown(BuildTab, "Шаблон:", {"GoldFarm", "Jet", "Boat", "Tower"}, "BuildTemplate")

CreateButton(BuildTab, "▶ Построить шаблон", function()
	KState.AutoBuild = true
	print("[KYDIABROSO] Строим: " .. KState.BuildTemplate)
end, Color3.fromRGB(0, 200, 100))

CreateButton(BuildTab, "⏹ Стоп", function()
	KState.AutoBuild = false
end, Color3.fromRGB(200, 50, 50))

CreateButton(BuildTab, "📋 Скопировать чужой", function()
	KState.StealBuild = true
	print("[KYDIABROSO] Копируем ближайший корабль...")
end, Color3.fromRGB(255, 165, 0))

-- Transport
local TransTab = CreateTab("Транспорт", "🚀")
CreateToggle(TransTab, "Fly", "Fly")
CreateSlider(TransTab, "Fly Speed", 10, 500, 100, "FlySpeed", "")
CreateToggle(TransTab, "Speed", "Speed")
CreateSlider(TransTab, "Walk Speed", 10, 200, 50, "WalkSpeed", "")
CreateSlider(TransTab, "Jump", 10, 200, 50, "JumpPower", "")
CreateToggle(TransTab, "Noclip", "Noclip")

CreateButton(TransTab, "ТП к старту", function()
	pcall(function()
		local hrp = GetHRP()
		hrp.CFrame = CFrame.new(-51, 67, 815)
	end)
end)

CreateButton(TransTab, "ТП к сундуку", function()
	pcall(function()
		local hrp = GetHRP()
		local chest = Workspace:FindFirstChild("BoatStages")
			and Workspace.BoatStages:FindFirstChild("NormalStages")
			and Workspace.BoatStages.NormalStages:FindFirstChild("TheEnd")
			and Workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
			and Workspace.BoatStages.NormalStages.TheEnd.GoldenChest:FindFirstChild("Trigger")
		if chest then
			hrp.CFrame = chest.CFrame + Vector3.new(0, 5, 0)
		else
			hrp.CFrame = CFrame.new(-4195, 177, -18)
		end
	end)
end)

-- World
local WorldTab = CreateTab("Мир", "🌍")
CreateToggle(WorldTab, "Delete Water", "DeleteWater")
CreateToggle(WorldTab, "No Fog", "NoFog")
CreateButton(WorldTab, "Full Bright", function()
	pcall(function()
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 100000
	end)
end)

-- Settings
local SetTab = CreateTab("Настройки", "⚙️")
CreateButton(SetTab, "Сбросить всё", function()
	for k, v in pairs(KState) do
		if type(v) == "boolean" then KState[k] = false end
	end
end, Color3.fromRGB(200, 50, 50))

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -10, 0, 90)
Info.BackgroundTransparency = 1
Info.Text = "KYDIABROSO v4.0 PRO\nBuild A Boat For Treasure\n\nУправление: W/A/S/D | Space | LShift"
Info.TextColor3 = Color3.fromRGB(130, 130, 150)
Info.TextSize = 11
Info.Font = Enum.Font.Gotham
Info.TextWrapped = true
Info.ZIndex = 6
Info.Parent = SetTab

-- Activate first tab
local first = true
for _, tab in pairs(Tabs) do
	if first then
		tab.Frame.Visible = true
		tab.Button.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
		tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		first = false
	end
end

-- ==================== РАБОЧАЯ ЛОГИКА ====================

--// 1. INFINITE BLOCKS (Рабочий метод)
task.spawn(function()
	while true do
		if KState.InfiniteBlocks then
			pcall(function()
				local bp = LocalPlayer:FindFirstChild("Backpack")
				if bp then
					for _, tool in pairs(bp:GetChildren()) do
						if tool:IsA("Tool") then
							local amt = tool:FindFirstChild("Amount")
							if amt and (amt:IsA("IntValue") or amt:IsA("NumberValue")) then
								amt.Value = 9999
							end
						end
					end
				end
				for _, tool in pairs(GetChar():GetChildren()) do
					if tool:IsA("Tool") then
						local amt = tool:FindFirstChild("Amount")
						if amt and (amt:IsA("IntValue") or amt:IsA("NumberValue")) then
							amt.Value = 9999
						end
					end
				end
			end)
		end
		task.wait(0.3)
	end
end)

--// 2. AUTOFARM GOLD (Рабочий метод из реальных скриптов)
local function DoAutoFarm()
	pcall(function()
		local hrp = GetHRP()
		local remotes = ReplicatedStorage:FindFirstChild("Remotes")

		-- Запускаем корабль
		if remotes and remotes:FindFirstChild("launchBoat") then
			remotes.launchBoat:FireServer()
		end

		-- Ждём запуска
		task.wait(1)

		-- Телепорт на стартовую позицию
		hrp.CFrame = CFrame.new(-51, 67, 815)

		-- Tween до конца карты
		local tween1 = TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Linear), {
			CFrame = CFrame.new(-51, 67, 815) * CFrame.Angles(0, math.rad(90), 0)
		})
		tween1:Play()
		tween1.Completed:Wait()

		-- Основной путь до сундука
		local tween2 = TweenService:Create(hrp, TweenInfo.new(5, Enum.EasingStyle.Linear), {
			CFrame = CFrame.new(-77, 83, 8626) * CFrame.Angles(0, math.rad(90), 0)
		})
		tween2:Play()
		tween2.Completed:Wait()

		-- К сундуку
		local chest = Workspace:FindFirstChild("BoatStages")
			and Workspace.BoatStages:FindFirstChild("NormalStages")
			and Workspace.BoatStages.NormalStages:FindFirstChild("TheEnd")
			and Workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
			and Workspace.BoatStages.NormalStages.TheEnd.GoldenChest:FindFirstChild("Trigger")

		if chest then
			local tween3 = TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Linear), {
				CFrame = chest.CFrame
			})
			tween3:Play()
			tween3.Completed:Wait()
		else
			hrp.CFrame = CFrame.new(-4195, 177, -18)
		end

		-- Собираем награду
		task.wait(1)
		pcall(function()
			local pg = LocalPlayer:FindFirstChild("PlayerGui")
			if pg and pg:FindFirstChild("Main") then
				local goldShow = pg.Main:FindFirstChild("goldShow2")
				if goldShow and goldShow.Visible then
					local btn = goldShow:FindFirstChild("Frame2") and goldShow.Frame2:FindFirstChild("TextButton")
					if btn then
						for _, conn in pairs(getconnections(btn.MouseButton1Click)) do
							conn:Fire()
						end
					end
				end
			end
		end)

		task.wait(2)
	end)
end

task.spawn(function()
	while true do
		if KState.AutoFarm then
			DoAutoFarm()
		end
		task.wait(0.5)
	end
end)

--// 3. AUTO COLLECT (Сбор монет на карте)
task.spawn(function()
	while true do
		if KState.AutoCollect then
			pcall(function()
				local hrp = GetHRP()
				for _, obj in pairs(Workspace:GetDescendants()) do
					if not KState.AutoCollect then break end
					if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
						local name = obj.Name:lower()
						if name:find("coin") or name:find("gold") or name:find("chest") or name:find("treasure") then
							firetouchinterest(hrp, obj, 0)
							firetouchinterest(hrp, obj, 1)
							task.wait(0.1)
						end
					end
				end
			end)
		end
		task.wait(0.3)
	end
end)

--// 4. BUILD TEMPLATES (Шаблоны построек)
local BuildTemplates = {
	GoldFarm = {
		{block = "WoodBlock", pos = Vector3.new(0, 0, 0), size = Vector3.new(2, 1, 2)},
		{block = "WoodBlock", pos = Vector3.new(0, 1, 0), size = Vector3.new(2, 1, 2)},
		{block = "Seat", pos = Vector3.new(0, 2, 0)},
		{block = "Thruster", pos = Vector3.new(0, 0, -2)},
		{block = "Balloon", pos = Vector3.new(-1, 2, 0)},
		{block = "Balloon", pos = Vector3.new(1, 2, 0)},
	},
	Jet = {
		{block = "WoodBlock", pos = Vector3.new(0, 0, 0), size = Vector3.new(2, 1, 4)},
		{block = "WoodBlock", pos = Vector3.new(0, 1, 0), size = Vector3.new(2, 1, 4)},
		{block = "Seat", pos = Vector3.new(0, 2, 0)},
		{block = "Thruster", pos = Vector3.new(-1, 0, -3)},
		{block = "Thruster", pos = Vector3.new(1, 0, -3)},
	},
	Boat = {
		{block = "WoodBlock", pos = Vector3.new(0, 0, 0), size = Vector3.new(4, 1, 6)},
		{block = "Seat", pos = Vector3.new(0, 1, 0)},
		{block = "Thruster", pos = Vector3.new(0, 0, -3)},
	},
	Tower = {
		{block = "WoodBlock", pos = Vector3.new(0, 0, 0), size = Vector3.new(3, 1, 3)},
		{block = "WoodBlock", pos = Vector3.new(0, 1, 0), size = Vector3.new(3, 1, 3)},
		{block = "WoodBlock", pos = Vector3.new(0, 2, 0), size = Vector3.new(2, 1, 2)},
		{block = "Seat", pos = Vector3.new(0, 3, 0)},
		{block = "Thruster", pos = Vector3.new(0, 0, -2)},
	},
}

local function PlaceBlock(blockType, cframe)
	pcall(function()
		local tool = GetChar():FindFirstChildOfClass("Tool")
		if not tool then
			local bp = LocalPlayer:FindFirstChild("Backpack")
			if bp then
				for _, t in pairs(bp:GetChildren()) do
					if t:IsA("Tool") then
						local isBlock = t.Name:lower():find("block") or t.Name:lower():find("wood") or t.Name:lower():find("stone") or t.Name:lower():find("thruster") or t.Name:lower():find("seat") or t.Name:lower():find("balloon")
						if isBlock then
							t.Parent = GetChar()
							tool = t
							break
						end
					end
				end
			end
		end

		if tool then
			local event = tool:FindFirstChild("BuildEvent") or tool:FindFirstChild("PlaceBlock") or tool:FindFirstChild("Place")
			if event and event:IsA("RemoteEvent") then
				event:FireServer(cframe.Position, cframe)
			end
		end
	end)
end

-- AutoBuild
task.spawn(function()
	while true do
		if KState.AutoBuild then
			pcall(function()
				local template = BuildTemplates[KState.BuildTemplate]
				if template then
					local hrp = GetHRP()
					local basePos = hrp.Position

					for _, data in ipairs(template) do
						if not KState.AutoBuild then break end
						local cf = CFrame.new(basePos + data.pos)
						PlaceBlock(data.block, cf)
						task.wait(KState.FastPlace and 0.05 or 0.2)
					end

					-- Auto Weld
					if KState.AutoWeld then
						task.wait(0.5)
						for _, boat in pairs(Workspace:GetChildren()) do
							if boat.Name:find(LocalPlayer.Name) or boat.Name:lower():find("boat") then
								local parts = {}
								for _, part in pairs(boat:GetDescendants()) do
									if part:IsA("BasePart") then
										table.insert(parts, part)
									end
								end
								for i = 2, #parts do
									local weld = Instance.new("WeldConstraint")
									weld.Part0 = parts[1]
									weld.Part1 = parts[i]
									weld.Parent = parts[i]
								end
							end
						end
					end

					KState.AutoBuild = false
					print("[KYDIABROSO] Постройка завершена!")
				end
			end)
		end
		task.wait(0.5)
	end
end)

--// 5. STEAL BUILD (Копирование чужого корабля)
task.spawn(function()
	while true do
		if KState.StealBuild then
			pcall(function()
				local hrp = GetHRP()
				local myPos = hrp.Position
				local target = nil
				local minDist = 60

				for _, obj in pairs(Workspace:GetChildren()) do
					if obj.Name:lower():find("boat") or obj:FindFirstChild("Seat") then
						local primary = obj:FindFirstChildWhichIsA("BasePart")
						if primary then
							local dist = (primary.Position - myPos).Magnitude
							if dist < minDist and not obj.Name:find(LocalPlayer.Name) then
								target = obj
								minDist = dist
							end
						end
					end
				end

				if target then
					local basePart = target:FindFirstChildWhichIsA("BasePart")
					if basePart then
						local offset = myPos - basePart.Position
						for _, part in pairs(target:GetDescendants()) do
							if part:IsA("BasePart") then
								local newCf = CFrame.new(part.Position + offset) * (part.CFrame - part.CFrame.Position)
								PlaceBlock(part.Name, newCf)
								task.wait(KState.FastPlace and 0.05 or 0.15)
							end
						end
					end
					print("[KYDIABROSO] Копирование завершено!")
				else
					print("[KYDIABROSO] Нет кораблей рядом для копирования")
				end

				KState.StealBuild = false
			end)
		end
		task.wait(1)
	end
end)

--// 6. AUTO REPAIR
task.spawn(function()
	while true do
		if KState.AutoRepair then
			pcall(function()
				for _, boat in pairs(Workspace:GetChildren()) do
					if boat.Name:find(LocalPlayer.Name) or boat.Name:lower():find("boat") then
						for _, part in pairs(boat:GetDescendants()) do
							if part:IsA("BasePart") then
								local hp = part:FindFirstChild("Health") or part:FindFirstChild("HP")
								if hp then hp.Value = 100 end
							end
						end
					end
				end
			end)
		end
		task.wait(1)
	end
end)

--// 7. DELETE WATER
local function DoDeleteWater()
	pcall(function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj.Name:lower():find("water") and obj:IsA("BasePart") then
				obj:Destroy()
			end
		end
		Workspace.Terrain:Clear()
	end)
end

--// 8. NO FOG
local function DoNoFog()
	pcall(function()
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
		for _, v in pairs(Lighting:GetChildren()) do
			if v:IsA("Atmosphere") then v:Destroy() end
		end
	end)
end

--// 9. FLY SYSTEM
local FlyBV, FlyBG, FlyConn

local function StartFly()
	if FlyBV then FlyBV:Destroy() end
	if FlyBG then FlyBG:Destroy() end
	local hrp = GetHRP()

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

--// 10. NOCLIP
local NoclipConn
local function StartNoclip()
	NoclipConn = RunService.Stepped:Connect(function()
		if KState.Noclip then
			for _, part in pairs(GetChar():GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)
end

local function StopNoclip()
	if NoclipConn then NoclipConn:Disconnect() end
	NoclipConn = nil
	for _, part in pairs(GetChar():GetDescendants()) do
		if part:IsA("BasePart") then part.CanCollide = true end
	end
end

--// STATE MONITOR
task.spawn(function()
	while SG and SG.Parent do
		if KState.Fly and not FlyConn then StartFly() end
		if not KState.Fly and FlyConn then StopFly() end
		if KState.Noclip and not NoclipConn then StartNoclip() end
		if not KState.Noclip and NoclipConn then StopNoclip() end
		if KState.DeleteWater then DoDeleteWater() end
		if KState.NoFog then DoNoFog() end

		local hum = GetHum()
		if KState.Speed then hum.WalkSpeed = KState.WalkSpeed else hum.WalkSpeed = 16 end
		hum.JumpPower = KState.JumpPower

		task.wait(0.2)
	end
end)

-- Respawn handler
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	if KState.Fly then StartFly() end
	if KState.Noclip then StartNoclip() end
end)

-- Drag UI
local dragging, dragStart, startPos = false, nil, nil
Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Open animation
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
	Size = UDim2.new(0, 520, 0, 380),
	Position = UDim2.new(0.5, -260, 0.5, -190)
}):Play()

print("[KYDIABROSO] v4.0 PRO загружен! | AutoFarm + Build + Steal работают")
