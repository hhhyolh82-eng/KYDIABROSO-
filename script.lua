--[[ KYDIABROSO v6.0 ShieldTeam Edition | Build A Boat For Treasure ]]

local P=game:GetService("Players")
local R=game:GetService("RunService")
local T=game:GetService("TweenService")
local U=game:GetService("UserInputService")
local C=game:GetService("CoreGui")
local W=game:GetService("Workspace")
local H=game:GetService("HttpService")
local L=game:GetService("Lighting")
local V=game:GetService("VirtualInputManager")

local LP=P.LocalPlayer
local Cam=W.CurrentCamera

local K={
	Farm=false,God=false,AFK=false,Claim=false,
	Inf=false,Fast=false,Weld=false,Build=false,Steal=false,
	Fly=false,Spd=false,Noclip=false,DelW=false,NoFog=false,
	FlySpd=120,WalkSpd=80,JumpPw=50,Template="GoldFarm",
}

local function G()return H:GenerateGUID(false):sub(1,6)end
local function Ch()return LP.Character or LP.CharacterAdded:Wait()end
local function Hrp()return Ch():WaitForChild("HumanoidRootPart")end
local function Hum()return Ch():WaitForChild("Humanoid")end

-- GUI
local S=Instance.new("ScreenGui")
S.Name="KYDIABROSO_"..G()
S.ResetOnSpawn=false
S.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
S.Parent=C

local M=Instance.new("Frame")
M.Size=UDim2.new(0,500,0,350)
M.Position=UDim2.new(0.5,-250,0.5,-175)
M.BackgroundColor3=Color3.fromRGB(16,16,26)
M.BorderSizePixel=0
M.Active=true
M.Parent=S
Instance.new("UICorner",M).CornerRadius=UDim.new(0,10)

local Stroke=Instance.new("UIStroke")
Stroke.Color=Color3.fromRGB(139,92,246)
Stroke.Thickness=1
Stroke.Transparency=0.5
Stroke.Parent=M

-- Title
local Tb=Instance.new("Frame")
Tb.Size=UDim2.new(1,0,0,32)
Tb.BackgroundColor3=Color3.fromRGB(22,22,34)
Tb.BorderSizePixel=0
Tb.ZIndex=5
Tb.Parent=M
Instance.new("UICorner",Tb).CornerRadius=UDim.new(0,10)

local Tf=Instance.new("Frame")
Tf.Size=UDim2.new(0,20,0,32)
Tf.Position=UDim2.new(1,-20,0,0)
Tf.BackgroundColor3=Color3.fromRGB(22,22,34)
Tf.BorderSizePixel=0
Tf.ZIndex=5
Tf.Parent=Tb

local Tl=Instance.new("TextLabel")
Tl.Size=UDim2.new(1,-40,1,0)
Tl.Position=UDim2.new(0,12,0,0)
Tl.BackgroundTransparency=1
Tl.Text="KYDIABROSO"
Tl.TextColor3=Color3.fromRGB(139,92,246)
Tl.TextSize=17
Tl.Font=Enum.Font.GothamBold
Tl.TextXAlignment=Enum.TextXAlignment.Left
Tl.ZIndex=6
Tl.Parent=Tb

local X=Instance.new("TextButton")
X.Size=UDim2.new(0,26,0,26)
X.Position=UDim2.new(1,-30,0,3)
X.BackgroundTransparency=1
X.Text="×"
X.TextColor3=Color3.fromRGB(180,180,180)
X.TextSize=20
X.Font=Enum.Font.GothamBold
X.ZIndex=6
X.Parent=Tb
X.MouseEnter:Connect(function()X.TextColor3=Color3.fromRGB(255,80,80)end)
X.MouseLeave:Connect(function()X.TextColor3=Color3.fromRGB(180,180,180)end)
X.MouseButton1Click:Connect(function()S:Destroy()end)

-- Sidebar
local Bar=Instance.new("Frame")
Bar.Size=UDim2.new(0,100,1,-32)
Bar.Position=UDim2.new(0,0,0,32)
Bar.BackgroundColor3=Color3.fromRGB(14,14,22)
Bar.BorderSizePixel=0
Bar.ZIndex=4
Bar.Parent=M
Instance.new("UICorner",Bar).CornerRadius=UDim.new(0,10)

