--[[
    KYDIABROSO HUB | Muscle Legends
    Версия: 10.0 (Auto Farm + Crystal Selector)
    Основано на: KING SUPREMACY, Tokattk, X2 Hub
]]

--// ПРОВЕРКА ИГРЫ
if game.PlaceId ~= 155615604 then
    return warn("KYDIABROSO: Скрипт только для Muscle Legends.")
end

--// СЕРВИСЫ И ПЕРЕМЕННЫЕ
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

repeat task.wait() until LP.Character
repeat task.wait() until LP.Character:FindFirstChild("HumanoidRootPart")

local rEvents = RS:FindFirstChild("rEvents")
local MuscleEvent = LP:FindFirstChild("MuscleEvent") or LP.Character:FindFirstChild("MuscleEvent")

--// СОСТОЯНИЕ
_G.Kydiabroso = {
    AutoFarm = false, AutoRebirth = false, AutoCrystals = false,
    CrystalName = "Blue Crystal", Hidden = false
}

--// УДАЛЯЕМ СТАРОЕ МЕНЮ
if LP.PlayerGui:FindFirstChild("KYDIABROSO_HUB") then
    LP.PlayerGui.KYDIABROSO_HUB:Destroy()
end

--// ГЛАВНОЕ ОКНО
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KYDIABROSO_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(80, 50, 200)
MainStroke.Thickness = 2

--// ЗАГОЛОВОК
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "KYDIABROSO | Muscle Legends"
TitleText.TextColor3 = Color3.fromRGB(180, 130, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 180)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

--// ВКЛАДКИ
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 130, 1, -50)
TabBar.Position = UDim2.new(0, 5, 0, 45)
TabBar.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -145, 1, -55)
ContentArea.Position = UDim2.new(0, 140, 0, 48)
ContentArea.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame
Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 8)

local Tabs = {}
local function CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 38)
    tabBtn.Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 42))
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
    tabBtn.Text = icon .. "  " .. name
    tabBtn.TextColor3 = Color3.fromRGB(160, 140, 200)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local tabPage = Instance.new("ScrollingFrame")
    tabPage.Size = UDim2.new(1, 0, 1, 0)
    tabPage.BackgroundTransparency = 1
    tabPage.Visible = false
    tabPage.ScrollBarThickness = 4
    tabPage.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 200)
    tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabPage.Parent = ContentArea
    local layout = Instance.new("UIListLayout", tabPage)
    layout.Padding = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", tabPage)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)

    table.insert(Tabs, {Button = tabBtn, Page = tabPage, Name = name})

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 20, 45), TextColor3 = Color3.fromRGB(160, 140, 200)}):Play()
        end
        tabPage.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 30, 80), TextColor3 = Color3.fromRGB(200, 170, 255)}):Play()
    end)

    return tabPage
end

--// КОМПОНЕНТЫ
local function CreateToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(20, 18, 35)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 190, 230)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -56, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 70)
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 11)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(120, 120, 150)
    circle.Parent = toggleBtn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 50, 180)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 25, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 140, 255)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 40, 70)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(120, 120, 150)}):Play()
        end
        if callback then callback(state) end
    end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(35, 28, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 180, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 40, 100)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 28, 60)}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
end

--// ВКЛАДКА FARM
local FarmTab = CreateTab("Farm", "💪")

CreateToggle(FarmTab, "AutoFarm (Strength)", function(v)
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
                task.wait(0.01)
            end
        end)
    end
end)

