--[[
    KYDIABROSO HUB | Muscle Legends
    PlaceId: 155615604
    Сделано с использованием опыта KING SUPREMACY V7.3/V8.2 и мануалов по RemoteEvents.
    
    RemoteEvents:
    - MuscleEvent (FireServer "punch", "leftHand"/"rightHand")
    - RS.rEvents.rebirthRemote (InvokeServer "rebirthRequest")
    - RS.rEvents.openCrystalRemote (InvokeServer "openCrystalRequest", "Blue Crystal")
]]

--// ЗАЩИТА ОТ ЗАПУСКА НЕ В ТОЙ ИГРЕ
if game.PlaceId ~= 155615604 then
    return warn("KYDIABROSO: Это скрипт для Muscle Legends (155615604).")
end

--// СЕРВИСЫ И ПЕРЕМЕННЫЕ
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

--// ОЖИДАНИЕ ИГРУШЕК
repeat task.wait() until LP.Character
repeat task.wait() until LP:FindFirstChild("MuscleEvent") or LP.Character:FindFirstChild("MuscleEvent")

local MuscleEvent = LP:FindFirstChild("MuscleEvent") or LP.Character:FindFirstChild("MuscleEvent")
local rEvents = RS:FindFirstChild("rEvents")

--// ГЛОБАЛЬНЫЕ ФЛАГИ
_G.Kydiabroso = {
    AutoFarm = false,
    AutoRebirth = false,
    KillAura = false,
    AutoPunch = false,
    AutoCrystals = false,
    AutoGift = false,
    AutoProtein = false,
    AutoWeight = false,
    Hidden = false
}

--// ГЛАВНЫЙ GUILD
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KYDIABROSO_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

--// ГЛАВНЫЙ ФРЕЙМ
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 50, 200)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 15, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

--// ЗАГОЛОВОК
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "KYDIABROSO"
TitleText.TextColor3 = Color3.fromRGB(180, 130, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local TitleGlow = Instance.new("UIStroke")
TitleGlow.Color = Color3.fromRGB(150, 80, 255)
TitleGlow.Thickness = 1
TitleGlow.Transparency = 0.5
TitleGlow.Parent = TitleText

--// КНОПКА СВЁРТЫВАНИЯ
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

--// КНОПКА ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 180)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

--// ПАНЕЛЬ ВКЛАДОК
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 130, 1, -50)
TabBar.Position = UDim2.new(0, 5, 0, 45)
TabBar.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabBar

--// КОНТЕНТ ОБЛАСТЬ
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -145, 1, -55)
ContentArea.Position = UDim2.new(0, 140, 0, 48)
ContentArea.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentArea

--// СОЗДАНИЕ ВКЛАДОК
local Tabs = {}
local ActiveTab = nil

local function CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(1, -10, 0, 38)
    tabBtn.Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 42))
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
    tabBtn.Text = icon .. "  " .. name
    tabBtn.TextColor3 = Color3.fromRGB(160, 140, 200)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = TabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local tabPage = Instance.new("ScrollingFrame")
    tabPage.Name = name .. "Page"
    tabPage.Size = UDim2.new(1, 0, 1, 0)
    tabPage.BackgroundTransparency = 1
    tabPage.Visible = false
    tabPage.ScrollBarThickness = 4
    tabPage.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 200)
    tabPage.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = tabPage

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop = UDim.new(0, 8)
    pagePad.PaddingLeft = UDim.new(0, 8)
    pagePad.PaddingRight = UDim.new(0, 8)
    pagePad.Parent = tabPage

    local tabData = {Button = tabBtn, Page = tabPage, Name = name}
    table.insert(Tabs, tabData)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 20, 45)}):Play()
            TweenService:Create(t.Button, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(160, 140, 200)}):Play()
        end
        tabPage.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 30, 80)}):Play()
        TweenService:Create(tabBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(200, 170, 255)}):Play()
        ActiveTab = name
    end)

    return tabPage
end