local Bf=Instance.new("Frame")
Bf.Size=UDim2.new(0,20,1,0)
Bf.Position=UDim2.new(1,-20,0,0)
Bf.BackgroundColor3=Color3.fromRGB(14,14,22)
Bf.BorderSizePixel=0
Bf.ZIndex=4
Bf.Parent=Bar

local Cont=Instance.new("Frame")
Cont.Size=UDim2.new(1,-108,1,-40)
Cont.Position=UDim2.new(0,104,0,36)
Cont.BackgroundTransparency=1
Cont.ZIndex=5
Cont.Parent=M

local Tabs={}

local function Tab(n,ico)
	local B=Instance.new("TextButton")
	B.Size=UDim2.new(1,-10,0,30)
	B.BackgroundTransparency=1
	B.Text="  "..ico.."  "..n
	B.TextColor3=Color3.fromRGB(130,130,150)
	B.TextSize=11
	B.Font=Enum.Font.GothamSemibold
	B.TextXAlignment=Enum.TextXAlignment.Left
	B.ZIndex=5
	B.Parent=Bar

	local F=Instance.new("ScrollingFrame")
	F.Name=n
	F.Size=UDim2.new(1,-4,1,-4)
	F.Position=UDim2.new(0,2,0,2)
	F.BackgroundTransparency=1
	F.BorderSizePixel=0
	F.ScrollBarThickness=2
	F.ScrollBarImageColor3=Color3.fromRGB(139,92,246)
	F.Visible=false
	F.ZIndex=5
	F.Parent=Cont

	local Ly=Instance.new("UIListLayout")
	Ly.Padding=UDim.new(0,8)
	Ly.Parent=F

	Tabs[n]={Button=B,Frame=F}
	B.MouseButton1Click:Connect(function()
		for _,t in pairs(Tabs)do
			t.Frame.Visible=false
			t.Button.TextColor3=Color3.fromRGB(130,130,150)
			t.Button.BackgroundTransparency=1
		end
		F.Visible=true
		B.TextColor3=Color3.fromRGB(139,92,246)
		B.BackgroundColor3=Color3.fromRGB(139,92,246)
		B.BackgroundTransparency=0.85
	end)
	return F
end

-- Section
local function Sec(p,t)
	local Fr=Instance.new("Frame")
	Fr.Size=UDim2.new(1,-4,0,0)
	Fr.AutomaticSize=Enum.AutomaticSize.Y
	Fr.BackgroundColor3=Color3.fromRGB(24,24,38)
	Fr.BackgroundTransparency=0.3
	Fr.BorderSizePixel=0
	Fr.ZIndex=5
	Fr.Parent=p
	Instance.new("UICorner",Fr).CornerRadius=UDim.new(0,8)

	local H=Instance.new("TextLabel")
	H.Size=UDim2.new(1,-12,0,22)
	H.Position=UDim2.new(0,8,0,4)
	H.BackgroundTransparency=1
	H.Text=t
	H.TextColor3=Color3.fromRGB(139,92,246)
	H.TextSize=12
	H.Font=Enum.Font.GothamBold
	H.TextXAlignment=Enum.TextXAlignment.Left
	H.ZIndex=6
	H.Parent=Fr

	local Cn=Instance.new("Frame")
	Cn.Size=UDim2.new(1,-12,0,0)
	Cn.Position=UDim2.new(0,6,0,24)
	Cn.AutomaticSize=Enum.AutomaticSize.Y
	Cn.BackgroundTransparency=1
	Cn.ZIndex=6
	Cn.Parent=Fr

	local L=Instance.new("UIListLayout")
	L.Padding=UDim.new(0,6)
	L.Parent=Cn

	return Cn
end

