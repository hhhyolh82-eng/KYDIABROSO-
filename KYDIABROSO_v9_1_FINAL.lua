-- ==========================================
-- KYDIABROSO v9.1 FINAL | Build a Boat for Treasure
-- PlaceId: 537413528
-- ==========================================

if game.PlaceId ~= 537413528 then
    warn("[KYDIABROSO] Only for Build a Boat for Treasure!")
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
-- STATE
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
    CopyTeam = "Pink"
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
-- GUI
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

-- Title
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
TitleLabel.Text = "KYDIABROSO v9.1"
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
-- TABS
-- ==========================================
local FarmTab = CreateTab("Farm", "⚡")
local BuildTab = CreateTab("Build", "🏗️")
local PlayerTab = CreateTab("Player", "🚀")
local WorldTab = CreateTab("World", "🌍")
local CopyTab = CreateTab("Copy", "📋")

-- FARM
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

local FarmBtn = CreateButton(s1, "▶ START FARM", function()
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

local s2 = CreateSection(FarmTab, "Toggles")
CreateToggle(s2, "God Mode", "God")
CreateToggle(s2, "Anti-AFK", "AFK")

local s3 = CreateSection(FarmTab, "Settings")
CreateSlider(s3, "Farm Speed", 50, 500, 375, "FlySpd", "")
CreateSlider(s3, "Stage Delay", 1, 10, 3, "StageDelay", "s")

-- BUILD
local s4 = CreateSection(BuildTab, "Blocks")
CreateToggle(s4, "Infinite Blocks", "InfBlocks")
CreateToggle(s4, "Fast Place", "FastPlace")
CreateToggle(s4, "Auto Weld", "AutoWeld")
CreateDropdown(s4, "Template:", {"GoldFarm", "Jet", "Boat", "Tower"}, "Template")

local s5 = CreateSection(BuildTab, "Actions")
CreateButton(s5, "▶ Build", function() K.Build = true end, Color3.fromRGB(16, 185, 129))
CreateButton(s5, "⏹ Stop", function() K.Build = false end, Color3.fromRGB(239, 68, 68))

-- PLAYER
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
        local st = Workspace:FindFirstChild("BoatStages") and Workspace.BoatStages:FindFirstChild("NormalStages")
        if st and st:FindFirstChild("CaveStage10") then
            local dp = st.CaveStage10:FindFirstChild("DarknessPart")
            if dp then
                local h = GetHRP()
                if h then h.CFrame = dp.CFrame end
            end
        end
    end)
end)

-- WORLD
local s8 = CreateSection(WorldTab, "Environment")
CreateToggle(s8, "Delete Water", "DelWater")
CreateToggle(s8, "No Fog", "NoFog")
CreateButton(s8, "Full Bright", function()
    pcall(function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
    end)
end)

-- COPY
local s9 = CreateSection(CopyTab, "Copy Builds")
CreateDropdown(s9, "Target Team:", {"Pink", "Magenta", "Black", "White", "Red", "Blue", "Green", "Yellow"}, "CopyTeam")
CreateButton(s9, "📋 Scan & Copy", function()
    K.Steal = true
    Notify("Scanning " .. K.CopyTeam .. " team build...")
end, Color3.fromRGB(245, 158, 11))
CreateButton(s9, "⏹ Stop Copy", function()
    K.Steal = false
    Notify("Copy stopped")
end, Color3.fromRGB(239, 68, 68))

-- Activate Farm tab
Tabs["Farm"].Frame.Visible = true
Tabs["Farm"].Button.TextColor3 = Color3.fromRGB(139, 92, 246)
Tabs["Farm"].Button.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
Tabs["Farm"].Button.BackgroundTransparency = 0.85

local yOffset = 10
for _, t in pairs(Tabs) do
    t.Button.Position = UDim2.new(0, 5, 0, yOffset)
    yOffset = yOffset + 36
end

