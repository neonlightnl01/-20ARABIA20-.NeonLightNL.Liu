-- Neon Lightings.Lua (NL) By arabia
-- Sistema de Chave + Farol/Setas + Interface Melhorada

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- =========================================================
-- ====================== SISTEMA DE CHAVE =================
-- =========================================================
local correctKey = "NL01"   -- << ALTERE A CHAVE AQUI

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonLightingHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Tela de Chave
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeySystem"
KeyFrame.Size = UDim2.new(0, 320, 0, 210)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -105)
KeyFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
KeyFrame.BorderSizePixel = 0
KeyFrame.ZIndex = 200
KeyFrame.Parent = ScreenGui

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 14)

local keyStroke = Instance.new("UIStroke", KeyFrame)
keyStroke.Color = Color3.fromRGB(0, 190, 255)
keyStroke.Thickness = 2

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Position = UDim2.new(0, 0, 0, 15)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Neon Lighting's"
KeyTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 20
KeyTitle.ZIndex = 201

local KeySub = Instance.new("TextLabel", KeyFrame)
KeySub.Size = UDim2.new(1, 0, 0, 20)
KeySub.Position = UDim2.new(0, 0, 0, 48)
KeySub.BackgroundTransparency = 1
KeySub.Text = "Digite a chave de acesso"
KeySub.TextColor3 = Color3.fromRGB(160, 160, 175)
KeySub.Font = Enum.Font.Gotham
KeySub.TextSize = 13
KeySub.ZIndex = 201

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0.8, 0, 0, 38)
KeyBox.Position = UDim2.new(0.1, 0, 0, 85)
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Chave..."
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 15
KeyBox.ClearTextOnFocus = false
KeyBox.ZIndex = 201
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local KeyError = Instance.new("TextLabel", KeyFrame)
KeyError.Size = UDim2.new(1, 0, 0, 18)
KeyError.Position = UDim2.new(0, 0, 0, 128)
KeyError.BackgroundTransparency = 1
KeyError.Text = ""
KeyError.TextColor3 = Color3.fromRGB(255, 80, 80)
KeyError.Font = Enum.Font.Gotham
KeyError.TextSize = 12
KeyError.ZIndex = 201

local VerifyBtn = Instance.new("TextButton", KeyFrame)
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 38)
VerifyBtn.Position = UDim2.new(0.1, 0, 0, 155)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
VerifyBtn.Text = "Verificar Chave"
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 15
VerifyBtn.AutoButtonColor = false
VerifyBtn.ZIndex = 201
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

local keyAccepted = false

local function acceptKey()
	keyAccepted = true
	KeyFrame:Destroy()
end

VerifyBtn.MouseButton1Click:Connect(function()
	if KeyBox.Text == correctKey then
		KeyError.Text = ""
		KeyError.TextColor3 = Color3.fromRGB(0, 255, 120)
		KeyError.Text = "Chave correta!"
		task.wait(0.45)
		acceptKey()
	else
		KeyError.Text = "Chave incorreta!"
		KeyBox.Text = ""
	end
end)

KeyBox.FocusLost:Connect(function(enter)
	if enter then
		if KeyBox.Text == correctKey then
			KeyError.Text = "Chave correta!"
			KeyError.TextColor3 = Color3.fromRGB(0, 255, 120)
			task.wait(0.45)
			acceptKey()
		else
			KeyError.Text = "Chave incorreta!"
			KeyBox.Text = ""
		end
	end
end)

repeat task.wait() until keyAccepted

-- =========================================================
-- ====================== RESTANTE DO SCRIPT ===============
-- =========================================================

local character, humanoid, rootPart

local function getChar()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end

getChar()

local TECLA_HUB = Enum.KeyCode.K

local walkSpeed = 16
local flySpeed = 55

local flying = false
local noclip = false
local espEnabled = false
local freecam = false
local antiLagEnabled = false
local gravityEnabled = false
local fovEnabled = false
local lightsEnabled = false

local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil
local freecamConnection = nil

local hubOpen = true

local originalTransparencies = {}
local originalCanCollide = {}

local fullbrightEnabled = false
local noFogEnabled = false
local bloomEnabled = false
local neonShaderEnabled = false
local nightVisionEnabled = false
local highContrastEnabled = false
local blackWhiteEnabled = false
local blurEnabled = false

local originalLighting = {
	Brightness = Lighting.Brightness,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	FogEnd = Lighting.FogEnd,
	FogStart = Lighting.FogStart,
	GlobalShadows = Lighting.GlobalShadows,
	ClockTime = Lighting.ClockTime
}

local aimEnabled = false
local selectedTarget = nil
local aimSmoothness = 0.18
local aimMaxDistance = 5000
local aimPart = "Head"
local aimConnection = nil

local currentFPS = 0
local gravityOutside = 196.2
local gravityInside = 196.2
local currentFOV = 70

local tapCount = 0
local lastTapTime = 0
local TAP_WINDOW = 0.45

local function playClickSound()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://6895079853"
	sound.Volume = 0.35
	sound.Parent = SoundService
	sound:Play()
	sound.Ended:Connect(function() sound:Destroy() end)
end

-- Tela de Carregamento
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingScreen"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 100
LoadingFrame.Parent = ScreenGui

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 50)
LoadingTitle.Position = UDim2.new(0, 0, 0.38, 0)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "Carregando Script da NL"
LoadingTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.TextSize = 28
LoadingTitle.ZIndex = 101
LoadingTitle.Parent = LoadingFrame

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 25)
LoadingSub.Position = UDim2.new(0, 0, 0.45, 0)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = "Neon Lighting's  •  By arabia"
LoadingSub.TextColor3 = Color3.fromRGB(160, 160, 175)
LoadingSub.Font = Enum.Font.Gotham
LoadingSub.TextSize = 14
LoadingSub.ZIndex = 101
LoadingSub.Parent = LoadingFrame