-- Toggle (ShieldTeam style)
local function Tog(p,t,k)
	local Fr=Instance.new("Frame")
	Fr.Size=UDim2.new(1,0,0,28)
	Fr.BackgroundTransparency=1
	Fr.ZIndex=6
	Fr.Parent=p

	local Lb=Instance.new("TextLabel")
	Lb.Size=UDim2.new(0.6,0,1,0)
	Lb.BackgroundTransparency=1
	Lb.Text=t
	Lb.TextColor3=Color3.fromRGB(200,200,210)
	Lb.TextSize=12
	Lb.Font=Enum.Font.Gotham
	Lb.TextXAlignment=Enum.TextXAlignment.Left
	Lb.ZIndex=7
	Lb.Parent=Fr

	local Bg=Instance.new("TextButton")
	Bg.Size=UDim2.new(0,36,0,20)
	Bg.Position=UDim2.new(1,-40,0.5,-10)
	Bg.BackgroundColor3=Color3.fromRGB(50,50,65)
	Bg.BorderSizePixel=0
	Bg.Text=""
	Bg.ZIndex=7
	Bg.Parent=Fr
	Instance.new("UICorner",Bg).CornerRadius=UDim.new(1,0)

	local Kn=Instance.new("Frame")
	Kn.Size=UDim2.new(0,16,0,16)
	Kn.Position=UDim2.new(0,2,0.5,-8)
	Kn.BackgroundColor3=Color3.fromRGB(220,220,220)
	Kn.BorderSizePixel=0
	Kn.ZIndex=8
	Kn.Parent=Bg
	Instance.new("UICorner",Kn).CornerRadius=UDim.new(1,0)

	local on=K[k]
	local function Up()
		if on then
			T:Create(Bg,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(139,92,246)}):Play()
			T:Create(Kn,TweenInfo.new(0.2),{Position=UDim2.new(1,-18,0.5,-8)}):Play()
		else
			T:Create(Bg,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(50,50,65)}):Play()
			T:Create(Kn,TweenInfo.new(0.2),{Position=UDim2.new(0,2,0.5,-8)}):Play()
		end
		K[k]=on
	end
	Up()
	Bg.MouseButton1Click:Connect(function()on=not on;Up()end)
end

-- Slider
local function Sld(p,t,mi,ma,def,k,sfx)
	local Fr=Instance.new("Frame")
	Fr.Size=UDim2.new(1,0,0,40)
	Fr.BackgroundTransparency=1
	Fr.ZIndex=6
	Fr.Parent=p

	local Lb=Instance.new("TextLabel")
	Lb.Size=UDim2.new(0.5,0,0,16)
	Lb.BackgroundTransparency=1
	Lb.Text=t
	Lb.TextColor3=Color3.fromRGB(200,200,210)
	Lb.TextSize=11
	Lb.Font=Enum.Font.Gotham
	Lb.TextXAlignment=Enum.TextXAlignment.Left
	Lb.ZIndex=7
	Lb.Parent=Fr

	local Vl=Instance.new("TextLabel")
	Vl.Size=UDim2.new(0.3,0,0,16)
	Vl.Position=UDim2.new(0.7,0,0,0)
	Vl.BackgroundTransparency=1
	Vl.Text=tostring(def)..(sfx or"")
	Vl.TextColor3=Color3.fromRGB(139,92,246)
	Vl.TextSize=11
	Vl.Font=Enum.Font.GothamBold
	Vl.TextXAlignment=Enum.TextXAlignment.Right
	Vl.ZIndex=7
	Vl.Parent=Fr

	local Tk=Instance.new("Frame")
	Tk.Size=UDim2.new(1,0,0,4)
	Tk.Position=UDim2.new(0,0,0,26)
	Tk.BackgroundColor3=Color3.fromRGB(40,40,55)
	Tk.BorderSizePixel=0
	Tk.ZIndex=7
	Tk.Parent=Fr
	Instance.new("UICorner",Tk).CornerRadius=UDim.new(1,0)

	local Fl=Instance.new("Frame")
	Fl.Size=UDim2.new((def-mi)/(ma-mi),0,1,0)
	Fl.BackgroundColor3=Color3.fromRGB(139,92,246)
	Fl.BorderSizePixel=0
	Fl.ZIndex=8
	Fl.Parent=Tk
	Instance.new("UICorner",Fl).CornerRadius=UDim.new(1,0)

	local Kb=Instance.new("Frame")
	Kb.Size=UDim2.new(0,10,0,10)
	Kb.Position=UDim2.new((def-mi)/(ma-mi),-5,0.5,-5)
	Kb.BackgroundColor3=Color3.fromRGB(255,255,255)
	Kb.BorderSizePixel=0
	Kb.ZIndex=9
	Kb.Parent=Tk
	Instance.new("UICorner",Kb).CornerRadius=UDim.new(1,0)

	local Ht=Instance.new("TextButton")
	Ht.Size=UDim2.new(1,0,1,12)
	Ht.Position=UDim2.new(0,0,0,-6)
	Ht.BackgroundTransparency=1
	Ht.Text=""
	Ht.ZIndex=10
	Ht.Parent=Tk

	local dg=false
	local function Upd(i)
		local ps=math.clamp((i.Position.X-Tk.AbsolutePosition.X)/Tk.AbsoluteSize.X,0,1)
		local v=math.floor(mi+(ma-mi)*ps)
		K[k]=v;Vl.Text=tostring(v)..(sfx or"")
		Fl.Size=UDim2.new(ps,0,1,0)
		Kb.Position=UDim2.new(ps,-5,0.5,-5)
	end
	Ht.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dg=true;Upd(i)end end)
	U.InputChanged:Connect(function(i)if dg and i.UserInputType==Enum.UserInputType.MouseMovement then Upd(i)end end)
	U.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dg=false end end)
