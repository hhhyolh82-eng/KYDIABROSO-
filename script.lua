--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║              KYDIABROSO v3.0 | ULTIMATE BBFT HUB               ║
    ║          Build A Boat For Treasure — Premium Script            ║
    ║  Features: AutoBuild, Steal Build, Inf Blocks, AutoFarm, Fly   ║
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

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// State Manager
local KState = {
	AutoFarmCoins = false,
	AutoFarmXP = false,
	AutoCollectResources = false,
	InfiniteMaterials = false,
	AutoRepair = false,
	Fly = false,
	Speed = false,
	Noclip = false,
	DeleteWater = false,
	AutoWeld = false,
	FastPlace = false,
	AutoBuild = false,
	StealBuild = false,
	AntiAFK = false,
	FlySpeed = 100,
	WalkSpeed = 50,
	JumpPower = 50,
	CoinFarmDelay = 5,
	BuildTemplate = "Jet",
}

--// Utility
local function GUID() return HttpService:GenerateGUID(false):sub(1, 8) end

local function GetChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHum()
	local c = GetChar()
	return c:WaitForChild("Humanoid"), c:WaitForChild("HumanoidRootPart")
end

--// Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
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
Main.Size = UDim2.new(0, 540, 0, 400)
Main.Position = UDim2.new(0.5, -270, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 28)
Main.BackgroundTransparency = 0.08
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = SG

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local Grad = Instance.new("UIGradient")
Grad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 212, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(123, 47, 252)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 128))
})
Grad.Transparency = NumberSequence.new(0.94, 0.94)
Grad.Rotation = 45
Grad.Parent = Main

local Str = Instance.new("UIStroke")
Str.Color = Color3.fromRGB(0, 212, 255)
Str.Thickness = 1.5
Str.Transparency = 0.4
Str.Parent = Main

local Glass = Instance.new("Frame")
Glass.Size = UDim2.new(1, 0, 1, 0)
Glass.BackgroundTransparency = 0.92
Glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Glass.ZIndex = 2
Glass.Parent = Main
Instance.new("UICorner", Glass).CornerRadius = UDim.new(0, 16)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 44)
Title.Position = UDim2.new(0, 0, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "KYDIABROSO"
Title.TextColor3 = Color3.fromRGB(0, 212, 255)
Title.TextSize = 28
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 5
Title.Parent = Main

local Glow = Instance.new("TextLabel")
Glow.Size = Title.Size
Glow.Position = Title.Position + UDim2.new(0, 0, 0, 2)
Glow.BackgroundTransparency = 1
Glow.Text = "KYDIABROSO"
Glow.TextColor3 = Color3.fromRGB(123, 47, 252)
Glow.TextSize = 28
Glow.Font = Enum.Font.GothamBold
Glow.TextTransparency = 0.7
Glow.ZIndex = 4
Glow.Parent = Main

local Ver = Instance.new("TextLabel")
Ver.Size = UDim2.new(0, 60, 0, 16)
Ver.Position = UDim2.new(1, -70, 0, 8)
Ver.BackgroundTransparency = 1
Ver.Text = "v3.0"
Ver.TextColor3 = Color3.fromRGB(0, 212, 255)
Ver.TextSize = 12
Ver.Font = Enum.Font.Gotham
Ver.ZIndex = 5
Ver.Parent = Main

-- Close
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 32, 0, 32)
Close.Position = UDim2.new(1, -38, 0, 6)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.TextSize = 24
Close.Font = Enum.Font.GothamBold
Close.ZIndex = 6
Close.Parent = Main
Close.MouseButton1Click:Connect(function() SG:Destroy() end)

-- Minimize
local Min = Instance.new("TextButton")
Min.Size = UDim2.new(0, 32, 0, 32)
Min.Position = UDim2.new(1, -72, 0, 6)
Min.BackgroundTransparency = 1
Min.Text = "−"
Min.TextColor3 = Color3.fromRGB(200, 200, 200)
Min.TextSize = 24
Min.Font = Enum.Font.GothamBold
Min.ZIndex = 6
Min.Parent = Main

local Minimized = false
Min.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	TweenService:Create(Main, TweenInfo.new(0.3), {
		Size = Minimized and UDim2.new(0, 540, 0, 44) or UDim2.new(0, 540, 0, 400)
	}):Play()
end)

-- Tabs
local TabBtns = Instance.new("Frame")
TabBtns.Size = UDim2.new(1, -20, 0, 36)
TabBtns.Position = UDim2.new(0, 10, 0, 48)
TabBtns.BackgroundTransparency = 1
TabBtns.ZIndex = 5
TabBtns.Parent = Main