local LoadingDots = Instance.new("TextLabel")
LoadingDots.Size = UDim2.new(1, 0, 0, 30)
LoadingDots.Position = UDim2.new(0, 0, 0.52, 0)
LoadingDots.BackgroundTransparency = 1
LoadingDots.Text = "."
LoadingDots.TextColor3 = Color3.fromRGB(0, 200, 255)
LoadingDots.Font = Enum.Font.GothamBold
LoadingDots.TextSize = 32
LoadingDots.ZIndex = 101
LoadingDots.Parent = LoadingFrame

local ProgressBG = Instance.new("Frame")
ProgressBG.Size = UDim2.new(0, 280, 0, 6)
ProgressBG.Position = UDim2.new(0.5, -140, 0.60, 0)
ProgressBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ProgressBG.BorderSizePixel = 0
ProgressBG.ZIndex = 101
ProgressBG.Parent = LoadingFrame
Instance.new("UICorner", ProgressBG).CornerRadius = UDim.new(1, 0)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 102
ProgressFill.Parent = ProgressBG
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

local LoadingPercent = Instance.new("TextLabel")
LoadingPercent.Size = UDim2.new(1, 0, 0, 20)
LoadingPercent.Position = UDim2.new(0, 0, 0.64, 0)
LoadingPercent.BackgroundTransparency = 1
LoadingPercent.Text = "0%"
LoadingPercent.TextColor3 = Color3.fromRGB(140, 140, 155)
LoadingPercent.Font = Enum.Font.Gotham
LoadingPercent.TextSize = 13
LoadingPercent.ZIndex = 101
LoadingPercent.Parent = LoadingFrame

local dots = {".", "..", "...", "...."}
local dotIndex = 1
local loadingFinished = false

local dotsConnection = RunService.Heartbeat:Connect(function()
	if loadingFinished then return end
	dotIndex = (dotIndex % 4) + 1
	LoadingDots.Text = dots[dotIndex]
	task.wait(0.35)
end)

TweenService:Create(ProgressFill, TweenInfo.new(2.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(1, 0, 1, 0)
}):Play()

task.spawn(function()
	for i = 0, 100, 2 do
		if loadingFinished then break end
		LoadingPercent.Text = i .. "%"
		task.wait(0.05)
	end
	LoadingPercent.Text = "100%"
end)

-- Hub Principal
local Main = Instance.new("Frame")
Main.Name = "MainHub"
Main.Size = UDim2.new(0.78, 0, 0.80, 0)
Main.Position = UDim2.new(0.11, 0, 0.10, 0)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(0, 190, 255)
stroke.Thickness = 1.8
stroke.Transparency = 0.15

local Background = Instance.new("ImageLabel")
Background.Name = "Background"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundTransparency = 1
Background.Image = "rbxassetid://COLOQUE_O_ID_AQUI"
Background.ImageTransparency = 0.72
Background.ScaleType = Enum.ScaleType.Crop
Background.ZIndex = 0
Background.Parent = Main

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.ZIndex = 2

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 0, 24)
Title.Position = UDim2.new(0, 16, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "Neon Lighting's"
Title.TextColor3 = Color3.fromRGB(0, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3

local SubTitle = Instance.new("TextLabel", Header)
SubTitle.Size = UDim2.new(1, -60, 0, 16)
SubTitle.Position = UDim2.new(0, 16, 0, 30)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "By arabia  •  v2"
SubTitle.TextColor3 = Color3.fromRGB(140, 140, 155)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 3

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -44, 0, 9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 25)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 5
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

CloseBtn.MouseEnter:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(70, 25, 30)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 20, 25)}):Play()
end)

local FloatingIcon

local function openHub()
	hubOpen = true
	Main.Visible = true
	if FloatingIcon then FloatingIcon.Visible = false end
	playClickSound()
end

local function closeHub()
	hubOpen = false
	Main.Visible = false
	if FloatingIcon then FloatingIcon.Visible = true end
	playClickSound()
end

local function toggleHub()
	if hubOpen then closeHub() else openHub() end
end

-- Ícone Flutuante com "NL"
FloatingIcon = Instance.new("ImageButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Size = UDim2.new(0, 64, 0, 64)
FloatingIcon.Position = UDim2.new(1, -82, 0.5, -32)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
FloatingIcon.BackgroundTransparency = 0.1
FloatingIcon.Image = "rbxassetid://COLOQUE_O_ID_AQUI"
FloatingIcon.ScaleType = Enum.ScaleType.Fit
FloatingIcon.Visible = false
FloatingIcon.ZIndex = 50
FloatingIcon.Parent = ScreenGui

Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(0, 16)

local iconStroke = Instance.new("UIStroke", FloatingIcon)
iconStroke.Color = Color3.fromRGB(0, 190, 255)
iconStroke.Thickness = 2.2

local NLText = Instance.new("TextLabel")
NLText.Name = "NLText"
NLText.Size = UDim2.new(1, 0, 1, 0)
NLText.BackgroundTransparency = 1
NLText.Text = "NL"
NLText.TextColor3 = Color3.fromRGB(0, 230, 255)
NLText.Font = Enum.Font.GothamBlack
NLText.TextSize = 24
NLText.TextStrokeTransparency = 0.6
NLText.TextStrokeColor3 = Color3.fromRGB(0, 100, 150)
NLText.ZIndex = 51
NLText.Parent = FloatingIcon

task.spawn(function()
	while true do
		if FloatingIcon and FloatingIcon.Visible then
			TweenService:Create(iconStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.55}):Play()
			task.wait(1.2)
			TweenService:Create(iconStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
			task.wait(1.2)
		else
			task.wait(0.5)
		end
	end
end)

local dragStartPos, iconStartPos, isDragging = nil, nil, false

FloatingIcon.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
		dragStartPos = input.Position
		iconStartPos = FloatingIcon.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragStartPos then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = input.Position - dragStartPos
	if delta.Magnitude > 10 then isDragging = true end
	FloatingIcon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if dragStartPos then
			if not isDragging then openHub() end
			dragStartPos = nil
			isDragging = false
		end
	end
end)

-- Tabs
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(1, -20, 0, 36)
TabBar.Position = UDim2.new(0, 10, 0, 58)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex = 2