end

-- Dropdown
local function Drp(p,t,opts,k)
	local Fr=Instance.new("Frame")
	Fr.Size=UDim2.new(1,0,0,28)
	Fr.BackgroundTransparency=1
	Fr.ZIndex=6
	Fr.Parent=p

	local Lb=Instance.new("TextLabel")
	Lb.Size=UDim2.new(0.4,0,1,0)
	Lb.BackgroundTransparency=1
	Lb.Text=t
	Lb.TextColor3=Color3.fromRGB(200,200,210)
	Lb.TextSize=12
	Lb.Font=Enum.Font.Gotham
	Lb.TextXAlignment=Enum.TextXAlignment.Left
	Lb.ZIndex=7
	Lb.Parent=Fr

	local Sel=Instance.new("TextButton")
	Sel.Size=UDim2.new(0,110,0,22)
	Sel.Position=UDim2.new(1,-114,0.5,-11)
	Sel.BackgroundColor3=Color3.fromRGB(30,30,45)
	Sel.BorderSizePixel=0
	Sel.Text=K[k]or opts[1]
	Sel.TextColor3=Color3.fromRGB(139,92,246)
	Sel.TextSize=11
	Sel.Font=Enum.Font.GothamBold
	Sel.ZIndex=7
	Sel.Parent=Fr
	Instance.new("UICorner",Sel).CornerRadius=UDim.new(0,6)

	local Ar=Instance.new("TextLabel")
	Ar.Size=UDim2.new(0,16,0,16)
	Ar.Position=UDim2.new(1,-18,0,3)
	Ar.BackgroundTransparency=1
	Ar.Text="▼"
	Ar.TextColor3=Color3.fromRGB(139,92,246)
	Ar.TextSize=9
	Ar.Font=Enum.Font.GothamBold
	Ar.ZIndex=8
	Ar.Parent=Sel

	local Ls=Instance.new("Frame")
	Ls.Size=UDim2.new(0,110,0,#opts*24)
	Ls.Position=UDim2.new(0,0,0,24)
	Ls.BackgroundColor3=Color3.fromRGB(26,26,40)
	Ls.BorderSizePixel=0
	Ls.ZIndex=12
	Ls.Visible=false
	Ls.Parent=Sel
	Instance.new("UICorner",Ls).CornerRadius=UDim.new(0,6)

	for i,o in ipairs(opts)do
		local B=Instance.new("TextButton")
		B.Size=UDim2.new(1,0,0,24)
		B.Position=UDim2.new(0,0,0,(i-1)*24)
		B.BackgroundTransparency=1
		B.Text=o
		B.TextColor3=Color3.fromRGB(180,180,190)
		B.TextSize=11
		B.Font=Enum.Font.Gotham
		B.ZIndex=13
		B.Parent=Ls
		B.MouseEnter:Connect(function()B.BackgroundColor3=Color3.fromRGB(139,92,246)B.BackgroundTransparency=0.8 end)
		B.MouseLeave:Connect(function()B.BackgroundTransparency=1 end)
		B.MouseButton1Click:Connect(function()K[k]=o;Sel.Text=o;Ls.Visible=false;Ar.Text="▼"end)
	end
	Sel.MouseButton1Click:Connect(function()Ls.Visible=not Ls.Visible;Ar.Text=Ls.Visible and"▲"or"▼"end)
end

-- Button
local function Btn(p,t,cb,col)
	local Fr=Instance.new("Frame")
	Fr.Size=UDim2.new(1,0,0,32)
	Fr.BackgroundTransparency=1
	Fr.ZIndex=6
	Fr.Parent=p

	local B=Instance.new("TextButton")
	B.Size=UDim2.new(1,0,1,0)
	B.BackgroundColor3=col or Color3.fromRGB(139,92,246)
	B.BackgroundTransparency=0.4
	B.BorderSizePixel=0
	B.Text=t
	B.TextColor3=Color3.fromRGB(255,255,255)
	B.TextSize=12
	B.Font=Enum.Font.GothamBold
	B.ZIndex=7
	B.Parent=Fr
	Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)

	B.MouseEnter:Connect(function()T:Create(B,TweenInfo.new(0.15),{BackgroundTransparency=0.1}):Play()end)
	B.MouseLeave:Connect(function()T:Create(B,TweenInfo.new(0.15),{BackgroundTransparency=0.4}):Play()end)
	B.MouseButton1Click:Connect(cb)
