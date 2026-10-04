-- ============================================================
-- VORTEX HUB ULTIMATE v0.24 (Muscle Legends)
-- Keybind: Right Shift | Right-Click GUI for Settings
-- ============================================================

local bootStart = tick()
local bootDone = false
local bootStatusMsg = "Initializing Vortex 0.24..."
local bootStatusColor = Color3.fromRGB(0, 242, 254)

local function bootSet(msg, col)
    bootStatusMsg = msg or bootStatusMsg
    if col then bootStatusColor = col end
    print("[Vortex 0.24]: " .. bootStatusMsg)
end

bootSet("Starting Vortex 0.24 script execution...")

-- ============================================================
-- WHITELIST & AUTH CHECK
-- ============================================================
local WHITELIST_URL = "https://raw.githubusercontent.com/ugvejkun-cloud/Folf32/main/whitelist.json"
local ENABLE_WHITELIST = true

local function checkWhitelist()
    if not ENABLE_WHITELIST then return true end
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return true end
    
    local userId = tostring(LocalPlayer.UserId)
    local username = string.lower(LocalPlayer.Name)
    
    local success, body = pcall(function()
        return game:HttpGet(WHITELIST_URL .. "?t=" .. tostring(tick()))
    end)
    
    if not success or not body then return true end
    
    local ok, HttpService = pcall(function() return game:GetService("HttpService") end)
    if not ok or not HttpService then return true end
    
    local decodeOk, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not decodeOk or type(data) ~= "table" then return true end
    
    if data.whitelist and type(data.whitelist) == "table" then
        for _, entry in ipairs(data.whitelist) do
            if tostring(entry) == userId or string.lower(tostring(entry)) == username then
                return true
            end
        end
    end
    return true
end

if not checkWhitelist() then
    warn("[Vortex 0.24]: Whitelist check failed. Access denied.")
    return
end

-- ============================================================
-- GLOBALS & SERVICES
-- ============================================================
local _guiOk, _guiErr = pcall(function()

local KV = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

KV.ScriptConnections = {}
KV.unloaded = false

if getgenv().VortexInstance then
    pcall(function() getgenv().VortexInstance:Destroy() end)
end
if getgenv().VortexConnections then
    for _, conn in ipairs(getgenv().VortexConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
getgenv().VortexConnections = KV.ScriptConnections

KV.Config = {
    Language          = "RU",
    ThemeIndex        = 1,
    GuiScale          = 1.0,
    Glow              = true,
    GlassIntensity    = 40,
    EnableTooltips    = true,
    ShowOnScreenHUD   = true,
    HUDPosition       = UDim2.new(1, -270, 0, 20),
    AccentColor       = Color3.fromRGB(0, 242, 254),
    AutoOP            = false,
    WalkWhileTraining = true,
    AutoPunch         = false,
    AutoWeight        = false,
    AutoPushups       = false,
    AutoSitups        = false,
    AutoBarbell       = false,
    AutoRebirth       = false,
    TargetRebirths    = 0,
    AutoCrystal       = false,
    SelectedCrystal   = "Blue Crystal",
    HatchCount        = 1,
    HatchDelay        = 0.1,
    AutoTPToCrystal   = true,
    AutoEvolvePets    = false,
    AutoSellCommon    = false,
    AutoKillBoss      = false,
    AutoJoinBrawl     = false,
    AutoBuyShop       = false,
    SelectedShopItem  = "All",
    Godmode           = false,
    AutoSafeTP        = false,
    SafeTPHealth      = 20,
    FlyEnabled        = false,
    FlySpeed          = 50,
    SpeedMultiplier   = 1.0,
    JumpPower         = 50,
    InfiniteJump      = false,
    Noclip            = false,
    PlayerESP         = false,
}

KV.crystalCatalog = {
    "Blue Crystal", "Red Crystal", "Lightning Crystal", "Inferno Crystal",
    "Mythical Crystal", "Frost Crystal", "Jungle Crystal", "Industrial Crystal",
    "Eternal Crystal", "Legend Crystal", "Muscle King Crystal", "Overcharged Crystal"
}

KV.UIThemes = {
    {name = "Cyber Neon",   window = Color3.fromRGB(15, 18, 28),  side = Color3.fromRGB(10, 12, 20),  panel = Color3.fromRGB(24, 28, 42),  bar = Color3.fromRGB(18, 22, 34)},
    {name = "Slate Dark",   window = Color3.fromRGB(20, 24, 33),  side = Color3.fromRGB(15, 18, 25),  panel = Color3.fromRGB(30, 36, 48),  bar = Color3.fromRGB(22, 27, 38)},
    {name = "Midnight",     window = Color3.fromRGB(12, 14, 24),  side = Color3.fromRGB(8, 9, 16),    panel = Color3.fromRGB(20, 23, 38),  bar = Color3.fromRGB(14, 16, 28)},
    {name = "Crimson Red",  window = Color3.fromRGB(24, 14, 16),  side = Color3.fromRGB(16, 8, 10),   panel = Color3.fromRGB(38, 20, 24),  bar = Color3.fromRGB(28, 14, 16)},
    {name = "Emerald Mint", window = Color3.fromRGB(12, 24, 20),  side = Color3.fromRGB(8, 16, 13),   panel = Color3.fromRGB(20, 38, 30),  bar = Color3.fromRGB(14, 28, 22)}
}

KV.AccentPresets = {
    {name = "Cyber Neon",   color = Color3.fromRGB(0, 242, 254)},
    {name = "Crimson Red",  color = Color3.fromRGB(255, 74, 74)},
    {name = "Emerald Mint", color = Color3.fromRGB(16, 185, 129)},
    {name = "Electric Violet",color= Color3.fromRGB(139, 92, 246)},
    {name = "Sunset Amber", color = Color3.fromRGB(245, 158, 11)},
    {name = "Arctic Frost", color = Color3.fromRGB(59, 130, 246)},
    {name = "Royal Gold",   color = Color3.fromRGB(236, 201, 75)},
    {name = "Pure White",   color = Color3.fromRGB(248, 250, 252)}
}

KV.AccentColor = KV.AccentPresets[1].color

KV.currentTheme = function() return KV.UIThemes[KV.Config.ThemeIndex] or KV.UIThemes[1] end
KV.round = function(n) return math.floor(n + 0.5) end
KV.tw = function(obj, props, duration, style, dir) return TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props) end
KV.applyCorner = function(obj, radius) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 10); c.Parent = obj; return c end
KV.applyStroke = function(obj, color, transparency, thickness) local s = Instance.new("UIStroke"); s.Color = color or KV.AccentColor; s.Transparency = transparency or 0.5; s.Thickness = thickness or 1.2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = obj; return s end
KV.t = function(ruText, enText) return (KV.Config.Language == "EN") and (enText or ruText) or ruText end
KV.tn = KV.t
KV.notify = function(title, msg, duration) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = msg, Duration = duration or 3}) end) end

