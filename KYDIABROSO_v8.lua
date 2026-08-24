-- KYDIABROSO v8.0 PRO | Build A Boat For Treasure
-- All features fixed: Speed, Jump, Fly, Farm, Build, Timer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

if game.PlaceId ~= 537413528 then
    warn("[KYDIABROSO] Only for Build A Boat For Treasure!")
    return
end

-- ==================== STATE ====================
local K = {
    Farm = false, FarmMethod = "Instant", God = false, AFK = false,
    Inf = false, Fast = false, Weld = false, Build = false, Steal = false,
    Fly = false, Spd = false, Noclip = false, DelW = false, NoFog = false,
    FlySpd = 200, WalkSpd = 80, JumpPw = 50,
    Template = "GoldFarm",
}

local FarmStartTime = 0
local FarmTimerLabel = nil

-- ==================== UTILS ====================
local function Ch() return LP.Character or LP.CharacterAdded:Wait() end
local function Hrp()
    local c = Ch()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function Hum()
    local c = Ch()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ==================== GUI ====================
local S = Instance.new("ScreenGui")
S.Name = "KYDIABROSO_v8"
S.ResetOnSpawn = false
S.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
S.Parent = CoreGui

local M = Instance.new("Frame")
M.Size = UDim2.new(0, 520, 0, 360)
M.Position = UDim2.new(0.5, -260, 0.5, -180)
M.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
M.BorderSizePixel = 0
M.Active = true
M.Parent = S
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 12)

local Str = Instance.new("UIStroke")
Str.Color = Color3.fromRGB(139, 92, 246)
Str.Thickness = 1.2
Str.Transparency = 0.5
Str.Parent = M

-- Title
local Tb = Instance.new("Frame")
Tb.Size = UDim2.new(1, 0, 0, 34)
Tb.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
Tb.BorderSizePixel = 0
Tb.ZIndex = 5
Tb.Parent = M
Instance.new("UICorner", Tb).CornerRadius = UDim.new(0, 12)

local Tf = Instance.new("Frame")
Tf.Size = UDim2.new(0, 24, 0, 34)
Tf.Position = UDim2.new(1, -24, 0, 0)
Tf.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
Tf.BorderSizePixel = 0
Tf.ZIndex = 5
Tf.Parent = Tb

local Tl = Instance.new("TextLabel")
Tl.Size = UDim2.new(1, -60, 1, 0)
Tl.Position = UDim2.new(0, 14, 0, 0)
Tl.BackgroundTransparency = 1
Tl.Text = "KYDIABROSO  v8.0"
Tl.TextColor3 = Color3.fromRGB(139, 92, 246)
Tl.TextSize = 18
Tl.Font = Enum.Font.GothamBold
Tl.TextXAlignment = Enum.TextXAlignment.Left
Tl.ZIndex = 6
Tl.Parent = Tb

local X = Instance.new("TextButton")
X.Size = UDim2.new(0, 28, 0, 28)
X.Position = UDim2.new(1, -32, 0, 3)
X.BackgroundTransparency = 1
X.Text = "×"
X.TextColor3 = Color3.fromRGB(180, 180, 180)
X.TextSize = 22
X.Font = Enum.Font.GothamBold
X.ZIndex = 6
X.Parent = Tb
X.MouseEnter:Connect(function() X.TextColor3 = Color3.fromRGB(255, 80, 80) end)
X.MouseLeave:Connect(function() X.TextColor3 = Color3.fromRGB(180, 180, 180) end)
X.MouseButton1Click:Connect(function() S:Destroy() end)

-- Sidebar
local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0, 110, 1, -34)
Bar.Position = UDim2.new(0, 0, 0, 34)
Bar.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
Bar.BorderSizePixel = 0
Bar.ZIndex = 4
Bar.Parent = M
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 12)

local Bf = Instance.new("Frame")
Bf.Size = UDim2.new(0, 22, 1, 0)
Bf.Position = UDim2.new(1, -22, 0, 0)
Bf.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
Bf.BorderSizePixel = 0
Bf.ZIndex = 4
Bf.Parent = Bar

local Cont = Instance.new("Frame")
Cont.Size = UDim2.new(1, -118, 1, -42)
Cont.Position = UDim2.new(0, 114, 0, 38)
Cont.BackgroundTransparency = 1
Cont.ZIndex = 5
Cont.Parent = M

local Tabs = {}