-- ==========================================
-- TIMER
-- ==========================================
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if K.Farm and FarmTimerLabel then
            local elapsed = math.floor(tick() - FarmStartTime)
            local m = math.floor(elapsed / 60)
            local s = elapsed % 60
            FarmTimerLabel.Text = string.format("⏱ Farm Time: %02d:%02d", m, s)
        elseif FarmTimerLabel then
            FarmTimerLabel.Text = "⏱ Farm Time: 00:00"
        end
        task.wait(1)
    end
end)

-- ==========================================
-- GOD MODE
-- ==========================================
RunService.Heartbeat:Connect(function()
    if K.God then
        pcall(function()
            local h = GetHum()
            if h then h.MaxHealth = 1e9; h.Health = 1e9 end
        end)
    end
end)

-- ==========================================
-- ANTI-AFK
-- ==========================================
task.spawn(function()
    while true do
        if K.AFK then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.K, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.K, false, game)
            end)
        end
        task.wait(10)
    end
end)

-- ==========================================
-- SPEED & JUMP
-- ==========================================
RunService.Heartbeat:Connect(function()
    pcall(function()
        local h = GetHum()
        if h then
            if K.Speed then h.WalkSpeed = K.WalkSpd else h.WalkSpeed = 16 end
            h.JumpPower = K.JumpPw
        end
    end)
end)

-- ==========================================
-- INFINITE BLOCKS
-- ==========================================
task.spawn(function()
    while true do
        if K.InfBlocks then
            pcall(function()
                local bp = LP:FindFirstChild("Backpack")
                if bp then
                    for _, t in pairs(bp:GetChildren()) do
                        if t:IsA("Tool") then
                            local a = t:FindFirstChild("Amount")
                            if a then a.Value = 9999 end
                        end
                    end
                end
                local c = GetChar()
                for _, t in pairs(c:GetChildren()) do
                    if t:IsA("Tool") then
                        local a = t:FindFirstChild("Amount")
                        if a then a.Value = 9999 end
                    end
                end
            end)
        end
        task.wait(0.3)
    end
end)

-- ==========================================
-- FLY
-- ==========================================
local FlyBodyVel = nil
local FlyConnection = nil

local function StartFly()
    pcall(function()
        if FlyBodyVel then FlyBodyVel:Destroy() end
        local hrp = GetHRP()
        if not hrp then return end
        FlyBodyVel = Instance.new("BodyVelocity")
        FlyBodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyVel.Velocity = Vector3.zero
        FlyBodyVel.Parent = hrp
    end)
    FlyConnection = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not K.Fly or not FlyBodyVel then return end
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then dir = dir.Unit * K.FlySpd end
            FlyBodyVel.Velocity = dir
        end)
    end)
end

local function StopFly()
    pcall(function() if FlyConnection then FlyConnection:Disconnect() end end)
    pcall(function() if FlyBodyVel then FlyBodyVel:Destroy() end end)
    FlyConnection = nil
    FlyBodyVel = nil
end

-- ==========================================
-- NOCLIP
-- ==========================================
local NoclipConnection = nil
local function StartNoclip()
    NoclipConnection = RunService.Stepped:Connect(function()
        pcall(function()
            if not K.Noclip then return end
            local c = GetChar()
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end)
end

local function StopNoclip()
    pcall(function() if NoclipConnection then NoclipConnection:Disconnect() end end)
    NoclipConnection = nil
    pcall(function()
        local c = GetChar()
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end)
end

-- ==========================================
-- FLY/NOCLIP MONITOR
-- ==========================================
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if K.Fly and not FlyConnection then StartFly() end
        if not K.Fly and FlyConnection then StopFly() end
        if K.Noclip and not NoclipConnection then StartNoclip() end
        if not K.Noclip and NoclipConnection then StopNoclip() end
        task.wait(0.3)
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if K.Fly then StartFly() end
    if K.Noclip then StartNoclip() end
end)

-- ==========================================
-- FARM DESTINATIONS
-- ==========================================
local StagePoints = {
    CFrame.new(-43.6, 62.1, 672.7),
    CFrame.new(-60.1, 97.4, 8767.9),
    CFrame.new(-54.3, -345.4, 9488.6),
}