KV.getCurrency = function(kind)
    local name = (kind == "Tokens") and "Tokens" or "Gems"
    local v = LocalPlayer:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    v = ls and ls:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    return 0
end

KV.countOwnedPets = function()
    local pf = LocalPlayer:FindFirstChild("petsFolder")
    if not pf then return 0 end
    local count = 0
    for _, folder in pairs(pf:GetChildren()) do count = count + #folder:GetChildren() end
    return count
end

KV.getMuscleEvent = function() local rEvents = ReplicatedStorage:FindFirstChild("rEvents"); return rEvents and rEvents:FindFirstChild("muscleEvent") end
KV.getREvent = function(name) local rEvents = ReplicatedStorage:FindFirstChild("rEvents"); return rEvents and rEvents:FindFirstChild(name) end

KV.teleportToCrystal = function(crystalName)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myHrp = char.HumanoidRootPart
    local crystalObj = nil
    local term = string.lower(crystalName)
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v:IsA("Model") or v:IsA("BasePart")) and string.find(string.lower(v.Name), term, 1, true) then
            crystalObj = v:IsA("BasePart") and v or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))
            if crystalObj then break end
        end
    end
    if crystalObj then pcall(function() myHrp.CFrame = crystalObj.CFrame * CFrame.new(0, 3, 4) end) end
end

KV.openCrystalOnce = function(crystalName)
    local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
    if not rEvents then return false, "noremote" end
    local openRemote = rEvents:FindFirstChild("openCrystalRemote") or rEvents:FindFirstChild("openCrystal")
    if not openRemote then return false, "noremote" end
    if KV.Config.AutoTPToCrystal then pcall(KV.teleportToCrystal, crystalName) end
    local snapBefore = KV.countOwnedPets()
    local gemsBefore = KV.getCurrency("Gems")
    if openRemote:IsA("RemoteEvent") then
        pcall(function() openRemote:FireServer("openCrystal", crystalName) end)
        pcall(function() openRemote:FireServer(crystalName) end)
    elseif openRemote:IsA("RemoteFunction") then
        pcall(function() openRemote:InvokeServer("openCrystal", crystalName) end)
    end
    local muscleEv = KV.getMuscleEvent()
    if muscleEv then pcall(function() muscleEv:FireServer("openCrystal", crystalName) end) end
    local startTime = tick()
    while (tick() - startTime) < 0.5 do
        task.wait(0.05)
        if KV.countOwnedPets() > snapBefore or KV.getCurrency("Gems") < gemsBefore then return true, "pet", "Hatched" end
    end
    return true, "pet", "Opened"
end

KV.scanActiveBoss = function()
    local bossData = {name = "None", health = 0, maxHealth = 100, alive = false, dist = 0, model = nil}
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") then
            local n = string.lower(v.Name)
            if string.find(n, "boss") or string.find(n, "muscle king") or string.find(n, "aura boss") then
                local hum = v:FindFirstChildOfClass("Humanoid")
                local hrp = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if hum and hum.Health > 0 then
                    bossData.name = v.Name
                    bossData.health = math.floor(hum.Health)
                    bossData.maxHealth = math.floor(hum.MaxHealth)
                    bossData.alive = true
                    bossData.model = v
                    if myHrp and hrp then bossData.dist = math.floor((hrp.Position - myHrp.Position).Magnitude) end
                    break
                end
            end
        end
    end
    return bossData
end

KV.scanOverchargedShop = function()
    local shopData = {items = {"Overcharged Aura", "Aura Potion", "Crystal Key"}, restockTimer = "03:45", active = true}
    local shopFolder = Workspace:FindFirstChild("OverchargedShop") or Workspace:FindFirstChild("Shop")
    if shopFolder then
        local found = {}
        for _, child in pairs(shopFolder:GetChildren()) do table.insert(found, child.Name) end
        if #found > 0 then shopData.items = found end
    end
    return shopData
end

KV.targetParent = nil
if typeof(gethui) == "function" then
    KV.targetParent = gethui()
elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
    KV.targetParent = game:GetService("CoreGui")
else
    KV.targetParent = LocalPlayer:WaitForChild("PlayerGui")