local function Tab(n, ico)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -10, 0, 32)
    B.BackgroundTransparency = 1
    B.Text = "  " .. ico .. "  " .. n
    B.TextColor3 = Color3.fromRGB(130, 130, 150)
    B.TextSize = 12
    B.Font = Enum.Font.GothamSemibold
    B.TextXAlignment = Enum.TextXAlignment.Left
    B.ZIndex = 5
    B.Parent = Bar

    local F = Instance.new("ScrollingFrame")
    F.Name = n
    F.Size = UDim2.new(1, -4, 1, -4)
    F.Position = UDim2.new(0, 2, 0, 2)
    F.BackgroundTransparency = 1
    F.BorderSizePixel = 0
    F.ScrollBarThickness = 3
    F.ScrollBarImageColor3 = Color3.fromRGB(139, 92, 246)
    F.Visible = false
    F.ZIndex = 5
    F.Parent = Cont

    local Ly = Instance.new("UIListLayout")
    Ly.Padding = UDim.new(0, 8)
    Ly.Parent = F

    Tabs[n] = {Button = B, Frame = F}

    B.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Frame.Visible = false
            t.Button.TextColor3 = Color3.fromRGB(130, 130, 150)
            t.Button.BackgroundTransparency = 1
        end
        F.Visible = true
        B.TextColor3 = Color3.fromRGB(139, 92, 246)
        B.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
        B.BackgroundTransparency = 0.85
    end)
    return F
end

local function Sec(p, t)
    local Fr = Instance.new("Frame")
    Fr.Size = UDim2.new(1, -4, 0, 0)
    Fr.AutomaticSize = Enum.AutomaticSize.Y
    Fr.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
    Fr.BackgroundTransparency = 0.3
    Fr.BorderSizePixel = 0
    Fr.ZIndex = 5
    Fr.Parent = p
    Instance.new("UICorner", Fr).CornerRadius = UDim.new(0, 8)

    local H = Instance.new("TextLabel")
    H.Size = UDim2.new(1, -12, 0, 24)
    H.Position = UDim2.new(0, 10, 0, 4)
    H.BackgroundTransparency = 1
    H.Text = t
    H.TextColor3 = Color3.fromRGB(139, 92, 246)
    H.TextSize = 13
    H.Font = Enum.Font.GothamBold
    H.TextXAlignment = Enum.TextXAlignment.Left
    H.ZIndex = 6
    H.Parent = Fr

    local Cn = Instance.new("Frame")
    Cn.Size = UDim2.new(1, -14, 0, 0)
    Cn.Position = UDim2.new(0, 7, 0, 26)
    Cn.AutomaticSize = Enum.AutomaticSize.Y
    Cn.BackgroundTransparency = 1
    Cn.ZIndex = 6
    Cn.Parent = Fr

    local L = Instance.new("UIListLayout")
    L.Padding = UDim.new(0, 6)
    L.Parent = Cn

    return Cn
end