--// КОМПОНЕНТЫ
local function CreateToggle(parent, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 36)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 190, 230)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -56, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 70)
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = toggleBtn

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(120, 120, 150)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBtn

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local state = default

    local function updateVisual()
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 50, 180)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 25, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 140, 255)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 40, 70)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(120, 120, 150)}):Play()
        end
    end

    updateVisual()

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        if callback then callback(state) end
    end)

    return toggleFrame
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(35, 28, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 180, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 40, 100)}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 28, 60)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return btn
end

--// ВКЛАДКА: FARM
local FarmTab = CreateTab("Farm", "💪")

CreateToggle(FarmTab, "AutoFarm (Strength)", false, function(v)
    _G.Kydiabroso.AutoFarm = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.AutoFarm do
                pcall(function()
                    if MuscleEvent then
                        MuscleEvent:FireServer("punch", "leftHand")
                        MuscleEvent:FireServer("punch", "rightHand")
                    end
                end)
                task.wait(0.001)
            end
        end)
    end
end)

CreateToggle(FarmTab, "AutoRebirth", false, function(v)
    _G.Kydiabroso.AutoRebirth = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.AutoRebirth do
                pcall(function()
                    if rEvents and rEvents:FindFirstChild("rebirthRemote") then
                        rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                    end
                end)
                task.wait(5)
            end
        end)
    end
end)