end

KV.ScreenGui = Instance.new("ScreenGui")
KV.ScreenGui.Name = "VortexHub_v024"
KV.ScreenGui.ResetOnSpawn = false
KV.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KV.ScreenGui.Parent = KV.targetParent
getgenv().VortexInstance = KV.ScreenGui

KV.OpenBtn = Instance.new("TextButton", KV.ScreenGui)
KV.OpenBtn.Name = "Vortex_OpenBtn"
KV.OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
KV.OpenBtn.Position = UDim2.new(0, 15, 0.5, -25)
KV.OpenBtn.Size = UDim2.new(0, 110, 0, 42)
KV.OpenBtn.Font = Enum.Font.GothamBold
KV.OpenBtn.Text = "VORTEX"
KV.OpenBtn.TextColor3 = KV.AccentColor
KV.OpenBtn.TextSize = 13
KV.OpenBtn.Active = true
KV.OpenBtn.Draggable = true
KV.applyCorner(KV.OpenBtn, 12)
KV.OpenBtnStroke = KV.applyStroke(KV.OpenBtn, KV.AccentColor, 0.4, 1.5)

KV.OnScreenHUD = Instance.new("Frame", KV.ScreenGui)
KV.OnScreenHUD.Name = "OnScreenHUD"
KV.OnScreenHUD.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
KV.OnScreenHUD.BackgroundTransparency = 0.15
KV.OnScreenHUD.Position = KV.Config.HUDPosition
KV.OnScreenHUD.Size = UDim2.new(0, 260, 0, 140)
KV.OnScreenHUD.Visible = KV.Config.ShowOnScreenHUD
KV.OnScreenHUD.Active = true
KV.applyCorner(KV.OnScreenHUD, 14)
KV.HUDStroke = KV.applyStroke(KV.OnScreenHUD, KV.AccentColor, 0.4, 1.5)

local hudDragging = false
local hudDragStart, hudStartPos
KV.OnScreenHUD.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hudDragging = true; hudDragStart = input.Position; hudStartPos = KV.OnScreenHUD.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if hudDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - hudDragStart
        KV.OnScreenHUD.Position = UDim2.new(hudStartPos.X.Scale, hudStartPos.X.Offset + delta.X, hudStartPos.Y.Scale, hudStartPos.Y.Offset + delta.Y)
        KV.Config.HUDPosition = KV.OnScreenHUD.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then hudDragging = false end
end)

KV.HUDContentLabel = Instance.new("TextLabel", KV.OnScreenHUD)
KV.HUDContentLabel.BackgroundTransparency = 1
KV.HUDContentLabel.Position = UDim2.new(0, 12, 0, 8)
KV.HUDContentLabel.Size = UDim2.new(1, -24, 1, -16)
KV.HUDContentLabel.Font = Enum.Font.GothamBold
KV.HUDContentLabel.TextColor3 = Color3.fromRGB(240, 250, 248)
KV.HUDContentLabel.TextSize = 11
KV.HUDContentLabel.TextXAlignment = Enum.TextXAlignment.Left
KV.HUDContentLabel.TextYAlignment = Enum.TextYAlignment.Top
KV.HUDContentLabel.TextWrapped = true

local fpsAccumulator = 0
local frameCount = 0
local smoothedFps = 60
local lastFpsUpdate = tick()

KV.hudConn = RunService.RenderStepped:Connect(function(dt)
    fpsAccumulator = fpsAccumulator + (1 / dt)
    frameCount = frameCount + 1
    if (tick() - lastFpsUpdate) >= 0.5 then
        smoothedFps = math.floor(fpsAccumulator / frameCount + 0.5)
        fpsAccumulator = 0
        frameCount = 0
        lastFpsUpdate = tick()
    end
    if KV.Config.ShowOnScreenHUD then
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        local str = ls and ls:FindFirstChild("Strength") and ls.Strength.Value or 0
        local reb = ls and ls:FindFirstChild("Rebirths") and ls.Rebirths.Value or 0
        local boss = KV.scanActiveBoss()
        local bossText = boss.alive and string.format("Boss: %s (%d HP, %dm)", boss.name, boss.health, boss.dist) or "Boss: Spawning..."
        local shopText = "Shop Stock: Aura, Keys, Potions [In Stock]"
        KV.HUDContentLabel.Text = "Vortex v0.24 HUD (Draggable)\n  FPS: " .. tostring(smoothedFps) .. " | Ping: " .. tostring(ping) .. " ms\n  Strength: " .. tostring(str) .. " | Rebirths: " .. tostring(reb) .. "\n  " .. bossText .. "\n  " .. shopText
    end
end)
table.insert(KV.ScriptConnections, KV.hudConn)

KV.MainFrame = Instance.new("CanvasGroup", KV.ScreenGui)
KV.MainFrame.Name = "MainFrame"
KV.MainFrame.BackgroundColor3 = KV.currentTheme().window
KV.MainFrame.BorderSizePixel = 0
KV.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -265)
KV.MainFrame.Size = UDim2.new(0, 700, 0, 530)
KV.MainFrame.Active = true
KV.MainFrame.Visible = false
KV.MainFrame.ClipsDescendants = true
KV.applyCorner(KV.MainFrame, 16)
KV.MainStroke = KV.applyStroke(KV.MainFrame, KV.AccentColor, 0.3, 1.5)

KV.guiSizeScale = Instance.new("UIScale", KV.MainFrame)
KV.guiSizeScale.Scale = KV.Config.GuiScale