local function Tog(p, txt, key)
    local Fr = Instance.new("Frame")
    Fr.Size = UDim2.new(1, 0, 0, 30)
    Fr.BackgroundTransparency = 1
    Fr.ZIndex = 6
    Fr.Parent = p

    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(0.6, 0, 1, 0)
    Lb.BackgroundTransparency = 1
    Lb.Text = txt
    Lb.TextColor3 = Color3.fromRGB(210, 210, 220)
    Lb.TextSize = 12
    Lb.Font = Enum.Font.Gotham
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.ZIndex = 7
    Lb.Parent = Fr

    local Bg = Instance.new("TextButton")
    Bg.Size = UDim2.new(0, 40, 0, 22)
    Bg.Position = UDim2.new(1, -44, 0.5, -11)
    Bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Bg.BorderSizePixel = 0
    Bg.Text = ""
    Bg.ZIndex = 7
    Bg.Parent = Fr
    Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

    local Kn = Instance.new("Frame")
    Kn.Size = UDim2.new(0, 18, 0, 18)
    Kn.Position = UDim2.new(0, 2, 0.5, -9)
    Kn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    Kn.BorderSizePixel = 0
    Kn.ZIndex = 8
    Kn.Parent = Bg
    Instance.new("UICorner", Kn).CornerRadius = UDim.new(1, 0)

    local on = K[key]
    local function Up()
        if on then
            TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(139, 92, 246)}):Play()
            TweenService:Create(Kn, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        else
            TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
            TweenService:Create(Kn, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        end
        K[key] = on
    end
    Up()
    Bg.MouseButton1Click:Connect(function() on = not on; Up() end)
end

local function Sld(p, txt, mi, ma, def, key, sfx)
    local Fr = Instance.new("Frame")
    Fr.Size = UDim2.new(1, 0, 0, 44)
    Fr.BackgroundTransparency = 1
    Fr.ZIndex = 6
    Fr.Parent = p

    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(0.5, 0, 0, 18)
    Lb.BackgroundTransparency = 1
    Lb.Text = txt
    Lb.TextColor3 = Color3.fromRGB(210, 210, 220)
    Lb.TextSize = 12
    Lb.Font = Enum.Font.Gotham
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.ZIndex = 7
    Lb.Parent = Fr

    local Vl = Instance.new("TextLabel")
    Vl.Size = UDim2.new(0.3, 0, 0, 18)
    Vl.Position = UDim2.new(0.7, 0, 0, 0)
    Vl.BackgroundTransparency = 1
    Vl.Text = tostring(def) .. (sfx or "")
    Vl.TextColor3 = Color3.fromRGB(139, 92, 246)
    Vl.TextSize = 12
    Vl.Font = Enum.Font.GothamBold
    Vl.TextXAlignment = Enum.TextXAlignment.Right
    Vl.ZIndex = 7
    Vl.Parent = Fr

    local Tk = Instance.new("Frame")
    Tk.Size = UDim2.new(1, 0, 0, 5)
    Tk.Position = UDim2.new(0, 0, 0, 28)
    Tk.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Tk.BorderSizePixel = 0
    Tk.ZIndex = 7
    Tk.Parent = Fr
    Instance.new("UICorner", Tk).CornerRadius = UDim.new(1, 0)

    local Fl = Instance.new("Frame")
    Fl.Size = UDim2.new((def - mi) / (ma - mi), 0, 1, 0)
    Fl.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    Fl.BorderSizePixel = 0
    Fl.ZIndex = 8
    Fl.Parent = Tk
    Instance.new("UICorner", Fl).CornerRadius = UDim.new(1, 0)

    local Kb = Instance.new("Frame")
    Kb.Size = UDim2.new(0, 12, 0, 12)
    Kb.Position = UDim2.new((def - mi) / (ma - mi), -6, 0.5, -6)
    Kb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Kb.BorderSizePixel = 0
    Kb.ZIndex = 9
    Kb.Parent = Tk
    Instance.new("UICorner", Kb).CornerRadius = UDim.new(1, 0)

    local Ht = Instance.new("TextButton")
    Ht.Size = UDim2.new(1, 0, 1, 14)
    Ht.Position = UDim2.new(0, 0, 0, -7)
    Ht.BackgroundTransparency = 1
    Ht.Text = ""
    Ht.ZIndex = 10
    Ht.Parent = Tk

    local dg = false
    local function Upd(i)
        local ps = math.clamp((i.Position.X - Tk.AbsolutePosition.X) / Tk.AbsoluteSize.X, 0, 1)
        local v = math.floor(mi + (ma - mi) * ps)
        K[key] = v
        Vl.Text = tostring(v) .. (sfx or "")
        Fl.Size = UDim2.new(ps, 0, 1, 0)
        Kb.Position = UDim2.new(ps, -6, 0.5, -6)
    end
    Ht.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = true; Upd(i) end end)
    UserInputService.InputChanged:Connect(function(i) if dg and i.UserInputType == Enum.UserInputType.MouseMovement then Upd(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = false end end)
end

local function Btn(p, txt, cb, col)
    local Fr = Instance.new("Frame")
    Fr.Size = UDim2.new(1, 0, 0, 34)
    Fr.BackgroundTransparency = 1
    Fr.ZIndex = 6
    Fr.Parent = p

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 1, 0)
    B.BackgroundColor3 = col or Color3.fromRGB(139, 92, 246)
    B.BackgroundTransparency = 0.35
    B.BorderSizePixel = 0
    B.Text = txt
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.TextSize = 12
    B.Font = Enum.Font.GothamBold
    B.ZIndex = 7
    B.Parent = Fr
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)

    B.MouseEnter:Connect(function() TweenService:Create(B, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play() end)
    B.MouseLeave:Connect(function() TweenService:Create(B, TweenInfo.new(0.15), {BackgroundTransparency = 0.35}):Play() end)
    B.MouseButton1Click:Connect(cb)
end

local function Drp(p, txt, opts, key)
    local Fr = Instance.new("Frame")
    Fr.Size = UDim2.new(1, 0, 0, 30)
    Fr.BackgroundTransparency = 1
    Fr.ZIndex = 6
    Fr.Parent = p

    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(0.4, 0, 1, 0)
    Lb.BackgroundTransparency = 1
    Lb.Text = txt
    Lb.TextColor3 = Color3.fromRGB(210, 210, 220)
    Lb.TextSize = 12
    Lb.Font = Enum.Font.Gotham
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.ZIndex = 7
    Lb.Parent = Fr

    local Sel = Instance.new("TextButton")
    Sel.Size = UDim2.new(0, 110, 0, 24)
    Sel.Position = UDim2.new(1, -114, 0.5, -12)
    Sel.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
    Sel.BorderSizePixel = 0
    Sel.Text = K[key] or opts[1]
    Sel.TextColor3 = Color3.fromRGB(139, 92, 246)
    Sel.TextSize = 11
    Sel.Font = Enum.Font.GothamBold
    Sel.ZIndex = 7
    Sel.Parent = Fr
    Instance.new("UICorner", Sel).CornerRadius = UDim.new(0, 6)

    local Ar = Instance.new("TextLabel")
    Ar.Size = UDim2.new(0, 16, 0, 16)
    Ar.Position = UDim2.new(1, -18, 0, 4)
    Ar.BackgroundTransparency = 1
    Ar.Text = "▼"
    Ar.TextColor3 = Color3.fromRGB(139, 92, 246)
    Ar.TextSize = 10
    Ar.Font = Enum.Font.GothamBold
    Ar.ZIndex = 8
    Ar.Parent = Sel

    local Ls = Instance.new("Frame")
    Ls.Size = UDim2.new(0, 110, 0, #opts * 26)
    Ls.Position = UDim2.new(0, 0, 0, 26)
    Ls.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
    Ls.BorderSizePixel = 0
    Ls.ZIndex = 12
    Ls.Visible = false
    Ls.Parent = Sel
    Instance.new("UICorner", Ls).CornerRadius = UDim.new(0, 6)

    for i, o in ipairs(opts) do
        local Bt = Instance.new("TextButton")
        Bt.Size = UDim2.new(1, 0, 0, 26)
        Bt.Position = UDim2.new(0, 0, 0, (i - 1) * 26)
        Bt.BackgroundTransparency = 1
        Bt.Text = o
        Bt.TextColor3 = Color3.fromRGB(180, 180, 190)
        Bt.TextSize = 11
        Bt.Font = Enum.Font.Gotham
        Bt.ZIndex = 13
        Bt.Parent = Ls
        Bt.MouseEnter:Connect(function() Bt.BackgroundColor3 = Color3.fromRGB(139, 92, 246); Bt.BackgroundTransparency = 0.8 end)
        Bt.MouseLeave:Connect(function() Bt.BackgroundTransparency = 1 end)
        Bt.MouseButton1Click:Connect(function() K[key] = o; Sel.Text = o; Ls.Visible = false; Ar.Text = "▼" end)
    end
    Sel.MouseButton1Click:Connect(function() Ls.Visible = not Ls.Visible; Ar.Text = Ls.Visible and "▲" or "▼" end)
end

-- ==================== TABS ====================
local Farm = Tab("Farm", "⚡")
local Build = Tab("Build", "🏗️")
local Play = Tab("Player", "🚀")
local World = Tab("World", "🌍")

-- Farm
local s1 = Sec(Farm, "Farm Controls")

-- Timer Label
local TimerFr = Instance.new("Frame")
TimerFr.Size = UDim2.new(1, 0, 0, 26)
TimerFr.BackgroundTransparency = 1
TimerFr.ZIndex = 6
TimerFr.Parent = s1

local TimerLbl = Instance.new("TextLabel")
TimerLbl.Size = UDim2.new(1, 0, 1, 0)
TimerLbl.BackgroundTransparency = 1
TimerLbl.Text = "⏱ Farm Time: 00:00"
TimerLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
TimerLbl.TextSize = 13
TimerLbl.Font = Enum.Font.GothamBold
TimerLbl.ZIndex = 7
TimerLbl.Parent = TimerFr
FarmTimerLabel = TimerLbl

Drp(s1, "Method:", {"Instant", "Tween", "Stages"}, "FarmMethod")

local FarmBtn = nil
Btn(s1, "▶ START FARM", function()
    K.Farm = not K.Farm
    if K.Farm then
        FarmStartTime = tick()
        FarmBtn.Text = "⏹ STOP FARM"
        print("[KYDIABROSO] Farm started: " .. K.FarmMethod)
    else
        FarmBtn.Text = "▶ START FARM"
        print("[KYDIABROSO] Farm stopped")
    end
end, Color3.fromRGB(16, 185, 129))
-- Получаем ссылку на кнопку (последняя созданная)
for _, ch in ipairs(s1:GetChildren()) do
    if ch:IsA("Frame") and ch:FindFirstChildOfClass("TextButton") then
        FarmBtn = ch:FindFirstChildOfClass("TextButton")
    end
end

local s2 = Sec(Farm, "Toggles")
Tog(s2, "God Mode", "God")
Tog(s2, "Anti-AFK", "AFK")

local s3 = Sec(Farm, "Settings")
Sld(s3, "Farm Speed", 50, 500, 375, "FlySpd", "")
Sld(s3, "Stage Delay", 1, 10, 3, "StgDel", "s")

-- Build
local s4 = Sec(Build, "Blocks")
Tog(s4, "Infinite Blocks", "Inf")
Tog(s4, "Fast Place", "Fast")
Tog(s4, "Auto Weld", "Weld")
Drp(s4, "Template:", {"GoldFarm", "Jet", "Boat", "Tower"}, "Template")

local s5 = Sec(Build, "Actions")
Btn(s5, "▶ Build", function() K.Build = true end, Color3.fromRGB(16, 185, 129))
Btn(s5, "⏹ Stop", function() K.Build = false end, Color3.fromRGB(239, 68, 68))
Btn(s5, "📋 Steal", function() K.Steal = true end, Color3.fromRGB(245, 158, 11))

-- Player
local s6 = Sec(Play, "Movement")
Tog(s6, "Fly", "Fly")
Sld(s6, "Fly Speed", 10, 500, 200, "FlySpd", "")
Tog(s6, "Speed", "Spd")
Sld(s6, "Walk Speed", 16, 200, 80, "WalkSpd", "")
Sld(s6, "Jump Power", 10, 200, 50, "JumpPw", "")
Tog(s6, "Noclip", "Noclip")

local s7 = Sec(Play, "Teleports")
Btn(s7, "Spawn", function() pcall(function() local h = Hrp() if h then h.CFrame = CFrame.new(-43, 62, 672) end end) end)
Btn(s7, "Gold Chest", function() pcall(function() local h = Hrp() if h then h.CFrame = CFrame.new(-54, -345, 9488) end end) end)
Btn(s7, "Stage 10", function()
    pcall(function()
        local st = W:FindFirstChild("BoatStages") and W.BoatStages:FindFirstChild("NormalStages")
        if st and st:FindFirstChild("CaveStage10") then
            local dp = st.CaveStage10:FindFirstChild("DarknessPart")
            if dp then local h = Hrp() if h then h.CFrame = dp.CFrame end end
        end
    end)
end)

-- World
local s8 = Sec(World, "Environment")
Tog(s8, "Delete Water", "DelW")
Tog(s8, "No Fog", "NoFog")
Btn(s8, "Full Bright", function()
    pcall(function() Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false; Lighting.FogEnd = 100000 end)
end)

-- Activate Farm
Tabs["Farm"].Frame.Visible = true
Tabs["Farm"].Button.TextColor3 = Color3.fromRGB(139, 92, 246)
Tabs["Farm"].Button.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
Tabs["Farm"].Button.BackgroundTransparency = 0.85

local y = 10
for _, t in pairs(Tabs) do t.Button.Position = UDim2.new(0, 5, 0, y); y = y + 36 end

-- ==================== TIMER ====================
task.spawn(function()
    while S and S.Parent do
        if K.Farm and FarmTimerLabel then
            local e = math.floor(tick() - FarmStartTime)
            local m = math.floor(e / 60)
            local s = e % 60
            FarmTimerLabel.Text = string.format("⏱ Farm Time: %02d:%02d", m, s)
        elseif FarmTimerLabel then
            FarmTimerLabel.Text = "⏱ Farm Time: 00:00"
        end
        task.wait(1)
    end
end)

-- ==================== GOD MODE ====================
RunService.Heartbeat:Connect(function()
    if K.God then
        pcall(function()
            local h = Hum()
            if h then h.MaxHealth = 1e9; h.Health = 1e9 end
        end)
    end
end)

-- ==================== ANTI-AFK ====================
task.spawn(function()
    while true do
        if K.AFK then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.K, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.K, false, game)
        end
        task.wait(10)
    end
end)

-- ==================== SPEED & JUMP (Heartbeat) ====================
RunService.Heartbeat:Connect(function()
    pcall(function()
        local h = Hum()
        if h then
            if K.Spd then h.WalkSpeed = K.WalkSpd else h.WalkSpeed = 16 end
            h.JumpPower = K.JumpPw
        end
    end)
end)

-- ==================== INFINITE BLOCKS ====================
task.spawn(function()
    while true do
        if K.Inf then
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
                local c = Ch()
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

-- ==================== FLY ====================
local FlyObj = nil
local FlyConn = nil

local function StartFly()
    pcall(function()
        if FlyObj then FlyObj:Destroy() end
        local hrp = Hrp()
        if not hrp then return end
        FlyObj = Instance.new("BodyVelocity")
        FlyObj.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        FlyObj.Velocity = Vector3.zero
        FlyObj.Parent = hrp
    end)
    FlyConn = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not K.Fly or not FlyObj then return end
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then dir = dir.Unit * K.FlySpd end
            FlyObj.Velocity = dir
        end)
    end)
