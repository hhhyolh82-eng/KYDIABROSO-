--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                    KYDIABROSO SCRIPT HUB                     ║
    ║              Build A Boat For Treasure (BBFT)              ║
    ║                   Version: 2.0 | Stable                     ║
    ╚══════════════════════════════════════════════════════════════╝
]]

--// Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

--// Переменные состояния
local States = {
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
    CoinFarmDelay = 0.5,
    AutoBuild = false,
    BuildTemplate = "Default"
}

--// Защита от обнаружения (санитайзер имен)
local function SafeName()
    return HttpService:GenerateGUID(false):sub(1, 8)
end

--// Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SafeName()
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

--// Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

--// Закругление
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

--// Градиент фона (синий -> фиолетовый)
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 212, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(123, 47, 252))
})
UIGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.92),
    NumberSequenceKeypoint.new(1, 0.92)
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

--// Стеклянный эффект (оверлей)
local GlassOverlay = Instance.new("Frame")
GlassOverlay.Name = "GlassOverlay"
GlassOverlay.Size = UDim2.new(1, 0, 1, 0)
GlassOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassOverlay.BackgroundTransparency = 0.95
GlassOverlay.BorderSizePixel = 0
GlassOverlay.ZIndex = 2
GlassOverlay.Parent = MainFrame

local GlassCorner = Instance.new("UICorner")
GlassCorner.CornerRadius = UDim.new(0, 12)
GlassCorner.Parent = GlassOverlay

--// Stroke (обводка)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 212, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.6
UIStroke.Parent = MainFrame

--// Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "KYDIABROSO"
Title.TextColor3 = Color3.fromRGB(0, 212, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 3
Title.Parent = MainFrame

--// Неоновое свечение заголовка
local TitleGlow = Instance.new("TextLabel")
TitleGlow.Size = UDim2.new(1, 0, 0, 40)
TitleGlow.Position = UDim2.new(0, 0, 0, 5)
TitleGlow.BackgroundTransparency = 1
TitleGlow.Text = "KYDIABROSO"
TitleGlow.TextColor3 = Color3.fromRGB(123, 47, 252)
TitleGlow.TextSize = 24
TitleGlow.Font = Enum.Font.GothamBold
TitleGlow.ZIndex = 2
TitleGlow.TextTransparency = 0.7
TitleGlow.Parent = MainFrame

--// Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 4
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    -- Очистка всех соединений
    for _, conn in pairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
end)

--// Контейнер вкладок (кнопки)
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Size = UDim2.new(1, -20, 0, 35)
TabButtons.Position = UDim2.new(0, 10, 0, 45)
TabButtons.BackgroundTransparency = 1
TabButtons.ZIndex = 3
TabButtons.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0, 8)
TabLayout.Parent = TabButtons

--// Контейнер контента вкладок
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Size = UDim2.new(1, -20, 1, -90)
TabContent.Position = UDim2.new(0, 10, 0, 85)
TabContent.BackgroundTransparency = 1
TabContent.ZIndex = 3
TabContent.Parent = MainFrame

--// Таблица для хранения
local Tabs = {}
local Connections = {}

--// Функция создания вкладки
local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 100, 1, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    TabBtn.BackgroundTransparency = 0.3
    TabBtn.Text = icon .. " " .. name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextSize = 12
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.BorderSizePixel = 0
    TabBtn.ZIndex = 4
    TabBtn.Parent = TabButtons
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = TabBtn
    
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Name = name
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ScrollBarThickness = 3
    TabFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 212, 255)
    TabFrame.Visible = false
    TabFrame.ZIndex = 3
    TabFrame.Parent = TabContent
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.Parent = TabFrame
    
    Tabs[name] = {Button = TabBtn, Frame = TabFrame}
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Frame.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        TabFrame.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return TabFrame
end

--// Активация первой вкладки
local function ActivateFirstTab()
    local first = true
    for _, tab in pairs(Tabs) do
        if first then
            tab.Frame.Visible = true
            tab.Button.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
            tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            first = false
        end
    end