CreateToggle(FarmTab, "AutoProtein", false, function(v)
    _G.Kydiabroso.AutoProtein = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.AutoProtein do
                pcall(function()
                    for _, tool in pairs(LP.Backpack:GetChildren()) do
                        if tool.Name:lower():find("protein") then
                            tool.Parent = LP.Character
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

CreateToggle(FarmTab, "AutoWeight", false, function(v)
    _G.Kydiabroso.AutoWeight = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.AutoWeight do
                pcall(function()
                    local bench = workspace:FindFirstChild("Machines")
                    if bench then
                        local weight = bench:FindFirstChild("Weight")
                        if weight then
                            firetouchinterest(LP.Character.HumanoidRootPart, weight, 0)
                            task.wait()
                            firetouchinterest(LP.Character.HumanoidRootPart, weight, 1)
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

--// ВКЛАДКА: COMBAT
local CombatTab = CreateTab("Combat", "⚔️")

CreateToggle(CombatTab, "KillAura", false, function(v)
    _G.Kydiabroso.KillAura = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.KillAura do
                pcall(function()
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LP and plr.Character then
                            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                            local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and myHrp then
                                local dist = (myHrp.Position - hrp.Position).Magnitude
                                if dist < 30 then
                                    MuscleEvent:FireServer("punch", "rightHand")
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

CreateToggle(CombatTab, "AutoPunch", false, function(v)
    _G.Kydiabroso.AutoPunch = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.AutoPunch do
                pcall(function()
                    MuscleEvent:FireServer("punch", "leftHand")
                    MuscleEvent:FireServer("punch", "rightHand")
                end)
                task.wait(0.05)
            end
        end)
    end
end)

--// ВКЛАДКА: GIFT
local GiftTab = CreateTab("Gift", "🎁")

CreateToggle(GiftTab, "AutoClaimGifts", false, function(v)
    _G.Kydiabroso.AutoGift = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.AutoGift do
                pcall(function()
                    if rEvents then
                        for _, remote in pairs(rEvents:GetChildren()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("gift") then
                                remote:FireServer()
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

CreateToggle(GiftTab, "AutoBuyCrystals (Blue)", false, function(v)
    _G.Kydiabroso.AutoCrystals = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.AutoCrystals do
                pcall(function()
                    if rEvents and rEvents:FindFirstChild("openCrystalRemote") then
                        rEvents.openCrystalRemote:InvokeServer("openCrystalRequest", "Blue Crystal")
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

--// ВКЛАДКА: SETTINGS
local SettingsTab = CreateTab("Settings", "⚙️")

CreateButton(SettingsTab, "Сохранить конфиг", function()
    local data = {
        AutoFarm = _G.Kydiabroso.AutoFarm,
        AutoRebirth = _G.Kydiabroso.AutoRebirth,
        KillAura = _G.Kydiabroso.KillAura,
        AutoPunch = _G.Kydiabroso.AutoPunch,
        AutoCrystals = _G.Kydiabroso.AutoCrystals,
        AutoGift = _G.Kydiabroso.AutoGift,
        AutoProtein = _G.Kydiabroso.AutoProtein,
        AutoWeight = _G.Kydiabroso.AutoWeight
    }
    if writefile then
        writefile("KydiabrosoConfig.json", game:GetService("HttpService"):JSONEncode(data))
        print("[KYDIABROSO] Конфиг сохранён")
    end
end)

CreateButton(SettingsTab, "Загрузить конфиг", function()
    if readfile and isfile and isfile("KydiabrosoConfig.json") then
        local ok, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("KydiabrosoConfig.json"))
        end)
        if ok and data then
            _G.Kydiabroso.AutoFarm = data.AutoFarm or false
            _G.Kydiabroso.AutoRebirth = data.AutoRebirth or false
            _G.Kydiabroso.KillAura = data.KillAura or false
            _G.Kydiabroso.AutoPunch = data.AutoPunch or false
            _G.Kydiabroso.AutoCrystals = data.AutoCrystals or false
            _G.Kydiabroso.AutoGift = data.AutoGift or false
            _G.Kydiabroso.AutoProtein = data.AutoProtein or false
            _G.Kydiabroso.AutoWeight = data.AutoWeight or false
            print("[KYDIABROSO] Конфиг загружен")
        end
    end
end)

CreateButton(SettingsTab, "Скрыть интерфейс (RightShift)", function()
    _G.Kydiabroso.Hidden = not _G.Kydiabroso.Hidden
    MainFrame.Visible = not _G.Kydiabroso.Hidden
end)

CreateButton(SettingsTab, "Выход", function()
    ScreenGui:Destroy()
end)

--// МИНИ-ИКОНКА (СВЁРНУТОЕ СОСТОЯНИЕ)
local MiniFrame = Instance.new("Frame")
MiniFrame.Name = "MiniFrame"
MiniFrame.Size = UDim2.new(0, 120, 0, 36)
MiniFrame.Position = UDim2.new(0, 10, 0, 10)
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
MiniFrame.BorderSizePixel = 0
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true
MiniFrame.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 8)
MiniCorner.Parent = MiniFrame

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(100, 60, 220)
MiniStroke.Thickness = 1
MiniStroke.Parent = MiniFrame

local MiniText = Instance.new("TextLabel")
MiniText.Size = UDim2.new(1, -10, 1, 0)
MiniText.Position = UDim2.new(0, 5, 0, 0)
MiniText.BackgroundTransparency = 1
MiniText.Text = "KYDIABROSO"
MiniText.TextColor3 = Color3.fromRGB(180, 140, 255)
MiniText.TextSize = 12
MiniText.Font = Enum.Font.GothamBold
MiniText.Parent = MiniFrame

local MiniOpenBtn = Instance.new("TextButton")
MiniOpenBtn.Size = UDim2.new(0, 30, 0, 30)
MiniOpenBtn.Position = UDim2.new(1, -35, 0.5, -15)
MiniOpenBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 100)
MiniOpenBtn.Text = "▲"
MiniOpenBtn.TextColor3 = Color3.fromRGB(180, 150, 255)
MiniOpenBtn.TextSize = 12
MiniOpenBtn.Font = Enum.Font.GothamBold
MiniOpenBtn.BorderSizePixel = 0
MiniOpenBtn.Parent = MiniFrame

local MiniBtnCorner = Instance.new("UICorner")
MiniBtnCorner.CornerRadius = UDim.new(0, 5)
MiniBtnCorner.Parent = MiniOpenBtn

--// ЛОГИКА СВЁРТЫВАНИЯ
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniFrame.Visible = true
end)

MiniOpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniFrame.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--// ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК КЛАВИШАМИ (RightShift для скрытия)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightS
