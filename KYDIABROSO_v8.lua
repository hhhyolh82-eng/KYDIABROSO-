-- ==========================================
-- KYDIABROSO v9.0 REMASTERED
-- Build a Boat for Treasure | Рабочий фарм + Копирование построек
-- PlaceId: 537413528
-- ==========================================

if game.PlaceId ~= 537413528 then
    warn("[KYDIABROSO] Этот скрипт только для Build a Boat for Treasure!")
    return
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==========================================
-- STATE TABLE
-- ==========================================
local K = {
    Farm = false,
    FarmMethod = "Instant",
    God = false,
    AFK = false,
    InfBlocks = false,
    FastPlace = false,
    AutoWeld = false,
    Build = false,
    Steal = false,
    Fly = false,
    Speed = false,
    Noclip = false,
    DelWater = false,
    NoFog = false,
    FlySpd = 200,
    WalkSpd = 80,
    JumpPw = 50,
    StageDelay = 3,
    Template = "GoldFarm",
    CopyTeam = "Pink" -- Команда для копирования
}

local FarmStartTime = 0
local FarmTimerLabel = nil
local CurrentTween = nil

-- ==========================================
-- UTILITIES
-- ==========================================
local function GetChar()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function GetHRP()
    local char = GetChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
    local char = GetChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function Notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "KYDIABROSO",
            Text = msg,
            Duration = 3
        })
    end)
end

-- ==========================================
-- GUI CREATION
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KYDIABROSO_v9"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(139, 92, 246)
Stroke.Thickness = 1.2
Stroke.Transparency = 0.5
Stroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 34)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 5
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(0, 24, 0, 34)
TitleFix.Position = UDim2.new(1, -24, 0, 0)
TitleFix.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 5
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "KYDIABROSO v9.0"
TitleLabel.TextColor3 = Color3.fromRGB(139, 92, 246)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 6
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 3)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 6
CloseBtn.Parent = TitleBar
CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80) end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180) end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -34)
Sidebar.Position = UDim2.new(0, 0, 0, 34)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 22, 1, 0)
SidebarFix.Position = UDim2.new(1, -22, 0, 0)
SidebarFix.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
SidebarFix.BorderSizePixel = 0
SidebarFix.ZIndex = 4
SidebarFix.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -118, 1, -42)
Content.Position = UDim2.new(0, 114, 0, 38)
Content.BackgroundTransparency = 1
Content.ZIndex = 5
Content.Parent = MainFrame

local Tabs = {}

local function CreateTab(name, icon)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 32)
    Button.BackgroundTransparency = 1
    Button.Text = "  " .. icon .. "  " .. name
    Button.TextColor3 = Color3.fromRGB(130, 130, 150)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamSemibold
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.ZIndex = 5
    Button.Parent = Sidebar

    local Frame = Instance.new("ScrollingFrame")
    Frame.Name = name
    Frame.Size = UDim2.new(1, -4, 1, -4)
    Frame.Position = UDim2.new(0, 2, 0, 2)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.ScrollBarThickness = 3
    Frame.ScrollBarImageColor3 = Color3.fromRGB(139, 92, 246)
    Frame.Visible = false
    Frame.ZIndex = 5
    Frame.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Frame

    Tabs[name] = {Button = Button, Frame = Frame}

    Button.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Frame.Visible = false
            t.Button.TextColor3 = Color3.fromRGB(130, 130, 150)
            t.Button.BackgroundTransparency = 1
        end
        Frame.Visible = true
        Button.TextColor3 = Color3.fromRGB(139, 92, 246)
        Button.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
        Button.BackgroundTransparency = 0.85
    end)
    return Frame
end

local function CreateSection(parent, title)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -4, 0, 0)
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 5
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, -12, 0, 24)
    Header.Position = UDim2.new(0, 10, 0, 4)
    Header.BackgroundTransparency = 1
    Header.Text = title
    Header.TextColor3 = Color3.fromRGB(139, 92, 246)
    Header.TextSize = 13
    Header.Font = Enum.Font.GothamBold
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.ZIndex = 6
    Header.Parent = Frame

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -14, 0, 0)
    Container.Position = UDim2.new(0, 7, 0, 26)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.ZIndex = 6
    Container.Parent = Frame

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 6)
    List.Parent = Container

    return Container
end