local function createTab(text, order)
	local btn = Instance.new("TextButton", TabBar)
	btn.Size = UDim2.new(1/6, -4, 1, 0)
	btn.Position = UDim2.new((order-1)/6, 2, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(170, 170, 180)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.AutoButtonColor = false
	btn.ZIndex = 3
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local TabMainBtn    = createTab("Principal", 1)
local TabShaderBtn  = createTab("Shaders", 2)
local TabAimBtn     = createTab("Aimbot", 3)
local TabAntiBtn    = createTab("AntiLag", 4)
local TabGravityBtn = createTab("Gravity", 5)
local TabFOVBtn     = createTab("FOV", 6)

local function createPage()
	local page = Instance.new("ScrollingFrame", Main)
	page.Size = UDim2.new(1, -16, 1, -110)
	page.Position = UDim2.new(0, 8, 0, 100)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 4
	page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.ZIndex = 1

	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local padding = Instance.new("UIPadding", page)
	padding.PaddingTop = UDim.new(0, 6)
	padding.PaddingBottom = UDim.new(0, 20)

	return page
end

local PageMain    = createPage()
local PageShaders = createPage()
local PageAim     = createPage()
local PageAnti    = createPage()
local PageGravity = createPage()
local PageFOV     = createPage()
PageMain.Visible = true

local function setTabActive(btn, active)
	if active then
		btn.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	else
		btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
		btn.TextColor3 = Color3.fromRGB(170, 170, 180)
	end
end

local function switchPage(pageName)
	PageMain.Visible    = pageName == "main"
	PageShaders.Visible = pageName == "shaders"
	PageAim.Visible     = pageName == "aim"
	PageAnti.Visible    = pageName == "anti"
	PageGravity.Visible = pageName == "gravity"
	PageFOV.Visible     = pageName == "fov"

	setTabActive(TabMainBtn,    pageName == "main")
	setTabActive(TabShaderBtn,  pageName == "shaders")
	setTabActive(TabAimBtn,     pageName == "aim")
	setTabActive(TabAntiBtn,    pageName == "anti")
	setTabActive(TabGravityBtn, pageName == "gravity")
	setTabActive(TabFOVBtn,     pageName == "fov")
end

TabMainBtn.MouseButton1Click:Connect(function() switchPage("main") end)
TabShaderBtn.MouseButton1Click:Connect(function() switchPage("shaders") end)
TabAimBtn.MouseButton1Click:Connect(function() switchPage("aim") end)
TabAntiBtn.MouseButton1Click:Connect(function() switchPage("anti") end)
TabGravityBtn.MouseButton1Click:Connect(function() switchPage("gravity") end)
TabFOVBtn.MouseButton1Click:Connect(function() switchPage("fov") end)

setTabActive(TabMainBtn, true)

local function createButton(parent, text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.94, 0, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(235, 235, 240)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.ZIndex = 2
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

	local s = Instance.new("UIStroke", btn)
	s.Color = color
	s.Thickness = 1.3
	s.Transparency = 0.55

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(32, 32, 40)}):Play()
		TweenService:Create(s, TweenInfo.new(0.12), {Transparency = 0.25}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
		TweenService:Create(s, TweenInfo.new(0.12), {Transparency = 0.55}):Play()
	end)

	return btn
end

local function createSlider(parent, labelText, minVal, maxVal, defaultVal, color, onChanged)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.94, 0, 0, 52)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, 0, 0, 18)
	label.BackgroundTransparency = 1
	label.Text = labelText .. ": " .. tostring(defaultVal)
	label.TextColor3 = Color3.fromRGB(210, 210, 220)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 2

	local track = Instance.new("Frame", container)
	track.Size = UDim2.new(1, 0, 0, 8)
	track.Position = UDim2.new(0, 0, 0, 28)
	track.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	track.BorderSizePixel = 0
	track.ZIndex = 2
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame", track)
	local defaultPercent = (defaultVal - minVal) / (maxVal - minVal)
	fill.Size = UDim2.new(defaultPercent, 0, 1, 0)
	fill.BackgroundColor3 = color
	fill.BorderSizePixel = 0
	fill.ZIndex = 2
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local handle = Instance.new("TextButton", track)
	handle.Size = UDim2.new(0, 18, 0, 18)
	handle.Position = UDim2.new(defaultPercent, -9, 0.5, -9)
	handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	handle.Text = ""
	handle.AutoButtonColor = false
	handle.ZIndex = 3
	Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

	local strokeH = Instance.new("UIStroke", handle)
	strokeH.Color = color
	strokeH.Thickness = 2

	local dragging = false
	local currentValue = defaultVal
	local lastSoundValue = defaultVal

	local function updateVisual(val)
		currentValue = math.clamp(math.floor(val + 0.5), minVal, maxVal)
		local percent = (currentValue - minVal) / (maxVal - minVal)
		fill.Size = UDim2.new(percent, 0, 1, 0)
		handle.Position = UDim2.new(percent, -9, 0.5, -9)
		label.Text = labelText .. ": " .. tostring(currentValue)
		if onChanged then onChanged(currentValue) end
		if currentValue ~= lastSoundValue then
			playClickSound()
			lastSoundValue = currentValue
		end
	end

	handle.MouseButton1Down:Connect(function() dragging = true end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local mousePos = UserInputService:GetMouseLocation()
		local relative = math.clamp((mousePos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		updateVisual(minVal + relative * (maxVal - minVal))
	end)
	track.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local mousePos = UserInputService:GetMouseLocation()
		local relative = math.clamp((mousePos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		updateVisual(minVal + relative * (maxVal - minVal))
		dragging = true
	end)

	return { setValue = updateVisual, getValue = function() return currentValue end }
end

local function setState(btn, state, onText, offText, color)
	btn.Text = state and onText or offText
	btn.BackgroundColor3 = state and color or Color3.fromRGB(22, 22, 28)
end

-- =========================================================
-- ====================== PÁGINA PRINCIPAL =================
-- =========================================================
local FlyBtn     = createButton(PageMain, "Fly: OFF", Color3.fromRGB(0, 200, 255))
local NoclipBtn  = createButton(PageMain, "Noclip: OFF", Color3.fromRGB(0, 255, 150))
local ESPBtn     = createButton(PageMain, "ESP: OFF", Color3.fromRGB(255, 80, 80))
local FreeCamBtn = createButton(PageMain, "FreeCam: OFF", Color3.fromRGB(255, 150, 50))
local LightsBtn  = createButton(PageMain, "Farol + Setas: OFF", Color3.fromRGB(255, 220, 50))

createSlider(PageMain, "Corrida", 8, 100, 16, Color3.fromRGB(255, 200, 0), function(val)
	walkSpeed = val
	if humanoid and humanoid.Parent then humanoid.WalkSpeed = walkSpeed end
end)

createSlider(PageMain, "Voo", 20, 200, 55, Color3.fromRGB(0, 200, 255), function(val)
	flySpeed = val
end)

-- =========================================================
-- ====================== SHADERS ==========================
-- =========================================================
local FullbrightBtn   = createButton(PageShaders, "Fullbright: OFF", Color3.fromRGB(255, 220, 50))
local NoFogBtn        = createButton(PageShaders, "Sem Névoa: OFF", Color3.fromRGB(100, 200, 255))
local BloomBtn        = createButton(PageShaders, "Bloom: OFF", Color3.fromRGB(255, 100, 200))
local NeonShaderBtn   = createButton(PageShaders, "Neon Shader: OFF", Color3.fromRGB(0, 255, 180))
local NightVisionBtn  = createButton(PageShaders, "Night Vision: OFF", Color3.fromRGB(50, 255, 50))
local HighContrastBtn = createButton(PageShaders, "Alto Contraste: OFF", Color3.fromRGB(255, 180, 50))
local BlackWhiteBtn   = createButton(PageShaders, "Preto & Branco: OFF", Color3.fromRGB(200, 200, 200))
local BlurBtn         = createButton(PageShaders, "Blur: OFF", Color3.fromRGB(150, 100, 255))

local bloomEffect, colorCorrection, blurEffect = nil, nil, nil

local function toggleFullbright()
	fullbrightEnabled = not fullbrightEnabled
	if fullbrightEnabled then
		Lighting.Brightness = 2
		Lighting.Ambient = Color3.fromRGB(180, 180, 180)
		Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
		Lighting.GlobalShadows = false
		Lighting.ClockTime = 14
		setState(FullbrightBtn, true, "Fullbright: ON", "Fullbright: OFF", Color3.fromRGB(200, 170, 30))
	else
		Lighting.Brightness = originalLighting.Brightness
		Lighting.Ambient = originalLighting.Ambient
		Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
		Lighting.GlobalShadows = originalLighting.GlobalShadows
		Lighting.ClockTime = originalLighting.ClockTime
		setState(FullbrightBtn, false, "Fullbright: ON", "Fullbright: OFF", Color3.fromRGB(200, 170, 30))
	end
end

local function toggleNoFog()
	noFogEnabled = not noFogEnabled
	if noFogEnabled then
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
		setState(NoFogBtn, true, "Sem Névoa: ON", "Sem Névoa: OFF", Color3.fromRGB(60, 140, 200))
	else
		Lighting.FogEnd = originalLighting.FogEnd
		Lighting.FogStart = originalLighting.FogStart
		setState(NoFogBtn, false, "Sem Névoa: ON", "Sem Névoa: OFF", Color3.fromRGB(60, 140, 200))
	end
end

local function toggleBloom()
	bloomEnabled = not bloomEnabled
	if bloomEnabled then
		if not bloomEffect or not bloomEffect.Parent then
			bloomEffect = Instance.new("BloomEffect")
			bloomEffect.Intensity = 0.85
			bloomEffect.Size = 24
			bloomEffect.Threshold = 0.9
			bloomEffect.Parent = Lighting
		end
		bloomEffect.Enabled = true
		setState(BloomBtn, true, "Bloom: ON", "Bloom: OFF", Color3.fromRGB(200, 60, 150))
	else
		if bloomEffect then bloomEffect.Enabled = false end
		setState(BloomBtn, false, "Bloom: ON", "Bloom: OFF", Color3.fromRGB(200, 60, 150))
	end
end

local function toggleNeonShader()
	neonShaderEnabled = not neonShaderEnabled
	if neonShaderEnabled then
		if not colorCorrection or not colorCorrection.Parent then
			colorCorrection = Instance.new("ColorCorrectionEffect")
			colorCorrection.Parent = Lighting
		end
		colorCorrection.Enabled = true
		colorCorrection.Saturation = 0.6
		colorCorrection.Contrast = 0.3
		colorCorrection.Brightness = 0.05
		colorCorrection.TintColor = Color3.fromRGB(200, 240, 255)
		setState(NeonShaderBtn, true, "Neon Shader: ON", "Neon Shader: OFF", Color3.fromRGB(0, 180, 130))
	else
		if colorCorrection then colorCorrection.Enabled = false end
		setState(NeonShaderBtn, false, "Neon Shader: ON", "Neon Shader: OFF", Color3.fromRGB(0, 180, 130))
	end
end

local function toggleNightVision()
	nightVisionEnabled = not nightVisionEnabled
	if nightVisionEnabled then
		if not colorCorrection or not colorCorrection.Parent then
			colorCorrection = Instance.new("ColorCorrectionEffect")
			colorCorrection.Parent = Lighting
		end
		colorCorrection.Enabled = true
		colorCorrection.Saturation = -0.3
		colorCorrection.Contrast = 0.4
		colorCorrection.Brightness = 0.15
		colorCorrection.TintColor = Color3.fromRGB(80, 255, 100)
		Lighting.Brightness = 3
		Lighting.Ambient = Color3.fromRGB(40, 80, 40)
		setState(NightVisionBtn, true, "Night Vision: ON", "Night Vision: OFF", Color3.fromRGB(30, 180, 30))
	else
		if colorCorrection then colorCorrection.Enabled = false end
		Lighting.Brightness = originalLighting.Brightness
		Lighting.Ambient = originalLighting.Ambient
		setState(NightVisionBtn, false, "Night Vision: ON", "Night Vision: OFF", Color3.fromRGB(30, 180, 30))
	end
end

local function toggleHighContrast()
	highContrastEnabled = not highContrastEnabled
	if highContrastEnabled then
		if not colorCorrection or not colorCorrection.Parent then
			colorCorrection = Instance.new("ColorCorrectionEffect")
			colorCorrection.Parent = Lighting
		end
		colorCorrection.Enabled = true
		colorCorrection.Saturation = 0.2
		colorCorrection.Contrast = 0.7
		colorCorrection.Brightness = 0.1
		setState(HighContrastBtn, true, "Alto Contraste: ON", "Alto Contraste: OFF", Color3.fromRGB(200, 140, 30))
	else
		if colorCorrection then colorCorrection.Enabled = false end
		setState(HighContrastBtn, false, "Alto Contraste: ON", "Alto Contraste: OFF", Color3.fromRGB(200, 140, 30))
	end
end

local function toggleBlackWhite()
	blackWhiteEnabled = not blackWhiteEnabled
	if blackWhiteEnabled then
		if not colorCorrection or not colorCorrection.Parent then
			colorCorrection = Instance.new("ColorCorrectionEffect")
			colorCorrection.Parent = Lighting
		end
		colorCorrection.Enabled = true
		colorCorrection.Saturation = -1
		colorCorrection.Contrast = 0.15
		colorCorrection.Brightness = 0.05
		setState(BlackWhiteBtn, true, "Preto & Branco: ON", "Preto & Branco: OFF", Color3.fromRGB(150, 150, 150))
	else
		if colorCorrection then colorCorrection.Enabled = false end
		setState(BlackWhiteBtn, false, "Preto & Branco: ON", "Preto & Branco: OFF", Color3.fromRGB(150, 150, 150))
	end
end

local function toggleBlur()
	blurEnabled = not blurEnabled
	if blurEnabled then
		if not blurEffect or not blurEffect.Parent then
			blurEffect = Instance.new("BlurEffect")
			blurEffect.Size = 12
			blurEffect.Parent = Lighting
		end
		blurEffect.Enabled = true
		setState(BlurBtn, true, "Blur: ON", "Blur: OFF", Color3.fromRGB(120, 70, 200))
	else
		if blurEffect then blurEffect.Enabled = false end
		setState(BlurBtn, false, "Blur: ON", "Blur: OFF", Color3.fromRGB(120, 70, 200))
	end
end

FullbrightBtn.MouseButton1Click:Connect(toggleFullbright)
NoFogBtn.MouseButton1Click:Connect(toggleNoFog)
BloomBtn.MouseButton1Click:Connect(toggleBloom)
NeonShaderBtn.MouseButton1Click:Connect(toggleNeonShader)
NightVisionBtn.MouseButton1Click:Connect(toggleNightVision)
HighContrastBtn.MouseButton1Click:Connect(toggleHighContrast)
BlackWhiteBtn.MouseButton1Click:Connect(toggleBlackWhite)
BlurBtn.MouseButton1Click:Connect(toggleBlur)

-- AIMBOT
local AimBtn = createButton(PageAim, "Aim Assist: OFF", Color3.fromRGB(255, 70, 70))

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0.94, 0, 0, 22)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Alvo: nenhum"
TargetLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.TextSize = 14
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = PageAim

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.94, 0, 0, 130)
PlayerList.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = PageAim
Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 10)