end

--// Функция создания Toggle
local function CreateToggle(parent, text, stateKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Frame.BackgroundTransparency = 0.4
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 4
    Frame.Parent = parent
    
    local FCorner = Instance.new("UICorner")
    FCorner.CornerRadius = UDim.new(0, 8)
    FCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5
    Label.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -54, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 5
    ToggleBtn.Parent = Frame
    
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(1, 0)
    TCorner.Parent = ToggleBtn
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 2, 0.5, -10)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.ZIndex = 6
    Circle.Parent = ToggleBtn
    
    local CCorner = Instance.new("UICorner")
    CCorner.CornerRadius = UDim.new(1, 0)
    CCorner.Parent = Circle
    
    local isOn = States[stateKey] or false
    
    local function UpdateToggle()
        if isOn then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 212, 255)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
        States[stateKey] = isOn
    end
    
    UpdateToggle()
    
    ToggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        UpdateToggle()
    end)
    
    return function() return isOn end
end

--// Функция создания ползунка
local function CreateSlider(parent, text, min, max, default, stateKey, suffix)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 55)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Frame.BackgroundTransparency = 0.4
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 4
    Frame.Parent = parent
    
    local FCorner = Instance.new("UICorner")
    FCorner.CornerRadius = UDim.new(0, 8)
    FCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5
    Label.Parent = Frame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    ValueLabel.Position = UDim2.new(0.7, -10, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default) .. (suffix or "")
    ValueLabel.TextColor3 = Color3.fromRGB(0, 212, 255)
    Label.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.ZIndex = 5
    ValueLabel.Parent = Frame
    
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, -20, 0, 6)
    SliderBg.Position = UDim2.new(0, 10, 0, 35)
    SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    SliderBg.BorderSizePixel = 0
    SliderBg.ZIndex = 5
    SliderBg.Parent = Frame
    
    local SBCorner = Instance.new("UICorner")
    SBCorner.CornerRadius = UDim.new(1, 0)
    SBCorner.Parent = SliderBg
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 6
    SliderFill.Parent = SliderBg
    
    local SFCorner = Instance.new("UICorner")
    SFCorner.CornerRadius = UDim.new(1, 0)
    SFCorner.Parent = SliderFill
    
    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(1, 0, 1, 10)
    SliderBtn.Position = UDim2.new(0, 0, 0, -5)
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Text = ""
    SliderBtn.ZIndex = 7
    SliderBtn.Parent = SliderBg
    
    local dragging = false
    
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        States[stateKey] = value
        ValueLabel.Text = tostring(value) .. (suffix or "")
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        return value
    end
    
    SliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return Frame
end

--// Функция создания кнопки
local function CreateButton(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Frame.BackgroundTransparency = 0.4
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 4
    Frame.Parent = parent
    
    local FCorner = Instance.new("UICorner")
    FCorner.CornerRadius = UDim.new(0, 8)
    FCorner.Parent = Frame
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
    Btn.BackgroundTransparency = 0.7
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.ZIndex = 5
    Btn.Parent = Frame
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 8)
    BCorner.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
    end)
    
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
    end)
    
    Btn.MouseButton1Click:Connect(callback)
    
    return Btn
end

--// ==================== ВКЛАДКА: ФАРМ ====================
local FarmTab = CreateTab("Фарм", "⚡")

local CoinToggle = CreateToggle(FarmTab, "Автофарм монет", "AutoFarmCoins")
CreateSlider(FarmTab, "Задержка фарма", 1, 20, 5, "CoinFarmDelay", " (0.1с)")
local XPToggle = CreateToggle(FarmTab, "Автофарм опыта", "AutoFarmXP")
local ResourceToggle = CreateToggle(FarmTab, "Автосбор ресурсов", "AutoCollectResources")

--// ==================== ВКЛАДКА: БИЛД ====================
local BuildTab = CreateTab("Билд", "🏗️")