end

-- ==================== TABS ====================
local Farm=Tab("Farm","⚡")
local Build=Tab("Build","🏗️")
local Play=Tab("Player","🚀")
local World=Tab("World","🌍")

-- Farm
local s1=Sec(Farm,"Auto Farm")
Tog(s1,"Auto Farm Gold","Farm")
Tog(s1,"God Mode","God")
Tog(s1,"Auto Claim","Claim")
Tog(s1,"Anti-AFK","AFK")
local s2=Sec(Farm,"Settings")
Sld(s2,"Farm Speed",50,500,375,"FlySpd","")
Sld(s2,"Stage Delay",1,10,3,"StgDel","s")

-- Build
local s3=Sec(Build,"Blocks")
Tog(s3,"Infinite Blocks","Inf")
Tog(s3,"Fast Place","Fast")
Tog(s3,"Auto Weld","Weld")
Drp(s3,"Template:",{"GoldFarm","Jet","Boat","Tower"},"Template")
local s4=Sec(Build,"Actions")
Btn(s4,"▶ Build Template",function()K.Build=true;print("[KYDIABROSO] Building "..K.Template)end,Color3.fromRGB(16,185,129))
Btn(s4,"⏹ Stop Build",function()K.Build=false end,Color3.fromRGB(239,68,68))
Btn(s4,"📋 Steal Boat",function()K.Steal=true;print("[KYDIABROSO] Stealing...")end,Color3.fromRGB(245,158,11))

-- Player
local s5=Sec(Play,"Movement")
Tog(s5,"Fly","Fly")
Sld(s5,"Fly Speed",10,500,120,"FlySpd","")
Tog(s5,"Speed","Spd")
Sld(s5,"Walk Speed",16,200,80,"WalkSpd","")
Sld(s5,"Jump Power",10,200,50,"JumpPw","")
Tog(s5,"Noclip","Noclip")
local s6=Sec(Play,"Teleports")
Btn(s6,"Spawn",function()pcall(function()Hrp().CFrame=CFrame.new(-43,62,672)end)end)
Btn(s6,"Gold Chest",function()pcall(function()Hrp().CFrame=CFrame.new(-54,-345,9488)end)end)
Btn(s6,"Stage 10",function()
	pcall(function()
		local st=W:FindFirstChild("BoatStages")and W.BoatStages:FindFirstChild("NormalStages")
		if st and st:FindFirstChild("CaveStage10")then
			local dp=st.CaveStage10:FindFirstChild("DarknessPart")
			if dp then Hrp().CFrame=dp.CFrame end
		end
	end)
end)

-- World
local s7=Sec(World,"Environment")
Tog(s7,"Delete Water","DelW")
Tog(s7,"No Fog","NoFog")
Btn(s7,"Full Bright",function()
	pcall(function()
		L.Brightness=2;L.ClockTime=14;L.GlobalShadows=false;L.FogEnd=100000
	end)
end)