local function CollectGold()
    pcall(function()
        local hrp = GetHRP()
        if not hrp then return end
        for _, o in pairs(Workspace:GetDescendants()) do
            if o:IsA("BasePart") and o:FindFirstChild("TouchInterest") then
                local n = o.Name:lower()
                if n:find("gold") or n:find("coin") or n:find("nugget") or n:find("treasure") then
                    if (o.Position - hrp.Position).Magnitude <= 60 then
                        firetouchinterest(hrp, o, 0)
                        firetouchinterest(hrp, o, 1)
                    end
                end
            end
            if o:IsA("ClickDetector") then
                local par = o.Parent
                if par and par:IsA("BasePart") then
                    local n = par.Name:lower()
                    if n:find("gold") or n:find("statue") or n:find("chest") then
                        if (par.Position - hrp.Position).Magnitude <= 60 then
                            pcall(function() fireclickdetector(o, 50) end)
                        end
                    end
                end
            end
        end
    end)
end

local function TweenTo(cf, spd)
    local hrp = GetHRP()
    if not hrp then return end
    local d = (hrp.Position - cf.Position).Magnitude
    CurrentTween = TweenService:Create(hrp, TweenInfo.new(d / (spd or 375), Enum.EasingStyle.Linear), {CFrame = cf})
    CurrentTween:Play()
    CurrentTween.Completed:Wait()
end

local function DoInstantFarm()
    pcall(function()
        local hrp = GetHRP()
        if not hrp then return end
        local rem = Workspace:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Remotes")
        if rem and rem:FindFirstChild("launchBoat") then
            rem.launchBoat:FireServer()
        end
        local chest = Workspace:FindFirstChild("BoatStages")
            and Workspace.BoatStages:FindFirstChild("NormalStages")
            and Workspace.BoatStages.NormalStages:FindFirstChild("TheEnd")
            and Workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
            and Workspace.BoatStages.NormalStages.TheEnd.GoldenChest:FindFirstChild("Trigger")
        if chest then
            hrp.CFrame = chest.CFrame + Vector3.new(0, 5, 0)
            CollectGold()
            task.wait(1.5)
        else
            hrp.CFrame = CFrame.new(-54, -345, 9488)
            CollectGold()
            task.wait(1.5)
        end
        local h = GetHum()
        if h then h.Health = 0 end
        task.wait(7)
    end)
end

local function DoTweenFarm()
    pcall(function()
        Workspace.Gravity = 0
        for _, cf in ipairs(StagePoints) do
            if not K.Farm then break end
            TweenTo(cf, K.FlySpd)
            CollectGold()
            task.wait(0.5)
        end
        local chest = Workspace:FindFirstChild("BoatStages")
            and Workspace.BoatStages:FindFirstChild("NormalStages")
            and Workspace.BoatStages.NormalStages:FindFirstChild("TheEnd")
            and Workspace.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")
            and Workspace.BoatStages.NormalStages.TheEnd.GoldenChest:FindFirstChild("Trigger")
        if chest and K.Farm then
            TweenTo(chest.CFrame + Vector3.new(0, 5, 0), K.FlySpd)
            CollectGold()
        end
        Workspace.Gravity = 196.2
        if K.Farm then
            task.wait(1)
            local h = GetHum()
            if h then h.Health = 0 end
            task.wait(7)
        end
    end)
end

local function DoStageFarm()
    pcall(function()
        local st = Workspace:FindFirstChild("BoatStages") and Workspace.BoatStages:FindFirstChild("NormalStages")
        if not st then return end
        for i = 1, 10 do
            if not K.Farm then break end
            local stage = st:FindFirstChild("CaveStage" .. i)
            if stage then
                local dp = stage:FindFirstChild("DarknessPart")
                if dp then
                    local hrp = GetHRP()
                    if hrp then hrp.CFrame = dp.CFrame end
                    CollectGold()
                    pcall(function()
                        local ge = ReplicatedStorage:FindFirstChild("ClaimRiverResultsGold") or Workspace:FindFirstChild("ClaimRiverResultsGold")
                        if ge then ge:FireServer() end
                    end)
                    task.wait(K.StageDelay or 0.5)
                end
            end
        end
        local chest = st:FindFirstChild("TheEnd") and st.TheEnd:FindFirstChild("GoldenChest") and st.TheEnd.GoldenChest:FindFirstChild("Trigger")
        if chest and K.Farm then
            local hrp = GetHRP()
            if hrp then hrp.CFrame = chest.CFrame + Vector3.new(0, 5, 0) end
            CollectGold()
            task.wait(1.5)
        end
        if K.Farm then
            local h = GetHum()
            if h then h.Health = 0 end
            task.wait(7)
        end
    end)