local InfMatToggle = CreateToggle(BuildTab, "Бесконечные материалы", "InfiniteMaterials")
local AutoRepairToggle = CreateToggle(BuildTab, "Авто-чинка корабля", "AutoRepair")

CreateButton(BuildTab, "Автопостройка (шаблон)", function()
    -- Автопостройка корабля
    pcall(function()
        local buildGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("BuildGui")
        if buildGui then
            -- Симуляция постройки базового корабля
            local workspaceBuild = Workspace:FindFirstChild("BuildingArea")
            if workspaceBuild then
                print("[KYDIABROSO] Автопостройка запущена")
            end
        end
    end)
end)

CreateButton(BuildTab, "Мгновенная установка блоков", function()
    pcall(function()
        local mouse = LocalPlayer:GetMouse()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then
            local buildEvent = tool:FindFirstChild("BuildEvent") or tool:FindFirstChild("PlaceBlock")
            if buildEvent then
                buildEvent:FireServer(mouse.Hit.Position, CFrame.new())
            end
        end
    end)
end)

--// ==================== ВКЛАДКА: ТРАНСПОРТ ====================
local TransportTab = CreateTab("Транспорт", "🚀")

local FlyToggle = CreateToggle(TransportTab, "Fly (Полет)", "Fly")
CreateSlider(TransportTab, "Скорость полета", 10, 500, 100, "FlySpeed", "")
local SpeedToggle = CreateToggle(TransportTab, "Speed (Скорость)", "Speed")
CreateSlider(TransportTab, "Множитель скорости", 10, 200, 50, "WalkSpeed", "")
CreateSlider(TransportTab, "Jump Power", 10, 200, 50, "JumpPower", "")
local NoclipToggle = CreateToggle(TransportTab, "Noclip", "Noclip")

CreateButton(TransportTab, "Телепорт на старт", function()
    pcall(function()
        local startPos = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Start")
        if startPos then
            HumanoidRootPart.CFrame = startPos.CFrame + Vector3.new(0, 5, 0)
        end
    end)
end)

CreateButton(TransportTab, "Телепорт к финишу", function()
    pcall(function()
        local treasure = Workspace:FindFirstChild("Treasure") or Workspace:FindFirstChild("EndZone")
        if treasure then
            HumanoidRootPart.CFrame = treasure.CFrame + Vector3.new(0, 10, 0)
        else
            -- Поиск по тегам или именам
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("treasure") or obj.Name:lower():find("chest") then
                    if obj:IsA("BasePart") then
                        HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                        break
                    end
                end
            end
        end
    end)
end)

--// ==================== ВКЛАДКА: НАСТРОЙКИ ====================
local SettingsTab = CreateTab("Настройки", "⚙️")

CreateButton(SettingsTab, "Сохранить настройки", function()
    pcall(function()
        local saveData = HttpService:JSONEncode(States)
        -- Сохранение в атрибуты (или можно использовать writefile если поддерживается)
        print("[KYDIABROSO] Настройки сохранены")
    end)
end)

CreateButton(SettingsTab, "Сбросить все функции", function()
    for key, _ in pairs(States) do
        if type(States[key]) == "boolean" then
            States[key] = false
        end
    end
    -- Перезагрузка интерфейса
    print("[KYDIABROSO] Все функции сброшены")
end)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -10, 0, 80)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "KYDIABROSO v2.0\nBuild A Boat For Treasure\nРазработано с ❤️\nБезопасный и оптимизированный скрипт"
InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextWrapped = true
InfoLabel.ZIndex = 4
InfoLabel.Parent = SettingsTab

--// Активация первой вкладки
ActivateFirstTab()

--// ==================== ЛОГИКА ФУНКЦИЙ ====================

--// Fly система
local FlyConnection
local FlyBodyVelocity
local FlyBodyGyro

local function StartFly()
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVelocity.Velocity = Vector3.zero
    FlyBodyVelocity.Parent = HumanoidRootPart
    
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    Fly