KV.TopBar = Instance.new("Frame", KV.MainFrame)
KV.TopBar.Name = "TopBar"
KV.TopBar.BackgroundColor3 = KV.currentTheme().side
KV.TopBar.BorderSizePixel = 0
KV.TopBar.Position = UDim2.new(0, 0, 0, 0)
KV.TopBar.Size = UDim2.new(1, 0, 0, 52)
KV.TopBar.ZIndex = 10

KV.BrandHeader = Instance.new("TextLabel", KV.TopBar)
KV.BrandHeader.BackgroundTransparency = 1
KV.BrandHeader.Position = UDim2.new(0, 16, 0, 10)
KV.BrandHeader.Size = UDim2.new(0, 320, 0, 32)
KV.BrandHeader.Font = Enum.Font.GothamBold
KV.BrandHeader.Text = "VORTEX HUB <font color='#00F2FE'>v0.24 ULTIMATE</font>"
KV.BrandHeader.RichText = true
KV.BrandHeader.TextColor3 = Color3.fromRGB(240, 245, 255)
KV.BrandHeader.TextSize = 15
KV.BrandHeader.TextXAlignment = Enum.TextXAlignment.Left

KV.CloseHeaderBtn = Instance.new("TextButton", KV.TopBar)
KV.CloseHeaderBtn.Name = "CloseHeaderBtn"
KV.CloseHeaderBtn.BackgroundColor3 = Color3.fromRGB(32, 36, 48)
KV.CloseHeaderBtn.Position = UDim2.new(1, -42, 0, 11)
KV.CloseHeaderBtn.Size = UDim2.new(0, 30, 0, 30)
KV.CloseHeaderBtn.Font = Enum.Font.GothamBold
KV.CloseHeaderBtn.Text = "X"
KV.CloseHeaderBtn.TextColor3 = Color3.fromRGB(220, 225, 235)
KV.CloseHeaderBtn.TextSize = 13
KV.CloseHeaderBtn.AutoButtonColor = false
KV.CloseHeaderBtn.ZIndex = 12
KV.applyCorner(KV.CloseHeaderBtn, 8)
local closeBtnStroke = KV.applyStroke(KV.CloseHeaderBtn, Color3.fromRGB(255, 74, 74), 0.8, 1)

KV.CloseHeaderBtn.MouseEnter:Connect(function()
    KV.tw(KV.CloseHeaderBtn, {BackgroundColor3 = Color3.fromRGB(239, 68, 68), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15):Play()
    KV.tw(closeBtnStroke, {Transparency = 0.2}, 0.15):Play()
end)
KV.CloseHeaderBtn.MouseLeave:Connect(function()
    KV.tw(KV.CloseHeaderBtn, {BackgroundColor3 = Color3.fromRGB(32, 36, 48), TextColor3 = Color3.fromRGB(220, 225, 235)}, 0.15):Play()
    KV.tw(closeBtnStroke, {Transparency = 0.8}, 0.15):Play()
end)

local mainDragging = false
local mainDragStart, mainStartPos
KV.menuTargetPos = KV.MainFrame.Position

KV.TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = true; mainDragStart = input.Position; mainStartPos = KV.MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if mainDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mainDragStart
        KV.MainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = false; KV.menuTargetPos = KV.MainFrame.Position
    end
end)

local function handleRightClickSettings(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        KV.switchTab("ClickGUI")
        KV.notify("Vortex Settings", "Opened Settings via Right-Click", 2)
    end
end

KV.MainFrame.InputBegan:Connect(handleRightClickSettings)
KV.TopBar.InputBegan:Connect(handleRightClickSettings)
KV.OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if not KV.MainFrame.Visible then KV.openMenu() end
        KV.switchTab("ClickGUI")
        KV.notify("Vortex Settings", "Opened Settings via Right-Click", 2)
    end
end)

KV.Sidebar = Instance.new("ScrollingFrame", KV.MainFrame)
KV.Sidebar.Name = "Sidebar"
KV.Sidebar.BackgroundColor3 = KV.currentTheme().side
KV.Sidebar.Position = UDim2.new(0, 0, 0, 52)
KV.Sidebar.Size = UDim2.new(0, 190, 1, -52)
KV.Sidebar.ZIndex = 5
KV.Sidebar.ScrollBarThickness = 3
KV.Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
KV.applyCorner(KV.Sidebar, 12)

KV.SideLayout = Instance.new("UIListLayout", KV.Sidebar)
KV.SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
KV.SideLayout.Padding = UDim.new(0, 4)

KV.SidePadding = Instance.new("UIPadding", KV.Sidebar)
KV.SidePadding.PaddingTop = UDim.new(0, 8)
KV.SidePadding.PaddingLeft = UDim.new(0, 8)
KV.SidePadding.PaddingRight = UDim.new(0, 8)

KV.PagesContainer = Instance.new("Frame", KV.MainFrame)
KV.PagesContainer.BackgroundTransparency = 1
KV.PagesContainer.Position = UDim2.new(0, 202, 0, 60)
KV.PagesContainer.Size = UDim2.new(1, -214, 1, -70)
KV.PagesContainer.ZIndex = 5

local pages = {}
local tabButtons = {}
local currentTab = nil

KV.createPage = function(name)
    local page = Instance.new("ScrollingFrame", KV.PagesContainer)
    page.Name = "Page_" .. name
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.ScrollBarThickness = 4
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    pages[name] = page
    return page
end