local function CreateToggle(parent, text, key)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 6
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(210, 210, 220)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 7
    Label.Parent = Frame

    local Bg = Instance.new("TextButton")
    Bg.Size = UDim2.new(0, 40, 0, 22)
    Bg.Position = UDim2.new(1, -44, 0.5, -11)
    Bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Bg.BorderSizePixel = 0
    Bg.Text = ""
    Bg.ZIndex = 7
    Bg.Parent = Frame
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 2, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 8
    Knob.Parent = Bg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local on = K[key]
    local function Update()
        if on then
            TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(139, 92, 246)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        else
            TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        end
        K[key] = on
    end
    Update()
    Bg.MouseButton1Click:Connect(function() on = not on; Update() end)
end

local function CreateSlider(parent, text, min, max, def, key, suffix)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 44)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 6
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(210, 210, 220)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 7
    Label.Parent = Frame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 18)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(def) .. (suffix or "")
    ValueLabel.TextColor3 = Color3.fromRGB(139, 92, 246)
    ValueLabel.TextSize = 12
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.ZIndex = 7
    ValueLabel.Parent = Frame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 5)
    Track.Position = UDim2.new(0, 0, 0, 28)
    Track.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Track.BorderSizePixel = 0
    Track.ZIndex = 7
    Track.Parent = Frame
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 8
    Fill.Parent = Track
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new((def - min) / (max - min), -6, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 9
    Knob.Parent = Track
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local Hitbox = Instance.new("TextButton")
    Hitbox.Size = UDim2.new(1, 0, 1, 14)
    Hitbox.Position = UDim2.new(0, 0, 0, -7)
    Hitbox.BackgroundTransparency = 1
    Hitbox.Text = ""
    Hitbox.ZIndex = 10
    Hitbox.Parent = Track

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        K[key] = val
        ValueLabel.Text = tostring(val) .. (suffix or "")
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -6, 0.5, -6)
    end
    Hitbox.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(i) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

local function CreateButton(parent, text, callback, color)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 34)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 6
    Frame.Parent = parent

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundColor3 = color or Color3.fromRGB(139, 92, 246)
    Btn.BackgroundTransparency = 0.35
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Btn.ZIndex = 7
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play() end)
    Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.35}):Play() end)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function CreateDropdown(parent, text, options, key)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 6
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(210, 210, 220)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 7
    Label.Parent = Frame

    local Select = Instance.new("TextButton")
    Select.Size = UDim2.new(0, 110, 0, 24)
    Select.Position = UDim2.new(1, -114, 0.5, -12)
    Select.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
    Select.BorderSizePixel = 0
    Select.Text = K[key] or options[1]
    Select.TextColor3 = Color3.fromRGB(139, 92, 246)
    Select.TextSize = 11
    Select.Font = Enum.Font.GothamBold
    Select.ZIndex = 7
    Select.Parent = Frame
    Instance.new("UICorner", Select).CornerRadius = UDim.new(0, 6)

    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 16, 0, 16)
    Arrow.Position = UDim2.new(1, -18, 0, 4)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(139, 92, 246)
    Arrow.TextSize = 10
    Arrow.Font = Enum.Font.GothamBold
    Arrow.ZIndex = 8
    Arrow.Parent = Select

    local List = Instance.new("Frame")
    List.Size = UDim2.new(0, 110, 0, #options * 26)
    List.Position = UDim2.new(0, 0, 0, 26)
    List.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    List.BorderSizePixel = 0
    List.ZIndex = 12
    List.Visible = false
    List.Parent = Select
    Instance.new("UICorner", List).CornerRadius = UDim.new(0, 6)

    for i, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 26)
        OptBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 26)
        OptBtn.BackgroundTransparency = 1
        OptBtn.Text = opt
        OptBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
        OptBtn.TextSize = 11
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.ZIndex = 13
        OptBtn.Parent = List
        OptBtn.MouseEnter:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246); OptBtn.BackgroundTransparency = 0.8 end)
        OptBtn.MouseLeave:Connect(function() OptBtn.BackgroundTransparency = 1 end)
        OptBtn.MouseButton1Click:Connect(function() K[key] = opt; Select.Text = opt; List.Visible = false; Arrow.Text = "▼" end)
    end
    Select.MouseButton1Click:Connect(function() List.Visible = not List.Visible; Arrow.Text = List.Visible and "▲" or "▼" end)
end