-- Activate Farm tab
Tabs["Farm"].Frame.Visible=true
Tabs["Farm"].Button.TextColor3=Color3.fromRGB(139,92,246)
Tabs["Farm"].Button.BackgroundColor3=Color3.fromRGB(139,92,246)
Tabs["Farm"].Button.BackgroundTransparency=0.85

-- Sidebar layout
local y=8
for _,t in pairs(Tabs)do t.Button.Position=UDim2.new(0,5,0,y);y=y+34 end

-- ==================== LOGIC ====================

-- GodMode
task.spawn(function()while S and S.Parent do if K.God then pcall(function()local h=Hum();h.MaxHealth=1e9;h.Health=1e9 end)end;task.wait(0.3)end end)

-- AntiAFK
task.spawn(function()while true do if K.AFK then V:SendKeyEvent(true,Enum.KeyCode.K,false,game)V:SendKeyEvent(false,Enum.KeyCode.K,false,game)end;task.wait(10)end end)

-- AutoClaim
task.spawn(function()
	while S and S.Parent do
		if K.Claim then
			pcall(function()
				local pg=LP:FindFirstChild("PlayerGui")
				if pg and pg:FindFirstChild("Main")then
					local gs=pg.Main:FindFirstChild("goldShow2")
					if gs and gs.Visible then
						local b=gs:FindFirstChild("Frame2")and gs.Frame2:FindFirstChild("TextButton")
						if b then for _,c in pairs(getconnections(b.MouseButton1Click))do c:Fire()end end
					end
				end
			end)
		end
		task.wait(0.5)
	end
end)

-- InfBlocks
task.spawn(function()
	while true do
		if K.Inf then
			pcall(function()
				local bp=LP:FindFirstChild("Backpack")
				if bp then for _,t in pairs(bp:GetChildren())do if t:IsA("Tool")then local a=t:FindFirstChild("Amount")if a then a.Value=9999 end end end end
				for _,t in pairs(Ch():GetChildren())do if t:IsA("Tool")then local a=t:FindFirstChild("Amount")if a then a.Value=9999 end end end
			end)
		end
		task.wait(0.3)
	end
end)

-- AutoFarm (Tween method)
local Stages={
	CFrame.new(-43.6,62.1,672.7),
	CFrame.new(-60.1,97.4,8767.9),
	CFrame.new(-54.3,-345.4,9488.6),
}

local function Twn(cf,spd)
	local hrp=Hrp()
	local d=(hrp.Position-cf.Position).Magnitude
	local tw=T:Create(hrp,TweenInfo.new(d/(spd or 375),Enum.EasingStyle.Linear),{CFrame=cf})
	tw:Play()
	tw.Completed:Wait()
end

local function Coll()
	pcall(function()
		local hrp=Hrp()
		for _,o in pairs(W:GetDescendants())do
			if o:IsA("BasePart")and o:FindFirstChild("TouchInterest")then
				local n=o.Name:lower()
				if n:find("gold")or n:find("coin")or n:find("nugget")then
					if(o.Position-hrp.Position).Magnitude<=40 then
						firetouchinterest(hrp,o,0)firetouchinterest(hrp,o,1)
					end
				end
			end
			if o:IsA("ClickDetector")then
				local p=o.Parent
				if p and p:IsA("BasePart")then
					local n=p.Name:lower()
					if(n:find("gold")or n:find("statue")or n:find("chest"))and(p.Position-hrp.Position).Magnitude<=40 then
						pcall(function()fireclickdetector(o,50)end)
					end
				end
			end
		end
	end)
end

local function DoFarm()
	pcall(function()
		W.Gravity=0
		for _,cf in ipairs(Stages)do if not K.Farm then break end;Twn(cf,K.FlySpd);Coll();task.wait(0.3)end
		local st=W:FindFirstChild("BoatStages")and W.BoatStages:FindFirstChild("NormalStages")
		if st and K.Farm then for i=1,10 do if not K.Farm then break end local s=st:FindFirstChild("CaveStage"..i)if s then local dp=s:FindFirstChild("DarknessPart")if dp then Twn(dp.CFrame,K.FlySpd);Coll();pcall(function()local ge=W:FindFirstChild("ClaimRiverResultsGold")if ge then ge:FireServer()end end);task.wait(K.StgDel or 0.3)end end end end
		local ch=W:FindFirstChild("BoatStages")and W.BoatStages:FindFirstChild("NormalStages")and W.BoatStages.NormalStages:FindFirstChild("TheEnd")and W.BoatStages.NormalStages.TheEnd:FindFirstChild("GoldenChest")and W.BoatStages.NormalStages.TheEnd.GoldenChest:FindFirstChild("Trigger")
		if ch and K.Farm then Twn(ch.CFrame+Vector3.new(0,5,0),K.FlySpd);Coll()end
		W.Gravity=196.2
		if K.Farm then task.wait(1);pcall(function()Hum().Health=0 end);task.wait(6)end
	end)