end

-- ==========================================
-- MAIN FARM LOOP
-- ==========================================
task.spawn(function()
    while true do
        if K.Farm then
            if K.FarmMethod == "Instant" then
                DoInstantFarm()
            elseif K.FarmMethod == "Tween" then
                DoTweenFarm()
            elseif K.FarmMethod == "Stages" then
                DoStageFarm()
            end
        end
        task.wait(0.5)
    end
end)

-- ==========================================
-- BUILD SYSTEM
-- ==========================================
local Templates = {
    GoldFarm = {
        {b = "WoodBlock", p = Vector3.new(0, 0, 0)},
        {b = "WoodBlock", p = Vector3.new(0, 1, 0)},
        {b = "Seat", p = Vector3.new(0, 2, 0)},
        {b = "Thruster", p = Vector3.new(0, 0, -2)},
        {b = "Balloon", p = Vector3.new(-1, 2, 0)},
        {b = "Balloon", p = Vector3.new(1, 2, 0)}
    },
    Jet = {
        {b = "WoodBlock", p = Vector3.new(0, 0, 0)},
        {b = "WoodBlock", p = Vector3.new(0, 1, 0)},
        {b = "Seat", p = Vector3.new(0, 2, 0)},
        {b = "Thruster", p = Vector3.new(-1, 0, -3)},
        {b = "Thruster", p = Vector3.new(1, 0, -3)}
    },
    Boat = {
        {b = "WoodBlock", p = Vector3.new(0, 0, 0)},
        {b = "Seat", p = Vector3.new(0, 0, 0)},
        {b = "Thruster", p = Vector3.new(0, 0, -3)}
    },
    Tower = {
        {b = "WoodBlock", p = Vector3.new(0, 0, 0)},
        {b = "WoodBlock", p = Vector3.new(0, 1, 0)},
        {b = "WoodBlock", p = Vector3.new(0, 2, 0)},
        {b = "Seat", p = Vector3.new(0, 3, 0)},
        {b = "Thruster", p = Vector3.new(0, 0, -2)}
    }
}

local function PlaceBlock(blockName, cframe)
    pcall(function()
        local tool = GetChar():FindFirstChildOfClass("Tool")
        if not tool then
            local bp = LP:FindFirstChild("Backpack")
            if bp then
                for _, t in pairs(bp:GetChildren()) do
                    if t:IsA("Tool") and (t.Name:lower():find("block") or t.Name:lower():find("wood") or t.Name:lower():find("thruster") or t.Name:lower():find("seat") or t.Name:lower():find("balloon")) then
                        t.Parent = GetChar()
                        tool = t
                        break
                    end
                end
            end
        end
        if tool then
            local ev = tool:FindFirstChild("BuildEvent") or tool:FindFirstChild("PlaceBlock") or tool:FindFirstChild("Place")
            if ev then
                ev:FireServer(cframe.Position, cframe)
            end
        end
    end)
end