CreateToggle(FarmTab, "AutoRebirth", function(v)
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

--// ВКЛАДКА CRYSTALS (ВЫБОР КРИСТАЛЛА)
local CrystalTab = CreateTab("Crystals", "💎")

local selectedCrystal = "Blue Crystal"
local crystalsList = {
    "Blue Crystal", "Green Crystal", "Frost Crystal", "Inferno Crystal",
    "Mythical Crystal", "Legends Crystal", "Muscle Elite Crystal"
}

local crystalDropdown = Instance.new("TextButton")
crystalDropdown.Size = UDim2.new(1, 0, 0, 34)
crystalDropdown.BackgroundColor3 = Color3.fromRGB(35, 28, 60)
crystalDropdown.Text = "💎 Выбрать: Blue Crystal ▾"
crystalDropdown.TextColor3 = Color3.fromRGB(200, 180, 255)
crystalDropdown.TextSize = 13
crystalDropdown.Font = Enum.Font.GothamMedium
crystalDropdown.Parent = CrystalTab
Instance.new("UICorner", crystalDropdown).CornerRadius = UDim.new(0, 6)

local crystalIndex = 1
crystalDropdown.MouseButton1Click:Connect(function()
    crystalIndex = crystalIndex % #crystalsList + 1
    selectedCrystal = crystalsList[crystalIndex]
    _G.Kydiabroso.CrystalName = selectedCrystal
    crystalDropdown.Text = "💎 Выбрать: " .. selectedCrystal .. " ▾"
end)

CreateToggle(CrystalTab, "Auto Open Selected Crystal", function(v)
    _G.Kydiabroso.AutoCrystals = v
    if v then
        task.spawn(function()
            while _G.Kydiabroso.AutoCrystals do
                pcall(function()
                    if rEvents and rEvents:FindFirstChild("openCrystalRemote") then
                        rEvents.openCrystalRemote:InvokeServer("openCrystalRequest", _G.Kydiabroso.CrystalName)
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

--// ВКЛАДКА SETTINGS
local SettingsTab = CreateTab("Settings", "⚙️")

CreateButton(SettingsTab, "Сохранить конфиг", function()
    if writefile then
        local data = {}
        for k, v in pairs(_G.Kydiabroso) do data[k] = v end
        writefile("KydiabrosoConfig.json", game:GetService("HttpService"):JSONEncode(data))
        print("[KYDIABROSO] Конфиг сохранён")
    end
end)

CreateButton(SettingsTab, "Загрузить конфиг", function()
    if readfile and isfile and isfile("KydiabrosoConfig.json") then
        local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("KydiabrosoConfig.json")) end)
        if ok and data then
            for k, v in pairs(data) do _G.Kydiabroso[k] = v end
            print("[KYDIABROSO] Конфиг загружен")
        end
    end
end)

CreateButton(SettingsTab, "Скрыть интерфейс", function()
    MainFrame.Visible = not MainFrame.Visible
end)

CreateButton(SettingsTab, "Выход", function()
    ScreenGui:Destroy()
end)

--// АКТИВАЦИЯ ПЕРВОЙ ВКЛАДКИ
FarmTab.Visible = true
if Tabs[1] then
    Tabs[1].Button.BackgroundColor3 = Color3.fromRGB(45, 30, 80)
    Tabs[1].Button.TextColor3 = Color3.fromRGB(200, 170, 255)
end

--// МИНИ-ИКОНКА
local MiniFrame = Instance.new("Frame")
MiniFrame.Size = UDim2.new(0, 120, 0, 36)
MiniFrame.Position = UDim2.new(0, 10, 0, 10)
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true
MiniFrame.Parent = ScreenGui
Instance.new("UICorner", MiniFrame).CornerRadius = UDim.new(0, 8)

local MiniText = Instance.new("TextLabel")
MiniText.Size = UDim2.new(1, -10, 1, 0)
MiniText.BackgroundTransparency = 1
MiniText.Text = "KYDIABROSO"
MiniText.TextColor3 = Color3.fromRGB(180, 140, 255)
MiniText.TextSize = 12
MiniText.Font = Enum.Font.GothamBold
MiniText.Parent = MiniFrame

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniFrame.Visible = true
end)

MiniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MainFrame.Visible = true
        MiniFrame.Visible = false
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("═══════════════════════════════════════════════════")
print("  ✅ KYDIABROSO HUB v10.0 загружен!")
print("  💪 AutoFarm + AutoRebirth")
print("  💎 Выбор кристалла: " .. _G.Kydiabroso.CrystalName)
print("═══════════════════════════════════════════════════")