local ListLayout = Instance.new("UIListLayout", PlayerList)
ListLayout.Padding = UDim.new(0, 5)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function updateCanvas()
	PlayerList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function selectTarget(plr)
	selectedTarget = plr
	TargetLabel.Text = plr and ("Alvo: " .. plr.DisplayName) or "Alvo: nenhum"
end

local function refreshPlayerList()
	for _, obj in ipairs(PlayerList:GetChildren()) do
		if obj:IsA("TextButton") then obj:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(0.94, 0, 0, 30)
			button.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			button.Text = plr.DisplayName
			button.TextColor3 = Color3.fromRGB(220, 220, 225)
			button.Font = Enum.Font.Gotham
			button.TextSize = 13
			button.AutoButtonColor = false
			button.Parent = PlayerList
			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)

			button.MouseButton1Click:Connect(function()
				selectTarget(plr)
				for _, other in ipairs(PlayerList:GetChildren()) do
					if other:IsA("TextButton") then other.BackgroundColor3 = Color3.fromRGB(28, 28, 36) end
				end
				button.BackgroundColor3 = Color3.fromRGB(120, 40, 50)
			end)
		end
	end
	updateCanvas()
end

refreshPlayerList()
Players.PlayerAdded:Connect(function() task.wait(0.2) refreshPlayerList() end)
Players.PlayerRemoving:Connect(function(plr)
	if selectedTarget == plr then
		selectTarget(nil)
		if aimEnabled then
			aimEnabled = false
			if aimConnection then aimConnection:Disconnect() aimConnection = nil end
			setState(AimBtn, false, "Aim Assist: ON", "Aim Assist: OFF", Color3.fromRGB(200, 50, 50))
		end
	end
	refreshPlayerList()
end)

local function getTargetPart()
	if not selectedTarget then return nil end
	local char = selectedTarget.Character
	if not char then return nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return nil end
	return char:FindFirstChild(aimPart) or char:FindFirstChild("HumanoidRootPart")
end

local function stopAim()
	if aimConnection then aimConnection:Disconnect() aimConnection = nil end
end

local function startAim()
	stopAim()
	aimConnection = RunService.RenderStepped:Connect(function()
		if not aimEnabled or not selectedTarget then return end
		local targetPart = getTargetPart()
		if not targetPart then return end
		local cam = workspace.CurrentCamera
		if (cam.CFrame.Position - targetPart.Position).Magnitude > aimMaxDistance then return end
		local targetCF = CFrame.lookAt(cam.CFrame.Position, targetPart.Position)
		cam.CFrame = cam.CFrame:Lerp(targetCF, aimSmoothness)
	end)