-- ==========================================
-- TABS SETUP
-- ==========================================
local FarmTab = CreateTab("Farm", "⚡")
local BuildTab = CreateTab("Build", "🏗️")
local PlayerTab = CreateTab("Player", "🚀")
local WorldTab = CreateTab("World", "🌍")
local CopyTab = CreateTab("Copy", "📋")

-- FARM TAB
local s1 = CreateSection(FarmTab, "Farm Control")
local TimerFrame = Instance.new("Frame")
TimerFrame.Size = UDim2.new(1, 0, 0, 26)
TimerFrame.BackgroundTransparency = 1
TimerFrame.ZIndex = 6
TimerFrame.Parent = s1

local TimerLbl = Instance.new("TextLabel")
TimerLbl.Size = UDim2.new(1, 0, 1, 0)
TimerLbl.BackgroundTransparency = 1
TimerLbl.Text = "⏱ Farm Time: 00:00"
TimerLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
TimerLbl.TextSize = 13
TimerLbl.Font = Enum.Font.GothamBold
TimerLbl.ZIndex = 7
TimerLbl.Parent = TimerFrame
FarmTimerLabel = TimerLbl

CreateDropdown(s1, "Method:", {"Instant", "Tween", "Stages"}, "FarmMethod")

local FarmBtn = nil
CreateButton(s1, "▶ START FARM", function()
    K.Farm = not K.Farm
    if K.Farm then
        FarmStartTime = tick()
        FarmBtn.Text = "⏹ STOP FARM"
        Notify("Farm started: " .. K.FarmMethod)
    else
        FarmBtn.Text = "▶ START FARM"
        if CurrentTween then CurrentTween:Cancel() end
        Workspace.Gravity = 196.2
        Notify("Farm stopped")
    end
end, Color3.fromRGB(16, 185, 129))

-- Get reference to farm button
for _, ch in ipairs(s1:GetChildren()) do
    if ch:IsA("Frame") and ch:FindFirstChildOfClass("TextButton") and ch:FindFirstChildOfClass("TextButton").Text:find("FARM") then
        FarmBtn = ch:FindFirstChildOfClass("TextButton")
    end
end

local s2 = CreateSection(FarmTab, "Toggles")
CreateToggle(s2, "God Mode", "God")
CreateToggle(s2, "Anti-AFK", "AFK")

local s3 = CreateSection(FarmTab, "Settings")
CreateSlider(s3, "Farm Speed", 50, 500, 375, "FlySpd", "")
CreateSlider(s3, "Stage Delay", 1, 10, 3, "StageDelay", "s")

-- BUILD TAB
local s4 = CreateSection(BuildTab, "Blocks")
CreateToggle(s4, "Infinite Blocks", "InfBlocks")
CreateToggle(s4, "Fast Place", "FastPlace")
CreateToggle(s4, "Auto Weld", "AutoWeld")
CreateDropdown(s4, "Template:", {"GoldFarm", "Jet", "Boat", "Tower"}, "Template")

local s5 = CreateSection(BuildTab, "Actions")
CreateButton(s5, "▶ Build", function() K.Build = true end, Color3.fromRGB(16, 185, 129))
CreateButton(s5, "⏹ Stop", function() K.Build = false end, Color3.fromRGB(239, 68, 68))

-- PLAYER TAB
local s6 = CreateSection(PlayerTab, "Movement")
CreateToggle(s6, "Fly", "Fly")
CreateSlider(s6, "Fly Speed", 10, 500, 200, "FlySpd", "")
CreateToggle(s6, "Speed", "Speed")
CreateSlider(s6, "Walk Speed", 16, 200, 80, "WalkSpd", "")
CreateSlider(s6, "Jump Power", 10, 200, 50, "JumpPw", "")
CreateToggle(s6, "Noclip", "Noclip")

local s7 = CreateSection(PlayerTab, "Teleport")
CreateButton(s7, "Spawn", function()
    pcall(function()
        local h = GetHRP()
        if h then h.CFrame = CFrame.new(-43, 62, 672) end
    end)
end)
CreateButton(s7, "Gold Chest", function()
    pcall(function()
        local h = GetHRP()
        if h then h.CFrame = CFrame.new(-54, -345, 9488) end
    end)
end)
CreateButton(s7, "Stage 10", function()
    pcall(function()
        local st = Workspace:FindFirstChild