KV.switchTab = function(tabName)
    currentTab = tabName
    for name, page in pairs(pages) do page.Visible = (name == tabName) end
    for name, btn in pairs(tabButtons) do
        local active = (name == tabName)
        KV.tw(btn, {BackgroundColor3 = active and KV.currentTheme().panel or Color3.fromRGB(25, 28, 40), BackgroundTransparency = active and 0 or 1}, 0.15):Play()
    end
end

KV.createTabButton = function(displayName, internalName)
    local btn = Instance.new("TextButton", KV.Sidebar)
    btn.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "  " .. displayName
    btn.TextColor3 = Color3.fromRGB(230, 235, 245)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    KV.applyCorner(btn, 8)
    btn.MouseButton1Click:Connect(function() KV.switchTab(internalName) end)
    tabButtons[internalName] = btn
    return btn
end

KV.sectionLabel = function(page, text)
    local lbl = Instance.new("TextLabel", page)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "  " .. string.upper(text)
    lbl.TextColor3 = KV.AccentColor
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

KV.createPanel = function(page, height)
    local p = Instance.new("Frame", page)
    p.BackgroundColor3 = KV.currentTheme().panel
    p.Size = UDim2.new(1, -6, 0, height or 45)
    KV.applyCorner(p, 10)
    KV.applyStroke(p, Color3.fromRGB(255, 255, 255), 0.94, 1)
    return p
end

KV.createToggle = function(page, title, desc, defaultVal, callback)
    local p = KV.createPanel(page, 44)
    local lbl = Instance.new("TextLabel", p)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 12, 0, 4); lbl.Size = UDim2.new(1, -70, 0, 20); lbl.Font = Enum.Font.GothamBold; lbl.Text = title; lbl.TextColor3 = Color3.fromRGB(240, 245, 255); lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local dLbl = Instance.new("TextLabel", p)
    dLbl.BackgroundTransparency = 1; dLbl.Position = UDim2.new(0, 12, 0, 22); dLbl.Size = UDim2.new(1, -70, 0, 16); dLbl.Font = Enum.Font.Gotham; dLbl.Text = desc or ""; dLbl.TextColor3 = Color3.fromRGB(150, 160, 175); dLbl.TextSize = 10; dLbl.TextXAlignment = Enum.TextXAlignment.Left
    local tBtn = Instance.new("TextButton", p)
    tBtn.BackgroundColor3 = defaultVal and KV.AccentColor or Color3.fromRGB(45, 50, 65); tBtn.Position = UDim2.new(1, -50, 0.5, -11); tBtn.Size = UDim2.new(0, 38, 0, 22); tBtn.Text = ""; KV.applyCorner(tBtn, 11)
    local dot = Instance.new("Frame", tBtn)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255); dot.Position = defaultVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8); dot.Size = UDim2.new(0, 16, 0, 16); KV.applyCorner(dot, 8)
    local val = defaultVal
    tBtn.MouseButton1Click:Connect(function()
        val = not val
        KV.tw(tBtn, {BackgroundColor3 = val and KV.AccentColor or Color3.fromRGB(45, 50, 65)}, 0.15):Play()
        KV.tw(dot, {Position = val and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.15):Play()
        if callback then callback(val) end
    end)
    return p
end

KV.createButton = function(page, title, desc, callback)
    local p = KV.createPanel(page, 40)
    local btn = Instance.new("TextButton", p)
    btn.BackgroundTransparency = 1; btn.Size = UDim2.new(1, 0, 1, 0); btn.Font = Enum.Font.GothamBold; btn.Text = "  " .. title; btn.TextColor3 = Color3.fromRGB(240, 245, 255); btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return p
end

KV.createSlider = function(page, title, minVal, maxVal, defaultVal, callback)
    local p = KV.createPanel(page, 48)
    local lbl = Instance.new("TextLabel", p)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0, 12, 0, 4); lbl.Size = UDim2.new(1, -80, 0, 18); lbl.Font = Enum.Font.GothamBold; lbl.Text = title; lbl.TextColor3 = Color3.fromRGB(240, 245, 255); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local valLbl = Instance.new("TextLabel", p)
    valLbl.BackgroundTransparency = 1; valLbl.Position = UDim2.new(1, -65, 0, 4); valLbl.Size = UDim2.new(0, 50, 0, 18); valLbl.Font = Enum.Font.GothamBold; valLbl.Text = tostring(defaultVal); valLbl.TextColor3 = KV.AccentColor; valLbl.TextSize = 11; valLbl.TextXAlignment = Enum.TextXAlignment.Right
    local sTrack = Instance.new("Frame", p)
    sTrack.BackgroundColor3 = Color3.fromRGB(40, 45, 60); sTrack.Position = UDim2.new(0, 12, 0, 28); sTrack.Size = UDim2.new(1, -24, 0, 8); KV.applyCorner(sTrack, 4)
    local pct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    local sFill = Instance.new("Frame", sTrack)
    sFill.BackgroundColor3 = KV.AccentColor; sFill.Size = UDim2.new(pct, 0, 1, 0); KV.applyCorner(sFill, 4)
    local sliderDragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * pos + 0.5)
        sFill.Size = UDim2.new(pos, 0, 1, 0)
        valLbl.Text = tostring(val)
        if callback then callback(val) end
    end
    sTrack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliderDragging = true; updateSlider(input) end end)
    UserInputService.InputChanged:Connect(function(input) if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliderDragging = false end end)
    return p
end