end

local function toggleAim()
	if not selectedTarget then
		TargetLabel.Text = "Alvo: selecione um jogador"
		return
	end
	aimEnabled = not aimEnabled
	if aimEnabled then
		startAim()
		setState(AimBtn, true, "Aim Assist: ON", "Aim Assist: OFF", Color3.fromRGB(200, 50, 50))
	else
		stopAim()
		setState(AimBtn, false, "Aim Assist: ON", "Aim Assist: OFF", Color3.fromRGB(200, 50, 50))
	end
end

AimBtn.MouseButton1Click:Connect(toggleAim)

createSlider(PageAim, "Suavidade", 5, 100, 18, Color3.fromRGB(255, 80, 80), function(v)
	aimSmoothness = v / 100
end)

createSlider(PageAim, "Distância", 50, 5000, 5000, Color3.fromRGB(255, 150, 50), function(v)
	aimMaxDistance = v
end)

-- ANTILAG
local AntiLagBtn = createButton(PageAnti, "Anti-Lag: OFF", Color3.fromRGB(180, 100, 255))

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0.94, 0, 0, 20)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS Cap: Ilimitado"
FPSLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 14
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Parent = PageAnti

local fpsContainer = Instance.new("Frame")
fpsContainer.Size = UDim2.new(0.94, 0, 0, 36)
fpsContainer.BackgroundTransparency = 1
fpsContainer.Parent = PageAnti

local fpsButtons = {}
local fpsOptions = {{"30",30},{"60",60},{"120",120},{"∞",0}}

local function setFPS(value)
	currentFPS = value
	playClickSound()
	FPSLabel.Text = value == 0 and "FPS Cap: Ilimitado" or ("FPS Cap: " .. value)
	pcall(function() if setfpscap then setfpscap(value == 0 and 999 or value) end end)

	for _, data in ipairs(fpsButtons) do
		data.btn.BackgroundColor3 = data.value == value and Color3.fromRGB(0, 130, 180) or Color3.fromRGB(28, 28, 36)
		data.btn.TextColor3 = data.value == value and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,210)
	end
end

for i, opt in ipairs(fpsOptions) do
	local btn = Instance.new("TextButton", fpsContainer)
	btn.Size = UDim2.new(0.23, 0, 1, 0)
	btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	btn.Text = opt[1]
	btn.TextColor3 = Color3.fromRGB(200, 200, 210)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(function() setFPS(opt[2]) end)
	table.insert(fpsButtons, {btn = btn, value = opt[2]})
end
setFPS(0)

local AntiInfo = Instance.new("TextLabel")
AntiInfo.Size = UDim2.new(0.94, 0, 0, 70)
AntiInfo.BackgroundTransparency = 1
AntiInfo.Text = "Anti-Lag otimizado:\n• Qualidade baixa\n• Remove sombras e névoa\n• Desativa partículas (1x)"
AntiInfo.TextColor3 = Color3.fromRGB(140, 140, 155)
AntiInfo.Font = Enum.Font.Gotham
AntiInfo.TextSize = 12
AntiInfo.TextYAlignment = Enum.TextYAlignment.Top
AntiInfo.Parent = PageAnti

-- GRAVITY
local GravityToggleBtn = createButton(PageGravity, "Gravidade: OFF", Color3.fromRGB(0, 200, 255))

createSlider(PageGravity, "Gravidade FORA do carro", 0, 300, 196, Color3.fromRGB(0, 200, 255), function(val)
	gravityOutside = val
end)

createSlider(PageGravity, "Gravidade DENTRO do carro", 0, 300, 196, Color3.fromRGB(0, 180, 140), function(val)
	gravityInside = val
end)

local GravInfo = Instance.new("TextLabel")
GravInfo.Size = UDim2.new(0.94, 0, 0, 60)
GravInfo.BackgroundTransparency = 1
GravInfo.Text = "Ative o botão acima para usar.\nPulo funciona mesmo em Gravidade 0."
GravInfo.TextColor3 = Color3.fromRGB(140, 140, 155)
GravInfo.Font = Enum.Font.Gotham
GravInfo.TextSize = 12
GravInfo.TextYAlignment = Enum.TextYAlignment.Top
GravInfo.Parent = PageGravity

local function toggleGravity()
	gravityEnabled = not gravityEnabled
	playClickSound()
	if gravityEnabled then
		setState(GravityToggleBtn, true, "Gravidade: ON", "Gravidade: OFF", Color3.fromRGB(0, 160, 200))
	else
		workspace.Gravity = 196.2
		setState(GravityToggleBtn, false, "Gravidade: ON", "Gravidade: OFF", Color3.fromRGB(0, 160, 200))
	end
end
GravityToggleBtn.MouseButton1Click:Connect(toggleGravity)

-- FOV
local FOVToggleBtn = createButton(PageFOV, "FOV: OFF", Color3.fromRGB(255, 140, 50))

createSlider(PageFOV, "FOV (Campo de Visão)", 40, 120, 70, Color3.fromRGB(255, 140, 50), function(val)
	currentFOV = val
	if fovEnabled then
		pcall(function() workspace.CurrentCamera.FieldOfView = val end)
	end
end)

local FOVInfo = Instance.new("TextLabel")
FOVInfo.Size = UDim2.new(0.94, 0, 0, 50)
FOVInfo.BackgroundTransparency = 1
FOVInfo.Text = "Ative o botão acima para usar o FOV."
FOVInfo.TextColor3 = Color3.fromRGB(140, 140, 155)
FOVInfo.Font = Enum.Font.Gotham
FOVInfo.TextSize = 12
FOVInfo.TextYAlignment = Enum.TextYAlignment.Top
FOVInfo.Parent = PageFOV

local function toggleFOV()
	fovEnabled = not fovEnabled
	playClickSound()
	if fovEnabled then
		pcall(function() workspace.CurrentCamera.FieldOfView = currentFOV end)
		setState(FOVToggleBtn, true, "FOV: ON", "FOV: OFF", Color3.fromRGB(220, 120, 30))
	else
		pcall(function() workspace.CurrentCamera.FieldOfView = 70 end)
		setState(FOVToggleBtn, false, "FOV: ON", "FOV: OFF", Color3.fromRGB(220, 120, 30))
	end