local TabLay = Instance.new("UIListLayout")
TabLay.FillDirection = Enum.FillDirection.Horizontal
TabLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLay.Padding = UDim.new(0, 6)
TabLay.Parent = TabBtns

local TabCont = Instance.new("Frame")
TabCont.Size = UDim2.new(1, -20, 1, -96)
TabCont.Position = UDim2.new(0, 10, 0, 88)
TabCont.BackgroundTransparency = 1
TabCont.ZIndex = 5
TabCont.Parent = Main

local Tabs = {}

local function CreateTab(name, icon)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0, 96, 1, 0)
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
	Frame.Size = UDim2.new(1, -10, 0, 42)
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
	TBg.Size = UDim2.new(0, 46, 0, 24)
	TBg.Position = UDim2.new(1, -56, 0.5, -12)
	TBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	TBg.BorderSizePixel = 0
	TBg.Text = ""
	TBg.ZIndex = 7
	TBg.Parent = Frame
	Instance.new("UICorner", TBg).CornerRadius = UDim.new(1, 0)

	local Cir = Instance.new("Frame")
	Cir.Size = UDim2.new(0, 20, 0, 20)
	Cir.Position = UDim2.new(0, 2, 0.5, -10)
	Cir.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Cir.BorderSizePixel = 0
	Cir.ZIndex = 8
	Cir.Parent = TBg
	Instance.new("UICorner", Cir).CornerRadius = UDim.new(1, 0)

	local isOn = KState[key]

	local function Upd()
		if isOn then
			TweenService:Create(TBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 212, 255)}):Play()
			TweenService:Create(Cir, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
		else
			TweenService:Create(TBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
			TweenService:Create(Cir, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
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
	Frame.Size = UDim2.new(1, -10, 0, 56)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	Frame.BackgroundTransparency = 0.3
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 0, 20)
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
	VL.Size = UDim2.new(0.3, 0, 0, 20)
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
	SBg.Size = UDim2.new(1, -24, 0, 6)
	SBg.Position = UDim2.new(0, 12, 0, 36)
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
	HB.Size = UDim2.new(1, 0, 1, 14)
	HB.Position = UDim2.new(0, 0, 0, -7)
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
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			drag = true
			UpdSlider(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			UpdSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			drag = false
		end
	end)
end

-- Button
local function CreateButton(parent, text, callback, color)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 40)
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

-- Dropdown (для выбора шаблона)
local function CreateDropdown(parent, text, options, stateKey)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 40)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	Frame.BackgroundTransparency = 0.3
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 6
	Frame.Parent = parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.TextSize = 13
	Label.Font = Enum.Font.Gotham
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 7
	Label.Parent = Frame

	local Selected = Instance.new("TextButton")
	Selected.Size = UDim2.new(0, 130, 0, 28)
	Selected.Position = UDim2.new(1, -140, 0.5, -14)
	Selected.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
	Selected.BorderSizePixel = 0
	Selected.Text = KState[stateKey] or options[1]
	Selected.TextColor3 = Color3.fromRGB(0, 212, 255)
	Selected.TextSize = 12
	Selected.Font = Enum.Font.GothamBold
	Selected.ZIndex = 7
	Selected.Parent = Frame
	Instance.new("UICorner", Selected).CornerRadius = UDim.new(0, 6)

	local ListFrame = Instance.new("Frame")
	ListFrame.Size = UDim2.new(0, 130, 0, #options * 28)
	ListFrame.Position = UDim2.new(1, -140, 0, 38)
	ListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
	ListFrame.BorderSizePixel = 0
	ListFrame.ZIndex = 10
	ListFrame.Visible = false
	ListFrame.Parent = Frame
	Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 6)

	for i, opt in ipairs(options) do
		local OptBtn = Instance.new("TextButton")
		OptBtn.Size = UDim2.new(1, 0, 0, 28)
		OptBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 28)
		OptBtn.BackgroundTransparency = 1
		OptBtn.Text = opt
		OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
		OptBtn.TextSize = 12
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

-- ⚡ Фарм
local FarmTab = CreateTab("Фарм", "⚡")
CreateToggle(FarmTab, "Автофарм монет", "AutoFarmCoins")
CreateSlider(FarmTab, "Задержка фарма", 1, 20, 5, "CoinFarmDelay", " (0.1с)")
CreateToggle(FarmTab, "Автофарм опыта", "AutoFarmXP")
CreateToggle(FarmTab, "Автосбор ресурсов", "AutoCollectResources")
CreateToggle(FarmTab, "Anti-AFK", "AntiAFK")