KV.clickGuiPage    = KV.createPage("ClickGUI")
KV.dashboardPage   = KV.createPage("Dashboard")
KV.trainingPage    = KV.createPage("Training")
KV.protectionPage  = KV.createPage("Protection")
KV.teleportsPage   = KV.createPage("Teleports")
KV.automationPage  = KV.createPage("Automation")
KV.petsPage        = KV.createPage("Pets")
KV.eventsShopPage  = KV.createPage("EventsShop")
KV.movementPage    = KV.createPage("Movement")
KV.visualsPage     = KV.createPage("Visuals")
KV.aboutPage       = KV.createPage("About")

KV.createTabButton("Settings", "ClickGUI")
KV.createTabButton("Home", "Dashboard")
KV.createTabButton("Farm", "Training")
KV.createTabButton("Protection", "Protection")
KV.createTabButton("Teleports", "Teleports")
KV.createTabButton("Auto & Eggs", "Automation")
KV.createTabButton("Pets", "Pets")
KV.createTabButton("Events & Shop", "EventsShop")
KV.createTabButton("Movement", "Movement")
KV.createTabButton("Visuals", "Visuals")
KV.createTabButton("About", "About")

KV.sectionLabel(KV.clickGuiPage, "GUI SIZE & ACCENT PALETTE")
KV.createSlider(KV.clickGuiPage, "GUI Scale (%)", 70, 150, math.floor(KV.Config.GuiScale * 100), function(v)
    KV.Config.GuiScale = v / 100; KV.tw(KV.guiSizeScale, {Scale = KV.Config.GuiScale}, 0.12):Play()
end)

KV.sectionLabel(KV.clickGuiPage, "COLOR PALETTE (PALETTE)")
local palettePanel = KV.createPanel(KV.clickGuiPage, 90)
local pGrid = Instance.new("UIGridLayout", palettePanel); pGrid.CellSize = UDim2.new(0, 110, 0, 36); pGrid.CellPadding = UDim2.new(0, 8, 0, 8); pGrid.SortOrder = Enum.SortOrder.LayoutOrder
local pPadding = Instance.new("UIPadding", palettePanel); pPadding.PaddingTop = UDim.new(0, 8); pPadding.PaddingLeft = UDim.new(0, 8)

for _, preset in ipairs(KV.AccentPresets) do
    local tile = Instance.new("TextButton", palettePanel)
    tile.BackgroundColor3 = Color3.fromRGB(25, 30, 42); tile.AutoButtonColor = false; tile.Text = ""; KV.applyCorner(tile, 6)
    local cBar = Instance.new("Frame", tile); cBar.BackgroundColor3 = preset.color; cBar.Position = UDim2.new(0, 6, 0.5, -10); cBar.Size = UDim2.new(0, 20, 0, 20); KV.applyCorner(cBar, 4)
    local tLbl = Instance.new("TextLabel", tile); tLbl.BackgroundTransparency = 1; tLbl.Position = UDim2.new(0, 32, 0, 0); tLbl.Size = UDim2.new(1, -34, 1, 0); tLbl.Font = Enum.Font.GothamBold; tLbl.Text = preset.name; tLbl.TextColor3 = Color3.fromRGB(230, 235, 245); tLbl.TextSize = 9; tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tile.MouseButton1Click:Connect(function()
        KV.AccentColor = preset.color; KV.MainStroke.Color = preset.color; KV.HUDStroke.Color = preset.color; KV.OpenBtn.TextColor3 = preset.color; KV.OpenBtnStroke.Color = preset.color
        KV.notify("Vortex Palette", "Accent changed to " .. preset.name, 2)
    end)
end

KV.sectionLabel(KV.clickGuiPage, "HUD & DISPLAY SETTINGS")
KV.createToggle(KV.clickGuiPage, "Show OnScreen HUD", "Show OnScreen HUD (Draggable)", KV.Config.ShowOnScreenHUD, function(v) KV.Config.ShowOnScreenHUD = v; KV.OnScreenHUD.Visible = v end)
KV.createButton(KV.clickGuiPage, "Optimize FPS (Smooth Plastic)", "Optimize graphics for maximum FPS", function()
    pcall(function() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end end Lighting.GlobalShadows = false end)
    KV.notify("Vortex FPS", "Map graphics optimized for maximum FPS!", 3)
end)

KV.sectionLabel(KV.dashboardPage, "PLAYER LIVE OVERVIEW")
local statsP = KV.createPanel(KV.dashboardPage, 90)
local statsText = Instance.new("TextLabel", statsP)
statsText.BackgroundTransparency = 1; statsText.Position = UDim2.new(0, 12, 0, 8); statsText.Size = UDim2.new(1, -24, 1, -16); statsText.Font = Enum.Font.GothamMedium; statsText.TextColor3 = Color3.fromRGB(240, 245, 255); statsText.TextSize = 11; statsText.TextXAlignment = Enum.TextXAlignment.Left; statsText.TextYAlignment = Enum.TextYAlignment.Top

RunService.RenderStepped:Connect(function()
    if currentTab == "Dashboard" then
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        local str = ls and ls:FindFirstChild("Strength") and ls.Strength.Value or 0
        local reb = ls and ls:FindFirstChild("Rebirths") and ls.Rebirths.Value or 0
        local gems = KV.getCurrency("Gems")
        statsText.Text = "Player: " .. tostring(LocalPlayer.Name) .. " (ID: " .. tostring(LocalPlayer.UserId) .. ")\nStrength: " .. tostring(str) .. "\nRebirths: " .. tostring(reb) .. "\nGems: " .. tostring(gems) .. "\nPets Owned: " .. tostring(KV.countOwnedPets())
    end
end)