end

local function StopFly()
    pcall(function() if FlyConn then FlyConn:Disconnect() end end)
    pcall(function() if FlyObj then FlyObj:Destroy() end end)
    FlyConn = nil; FlyObj = nil
end

-- ==================== NOCLIP ====================
local NoclipConn = nil
local function StartNoclip()
    NoclipConn = RunService.Stepped:Connect(function()
        pcall(function()
            if not K.Noclip then return end
            local c = Ch()
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end)
end
local function StopNoclip()
    pcall(function() if NoclipConn then NoclipConn:Disconnect() end end)
    NoclipConn = nil
    pcall(function()
        local c = Ch()
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end)
end

-- ==================== FLY/NOCLIP MONITOR ====================
task.spawn(function()
    while S and S.Parent do
        if K.Fly and not FlyConn then StartFly() end
        if not K.Fly and FlyConn then StopFly() end
        if K.Noclip and not NoclipConn then StartNoclip() end
        if not K.Noclip and NoclipConn then StopNoclip() end
        task.wait(0.3)
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if K.Fly then StartFly() end
    if K.Noclip then StartNoclip() end
end)

-- ==================== AUTOFARM ====================
local StagePoints = {
    CFrame.new(-43.6, 62.1, 672.7),
    CFrame.new(-60.1, 97.4, 8767.9),
    CFrame.new(-54.3, -345.4, 9488.6),
}

local function CollectGold()
    pcall(function()
        local hrp = Hrp()
        if not hrp then return end
        for _, o in pairs(W:GetDescendants()) do
            if o:IsA("BasePart") and o:FindFirstChild("TouchInterest") then
                local n = o.Name:lower()
                if n:find("gold") or n:find("coin") or n:find("nugget") or n:find("treasure") then
                    if (o.Position - hrp.Position).Magnitude <= 50 then
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
                        if (par.Position - hrp.Position).Magnitude <= 50 then
                            pcall(function() fireclickdetector(o, 50) end)
                        end
                    end
                end
            end
        end
    end)
end

local function TweenTo(cf, spd)
    local hrp = Hrp()
    if not hrp then return end
    local d = (hrp.Position - cf.Position).Magnitude
    local tw = TweenService:Create(hrp, TweenInfo.new(d / (spd or 375), Enum.EasingStyle.Linear), {CFrame = cf})
    tw:Play()
    tw.Completed:Wait()
end

local function DoInstantFarm()
    pcall(function()
        local hrp = Hrp()
        if not hrp then return end
        -- Launch boat if possible
        local rem = W:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Remotes")
        if rem and rem:FindFirstChild("launchBoat") then rem.launchBoat:FireServer() end
        -- Teleport to chest
        local chest = W:FindFirstChild("BoatStages") and W.BoatStages:FindFirstChild("NormalStages") and W.BoatStages.NormalStages:FindFirstChild("TheEnd") and W.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest") and W.BoatStages.NormalStages.TheEnd.GoldenChest:FindFirstChild("Trigger")
        if chest then
            hrp.CFrame = chest.CFrame + Vector3.new(0, 5, 0)
            CollectGold()
            task.wait(1)
        else
            hrp.CFrame = CFrame.new(-54, -345, 9488)
            CollectGold()
            task.wait(1)
        end
        -- Die to restart
        local h = Hum()
        if h then h.Health = 0 end
        task.wait(7)
    end)
end

local function DoTweenFarm()
    pcall(function()
        W.Gravity = 0
        for _, cf in ipairs(StagePoints) do
            if not K.Farm then break end
            TweenTo(cf, K.FlySpd)
            CollectGold()
            task.wait(0.3)
        end
        local chest = W:FindFirstChild("BoatStages") and W.BoatStages:FindFirstChild("NormalStages") and W.BoatStages.NormalStages:FindFirstChild("TheEnd") and W.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest") and W.BoatStages.NormalStages.TheEnd.GoldenChest:FindFirstChild("Trigger")
        if chest and K.Farm then
            TweenTo(chest.CFrame + Vector3.new(0, 5, 0), K.FlySpd)
            CollectGold()
        end
        W.Gravity = 196.2
        if K.Farm then
            task.wait(1)
            local h = Hum()
            if h then h.Health = 0 end
            task.wait(7)
        end
    end)
end

local function DoStageFarm()
    pcall(function()
        local st = W:FindFirstChild("BoatStages") and W.BoatStages:FindFirstChild("NormalStages")
        if not st then return end
        for i = 1, 10 do
            if not K.Farm then break end
            local stage = st:FindFirstChild("CaveStage" .. i)
            if stage then
                local dp = stage:FindFirstChild("DarknessPart")
                if dp then
                    local hrp = Hrp()
                    if hrp then hrp.CFrame = dp.CFrame end
                    CollectGold()
                    pcall(function()
                        local ge = W:FindFirstChild("ClaimRiverResultsGold")
                        if ge then ge:FireServer() end
                    end)
                    task.wait(K.StgDel or 0.5)
                end
            end
        end
        local chest = st:FindFirstChild("TheEnd") and st.TheEnd:FindFirstChild("GoldenChest") and st.TheEnd.GoldenChest:FindFirstChild("Trigger")
        if chest and K.Farm then
            local hrp = Hrp()
            if hrp then hrp.CFrame = chest.CFrame + Vector3.new(0, 5, 0) end
            CollectGold()
            task.wait(1)
        end
        if K.Farm then
            local h = Hum()
            if h then h.Health = 0 end
            task.wait(7)
        end
    end)
end

task.spawn(function()
    while true do
        if K.Farm then
            if K.FarmMethod == "Instant" then DoInstantFarm()
            elseif K.FarmMethod == "Tween" then DoTweenFarm()
            elseif K.FarmMethod == "Stages" then DoStageFarm() end
        end
        task.wait(0.5)
    end
end)

-- ==================== BUILD ====================
local Tmpls = {
    GoldFarm = {{b = "WoodBlock", p = Vector3.new(0, 0, 0)}, {b = "WoodBlock", p = Vector3.new(0, 1, 0)}, {b = "Seat", p = Vector3.new(0, 2, 0)}, {b = "Thruster", p = Vector3.new(0, 0, -2)}, {b = "Balloon", p = Vector3.new(-1, 2, 0)}, {b = "Balloon", p = Vector3.new(1, 2, 0)}},
    Jet = {{b = "WoodBlock", p = Vector3.new(0, 0, 0)}, {b = "WoodBlock", p = Vector3.new(0, 1, 0)}, {b = "Seat", p = Vector3.new(0, 2, 0)}, {b = "Thruster", p = Vector3.new(-1, 0, -3)}, {b = "Thruster", p = Vector3.new(1, 0, -3)}},
    Boat = {{b = "WoodBlock", p = Vector3.new(0, 0, 0)}, {b = "Seat", p = Vector3.new(0, 1, 0)}, {b = "Thruster", p = Vector3.new(0, 0, -3)}},
    Tower = {{b = "WoodBlock", p = Vector3.new(0, 0, 0)}, {b = "WoodBlock", p = Vector3.new(0, 1, 0)}, {b = "WoodBlock", p = Vector3.new(0, 2, 0)}, {b = "Seat", p = Vector3.new(0, 3, 0)}, {b = "Thruster", p = Vector3.new(0, 0, -2)}},
}

local function PlBlock(bn, cf)
    pcall(function()
        local tool = Ch():FindFirstChildOfClass("Tool")
        if not tool then
            local bp = LP:FindFirstChild("Backpack")
            if bp then
                for _, t in pairs(bp:GetChildren()) do
                    if t:IsA("Tool") and (t.Name:lower():find("block") or t.Name:lower():find("wood") or t.Name:lower():find("thruster") or t.Name:lower():find("seat") or t.Name:lower():find("balloon")) then
                        t.Parent = Ch(); tool = t; break
                    end
                end
            end
        end
        if tool then
            local ev = tool:FindFirstChild("BuildEvent") or tool:FindFirstChild("PlaceBlock") or tool:FindFirstChild("Place")
            if ev then ev:FireServer(cf.Position, cf) end
        end
    end)
end

task.spawn(function()
    while true do
        if K.Build then
            pcall(function()
                local tm = Tmpls[K.Template]
                if tm then
                    local hrp = Hrp()
                    if not hrp then return end
                    local base = hrp.Position
                    for _, d in ipairs(tm) do
                        if not K.Build then break end
                        PlBlock(d.b, CFrame.new(base + d.p))
                        task.wait(K.Fast and 0.05 or 0.15)
                    end
                    if K.Weld then
                        task.wait(0.5)
                        for _, bt in pairs(W:GetChildren()) do
                            if bt.Name:find(LP.Name) or bt.Name:lower():find("boat") then
                                local pts = {}
                                for _, pt in pairs(bt:GetDescendants()) do if pt:IsA("BasePart") then table.insert(pts, pt) end end
                                for i = 2, #pts do local wl = Instance.new("WeldConstraint") wl.Part0 = pts[1] wl.Part1 = pts[i] wl.Parent = pts[i] end
                            end
                        end
                    end
                    K.Build = false
                    print("[KYDIABROSO] Build done!")
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- ==================== STEAL ====================
task.spawn(function()
    while true do
        if K.Steal then
            pcall(function()
                local hrp = Hrp()
                if not hrp then return end
                local mp = hrp.Position
                local trg = nil
                local md = 60
                for _, o in pairs(W:GetChildren()) do
                    if o.Name:lower():find("boat") or o:FindFirstChild("Seat") then
                        local pr = o:FindFirstChildWhichIsA("BasePart")
                        if pr then
                            local d = (pr.Position - mp).Magnitude
                            if d < md and not o.Name:find(LP.Name) then trg = o; md = d end
                        end
                    end
                end
                if trg then
                    local bp = trg:FindFirstChildWhichIsA("BasePart")
                    if bp then
                        local off = mp - bp.Position
                        for _, pt in pairs(trg:GetDescendants()) do
                            if pt:IsA("BasePart") then
                                PlBlock(pt.Name, CFrame.new(pt.Position + off) * (pt.CFrame - pt.CFrame.Position))
                                task.wait(K.Fast and 0.05 or 0.12)
                            end
                        end
                    end
                    print("[KYDIABROSO] Steal done!")
                else
                    print("[KYDIABROSO] No boat nearby!")
                end
                K.Steal = false
            end)
        end
        task.wait(1)
    end
end)

-- ==================== WORLD ====================
local function DelWater()
    pcall(function()
        for _, o in pairs(W:GetDescendants()) do
            if o.Name:lower():find("water") and o:IsA("BasePart") then o:Destroy() end
        end
        W.Terrain:Clear()
    end)
end
local function NoFogFn()
    pcall(function()
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        for _, v in pairs(Lighting:GetChildren()) do if v:IsA("Atmosphere") then v:Destroy() end end
    end)
end

task.spawn(function()
    while S and S.Parent do
        if K.DelW then DelWater() end
        if K.NoFog then NoFogFn() end
        task.wait(2)
    end
end)

-- ==================== DRAG ====================
local dg, ds, sp = false, nil, nil
Tl.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = true; ds = i.Position; sp = M.Position end end)
UserInputService.InputChanged:Connect(function(i) if dg and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - ds; M.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = false end end)

-- ==================== OPEN ANIM ====================
M.Size = UDim2.new(0, 0, 0, 0)
M.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(M, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 520, 0, 360), Position = UDim2.new(0.5, -260, 0.5, -180)}):Play()

print("[KYDIABROSO] v8.0 PRO Loaded | Timer + 3 Farm Methods + Fixed Speed/Jump")