task.spawn(function()
    while true do
        if K.Build then
            pcall(function()
                local tm = Templates[K.Template]
                if tm then
                    local hrp = GetHRP()
                    if not hrp then return end
                    local base = hrp.Position
                    for _, d in ipairs(tm) do
                        if not K.Build then break end
                        PlaceBlock(d.b, CFrame.new(base + d.p))
                        task.wait(K.FastPlace and 0.05 or 0.15)
                    end
                    if K.AutoWeld then
                        task.wait(0.5)
                        for _, bt in pairs(Workspace:GetChildren()) do
                            if bt.Name:find(LP.Name) or bt.Name:lower():find("boat") then
                                local pts = {}
                                for _, pt in pairs(bt:GetDescendants()) do
                                    if pt:IsA("BasePart") then table.insert(pts, pt) end
                                end
                                for i = 2, #pts do
                                    local wl = Instance.new("WeldConstraint")
                                    wl.Part0 = pts[1]
                                    wl.Part1 = pts[i]
                                    wl.Parent = pts[i]
                                end
                            end
                        end
                    end
                    K.Build = false
                    Notify("Build completed!")
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- ==========================================
-- COPY / STEAL BUILD
-- ==========================================
local function GetTeamColor(teamName)
    local colors = {
        Pink = BrickColor.new("Hot pink"),
        Magenta = BrickColor.new("Magenta"),
        Black = BrickColor.new("Really black"),
        White = BrickColor.new("White"),
        Red = BrickColor.new("Bright red"),
        Blue = BrickColor.new("Bright blue"),
        Green = BrickColor.new("Bright green"),
        Yellow = BrickColor.new("Bright yellow")
    }
    return colors[teamName]
end

local function ScanAndCopyBuild()
    pcall(function()
        local hrp = GetHRP()
        if not hrp then
            K.Steal = false
            return
        end

        local targetColor = GetTeamColor(K.CopyTeam)
        if not targetColor then
            Notify("Invalid team color!")
            K.Steal = false
            return
        end

        local targetBlocks = {}
        local myPos = hrp.Position

        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.BrickColor == targetColor then
                if obj.Name:lower():find("block") or obj.Name:lower():find("seat") or
                   obj.Name:lower():find("thruster") or obj.Name:lower():find("balloon") or
                   obj.Name:lower():find("wood") or obj.Name:lower():find("plastic") then
                    table.insert(targetBlocks, {
                        Name = obj.Name,
                        Position = obj.Position,
                        CFrame = obj.CFrame,
                        Size = obj.Size
                    })
                end
            end
        end

        if #targetBlocks == 0 then
            Notify("No blocks found for " .. K.CopyTeam .. " team!")
            K.Steal = false
            return
        end

        Notify("Found " .. #targetBlocks .. " blocks! Copying...")

        local avgPos = Vector3.new(0, 0, 0)
        for _, b in ipairs(targetBlocks) do
            avgPos = avgPos + b.Position
        end
        avgPos = avgPos / #targetBlocks

        local offset = myPos - avgPos + Vector3.new(0, 5, 0)

        for i, b in ipairs(targetBlocks) do
            if not K.Steal then break end
            PlaceBlock(b.Name, CFrame.new(b.Position + offset))
            if i % 10 == 0 then
                task.wait(0.1)
            end
            task.wait(K.FastPlace and 0.03 or 0.08)
        end

        K.Steal = false
        Notify("Copy completed! " .. #targetBlocks .. " blocks placed.")
    end)
end

task.spawn(function()
    while true do
        if K.Steal then
            ScanAndCopyBuild()
        end
        task.wait(1)
    end
end)

-- ==========================================
-- WORLD MODS
-- ==========================================
local function DeleteWater()
    pcall(function()
        for _, o in pairs(Workspace:GetDescendants()) do
            if o.Name:lower():find("water") and o:IsA("BasePart") then
                o:Destroy()
            end
        end
        if Workspace:FindFirstChild("Terrain") then
            Workspace.Terrain:Clear()
        end
    end)
end

local function RemoveFog()
    pcall(function()
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") then v:Destroy() end
        end
    end)
end

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if K.DelWater then DeleteWater() end
        if K.NoFog then RemoveFog() end
        task.wait(2)
    end
end)

-- ==========================================
-- DRAG GUI
-- ==========================================
local dragging, dragStart, startPos = false, nil, nil
TitleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ==========================================
-- OPEN ANIMATION
-- ==========================================
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 520, 0, 360),
    Position = UDim2.new(0.5, -260, 0.5, -180)
}):Play()

print("[KYDIABROSO] v9.1 FINAL Loaded | Farm + Build Copy + All fixes")
Notify("KYDIABROSO v9.1 Loaded Successfully!")