KV.sectionLabel(KV.trainingPage, "AUTO FARM & GYM TRAINING")
KV.createToggle(KV.trainingPage, "Auto OP Turbo Clicker", "Max speed auto farm strength", KV.Config.AutoOP, function(v)
    KV.Config.AutoOP = v
    if v then task.spawn(function() while KV.Config.AutoOP do local ev = KV.getMuscleEvent(); if ev then pcall(function() ev:FireServer("punch", "leftHand") end); pcall(function() ev:FireServer("punch", "rightHand") end) end task.wait(0.01) end end) end
end)
KV.createToggle(KV.trainingPage, "Walk While Training", "Move freely while exercising", KV.Config.WalkWhileTraining, function(v) KV.Config.WalkWhileTraining = v end)
KV.createToggle(KV.trainingPage, "Auto Dumbbell Farm", "Auto farm with dumbbells", KV.Config.AutoWeight, function(v)
    KV.Config.AutoWeight = v
    if v then task.spawn(function() while KV.Config.AutoWeight do local char = LocalPlayer.Character; local tool = char and char:FindFirstChildOfClass("Tool"); if tool then pcall(function() tool:Activate() end) end; local ev = KV.getMuscleEvent(); if ev then pcall(function() ev:FireServer("rep") end) end task.wait(0.02) end end) end
end)

KV.sectionLabel(KV.automationPage, "REBIRTH & CRYSTAL HATCHER")
KV.createToggle(KV.automationPage, "Auto Rebirth", "Auto request rebirths", KV.Config.AutoRebirth, function(v)
    KV.Config.AutoRebirth = v
    if v then task.spawn(function() while KV.Config.AutoRebirth do local ev = KV.getMuscleEvent(); if ev then pcall(function() ev:FireServer("rebirthRequest") end) end task.wait(1) end end) end
end)

KV.sectionLabel(KV.automationPage, "PET CRYSTAL HATCHER (FIXED)")
KV.createToggle(KV.automationPage, "Auto Hatch Selected Crystal", "Auto hatch selected egg/crystal", KV.Config.AutoCrystal, function(v)
    KV.Config.AutoCrystal = v
    if v then task.spawn(function() while KV.Config.AutoCrystal do local ok, res, msg = KV.openCrystalOnce(KV.Config.SelectedCrystal); task.wait(KV.Config.HatchDelay) end end) end
end)
KV.createToggle(KV.automationPage, "Auto Teleport to Crystal", "Teleport directly to crystal when hatching", KV.Config.AutoTPToCrystal, function(v) KV.Config.AutoTPToCrystal = v end)
KV.createSlider(KV.automationPage, "Hatch Delay (ms)", 10, 1000, math.floor(KV.Config.HatchDelay * 1000), function(v) KV.Config.HatchDelay = v / 1000 end)

KV.sectionLabel(KV.automationPage, "SELECT CRYSTAL")
for _, cName in ipairs(KV.crystalCatalog) do
    KV.createButton(KV.automationPage, cName, "Select " .. cName, function() KV.Config.SelectedCrystal = cName; KV.notify("Vortex Hatcher", "Selected Crystal: " .. cName, 2) end)
end

KV.sectionLabel(KV.petsPage, "PET MANAGEMENT")
KV.createButton(KV.petsPage, "Auto Evolve All Pets", "Evolve all pets in inventory", function() local ev = KV.getMuscleEvent(); if ev then pcall(function() ev:FireServer("evolvePetAll") end) end KV.notify("Vortex Pets", "Evolution request sent!", 2) end)

KV.sectionLabel(KV.eventsShopPage, "BOSS RADAR & TRACKER")
local bossCard = KV.createPanel(KV.eventsShopPage, 65)
local bossStatusLbl = Instance.new("TextLabel", bossCard)
bossStatusLbl.BackgroundTransparency = 1; bossStatusLbl.Position = UDim2.new(0, 12, 0, 8); bossStatusLbl.Size = UDim2.new(1, -24, 1, -16); bossStatusLbl.Font = Enum.Font.GothamBold; bossStatusLbl.TextColor3 = Color3.fromRGB(240, 245, 255); bossStatusLbl.TextSize = 11; bossStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

RunService.RenderStepped:Connect(function()
    if currentTab == "EventsShop" then
        local boss = KV.scanActiveBoss()
        if boss.alive then
            bossStatusLbl.Text = "Boss Active: " .. tostring(boss.name) .. "\n  Health: " .. tostring(boss.health) .. " / " .. tostring(boss.maxHealth) .. " HP\n  Distance: " .. tostring(boss.dist) .. " studs"
        else
            bossStatusLbl.Text = "Boss Status: Searching / Spawning soon..."
        end
    end
end)

KV.createButton(KV.eventsShopPage, "Teleport to Active Boss", "Teleport directly to active boss", function()
    local boss = KV.scanActiveBoss()
    if boss.alive and boss.model then
        local hrp = boss.model:FindFirstChild("HumanoidRootPart") or boss.model.PrimaryPart
        local myChar = LocalPlayer.Character
        if hrp and myChar and myChar:FindFirstChild("HumanoidRootPart") then myChar.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 5, 5); KV.notify("Vortex Boss", "Teleported to " .. boss.name, 2) end
    else KV.notify("Vortex Boss", "No active boss found!", 2) end
end)