end
FOVToggleBtn.MouseButton1Click:Connect(toggleFOV)

-- =========================================================
-- ====================== FUNÇÕES ==========================
-- =========================================================

local function toggleLights()
	lightsEnabled = not lightsEnabled
	playClickSound()
	if lightsEnabled then
		setState(LightsBtn, true, "Farol + Setas: ON", "Farol + Setas: OFF", Color3.fromRGB(220, 180, 30))
	else
		setState(LightsBtn, false, "Farol + Setas: ON", "Farol + Setas: OFF", Color3.fromRGB(220, 180, 30))
	end
end

local function toggleFly()
	if freecam then return end
	flying = not flying
	if flying then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.Parent = rootPart
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyGyro.P = 9000
		bodyGyro.Parent = rootPart
		humanoid.PlatformStand = true
		flyConnection = RunService.RenderStepped:Connect(function()
			if not flying or not rootPart then return end
			local cam = workspace.CurrentCamera
			local move = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
			if move.Magnitude > 0 then move = move.Unit * flySpeed end
			bodyVelocity.Velocity = move
			bodyGyro.CFrame = cam.CFrame
		end)
		setState(FlyBtn, true, "Fly: ON", "Fly: OFF", Color3.fromRGB(0, 140, 200))
	else
		if flyConnection then flyConnection:Disconnect() flyConnection = nil end
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
		if humanoid then humanoid.PlatformStand = false end
		setState(FlyBtn, false, "Fly: ON", "Fly: OFF", Color3.fromRGB(0, 140, 200))
	end
end

local function toggleNoclip()
	noclip = not noclip
	setState(NoclipBtn, noclip, "Noclip: ON", "Noclip: OFF", Color3.fromRGB(0, 160, 100))
end