-- 🏗️ Билд (улучшенный)
local BuildTab = CreateTab("Билд", "🏗️")
CreateToggle(BuildTab, "Бесконечные блоки", "InfiniteMaterials")
CreateToggle(BuildTab, "Быстрая установка", "FastPlace")
CreateToggle(BuildTab, "Авто-Велд", "AutoWeld")
CreateToggle(BuildTab, "Авто-чинка корабля", "AutoRepair")
CreateDropdown(BuildTab, "Шаблон:", {"Jet", "Boat", "Tower", "Bridge", "GoldFarm"}, "BuildTemplate")

CreateButton(BuildTab, "▶ Автопостройка шаблона", function()
	KState.AutoBuild = true
	print("[KYDIABROSO] AutoBuild запущен: " .. KState.BuildTemplate)
end, Color3.fromRGB(0, 200, 100))

CreateButton(BuildTab, "⏹ Остановить постройку", function()
	KState.AutoBuild = false
	print("[KYDIABROSO] AutoBuild остановлен")
end, Color3.fromRGB(200, 50, 50))

CreateButton(BuildTab, "📋 Скопировать чужой корабль", function()
	KState.StealBuild = true
	print("[KYDIABROSO] StealBuild активирован")
end, Color3.fromRGB(255, 165, 0))

-- 🚀 Транспорт
local TransTab = CreateTab("Транспорт", "🚀")
CreateToggle(TransTab, "Fly (Полет)", "Fly")
CreateSlider(TransTab, "Скорость полета", 10, 500, 100, "FlySpeed", "")
CreateToggle(TransTab, "Speed (Скорость)", "Speed")
CreateSlider(TransTab, "Множитель скорости", 10, 200, 50, "WalkSpeed", "")
CreateSlider(TransTab, "Jump Power", 10, 200, 50, "JumpPower", "")
CreateToggle(TransTab, "Noclip", "Noclip")

CreateButton(TransTab, "Телепорт на старт", function()
	pcall(function()
		local sp = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Start")
		if sp and sp:IsA("BasePart") then
			local _, hrp = GetHum()
			hrp.CFrame = sp.CFrame + Vector3.new(0, 5, 0)
		end
	end)
end)

CreateButton(TransTab, "Телепорт к сундуку", function()
	pcall(function()
		local _, hrp = GetHum()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj.Name:lower():find("treasure") or obj.Name:lower():find("chest") then
				if obj:IsA("BasePart") then
					hrp.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
					break
				end
			end
		end
	end)
end)

CreateButton(TransTab, "Авто-доезд до сундука", function()
	pcall(function()
		local _, hrp = GetHum()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj.Name:lower():find("treasure") or obj.Name:lower():find("chest") or obj.Name:lower():find("end") then
				if obj:IsA("BasePart") then
					local tween = TweenService:Create(hrp, TweenInfo.new(8, Enum.EasingStyle.Linear), {CFrame = obj.CFrame + Vector3.new(0, 10, 0)})
					tween:Play()
					break
				end
			end
		end
	end)
end, Color3.fromRGB(255, 215, 0))

-- 🌍 Мир
local WorldTab = CreateTab("Мир", "🌍")
CreateToggle(WorldTab, "Удалить воду", "DeleteWater")
CreateButton(WorldTab, "Очистить туман", function()
	pcall(function()
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
		for _, v in pairs(Lighting:GetChildren()) do
			if v:IsA("Atmosphere") then v:Destroy() end
		end
	end)
end)
CreateButton(WorldTab, "Полное освещение", function()
	pcall(function()
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.GlobalShadows = false
	end)
end)

-- ⚙️ Настройки
local SetTab = CreateTab("Настройки", "⚙️")
CreateButton(SetTab, "Сбросить все функции", function()
	for k, v in pairs(KState) do
		if type(v) == "boolean" then KState[k] = false end
	end
end, Color3.fromRGB(200, 50, 50))

CreateButton(SetTab, "Скрыть/Показать UI", function()
	Main.Visible = not Main.Visible
end, Color3.fromRGB(100, 100, 100))

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -10, 0, 100)
Info.BackgroundTransparency = 1
Info.Text = "KYDIABROSO v3.0 ULTIMATE\nBuild A Boat For Treasure\nGitHub: hhhyolh82-eng/KYDIABROSO-\n\nУправление: W/A/S/D | Space | LShift\nСворачивание: кнопка − вверху"
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

-- ==================== ADVANCED BUILD SYSTEM ====================

-- Шаблоны построек (координаты относительно точки спавна)
local BuildTemplates = {
	Jet = {
		{block = "WoodBlock", pos = Vector3.new(0, 0, 0), size = Vector3.new(2, 1, 4)},
		{block = "WoodBlock", pos = Vector3.new(0, 1, 0), size = Vector3.new(2, 1, 4)},
		{block = "WoodBlock", pos = Vector3