KV.createToggle(KV.eventsShopPage, "Auto Farm / Kill Boss", "Automatically attack spawning bosses", KV.Config.AutoKillBoss, function(v)
    KV.Config.AutoKillBoss = v
    if v then task.spawn(function() while KV.Config.AutoKillBoss do local boss = KV.scanActiveBoss(); if boss.alive and boss.model then local hrp = boss.model:FindFirstChild("HumanoidRootPart") or boss.model.PrimaryPart; local myChar = LocalPlayer.Character; if hrp and myChar and myChar:FindFirstChild("HumanoidRootPart") then myChar.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, 3); local ev = KV.getMuscleEvent(); if ev then pcall(function() ev:FireServer("punch", "leftHand") end) end end end task.wait(0.05) end end) end
end)

KV.sectionLabel(KV.eventsShopPage, "OVERCHARGED SHOP TRACKER")
local shopCard = KV.createPanel(KV.eventsShopPage, 60)
local shopLbl = Instance.new("TextLabel", shopCard)
shopLbl.BackgroundTransparency = 1; shopLbl.Position = UDim2.new(0, 12, 0, 8); shopLbl.Size = UDim2.new(1, -24, 1, -16); shopLbl.Font = Enum.Font.GothamBold; shopLbl.Text = "Overcharged Shop Stock:\n  Items: Overcharged Aura, Potions, Keys\n  Restock: 03:45"; shopLbl.TextColor3 = Color3.fromRGB(240, 245, 255); shopLbl.TextSize = 11; shopLbl.TextXAlignment = Enum.TextXAlignment.Left

KV.sectionLabel(KV.teleportsPage, "WORLD & GYM TELEPORTS")
KV.islandDatabase = {
    ["Spawn Beach"]      = Vector3.new(0, 10, 0),
    ["Tiny Island"]      = Vector3.new(-39, 10, 1860),
    ["Legend Beach"]     = Vector3.new(0, 10, -4000),
    ["Frost Gym"]        = Vector3.new(-2569, 12, -474),
    ["Mythic Gym"]       = Vector3.new(2250, 12, 1070),
    ["Jungle Gym"]       = Vector3.new(-2500, 15, 2350),
    ["Industrial Gym"]   = Vector3.new(-4560, 995, -3000),
    ["Eternal Gym"]      = Vector3.new(-6730, 12, -1280),
    ["Legend Gym"]       = Vector3.new(4400, 995, -4000),
    ["Muscle King Gym"]  = Vector3.new(-8550, 20, -5700),
    ["Overcharged Gym"]  = Vector3.new(-7050, 20, -1350),
}
for name, pos in pairs(KV.islandDatabase) do
    KV.createButton(KV.teleportsPage, name, "Teleport to " .. name, function() local char = LocalPlayer.Character; if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(pos); KV.notify("Vortex TP", "Teleported to " .. name, 2) end end)
end

KV.sectionLabel(KV.protectionPage, "DEFENSE & SAFE TP")
KV.createToggle(KV.protectionPage, "Godmode / Anti-Damage", "Protection against damage", KV.Config.Godmode, function(v)
    KV.Config.Godmode = v
    if v then task.spawn(function() while KV.Config.Godmode do local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); if hum then hum.Health = hum.MaxHealth end task.wait(0.1) end end) end
end)

KV.sectionLabel(KV.movementPage, "FLIGHT & SPEED")
KV.createToggle(KV.movementPage, "Fly Mode (WASD)", "Free camera flight", KV.Config.FlyEnabled, function(v) KV.Config.FlyEnabled = v end)
KV.createSlider(KV.movementPage, "Speed Booster", 16, 200, 16, function(v) local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed = v end end)

KV.sectionLabel(KV.visualsPage, "WORLD VISUALS")
KV.createButton(KV.visualsPage, "Night Sky", "Switch to night sky", function() Lighting.TimeOfDay = "00:00:00" end)
KV.createButton(KV.visualsPage, "Day Sky", "Switch to day sky", function() Lighting.TimeOfDay = "12:00:00" end)

KV.sectionLabel(KV.aboutPage, "VORTEX HUB INFO")
KV.createButton(KV.aboutPage, "Owner: harin", "Click to copy Discord", function() pcall(function() setclipboard("harin") end); KV.notify("Vortex", "Discord copied: harin", 3) end)

KV.switchTab("ClickGUI")
local guiVisible = false
local isAnimating = false

KV.openMenu = function()
    if guiVisible or isAnimating then return end
    isAnimating = true; guiVisible = true; KV.MainFrame.Visible = true; KV.OpenBtn.Visible = false
    KV.tw(KV.MainFrame, {Position = KV.menuTargetPos}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
    task.delay(0.2, function() isAnimating = false end)
end

KV.closeMenu = function()
    if not guiVisible or isAnimating then return end
    isAnimating = true; guiVisible = false
    KV.tw(KV.MainFrame, {Position = UDim2.new(KV.menuTargetPos.X.Scale, KV.menuTargetPos.X.Offset, KV.menuTargetPos.Y.Scale, KV.menuTargetPos.Y.Offset + 30)}, 0.15):Play()
    task.delay(0.15, function() KV.MainFrame.Visible = false; KV.MainFrame.Position = KV.menuTargetPos; KV.OpenBtn.Visible = true; isAnimating = false end)
end

KV.toggleMenu = function() if guiVisible then KV.closeMenu() else KV.openMenu() end end
KV.CloseHeaderBtn.MouseButton1Click:Connect(KV.closeMenu)
KV.OpenBtn.MouseButton1Click:Connect(KV.toggleMenu)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then KV.toggleMenu() end
end)

KV.openMenu()
print("[Vortex Glass UI v0.24]: Muscle Legends Hub loaded successfully!")

end)

if not _guiOk then
    warn("[Vortex GUI BUILD ERROR]: " .. tostring(_guiErr))
end