end

task.spawn(function()while true do if K.Farm then DoFarm()end;task.wait(0.5)end end)

-- Build Templates
local Tmpls={
	GoldFarm={{b="WoodBlock",p=Vector3.new(0,0,0)},{b="WoodBlock",p=Vector3.new(0,1,0)},{b="Seat",p=Vector3.new(0,2,0)},{b="Thruster",p=Vector3.new(0,0,-2)},{b="Balloon",p=Vector3.new(-1,2,0)},{b="Balloon",p=Vector3.new(1,2,0)}},
	Jet={{b="WoodBlock",p=Vector3.new(0,0,0)},{b="WoodBlock",p=Vector3.new(0,1,0)},{b="Seat",p=Vector3.new(0,2,0)},{b="Thruster",p=Vector3.new(-1,0,-3)},{b="Thruster",p=Vector3.new(1,0,-3)}},
	Boat={{b="WoodBlock",p=Vector3.new(0,0,0)},{b="Seat",p=Vector3.new(0,1,0)},{b="Thruster",p=Vector3.new(0,0,-3)}},
	Tower={{b="WoodBlock",p=Vector3.new(0,0,0)},{b="WoodBlock",p=Vector3.new(0,1,0)},{b="WoodBlock",p=Vector3.new(0,2,0)},{b="Seat",p=Vector3.new(0,3,0)},{b="Thruster",p=Vector3.new(0,0,-2)}},
}

local function Pl(bn,cf)
	pcall(function()
		local tool=Ch():FindFirstChildOfClass("Tool")
		if not tool then local bp=LP:FindFirstChild("Backpack")if bp then for _,t in pairs(bp:GetChildren())do if t:IsA("Tool")and(t.Name:lower():find("block")or t.Name:lower():find("wood")or t.Name:lower():find("thruster")or t.Name:lower():find("seat")or t.Name:lower():find("balloon"))then t.Parent=Ch();tool=t;break end end end end
		if tool then local ev=tool:FindFirstChild("BuildEvent")or tool:FindFirstChild("PlaceBlock")or tool:FindFirstChild("Place")if ev then ev:FireServer(cf.Position,cf)end end
	end)
end

task.spawn(function()
	while true do
		if K.Build then
			pcall(function()
				local tm=Tmpls[K.Template]
				if tm then
					local hrp=Hrp();local b=hrp.Position
					for _,d in ipairs(tm)do if not K.Build then break end;Pl(d.b,CFrame.new(b+d.p));task.wait(K.Fast and 0.05 or 0.15)end
					if K.Weld then task.wait(0.5);for _,bt in pairs(W:GetChildren())do if bt.Name:find(LP.Name)or bt.Name:lower():find("boat")then local pts={}for _,pt in pairs(bt:GetDescendants())do if pt:IsA("BasePart")then table.insert(pts,pt)end end;for i=2,#pts do local wl=Instance.new("WeldConstraint")wl.Part0=pts[1]wl.Part1=pts[i]wl.Parent=pts[i]end end end end
					K.Build=false;print("[KYDIABROSO] Build done!")
				end
			end)
		end
		task.wait(0.5)
	end
end)

-- Steal
task.spawn(function()
	while true do
		if K.Steal then
			pcall(function()
				local hrp=Hrp();local mp=hrp.Position;local trg=nil;local md=60
				for _,o in pairs(W:GetChildren())do if o.Name:lower():find("boat")or o:FindFirstChild("Seat")then local pr=o:FindFirstChildWhichIsA("BasePart")if pr then local d=(pr.Position-mp).Magnitude if d<md and not o.Name:find(LP.Name)then trg=o;md=d end end end end
				if trg th