RunService.Stepped:Connect(function()
	if (noclip or freecam) and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

local espConnections = {}
local function createESP(plr)
	if plr == player then return end
	local function apply(char)
		if not espEnabled or not char then return end
		local old = char:FindFirstChild("AdminHighlight")
		if old then old:Destroy() end
		local h = Instance.new("Highlight")
		h.Name = "AdminHighlight"
		h.FillColor = Color3.fromRGB(255, 50, 50)
		h.OutlineColor = Color3.fromRGB(255, 255, 255)
		h.FillTransparency = 0.55
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Parent = char
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			local b = Instance.new("BillboardGui")
			b.Name = "AdminName"
			b.Size = UDim2.new(0, 200, 0, 40)
			b.StudsOffset = Vector3.new(0, 3.3, 0)
			b.AlwaysOnTop = true
			b.Parent = root
			local t = Instance.new("TextLabel", b)
			t.Size = UDim2.new(1, 0, 1, 0)
			t.BackgroundTransparency = 1
			t.Text = plr.Name
			t.TextColor3 = Color3.new(1,1,1)
			t.TextStrokeTransparency = 0.4
			t.Font = Enum.Font.GothamBold
			t.TextSize = 15
		end
	end
	if plr.Character then apply(plr.Character) end
	if not espConnections[plr] then
		espConnections[plr] = plr.CharacterAdded:Connect(apply)
	end
end

local function clearESP()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj.Name == "AdminHighlight" or obj.Name == "AdminName" then obj:Destroy() end
	end
	for plr, conn in pairs(espConnections) do
		if conn then conn:Disconnect() end
		espConnections[plr] = nil
	end
end

local function toggleESP()
	espEnabled = not espEnabled
	if espEnabled then
		for _, plr in pairs(Players:GetPlayers()) do createESP(plr) end
		setState(ESPBtn, true, "ESP: ON", "ESP: OFF", Color3.fromRGB(180, 40, 40))
	else
		clearESP()
		setState(ESPBtn, false, "ESP: ON", "ESP: OFF", Color3.fromRGB(180, 40, 40))
	end
end

local function toggleAntiLag()
	antiLagEnabled = not antiLagEnabled
	if antiLagEnabled then
		pcall(function() UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
		task.spawn(function()
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
					pcall(function() obj.Enabled = false end)
				end
			end
		end)
		setState(AntiLagBtn, true, "Anti-Lag: ON", "Anti-Lag: OFF", Color3.fromRGB(140, 70, 200))
	else
		pcall(function() UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic end)
		Lighting.GlobalShadows = originalLighting.GlobalShadows
		Lighting.FogEnd = originalLighting.FogEnd
		Lighting.FogStart = originalLighting.FogStart
		setState(AntiLagBtn, false, "Anti-Lag: ON", "Anti-Lag: OFF", Color3.fromRGB(140, 70, 200))
	end
end

local function setInvisible(state)
	if not character then return end
	for _, obj in pairs(character:GetDescendants()) do
		if obj:IsA("BasePart") then
			if state then
				originalTransparencies[obj] = obj.Transparency
				originalCanCollide[obj] = obj.CanCollide
				obj.Transparency = 1
				obj.CanCollide = false
			else
				if originalTransparencies[obj] then obj.Transparency = originalTransparencies[obj] end
				if originalCanCollide[obj] then obj.CanCollide = originalCanCollide[obj] end
			end
		elseif obj:IsA("Decal") then
			if state then
				originalTransparencies[obj] = obj.Transparency
				obj.Transparency = 1
			else
				if originalTransparencies[obj] then obj.Transparency = originalTransparencies[obj] end
			end
		end
	end
	if not state then
		originalTransparencies = {}
		originalCanCollide = {}
	end
end

local function forcarCameraNormal()
	pcall(function()
		camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Custom
		if humanoid then camera.CameraSubject = humanoid end
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end)
end

local function toggleFreeCam()
	freecam = not freecam
	if freecam then
		if flying then toggleFly() end
		camera.CameraType = Enum.CameraType.Scriptable
		setInvisible(true)
		if rootPart then rootPart.Anchored = true end
		if humanoid then humanoid.PlatformStand = true humanoid.AutoRotate = false end
		local camCF = camera.CFrame
		local yaw = math.atan2(-camCF.LookVector.X, -camCF.LookVector.Z)
		local pitch = math.asin(math.clamp(camCF.LookVector.Y, -1, 1))
		freecamConnection = RunService.RenderStepped:Connect(function(dt)
			if not freecam then return end
			local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 120 or 55
			local move = Vector3.zero
			local rotCF = CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += rotCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= rotCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= rotCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += rotCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.E) then move += Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move -= Vector3.new(0,1,0) end
			if move.Magnitude > 0 then camCF = camCF + move.Unit * speed * dt end
			if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
				local delta = UserInputService:GetMouseDelta()
				yaw = yaw - delta.X * 0.004
				pitch = math.clamp(pitch - delta.Y * 0.004, -1.4, 1.4)
			else
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end
			camera.CFrame = CFrame.new(camCF.Position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
			camCF = camera.CFrame
		end)
		setState(FreeCamBtn, true, "FreeCam: ON", "FreeCam: OFF", Color3.fromRGB(200, 110, 30))
	else
		if freecamConnection then freecamConnection:Disconnect() freecamConnection = nil end
		setInvisible(false)
		if rootPart then rootPart.Anchored = false end
		if humanoid then humanoid.PlatformStand = false humanoid.AutoRotate = true end
		forcarCameraNormal()
		task.delay(0.05, forcarCameraNormal)
		setState(FreeCamBtn, false, "FreeCam: ON", "FreeCam: OFF", Color3.fromRGB(200, 110, 30))
	end
end

-- ====================== SISTEMA DE GRAVIDADE ======================
RunService.Heartbeat:Connect(function()
	if not gravityEnabled then return end
	if not humanoid or not humanoid.Parent then return end
	if humanoid.Sit and humanoid.SeatPart then
		workspace.Gravity = gravityInside
	else
		workspace.Gravity = gravityOutside
	end
end)

-- ====================== SISTEMA DE FAROL + SETAS ======================
RunService.Heartbeat:Connect(function()
	if not lightsEnabled then return end
	if not humanoid or not humanoid.Parent then return end
	if not humanoid.Sit or not humanoid.SeatPart then return end

	local vehicle = humanoid.SeatPart:FindFirstAncestorOfClass("Model") or humanoid.SeatPart.Parent
	if not vehicle then return end

	for _, obj in pairs(vehicle:GetDescendants()) do
		if obj:IsA("SpotLight") or obj:IsA("SurfaceLight") or obj:IsA("PointLight") then
			obj.Enabled = true
		end

		local name = obj.Name:lower()
		if obj:IsA("BasePart") then
			if name:find("farol") or name:find("headlight") or name:find("light") or name:find("seta") or name:find("blink") or name:find("signal") or name:find("indicator") then
				if obj.Material == Enum.Material.Neon then
					obj.Transparency = 0
				end
			end
		end
	end
end)

-- ====================== PULO CUSTOMIZADO ======================
UserInputService.JumpRequest:Connect(function()
	if not gravityEnabled then return end
	if not humanoid or not rootPart or not humanoid.Parent then return end
	if flying or freecam then return end
	if workspace.Gravity > 5 then return end
	rootPart.AssemblyLinearVelocity = Vector3.new(
		rootPart.AssemblyLinearVelocity.X,
		58,
		rootPart.AssemblyLinearVelocity.Z
	)
end)

-- Conexões
FlyBtn.MouseButton1Click:Connect(toggleFly)
NoclipBtn.MouseButton1Click:Connect(toggleNoclip)
ESPBtn.MouseButton1Click:Connect(toggleESP)
FreeCamBtn.MouseButton1Click:Connect(toggleFreeCam)
LightsBtn.MouseButton1Click:Connect(toggleLights)
AntiLagBtn.MouseButton1Click:Connect(toggleAntiLag)
CloseBtn.MouseButton1Click:Connect(closeHub)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == TECLA_HUB then toggleHub() return end
	if input.UserInputType == Enum.UserInputType.Touch then
		local now = tick()
		if now - lastTapTime <= TAP_WINDOW then tapCount += 1 else tapCount = 1 end
		lastTapTime = now
		if tapCount >= 3 then toggleHub() tapCount = 0 end
	end
end)

player.CharacterAdded:Connect(function()
	if freecam then freecam = false if freecamConnection then freecamConnection:Disconnect() freecamConnection = nil end end
	if flying then
		flying = false
		if flyConnection then flyConnection:Disconnect() flyConnection = nil end
		if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
		if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	end
	task.wait(0.3)
	getChar()
	forcarCameraNormal()
	if humanoid then humanoid.WalkSpeed = walkSpeed end
	setState(FreeCamBtn, false, "FreeCam: ON", "FreeCam: OFF", Color3.fromRGB(200, 110, 30))
	setState(FlyBtn, false, "Fly: ON", "Fly: OFF", Color3.fromRGB(0, 140, 200))
end)

if humanoid then humanoid.WalkSpeed = walkSpeed end

task.delay(2.8, function()
	loadingFinished = true
	if dotsConnection then dotsConnection:Disconnect() end
	local fade = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(LoadingFrame, fade, {BackgroundTransparency = 1}):Play()
	TweenService:Create(LoadingTitle, fade, {TextTransparency = 1}):Play()
	TweenService:Create(LoadingSub, fade, {TextTransparency = 1}):Play()
	TweenService:Create(LoadingDots, fade, {TextTransparency = 1}):Play()
	TweenService:Create(ProgressBG, fade, {BackgroundTransparency = 1}):Play()
	TweenService:Create(ProgressFill, fade, {BackgroundTransparency = 1}):Play()
	TweenService:Create(LoadingPercent, fade, {TextTransparency = 1}):Play()
	task.wait(0.6)
	LoadingFrame:Destroy()
	Main.Visible = true
end)

print("✅ Neon Lighting's (NL) | Farol + Setas adicionado")
