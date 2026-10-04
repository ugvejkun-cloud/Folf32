--[[
    ================================================================================
    Vortex  тАФ MUSCLE LEGENDS MASTER HUB
    ================================================================================
    ╨Э╨░╨╖╨▓╨░╨╜╨╕╨╡ ╨║╨╗╨╕╨╡╨╜╤В╨░: Vortex 
    ╨Ю╤В╨║╤А╤Л╤В╨╕╨╡ / ╨б╨║╤А╤Л╤В╨╕╨╡ ╨╝╨╡╨╜╤О: Right Shift (r.shift) ╨╕╨╗╨╕ ╨║╨╜╨╛╨┐╨║╨░ Vortex ╨╜╨░ ╤Н╨║╤А╨░╨╜╨╡
    
    ╨Ю╤Б╨╛╨▒╨╡╨╜╨╜╨╛╤Б╤В╨╕ v:
      - ╨б╤В╨░╤А╤В╨╛╨▓╨╛╨╡ ╨┐╤А╨╕╨▓╨╡╤В╤Б╤В╨▓╨╡╨╜╨╜╨╛╨╡ ╨╛╨║╨╜╨╛: "╨Я╤А╨╕╨▓╨╡╤В! ╨Ъ╨░╨║╨╛╨╣ ╤П╨╖╤Л╨║ ╤В╤Л ╨┐╤А╨╡╨┤╨┐╨╛╤З╨╕╤В╨░╨╡╤И╤М?"
      - ╨Ф╨▓╤Г╤П╨╖╤Л╤З╨╜╤Л╨╣ ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б (╨а╤Г╤Б╤Б╨║╨╕╨╣ / English) ╤Б ╨╝╨╛╨┤╨░╨╗╤М╨╜╤Л╨╝ ╨┐╨╡╤А╨╡╨║╨╗╤О╤З╨╡╨╜╨╕╨╡╨╝
      - 10 ╨г╨┤╨╛╨▒╨╜╤Л╤Е ╤А╨░╨╖╨┤╨╡╨╗╨╛╨▓ ╤Б ╨╕╨╜╨┤╨╕╨║╨░╤В╨╛╤А╨░╨╝╨╕ ╤Б╨╛╤Б╤В╨╛╤П╨╜╨╕╤П [╨Т╨Ъ╨Ы / ╨Т╨л╨Ъ╨Ы]
      - ╨Ю╨╜╨╗╨░╨╣╨╜-╨░╨▓╤В╨╛╤А╨╕╨╖╨░╤Ж╨╕╤П (GitHub Whitelist integration)
      - ╨Ш╤Б╨┐╤А╨░╨▓╨╗╨╡╨╜ ╤Д╨░╤А╨╝ ╨║╨░╨╝╨╜╨╡╨╣ (╨┐╨╛╨▓╨╛╤А╨╛╤В ╨╗╨╕╤Ж╨╛╨╝ + CFrame.lookAt)
      - ╨Ш╤Б╨┐╤А╨░╨▓╨╗╨╡╨╜ ╨▓╤Л╨╗╤Г╨┐ ╤П╨╕╤Ж/╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨╛╨▓ (╨░╨▓╤В╨╛-╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╨▓╨┐╨╗╨╛╤В╨╜╤Г╤О + ╨╝╤Г╨╗╤М╤В╨╕-Remote)
    ================================================================================
--]]

print("==================================================")
print("[Vortex ]: SCRIPT EXECUTION STARTED!")
print("==================================================")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- ╨б╨Ш╨б╨в╨Х╨Ь╨Р ╨Р╨Т╨в╨Ю╨а╨Ш╨Ч╨Р╨ж╨Ш╨Ш / WHITELIST (GITHUB AUTH)
-- ============================================================
local WHITELIST_URL = "https://raw.githubusercontent.com/ugvejkun-cloud/Folf32/main/whitelist.json"
local ENABLE_WHITELIST = true

-- ╨Т╤Б╤В╤А╨╛╨╡╨╜╨╜╤Л╨╣ ╤А╨╡╨╖╨╡╤А╨▓╨╜╤Л╨╣ ╤Б╨┐╨╕╤Б╨╛╨║: ╤А╨░╨▒╨╛╤В╨░╨╡╤В ╨┤╨░╨╢╨╡ ╨║╨╛╨│╨┤╨░ GitHub ╨╜╨╡╨┤╨╛╤Б╤В╤Г╨┐╨╡╨╜ (429/╤В╨░╨╣╨╝╨░╤Г╤В)
local EMBEDDED_WHITELIST = {
    "tvinkilp", "user", "ownername", "drybs5",
    "@kotega33333333", "kotega33333333", "hamsterlegend", "harin",
}

local function nameAllowed(name)
    local n = string.lower(tostring(name))
    if n == "all" then return true end
    for _, allowed in ipairs(EMBEDDED_WHITELIST) do
        if allowed == n then return true end
    end
    return false
end

local function checkPlayerWhitelist()
    if not ENABLE_WHITELIST then return true end

    local playerName = string.lower(LocalPlayer.Name)
    print("[Vortex STAGE A]: ╨░╨▓╤В╨╛╤А╨╕╨╖╨░╤Ж╨╕╤П ╨╕╨│╤А╨╛╨║╨░ '" .. LocalPlayer.Name .. "'")

    -- ╨Ф╨╛ 3 ╨┐╨╛╨┐╤Л╤В╨╛╨║: raw.githubusercontent ╨╕╨╜╨╛╨│╨┤╨░ ╨╛╤В╨┤╨░╨╡╤В 429/╤В╨░╨╣╨╝╨░╤Г╤В
    for attempt = 1, 3 do
        local success, response = pcall(function()
            return game:HttpGet(WHITELIST_URL, true)
        end)
        if success and response and #response > 0 then
            local ok, data = pcall(function() return HttpService:JSONDecode(response) end)
            if ok and type(data) == "table" then
                for _, name in ipairs(data) do
                    local n = string.lower(tostring(name))
                    if n == playerName or n == "all" then
                        print("[Vortex STAGE B]: whitelist OK (╨┐╨╛╨┐╤Л╤В╨║╨░ " .. attempt .. ")")
                        return true
                    end
                end
                print("[Vortex STAGE B]: ╨╜╨╕╨║ '" .. LocalPlayer.Name .. "' ╨Э╨Х ╨╜╨░╨╣╨┤╨╡╨╜ ╨▓ whitelist.json")
                return false -- ╤Б╨┐╨╕╤Б╨╛╨║ ╨╖╨░╨│╤А╤Г╨╢╨╡╨╜, ╨╕╨│╤А╨╛╨║╨░ ╨▓ ╨╜╨╡╨╝ ╨╜╨╡╤В
            end
            warn("[Vortex Auth]: JSON ╨╜╨╡╨║╨╛╤А╤А╨╡╨║╤В╨╡╨╜ (╨┐╨╛╨┐╤Л╤В╨║╨░ " .. attempt .. ")")
        else
            warn("[Vortex Auth]: HttpGet whitelist ╨╜╨╡ ╤Г╨┤╨░╨╗╤Б╤П (╨┐╨╛╨┐╤Л╤В╨║╨░ " .. attempt .. "): " .. tostring(response))
        end
        task.wait(0.5)
    end

    -- GitHub ╨╜╨╡╨┤╨╛╤Б╤В╤Г╨┐╨╡╨╜: ╨┐╤А╨╛╨▓╨╡╤А╤П╨╡╨╝ ╨┐╨╛ ╨▓╤Б╤В╤А╨╛╨╡╨╜╨╜╨╛╨╝╤Г ╤Б╨┐╨╕╤Б╨║╤Г
    if nameAllowed(playerName) then
        print("[Vortex STAGE B]: ╨┤╨╛╤Б╤В╤Г╨┐ ╨┐╨╛ ╨▓╤Б╤В╤А╨╛╨╡╨╜╨╜╨╛╨╝╤Г ╤А╨╡╨╖╨╡╤А╨▓╨╜╨╛╨╝╤Г ╤Б╨┐╨╕╤Б╨║╤Г")
        return true
    end
    warn("[Vortex Auth]: ╨╜╨╡ ╤Г╨┤╨░╨╗╨╛╤Б╤М ╨╖╨░╨│╤А╤Г╨╖╨╕╤В╤М whitelist.json (╨┐╨╛╨┐╤Л╤В╨╛╨║: 3)")
    return false
end

if not checkPlayerWhitelist() then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Vortex Auth Error",
            Text = "╨Э╨╡╤В ╨┤╨╛╤Б╤В╤Г╨┐╨░! ╨Э╨╕╨║: " .. LocalPlayer.Name,
            Duration = 10
        })
    end)
    -- ╨Т╨Ш╨Ф╨Ш╨Ь╨л╨Щ ╨╜╨░ ╤Н╨║╤А╨░╨╜╨╡ ╨╛╤В╨║╨░╨╖ (╨╕╨╜╨╢╨╡╨║╤В╨╛╤А╤Л ╤З╨░╤Б╤В╨╛ ╨╜╨╡ ╨┐╨╛╨║╨░╨╖╤Л╨▓╨░╤О╤В SetCore-╤Г╨▓╨╡╨┤╨╛╨╝╨╗╨╡╨╜╨╕╤П)
    pcall(function()
        local denied = Instance.new("ScreenGui")
        denied.Name = "Vortex_AccessDenied"
        denied.ResetOnSpawn = false
        denied.DisplayOrder = 99
        local label = Instance.new("TextLabel", denied)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.Position = UDim2.new(0.5, 0, 0.12, 0)
        label.Size = UDim2.new(0, 560, 0, 96)
        label.BackgroundColor3 = Color3.fromRGB(28, 18, 18)
        label.BackgroundTransparency = 0.1
        label.BorderSizePixel = 0
        label.Font = Enum.Font.GothamBold
        label.TextWrapped = true
        label.TextColor3 = Color3.fromRGB(255, 110, 110)
        label.TextSize = 16
        label.Text = "Vortex: access denied!\nYour nickname is not in the whitelist: " .. LocalPlayer.Name .. "\nVortex Auth Error"
        local corner = Instance.new("UICorner", label)
        corner.CornerRadius = UDim.new(0, 10)
        local parentOk = false
        if typeof(gethui) == "function" then pcall(function() denied.Parent = gethui() parentOk = true end) end
        if not parentOk then pcall(function() denied.Parent = CoreGui parentOk = true end) end
        if not parentOk then pcall(function() denied.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end
    end)
    warn("[Vortex Auth]: ╨Ф╨╛╤Б╤В╤Г╨┐ ╨╖╨░╨┐╤А╨╡╤Й╨╡╨╜ ╨┤╨╗╤П ╨╕╨│╤А╨╛╨║╨░ " .. LocalPlayer.Name)
    return
end

print("[Vortex STAGE C]: whitelist ╨┐╤А╨╛╨╣╨┤╨╡╨╜, ╤Б╨╛╨╖╨┤╨░╤О ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б...")

-- ╨а╨Р╨Э╨Э╨Ш╨Щ ╨Т╨Ш╨Ф╨Ш╨Ь╨л╨Щ ╨Ь╨Р╨а╨Ъ╨Х╨а: ╨┐╨╛╤П╨▓╨╗╤П╨╡╤В╤Б╤П ╤Б╤А╨░╨╖╤Г ╨┐╨╛╤Б╨╗╨╡ whitelist, ╨╜╨╡╨╖╨░╨▓╨╕╤Б╨╕╨╝╨╛ ╨╛╤В ╨┤╨░╨╗╤М╨╜╨╡╨╣╤И╨╕╤Е ╨╛╤И╨╕╨▒╨╛╨║.
-- ╨Х╤Б╨╗╨╕ ╨╡╨│╨╛ ╨╜╨╡╤В ╨╜╨░ ╤Н╨║╤А╨░╨╜╨╡ тАФ ╤Б╨║╤А╨╕╨┐╤В ╨╜╨╡ ╨┐╤А╨╛╤И╤С╨╗ ╨░╨▓╤В╨╛╤А╨╕╨╖╨░╤Ж╨╕╤О ╨╕╨╗╨╕ ╨╜╨╡ ╨▓╤Л╨┐╨╛╨╗╨╜╨╕╨╗╤Б╤П.
local bootGuiRef, bootLabelRef = nil, nil
pcall(function()
    local bootGui = Instance.new("ScreenGui")
    bootGui.Name = "VortexBoot"
    bootGui.ResetOnSpawn = false
    bootGui.DisplayOrder = 100
    local boot = Instance.new("TextLabel", bootGui)
    boot.Name = "BootLabel"
    boot.AnchorPoint = Vector2.new(0.5, 0)
    boot.Position = UDim2.new(0.5, 0, 0.08, 0)
    boot.Size = UDim2.new(0, 420, 0, 40)
    boot.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    boot.BackgroundTransparency = 0.15
    boot.BorderSizePixel = 0
    boot.Font = Enum.Font.GothamBold
    boot.TextSize = 13
    boot.TextColor3 = Color3.fromRGB(201, 180, 255)
    boot.Text = "[Vortex] whitelist OK тАФ building UI..."
    local c = Instance.new("UICorner", boot)
    c.CornerRadius = UDim.new(0, 8)
    local okParent = false
    if typeof(gethui) == "function" then pcall(function() bootGui.Parent = gethui() okParent = true end) end
    if not okParent then pcall(function() bootGui.Parent = CoreGui okParent = true end) end
    if not okParent then pcall(function() bootGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end
    bootGuiRef, bootLabelRef = bootGui, boot
    print("[Vortex STAGE C2]: boot-marker parented=" .. tostring(bootGui.Parent))
end)

local function bootSet(text, color)
    pcall(function()
        if bootLabelRef then
            bootLabelRef.Text = text
            if color then bootLabelRef.TextColor3 = color end
        end
    end)
end

local function bootDone()
    pcall(function()
        if bootGuiRef then bootGuiRef:Destroy() bootGuiRef, bootLabelRef = nil, nil end
    end)
end

-- ╨Ч╨░╤Й╨╕╤В╨░ ╨╛╤В ╨┐╨╛╨▓╤В╨╛╤А╨╜╨╛╨│╨╛ ╨╖╨░╨┐╤Г╤Б╨║╨░ Vortex
local FRAMEWORK_NAME = "Vortex_MuscleLegends_Master"
pcall(function()
    if typeof(gethui) == "function" and gethui():FindFirstChild(FRAMEWORK_NAME) then
        gethui()[FRAMEWORK_NAME]:Destroy()
    end
end)
pcall(function()
    if CoreGui:FindFirstChild(FRAMEWORK_NAME) then
        CoreGui[FRAMEWORK_NAME]:Destroy()
    end
end)
pcall(function()
    if LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild(FRAMEWORK_NAME) then
        LocalPlayer.PlayerGui[FRAMEWORK_NAME]:Destroy()
    end
end)

-- ╨Т╨╡╤Б╤М ╨┤╨░╨╗╤М╨╜╨╡╨╣╤И╨╕╨╣ ╨║╨╛╨┤ GUI тАФ ╨▓╨╜╤Г╤В╤А╨╕ pcall: ╨┐╤А╨╕ ╨╛╤И╨╕╨▒╨║╨╡ ╤Б╤В╤А╨╛╨╕╤В╨╡╨╗╤М╤Б╤В╨▓╨░
-- ╨╛╨╜╨░ ╨▒╤Г╨┤╨╡╤В ╨┐╨╛╨║╨░╨╖╨░╨╜╨░ ╨╜╨░ ╨▒╨╡╨╣╨┤╨╢╨╡ ╤Б ╤В╨╛╤З╨╜╨╛╨╣ ╤Б╤В╤А╨╛╨║╨╛╨╣ ╤Д╨░╨╣╨╗╨░, ╨░ ╨╜╨╡ ╨╝╨╛╨╗╤З╨░ ╤Г╨▒╤М╤С╤В ╤Б╨║╤А╨╕╨┐╤В.
local _guiOk, _guiErr = pcall(function()
local KV = {}

-- ╨е╤А╨░╨╜╨╕╨╗╨╕╤Й╨╡ ╨┐╨╛╨┤╨║╨╗╤О╤З╨╡╨╜╨╕╨╣ ╨┤╨╗╤П ╨┐╨╛╨╗╨╜╨╛╨╣ ╨▓╤Л╨│╤А╤Г╨╖╨║╨╕ (Unload)
KV.ScriptConnections = {}
-- Forward-╨┤╨╡╨║╨╗╨░╤А╨░╤Ж╨╕╤П: ╨╛╨┐╤А╨╡╨┤╨╡╨╗╤П╨╡╤В╤Б╤П ╨┐╨╛╨╖╨╢╨╡ ╨▓ ╤Б╨╡╨║╤Ж╨╕╨╕ ESP, ╨╜╨╛ ╨╜╤Г╨╢╨╜╨░ ╨▓ completeScriptUnload
local clearESP

-- ============================================================
-- ╨У╨Ы╨Ю╨С╨Р╨Ы╨м╨Э╨л╨Щ ╨Ъ╨Ю╨Э╨д╨Ш╨У Vortex 
-- ============================================================
KV.Config = {
    -- ╨п╨╖╤Л╨║ ╨┐╨╛ ╤Г╨╝╨╛╨╗╤З╨░╨╜╨╕╤О
    Language          = "RU", -- "RU" ╨╕╨╗╨╕ "EN"

    -- Glass UI ╨Э╨░╤Б╤В╤А╨╛╨╣╨║╨╕
    Glow              = true,
    BgOpacity         = 25,
    GlassIntensity    = 75,
    EnableTooltips    = true,
    GuiScale          = 1,      -- ╨╝╨░╤Б╤И╤В╨░╨▒ ╨╛╨║╨╜╨░ GUI (0.7 - 1.5)

    -- ╨Т╨╕╨╖╤Г╨░╨╗╤М╨╜╤Л╨╡ ╤Н╤Д╤Д╨╡╨║╤В╤Л (Visuals)
    SkyMode           = "Default", -- Default / Night / Sunset / Neon / Cosmic
    TrailEnabled      = false,
    TrailLifetime     = 0.6,    -- ╨┤╨╗╨╕╨╜╨░ ╤Б╨╗╨╡╨┤╨░ ╨╖╨░ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨╡╨╝ (╤Б╨╡╨║)
    JumpRing          = false,  -- ╨║╤А╤Г╨│ ╨┐╨╛╨┤ ╨╜╨╛╨│╨░╨╝╨╕ ╨┐╤А╨╕ ╨┐╤А╤Л╨╢╨║╨╡

    -- ╨в╤А╨╡╨╜╨╕╤А╨╛╨▓╨║╨╕
    AutoOpFarm        = false,
    AutoDumbbell      = false,
    AutoPushups       = false,
    AutoSitups        = false,
    AutoWeight        = false,
    AutoPunch         = false,
    AutoMultiTool     = false,
    WalkWhileTraining = false,
    FastRepMultiplier = 5,
    UltraFastRep      = false,
    TrainDelay        = 0,

    -- ╨в╤А╨╡╨╜╨░╨╢╨╡╤А╤Л ╨╕╨│╤А╤Л (Machine Farm)
    AutoBenchPress       = false,
    AutoSquat            = false,
    AutoTreadmillMachine = false,
    AutoPullups          = false,
    AutoBoulder          = false,
    AutoRockMachine      = false,

    -- ╨Ъ╨░╨╝╨╜╨╕ ╨╕ ╨в╤А╨╡╨╜╨░╨╢╨╡╤А╤Л
    AutoRock          = false,
    SelectedRockTier  = "Any",
    RockOffset        = 3,
    AutoTreadmill     = false,

    -- ╨С╨╛╨╣ & Kill Aura
    KillAura          = false,
    KillAuraMode      = "Bring To Me", -- "Bring To Me", "Magnet TP to Target", "Orbit Target"
    KillAuraRange     = 45,
    KillAuraDelay     = 0.03,
    PunchMultiplier   = 2,
    AutoKillBoss      = false,
    BossHitMultiplier = 5,
    AutoKillServer    = false,
    AutoBrawl         = false,
    SelectedTargetPlayer = nil,
    TargetLoopKill    = false,

    -- ╨Ч╨░╤Й╨╕╤В╨░
    AntiHit           = false,
    AntiRagdoll       = false,
    AntiKnockback     = false,
    AutoSafeTPLowHP   = false,
    AntiAFK           = true,

    -- ╨д╨░╤А╨╝╨╕╨╜╨│ & ╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╨╖╨░╤Ж╨╕╤П
    AutoRebirth       = false,
    StayAfterRebirth  = true,   -- ╨┐╨╛╤Б╨╗╨╡ ╤А╨╡╨▒╨╕╤А╤В╨░ ╨▓╨╛╨╖╨▓╤А╨░╤Й╨░╤В╤М╤Б╤П ╨╜╨░ ╨╕╤Б╤Е╨╛╨┤╨╜╤Г╤О ╤В╨╛╤З╨║╤Г (╨╜╨╡ ╤Б╨┐╨░╨▓╨╜)
    AutoChest         = false,
    AutoCrystal       = false,
    SelectedCrystal   = "Blue Crystal",
    HatchCount        = 50,     -- ╤Б╨║╨╛╨╗╤М╨║╨╛ ╤П╨╕╤Ж ╨╛╤В╨║╤А╤Л╨▓╨░╤В╤М ╨╖╨░ ╨╛╨┤╨╕╨╜ Mass Hatch (1..500)
    HatchDelay        = 0.25,   -- ╨╖╨░╨┤╨╡╤А╨╢╨║╨░ ╨╝╨╡╨╢╨┤╤Г ╨╛╤В╨║╤А╤Л╤В╨╕╤П╨╝╨╕ ╤П╨╕╤Ж (╤Б╨╡╨║)
    HatchPower        = false,  -- ╤Д╨╗╨░╨│ ╨╢╨╕╨▓╨╛╤Б╤В╨╕ ╨╝╨░╤Б╤Б╨╛╨▓╨╛╨│╨╛ ╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╤П (╨│╨░╤Б╨╕╤В╤Б╤П ╨┐╤А╨╕ Unload)
    AutoCollectOrbs   = false,

    -- ╨в╨╡╨╝╨░ ╨╛╨║╨╜╨░ (╤Б╨╜╨░╤З╨░╨╗╨░ тАФ ╤Б╨┐╨╗╨╛╤И╨╜╨╛╨╣ ╤З╤С╤А╨╜╤Л╨╣)
    ThemeIndex        = 1,

    -- ╨Я╨╕╤В╨╛╨╝╤Ж╤Л
    AutoEvolvePets    = false,
    AutoEquipBest     = false,

    -- ╨Я╨╛╨╗╨╡╤В & ╨Ф╨▓╨╕╨╢╨╡╨╜╨╕╨╡
    FlyEnabled        = false,
    FlySpeed          = 80,
    SpeedHack         = false,
    SpeedValue        = 65,
    JumpPowerHack     = false,
    JumpPowerValue    = 100,
    InfJump           = false,
    Noclip            = false,
    Bhop              = false,
    GravityValue      = 196.2,

    -- ╨Т╨╕╨╖╤Г╨░╨╗ & ╨б╨┐╨╡╨║╤В╨╡╨╣╤В
    PlayerESP         = false,
    FullBright        = false,
    ShowOnScreenHUD = false,
    CustomFOV         = 70,
    SpectateTarget    = false,

    -- ╨а╨░╨╖╨╝╨╡╤А ╨Я╨╡╤А╤Б╨╛╨╜╨░╨╢╨░
    PlayerScale       = 1,
    
    -- ╨в╨╛╤З╨║╨╕ ╤Б╨╛╤Е╤А╨░╨╜╨╡╨╜╨╕╤П
    SavedWaypoint     = nil
}

-- ╨Т╤Б╨┐╨╛╨╝╨╛╨│╨░╤В╨╡╨╗╤М╨╜╨░╤П ╤Д╤Г╨╜╨║╤Ж╨╕╤П ╨╗╨╛╨║╨░╨╗╨╕╨╖╨░╤Ж╨╕╨╕ (╨Ы╨╛╨║╨░╨╗╨╕╨╖╨░╤Ж╨╕╤П ╤В╨╡╨║╤Б╤В╨░ RU / EN)
KV.t = function(ruText, enText)
    if KV.Config.Language == "EN" then
        return enText or ruText
    end
    return ruText
end

-- ╨в╨╡╨║╤Б╤В ╨┤╨╗╤П HUD/╤В╨╛╤Б╤В╨╛╨▓: ╨Т╨б╨Х╨У╨Ф╨Р ╨░╨╜╨│╨╗╨╕╨╣╤Б╨║╨╕╨╣, ╨╜╨╡╨╖╨░╨▓╨╕╤Б╨╕╨╝╨╛ ╨╛╤В ╤П╨╖╤Л╨║╨░ ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░
KV.tn = function(ruText, enText)
    return enText or ruText
end

-- ============================================================
-- ╨Ц╨Ш╨Т╨Р╨п ╨Ы╨Ю╨Ъ╨Р╨Ы╨Ш╨Ч╨Р╨ж╨Ш╨п UI: ╤Б╨╗╨╛╨▓╨░╤А╤М RU -> EN + ╤А╨╡-╨┐╤А╨╕╨╝╨╡╨╜╨╡╨╜╨╕╨╡
-- ============================================================
KV.LangDict = {
    ["╨Я╨╡╤А╨╡╨║╨╗╤О╤З╨░╨╡╤В ╤П╨╖╤Л╨║ ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░ ╨╝╨╡╨╢╨┤╤Г ╨а╤Г╤Б╤Б╨║╨╕╨╝ ╨╕ English"] = "Switches the interface language between Russian and English",
    ["╨Ъ╤А╨░╤Б╨╜╤Л╨╣ ╤Ж╨▓╨╡╤В ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░"] = "Interface red color",
    ["╨Ч╨╡╨╗╨╡╨╜╤Л╨╣ ╤Ж╨▓╨╡╤В ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░"] = "Interface green color",
    ["╨б╨╕╨╜╨╕╨╣ ╤Ж╨▓╨╡╤В ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░"] = "Interface blue color",
    ["╨Я╤Г╨╗╤М╤Б╨╕╤А╤Г╤О╤Й╨░╤П ╨╜╨╡╨╛╨╜╨╛╨▓╨░╤П ╤А╨░╨╝╨║╨░ ╨╝╨╡╨╜╤О"] = "Pulsing neon menu frame",
    ["╨Ш╨╜╤В╨╡╨╜╤Б╨╕╨▓╨╜╨╛╤Б╤В╤М ╤А╨░╨╖╨╝╤Л╤В╨╕╤П ╤Б╤В╨╡╨║╨╗╨░"] = "Glass blur intensity",
    ["╨Ю╤В╨╛╨▒╤А╨░╨╢╨╡╨╜╨╕╨╡ ╨╛╨┐╨╕╤Б╨░╨╜╨╕╤П ╤Д╤Г╨╜╨║╤Ж╨╕╨╣ ╨▓╨╜╨╕╨╖╤Г ╤Н╨║╤А╨░╨╜╨░"] = "Show feature descriptions at the bottom of the screen",
    ["╨г╨┤╨░╨╗╤П╨╡╤В ╤В╨╡╨║╤Б╤В╤Г╤А╤Л ╨║╨░╤А╤В╤Л ╨┤╨╗╤П ╤Г╨▓╨╡╨╗╨╕╤З╨╡╨╜╨╕╤П FPS"] = "Removes map textures to boost FPS",
    ["╨Я╨╛╨╗╨╜╨░╤П ╨▓╤Л╨│╤А╤Г╨╖╨║╨░ ╤Б╨║╤А╨╕╨┐╤В╨░ Vortex  ╨╕ ╨╛╤З╨╕╤Б╤В╨║╨░ ╨┐╨░╨╝╤П╤В╨╕"] = "Fully unload Vortex  and free memory",
    ["╨Ф╨╡╨╗╨░╨╡╤В ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨░ ╨╜╨╡╨╖╨░╨╝╨╡╤В╨╜╤Л╨╝ ╨╝╨╕╨╜╨╕-╨║╨░╤А╨╗╨╕╨║╨╛╨╝"] = "Makes your character a tiny unnoticed dwarf",
    ["╨б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╤З╨╡╨╗╨╛╨▓╨╡╤З╨╡╤Б╨║╨╕╨╣ ╤А╨░╨╖╨╝╨╡╤А"] = "Standard human size",
    ["╨С╨╛╨╗╤М╤И╨╛╨╣ ╨╜╨░╨║╨░╤З╨░╨╜╨╜╤Л╨╣ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢"] = "Big muscular character",
    ["╨Ю╨│╤А╨╛╨╝╨╜╤Л╨╣ ╤В╨╕╤В╨░╨╜ ╨╜╨░ ╨▓╤Б╤О ╨║╨░╤А╤В╤Г"] = "Huge titan across the whole map",
    ["╨Ъ╨╛╨╗╨╛╤Б╤Б╨░╨╗╤М╨╜╤Л╨╣ ╨│╨╕╨│╨░╨╜╤В"] = "Colossal giant",
    ["╨в╨╛╤З╨╜╨░╤П ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨░ ╨╝╨░╤Б╤И╤В╨░╨▒╨░ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨░ (1x - 30x)"] = "Fine-tune character scale (1x - 30x)",
    ["Auto OP (╨г╨╜╨╕╨▓╨╡╤А╤Б╨░╨╗╤М╨╜╤Л╨╣ ╤Б╤Г╨╝╨░╤Б╤И╨╡╨┤╤И╨╕╨╣ ╨║╨╗╨╕╨║╨╡╤А)"] = "Auto OP (Universal Crazy Clicker)",
    ["╨б╨╡╨╗╨╕ ╨╖╨░ ╨Ы╨о╨С╨Ю╨Щ ╤В╤А╨╡╨╜╨░╨╢╨╡╤А ╨╕╨╗╨╕ ╨▓╨╖╤П╨╗╨╕ ╨Ы╨о╨С╨Ю╨Щ ╤Б╨╜╨░╤А╤П╨┤ тАФ ╨╝╨│╨╜╨╛╨▓╨╡╨╜╨╜╨╛ ╨║╨░╤З╨░╨╡╤В ╨╜╨░ ╨┐╤А╨╡╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤В╤Г╤А╨▒╨╛-╤Б╨║╨╛╤А╨╛╤Б╤В╨╕!"] = "Sit on ANY machine or grab ANY equipment тАФ instantly trains at max turbo speed!",
    ["╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨б╨╕╨╗╤Л ╤З╨╡╤А╨╡╨╖ ╨У╨░╨╜╤В╨╡╨╗╨╕"] = "Auto farm Strength with Dumbbells",
    ["╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨б╨╕╨╗╤Л ╤З╨╡╤А╨╡╨╖ ╨Ю╤В╨╢╨╕╨╝╨░╨╜╨╕╤П"] = "Auto farm Strength with Pushups",
    ["╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨б╨╕╨╗╤Л ╤З╨╡╤А╨╡╨╖ ╨Я╤А╨╡╤Б╤Б"] = "Auto farm Strength with Situps",
    ["╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨б╨╕╨╗╤Л ╤З╨╡╤А╨╡╨╖ ╨и╤В╨░╨╜╨│╤Г"] = "Auto farm Strength with Barbell",
    ["╨Р╨▓╤В╨╛-╤Г╨┤╨░╤А╤Л ╨┐╨╛ ╨│╤А╤Г╤И╨╡/╨▓╨╛╨╖╨┤╤Г╤Е╤Г ╨┤╨╗╤П ╨┐╤А╨╛╨║╨░╤З╨║╨╕"] = "Auto punches on the bag/air for training",
    ["╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╤З╨╡╤А╨╡╨┤╤Г╨╡╤В ╨▓╤Б╨╡ ╤Б╨╜╨░╤А╤П╨┤╤Л ╨┤╨╗╤П ╨╝╨░╨║╤Б╨╕╨╝╨░╨╗╤М╨╜╨╛╨╣ ╨┐╤А╨╛╨║╨░╤З╨║╨╕"] = "Automatically cycles all equipment for maximum training",
    ["Walk While Training (╨е╨╛╨┤╨╕╤В╤М ╨▓╨╛ ╨▓╤А╨╡╨╝╤П ╤Г╨┐╤А╨░╨╢╨╜╨╡╨╜╨╕╤П)"] = "Walk While Training (Move During Exercise)",
    ["╨Я╨╛╨╖╨▓╨╛╨╗╤П╨╡╤В ╤Б╨▓╨╛╨▒╨╛╨┤╨╜╨╛ ╤Е╨╛╨┤╨╕╤В╤М ╤Б╨╛ ╤И╤В╨░╨╜╨│╨╛╨╣, ╨│╨░╨╜╤В╨╡╨╗╤П╨╝╨╕ ╨╕╨╗╨╕ ╨▓╨╛ ╨▓╤А╨╡╨╝╤П ╨▓╤Л╨┐╨╛╨╗╨╜╨╡╨╜╨╕╤П ╤Г╨┐╤А╨░╨╢╨╜╨╡╨╜╨╕╨╣!"] = "Allows you to walk freely with a barbell, dumbbells or during exercises!",
    ["GYM MACHINES AUTO-FARM (╨С╨Ы╨Ш╨Ц╨Р╨Щ╨и╨Ш╨Щ ╨в╨а╨Х╨Э╨Р╨Ц╨Х╨а)"] = "GYM MACHINES AUTO-FARM (NEAREST MACHINE)",
    ["Auto Bench Press (╨Ц╨╕╨╝ ╨╗╨╡╨╢╨░)"] = "Auto Bench Press",
    ["╨б╨░╨┤╨╕╤В╤Б╤П ╨╜╨░ ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╕╨╣ ╨╢╨╕╨╝ ╨╗╨╡╨╢╨░ 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨│╤А╤Г╨┤╤М!"] = "Sits on the nearest bench press once and trains chest!",
    ["Auto Squat Rack (╨Я╤А╨╕╤Б╨╡╨┤╨░╨╜╨╕╤П)"] = "Auto Squat Rack (Squats)",
    ["╨б╨░╨┤╨╕╤В╤Б╤П ╨╜╨░ ╨▒╨╗╨╕╨╢╨░╨╣╤И╤Г╤О ╤Б╤В╨╛╨╣╨║╤Г ╨┐╤А╨╕╤Б╨╡╨┤╨░╨╜╨╕╨╣ 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨╜╨╛╨│╨╕!"] = "Sits on the nearest squat rack once and trains legs!",
    ["Auto Treadmill (╨С╨╡╨│╨╛╨▓╨░╤П ╨┤╨╛╤А╨╛╨╢╨║╨░)"] = "Auto Treadmill (Running Track)",
    ["╨Т╤Б╤В╨░╨╡╤В ╨╜╨░ ╨▒╨╗╨╕╨╢╨░╨╣╤И╤Г╤О ╨▒╨╡╨│╨╛╨▓╤Г╤О ╨┤╨╛╤А╨╛╨╢╨║╤Г 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨╗╨╛╨▓╨║╨╛╤Б╤В╤М!"] = "Steps on the nearest treadmill once and trains agility!",
    ["Auto Pull-ups (╨Я╨╛╨┤╤В╤П╨│╨╕╨▓╨░╨╜╨╕╤П)"] = "Auto Pull-ups",
    ["╨Т╤Б╤В╨░╨╡╤В ╨║ ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╡╨╝╤Г ╤В╤Г╤А╨╜╨╕╨║╤Г 1 ╤А╨░╨╖ ╨╕ ╨┐╨╛╨┤╤В╤П╨│╨╕╨▓╨░╨╡╤В╤Б╤П!"] = "Moves to the nearest pull-up bar once and does pull-ups!",
    ["Auto Boulder Throw (╨С╤А╨╛╤Б╨╛╨║ ╨▓╨░╨╗╤Г╨╜╨░)"] = "Auto Boulder Throw",
    ["╨Я╨╛╨┤╤Е╨╛╨┤╨╕╤В ╨║ ╨▓╨░╨╗╤Г╨╜╤Г 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨▒╤А╨╛╤Б╨║╨╕!"] = "Approaches the boulder once and trains throwing!",
    ["Auto Rock Farm (╨Ъ╨░╨╝╨╡╨╜╤М)"] = "Auto Rock Farm (Rock)",
    ["╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨║ ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╡╨╝╤Г ╨║╨░╨╝╨╜╤О 1 ╤А╨░╨╖ ╨╕ ╨╜╨╡╨┐╤А╨╡╤А╤Л╨▓╨╜╨╛ ╨▒╤М╨╡╤В!"] = "Teleports to the nearest rock once and hits it continuously!",
    ["╨г╨╗╤М╤В╤А╨░-╤Б╨║╨╛╤А╨╛╤Б╤В╨╜╨╛╨╣ ╤А╨╡╨╢╨╕╨╝: ╨╝╨│╨╜╨╛╨▓╨╡╨╜╨╜╤Л╨╣ ╤Б╨┐╨░╨╝ ╨╕╨▓╨╡╨╜╤В╨╛╨▓ ╨║╨░╤З╨░╨╜╨╕╤П ╨▒╨╡╨╖ ╨╖╨░╨┤╨╡╤А╨╢╨║╨╕!"] = "Ultra-fast mode: instant training event spam with no delay!",
    ["╨г╤Б╨║╨╛╤А╨╕╤В╨╡╨╗╤М ╤Д╨░╤А╨╝╨░: ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛ ╨╛╤В╨┐╤А╨░╨▓╨╗╤П╨╡╨╝╤Л╤Е ╨┐╨░╨║╨╡╤В╨╛╨▓ ╨║╨░╤З╨░╨╜╨╕╤П ╨╖╨░ ╨╛╨┤╨╕╨╜ ╤А╨░╨╖ (╨┤╨╛ 100x)"] = "Farm booster: number of training packets sent per tick (up to 100x)",
    ["╨Ч╨░╨┤╨╡╤А╨╢╨║╨░ ╨╝╨╡╨╢╨┤╤Г ╨┐╨╛╨▓╤В╨╛╤А╨░╨╝╨╕ (0 = ╨╝╨│╨╜╨╛╨▓╨╡╨╜╨╜╨╛)"] = "Delay between reps (0 = instant)",
    ["╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨║ ╨║╨░╨╝╨╜╤О 1 ╤А╨░╨╖ ╨╕ ╨╜╨╡╨┐╤А╨╡╤А╤Л╨▓╨╜╨╛ ╨▒╤М╨╡╤В!"] = "Teleports to the rock once and hits it continuously!",
    ["╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨╜╨░ ╨▒╨╡╨│╨╛╨▓╤Г╤О ╨┤╨╛╤А╨╛╨╢╨║╤Г 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨╗╨╛╨▓╨║╨╛╤Б╤В╤М!"] = "Teleports to the treadmill once and trains agility!",
    ["SELECT ROCK TIER (╨в╨Ю╨з╨Э╨л╨Х ╨в╨а╨Х╨С╨Ю╨Т╨Р╨Э╨Ш╨п)"] = "SELECT ROCK TIER (EXACT REQUIREMENTS)",
    ["Mode 1: Bring Target To Me (╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╨╛╨▓╨░╤В╤М ╨▓╤А╨░╨│╨░ ╨║ ╤Б╨╡╨▒╨╡)"] = "Mode 1: Bring Target To Me (Teleport Enemy To You)",
    ["╨Я╤А╨╕╤В╤П╨│╨╕╨▓╨░╨╡╤В/╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨║╨╛╤А╨┐╤Г╤Б ╨▓╤А╨░╨│╨░ ╨┐╤А╤П╨╝╨╛ ╨┐╨╡╤А╨╡╨┤ ╨▓╨░╤И╨╕╨╝╨╕ ╨║╤Г╨╗╨░╨║╨░╨╝╨╕ ╨╕ ╨▒╤М╨╡╤В!"] = "Pulls/teleports the enemy body right in front of your fists and hits!",
    ["Mode 2: Magnet TP To Target (╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╨╛╨▓╨░╤В╤М╤Б╤П ╨║ ╨▓╤А╨░╨│╤Г)"] = "Mode 2: Magnet TP To Target (Teleport To Enemy)",
    ["╨Ь╨│╨╜╨╛╨▓╨╡╨╜╨╜╨╛ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╨░╤Б ╨╖╨░ ╤Б╨┐╨╕╨╜╤Г / ╨▓ ╨╗╨╕╤Ж╨╛ ╨▓╤А╨░╨│╤Г ╨╕ ╨╜╨░╨╜╨╛╤Б╨╕╤В ╤Г╨┤╨░╤А╤Л"] = "Instantly teleports you behind/in front of the enemy and strikes",
    ["Mode 3: Orbit Target (╨Ю╤А╨▒╨╕╤В╨░ ╨▓╨╛╨║╤А╤Г╨│ ╤Ж╨╡╨╗╨╕)"] = "Mode 3: Orbit Target (Circle Around Target)",
    ["╨Т╤А╨░╤Й╨░╨╡╤В╤Б╤П ╨┐╨╛ ╨║╤А╤Г╨│╤Г ╨▓╨╛╨║╤А╤Г╨│ ╤Ж╨╡╨╗╨╕ ╨╕ ╨╜╨░╨╜╨╛╤Б╨╕╤В ╤Б╨╡╤А╨╕╨╕ ╤Г╨┤╨░╤А╨╛╨▓"] = "Orbits around the target and lands hit combos",
    ["╨Р╨║╤В╨╕╨▓╨╕╤А╤Г╨╡╤В Kill Aura: ╨▒╤М╨╡╤В, ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╤А╨░╨│╨╛╨▓ ╨┐╤А╤П╨╝╨╛ ╨║ ╨▓╨░╨╝ ╨╕╨╗╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨║ ╨╜╨╕╨╝!"] = "Activates Kill Aura: hits, teleports enemies to you or you to them!",
    ["╨а╨░╨┤╨╕╤Г╤Б ╨▓ ╤Б╤В╤Г╨┤╨░╤Е ╨┤╨╗╤П ╨╛╨▒╨╜╨░╤А╤Г╨╢╨╡╨╜╨╕╤П ╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨░╤Ж╨╕╨╕ ╨▓╤А╨░╨│╨╛╨▓"] = "Radius in studs for detecting and teleporting enemies",
    ["╨Ч╨░╨┤╨╡╤А╨╢╨║╨░ ╤Г╨┤╨░╤А╨╛╨▓ ╨▓ ╨╝╨╕╨╗╨╗╨╕╤Б╨╡╨║╤Г╨╜╨┤╨░╤Е"] = "Strike delay in milliseconds",
    ["╨Ъ╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛ ╨╛╤В╨┐╤А╨░╨▓╨╗╤П╨╡╨╝╤Л╤Е ╨┐╨░╨║╨╡╤В╨╛╨▓ ╤Г╨┤╨░╤А╨╛╨▓ ╨╖╨░ ╨╕╤В╨╡╤А╨░╤Ж╨╕╤О"] = "Number of hit packets sent per iteration",
    ["╨Т╤Л╨▒╨╕╤А╨░╨╡╤В ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╡╨│╨╛ ╨║ ╨▓╨░╨╝ ╨╕╨│╤А╨╛╨║╨░ ╨▓ ╨║╨░╤З╨╡╤Б╤В╨▓╨╡ ╤Ж╨╡╨╗╨╕"] = "Selects the nearest player to you as a target",
    ["╨Я╤А╨╕╤В╤П╨│╨╕╨▓╨░╨╡╤В ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨│╨╛ ╨╕╨│╤А╨╛╨║╨░ ╨┐╤А╤П╨╝╨╛ ╨║ ╨▓╨░╤И╨╕╨╝ ╨║╤Г╨╗╨░╨║╨░╨╝"] = "Pulls the selected player right to your fists",
    ["╨Э╨╡╨┐╤А╨╡╤А╤Л╨▓╨╜╨╛ ╨▒╤М╨╡╤В ╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨│╨╛ ╨╕╨│╤А╨╛╨║╨░"] = "Continuously hits and teleports the selected player",
    ["╨Ч╨░╤Ж╨╕╨║╨╗╨╡╨╜╨╜╤Л╨╣ ╨░╨▓╤В╨╛-╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╨┐╨╛ ╨▓╤Б╨╡╨╝ ╨╕╨│╤А╨╛╨║╨░╨╝ ╤Б╨╡╤А╨▓╨╡╤А╨░ ╨╕ ╨╕╤Е ╤Г╨╜╨╕╤З╤В╨╛╨╢╨╡╨╜╨╕╨╡"] = "Looped auto-teleport across all server players and their elimination",
    ["╨Р╨▓╤В╨╛-╨▓╤Е╨╛╨┤ ╨╜╨░ Brawl ╤В╤Г╤А╨╜╨╕╤А╤Л ╤Б╨╡╤А╨▓╨╡╤А╨░ ╨╕ ╨╜╨╡╨╝╨╡╨┤╨╗╨╡╨╜╨╜╨░╤П ╨┐╨╛╨▒╨╡╨┤╨░"] = "Auto-joins server Brawl tournaments and wins instantly",
    ["╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨С╨╛╤Б╤Б╨░: ╨┐╨╛╨╖╨╕╤Ж╨╕╤П ╤Г ╨▒╨╛╤Б╤Б╨░ + ╨▒╨╡╨╖ ╤Г╤А╨╛╨╜╨░ ╨┐╨╛ ╨▓╨░╨╝ + ╨▒╤Л╤Б╤В╤А╨░╤П ╨░╤В╨░╨║╨░!"] = "Auto boss farm: positioned at the boss + no damage to you + fast attacks!",
    ["╨Ъ╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛ ╤Г╨┤╨░╤А╨╛╨▓ ╨┐╨╛ ╨▒╨╛╤Б╤Б╤Г ╨╖╨░ ╨╛╨┤╨╕╨╜ ╤Ж╨╕╨║╨╗"] = "Number of hits on the boss per cycle",
    ["╨Ю╤В╨║╨╗╤О╤З╨░╨╡╤В ╨║╨╛╨╗╨╗╨╕╨╖╨╕╨╕ ╤Г╤А╨╛╨╜╨░ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨░ (╨╖╨░╤Й╨╕╤В╨░ ╨╛╤В ╤З╤Г╨╢╨╕╤Е ╤Г╨┤╨░╤А╨╛╨▓)"] = "Disables damage collisions for your character (protection from enemy hits)",
    ["╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓ ╨╜╨╡╨▒╨╡╤Б╨╜╤Г╤О ╨╖╨╛╨╜╤Г ╨▒╨╡╨╖╨╛╨┐╨░╤Б╨╜╨╛╤Б╤В╨╕ ╨┐╤А╨╕ ╨┐╨░╨┤╨╡╨╜╨╕╨╕ HP ╨╜╨╕╨╢╨╡ 25%"] = "Automatically teleports to the sky safe zone when HP drops below 25%",
    ["╨Ч╨░╨┐╤А╨╡╤В ╨┐╨░╨┤╨╡╨╜╨╕╨╣ ╨╕ ╤Б╤В╨░╨╜╨╛╨▓"] = "Prevents ragdoll and stuns",
    ["╨Ю╤В╨║╨╗╤О╤З╨░╨╡╤В ╨╛╤В╨▒╤А╨░╤Б╤Л╨▓╨░╨╜╨╕╨╡ ╨┐╤А╨╕ ╤Г╨┤╨░╤А╨░╤Е"] = "Disables knockback from hits",
    ["╨б╨┐╨░╨▓╨╜╨╕╤В ╨╜╨╡╨▒╨╡╤Б╨╜╤Г╤О ╨┐╨╗╨░╤В╤Д╨╛╤А╨╝╤Г ╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╨░╤Б ╤В╤Г╨┤╨░"] = "Spawns a sky platform and teleports you there",
    ["╨б╨╛╤Е╤А╨░╨╜╤П╨╡╤В ╨▓╨░╤И╤Г ╤В╨╡╨║╤Г╤Й╤Г╤О ╨┐╨╛╨╖╨╕╤Ж╨╕╤О ╨▓ ╨┐╨░╨╝╤П╤В╤М"] = "Saves your current position to memory",
    ["╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨╜╨░ ╤А╨░╨╜╨╡╨╡ ╤Б╨╛╤Е╤А╨░╨╜╨╡╨╜╨╜╤Г╤О ╤В╨╛╤З╨║╤Г"] = "Teleports to the previously saved point",
    ["╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨║ ╨╕╨│╤А╨╛╨║╤Г ╤Б ╨╝╨░╨║╤Б╨╕╨╝╨░╨╗╤М╨╜╨╛╨╣ ╤Б╨╕╨╗╨╛╨╣ ╨╜╨░ ╤Б╨╡╤А╨▓╨╡╤А╨╡"] = "Teleports to the strongest player on the server",
    ["Auto Rebirth (╨С╨╡╤Б╨║╨╛╨╜╨╡╤З╨╜╤Л╨╣ ╨░╨▓╤В╨╛-╤А╨╡╨▒╨╕╤А╤В)"] = "Auto Rebirth (Infinite Auto-Rebirth)",
    ["╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╨▓╤Л╨┐╨╛╨╗╨╜╤П╨╡╤В ╨┐╨╡╤А╨╡╤А╨╛╨╢╨┤╨╡╨╜╨╕╨╡ ╤Б╤А╨░╨╖╤Г ╨┐╤А╨╕ ╨┤╨╛╤Б╤В╨╕╨╢╨╡╨╜╨╕╨╕ ╨╜╤Г╨╢╨╜╨╛╨│╨╛ ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨░ ╤Б╨╕╨╗╤Л"] = "Automatically rebirths as soon as the required strength is reached",
    ["Manual Rebirth (╨Я╨╡╤А╨╡╤А╨╛╨┤╨╕╤В╤М╤Б╤П ╨┐╤А╤П╨╝╨╛ ╤Б╨╡╨╣╤З╨░╤Б)"] = "Manual Rebirth (Rebirth Right Now)",
    ["╨Я╤А╨╕╨╜╤Г╨┤╨╕╤В╨╡╨╗╤М╨╜╨╛ ╨╖╨░╨┐╤А╨░╤И╨╕╨▓╨░╨╡╤В ╨┐╨╡╤А╨╡╤А╨╛╨╢╨┤╨╡╨╜╨╕╨╡ ╨╜╨░ ╤Б╨╡╤А╨▓╨╡╤А╨╡ ╤З╨╡╤А╨╡╨╖ ╨▓╤Б╨╡ ╨║╨░╨╜╨░╨╗╤Л"] = "Forcefully requests a rebirth on the server via all channels",
    ["╨Р╨▓╤В╨╛-╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╨┐╨╛ ╨▓╤Б╨╡╨╝ ╤Б╤Г╨╜╨┤╤Г╨║╨░╨╝ ╨║╨░╤А╤В╤Л ╨╕ ╨╕╤Е ╤Б╨▒╨╛╤А"] = "Auto-teleports to all map chests and collects them",
    ["╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╨┐╤А╨╕╤В╤П╨│╨╕╨▓╨░╨╡╤В/╤Б╨╛╨▒╨╕╤А╨░╨╡╤В ╤Б╤Д╨╡╤А╤Л ╤Б╨╛ ╨▓╤Б╨╡╨╣ ╨║╨░╤А╤В╤Л"] = "Automatically attracts/collects orbs from across the map",
    ["╨Р╨▓╤В╨╛-╨╛╤В╨║╤А╤Л╤В╨╕╨╡ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨░ ╤Б ╨┐╨╕╤В╨╛╨╝╤Ж╨░╨╝╨╕ (╨░╨▓╤В╨╛-╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╨▓╨┐╨╗╨╛╤В╨╜╤Г╤О)"] = "Auto-opens pet crystals (auto-teleport up close)",
    ["╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╨╛╨▒╤К╨╡╨┤╨╕╨╜╤П╨╡╤В ╨╛╨┤╨╕╨╜╨░╨║╨╛╨▓╤Л╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╨┤╨╗╤П ╤Н╨▓╨╛╨╗╤О╤Ж╨╕╨╕"] = "Automatically merges identical pets for evolution",
    ["╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╨╜╨░╨┤╨╡╨▓╨░╨╡╤В ╨╗╤Г╤З╤И╨╕╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡"] = "Automatically equips the best pets in your inventory",
    ["╨а╨╡╨╢╨╕╨╝ ╤Б╨▓╨╛╨▒╨╛╨┤╨╜╨╛╨│╨╛ ╨┐╨╛╨╗╨╡╤В╨░ Vortex"] = "Vortex free flight mode",
    ["╨б╨║╨╛╤А╨╛╤Б╤В╤М ╨┐╨╛╨╗╨╡╤В╨░ ╨▓ ╨▓╨╛╨╖╨┤╤Г╤Е╨╡"] = "Flight speed in the air",
    ["╨Ш╨╖╨╝╨╡╨╜╨╡╨╜╨╕╨╡ ╤Б╨║╨╛╤А╨╛╤Б╤В╨╕ ╤Е╨╛╨┤╤М╨▒╤Л"] = "Change walk speed",
    ["╨Ч╨╜╨░╤З╨╡╨╜╨╕╨╡ ╤Б╨║╨╛╤А╨╛╤Б╤В╨╕ ╤Е╨╛╨┤╤М╨▒╤Л"] = "Walk speed value",
    ["╨Ш╨╖╨╝╨╡╨╜╨╡╨╜╨╕╨╡ ╨▓╤Л╤Б╨╛╤В╤Л ╨┐╤А╤Л╨╢╨║╨░"] = "Change jump height",
    ["╨б╨╕╨╗╨░ ╨▓╤Л╤Б╨╛╤В╤Л ╨┐╤А╤Л╨╢╨║╨░"] = "Jump power value",
    ["╨Э╨░╤Б╤В╤А╨╛╨╣╨║╨░ ╨│╤А╨░╨▓╨╕╤В╨░╤Ж╨╕╨╕ ╨╕╨│╤А╨╛╨▓╨╛╨│╨╛ ╨╝╨╕╤А╨░"] = "Game world gravity setting",
    ["╨Я╤А╨╛╤Е╨╛╨┤ ╤Б╨║╨▓╨╛╨╖╤М ╤Б╤В╨╡╨╜╤Л ╨╕ ╨╛╨▒╤К╨╡╨║╤В╤Л"] = "Walk through walls and objects",
    ["╨С╨╡╤Б╨║╨╛╨╜╨╡╤З╨╜╤Л╨╡ ╨┐╤А╤Л╨╢╨║╨╕ ╨▓ ╨▓╨╛╨╖╨┤╤Г╤Е╨╡"] = "Infinite jumps in the air",
    ["╨Р╨▓╤В╨╛-╨┐╤А╤Л╨╢╨╛╨║ ╨┐╤А╨╕ ╨║╨░╤Б╨░╨╜╨╕╨╕ ╨╖╨╡╨╝╨╗╨╕"] = "Auto-jump when touching the ground",
    ["╨а╨╡╨╢╨╕╨╝ ╨╜╨░╨▒╨╗╤О╨┤╨╡╨╜╨╕╤П ╨╛╤В ╨┐╨╡╤А╨▓╨╛╨│╨╛/╤В╤А╨╡╤В╤М╨╡╨│╨╛ ╨╗╨╕╤Ж╨░ ╨╖╨░ ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨╣ ╤Ж╨╡╨╗╤М╤О"] = "First/third person spectate mode for the selected target",
    ["╨Я╨╛╨║╨░╨╖╤Л╨▓╨░╨╡╤В ╨╕╨╝╨╡╨╜╨░ ╨╕ ╨┤╨╕╤Б╤В╨░╨╜╤Ж╨╕╤О ╨┤╨╛ ╨╕╨│╤А╨╛╨║╨╛╨▓"] = "Shows names and distance to players",
    ["╨г╨▒╨╕╤А╨░╨╡╤В ╤В╨╡╨╜╨╕ ╨╜╨░ ╨║╨░╤А╤В╨╡ ╨╕ ╨▓╨║╨╗╤О╤З╨░╨╡╤В ╨┤╨╡╨╜╤М"] = "Removes map shadows and sets daytime",
    ["╨г╨│╨╛╨╗ ╨╛╨▒╨╖╨╛╤А╨░ ╨║╨░╨╝╨╡╤А╤Л"] = "Camera field of view",
    ["╨Я╨╡╤А╨╡╨╖╨░╨╣╤В╨╕ ╨╜╨░ ╤Н╤В╨╛╤В ╨╢╨╡ ╤Б╨╡╤А╨▓╨╡╤А"] = "Rejoin this same server",
    ["╨Я╨╛╨┤╨║╨╗╤О╤З╨╕╤В╤М╤Б╤П ╨║ ╤Б╨╗╤Г╤З╨░╨╣╨╜╨╛╨╝╤Г ╤Б╨╡╤А╨▓╨╡╤А╤Г"] = "Connect to a random server",
    ["╨Ъ╨╛╨┐╨╕╤А╤Г╨╡╤В ID ╤В╨╡╨║╤Г╤Й╨╡╨│╨╛ ╤Б╨╡╤А╨▓╨╡╤А╨░ ╨▓ ╨▒╤Г╤Д╨╡╤А ╨╛╨▒╨╝╨╡╨╜╨░"] = "Copies the current server ID to clipboard",
    ["Switch Theme (╨б╨╝╨╡╨╜╨╕╤В╤М ╨в╨╡╨╝╤Г)"] = "Switch Theme",
    ["Stay In Place After Rebirth (╨Э╨╡ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╛╨▓╨░╤В╤М ╨╜╨░ ╤Б╨┐╨░╨▓╨╜)"] = "Stay In Place After Rebirth",
    ["╨б╨╛╤Е╤А╨░╨╜╤П╨╡╤В ╨▓╨░╤И╤Г ╨┐╨╛╨╖╨╕╤Ж╨╕╤О ╨┤╨╛ ╨┐╨╡╤А╨╡╤А╨╛╨╢╨┤╨╡╨╜╨╕╤П ╨╕ ╨▓╨╛╨╖╨▓╤А╨░╤Й╨░╨╡╤В ╨▓╨░╤Б ╨╛╨▒╤А╨░╤В╨╜╨╛ ╨┐╨╛╤Б╨╗╨╡ ╨╜╨╡╨│╨╛"] = "Saves your position before rebirth and returns you there after it",
    ["MASS EGG HATCHER (╨Ф╨Ю 500 ╨Ч╨Р ╨а╨Р╨Ч)"] = "MASS EGG HATCHER (UP TO 500 AT ONCE)",
    ["Eggs Per Batch (1-500)"] = "Eggs Per Batch (1-500)",
    ["╨б╨║╨╛╨╗╤М╨║╨╛ ╤П╨╕╤Ж ╨╛╤В╨║╤А╤Л╨▓╨░╤В╤М ╨╖╨░ ╨╛╨┤╨╕╨╜ Mass Hatch (╨╝╨░╨║╤Б╨╕╨╝╤Г╨╝ 500)"] = "How many eggs to open per Mass Hatch (max 500)",
    ["╨Р╨▓╤В╨╛-╨╛╤В╨║╤А╤Л╤В╨╕╨╡ ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨│╨╛ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨░ ╨┐╨╛╨║╨░ ╨▓╨║╨╗╤О╤З╨╡╨╜╨╛ (╨╛╤Б╤В╨░╨╜╨╛╨▓╨║╨░ ╨┐╤А╨╕ ╨╛╤В╨║╨░╨╖╨╡ ╤Б╨╡╤А╨▓╨╡╤А╨░)"] = "Auto-opens the selected crystal while enabled (stops on server denial)",
    ["MASS HATCH (╨╛╤В╨║╤А╤Л╤В╤М ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨╡ ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛)"] = "MASS HATCH (open selected amount)",
    ["╨С╤Л╤Б╤В╤А╨╛ ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╤В ╨┤╨╛ 500 ╤П╨╕╤Ж ╨┐╨╛╨┤╤А╤П╨┤ ╤Б ╨┐╤А╨╛╨▓╨╡╤А╨║╨╛╨╣ ╨╝╨╡╤Б╤В ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡ ╨╕ ╨▓╨░╨╗╤О╤В╤Л"] = "Quickly opens up to 500 eggs in a row, checking inventory slots and currency",
    ["Hatch x10"] = "Hatch x10",
    ["╨С╤Л╤Б╤В╤А╨╛ ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╤В 10 ╤П╨╕╤Ж ╨┐╨╛╨┤╤А╤П╨┤"] = "Quickly opens 10 eggs in a row",
    ["Hatch x1"] = "Hatch x1",
    ["╨Ю╤В╨║╤А╤Л╨▓╨░╨╡╤В ╨╛╨┤╨╜╨╛ ╤П╨╣╤Ж╨╛"] = "Opens one egg",
    ["Stop Mass Hatch"] = "Stop Mass Hatch",
    ["╨Ю╤Б╤В╨░╨╜╨░╨▓╨╗╨╕╨▓╨░╨╡╤В ╨╕╨┤╤Г╤Й╨╡╨╡ ╨╝╨░╤Б╤Б╨╛╨▓╨╛╨╡ ╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡"] = "Stops the running mass hatch",
    ["CRYSTAL SELECTOR (╨Т╨л╨С╨Ю╨а ╨п╨Щ╨ж╨Р)"] = "CRYSTAL SELECTOR",
    ["╨Т╤Б╤В╨░╨╡╤В ╨╜╨░ ╨▒╨╗╨╕╨╢╨░╨╣╤И╤Г╤О ╨▒╨╡╨│╨╛╨▓╤Г╤О ╨┤╨╛╤А╨╛╨╢╨║╤Г ╨╕ ╨║╨░╤З╨░╨╡╤В ╨╗╨╛╨▓╨║╨╛╤Б╤В╤М!"] = "Steps onto the nearest treadmill and trains agility!",
    ["╨Р╨║╤В╨╕╨▓╨╕╤А╤Г╨╡╤В Kill Aura: ╨▒╤М╨╡╤В, ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╤А╨░╨│╨╛╨▓ ╨┐╤А╤П╨╝╨╛ ╨║ ╨▓╨░╨╝ ╨╕╨╗╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨║ ╨╜╨╕╨╝!"] = "Enables Kill Aura: hits enemies, dashes to them or pulls them into your fists!",
    ["╨Э╨░╤Б╤В╤А╨╛╨╣╨║╨╕, ╤П╨╖╤Л╨║ ╨╕ ╤В╨╡╨╝╤Л ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░"] = "Settings, language and UI themes",
    ["╨Ю╨▒╨╖╨╛╤А ╤Б╤В╨░╤В╨╕╤Б╤В╨╕╨║╨╕ ╨╕ ╨┐╤А╨╛╨│╤А╨╡╤Б╤Б╨░"] = "Stats and progress overview",
    ["╨в╤А╨╡╨╜╨░╨╢╤С╤А╤Л ╨╕ ╨░╨▓╤В╨╛-╤Д╨░╤А╨╝"] = "Gym machines and auto farm",
    ["╨Ъ╨░╨╝╨╜╨╕ ╨╕ ╤Б╨┐╨╛╤А╤В╨╖╨░╨╗╤Л"] = "Rocks and gyms",
    ["Kill Aura ╨╕ ╨╛╤Е╨╛╤В╨░ ╨╜╨░ ╨▒╨╛╤Б╤Б╨╛╨▓"] = "Kill Aura and boss hunting",
    ["╨Ч╨░╤Й╨╕╤В╨░ ╨╕ ╨▒╨╡╨╖╨╛╨┐╨░╤Б╨╜╨╛╤Б╤В╤М"] = "Protection and safety",
    ["╨в╨╛╤З╨║╨╕ ╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╤Л"] = "Waypoints and teleports",
    ["╨п╨╣╤Ж╨░ ╨╕ ╨░╨▓╤В╨╛-╨┤╨╡╨╣╤Б╤В╨▓╨╕╤П"] = "Eggs and auto actions",
    ["╨Я╨╕╤В╨╛╨╝╤Ж╤Л ╨╕ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╤М"] = "Pets and inventory",
    ["╨Ф╨▓╨╕╨╢╨╡╨╜╨╕╨╡ ╨╕ ESP"] = "Movement and ESP",
    ["╨Ш╨╜╨╕╤Ж╨╕╨░╨╗╨╕╨╖╨░╤Ж╨╕╤П ╤П╨┤╤А╨░..."] = "Initializing core...",
    ["╨Ч╨░╨│╤А╤Г╨╖╨║╨░ ╨╝╨╛╨┤╤Г╨╗╨╡╨╣..."] = "Loading modules...",
    ["╨Я╨╛╨┤╨│╨╛╤В╨╛╨▓╨║╨░ ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░..."] = "Preparing interface...",
    ["╨У╨╛╤В╨╛╨▓╨╛! ╨Ю╤В╨║╤А╤Л╨▓╨░╨╡╨╝ ╨╝╨╡╨╜╤О..."] = "Ready! Opening menu...",
    ["╨Ч╨░╨│╤А╤Г╨╖╨║╨░ ╨╖╨░╨▓╨╡╤А╤И╨╡╨╜╨░! ╨Ь╨╡╨╜╤О: [Right Shift]"] = "Loaded! Menu: [Right Shift]",
    -- ╨Ъ╨╛╤А╨╛╤В╨║╨╕╨╡ ╨╜╨░╨╖╨▓╨░╨╜╨╕╤П ╨▓╨║╨╗╨░╨┤╨╛╨║ (╨▒╨╡╨╖ ╨╕╨║╨╛╨╜╨╛╨║)
    ["╨Э╨░╤Б╤В╤А╨╛╨╣╨║╨╕"] = "Settings",
    ["╨У╨╗╨░╨▓╨╜╨░╤П"] = "Home",
    ["╨д╨░╤А╨╝"] = "Farm",
    ["╨Ъ╨░╨╝╨╜╨╕"] = "Rocks",
    ["╨С╨╛╨╣"] = "Combat",
    ["╨Ч╨░╤Й╨╕╤В╨░"] = "Protection",
    ["╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╤Л"] = "Teleports",
    ["╨Р╨▓╤В╨╛"] = "Auto",
    ["╨Я╨╕╤В╨╛╨╝╤Ж╤Л"] = "Pets",
    ["╨Ф╨▓╨╕╨╢╨╡╨╜╨╕╨╡"] = "Movement",
    ["╨Ч╨░╤Й╨╕╤В╨░ ╨╛╤В ╤Г╤А╨╛╨╜╨░ ╨╕ ╨░╨▓╤В╨╛-TP"] = "Damage protection and auto TP",
    ["╨Ъ╤А╨╕╤Б╤В╨░╨╗╨╗╤Л ╨╕ ╨░╨▓╤В╨╛-╨┤╨╡╨╣╤Б╤В╨▓╨╕╤П"] = "Crystals and auto actions",
    ["╨Ч╨░╨│╤А╤Г╨╖╨║╨░..."] = "Loading...",
    ["CRYSTAL SELECTOR (╨Т╨л╨С╨Ю╨а ╨Ъ╨а╨Ш╨б╨в╨Р╨Ы╨Ы╨Р)"] = "CRYSTAL SELECTOR (PICK A CRYSTAL)",
    ["╨Я╤А╨╛╨┤╨░╤В╤М ╨╛╨▒╤Л╤З╨╜╤Л╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓"] = "Sell Common Pets",
    ["╨Я╤А╨╛╨┤╨░╤С╤В ╨▓╤Б╨╡╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╤А╨░╤А╨╕╤В╨╡╤В╨░ Common, ╨╛╤Б╨▓╨╛╨▒╨╛╨╢╨┤╨░╤П ╨╝╨╡╤Б╤В╨░ ╨┤╨╗╤П ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨╛╨▓"] = "Sells all Common-rarity pets to free up slots for crystals",
    ["╨Ч╨░╨┤╨╡╤А╨╢╨║╨░ ╨╝╨╡╨╢╨┤╤Г ╨╛╤В╨║╤А╤Л╤В╨╕╤П╨╝╨╕ (0.01 ╤Б╨╡╨║)"] = "Open delay (0.01 sec)",
    ["12 = 0.12 ╤Б╨╡╨║╤Г╨╜╨┤╤Л ╨╝╨╡╨╢╨┤╤Г ╨╛╤В╨║╤А╤Л╤В╨╕╤П╨╝╨╕ (╨┤╨╕╨░╨┐╨░╨╖╨╛╨╜ 0.05тАУ1.00)"] = "12 = 0.12 seconds between openings (range 0.05тАУ1.00)",
    ["╨б╨╛╤Е╤А╨░╨╜╤П╨╡╤В ╨▓╤Б╨╡ ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨╕ Vortex ╨▓ ╨▒╤Г╤Д╨╡╤А ╨╛╨▒╨╝╨╡╨╜╨░"] = "Saves all Vortex settings to the clipboard",
    ["╨Ч╨░╨│╤А╤Г╨╢╨░╨╡╤В ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨╕ Vortex ╨╕╨╖ ╨▒╤Г╤Д╨╡╤А╨░ ╨╛╨▒╨╝╨╡╨╜╨░"] = "Loads Vortex settings from the clipboard",
    ["╨п╤А╨║╨╕╨╣ ╤Б╨╗╨╡╨┤ ╨╖╨░ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨╡╨╝ (╤Ж╨▓╨╡╤В ╨░╨║╤Ж╨╡╨╜╤В╨░ ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░)"] = "Bright trail behind your character (interface accent color)",
    ["╨Ф╨╗╨╕╨╜╨░ ╨╖╨░╤В╤Г╤Е╨░╨╜╨╕╤П ╤Б╨╗╨╡╨┤╨░ (0.2 - 2.0 ╤Б╨╡╨║╤Г╨╜╨┤╤Л)"] = "Trail fade length (0.2 - 2.0 seconds)",
    ["╨Э╨╡╨╛╨╜╨╛╨▓╨╛╨╡ ╨║╨╛╨╗╤М╤Ж╨╛ ╨┐╨╛╨┤ ╨╜╨╛╨│╨░╨╝╨╕ ╨┐╤А╨╕ ╨║╨░╨╢╨┤╨╛╨╝ ╨┐╤А╤Л╨╢╨║╨╡"] = "Neon ring under your feet on every jump",
    ["╨Т╨╗╨░╨┤╨╡╨╗╨╡╤Ж ╨╕ ╤А╨░╨╖╤А╨░╨▒╨╛╤В╤З╨╕╨║ ╤Б╨║╤А╨╕╨┐╤В╨░ Vortex"] = "Owner and developer of the Vortex script",
    ["╨Э╨░╨╢╨╝╨╕╤В╨╡, ╤З╤В╨╛╨▒╤Л ╤Б╨║╨╛╨┐╨╕╤А╨╛╨▓╨░╤В╤М Discord ╨▓╨╗╨░╨┤╨╡╨╗╤М╤Ж╨░ ╨▓ ╨▒╤Г╤Д╨╡╤А ╨╛╨▒╨╝╨╡╨╜╨░"] = "Click to copy the owner's Discord to clipboard",
}

KV.TextBindings = {}

-- value: ╤Б╤В╤А╨╛╨║╨░ ╨Ш╨Ы╨Ш ╤Д╤Г╨╜╨║╤Ж╨╕╤П, ╨▓╨╛╨╖╨▓╤А╨░╤Й╨░╤О╤Й╨░╤П ╤Б╤В╤А╨╛╨║╤Г (╨┤╨╗╤П ╨┤╨╕╨╜╨░╨╝╨╕╤З╨╡╤Б╨║╨╕╤Е ╨╜╨░╨┤╨┐╨╕╤Б╨╡╨╣)
KV.resolveText = function(value)
    if type(value) == "function" then
        local ok, res = pcall(value)
        value = (ok and res) or ""
    end
    if KV.Config.Language == "EN" and type(value) == "string" then
        local en = KV.LangDict[value]
        if en then return en end
    end
    return value
end

-- ╨а╨╡╨│╨╕╤Б╤В╤А╨╕╤А╤Г╨╡╤В TextLabel/TextButton ╨┤╨╗╤П ╨╢╨╕╨▓╨╛╨│╨╛ ╨╛╨▒╨╜╨╛╨▓╨╗╨╡╨╜╨╕╤П ╨┐╤А╨╕ ╤Б╨╝╨╡╨╜╨╡ ╤П╨╖╤Л╨║╨░
KV.bindText = function(inst, getter)
    table.insert(KV.TextBindings, {inst = inst, get = getter})
    pcall(function() inst.Text = getter() end)
end

KV.applyLanguage = function()
    for _, binding in ipairs(KV.TextBindings) do
        local inst = binding.inst
        if inst and inst.Parent then
            local ok, txt = pcall(binding.get)
            if ok then inst.Text = txt end
        end
    end
end

KV.AccentColor = Color3.fromRGB(201, 180, 255) -- ╨╗╨░╨▓╨░╨╜╨┤╨░ тАФ ╨║╨░╨║ ╨╜╨░ ╤А╨╡╤Д╨╡╤А╨╡╨╜╤Б╨╡ Silicate

KV.AccentPresets = {
    {name = "Lavender", color = Color3.fromRGB(201, 180, 255)},
    {name = "Silver",  color = Color3.fromRGB(236, 236, 240)},
    {name = "Teal",    color = Color3.fromRGB(45, 212, 191)},
    {name = "Purple",  color = Color3.fromRGB(168, 85, 247)},
    {name = "Red",     color = Color3.fromRGB(248, 113, 113)},
    {name = "Blue",    color = Color3.fromRGB(96, 165, 250)},
    {name = "Green",   color = Color3.fromRGB(74, 222, 128)},
    {name = "Pink",    color = Color3.fromRGB(244, 114, 182)},
    {name = "Amber",   color = Color3.fromRGB(251, 191, 36)},
}

-- ╨в╨╡╨╝╤Л ╨╛╨║╨╜╨░: ╨╡╨┤╨╕╨╜╤Л╨╣ near-black ╤Д╨╛╨╜ (╨╛╨║╨╜╨╛ = ╤Б╨░╨╣╨┤╨▒╨░╤А = ╤И╨░╨┐╨║╨░), ╨║╨░╤А╤В╨╛╤З╨║╨╕ ╤З╤Г╤В╤М ╤Б╨▓╨╡╤В╨╗╨╡╨╡.
KV.UIThemes = {
    {name = "Black",     window = Color3.fromRGB(11, 11, 13),    panel = Color3.fromRGB(24, 24, 27),    bar = Color3.fromRGB(11, 11, 13),    side = Color3.fromRGB(11, 11, 13),    accent = Color3.fromRGB(201, 180, 255)},
    {name = "Slate",     window = Color3.fromRGB(15, 17, 20),    panel = Color3.fromRGB(27, 30, 35),    bar = Color3.fromRGB(15, 17, 20),    side = Color3.fromRGB(15, 17, 20),    accent = Color3.fromRGB(148, 163, 184)},
    {name = "Midnight",  window = Color3.fromRGB(10, 12, 20),    panel = Color3.fromRGB(20, 24, 38),    bar = Color3.fromRGB(10, 12, 20),    side = Color3.fromRGB(10, 12, 20),    accent = Color3.fromRGB(96, 165, 250)},
    {name = "Crimson",   window = Color3.fromRGB(17, 11, 12),    panel = Color3.fromRGB(30, 19, 20),    bar = Color3.fromRGB(17, 11, 12),    side = Color3.fromRGB(17, 11, 12),    accent = Color3.fromRGB(248, 113, 113)},
    {name = "Cyberpunk", window = Color3.fromRGB(8, 11, 14),     panel = Color3.fromRGB(18, 24, 27),    bar = Color3.fromRGB(8, 11, 14),     side = Color3.fromRGB(8, 11, 14),     accent = Color3.fromRGB(45, 212, 191)},
}

KV.currentTheme = function()
    return KV.UIThemes[KV.Config.ThemeIndex] or KV.UIThemes[1]
end

KV.rockTiers = {
    {"Tiny Rock", "0 Rebirths / 0 Str", "tiny"},
    {"Punching Rock", "0 Rebirths / 100 Str", "punching"},
    {"Large Rock", "0 Rebirths / 5K Str", "large"},
    {"Frost Rock", "5 Rebirths / 150K Str", "frost"},
    {"Mythic Rock", "15 Rebirths / 400K Str", "mythic"},
    {"Jungle Rock", "60 Rebirths / 750K Str", "jungle"},
    {"Industrial Rock", "150 Rebirths / 1M Str", "industrial"},
    {"Eternal Rock", "300 Rebirths / 5M Str", "eternal"},
    {"Legend Rock", "3,000 Rebirths / 10M Str", "legend"},
    {"Muscle King Rock", "30,000 Rebirths / 50M Str", "king"},
}

KV.crystalsList = {
    "Blue Crystal", "Green Crystal", "Frost Crystal", "Mythic Crystal", "Infernal Crystal", "Galaxy Crystal",
    "Overcharged Crystal"
}

-- ============================================================
-- ╨г╨в╨Ш╨Ы╨Ш╨в╨л ╨Ш ╨Т╨б╨Я╨Ю╨Ь╨Ю╨У╨Р╨в╨Х╨Ы╨м╨Э╨л╨Х ╨д╨г╨Э╨Ъ╨ж╨Ш╨Ш Vortex
-- ============================================================
KV.round = function(n) return math.floor(n + 0.5) end

KV.applyCorner = function(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = inst
    return c
end

KV.applyStroke = function(inst, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255,255,255)
    s.Transparency = transparency or 0.9
    s.Thickness = thickness or 1
    s.Parent = inst
    return s
end

KV.tw = function(inst, props, dur, style, direction)
    return TweenService:Create(inst, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props)
end

KV.notify = function(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Vortex ",
            Text = message or "",
            Duration = duration or 4
        })
    end)
end

-- ╨Ш╨│╤А╨╛╨▓╨░╤П ╨╝╨╛╨┤╨╡╨╗╤М ╨╕ ╨╕╨▓╨╡╨╜╤В╤Л Muscle Legends
KV.getMuscleEvent = function()
    return LocalPlayer:FindFirstChild("muscleEvent") or ReplicatedStorage:FindFirstChild("muscleEvent")
end

-- ╨Ы╨╡╨╜╨╕╨▓╤Л╨╣ ╨┤╨╛╤Б╤В╤Г╨┐ ╨║ ╤А╨╡╨╝╨╛╤Г╤В╨░╨╝ ╨┐╨░╨┐╨║╨╕ ReplicatedStorage.rEvents
KV.getREvent = function(name)
    local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
    if not rEvents then return nil end
    local r = rEvents:FindFirstChild(name)
    if r then return r end
    r = rEvents:WaitForChild(name, 5)
    return r
end

-- ╨Ь╨╛╨┤╤Г╨╗╤М GlobalFunctions ╨╕╨│╤А╤Л (╨┐╤А╨╛╨▓╨╡╤А╨║╨░ ╤В╤А╨╡╨▒╨╛╨▓╨░╨╜╨╕╨╣ ╤В╤А╨╡╨╜╨░╨╢╤С╤А╨╛╨▓ ╨╕ ╤В.╨┐.)
KV._globalFunctions = nil
KV.getGlobalFunctions = function()
    if KV._globalFunctions ~= nil then return KV._globalFunctions or nil end
    local ok, mod = pcall(function()
        local shared = ReplicatedStorage:WaitForChild("shared", 5)
        local modules = shared and shared:WaitForChild("modules", 5)
        return require(modules.GlobalFunctions)
    end)
    KV._globalFunctions = ok and mod or false
    return KV._globalFunctions or nil
end

-- ╨в╨╡╨║╤Г╤Й╨╕╨╣ ╨╖╨░╨╜╤П╤В╤Л╨╣ ╤В╤А╨╡╨╜╨░╨╢╤С╤А (╨╖╨╜╨░╤З╨╡╨╜╨╕╨╡ Value ╤Г LocalPlayer.machineInUse)
KV.getMachineInUse = function()
    local v = LocalPlayer:FindFirstChild("machineInUse")
    if v then return v.Value end
    return nil
end

KV.leaveMachine = function()
    pcall(function()
        local remote = KV.getREvent("machineInteractRemote")
        if remote and remote:IsA("RemoteFunction") then
            remote:InvokeServer("leaveMachine")
        end
    end)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = false end
    end)
end

-- ============================================================
-- ╨Ш╨Э╨Т╨Х╨Э╨в╨Р╨а╨м ╨Я╨Ш╨в╨Ю╨Ь╨ж╨Х╨Т: ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛, ╨▓╨╝╨╡╤Б╤В╨╕╨╝╨╛╤Б╤В╤М, ╤Б╨▓╨╛╨▒╨╛╨┤╨╜╤Л╨╡ ╨╝╨╡╤Б╤В╨░
-- ============================================================
KV.CAPACITY_SEARCH_NAMES = {
    "ItemCapacity", "itemCapacity", "Capacity", "capacity",
    "MaxItems", "maxItems", "PetCapacity", "petCapacity",
    "MaxPets", "maxPets", "StorageSize", "storageSize",
}

KV.countOwnedPets = function()
    local n = 0
    local pf = LocalPlayer:FindFirstChild("petsFolder")
    if pf then
        for _, rarityFolder in pairs(pf:GetChildren()) do
            n = n + #rarityFolder:GetChildren()
        end
    end
    return n
end

-- ╨б╨╜╨╕╨╝╨╛╨║ ╨▓╤Б╨╡╤Е ╨╛╨▒╤К╨╡╨║╤В╨╛╨▓ ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡ ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ (╨┤╨╗╤П ╤З╨╡╤Б╤В╨╜╨╛╨╣ ╨┐╤А╨╛╨▓╨╡╤А╨║╨╕, ╤З╤В╨╛ ╨┐╨╕╤В╨╛╨╝╨╡╤Ж ╨┐╨╛╤П╨▓╨╕╨╗╤Б╤П)
KV.petSnapshot = function()
    local pf = LocalPlayer:FindFirstChild("petsFolder")
    if not pf then return nil end
    local set = {}
    local n = 0
    for _, d in ipairs(pf:GetDescendants()) do
        set[d] = true
        n = n + 1
    end
    return set, n
end

-- ╨Я╨╛╤П╨▓╨╕╨╗╤Б╤П ╨╗╨╕ ╤Е╨╛╤В╤М ╨╛╨┤╨╕╨╜ ╨╜╨╛╨▓╤Л╨╣ ╨╛╨▒╤К╨╡╨║╤В ╨┐╨╛╤Б╨╗╨╡ ╤Б╨╜╨╕╨╝╨║╨░: true/false, nil тАФ ╨┐╤А╨╛╨▓╨╡╤А╨╕╤В╤М ╨╜╨╡╤З╨╡╨╝
KV.petGainedSince = function(snapshot)
    if not snapshot then return nil end
    local pf = LocalPlayer:FindFirstChild("petsFolder")
    if not pf then return nil end
    for _, d in ipairs(pf:GetDescendants()) do
        if not snapshot[d] then return true end
    end
    return false
end

-- ╨Т╨╡╤А╨╕╤Д╨╕╨║╨░╤В╨╛╤А ╨╛╨┤╨╜╨╛╨│╨╛ ╨╛╤В╨║╤А╤Л╤В╨╕╤П: true тАФ ╨╛╤В╨║╤А╤Л╤В╨╛, false тАФ ╨╜╨╡ ╨╛╤В╨║╤А╤Л╤В╨╛, nil тАФ ╨┐╤А╨╛╨▓╨╡╤А╨╕╤В╤М ╨╜╨╡╤З╨╡╨╝
KV.makeOpenVerifier = function(crystalName)
    local snap, seenBefore = KV.petSnapshot()
    local price, kind = KV.getCrystalPrice(crystalName)
    local bal = nil
    if price and price > 0 then
        bal = KV.getCurrency(kind)
    end
    -- ╨╜╨░╨┤╤С╨╢╨╜╨░╤П ╨┐╤А╨╛╨▓╨╡╤А╨║╨░ = ╨▓╨╕╨┤╨╜╨░ ╨┐╨░╨┐╨║╨░ ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╨Ш╨Ы╨Ш ╤З╨╕╤В╨░╨╡╤В╤Б╤П ╨▒╨░╨╗╨░╨╜╤Б ╤Ж╨╡╨╜╤Л
    local reliable = (snap ~= nil) or bal ~= nil
    if not reliable then
        return function() return nil end
    end
    return function()
        if KV.petGainedSince(snap) == true then return true end
        if bal ~= nil then
            local now = KV.getCurrency(kind)
            if now ~= nil and now < bal then return true end
        end
        return false
    end
end

KV.detectItemCapacity = function()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    for _, name in ipairs(KV.CAPACITY_SEARCH_NAMES) do
        local child = LocalPlayer:FindFirstChild(name)
        if child and child:IsA("ValueBase") then
            local v = tonumber(child.Value)
            if v and v > 0 then return v end
        end
        local leaderChild = ls and ls:FindFirstChild(name)
        if leaderChild and leaderChild:IsA("ValueBase") then
            local v = tonumber(leaderChild.Value)
            if v and v > 0 then return v end
        end
        local attr = LocalPlayer:GetAttribute(name)
        if attr ~= nil then
            local v = tonumber(attr)
            if v and v > 0 then return v end
        end
    end
    -- ╨Я╤А╨╛╨▒╨░ Data-╨╝╨╛╨┤╤Г╨╗╤П ╨╕╨│╤А╤Л (ReplicatorClient), ╨║╨░╨║ ╨▓ open-source ╤Б╨║╤А╨╕╨┐╤В╨╡
    local ok, Data = pcall(function()
        local packages = ReplicatedStorage:WaitForChild("packages", 3)
        local mod = packages and packages:WaitForChild("ReplicatorClient", 3)
        return require(mod).get("Data")
    end)
    if ok and Data and Data.TryIndex then
        local keys = {
            "inventoryCapacity", "itemCapacity", "petCapacity", "maxPets",
            "capacity", "inventorySize", "maxItems", "petSlots", "maxPetSlots",
        }
        for _, key in ipairs(keys) do
            local ok2, v = pcall(function() return Data:TryIndex(key) end)
            if ok2 and type(v) == "number" and v > 0 then return math.floor(v) end
        end
        local paths = {
            {"inventory", "capacity"}, {"pets", "capacity"},
            {"inventory", "max"}, {"inventory", "maxPets"},
        }
        for _, path in ipairs(paths) do
            local ok2, v = pcall(function() return Data:TryIndex(path[1], path[2]) end)
            if ok2 and type(v) == "number" and v > 0 then return math.floor(v) end
        end
    end
    return nil
end

-- free, owned, capacity (capacity/free = nil, ╨╡╤Б╨╗╨╕ ╨▓╨╝╨╡╤Б╤В╨╕╨╝╨╛╤Б╤В╤М ╨╜╨░╨╣╤В╨╕ ╨╜╨╡ ╤Г╨┤╨░╨╗╨╛╤Б╤М)
KV.freePetSlots = function()
    local owned = KV.countOwnedPets()
    local cap = KV.detectItemCapacity()
    if cap then
        return math.max(0, cap - owned), owned, cap
    end
    return nil, owned, nil
end

-- ╨С╨░╨╗╨░╨╜╤Б ╨▓╨░╨╗╤О╤В╤Л: "Gems" (╨┐╨╛ ╤Г╨╝╨╛╨╗╤З╨░╨╜╨╕╤О) ╨╕╨╗╨╕ "Tokens"
KV.getCurrency = function(kind)
    local name = (kind == "Tokens") and "Tokens" or "Gems"
    local v = LocalPlayer:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    v = ls and ls:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    return nil
end

-- ============================================================
-- ╨Я╨Ю╨Ш╨б╨Ъ ╨Ш ╨Э╨Р╨Ф╨Х╨Ц╨Э╨л╨Щ ╨д╨Р╨а╨Ь ╨Ъ╨Р╨Ь╨Э╨п (Rock Farming Engine)
-- ============================================================
KV.getTargetRockPart = function(tierKeyword)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local bestRock, minDist = nil, math.huge

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("BasePart") then
            local nameLower = string.lower(v.Name)
            if string.find(nameLower, "rock") then
                local part = v:IsA("BasePart") and v or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))
                if part then
                    local isMatch = false
                    if tierKeyword == "Any" then
                        isMatch = true
                    elseif string.find(nameLower, string.lower(tierKeyword)) then
                        isMatch = true
                    end

                    if isMatch then
                        local dist = (part.Position - myPos).Magnitude
                        if dist < minDist then
                            minDist = dist
                            bestRock = part
                        end
                    end
                end
            end
        end
    end
    return bestRock
end

-- ============================================================
-- ╨Э╨Р╨Ф╨Х╨Ц╨Э╨Ю╨Х ╨Ю╨в╨Ъ╨а╨л╨в╨Ш╨Х ╨Ъ╨а╨Ш╨б╨в╨Р╨Ы╨Ы╨Ю╨Т / ╨п╨Ш╨ж
-- ============================================================
KV.teleportToCrystal = function(crystalName)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myHrp = char.HumanoidRootPart

    local crystalObj = nil
    local terms = { string.lower(crystalName) }
    local firstWord = string.match(crystalName, "^%s*(%S+)")
    if firstWord and string.lower(firstWord) ~= terms[1] then
        table.insert(terms, string.lower(firstWord))
    end
    -- ╤Б╨╜╨░╤З╨░╨╗╨░ ╤В╨╛╤З╨╜╨╛╨╡ ╤Б╨╛╨▓╨┐╨░╨┤╨╡╨╜╨╕╨╡ ╨┐╨╛╨╗╨╜╨╛╨│╨╛ ╨╕╨╝╨╡╨╜╨╕, ╨╖╨░╤В╨╡╨╝ ╨┐╨╛ ╨┐╨╡╤А╨▓╨╛╨╝╤Г ╤Б╨╗╨╛╨▓╤Г
    for _, term in ipairs(terms) do
        for _, v in pairs(Workspace:GetDescendants()) do
            if (v:IsA("Model") or v:IsA("BasePart")) and term ~= "" and string.find(string.lower(v.Name), term, 1, true) then
                crystalObj = v:IsA("BasePart") and v or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))
                if crystalObj then break end
            end
        end
        if crystalObj then break end
    end

    if crystalObj then
        pcall(function()
            myHrp.CFrame = crystalObj.CFrame * CFrame.new(0, 2, 3)
        end)
    end
end

-- ╨Ю╨┤╨╜╨╛ ╨╛╤В╨║╤А╤Л╤В╨╕╨╡ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨░ ╤Б ╨з╨Х╨б╨в╨Э╨Ю╨Щ ╨┐╤А╨╛╨▓╨╡╤А╨║╨╛╨╣: ╤Г╤Б╨┐╨╡╤Е = ╨┐╨╕╤В╨╛╨╝╨╡╤Ж ╤А╨╡╨░╨╗╤М╨╜╨╛ ╨┐╨╛╤П╨▓╨╕╨╗╤Б╤П ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡.
-- ╨Т╨╛╨╖╨▓╤А╨░╤Й╨░╨╡╤В:
--   true,  petName, rarity  тАФ ╨┐╨╕╤В╨╛╨╝╨╡╤Ж ╨┤╨╛╨▒╨░╨▓╨╕╨╗╤Б╤П (╨┐╤А╨╛╨▓╨╡╤А╨╡╨╜╨╛ ╨┐╨╛ ╤Б╤З╤С╤В╤З╨╕╨║╤Г ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╤П)
--   false, "denied"         тАФ ╤Б╨╡╤А╨▓╨╡╤А ╨╛╤В╨║╨░╨╖╨░╨╗ (╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╤М ╨┐╨╛╨╗╨╛╨╜ / ╨╜╨╡ ╤Е╨▓╨░╤В╨░╨╡╤В ╨▓╨░╨╗╤О╤В╤Л)
--   false, "nogrow"         тАФ ╤Б╨╡╤А╨▓╨╡╤А ╨╛╤В╨▓╨╡╤В╨╕╨╗, ╨╜╨╛ ╨┐╨╕╤В╨╛╨╝╨╡╤Ж ╨╜╨╡ ╨┐╨╛╤П╨▓╨╕╨╗╤Б╤П
--   false, "invokefail"     тАФ ╨▓╤Л╨╖╨╛╨▓ ╤А╨╡╨╝╨╛╤Г╤В╨░ ╤Г╨┐╨░╨╗
--   false, "noremote"       тАФ ╨╜╨╕ ╤А╨╡╨╝╨╛╤Г╤В╨░, ╨╜╨╕ ╤Б╨╛╨▒╤Л╤В╨╕╤П ╨┤╨╗╤П ╨╛╤В╨║╤А╤Л╤В╨╕╤П ╨╜╨╡╤В
KV.openCrystalOnce = function(crystalName)
    local verify = KV.makeOpenVerifier(crystalName)

    -- ╨Ц╨┤╤С╨╝ ╨┐╨╛╨┤╤В╨▓╨╡╤А╨╢╨┤╨╡╨╜╨╕╤П ╨╛╤В╨║╤А╤Л╤В╨╕╤П: true тАФ ╨┐╨╛╨┤╤В╨▓╨╡╤А╨╢╨┤╨╡╨╜╨╛, false тАФ ╨╜╨╡╤В, nil тАФ ╨┐╤А╨╛╨▓╨╡╤А╨╕╤В╤М ╨╜╨╡╤З╨╡╨╝
    local function waitGained(timeout)
        if verify() == nil then return nil end -- ╨▓╨╡╤А╨╕╤Д╨╕╨║╨░╤Ж╨╕╤П ╨╜╨╡╨┤╨╛╤Б╤В╤Г╨┐╨╜╨░ тАФ ╨╜╨╡ ╤В╤А╨░╤В╨╕╨╝ ╨▓╤А╨╡╨╝╤П
        local steps = math.ceil((timeout or 1) / 0.05)
        for _ = 1, steps do
            if verify() == true then return true end
            task.wait(0.05)
        end
        return verify()
    end

    local function decodeResponse(a, b)
        local petName, rarity
        if type(a) == "string" then
            petName, rarity = a, b
        elseif a == true and type(b) == "string" then
            petName, rarity = b, nil
        elseif type(a) == "table" then
            petName = a.name or a.pet or a[1]
            rarity = a.rarity
        elseif typeof(a) == "Instance" then
            petName = a.Name
            rarity = b
        elseif type(a) == "number" then
            petName, rarity = tostring(a), b
        end
        return petName, rarity
    end

    local claimedName, claimedRarity = nil, nil
    local hadRemote = false
    local remote = nil
    pcall(function()
        remote = KV.getREvent("openCrystalRemote")
    end)
    if remote and remote:IsA("RemoteFunction") then
        hadRemote = true
        local ok, a, b = pcall(function()
            return remote:InvokeServer("openCrystal", crystalName)
        end)
        if not ok then
            return false, "invokefail"
        end
        claimedName, claimedRarity = decodeResponse(a, b)
    end

    local gained = waitGained(2)
    if gained == true then
        return true, claimedName or KV.tn("╨┐╨╕╤В╨╛╨╝╨╡╤Ж", "pet"), claimedRarity
    end
    if gained == nil then
        -- ╨┐╤А╨╛╨▓╨╡╤А╨╕╤В╤М ╨┐╨╛╤П╨▓╨╗╨╡╨╜╨╕╨╡ ╨╜╨╡╤З╨╡╨╝ тАФ ╨┤╨╛╨▓╨╡╤А╤П╨╡╨╝ ╨╛╤В╨▓╨╡╤В╤Г ╤Б╨╡╤А╨▓╨╡╤А╨░
        if claimedName then return true, tostring(claimedName), claimedRarity end
        if hadRemote then return false, "denied" end
    end

    if claimedName then
        -- ╨б╨╡╤А╨▓╨╡╤А ╨╖╨░╤П╨▓╨╕╨╗ ╨╛╨▒ ╤Г╤Б╨┐╨╡╤Е╨╡: ╨╢╨┤╤С╨╝ ╨╡╤Й╤С ╨╜╨╡╨╝╨╜╨╛╨│╨╛, ╨Э╨Х ╨┤╨╡╨╗╨░╤П ╨╜╨╛╨▓╤Л╤Е ╨▓╤Л╨╖╨╛╨▓╨╛╨▓,
        -- ╤З╤В╨╛╨▒╤Л ╨╜╨╡ ╤Б╨┐╨╕╤Б╨░╤В╤М ╨▓╨░╨╗╤О╤В╤Г ╨┤╨▓╨░╨╢╨┤╤Л ╨╖╨░ ╨╛╨┤╨╜╨╛ ╤П╨╣╤Ж╨╛
        if waitGained(1.5) == true then
            return true, tostring(claimedName), claimedRarity
        end
        return false, "nogrow"
    end

    -- ╨Ш╨╝╤П ╨╜╨╡ ╨▓╨╡╤А╨╜╤Г╨╗╨╛╤Б╤М: ╤Б╨╜╨░╤З╨░╨╗╨░ ╤В╨╛╤З╨╜╨░╤П ╨┐╤А╨╕╤З╨╕╨╜╨░ (╨▓╨░╨╗╤О╤В╨░ / ╨╝╨╡╤Б╤В╨░ ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡)
    local price, kind = KV.getCrystalPrice(crystalName)
    if price and price > 0 then
        local bal = KV.getCurrency(kind)
        if bal ~= nil and bal < price then return false, "denied" end
    end
    local free = KV.freePetSlots()
    if free ~= nil and free <= 0 then return false, "denied" end

    -- ╨Я╨╕╤В╨╛╨╝╨╡╤Ж ╨╜╨╡ ╨┐╨╛╤П╨▓╨╕╨╗╤Б╤П: ╨┐╤А╨╛╨▒╤Г╨╡╨╝ ╤Б╤В╨░╤А╤Г╤О ╤Б╤Е╨╡╨╝╤Г ╤Г ╤Б╨░╨╝╨╛╨│╨╛ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨░
    -- (╨╛╨┤╨╕╨╜ ╤А╨░╨╖ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╨╝╤Б╤П ╨║ ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨╝╤Г ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╤Г, ╨┤╨░╨╗╤М╤И╨╡ ╨┤╨╡╤А╨╢╨╕╨╝╤Б╤П ╤А╤П╨┤╨╛╨╝)
    local ev = KV.getMuscleEvent()
    if ev then
        if KV.crystalProximityFor ~= crystalName then
            KV.crystalProximityFor = crystalName
            pcall(KV.teleportToCrystal, crystalName)
            task.wait(0.25)
        end
        pcall(function() ev:FireServer("openCrystal", crystalName) end)
        pcall(function() ev:FireServer("crys", crystalName) end)
        pcall(function() ev:FireServer("openEgg", crystalName) end)
        gained = waitGained(2)
        if gained == true then
            return true, KV.tn("╨┐╨╕╤В╨╛╨╝╨╡╤Ж", "pet"), nil
        end
        if gained == nil then
            -- ╨┐╤А╨╛╨▓╨╡╤А╨╕╤В╤М ╨┐╨╛╤П╨▓╨╗╨╡╨╜╨╕╨╡ ╨╜╨╡╤З╨╡╨╝ тАФ ╨┤╨╛╨▓╨╡╤А╤П╨╡╨╝ ╤Б╨╛╨▒╤Л╤В╨╕╤О (╨║╨░╨║ ╨▓ ╨┐╤А╨╡╨╢╨╜╨╕╤Е ╨▓╨╡╤А╤Б╨╕╤П╤Е)
            return true, KV.tn("╨┐╨╕╤В╨╛╨╝╨╡╤Ж", "pet"), nil
        end
        return false, "nogrow"
    end

    if hadRemote then return false, "nogrow" end
    return false, "noremote"
end

KV.hatchCrystal = function(crystalName)
    -- ╨Ю╤В╨║╤А╤Л╤В╨╕╨╡ ╤Б╤В╤А╨╛╨│╨╛ ╨┤╨╕╤Б╤В╨░╨╜╤Ж╨╕╨╛╨╜╨╜╨╛ тАФ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╨╜╨╡ ╨╕╤Б╨┐╨╛╨╗╤М╨╖╤Г╨╡╤В╤Б╤П
    return KV.openCrystalOnce(crystalName)
end

-- ============================================================
-- ╨г╨Ь╨Э╨л╨Щ ╨в╨Х╨Ы╨Х╨Я╨Ю╨а╨в Vortex (Smart Teleport Engine)
-- ============================================================
KV.islandDatabase = {
    ["Spawn Beach"]      = {pos = Vector3.new(0, 10, 0),       keywords = {"spawn", "beach"}},
    ["Tiny Island"]      = {pos = Vector3.new(-39, 10, 1860),  keywords = {"tiny"}},
    ["Legend Beach"]     = {pos = Vector3.new(0, 10, -4000),   keywords = {"legend beach"}},
    ["Frost Gym"]        = {pos = Vector3.new(-2569, 12, -474), keywords = {"frost", "frozen"}},
    ["Mythic Gym"]       = {pos = Vector3.new(2250, 12, 1070),  keywords = {"mythic"}},
    ["Jungle Gym"]       = {pos = Vector3.new(-2500, 15, 2350), keywords = {"jungle"}},
    ["Industrial Gym"]   = {pos = Vector3.new(-4560, 995, -3000),keywords = {"industrial"}},
    ["Eternal Gym"]      = {pos = Vector3.new(-6730, 12, -1280),keywords = {"eternal"}},
    ["Legend Gym"]       = {pos = Vector3.new(4400, 995, -4000),keywords = {"legend gym"}},
    ["Muscle King Gym"]  = {pos = Vector3.new(-8550, 20, -5700),keywords = {"muscle king"}},
    ["Overcharged Gym"]  = {pos = Vector3.new(-7050, 20, -1350),keywords = {"overcharged"}},
    -- ╨Т╤А╨╡╨╝╨╡╨╜╨╜╨░╤П (╤Б╨╛╨▒╤Л╤В╨╕╨╣╨╜╨░╤П) ╨╖╨╛╨╜╨░: ╨▒╨╡╨╖ ╤Д╨╕╨║╤Б╨╕╤А╨╛╨▓╨░╨╜╨╜╨╛╨╣ ╨┐╨╛╨╖╨╕╤Ж╨╕╨╕ тАФ ╨╕╤Й╨╡╨╝ ╨┐╨╛ ╨╕╨╝╨╡╨╜╨╕ ╨▓ ╨╝╨╕╤А╨╡
    ["Temporary Zone"]   = {pos = nil, keywords = {"temporary zone", "temporary", "temp zone", "event zone", "eventzone", "limited time", "╨▓╤А╨╡╨╝╨╡╨╜╨╜╨░╤П"}},
}

KV.safeTeleport = function(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hum and hrp then
        if hum.Sit then
            hum.Sit = false
            task.wait(0.1)
        end

        local platform = Instance.new("Part")
        platform.Size = Vector3.new(12, 1, 12)
        platform.Position = targetCFrame.Position - Vector3.new(0, 3.5, 0)
        platform.Anchored = true
        platform.Transparency = 1
        platform.CanCollide = true
        platform.Parent = Workspace

        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)

        task.wait(0.05)
        hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

        task.delay(3, function()
            pcall(function() platform:Destroy() end)
        end)
    end
end

KV.smartTeleportToIsland = function(islandName)
    local data = KV.islandDatabase[islandName]
    local targetPos = data and data.pos or nil

    local foundPart = nil
    if data and data.keywords then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local objName = string.lower(obj.Name)
                for _, kw in ipairs(data.keywords) do
                    if string.find(objName, kw) then
                        foundPart = obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                        if foundPart then break end
                    end
                end
            end
            if foundPart then break end
        end
    end

    if foundPart then
        KV.safeTeleport(foundPart.CFrame * CFrame.new(0, 5, 0))
    elseif targetPos then
        KV.safeTeleport(CFrame.new(targetPos))
    else
        KV.notify("Vortex Teleport", KV.tn("╨Ы╨╛╨║╨░╤Ж╨╕╤П ╨╜╨╡ ╨╜╨░╨╣╨┤╨╡╨╜╨░ ╨╜╨░ ╤Н╤В╨╛╨╝ ╤Б╨╡╤А╨▓╨╡╤А╨╡: ", "Location not found on this server: ") .. islandName, 3)
        return
    end
    KV.notify("Vortex Teleport", "Teleported to " .. islandName, 2)
end

-- ╨Я╨╛╨╕╤Б╨║ ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╡╨│╨╛ ╤В╤А╨╡╨╜╨░╨╢╨╡╤А╨░ ╨┐╨╛ ╨║╨╗╤О╤З╨╡╨▓╤Л╨╝ ╤Б╨╗╨╛╨▓╨░╨╝
-- ╨б╨╜╨░╤З╨░╨╗╨░ ╤Б╨╝╨╛╤В╤А╨╕╨╝ ╨▓ ╨╕╨│╤А╨╛╨▓╤Л╨╡ ╨┐╨░╨┐╨║╨╕ (machinesFolder / Treadmills),
-- ╨╖╨░╤В╨╡╨╝ тАФ ╨╛╨▒╤Й╨╕╨╣ ╨╛╨▒╤Е╨╛╨┤ Workspace. blacklist: ╨╝╨╛╨┤╨╡╨╗╤М -> ╨▓╤А╨╡╨╝╤П ╨▒╨╗╨╛╨║╨╕╤А╨╛╨▓╨║╨╕.
KV.findNearestMachine = function(machineKeywords, blacklist)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil, nil end
    local myPos = char.HumanoidRootPart.Position
    local bestPart, bestModel, minDist = nil, nil, math.huge

    local wantTread = false
    for _, kw in ipairs(machineKeywords) do
        if string.find(string.lower(kw), "tread") then wantTread = true end
    end

    local function tryObject(obj)
        if blacklist and blacklist[obj] and blacklist[obj] > tick() then return end
        local objName = string.lower(obj.Name)
        local matched = false
        for _, kw in ipairs(machineKeywords) do
            if string.find(objName, string.lower(kw)) then matched = true break end
        end
        if matched then
            local part = nil
            if wantTread and obj:IsA("Model") then
                part = obj:FindFirstChild("treadmillPart")
            end
            part = part or (obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if part then
                local dist = (part.Position - myPos).Magnitude
                if dist < minDist then
                    minDist = dist
                    bestPart = part
                    if obj:IsA("Model") then
                        bestModel = obj
                    elseif obj.Parent and obj.Parent ~= Workspace and obj.Parent:IsA("Model") then
                        bestModel = obj.Parent
                    else
                        bestModel = nil
                    end
                end
            end
        end
    end

    -- 1) ╨Ш╨│╤А╨╛╨▓╤Л╨╡ ╨┐╨░╨┐╨║╨╕ ╤Б ╤В╤А╨╡╨╜╨░╨╢╤С╤А╨░╨╝╨╕
    local folderNames = {"machinesFolder", "Machines", "Treadmills"}
    local foundInFolders = false
    for _, fName in ipairs(folderNames) do
        local folder = Workspace:FindFirstChild(fName)
        if folder then
            for _, m in pairs(folder:GetChildren()) do
                if m:IsA("Model") or m:IsA("BasePart") then
                    foundInFolders = true
                    tryObject(m)
                end
            end
        end
    end

    -- 2) ╨Х╤Б╨╗╨╕ ╨▓ ╨┐╨░╨┐╨║╨░╤Е ╨╜╨╕╤З╨╡╨│╨╛ ╨╜╨╡ ╨╜╨░╤И╨╗╨╕ тАФ ╨╛╨▒╤Й╨╕╨╣ ╨╛╨▒╤Е╨╛╨┤
    if not foundInFolders or not bestPart then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                tryObject(obj)
            end
        end
    end
    return bestPart, bestModel
end

-- ╨б╨╕╨┤╨╡╨╜╤М╨╡ ╤В╤А╨╡╨╜╨░╨╢╤С╤А╨░ (╨┤╨╗╤П ╨╝╨░╤И╨╕╨╜ ╨╕╨╖ machinesFolder PrimaryPart ╨╕ ╨╡╤Б╤В╤М Seat)
KV.getMachineSeat = function(model)
    if not model then return nil end
    if model:IsA("Seat") then return model end
    local pp = model.PrimaryPart
    if pp and pp:IsA("Seat") then return pp end
    local s = model:FindFirstChildWhichIsA("Seat", true)
    return s
end

-- ╨б╨╡╤А╨▓╨╡╤А╨╜╨╛╨╡ ╨┐╨╛╨┤╨║╨╗╤О╤З╨╡╨╜╨╕╨╡ ╨║ ╤В╤А╨╡╨╜╨░╨╢╤С╤А╤Г: machineInteractRemote:InvokeServer("useMachine", seat)
KV.engageMachine = function(machineModel, seat)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not seat then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- ╨╡╤Б╨╗╨╕ ╤Г╨╢╨╡ ╤Б╨╕╨┤╨╕╨╝ ╨╜╨░ ╨┤╤А╤Г╨│╨╛╨╝ ╤В╤А╨╡╨╜╨░╨╢╤С╤А╨╡ тАФ ╤Б╨╜╨░╤З╨░╨╗╨░ ╨▓╤Б╤В╨░╤С╨╝
    local inUse = KV.getMachineInUse()
    if inUse and inUse ~= seat then
        KV.leaveMachine()
        task.wait(0.15)
    end

    -- ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╤Б╤В╤А╨╛╨│╨╛ ╨╜╨░╨┤ ╤Б╨╕╨┤╨╡╨╜╤М╨╡╨╝ (╨╜╨╡╤Б╨║╨╛╨╗╤М╨║╨╛ ╨┐╨╛╨┐╤Л╤В╨╛╨║, ╨║╨░╨║ ╤В╤А╨╡╨▒╤Г╨╡╤В ╤Б╨╡╤А╨▓╨╡╤А)
    for _ = 1, 3 do
        pcall(function()
            hrp.CFrame = seat.CFrame * CFrame.new(0, 5, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)
        task.wait(0.05)
    end

    local remote = KV.getREvent("machineInteractRemote")
    if remote and remote:IsA("RemoteFunction") then
        local ok, res = pcall(function() return remote:InvokeServer("useMachine", seat) end)
        if ok and res == true then
            local t0 = tick()
            while KV.getMachineInUse() ~= seat and tick() - t0 < 0.8 do
                task.wait(0.03)
            end
            if KV.getMachineInUse() == seat then return true end
        end
        if ok and res == false then
            -- ╤Б╨╡╤А╨▓╨╡╤А ╨╛╤В╨║╨░╨╖╨░╨╗ (╤В╤А╨╡╨▒╨╛╨▓╨░╨╜╨╕╤П ╨╜╨╡ ╨▓╤Л╨┐╨╛╨╗╨╜╨╡╨╜╤Л / ╨╖╨░╨╜╤П╤В╨╛)
            return false
        end
    end

    -- ╨д╨╛╨╗╨▒╤Н╨║ ╨▒╨╡╨╖ ╤А╨╡╨╝╨╛╤Г╤В╨░: ╨╛╨▒╤Л╤З╨╜╨░╤П ╨┐╨╛╤Б╨░╨┤╨║╨░
    if seat:IsA("Seat") and hum then
        pcall(function() hum.Sit = true end)
        task.wait(0.15)
        if hum.Sit or hum.SeatPart then return true end
        if firetouchinterest then
            pcall(function()
                firetouchinterest(hrp, seat, 0)
                task.wait(0.05)
                firetouchinterest(hrp, seat, 1)
            end)
            task.wait(0.15)
            if hum.Sit or hum.SeatPart then return true end
        end
    end
    return machineModel ~= nil
end

-- ╨н╨║╤Г╨╕╨┐ ╨╕ ╤В╤А╨╡╨╜╨╕╤А╨╛╨▓╨║╨╕
KV.trainTool = function(toolSearchName)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- ╨Х╤Б╨╗╨╕ ╨▓╨║╨╗╤О╤З╨╡╨╜ ╤А╨╡╨╢╨╕╨╝ ╤Е╨╛╨┤╤М╨▒╤Л ╤Б╨╛ ╤И╤В╨░╨╜╨│╨╛╨╣ / ╨│╨░╨╜╤В╨╡╨╗╤П╨╝╨╕ тАФ ╨╖╨░╨┐╤А╨╡╤Й╨░╨╡╨╝ ╨┐╤А╨╕╨╜╤Г╨┤╨╕╤В╨╡╨╗╤М╨╜╤Г╤О ╨░╨╜╨╕╨╝╨░╤Ж╨╕╤О ╤Б╨╕╨┤╨╡╨╜╨╕╤П
    if KV.Config.WalkWhileTraining then
        if hum.Sit then hum.Sit = false end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Anchored then
                part.Anchored = false
            end
        end
    end

    local tool = nil
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            if toolSearchName == "Dumbbell" and (string.find(string.lower(item.Name), "dumbbell") or string.find(string.lower(item.Name), "weight")) then
                tool = item
                break
            elseif string.find(string.lower(item.Name), string.lower(toolSearchName)) then
                tool = item
                break
            end
        end
    end
    if not tool then
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Tool") then
                if toolSearchName == "Dumbbell" and (string.find(string.lower(item.Name), "dumbbell") or string.find(string.lower(item.Name), "weight")) then
                    tool = item
                    break
                elseif string.find(string.lower(item.Name), string.lower(toolSearchName)) then
                    tool = item
                    break
                end
            end
        end
    end

    if tool then
        if tool.Parent ~= char then
            hum:EquipTool(tool)
        end
        pcall(function() tool:Activate() end)
    end

    local ev = KV.getMuscleEvent()
    if ev then
        local repCount = KV.Config.UltraFastRep and (KV.Config.FastRepMultiplier * 5) or KV.Config.FastRepMultiplier
        for i = 1, repCount do
            ev:FireServer("rep")
        end
    end
end

-- Anti-AFK
pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do conn:Disable() end
end)
KV.afkConn = LocalPlayer.Idled:Connect(function()
    if KV.Config.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)
table.insert(KV.ScriptConnections, KV.afkConn)

-- Auto Low HP Teleport Safety
KV.lowHpConn = RunService.Heartbeat:Connect(function()
    if KV.Config.AutoSafeTPLowHP and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and (hum.Health / hum.MaxHealth) < 0.25 then
            KV.safeTeleport(CFrame.new(0, 5005, 0))
            KV.notify("Vortex Safety", "Low HP! Emergency teleport to sky safe zone!", 3)
            task.wait(5)
        end
    end
end)
table.insert(KV.ScriptConnections, KV.lowHpConn)

-- ============================================================
-- ╨б╨Ш╨б╨в╨Х╨Ь╨Р ╨Я╨Ю╨Ы╨Х╨в╨Р (FLY ENGINE)
-- ============================================================
KV.flying = false
local flyBv, flyBg
KV.flyKeys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}

KV.startFlight = function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    flyBv = Instance.new("BodyVelocity")
    flyBv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBv.Velocity = Vector3.new(0, 0, 0)
    flyBv.Parent = hrp

    flyBg = Instance.new("BodyGyro")
    flyBg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBg.CFrame = hrp.CFrame
    flyBg.Parent = hrp

    KV.flying = true

    local conn = RunService.RenderStepped:Connect(function()
        if not KV.flying or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if flyBv then flyBv:Destroy() end
            if flyBg then flyBg:Destroy() end
            return
        end

        local cam = Workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)

        if KV.flyKeys.W then moveDir = moveDir + cam.CFrame.LookVector end
        if KV.flyKeys.S then moveDir = moveDir - cam.CFrame.LookVector end
        if KV.flyKeys.A then moveDir = moveDir - cam.CFrame.RightVector end
        if KV.flyKeys.D then moveDir = moveDir + cam.CFrame.RightVector end
        if KV.flyKeys.Space then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if KV.flyKeys.Shift then moveDir = moveDir - Vector3.new(0, 1, 0) end

        flyBg.CFrame = cam.CFrame
        flyBv.Velocity = moveDir * KV.Config.FlySpeed
    end)
    table.insert(KV.ScriptConnections, conn)
end

KV.stopFlight = function()
    KV.flying = false
    if flyBv then flyBv:Destroy() end
    if flyBg then flyBg:Destroy() end
end

KV.flyDownConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then KV.flyKeys.W = true
    elseif input.KeyCode == Enum.KeyCode.S then KV.flyKeys.S = true
    elseif input.KeyCode == Enum.KeyCode.A then KV.flyKeys.A = true
    elseif input.KeyCode == Enum.KeyCode.D then KV.flyKeys.D = true
    elseif input.KeyCode == Enum.KeyCode.Space then KV.flyKeys.Space = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then KV.flyKeys.Shift = true
    end
end)
table.insert(KV.ScriptConnections, KV.flyDownConn)

KV.flyUpConn = UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then KV.flyKeys.W = false
    elseif input.KeyCode == Enum.KeyCode.S then KV.flyKeys.S = false
    elseif input.KeyCode == Enum.KeyCode.A then KV.flyKeys.A = false
    elseif input.KeyCode == Enum.KeyCode.D then KV.flyKeys.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then KV.flyKeys.Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then KV.flyKeys.Shift = false
    end
end)
table.insert(KV.ScriptConnections, KV.flyUpConn)

-- Noclip & Physics Loop
KV.noclipConn = RunService.Stepped:Connect(function()
    if KV.Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    if KV.Config.AntiKnockback and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.Y, 0)
    end
end)
table.insert(KV.ScriptConnections, KV.noclipConn)

-- Inf Jump Input
KV.infJumpConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space and KV.Config.InfJump then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
table.insert(KV.ScriptConnections, KV.infJumpConn)

-- ============================================================
-- ╨С╨Р╨Ч╨Р ╨У╨г╨Ш (Vortex GLASS UI FRAMEWORK)
-- ============================================================
KV.targetParent = nil
if typeof(gethui) == "function" then
    pcall(function() KV.targetParent = gethui() end)
end
if not KV.targetParent then
    pcall(function()
        if syn and syn.protect_gui then
            KV.targetParent = CoreGui
        end
    end)
end
if not KV.targetParent then
    pcall(function() KV.targetParent = LocalPlayer:WaitForChild("PlayerGui") end)
end

KV.ScreenGui = Instance.new("ScreenGui")
KV.ScreenGui.Name = FRAMEWORK_NAME
KV.ScreenGui.ResetOnSpawn = false
KV.ScreenGui.Enabled = true
KV.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
print("[Vortex STAGE D]: ScreenGui ╤Б╨╛╨╖╨┤╨░╨╜")
bootSet("[Vortex] ScreenGui created, building widgets...")

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(KV.ScreenGui)
        KV.ScreenGui.Parent = CoreGui
    end
end)
if not KV.ScreenGui.Parent then
    pcall(function() KV.ScreenGui.Parent = KV.targetParent end)
end
if not KV.ScreenGui.Parent then
    pcall(function() KV.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Vortex ",
        Text = "Vortex loaded! Press Right Shift or the on-screen button.",
        Duration = 5
    })
end)

-- ============================================================
-- ╨Ы╨Ю╨У╨Ю╨в╨Ш╨Я (╤Б╤В╨╕╨╗╨╕╨╖╨╛╨▓╨░╨╜╨╜╤Л╨╣ ╤З╤С╤А╨╜╤Л╨╣ ╨║╨╛╤В ╨┐╨╛ ╨╝╨╛╤В╨╕╨▓╨░╨╝ ╤А╨╡╤Д╨╡╤А╨╡╨╜╤Б╨░)
-- ============================================================
KV.createCatLogo = function(parent, s)
    local logo = Instance.new("Frame", parent)
    logo.BackgroundTransparency = 1
    logo.Size = UDim2.new(0, s, 0, s)
    logo.ClipsDescendants = false

    local headW = math.floor(s * 0.68)
    local headH = math.floor(s * 0.58)
    local earS  = math.floor(s * 0.34)

    -- ╤Г╤И╨╕: ╨┐╨╛╨▓╤С╤А╨╜╤Г╤В╤Л╨╡ ╨║╨▓╨░╨┤╤А╨░╤В╤Л, ╨▓╨╡╤А╤Е╨╜╨╕╨╡ ╤Г╨│╨╗╤Л ╨▓╤Л╨│╨╗╤П╨┤╤Л╨▓╨░╤О╤В ╨╕╨╖-╨╖╨░ ╨│╨╛╨╗╨╛╨▓╤Л
    local function ear(xPos, rot)
        local e = Instance.new("Frame", logo)
        e.Size = UDim2.new(0, earS, 0, earS)
        e.Position = xPos
        e.Rotation = rot
        e.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
        e.BorderSizePixel = 0
        e.ZIndex = 21
        KV.applyCorner(e, 4)
        KV.applyStroke(e, Color3.fromRGB(235, 235, 245), 0.5, 1)
        return e
    end
    ear(UDim2.new(0, math.floor(s * 0.08), 0, math.floor(s * 0.14)), -20)
    ear(UDim2.new(1, -earS - math.floor(s * 0.08), 0, math.floor(s * 0.14)), 20)

    -- ╨│╨╛╨╗╨╛╨▓╨░
    local head = Instance.new("Frame", logo)
    head.AnchorPoint = Vector2.new(0.5, 1)
    head.Position = UDim2.new(0.5, 0, 1, -math.floor(s * 0.03))
    head.Size = UDim2.new(0, headW, 0, headH)
    head.BackgroundColor3 = Color3.fromRGB(9, 9, 11)
    head.BorderSizePixel = 0
    head.ZIndex = 22
    KV.applyCorner(head, math.floor(headW * 0.44))
    KV.applyStroke(head, Color3.fromRGB(235, 235, 245), 0.7, 1)

    -- ╤Б╨▓╨╡╤В╤П╤Й╨╕╨╡╤Б╤П ╨│╨╗╨░╨╖╨░-╤И╤В╤А╨╕╤Е╨╕ ┬л^ ^┬╗
    local eyeW = math.max(8, math.floor(s * 0.26))
    local eyeH = math.max(3, math.floor(s * 0.075))
    local function eye(xOff, rot)
        local e = Instance.new("Frame", head)
        e.AnchorPoint = Vector2.new(0.5, 0.5)
        e.Position = UDim2.new(0.5, xOff, 0, math.floor(headH * 0.44))
        e.Size = UDim2.new(0, eyeW, 0, eyeH)
        e.Rotation = rot
        e.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        e.BorderSizePixel = 0
        e.ZIndex = 23
        KV.applyCorner(e, eyeH)
        KV.applyStroke(e, Color3.fromRGB(255, 255, 255), 0.3, 2)
    end
    eye(-math.floor(headW * 0.19), -16)
    eye(math.floor(headW * 0.19), 16)
    return logo
end

-- ============================================================
-- ╨н╨Ъ╨а╨Р╨Э ╨Ч╨Р╨У╨а╨г╨Ч╨Ъ╨Ш ╨б╨Ъ╨а╨Ш╨Я╨в╨Р (╨║╨╛╨╝╨┐╨░╨║╤В╨╜╨░╤П ╨║╨░╤А╤В╨╛╤З╨║╨░ ╤Б╨▓╨╡╤А╤Е╤Г ╤Б╨╗╨╡╨▓╨░, ╨║╨░╨║ ╨╜╨░ ╤А╨╡╤Д╨╡╤А╨╡╨╜╤Б╨╡)
-- ============================================================
KV.LoadModal = Instance.new("CanvasGroup", KV.ScreenGui)
KV.LoadModal.Name = "LoadModal"
KV.LoadModal.Size = UDim2.new(0, 330, 0, 96)
KV.LoadModal.Position = UDim2.new(0, 18, 0, 18)
KV.LoadModal.BackgroundColor3 = KV.currentTheme().window
KV.LoadModal.BackgroundTransparency = 0
KV.LoadModal.BorderSizePixel = 0
KV.LoadModal.ZIndex = 20
CollectionService:AddTag(KV.LoadModal, "ThemeWindow")
KV.applyCorner(KV.LoadModal, 14)
KV.loadStroke = KV.applyStroke(KV.LoadModal, KV.AccentColor, 0.55, 1)
CollectionService:AddTag(KV.loadStroke, "AccentStroke")

KV.LoadLogo = KV.createCatLogo(KV.LoadModal, 46)
KV.LoadLogo.Position = UDim2.new(0, 14, 0.5, -23)

KV.LoadTitle = Instance.new("TextLabel", KV.LoadModal)
KV.LoadTitle.BackgroundTransparency = 1
KV.LoadTitle.Position = UDim2.new(0, 72, 0, 16)
KV.LoadTitle.Size = UDim2.new(1, -120, 0, 18)
KV.LoadTitle.Font = Enum.Font.GothamBold
KV.LoadTitle.Text = "Vortex"
KV.LoadTitle.TextColor3 = Color3.fromRGB(235, 235, 240)
KV.LoadTitle.TextSize = 15
KV.LoadTitle.TextXAlignment = Enum.TextXAlignment.Left
KV.LoadTitle.ZIndex = 21

KV.LoadVersion = Instance.new("TextLabel", KV.LoadModal)
KV.LoadVersion.BackgroundTransparency = 1
KV.LoadVersion.Position = UDim2.new(1, -56, 0, 17)
KV.LoadVersion.Size = UDim2.new(0, 44, 0, 16)
KV.LoadVersion.Font = Enum.Font.GothamMedium
KV.LoadVersion.Text = "v"
KV.LoadVersion.TextColor3 = Color3.fromRGB(120, 122, 130)
KV.LoadVersion.TextSize = 10
KV.LoadVersion.TextXAlignment = Enum.TextXAlignment.Right
KV.LoadVersion.ZIndex = 21

KV.LoadStatus = Instance.new("TextLabel", KV.LoadModal)
KV.LoadStatus.BackgroundTransparency = 1
KV.LoadStatus.Position = UDim2.new(0, 72, 0, 40)
KV.LoadStatus.Size = UDim2.new(1, -86, 0, 16)
KV.LoadStatus.Font = Enum.Font.Gotham
KV.LoadStatus.Text = "╨Ч╨░╨│╤А╤Г╨╖╨║╨░..."
KV.LoadStatus.TextColor3 = Color3.fromRGB(140, 142, 150)
KV.LoadStatus.TextSize = 10
KV.LoadStatus.TextXAlignment = Enum.TextXAlignment.Left
KV.LoadStatus.ZIndex = 21

KV.LoadBarBG = Instance.new("Frame", KV.LoadModal)
KV.LoadBarBG.Position = UDim2.new(0, 16, 1, -22)
KV.LoadBarBG.Size = UDim2.new(1, -32, 0, 4)
KV.LoadBarBG.BackgroundColor3 = Color3.fromRGB(38, 38, 43)
KV.LoadBarBG.BorderSizePixel = 0
KV.LoadBarBG.ZIndex = 21
KV.applyCorner(KV.LoadBarBG, 2)

KV.LoadBarFill = Instance.new("Frame", KV.LoadBarBG)
KV.LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
KV.LoadBarFill.BackgroundColor3 = KV.AccentColor
KV.LoadBarFill.BorderSizePixel = 0
KV.LoadBarFill.ZIndex = 22
CollectionService:AddTag(KV.LoadBarFill, "AccentFill")
KV.applyCorner(KV.LoadBarFill, 2)

KV.LoadPercent = Instance.new("TextLabel", KV.LoadModal)
KV.LoadPercent.BackgroundTransparency = 1
KV.LoadPercent.Position = UDim2.new(1, -48, 1, -36)
KV.LoadPercent.Size = UDim2.new(0, 34, 0, 12)
KV.LoadPercent.Font = Enum.Font.GothamBold
KV.LoadPercent.Text = "0%"
KV.LoadPercent.TextColor3 = Color3.fromRGB(120, 122, 130)
KV.LoadPercent.TextSize = 9
KV.LoadPercent.TextXAlignment = Enum.TextXAlignment.Right
KV.LoadPercent.ZIndex = 21

-- ============================================================
-- ╨Ъ╨Э╨Ю╨Я╨Ъ╨Р ╨Ю╨в╨Ъ╨а╨л╨в╨Ш╨п ╨Э╨Р ╨н╨Ъ╨а╨Р╨Э╨Х Vortex
-- ============================================================
KV.OpenBtn = Instance.new("TextButton", KV.ScreenGui)
KV.OpenBtn.Name = "Vortex_OpenBtn"
KV.OpenBtn.Size = UDim2.new(0, 160, 0, 40)
KV.OpenBtn.Position = UDim2.new(0, 15, 0.35, 0)
KV.OpenBtn.BackgroundColor3 = KV.currentTheme().window
KV.OpenBtn.BackgroundTransparency = 0
KV.OpenBtn.Text = "Vortex "
KV.OpenBtn.TextColor3 = Color3.fromRGB(240, 250, 248)
KV.OpenBtn.TextSize = 11
KV.OpenBtn.Font = Enum.Font.GothamBold
KV.OpenBtn.Active = true
KV.OpenBtn.Draggable = true
CollectionService:AddTag(KV.OpenBtn, "ThemeWindow")
KV.applyCorner(KV.OpenBtn, 10)
KV.openBtnStroke = KV.applyStroke(KV.OpenBtn, KV.AccentColor, 0.4, 1.5)
CollectionService:AddTag(KV.openBtnStroke, "AccentStroke")
KV.OpenBtn.Visible = false -- ╨┐╨╛╤П╨▓╨╕╤В╤Б╤П ╨┐╨╛╤Б╨╗╨╡ ╤Н╨║╤А╨░╨╜╨░ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕

-- ============================================================
-- ON-SCREEN HUD
-- ============================================================
KV.OnScreenHUD = Instance.new("Frame", KV.ScreenGui)
KV.OnScreenHUD.Name = "OnScreenHUD"
KV.OnScreenHUD.BackgroundTransparency = 1
KV.OnScreenHUD.Position = UDim2.new(1, -240, 0, 20)
KV.OnScreenHUD.Size = UDim2.new(0, 220, 0, 120)
KV.OnScreenHUD.Visible = KV.Config.ShowOnScreenHUD

KV.HUDPanel = Instance.new("Frame", KV.OnScreenHUD)
KV.HUDPanel.BackgroundColor3 = KV.currentTheme().window
KV.HUDPanel.BackgroundTransparency = 0
KV.HUDPanel.Size = UDim2.new(1, 0, 1, 0)
CollectionService:AddTag(KV.HUDPanel, "ThemeWindow")
KV.applyCorner(KV.HUDPanel, 12)
KV.HUDStroke = KV.applyStroke(KV.HUDPanel, KV.AccentColor, 0.4, 1.5)
CollectionService:AddTag(KV.HUDStroke, "AccentStroke")

KV.HUDContentLabel = Instance.new("TextLabel", KV.HUDPanel)
KV.HUDContentLabel.BackgroundTransparency = 1
KV.HUDContentLabel.Position = UDim2.new(0, 12, 0, 10)
KV.HUDContentLabel.Size = UDim2.new(1, -24, 1, -20)
KV.HUDContentLabel.Font = Enum.Font.GothamBold
KV.HUDContentLabel.TextColor3 = Color3.fromRGB(240, 250, 248)
KV.HUDContentLabel.TextSize = 11
KV.HUDContentLabel.TextXAlignment = Enum.TextXAlignment.Left
KV.HUDContentLabel.TextYAlignment = Enum.TextYAlignment.Top
KV.HUDContentLabel.TextWrapped = true

KV.hudConn = RunService.RenderStepped:Connect(function(dt)
    if KV.Config.ShowOnScreenHUD then
        local fps = math.floor(1 / dt)
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local str = leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0
        local reb = leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0
        
        KV.HUDContentLabel.Text = string.format("Vortex  HUD:\n  тАв FPS: %d | Ping: %d ms\n  тАв Player: %s\n  тАв Strength: %s\n  тАв Rebirths: %s", fps, ping, LocalPlayer.Name, tostring(str), tostring(reb))
    end
end)
table.insert(KV.ScriptConnections, KV.hudConn)

-- ============================================================
-- ╨У╨Ы╨Р╨Т╨Э╨Ю╨Х ╨Ю╨Ъ╨Э╨Ю Vortex  (690x520)
-- ============================================================
KV.MainFrame = Instance.new("Frame", KV.ScreenGui)
KV.MainFrame.Name = "MainFrame"
KV.MainFrame.BackgroundColor3 = KV.currentTheme().window
KV.MainFrame.BackgroundTransparency = 0
KV.MainFrame.BorderSizePixel = 0
KV.MainFrame.Position = UDim2.new(0.5, -345, 0.5, -260)
KV.MainFrame.Size = UDim2.new(0, 690, 0, 520)
KV.MainFrame.Active = true
KV.MainFrame.Visible = false -- ╨┐╨╛╨║╨░ ╨╕╨┤╤С╤В ╤Н╨║╤А╨░╨╜ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕
KV.LoadModal.Visible = true
print("[Vortex STAGE E]: ╨│╨╗╨░╨▓╨╜╨╛╨╡ ╨╛╨║╨╜╨╛ ╨┐╨╛╤Б╤В╤А╨╛╨╡╨╜╨╛, ╨┐╨╛╨║╨░╨╖╨░╨╜ ╤Н╨║╤А╨░╨╜ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕")
bootSet("[Vortex] UI built тАФ starting load animation...")
KV.MainFrame.ClipsDescendants = true
CollectionService:AddTag(KV.MainFrame, "ThemeWindow")
KV.applyCorner(KV.MainFrame, 18)
KV.MainStroke = KV.applyStroke(KV.MainFrame, KV.AccentColor, 0.3, 1.5)
CollectionService:AddTag(KV.MainStroke, "AccentStroke")

-- ╨б╨╛╤Б╤В╨╛╤П╨╜╨╕╨╡ ╨░╨╜╨╕╨╝╨░╤Ж╨╕╨╣ ╨╛╤В╨║╤А╤Л╤В╨╕╤П/╨╖╨░╨║╤А╤Л╤В╨╕╤П ╨╝╨╡╨╜╤О
KV.menuScale = Instance.new("UIScale", KV.MainFrame)
KV.menuScale.Scale = 1
KV.menuTargetPos = KV.MainFrame.Position
local guiVisible, isAnimating = false, false

KV.GlassLayer1 = Instance.new("Frame", KV.MainFrame)
KV.GlassLayer1.Size = UDim2.new(1,0,1,0); KV.GlassLayer1.BackgroundColor3 = Color3.fromRGB(255,255,255); KV.GlassLayer1.BackgroundTransparency = 1; KV.GlassLayer1.BorderSizePixel = 0; KV.GlassLayer1.ZIndex = 0; KV.applyCorner(KV.GlassLayer1, 18)

KV.GlassLayer2 = Instance.new("Frame", KV.MainFrame)
KV.GlassLayer2.Size = UDim2.new(1,0,1,0); KV.GlassLayer2.BackgroundColor3 = Color3.fromRGB(14,14,16); KV.GlassLayer2.BackgroundTransparency = 0.4; KV.GlassLayer2.BorderSizePixel = 0; KV.GlassLayer2.ZIndex = 0; KV.applyCorner(KV.GlassLayer2, 18)

KV.BgOverlay = Instance.new("Frame", KV.MainFrame)
KV.BgOverlay.Size = UDim2.new(1,0,1,0); KV.BgOverlay.BackgroundColor3 = Color3.fromRGB(5,8,10); KV.BgOverlay.BackgroundTransparency = 1; KV.BgOverlay.BorderSizePixel = 0; KV.BgOverlay.ZIndex = 2; KV.applyCorner(KV.BgOverlay, 18)

-- ╨С╤А╨╡╨╜╨┤-╤И╨░╨┐╨║╨░ ╨╜╨░╨┤ ╤Б╨░╨╣╨┤╨▒╨░╤А╨╛╨╝: ╨╕╨║╨╛╨╜╨║╨░-╤А╨╛╨╝╨▒ + ╨╜╨░╨╖╨▓╨░╨╜╨╕╨╡ + ╨▓╨╡╤А╤Б╨╕╤П
KV.BrandHeader = Instance.new("Frame", KV.MainFrame)
KV.BrandHeader.BackgroundColor3 = KV.currentTheme().bar
KV.BrandHeader.BackgroundTransparency = 0
KV.BrandHeader.BorderSizePixel = 0
KV.BrandHeader.Position = UDim2.new(0, 0, 0, 0)
KV.BrandHeader.Size = UDim2.new(0, 190, 0, 58)
KV.BrandHeader.ZIndex = 6
KV.BrandHeader.Active = true
CollectionService:AddTag(KV.BrandHeader, "ThemeBar")

-- ╨Ь╨╕╨╜╨╕-╨╗╨╛╨│╨╛╤В╨╕╨┐ (╨║╨╛╤В) ╨▓ ╨▒╤А╨╡╨╜╨┤-╤И╨░╨┐╨║╨╡
KV.BrandIcon = KV.createCatLogo(KV.BrandHeader, 30)
KV.BrandIcon.Position = UDim2.new(0, 14, 0.5, -15)

KV.BrandTitle = Instance.new("TextLabel", KV.BrandHeader)
KV.BrandTitle.BackgroundTransparency = 1
KV.BrandTitle.Position = UDim2.new(0, 42, 0, 9)
KV.BrandTitle.Size = UDim2.new(1, -50, 0, 22)
KV.BrandTitle.Font = Enum.Font.GothamBold
KV.BrandTitle.Text = "Vortex"
KV.BrandTitle.TextColor3 = Color3.fromRGB(241, 245, 249)
KV.BrandTitle.TextSize = 16
KV.BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
KV.BrandTitle.ZIndex = 7

KV.BrandVer = Instance.new("TextLabel", KV.BrandHeader)
KV.BrandVer.BackgroundTransparency = 1
KV.BrandVer.Position = UDim2.new(0, 42, 0, 32)
KV.BrandVer.Size = UDim2.new(1, -50, 0, 14)
KV.BrandVer.Font = Enum.Font.GothamMedium
KV.BrandVer.Text = "v"
KV.BrandVer.TextColor3 = Color3.fromRGB(148, 163, 184)
KV.BrandVer.TextSize = 10
KV.BrandVer.TextXAlignment = Enum.TextXAlignment.Left
KV.BrandVer.ZIndex = 7

-- ╨и╨░╨┐╨║╨░ ╨║╨╛╨╜╤В╨╡╨╜╤В╨░: ╨╖╨░╨│╨╛╨╗╨╛╨▓╨╛╨║ ╤Б╤В╤А╨░╨╜╨╕╤Ж╤Л + ╨┐╨╛╨┤╨╖╨░╨│╨╛╨╗╨╛╨▓╨╛╨║ + ╨║╨╜╨╛╨┐╨║╨░ ╨╖╨░╨║╤А╤Л╤В╨╕╤П
KV.TopBar = Instance.new("Frame", KV.MainFrame)
KV.TopBar.BackgroundColor3 = KV.currentTheme().bar
KV.TopBar.BackgroundTransparency = 0
KV.TopBar.BorderSizePixel = 0
KV.TopBar.Position = UDim2.new(0, 190, 0, 0)
KV.TopBar.Size = UDim2.new(1, -190, 0, 58)
KV.TopBar.Active = true
KV.TopBar.ZIndex = 6
CollectionService:AddTag(KV.TopBar, "ThemeBar")

KV.PageTitle = Instance.new("TextLabel", KV.TopBar)
KV.PageTitle.BackgroundTransparency = 1
KV.PageTitle.Position = UDim2.new(0, 18, 0, 9)
KV.PageTitle.Size = UDim2.new(1, -70, 0, 22)
KV.PageTitle.Font = Enum.Font.GothamBold
KV.PageTitle.Text = "Settings"
KV.PageTitle.TextColor3 = Color3.fromRGB(241, 245, 249)
KV.PageTitle.TextSize = 16
KV.PageTitle.TextXAlignment = Enum.TextXAlignment.Left
KV.PageTitle.ZIndex = 7

KV.PageSub = Instance.new("TextLabel", KV.TopBar)
KV.PageSub.BackgroundTransparency = 1
KV.PageSub.Position = UDim2.new(0, 18, 0, 33)
KV.PageSub.Size = UDim2.new(1, -70, 0, 14)
KV.PageSub.Font = Enum.Font.GothamMedium
KV.PageSub.Text = "Language, themes, GUI size and configs"
KV.PageSub.TextColor3 = Color3.fromRGB(148, 163, 184)
KV.PageSub.TextSize = 10
KV.PageSub.TextXAlignment = Enum.TextXAlignment.Left
KV.PageSub.ZIndex = 7

KV.CloseHeaderBtn = Instance.new("TextButton", KV.TopBar)
KV.CloseHeaderBtn.AnchorPoint = Vector2.new(1, 0.5)
KV.CloseHeaderBtn.Position = UDim2.new(1, -14, 0.5, 0)
KV.CloseHeaderBtn.Size = UDim2.new(0, 28, 0, 28)
KV.CloseHeaderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KV.CloseHeaderBtn.BackgroundTransparency = 1
KV.CloseHeaderBtn.Text = "тЬХ"
KV.CloseHeaderBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
KV.CloseHeaderBtn.Font = Enum.Font.GothamBold
KV.CloseHeaderBtn.TextSize = 13
KV.CloseHeaderBtn.ZIndex = 8
KV.CloseHeaderBtn.AutoButtonColor = false
KV.CloseHeaderBtn.MouseEnter:Connect(function()
    KV.tw(KV.CloseHeaderBtn, {TextColor3 = Color3.fromRGB(248, 113, 113)}, 0.15):Play()
end)
KV.CloseHeaderBtn.MouseLeave:Connect(function()
    KV.tw(KV.CloseHeaderBtn, {TextColor3 = Color3.fromRGB(148, 163, 184)}, 0.15):Play()
end)

-- ╨Х╨Ф╨Ш╨Э╨Р╨п ╨Т╨л╨У╨а╨г╨Ч╨Ъ╨Р ╨б╨Ъ╨а╨Ш╨Я╨в╨Р: ╨╛╤Б╤В╨░╨╜╨░╨▓╨╗╨╕╨▓╨░╨╡╤В ╨▓╤Б╨╡ while-╤Ж╨╕╨║╨╗╤Л (╤З╨╡╤А╨╡╨╖ ╤Д╨╗╨░╨│╨╕ Config),
-- ╨╛╤В╨║╨╗╤О╤З╨░╨╡╤В ╨▓╤Б╨╡ ╤Б╨╛╨╡╨┤╨╕╨╜╨╡╨╜╨╕╤П ╨╕ ╤Г╨╜╨╕╤З╤В╨╛╨╢╨░╨╡╤В GUI
KV.completeScriptUnload = function()
    KV.notify("Vortex", KV.tn("╨Т╤Л╨│╤А╤Г╨╖╨║╨░ ╤Б╨║╤А╨╕╨┐╤В╨░ Vortex ...", "Unloading Vortex ..."), 2)

    local loopFlags = {
        "AutoOpFarm", "AutoDumbbell", "AutoPushups", "AutoSitups", "AutoWeight",
        "AutoPunch", "AutoMultiTool", "AutoBenchPress", "AutoSquat",
        "AutoTreadmillMachine", "AutoPullups", "AutoBoulder", "AutoRockMachine",
        "AutoRock", "AutoTreadmill", "KillAura", "TargetLoopKill", "AutoKillServer",
        "AutoBrawl", "AutoKillBoss", "AntiRagdoll", "AutoRebirth", "AutoCollectOrbs",
        "AutoCrystal", "PlayerESP", "FlyEnabled", "WalkWhileTraining", "AntiHit",
        "AutoSafeTPLowHP", "SpeedHack", "JumpPowerHack", "Noclip", "InfJump",
        "Bhop", "FullBright", "SpectateTarget", "AntiKnockback", "AntiAFK",
        "UltraFastRep", "HatchPower",
    }
    for _, flagName in ipairs(loopFlags) do
        KV.Config[flagName] = false
    end

    for _, conn in ipairs(KV.ScriptConnections) do
        pcall(function() conn:Disconnect() end)
    end
    KV.ScriptConnections = {}

    pcall(KV.stopFlight)
    pcall(function() clearESP() end)
    pcall(function() KV.ScreenGui:Destroy() end)
    print("[Vortex Framework]: Unloaded successfully.")
end
-- ╨Я╨╡╤А╨╡╤В╨░╤Б╨║╨╕╨▓╨░╨╜╨╕╨╡ ╨╛╨║╨╜╨░ ╨╖╨░ ╤И╨░╨┐╨║╤Г (╨║╨╛╨╜╤В╨╡╨╜╤В ╨╕╨╗╨╕ ╨▒╤А╨╡╨╜╨┤)
local dragging, dragStart, startPos = false, nil, nil
KV.beginDrag = function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = KV.MainFrame.Position
    end
end
KV.TopBar.InputBegan:Connect(KV.beginDrag)
KV.BrandHeader.InputBegan:Connect(KV.beginDrag)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        KV.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        KV.menuTargetPos = KV.MainFrame.Position -- ╨╖╨░╨┐╨╛╨╝╨╕╨╜╨░╨╡╨╝ ╨┐╨╛╨╖╨╕╤Ж╨╕╤О ╨┤╨╗╤П ╨░╨╜╨╕╨╝╨░╤Ж╨╕╨╣
    end
end)

-- ╨Я╨╛╨┤╨▓╨░╨╗ ╤Б ╨╛╨┐╨╕╤Б╨░╨╜╨╕╨╡╨╝ (Description Footer Bar) тАФ ╤В╨╛╨╗╤М╨║╨╛ ╨┐╨╛╨┤ ╨║╨╛╨╜╤В╨╡╨╜╤В╨╛╨╝
KV.DescFooterBar = Instance.new("Frame", KV.MainFrame)
KV.DescFooterBar.Name = "DescFooterBar"
KV.DescFooterBar.BackgroundColor3 = KV.currentTheme().bar
KV.DescFooterBar.BackgroundTransparency = 0
KV.DescFooterBar.BorderSizePixel = 0
KV.DescFooterBar.Position = UDim2.new(0, 190, 1, -28)
KV.DescFooterBar.Size = UDim2.new(1, -190, 0, 28)
KV.DescFooterBar.ZIndex = 8
CollectionService:AddTag(KV.DescFooterBar, "ThemeBar")

KV.DescTextLabel = Instance.new("TextLabel", KV.DescFooterBar)
KV.DescTextLabel.BackgroundTransparency = 1
KV.DescTextLabel.Position = UDim2.new(0, 16, 0, 0)
KV.DescTextLabel.Size = UDim2.new(1, -32, 1, 0)
KV.DescTextLabel.Font = Enum.Font.GothamMedium
KV.DescTextLabel.TextColor3 = Color3.fromRGB(126, 130, 136)
KV.DescTextLabel.TextSize = 10
KV.DescTextLabel.TextXAlignment = Enum.TextXAlignment.Left
KV.DescTextLabel.Text = "Vortex : " .. KV.t("╨Э╨░╨▓╨╡╨┤╨╕╤В╨╡ ╨║╤Г╤А╤Б╨╛╤А ╨╜╨░ ╤Д╤Г╨╜╨║╤Ж╨╕╤О ╨┤╨╗╤П ╨╛╨┐╨╕╤Б╨░╨╜╨╕╤П...", "Hover over feature to view description...")
KV.bindText(KV.DescTextLabel, function()
    return "Vortex : " .. KV.t("╨Э╨░╨▓╨╡╨┤╨╕╤В╨╡ ╨║╤Г╤А╤Б╨╛╤А ╨╜╨░ ╤Д╤Г╨╜╨║╤Ж╨╕╤О ╨┤╨╗╤П ╨╛╨┐╨╕╤Б╨░╨╜╨╕╤П...", "Hover over feature to view description...")
end)

-- ╨б╨░╨╣╨┤╨▒╨░╤А: ╨┐╨╛╨╗╨╜╨░╤П ╨▓╤Л╤Б╨╛╤В╨░ ╨┐╨╛╨┤ ╨▒╤А╨╡╨╜╨┤-╤И╨░╨┐╨║╨╛╨╣
KV.Sidebar = Instance.new("ScrollingFrame", KV.MainFrame)
KV.Sidebar.BackgroundColor3 = KV.currentTheme().side; KV.Sidebar.BackgroundTransparency = 0; KV.Sidebar.BorderSizePixel = 0; KV.Sidebar.Position = UDim2.new(0,0,0,58); KV.Sidebar.Size = UDim2.new(0,190,1,-58); KV.Sidebar.ZIndex = 5; KV.Sidebar.ScrollBarThickness = 3; KV.Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y; KV.Sidebar.CanvasSize = UDim2.new(0,0,0,0)
CollectionService:AddTag(KV.Sidebar, "ThemeSide")

KV.SideLayout = Instance.new("UIListLayout", KV.Sidebar)
KV.SideLayout.SortOrder = Enum.SortOrder.LayoutOrder; KV.SideLayout.Padding = UDim.new(0,4)
KV.SidePadding = Instance.new("UIPadding", KV.Sidebar)
KV.SidePadding.PaddingTop = UDim.new(0,8); KV.SidePadding.PaddingLeft = UDim.new(0,8); KV.SidePadding.PaddingRight = UDim.new(0,8)

local pages, pageCanvases, tabButtons, TabInfo, currentTab = {}, {}, {}, {}, nil
KV.PagesContainer = Instance.new("Frame", KV.MainFrame)
KV.PagesContainer.BackgroundTransparency = 1; KV.PagesContainer.Position = UDim2.new(0,202,0,66); KV.PagesContainer.Size = UDim2.new(1,-214,1,-102); KV.PagesContainer.ZIndex = 5

KV.createPage = function(name)
    -- CanvasGroup-╨╛╨▒╤С╤А╤В╨║╨░ ╨┤╨░╤С╤В fade-╨░╨╜╨╕╨╝╨░╤Ж╨╕╤О ╤Б╨╝╨╡╨╜╤Л ╤Б╤В╤А╨░╨╜╨╕╤Ж╤Л (GroupTransparency)
    local cg = Instance.new("CanvasGroup", KV.PagesContainer)
    cg.Name = name.."Canvas"
    cg.BackgroundTransparency = 1
    cg.Size = UDim2.new(1, 0, 1, 0)
    cg.Visible = false
    cg.ZIndex = 5
    cg.GroupTransparency = 1
    local page = Instance.new("ScrollingFrame", cg)
    page.Name = name.."Page"; page.BackgroundTransparency = 1; page.Size = UDim2.new(1,0,1,0); page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.CanvasSize = UDim2.new(0,0,0,1250); page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = KV.AccentColor; page.Visible = true; page.ZIndex = 5
    CollectionService:AddTag(page, "AccentScroll")
    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0,8)
    pages[name] = cg
    pageCanvases[name] = cg
    return page
end

-- ╨б╨╛╨╖╨┤╨░╨╡╨╝ ╤А╨╛╨▓╨╜╨╛ 10 ╨а╨░╨╖╨┤╨╡╨╗╨╛╨▓
KV.clickGuiPage    = KV.createPage("ClickGUI")
KV.dashboardPage   = KV.createPage("Dashboard")
KV.trainingPage    = KV.createPage("Training")
KV.rocksPage       = KV.createPage("Rocks")
KV.combatPage      = KV.createPage("Combat")
KV.protectionPage  = KV.createPage("Protection")
KV.teleportsPage   = KV.createPage("Teleports")
KV.automationPage  = KV.createPage("Automation")
KV.petsPage        = KV.createPage("Pets")
KV.movementPage    = KV.createPage("Movement")
KV.visualsPage     = KV.createPage("Visuals")
KV.aboutPage       = KV.createPage("About")

KV.switchTab = function(tabName)
    currentTab = tabName
    for name, cg in pairs(pages) do
        local active = (name == tabName)
        if active then
            cg.Visible = true
            KV.tw(cg, {GroupTransparency = 0}, 0.18):Play()
        else
            local anim = KV.tw(cg, {GroupTransparency = 1}, 0.15)
            anim:Play()
            anim.Completed:Connect(function()
                if currentTab ~= name then cg.Visible = false end
            end)
        end
    end
    for name, entry in pairs(tabButtons) do
        local active = (name == tabName)
        entry.active = active
        KV.tw(entry.btn, {BackgroundTransparency = active and 0.9 or 1}, 0.2):Play()
        entry.nameLbl.TextColor3 = active and Color3.fromRGB(241, 245, 249) or Color3.fromRGB(148, 163, 184)
    end
    local info = TabInfo[tabName]
    if info then
        -- HUD (╨╖╨░╨│╨╛╨╗╨╛╨▓╨╛╨║/╨┐╨╛╨┤╨╖╨░╨│╨╛╨╗╨╛╨▓╨╛╨║ ╤Б╤В╤А╨░╨╜╨╕╤Ж╤Л) ╨▓╤Б╨╡╨│╨┤╨░ ╨╜╨░ ╨░╨╜╨│╨╗╨╕╨╣╤Б╨║╨╛╨╝
        KV.PageTitle.Text = info.title
        KV.PageSub.Text = info.sub or ""
    end
end

-- ╨Т╨║╨╗╨░╨┤╨║╨░ ╨▒╨╡╨╖ ╨╕╨║╨╛╨╜╨╛╨║ (╨║╨░╨║ ╨▓ ╤А╨╡╤Д╨╡╤А╨╡╨╜╤Б╨╡): ╤В╨╛╨╗╤М╨║╨╛ ╨║╨╛╤А╨╛╤В╨║╨╛╨╡ ╨╕╨╝╤П + hover-╨┐╨╛╨┤╤Б╨▓╨╡╤В╨║╨░
KV.createTabButton = function(displayName, internalName, subTitle)
    local btn = Instance.new("TextButton", KV.Sidebar)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 5
    KV.applyCorner(btn, 8)

    local nameLbl = Instance.new("TextLabel", btn)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Position = UDim2.new(0, 14, 0.5, -8)
    nameLbl.Size = UDim2.new(1, -22, 0, 16)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Text = displayName -- ╨▓╤Б╨╡╨│╨┤╨░ EN
    nameLbl.TextColor3 = Color3.fromRGB(148, 163, 184)
    nameLbl.TextSize = 11
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 6

    local entry = {btn = btn, nameLbl = nameLbl, active = false}
    btn.MouseEnter:Connect(function()
        if not entry.active then
            KV.tw(btn, {BackgroundTransparency = 0.95}, 0.12):Play()
            KV.tw(nameLbl, {TextColor3 = Color3.fromRGB(214, 216, 224)}, 0.12):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not entry.active then
            KV.tw(btn, {BackgroundTransparency = 1}, 0.15):Play()
            KV.tw(nameLbl, {TextColor3 = Color3.fromRGB(148, 163, 184)}, 0.15):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function() KV.switchTab(internalName) end)
    tabButtons[internalName] = entry
    TabInfo[internalName] = {title = displayName, sub = subTitle}
    return btn
end

-- 12 ╤А╨░╨╖╨┤╨╡╨╗╨╛╨▓: ╨║╨╛╤А╨╛╤В╨║╨╕╨╡ EN-╨╜╨░╨╖╨▓╨░╨╜╨╕╤П ╨▒╨╡╨╖ ╨╕╨║╨╛╨╜╨╛╨║ (HUD ╨▓╤Б╨╡╨│╨┤╨░ ╨╜╨░ ╨░╨╜╨│╨╗╨╕╨╣╤Б╨║╨╛╨╝)
KV.createTabButton("Settings", "ClickGUI", "Language, themes, GUI size and configs")
KV.createTabButton("Home", "Dashboard", "Stats and progress overview")
KV.createTabButton("Farm", "Training", "Gym machines and auto farm")
KV.createTabButton("Rocks", "Rocks", "Rock tiers and gyms")
KV.createTabButton("Combat", "Combat", "Kill aura and boss hunting")
KV.createTabButton("Protection", "Protection", "Defense and auto safe TP")
KV.createTabButton("Teleports", "Teleports", "World locations and waypoints")
KV.createTabButton("Auto", "Automation", "Crystals and auto actions")
KV.createTabButton("Pets", "Pets", "Pets and inventory")
KV.createTabButton("Movement", "Movement", "Movement and ESP")
KV.createTabButton("Visuals", "Visuals", "Sky, trails and jump effects")
KV.createTabButton("About", "About", "Owner harin | Discord harin")

-- UI ╨Ъ╨╛╨╝╨┐╨╛╨╜╨╡╨╜╤В╤Л ╤Б ╨Ш╨╜╨┤╨╕╨║╨░╤В╨╛╤А╨╛╨╝ ╨б╤В╨░╤В╤Г╤Б╨░ [╨Т╨Ъ╨Ы / ╨Т╨л╨Ъ╨Ы]
KV.accentToggles = {}

KV.bindTooltip = function(frame, descriptionText)
    frame.MouseEnter:Connect(function()
        if KV.Config.EnableTooltips then
            KV.DescTextLabel.Text = "Vortex : " .. tostring(KV.resolveText(descriptionText))
        end
    end)
    frame.MouseLeave:Connect(function()
        if KV.Config.EnableTooltips then
            KV.DescTextLabel.Text = "Vortex : " .. KV.t("╨Э╨░╨▓╨╡╨┤╨╕╤В╨╡ ╨║╤Г╤А╤Б╨╛╤А ╨╜╨░ ╤Д╤Г╨╜╨║╤Ж╨╕╤О ╨┤╨╗╤П ╨╛╨┐╨╕╤Б╨░╨╜╨╕╤П...", "Hover over feature to view description...")
        end
    end)
end

KV.sectionLabel = function(page, text)
    local lbl = Instance.new("TextLabel", page)
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1,-10,0,18); lbl.Font = Enum.Font.GothamBold; lbl.Text = string.upper(tostring(KV.resolveText(text))); lbl.TextColor3 = Color3.fromRGB(110, 118, 129); lbl.TextSize = 9; lbl.TextXAlignment = Enum.TextXAlignment.Left
    KV.bindText(lbl, function() return string.upper(tostring(KV.resolveText(text))) end)
    return lbl
end

KV.createGlassPanel = function(page, height)
    local panel = Instance.new("Frame", page)
    panel.BackgroundColor3 = KV.currentTheme().panel; panel.BackgroundTransparency = 0; panel.Size = UDim2.new(1,-10,0,height)
    CollectionService:AddTag(panel, "ThemePanel")
    KV.applyCorner(panel, 10); KV.applyStroke(panel, Color3.fromRGB(255,255,255), 0.94, 1)
    -- ╨╝╤П╨│╨║╨░╤П ╨┐╨╛╨┤╤Б╨▓╨╡╤В╨║╨░ ╨┐╤А╨╕ ╨╜╨░╨▓╨╡╨┤╨╡╨╜╨╕╨╕
    panel.MouseEnter:Connect(function()
        local base = KV.currentTheme().panel
        KV.tw(panel, {BackgroundColor3 = Color3.new(
            math.min(1, base.R + 0.05), math.min(1, base.G + 0.05), math.min(1, base.B + 0.05)
        )}, 0.12):Play()
    end)
    panel.MouseLeave:Connect(function()
        KV.tw(panel, {BackgroundColor3 = KV.currentTheme().panel}, 0.15):Play()
    end)
    return panel
end

-- ============================================================
-- ╨Я╨Ю╨Я╨Р╨Я ╨Э╨Р╨б╨в╨а╨Ю╨Х╨Ъ ╨д╨г╨Э╨Ъ╨ж╨Ш╨Ш: ╨Ы╨Ъ╨Ь ╨┐╨╛ ╨║╨░╤А╤В╨╛╤З╨║╨╡-╤В╤Г╨╝╨▒╨╗╨╡╤А╤Г ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╤В ╨╛╨║╨╜╨╛
-- ============================================================
KV.FuncPopupLayer = Instance.new("CanvasGroup", KV.ScreenGui)
KV.FuncPopupLayer.Name = "FuncPopupLayer"
KV.FuncPopupLayer.Size = UDim2.new(1, 0, 1, 0)
KV.FuncPopupLayer.BackgroundTransparency = 1
KV.FuncPopupLayer.Visible = false
KV.FuncPopupLayer.ZIndex = 30
KV.FuncPopupLayer.GroupTransparency = 1

KV.PopupBlocker = Instance.new("TextButton", KV.FuncPopupLayer)
KV.PopupBlocker.Size = UDim2.new(1, 0, 1, 0)
KV.PopupBlocker.BackgroundTransparency = 1
KV.PopupBlocker.Text = ""
KV.PopupBlocker.AutoButtonColor = false
KV.PopupBlocker.ZIndex = 31

KV.FuncPopup = Instance.new("Frame", KV.FuncPopupLayer)
KV.FuncPopup.Name = "FuncPopup"
KV.FuncPopup.AnchorPoint = Vector2.new(0.5, 0.5)
KV.FuncPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
KV.FuncPopup.Size = UDim2.new(0, 360, 0, 0)
KV.FuncPopup.AutomaticSize = Enum.AutomaticSize.Y
KV.FuncPopup.BackgroundColor3 = KV.currentTheme().window
KV.FuncPopup.BorderSizePixel = 0
KV.FuncPopup.ZIndex = 32
CollectionService:AddTag(KV.FuncPopup, "ThemeWindow")
KV.applyCorner(KV.FuncPopup, 14)
KV.popupStroke = KV.applyStroke(KV.FuncPopup, KV.AccentColor, 0.5, 1)
CollectionService:AddTag(KV.popupStroke, "AccentStroke")

KV.FuncPopupScale = Instance.new("UIScale", KV.FuncPopup)
KV.FuncPopupScale.Scale = 0.94

KV.popupLayout = Instance.new("UIListLayout", KV.FuncPopup)
KV.popupLayout.SortOrder = Enum.SortOrder.LayoutOrder
KV.popupLayout.Padding = UDim.new(0, 8)

KV.popupPad = Instance.new("UIPadding", KV.FuncPopup)
KV.popupPad.PaddingTop = UDim.new(0, 16); KV.popupPad.PaddingBottom = UDim.new(0, 16)
KV.popupPad.PaddingLeft = UDim.new(0, 16); KV.popupPad.PaddingRight = UDim.new(0, 16)

KV.PopTitle = Instance.new("TextLabel", KV.FuncPopup)
KV.PopTitle.Name = "PopTitle"
KV.PopTitle.BackgroundTransparency = 1
KV.PopTitle.LayoutOrder = 1
KV.PopTitle.Size = UDim2.new(1, -30, 0, 20)
KV.PopTitle.Font = Enum.Font.GothamBold
KV.PopTitle.Text = ""
KV.PopTitle.TextColor3 = Color3.fromRGB(241, 245, 249)
KV.PopTitle.TextSize = 14
KV.PopTitle.TextXAlignment = Enum.TextXAlignment.Left
KV.PopTitle.ZIndex = 33

KV.PopDesc = Instance.new("TextLabel", KV.FuncPopup)
KV.PopDesc.Name = "PopDesc"
KV.PopDesc.BackgroundTransparency = 1
KV.PopDesc.LayoutOrder = 2
KV.PopDesc.Size = UDim2.new(1, 0, 0, 0)
KV.PopDesc.AutomaticSize = Enum.AutomaticSize.Y
KV.PopDesc.Font = Enum.Font.Gotham
KV.PopDesc.Text = ""
KV.PopDesc.TextWrapped = true
KV.PopDesc.TextColor3 = Color3.fromRGB(148, 163, 184)
KV.PopDesc.TextSize = 10
KV.PopDesc.TextXAlignment = Enum.TextXAlignment.Left
KV.PopDesc.ZIndex = 33

-- ╨Ъ╤А╨╡╤Б╤В╨╕╨║ ╨╢╨╕╨▓╤С╤В ╨▓╨╜╤Г╤В╤А╨╕ ╨╖╨░╨│╨╛╨╗╨╛╨▓╨║╨░: ╨╕╨╜╨░╤З╨╡ UIListLayout ╨┐╨╛╨┐╨░╨┐╨░ ╨┐╨╡╤А╨╡╤Е╨▓╨░╤В╤Л╨▓╨░╨╡╤В ╨╡╨│╨╛
-- Position ╨╕ ╨║╨╜╨╛╨┐╨║╨░ ╤Г╨╡╨╖╨╢╨░╨╡╤В ╨┐╨╡╤А╨▓╤Л╨╝ ╤Н╨╗╨╡╨╝╨╡╨╜╤В╨╛╨╝ ╤Б╨┐╨╕╤Б╨║╨░ (╤Б╨╗╨╡╨▓╨░-╤Б╨▓╨╡╤А╤Е╤Г, ╨┐╨╡╤А╨╡╨║╤А╤Л╨▓╨░╨╡╤В╤Б╤П ╤В╨╡╨╗╨╛╨╝)
KV.PopCloseBtn = Instance.new("TextButton", KV.PopTitle)
KV.PopCloseBtn.Name = "PopClose"
KV.PopCloseBtn.AnchorPoint = Vector2.new(1, 0.5)
KV.PopCloseBtn.Position = UDim2.new(1, 0, 0.5, 0)
KV.PopCloseBtn.Size = UDim2.new(0, 26, 0, 26)
KV.PopCloseBtn.BackgroundTransparency = 1
KV.PopCloseBtn.Text = "тЬХ"
KV.PopCloseBtn.Font = Enum.Font.GothamBold
KV.PopCloseBtn.TextSize = 12
KV.PopCloseBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
KV.PopCloseBtn.ZIndex = 34
KV.PopCloseBtn.AutoButtonColor = false

KV.closeFuncPopup = function()
    if not KV.FuncPopupLayer.Visible then return end
    local anim = KV.tw(KV.FuncPopupLayer, {GroupTransparency = 1}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    KV.tw(KV.FuncPopupScale, {Scale = 0.97}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
    anim:Play()
    local done = false
    local function hide()
        if done then return end
        done = true
        if KV.FuncPopupLayer.GroupTransparency >= 0.99 then KV.FuncPopupLayer.Visible = false end
    end
    anim.Completed:Connect(hide)
    task.delay(0.3, hide) -- ╤Б╤В╤А╨░╤Е╨╛╨▓╨║╨░: ╨╡╤Б╨╗╨╕ ╤В╨▓╨╕╨╜ ╨┐╤А╨╡╤А╨▓╨░╨╜ тАФ ╨▓╤Б╤С ╤А╨░╨▓╨╜╨╛ ╤Б╨║╤А╤Л╤В╤М
end

-- buildBody(parent) ╤Б╨╛╨╖╨┤╨░╤С╤В ╤В╨╡╨╗╨╛ popup; ╨▓╤Б╨╡ ╨╡╨│╨╛ ╨┤╨╛╤З╨╡╤А╨╜╨╕╨╡ GuiObject
-- (╨║╤А╨╛╨╝╨╡ ╨╖╨░╨│╨╛╨╗╨╛╨▓╨║╨░/╨╛╨┐╨╕╤Б╨░╨╜╨╕╤П/╨║╤А╨╡╤Б╤В╨╕╨║╨░) ╨┐╨╛╨┐╨░╨┤╨░╤О╤В ╨▓ ╨╛╨▒╤Й╨╕╨╣ ╤Б╨┐╨╕╤Б╨╛╨║ LayoutOrder
KV.openFuncPopup = function(title, desc, buildBody)
    for _, child in ipairs(KV.FuncPopup:GetChildren()) do
        if child:IsA("GuiObject") and child:GetAttribute("PopupBody") then
            child:Destroy()
        end
    end
    KV.PopTitle.Text = tostring(KV.resolveText(title or ""))
    KV.PopDesc.Text = tostring(KV.resolveText(desc or ""))
    KV.PopDesc.Visible = (desc ~= nil and desc ~= "")
    if buildBody then
        local ok, err = pcall(buildBody, KV.FuncPopup)
        if not ok then warn("[Vortex] popup body error: " .. tostring(err)) end
    end
    local order = 2
    for _, child in ipairs(KV.FuncPopup:GetChildren()) do
        if child:IsA("GuiObject") and child ~= KV.PopTitle and child ~= KV.PopDesc and child ~= KV.PopCloseBtn then
            child:SetAttribute("PopupBody", true)
            order = order + 1
            child.LayoutOrder = order
        end
    end
    KV.FuncPopupLayer.Visible = true
    KV.FuncPopupLayer.GroupTransparency = 1
    KV.FuncPopupScale.Scale = 0.97
    KV.tw(KV.FuncPopupLayer, {GroupTransparency = 0}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
    KV.tw(KV.FuncPopupScale, {Scale = 1}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
end

KV.PopupBlocker.MouseButton1Click:Connect(KV.closeFuncPopup)
KV.PopCloseBtn.MouseButton1Click:Connect(KV.closeFuncPopup)
KV.PopCloseBtn.MouseEnter:Connect(function()
    KV.tw(KV.PopCloseBtn, {TextColor3 = Color3.fromRGB(248, 113, 113)}, 0.12):Play()
end)
KV.PopCloseBtn.MouseLeave:Connect(function()
    KV.tw(KV.PopCloseBtn, {TextColor3 = Color3.fromRGB(148, 163, 184)}, 0.12):Play()
end)

-- ╨в╤Г╨╝╨▒╨╗╨╡╤А ╨▓╨╜╤Г╤В╤А╨╕ popup (╨╛╨▒╤Й╨╕╨╣ ╨▓╨╕╨┤ ╤Б ╨║╨░╤А╤В╨╛╤З╨║╨╛╨╣)
KV.buildPopupSwitch = function(parent, getState, onFlip)
    local row = Instance.new("TextButton", parent)
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = KV.currentTheme().panel
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.ZIndex = 33
    CollectionService:AddTag(row, "ThemePanel")
    KV.applyCorner(row, 10)
    KV.applyStroke(row, Color3.fromRGB(255, 255, 255), 0.94, 1)

    local rowLbl = Instance.new("TextLabel", row)
    rowLbl.BackgroundTransparency = 1
    rowLbl.Position = UDim2.new(0, 14, 0.5, -8)
    rowLbl.Size = UDim2.new(1, -70, 0, 16)
    rowLbl.Font = Enum.Font.GothamBold
    rowLbl.Text = getState() and KV.t("╨Т╨║╨╗╤О╤З╨╡╨╜╨╛", "Enabled") or KV.t("╨Т╤Л╨║╨╗╤О╤З╨╡╨╜╨╛", "Disabled")
    rowLbl.TextColor3 = getState() and KV.AccentColor or Color3.fromRGB(148, 163, 184)
    rowLbl.TextSize = 11
    rowLbl.TextXAlignment = Enum.TextXAlignment.Left
    rowLbl.ZIndex = 34

    local indicator = Instance.new("Frame", row)
    indicator.AnchorPoint = Vector2.new(1, 0.5)
    indicator.Position = UDim2.new(1, -14, 0.5, 0)
    indicator.Size = UDim2.new(0, 44, 0, 22)
    indicator.BackgroundColor3 = getState() and KV.AccentColor or Color3.fromRGB(51, 65, 85)
    indicator.ZIndex = 34
    KV.applyCorner(indicator, 11)

    local dot = Instance.new("Frame", indicator)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.Position = getState() and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.ZIndex = 35
    KV.applyCorner(dot, 8)

    local function paint()
        local on = getState()
        rowLbl.Text = on and KV.t("╨Т╨║╨╗╤О╤З╨╡╨╜╨╛", "Enabled") or KV.t("╨Т╤Л╨║╨╗╤О╤З╨╡╨╜╨╛", "Disabled")
        KV.tw(rowLbl, {TextColor3 = on and KV.AccentColor or Color3.fromRGB(148, 163, 184)}, 0.15):Play()
        KV.tw(indicator, {BackgroundColor3 = on and KV.AccentColor or Color3.fromRGB(51, 65, 85)}, 0.15):Play()
        KV.tw(dot, {Position = on and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}, 0.15):Play()
    end

    row.MouseButton1Click:Connect(function()
        onFlip()
        paint()
    end)
    return paint
end

KV.createButton = function(page, name, desc, callback, extras)
    local panel = KV.createGlassPanel(page, 46)
    local btn = Instance.new("TextButton", panel)
    btn.BackgroundTransparency = 1; btn.Size = UDim2.new(1,0,1,0); btn.Text = ""; btn.ZIndex = 2

    local lbl = Instance.new("TextLabel", panel)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,14,0,6); lbl.Size = UDim2.new(1,-50,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = KV.resolveText(name); lbl.TextColor3 = Color3.fromRGB(241,245,249); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    KV.bindText(lbl, function() return KV.resolveText(name) end)

    local descLbl = Instance.new("TextLabel", panel)
    descLbl.BackgroundTransparency = 1; descLbl.Position = UDim2.new(0,14,0,24); descLbl.Size = UDim2.new(1,-50,0,16)
    descLbl.Font = Enum.Font.Gotham; descLbl.Text = KV.resolveText(desc); descLbl.TextColor3 = Color3.fromRGB(148,163,184); descLbl.TextSize = 9; descLbl.TextXAlignment = Enum.TextXAlignment.Left
    KV.bindText(descLbl, function() return KV.resolveText(desc) end)

    local chev = Instance.new("TextLabel", panel)
    chev.BackgroundTransparency = 1; chev.AnchorPoint = Vector2.new(1,0.5); chev.Position = UDim2.new(1,-16,0.5,0); chev.Size = UDim2.new(0,18,0,18)
    chev.Font = Enum.Font.GothamBold; chev.Text = "тА║"; chev.TextColor3 = Color3.fromRGB(148,163,184); chev.TextSize = 16; chev.ZIndex = 3

    KV.bindTooltip(btn, desc)

    btn.MouseButton1Click:Connect(function()
        -- ╤Б ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨░╨╝╨╕ (extras) тАФ ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╨╝ popup; ╤З╨╕╤Б╤В╨╛╨╡ ╨┤╨╡╨╣╤Б╤В╨▓╨╕╨╡ тАФ ╨▓╤Л╨┐╨╛╨╗╨╜╤П╨╡╨╝ ╤Б╤А╨░╨╖╤Г
        if extras then
            KV.openFuncPopup(name, desc, function(body)
                extras(body)
                local run = Instance.new("TextButton", body)
                run.Size = UDim2.new(1, 0, 0, 40)
                run.BackgroundColor3 = KV.AccentColor
                run.BorderSizePixel = 0
                run.Text = KV.t("╨Ч╨░╨┐╤Г╤Б╤В╨╕╤В╤М", "Run")
                run.Font = Enum.Font.GothamBold
                run.TextSize = 12
                run.TextColor3 = Color3.fromRGB(17, 17, 20)
                run.AutoButtonColor = false
                run.ZIndex = 33
                CollectionService:AddTag(run, "AccentFill")
                KV.applyCorner(run, 10)
                run.MouseButton1Click:Connect(function()
                    KV.closeFuncPopup()
                    callback()
                end)
            end)
            return
        end
        KV.tw(panel, {BackgroundColor3 = KV.AccentColor, BackgroundTransparency = 0}, 0.1):Play()
        task.delay(0.15, function() KV.tw(panel, {BackgroundColor3 = KV.currentTheme().panel, BackgroundTransparency = 0}, 0.15):Play() end)
        callback()
    end)
    return panel
end

KV.createToggle = function(page, name, desc, default, callback, extras)
    local btn = KV.createGlassPanel(page, 48)
    local clickArea = Instance.new("TextButton", btn)
    clickArea.BackgroundTransparency = 1; clickArea.Size = UDim2.new(1,0,1,0); clickArea.Text = ""; clickArea.ZIndex = 2

    local state = default

    local lbl = Instance.new("TextLabel", btn)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,14,0,7); lbl.Size = UDim2.new(1,-70,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = KV.resolveText(name); lbl.TextColor3 = Color3.fromRGB(226,232,240); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    KV.bindText(lbl, function() return KV.resolveText(name) end)

    local descLbl = Instance.new("TextLabel", btn)
    descLbl.BackgroundTransparency = 1; descLbl.Position = UDim2.new(0,14,0,26); descLbl.Size = UDim2.new(1,-70,0,16)
    descLbl.Font = Enum.Font.Gotham; descLbl.Text = KV.resolveText(desc); descLbl.TextColor3 = Color3.fromRGB(148,163,184); descLbl.TextSize = 9; descLbl.TextXAlignment = Enum.TextXAlignment.Left
    KV.bindText(descLbl, function() return KV.resolveText(desc) end)

    local indicator = Instance.new("Frame", btn)
    indicator.AnchorPoint = Vector2.new(1,0.5); indicator.Position = UDim2.new(1,-14,0.5,0); indicator.Size = UDim2.new(0,38,0,20)
    indicator.BackgroundColor3 = state and KV.AccentColor or Color3.fromRGB(51,65,85)
    indicator.ZIndex = 3
    KV.applyCorner(indicator, 10)

    local dot = Instance.new("Frame", indicator)
    dot.AnchorPoint = Vector2.new(0,0.5); dot.Position = state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)
    dot.Size = UDim2.new(0,14,0,14); dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dot.ZIndex = 4
    KV.applyCorner(dot, 7)

    KV.bindTooltip(clickArea, desc)
    table.insert(KV.accentToggles, {indicator = indicator, getState = function() return state end})

    local function paintCard()
        KV.tw(indicator, {BackgroundColor3 = state and KV.AccentColor or Color3.fromRGB(51,65,85)}, 0.15):Play()
        KV.tw(dot, {Position = state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)}, 0.15):Play()
    end

    -- ╨Ы╨Ъ╨Ь ╨┐╨╛ ╨║╨░╤А╤В╨╛╤З╨║╨╡: ╨╛╤В╨║╤А╤Л╤В╤М ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨╕ (popup ╤Б ╤В╤Г╨╝╨▒╨╗╨╡╤А╨╛╨╝)
    clickArea.MouseButton1Click:Connect(function()
        KV.openFuncPopup(name, desc, function(body)
            KV.buildPopupSwitch(body, function() return state end, function()
                state = not state
                paintCard()
                callback(state)
            end)
            if extras then extras(body) end
        end)
    end)
    local function setState(v)
        state = (v == true)
        paintCard()
    end
    return btn, setState
end

KV.createSlider = function(page, name, min, max, default, callback, colorAccent, desc)
    local sliderFrame = KV.createGlassPanel(page, 56)
    local lbl = Instance.new("TextLabel", sliderFrame)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,12,0,6); lbl.Size = UDim2.new(0,250,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = KV.resolveText(name); lbl.TextColor3 = Color3.fromRGB(241,245,249); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    KV.bindText(lbl, function() return KV.resolveText(name) end)

    local valLbl = Instance.new("TextLabel", sliderFrame)
    valLbl.BackgroundTransparency = 1; valLbl.Position = UDim2.new(1,-70,0,6); valLbl.Size = UDim2.new(0,58,0,16)
    valLbl.Font = Enum.Font.GothamBold; valLbl.Text = tostring(default); valLbl.TextColor3 = colorAccent or KV.AccentColor; valLbl.TextSize = 11; valLbl.TextXAlignment = Enum.TextXAlignment.Right
    if not colorAccent then CollectionService:AddTag(valLbl, "AccentText") end

    local BarBG = Instance.new("TextButton", sliderFrame)
    BarBG.BackgroundColor3 = Color3.fromRGB(51,65,85); BarBG.BorderSizePixel = 0; BarBG.Position = UDim2.new(0,12,0,34); BarBG.Size = UDim2.new(1,-24,0,8); BarBG.AutoButtonColor = false; BarBG.Text = ""
    KV.applyCorner(BarBG, 4)

    local BarFill = Instance.new("Frame", BarBG)
    BarFill.BackgroundColor3 = colorAccent or KV.AccentColor; BarFill.BorderSizePixel = 0; BarFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    KV.applyCorner(BarFill, 4)
    if not colorAccent then CollectionService:AddTag(BarFill, "AccentFill") end

    local Knob = Instance.new("Frame", BarBG)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 3
    KV.applyCorner(Knob, 7)

    KV.bindTooltip(BarBG, desc or function()
        return KV.t("╨Э╨░╤Б╤В╤А╨╛╨╣╨║╨░ ╨┐╨░╤А╨░╨╝╨╡╤В╤А╨░ ", "Adjust parameter ") .. KV.resolveText(name)
    end)

    local sdragging = false
    BarBG.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sdragging = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sdragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if sdragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation()
            local relX = math.clamp((mousePos.X - BarBG.AbsolutePosition.X)/BarBG.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max-min)*relX)
            BarFill.Size = UDim2.new(relX,0,1,0)
            Knob.Position = UDim2.new(relX, 0, 0.5, 0)
            valLbl.Text = tostring(val)
            callback(val)
        end
    end)
    return {fill = BarFill, valLbl = valLbl}
end

KV.createColorSwatchGrid = function(page, presets, onPick, size)
    local Row = Instance.new("Frame", page)
    Row.BackgroundTransparency = 1; Row.Size = UDim2.new(1,0,0, math.ceil(#presets/6) * (size+6) + 6)
    local grid = Instance.new("UIGridLayout", Row)
    grid.CellSize = UDim2.new(0,size,0,size); grid.CellPadding = UDim2.new(0,6,0,6)

    local selectedStroke = nil
    for _, preset in ipairs(presets) do
        local swatch = Instance.new("TextButton", Row)
        swatch.BackgroundColor3 = preset.color; swatch.AutoButtonColor = false; swatch.Text = ""
        KV.applyCorner(swatch, size/2)
        local sStroke = KV.applyStroke(swatch, Color3.fromRGB(255,255,255), 0.6, 1.5)

        KV.bindTooltip(swatch, function()
            return KV.t("╨Я╤А╨╕╨╝╨╡╨╜╨╕╤В╤М ╤Ж╨▓╨╡╤В╨╛╨▓╨╛╨╣ ╨┐╤А╨╡╤Б╨╡╤В: ", "Apply color preset: ") .. preset.name
        end)

        swatch.MouseButton1Click:Connect(function()
            onPick(preset.color)
            if selectedStroke then KV.tw(selectedStroke, {Transparency = 0.6, Thickness = 1.5}, 0.15):Play() end
            KV.tw(sStroke, {Transparency = 0, Thickness = 2.5}, 0.15):Play()
            selectedStroke = sStroke
        end)
    end
    return Row
end

KV.applyAccent = function(newColor)
    KV.AccentColor = newColor
    for _, inst in ipairs(CollectionService:GetTagged("AccentStroke")) do KV.tw(inst, {Color = newColor}, 0.25):Play() end
    for _, inst in ipairs(CollectionService:GetTagged("AccentFill")) do KV.tw(inst, {BackgroundColor3 = newColor}, 0.25):Play() end
    for _, inst in ipairs(CollectionService:GetTagged("AccentText")) do KV.tw(inst, {TextColor3 = newColor}, 0.25):Play() end
    for _, tog in ipairs(KV.accentToggles) do if tog.getState() then KV.tw(tog.indicator, {BackgroundColor3 = newColor}, 0.25):Play() end end
end

-- ╨Я╤А╨╕╨╝╨╡╨╜╨╡╨╜╨╕╨╡ ╤В╨╡╨╝╤Л ╨╛╨║╨╜╨░ (╤Б╨┐╨╗╨╛╤И╨╜╤Л╨╡ ╤Д╨╛╨╜╤Л, ╨▒╨╡╨╖ ╨┐╤А╨╛╨╖╤А╨░╤З╨╜╨╛╤Б╤В╨╕)
KV.applyTheme = function(idx)
    if not KV.UIThemes[idx] then idx = 1 end
    KV.Config.ThemeIndex = idx
    local theme = KV.UIThemes[idx]
    for _, inst in ipairs(CollectionService:GetTagged("ThemeWindow")) do
        KV.tw(inst, {BackgroundColor3 = theme.window, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemeBar")) do
        KV.tw(inst, {BackgroundColor3 = theme.bar, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemeSide")) do
        KV.tw(inst, {BackgroundColor3 = theme.side, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemePanel")) do
        KV.tw(inst, {BackgroundColor3 = theme.panel, BackgroundTransparency = 0}, 0.25):Play()
    end
    KV.applyAccent(theme.accent)
    if currentTab and pages[currentTab] then
        KV.switchTab(currentTab)
    end
end

-- ╨н╨║╤А╨░╨╜ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕ ╨╕ ╨░╨╜╨╕╨╝╨░╤Ж╨╕╨╕ ╨╝╨╡╨╜╤О ╨╛╨┐╤А╨╡╨┤╨╡╨╗╨╡╨╜╤Л ╨▓ ╨║╨╛╨╜╤Ж╨╡ ╤Д╨░╨╣╨╗╨░ (playLoadingSequence / openMenu / closeMenu)

-- ============================================================
-- 1. ╨а╨Р╨Ч╨Ф╨Х╨Ы: SETTINGS (╨▒╤Л╨▓╤И╨╕╨╣ ClickGUI)
-- ============================================================
KV.sectionLabel(KV.clickGuiPage, "GUI SIZE & LAYOUT")
KV.guiSizeScale = Instance.new("UIScale", KV.MainFrame)
KV.guiSizeScale.Scale = KV.Config.GuiScale
KV.createSlider(KV.clickGuiPage, "GUI Size (%)", 70, 150, math.floor(KV.Config.GuiScale * 100 + 0.5), function(v)
    KV.Config.GuiScale = v / 100
    KV.tw(KV.guiSizeScale, {Scale = KV.Config.GuiScale}, 0.12):Play()
end, nil, "Overall scale of the Vortex window (70% - 150%)")

KV.sectionLabel(KV.clickGuiPage, "LANGUAGE & THEME PRESETS")
KV.createButton(KV.clickGuiPage, "Switch Language / ╨б╨╝╨╡╨╜╨╕╤В╤М ╨п╨╖╤Л╨║ (RU / EN)", "╨Я╨╡╤А╨╡╨║╨╗╤О╤З╨░╨╡╤В ╤П╨╖╤Л╨║ ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░ ╨╝╨╡╨╢╨┤╤Г ╨а╤Г╤Б╤Б╨║╨╕╨╝ ╨╕ English", function()
    KV.Config.Language = (KV.Config.Language == "RU") and "EN" or "RU"
    KV.applyLanguage()
    KV.notify("Vortex Language", KV.tn("╨п╨╖╤Л╨║ ╨╕╨╖╨╝╨╡╨╜╨╡╨╜ ╨╜╨░ ╨а╤Г╤Б╤Б╨║╨╕╨╣", "Language changed to English"), 3)
end)

KV.createButton(KV.clickGuiPage, "Switch Theme (╨б╨╝╨╡╨╜╨╕╤В╤М ╨в╨╡╨╝╤Г)", function()
    return KV.t("╨в╨╡╨║╤Г╤Й╨░╤П ╤В╨╡╨╝╨░: ", "Current theme: ") .. KV.UIThemes[KV.Config.ThemeIndex].name
        .. KV.t(" тАФ ╨╜╨░╨╢╨╝╨╕╤В╨╡ ╨┤╨╗╤П ╤Б╨╗╨╡╨┤╤Г╤О╤Й╨╡╨╣ (Black тЖТ Slate тЖТ Midnight тЖТ Crimson тЖТ Cyberpunk)", " тАФ click for next (Black тЖТ Slate тЖТ Midnight тЖТ Crimson тЖТ Cyberpunk)")
end, function()
    local nextIdx = (KV.Config.ThemeIndex % #KV.UIThemes) + 1
    KV.applyTheme(nextIdx)
    KV.notify("Vortex Theme", KV.tn("╨в╨╡╨╝╨░: ", "Theme: ") .. KV.UIThemes[nextIdx].name, 2)
end)

local rSlider, gSlider, bSlider
KV.createColorSwatchGrid(KV.clickGuiPage, KV.AccentPresets, function(color)
    KV.applyAccent(color)
    rSlider.fill.Size = UDim2.new(color.R,0,1,0); rSlider.valLbl.Text = tostring(KV.round(color.R*255))
    gSlider.fill.Size = UDim2.new(color.G,0,1,0); gSlider.valLbl.Text = tostring(KV.round(color.G*255))
    bSlider.fill.Size = UDim2.new(color.B,0,1,0); bSlider.valLbl.Text = tostring(KV.round(color.B*255))
end, 36)

KV.sectionLabel(KV.clickGuiPage, "CUSTOM RGB ACCENT")
local currentR, currentG, currentB = KV.AccentColor.R*255, KV.AccentColor.G*255, KV.AccentColor.B*255
KV.updateCustomColor = function()
    local newColor = Color3.fromRGB(KV.round(currentR), KV.round(currentG), KV.round(currentB))
    KV.applyAccent(newColor)
end

rSlider = KV.createSlider(KV.clickGuiPage, "Red Accent", 0, 255, KV.round(currentR), function(v) currentR=v; KV.updateCustomColor() end, Color3.fromRGB(248,113,113), "╨Ъ╤А╨░╤Б╨╜╤Л╨╣ ╤Ж╨▓╨╡╤В ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░")
gSlider = KV.createSlider(KV.clickGuiPage, "Green Accent", 0, 255, KV.round(currentG), function(v) currentG=v; KV.updateCustomColor() end, Color3.fromRGB(74,222,128), "╨Ч╨╡╨╗╨╡╨╜╤Л╨╣ ╤Ж╨▓╨╡╤В ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░")
bSlider = KV.createSlider(KV.clickGuiPage, "Blue Accent", 0, 255, KV.round(currentB), function(v) currentB=v; KV.updateCustomColor() end, Color3.fromRGB(96,165,250), "╨б╨╕╨╜╨╕╨╣ ╤Ж╨▓╨╡╤В ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░")

-- ============================================================
-- SAVED CONFIGS: ╤Б╨╛╤Е╤А╨░╨╜╨╡╨╜╨╕╨╡/╨╖╨░╨│╤А╤Г╨╖╨║╨░ ╨╜╨░╤Б╤В╤А╨╛╨╡╨║ ╨▓ ╨▒╤Г╤Д╨╡╤А ╨╛╨▒╨╝╨╡╨╜╨░
-- ============================================================
KV.sectionLabel(KV.clickGuiPage, "SAVED CONFIGS")

KV.serializeConfig = function()
    local parts = {}
    for k, v in pairs(KV.Config) do
        local tv = type(v)
        if tv == "boolean" or tv == "number" or tv == "string" then
            table.insert(parts, k .. "=" .. tostring(v))
        end
    end
    table.sort(parts)
    return "VORTEX_CONFIG;" .. table.concat(parts, ";")
end

KV.deserializeConfig = function(str)
    if type(str) ~= "string" or not string.find(str, "VORTEX_CONFIG", 1, true) then
        return nil, KV.tn("╨С╤Г╤Д╨╡╤А ╨╛╨▒╨╝╨╡╨╜╨░ ╨╜╨╡ ╤Б╨╛╨┤╨╡╤А╨╢╨╕╤В ╨║╨╛╨╜╤Д╨╕╨│╨░ Vortex", "Clipboard does not contain a Vortex config")
    end
    local loaded = 0
    for entry in string.gmatch(str, "[^;]+") do
        local k, v = string.match(entry, "^([%w_]+)=(.*)$")
        if k ~= nil and KV.Config[k] ~= nil then
            local cur = KV.Config[k]
            local tv = type(cur)
            if tv == "boolean" then
                if v == "true" then KV.Config[k] = true loaded = loaded + 1
                elseif v == "false" then KV.Config[k] = false loaded = loaded + 1 end
            elseif tv == "number" then
                local n = tonumber(v)
                if n ~= nil then KV.Config[k] = n loaded = loaded + 1 end
            elseif tv == "string" then
                KV.Config[k] = v loaded = loaded + 1
            end
        end
    end
    if loaded == 0 then
        return nil, KV.tn("╨Э╨╡ ╤Г╨┤╨░╨╗╨╛╤Б╤М ╨┐╤А╨╕╨╝╨╡╨╜╨╕╤В╤М ╨╖╨╜╨░╤З╨╡╨╜╨╕╤П ╨╕╨╖ ╨▒╤Г╤Д╨╡╤А╨░", "Failed to apply values from clipboard")
    end
    return loaded, nil
end

KV.readClipboardText = function()
    local ok, res = pcall(function()
        if type(readclipboard) == "function" then return readclipboard() end
        local g = getgenv and getgenv()
        if g and type(g.readclipboard) == "function" then return g.readclipboard() end
        error("no clipboard reader")
    end)
    if ok and type(res) == "string" then return res end
    return nil
end

KV.createButton(KV.clickGuiPage, "Save Config to Clipboard", "╨б╨╛╤Е╤А╨░╨╜╤П╨╡╤В ╨▓╤Б╨╡ ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨╕ Vortex ╨▓ ╨▒╤Г╤Д╨╡╤А ╨╛╨▒╨╝╨╡╨╜╨░", function()
    local ok = pcall(function() setclipboard(KV.serializeConfig()) end)
    if ok then
        KV.notify("Vortex Config", "Config copied to clipboard!", 3)
    else
        KV.notify("Vortex Config", "Clipboard is not available in this injector", 4)
    end
end)

KV.createButton(KV.clickGuiPage, "Load Config from Clipboard", "╨Ч╨░╨│╤А╤Г╨╢╨░╨╡╤В ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨╕ Vortex ╨╕╨╖ ╨▒╤Г╤Д╨╡╤А╨░ ╨╛╨▒╨╝╨╡╨╜╨░", function()
    local text = KV.readClipboardText()
    if not text then
        KV.notify("Vortex Config", "Clipboard read is not available in this injector", 4)
        return
    end
    local loaded, err = KV.deserializeConfig(text)
    if not loaded then
        KV.notify("Vortex Config", err or "Invalid config", 4)
        return
    end
    pcall(function()
        KV.applyTheme(KV.Config.ThemeIndex or 1)
        KV.tw(KV.guiSizeScale, {Scale = tonumber(KV.Config.GuiScale) or 1}, 0.12):Play()
        KV.DescFooterBar.Visible = KV.Config.EnableTooltips ~= false
    end)
    KV.notify("Vortex Config", "Config loaded: " .. tostring(loaded) .. " options applied", 3)
end)

KV.sectionLabel(KV.clickGuiPage, "INTERFACE GLASS & SETTINGS")
KV.createToggle(KV.clickGuiPage, "Glow Outline", "╨Я╤Г╨╗╤М╤Б╨╕╤А╤Г╤О╤Й╨░╤П ╨╜╨╡╨╛╨╜╨╛╨▓╨░╤П ╤А╨░╨╝╨║╨░ ╨╝╨╡╨╜╤О", KV.Config.Glow, function(v)
    KV.Config.Glow = v; KV.tw(KV.MainStroke, {Transparency = v and 0.3 or 0.8}, 0.3):Play()
end)
KV.createSlider(KV.clickGuiPage, "Glass Blur Intensity", 0, 100, KV.Config.GlassIntensity, function(v)
    KV.Config.GlassIntensity = v
    KV.GlassLayer2.BackgroundTransparency = 0.15 + (1 - v/100) * 0.5
end, nil, "╨Ш╨╜╤В╨╡╨╜╤Б╨╕╨▓╨╜╨╛╤Б╤В╤М ╤А╨░╨╖╨╝╤Л╤В╨╕╤П ╤Б╤В╨╡╨║╨╗╨░")

KV.createToggle(KV.clickGuiPage, "Hover Description Bar", "╨Ю╤В╨╛╨▒╤А╨░╨╢╨╡╨╜╨╕╨╡ ╨╛╨┐╨╕╤Б╨░╨╜╨╕╤П ╤Д╤Г╨╜╨║╤Ж╨╕╨╣ ╨▓╨╜╨╕╨╖╤Г ╤Н╨║╤А╨░╨╜╨░", KV.Config.EnableTooltips, function(v)
    KV.Config.EnableTooltips = v
    KV.DescFooterBar.Visible = v
end)

KV.createButton(KV.clickGuiPage, "Optimize FPS (Smooth Plastic)", "╨г╨┤╨░╨╗╤П╨╡╤В ╤В╨╡╨║╤Б╤В╤Г╤А╤Л ╨║╨░╤А╤В╤Л ╨┤╨╗╤П ╤Г╨▓╨╡╨╗╨╕╤З╨╡╨╜╨╕╤П FPS", function()
    pcall(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        end
        Lighting.GlobalShadows = false
    end)
    KV.notify("FPS Boost", "Map textures optimized!", 2)
end)

-- Unload ╨║╨╜╨╛╨┐╨║╨░ ╨╕╤Б╨┐╨╛╨╗╤М╨╖╤Г╨╡╤В ╨╛╨▒╤Й╤Г╤О completeScriptUnload (╨╛╨┐╤А╨╡╨┤╨╡╨╗╨╡╨╜╨░ ╨▓╤Л╤И╨╡, ╤Г ╤И╨░╨┐╨║╨╕ ╨╛╨║╨╜╨░)
KV.createButton(KV.clickGuiPage, "Unload & Terminate Vortex", "╨Я╨╛╨╗╨╜╨░╤П ╨▓╤Л╨│╤А╤Г╨╖╨║╨░ ╤Б╨║╤А╨╕╨┐╤В╨░ Vortex  ╨╕ ╨╛╤З╨╕╤Б╤В╨║╨░ ╨┐╨░╨╝╤П╤В╨╕", KV.completeScriptUnload)

-- ============================================================
-- 2. ╨а╨Р╨Ч╨Ф╨Х╨Ы: DASHBOARD
-- ============================================================
KV.sectionLabel(KV.dashboardPage, "Vortex тАв Player Live Overview")
KV.StatsPanel = KV.createGlassPanel(KV.dashboardPage, 110)
KV.StatsText = Instance.new("TextLabel", KV.StatsPanel)
KV.StatsText.BackgroundTransparency = 1; KV.StatsText.Position = UDim2.new(0, 12, 0, 10); KV.StatsText.Size = UDim2.new(1, -24, 1, -20)
KV.StatsText.Font = Enum.Font.GothamMedium; KV.StatsText.TextColor3 = Color3.fromRGB(241,245,249); KV.StatsText.TextSize = 11; KV.StatsText.TextXAlignment = Enum.TextXAlignment.Left; KV.StatsText.TextYAlignment = Enum.TextYAlignment.Top

KV.dashConn = RunService.RenderStepped:Connect(function()
    local dashCanvas = pageCanvases["Dashboard"]
    if dashCanvas and dashCanvas.Visible then
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local str = leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0
        local reb = leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0
        local agi = leaderstats and leaderstats:FindFirstChild("Agility") and leaderstats.Agility.Value or 0
        local dur = leaderstats and leaderstats:FindFirstChild("Durability") and leaderstats.Durability.Value or 0

        KV.StatsText.Text = string.format("ACCOUNT STATS:\n  тАв Name: %s (UserId: %d)\n  тАв Strength: %s | Rebirths: %s\n  тАв Agility: %s | Durability: %s", LocalPlayer.Name, LocalPlayer.UserId, tostring(str), tostring(reb), tostring(agi), tostring(dur))
    end
end)
table.insert(KV.ScriptConnections, KV.dashConn)

KV.sectionLabel(KV.dashboardPage, "QUICK CHARACTER SIZE PRESETS")
KV.setCharacterScale = function(val)
    KV.Config.PlayerScale = val
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        pcall(function()
            if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = val end
            if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = val end
            if hum:FindFirstChild("BodyDepthScale") then hum.BodyDepthScale.Value = val end
            if hum:FindFirstChild("HeadScale") then hum.HeadScale.Value = val end
        end)
    end
    KV.notify("Vortex Size", "Character scale set: " .. tostring(val) .. "x", 2)
end

KV.createButton(KV.dashboardPage, "Micro Size (0.1x)", "╨Ф╨╡╨╗╨░╨╡╤В ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨░ ╨╜╨╡╨╖╨░╨╝╨╡╤В╨╜╤Л╨╝ ╨╝╨╕╨╜╨╕-╨║╨░╤А╨╗╨╕╨║╨╛╨╝", function() KV.setCharacterScale(0.1) end)
KV.createButton(KV.dashboardPage, "Normal Size (1x)", "╨б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╤З╨╡╨╗╨╛╨▓╨╡╤З╨╡╤Б╨║╨╕╨╣ ╤А╨░╨╖╨╝╨╡╤А", function() KV.setCharacterScale(1) end)
KV.createButton(KV.dashboardPage, "Big Muscle (5x)", "╨С╨╛╨╗╤М╤И╨╛╨╣ ╨╜╨░╨║╨░╤З╨░╨╜╨╜╤Л╨╣ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢", function() KV.setCharacterScale(5) end)
KV.createButton(KV.dashboardPage, "Giant Monster (15x)", "╨Ю╨│╤А╨╛╨╝╨╜╤Л╨╣ ╤В╨╕╤В╨░╨╜ ╨╜╨░ ╨▓╤Б╤О ╨║╨░╤А╤В╤Г", function() KV.setCharacterScale(15) end)
KV.createButton(KV.dashboardPage, "Colossal God (30x)", "╨Ъ╨╛╨╗╨╛╤Б╤Б╨░╨╗╤М╨╜╤Л╨╣ ╨│╨╕╨│╨░╨╜╤В", function() KV.setCharacterScale(30) end)

KV.createSlider(KV.dashboardPage, "Custom Size Multiplier", 1, 30, 1, function(v) KV.setCharacterScale(v) end, nil, "╨в╨╛╤З╨╜╨░╤П ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨░ ╨╝╨░╤Б╤И╤В╨░╨▒╨░ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨░ (1x - 30x)")

-- ============================================================
-- 3. ╨а╨Р╨Ч╨Ф╨Х╨Ы: AUTO FARM / TRAINING
-- ============================================================

-- NUMBER & TIME FORMATTING UTILS FOR FAST REP
local function formatNum(n)
    if not n or n ~= n or n == math.huge or n == -math.huge then return "0" end
    if n < 0 then return "-" .. formatNum(-n) end
    if n < 1000 then return string.format("%.2f", n):gsub("%.00$", "") end
    local suffixes = {"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc"}
    local i = 1
    while n >= 1000 and i < #suffixes do
        n = n / 1000
        i = i + 1
    end
    return string.format("%.2f%s", n, suffixes[i])
end

local function formatTime(sec)
    sec = math.floor(sec or 0)
    local d = math.floor(sec / 86400)
    local h = math.floor((sec % 86400) / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%dd %dh %dm %ds", d, h, m, s)
end

KV.getStatValue = function(statName)
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        local v = ls:FindFirstChild(statName)
        if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    end
    local direct = LocalPlayer:FindFirstChild(statName)
    if direct and direct:IsA("ValueBase") then return tonumber(direct.Value) or 0 end
    return 0
end

-- ============================================================
-- FAST REP FARM SYSTEM (EXACT MATCH FOR SCREENSHOT 3)
-- ============================================================
KV.sectionLabel(KV.trainingPage, "FAST REP FARM SYSTEM")

local farmStatsCard = KV.createPanel(KV.trainingPage, 195)
farmStatsCard.BackgroundColor3 = Color3.fromRGB(12, 14, 20)

local statusLbl = Instance.new("TextLabel", farmStatsCard)
statusLbl.BackgroundTransparency = 1
statusLbl.Position = UDim2.new(0, 12, 0, 8)
statusLbl.Size = UDim2.new(1, -24, 0, 18)
statusLbl.Font = Enum.Font.GothamBold
statusLbl.TextColor3 = Color3.fromRGB(34, 197, 94)
statusLbl.TextSize = 13
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Text = "Status: Idle | 0 reps/s"

local farmDetailsLbl = Instance.new("TextLabel", farmStatsCard)
farmDetailsLbl.BackgroundTransparency = 1
farmDetailsLbl.Position = UDim2.new(0, 12, 0, 28)
farmDetailsLbl.Size = UDim2.new(1, -24, 1, -36)
farmDetailsLbl.Font = Enum.Font.GothamMedium
farmDetailsLbl.TextColor3 = Color3.fromRGB(240, 245, 255)
farmDetailsLbl.TextSize = 11
farmDetailsLbl.TextXAlignment = Enum.TextXAlignment.Left
farmDetailsLbl.TextYAlignment = Enum.TextYAlignment.Top
farmDetailsLbl.Text = "Runtime: 0d 0h 00m 00s`nStrength: 0 | Gained: 0`nDurability: 0 | Gained: 0`nStr Pace: 0/s | 0/min | 0/h | 0/d`nDura Pace: 0/s | 0/min | 0/h | 0/d`nStr Г: 0/s | 0/min | 0/h | 0/d`nDura Г: 0/s | 0/min | 0/h | 0/d"

local farmStartTime = 0
local initialStr = 0
local initialDura = 0
local actualRepsCounter = 0
local repsPerSecLive = 0
local lastRepsReset = tick()

RunService.RenderStepped:Connect(function()
    if KV.unloaded then return end
    if currentTab == "Training" or KV.Config.FastRepEnabled then
        local curStr = KV.getStatValue("Strength")
        local curDura = KV.getStatValue("Agility") > 0 and KV.getStatValue("Agility") or KV.getStatValue("Durability")
        
        if KV.Config.FastRepEnabled then
            if farmStartTime == 0 then
                farmStartTime = tick()
                initialStr = curStr
                initialDura = curDura
            end
            
            local elapsed = math.max(1, tick() - farmStartTime)
            local gainedStr = math.max(0, curStr - initialStr)
            local gainedDura = math.max(0, curDura - initialDura)
            
            if (tick() - lastRepsReset) >= 1.0 then
                repsPerSecLive = actualRepsCounter
                actualRepsCounter = 0
                lastRepsReset = tick()
            end
            
            local currentRateStr = gainedStr / elapsed
            local currentRateDura = gainedDura / elapsed
            
            statusLbl.Text = string.format("Status: Farming | %d reps/s", repsPerSecLive > 0 and repsPerSecLive or (KV.Config.MaxRepsPerSec or 659))
            statusLbl.TextColor3 = Color3.fromRGB(34, 197, 94)
            
            farmDetailsLbl.Text = string.format(
                "Runtime: %s`nStrength: %s | Gained: %s`nDurability: %s | Gained: %s`nStr Pace: %s/s | %s/min | %s/h | %s/d`nDura Pace: %s/s | %s/min | %s/h | %s/d`nStr Г: %s/s | %s/min | %s/h | %s/d`nDura Г: %s/s | %s/min | %s/h | %s/d",
                formatTime(elapsed),
                formatNum(curStr), formatNum(gainedStr),
                formatNum(curDura), formatNum(gainedDura),
                formatNum(currentRateStr), formatNum(currentRateStr * 60), formatNum(currentRateStr * 3600), formatNum(currentRateStr * 86400),
                formatNum(currentRateDura), formatNum(currentRateDura * 60), formatNum(currentRateDura * 3600), formatNum(currentRateDura * 86400),
                formatNum(currentRateStr), formatNum(currentRateStr * 60), formatNum(currentRateStr * 3600), formatNum(currentRateStr * 86400),
                formatNum(currentRateDura), formatNum(currentRateDura * 60), formatNum(currentRateDura * 3600), formatNum(currentRateDura * 86400)
            )
        else
            farmStartTime = 0
            statusLbl.Text = "Status: Idle | 0 reps/s"
            statusLbl.TextColor3 = Color3.fromRGB(150, 160, 180)
            
            farmDetailsLbl.Text = string.format(
                "Runtime: 0d 0h 00m 00s`nStrength: %s | Gained: 0`nDurability: %s | Gained: 0`nStr Pace: 0/s | 0/min | 0/h | 0/d`nDura Pace: 0/s | 0/min | 0/h | 0/d`nStr Г: 0/s | 0/min | 0/h | 0/d`nDura Г: 0/s | 0/min | 0/h | 0/d",
                formatNum(curStr), formatNum(curDura)
            )
        end
    end
end)

KV.createSlider(KV.trainingPage, "Max reps/s: " .. tostring(KV.Config.MaxRepsPerSec or 659), 10, 1000, KV.Config.MaxRepsPerSec or 659, function(v)
    KV.Config.MaxRepsPerSec = v
end)

KV.createToggle(KV.trainingPage, "Fast Rep", "Enable high speed auto rep farming", KV.Config.FastRepEnabled or false, function(v)
    KV.Config.FastRepEnabled = v
    if v then
        task.spawn(function()
            while KV.Config.FastRepEnabled and not KV.unloaded do
                local ev = KV.getMuscleEvent()
                if ev then
                    local targetReps = KV.Config.MaxRepsPerSec or 659
                    local batchSize = math.clamp(math.floor(targetReps / 20), 5, 50)
                    for i = 1, batchSize do
                        pcall(function() ev:FireServer("rep") end)
                        actualRepsCounter = actualRepsCounter + 1
                    end
                end
                task.wait(0.02)
            end
        end)
    end
end)

local noteLabel1 = Instance.new("TextLabel", KV.trainingPage)
noteLabel1.Size = UDim2.new(1, 0, 0, 18)
noteLabel1.BackgroundTransparency = 1
noteLabel1.Font = Enum.Font.GothamMedium
noteLabel1.Text = "Recommended Speed: 659, more = lag"
noteLabel1.TextColor3 = Color3.fromRGB(160, 170, 190)
noteLabel1.TextSize = 10
noteLabel1.TextXAlignment = Enum.TextXAlignment.Left

local noteLabel2 = Instance.new("TextLabel", KV.trainingPage)
noteLabel2.Size = UDim2.new(1, 0, 0, 18)
noteLabel2.BackgroundTransparency = 1
noteLabel2.Font = Enum.Font.GothamMedium
noteLabel2.Text = "Reaching Average Speed takes some time!"
noteLabel2.TextColor3 = Color3.fromRGB(160, 170, 190)
noteLabel2.TextSize = 10
noteLabel2.TextXAlignment = Enum.TextXAlignment.Left

local noteLabel3 = Instance.new("TextLabel", KV.trainingPage)
noteLabel3.Size = UDim2.new(1, 0, 0, 24)
noteLabel3.BackgroundTransparency = 1
noteLabel3.Font = Enum.Font.GothamMedium
noteLabel3.Text = "Farming also wont stop if you stop it since its too fast for the Server."
noteLabel3.TextColor3 = Color3.fromRGB(160, 170, 190)
noteLabel3.TextSize = 10
noteLabel3.TextXAlignment = Enum.TextXAlignment.Left

KV.sectionLabel(KV.trainingPage, "AUTO OP тАФ UNIVERSAL TURBO FAST FARM")

KV.createToggle(KV.trainingPage, "Auto OP (╨г╨╜╨╕╨▓╨╡╤А╤Б╨░╨╗╤М╨╜╤Л╨╣ ╤Б╤Г╨╝╨░╤Б╤И╨╡╨┤╤И╨╕╨╣ ╨║╨╗╨╕╨║╨╡╤А)", "╨б╨╡╨╗╨╕ ╨╖╨░ ╨Ы╨о╨С╨Ю╨Щ ╤В╤А╨╡╨╜╨░╨╢╨╡╤А ╨╕╨╗╨╕ ╨▓╨╖╤П╨╗╨╕ ╨Ы╨о╨С╨Ю╨Щ ╤Б╨╜╨░╤А╤П╨┤ тАФ ╨╝╨│╨╜╨╛╨▓╨╡╨╜╨╜╨╛ ╨║╨░╤З╨░╨╡╤В ╨╜╨░ ╨┐╤А╨╡╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤В╤Г╤А╨▒╨╛-╤Б╨║╨╛╤А╨╛╤Б╤В╨╕!", KV.Config.AutoOpFarm, function(v)
    KV.Config.AutoOpFarm = v
    if v then
        KV.notify("Vortex Auto OP", "Auto OP enabled! Just sit on any machine or grab any equipment!", 4)
        task.spawn(function()
            while KV.Config.AutoOpFarm do
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local ev = KV.getMuscleEvent()

                    local isSitting = hum.Sit or (hum.SeatPart ~= nil)
                    local equippedTool = char:FindFirstChildOfClass("Tool")

                    if isSitting or equippedTool then
                        if equippedTool then
                            pcall(function() equippedTool:Activate() end)
                            if string.lower(equippedTool.Name) == "punch" and ev then
                                ev:FireServer("punch", "leftHand")
                                ev:FireServer("punch", "rightHand")
                            end
                        end

                        if isSitting and hum.SeatPart then
                            local seat = hum.SeatPart
                            local mModel = seat:FindFirstAncestorOfClass("Model")
                            if mModel and ev then
                                pcall(function() ev:FireServer("interact", mModel) end)
                            end
                        end

                        if ev then
                            local count = KV.Config.UltraFastRep and (KV.Config.FastRepMultiplier * 10) or (KV.Config.FastRepMultiplier * 3)
                            for i = 1, count do
                                ev:FireServer("rep")
                            end
                        end
                    end
                end
                task.wait(KV.Config.TrainDelay > 0 and KV.Config.TrainDelay or 0.01)
            end
        end)
    end
end)

KV.sectionLabel(KV.trainingPage, "AUTOMATED EXERCISE MACHINES")
KV.createToggle(KV.trainingPage, "Auto Dumbbell Farm", "╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨б╨╕╨╗╤Л ╤З╨╡╤А╨╡╨╖ ╨У╨░╨╜╤В╨╡╨╗╨╕", KV.Config.AutoDumbbell, function(v)
    KV.Config.AutoDumbbell = v
    if v then
        task.spawn(function()
            while KV.Config.AutoDumbbell do
                KV.trainTool("Dumbbell")
                task.wait(KV.Config.TrainDelay)
            end
        end)
    end
end)

KV.createToggle(KV.trainingPage, "Auto Pushups Farm", "╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨б╨╕╨╗╤Л ╤З╨╡╤А╨╡╨╖ ╨Ю╤В╨╢╨╕╨╝╨░╨╜╨╕╤П", KV.Config.AutoPushups, function(v)
    KV.Config.AutoPushups = v
    if v then
        task.spawn(function()
            while KV.Config.AutoPushups do
                KV.trainTool("Pushups")
                task.wait(KV.Config.TrainDelay)
            end
        end)
    end
end)

KV.createToggle(KV.trainingPage, "Auto Situps Farm", "╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨б╨╕╨╗╤Л ╤З╨╡╤А╨╡╨╖ ╨Я╤А╨╡╤Б╤Б", KV.Config.AutoSitups, function(v)
    KV.Config.AutoSitups = v
    if v then
        task.spawn(function()
            while KV.Config.AutoSitups do
                KV.trainTool("Situps")
                task.wait(KV.Config.TrainDelay)
            end
        end)
    end
end)

KV.createToggle(KV.trainingPage, "Auto Weight Bar Farm", "╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨б╨╕╨╗╤Л ╤З╨╡╤А╨╡╨╖ ╨и╤В╨░╨╜╨│╤Г", KV.Config.AutoWeight, function(v)
    KV.Config.AutoWeight = v
    if v then
        task.spawn(function()
            while KV.Config.AutoWeight do
                KV.trainTool("Weight")
                task.wait(KV.Config.TrainDelay)
            end
        end)
    end
end)

KV.createToggle(KV.trainingPage, "Auto Punching Bag Farm", "╨Р╨▓╤В╨╛-╤Г╨┤╨░╤А╤Л ╨┐╨╛ ╨│╤А╤Г╤И╨╡/╨▓╨╛╨╖╨┤╤Г╤Е╤Г ╨┤╨╗╤П ╨┐╤А╨╛╨║╨░╤З╨║╨╕", KV.Config.AutoPunch, function(v)
    KV.Config.AutoPunch = v
    if v then
        task.spawn(function()
            while KV.Config.AutoPunch do
                KV.trainTool("Punch")
                task.wait(KV.Config.TrainDelay)
            end
        end)
    end
end)

KV.createToggle(KV.trainingPage, "Multi-Tool Super Farm (All-in-One)", "╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╤З╨╡╤А╨╡╨┤╤Г╨╡╤В ╨▓╤Б╨╡ ╤Б╨╜╨░╤А╤П╨┤╤Л ╨┤╨╗╤П ╨╝╨░╨║╤Б╨╕╨╝╨░╨╗╤М╨╜╨╛╨╣ ╨┐╤А╨╛╨║╨░╤З╨║╨╕", KV.Config.AutoMultiTool, function(v)
    KV.Config.AutoMultiTool = v
    if v then
        task.spawn(function()
            local tools = {"Dumbbell", "Pushups", "Situps", "Weight"}
            local idx = 1
            while KV.Config.AutoMultiTool do
                KV.trainTool(tools[idx])
                idx = (idx % #tools) + 1
                task.wait(KV.Config.TrainDelay)
            end
        end)
    end
end)

KV.createToggle(KV.trainingPage, "Walk While Training (╨е╨╛╨┤╨╕╤В╤М ╨▓╨╛ ╨▓╤А╨╡╨╝╤П ╤Г╨┐╤А╨░╨╢╨╜╨╡╨╜╨╕╤П)", "╨Я╨╛╨╖╨▓╨╛╨╗╤П╨╡╤В ╤Б╨▓╨╛╨▒╨╛╨┤╨╜╨╛ ╤Е╨╛╨┤╨╕╤В╤М ╤Б╨╛ ╤И╤В╨░╨╜╨│╨╛╨╣, ╨│╨░╨╜╤В╨╡╨╗╤П╨╝╨╕ ╨╕╨╗╨╕ ╨▓╨╛ ╨▓╤А╨╡╨╝╤П ╨▓╤Л╨┐╨╛╨╗╨╜╨╡╨╜╨╕╤П ╤Г╨┐╤А╨░╨╢╨╜╨╡╨╜╨╕╨╣!", KV.Config.WalkWhileTraining, function(v)
    KV.Config.WalkWhileTraining = v
    if v then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
        end
        KV.notify("Vortex Walk", "Walk while training enabled!", 2)
        -- ╨Я╨╛╤Б╤В╨╛╤П╨╜╨╜╤Л╨╣ ╤Ж╨╕╨║╨╗: ╨╜╨╡ ╨┤╨░╨╡╤В ╨╕╨│╤А╨╡ ╤Г╤Б╨░╨┤╨╕╤В╤М ╨▓╨░╤Б, ╨┐╨╛╨║╨░ ╨▓╤Л ╨┤╨╡╤А╨╢╨╕╤В╨╡ ╤Б╨╜╨░╤А╤П╨┤.
        -- ╨в╤А╨╡╨╜╨░╨╢╨╡╤А╤Л-╤Б╨╕╨┤╨╡╨╜╤М╤П (╨╢╨╕╨╝, ╨┐╤А╨╕╤Б╨╡╨┤ ╨╕ ╤В.╨┤.) ╨╜╨╡ ╨╖╨░╤В╤А╨░╨│╨╕╨▓╨░╤О╤В╤Б╤П тАФ ╤Б╨╜╨░╤А╤П╨┤ ╨▓ ╤А╤Г╨║╨░╤Е ╨╜╨╡ ╤Н╨║╨╕╨┐╨╕╤А╨╛╨▓╨░╨╜.
        task.spawn(function()
            while KV.Config.WalkWhileTraining do
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Sit and char:FindFirstChildOfClass("Tool") then
                    hum.Sit = false
                end
                task.wait(0.2)
            end
        end)
    end
end)

KV.sectionLabel(KV.trainingPage, "GYM MACHINES AUTO-FARM (╨С╨Ы╨Ш╨Ц╨Р╨Щ╨и╨Ш╨Щ ╨в╨а╨Х╨Э╨Р╨Ц╨Х╨а)")

-- ╨Ю╨▒╤Й╨╕╨╣ ╨┤╨▓╨╕╨╢╨╛╨║ ╤Д╨░╤А╨╝╨░ ╨╜╨░ ╤В╤А╨╡╨╜╨░╨╢╨╡╤А╨╡:
--  * ╤Б╨╡╤А╨▓╨╡╤А╨╜╨╛╨╡ ╨┐╨╛╨┤╨║╨╗╤О╤З╨╡╨╜╨╕╨╡: machineInteractRemote:InvokeServer("useMachine", seat)
--  * rep ╤И╨╗╤С╤В╤Б╤П ╤Б ╨░╤А╨│╤Г╨╝╨╡╨╜╤В╨╛╨╝-╤Б╨╕╨┤╨╡╨╜╤М╨╡╨╝: muscleEvent:FireServer("rep", seat)
--  * ╤З╤С╤А╨╜╤Л╨╣ ╤Б╨┐╨╕╤Б╨╛╨║ ╨╛╤В╨║╨░╨╖╨░╨▓╤И╨╕╤Е ╨╝╨░╤И╨╕╨╜ (60 ╤Б╨╡╨║), ╨░╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕╨╣ re-engage ╨┐╤А╨╕ ╤А╨░╨╖╤А╤Л╨▓╨╡
--  * ╨┤╨╗╤П ╨▒╨╡╨│╨╛╨▓╤Л╤Е ╨┤╨╛╤А╨╛╨╢╨╡╨║ (isTreadmill=true): ╨┐╤А╨╛╤Б╤В╨╛ ╤Б╤В╨╛╨╕╤В ╨╜╨░ treadmillPart
KV.startMachineFarm = function(configKey, keywords, isTreadmill)
    task.spawn(function()
        local mModel, mSeat, lastFind = nil, nil, 0
        local blacklist = {}
        while KV.Config[configKey] do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local now = tick()
                local inUse = KV.getMachineInUse()

                local needFind = false
                if not mModel or not mModel.Parent then
                    needFind = true
                elseif (not isTreadmill) and mSeat ~= nil and inUse ~= mSeat then
                    needFind = true -- ╤Б╨▓╤П╨╖╤М ╤Б ╤В╤А╨╡╨╜╨░╨╢╤С╤А╨╛╨╝ ╨┐╨╛╤В╨╡╤А╤П╨╜╨░ тАФ ╨┐╨╡╤А╨╡╨┐╨╛╨┤╨║╨╗╤О╤З╨░╨╡╨╝╤Б╤П
                elseif (now - lastFind) > 1.5 then
                    local okPos, mPos = pcall(function() return mModel:GetPivot().Position end)
                    if okPos and (mPos - hrp.Position).Magnitude > 40 then
                        needFind = true -- ╤Г╨╜╨╡╤Б╨╗╨╛ ╨┤╨░╨╗╤М╤И╨╡ 40 ╤Б╤В╨░╨┤╨╛╨▓ тАФ ╨▓╨╛╨╖╨▓╤А╨░╤Й╨░╨╡╨╝╤Б╤П
                    else
                        lastFind = now
                    end
                end

                if needFind and (now - lastFind) > 0.5 then
                    local part, model = KV.findNearestMachine(keywords, blacklist)
                    mModel = model or part
                    mSeat = nil
                    if mModel then
                        if isTreadmill then
                            mSeat = part
                        else
                            mSeat = KV.getMachineSeat(mModel)
                            if not mSeat and part and part:IsA("Seat") then mSeat = part end
                            if mSeat then
                                local okEngage = KV.engageMachine(mModel, mSeat)
                                if not okEngage then
                                    blacklist[mModel] = now + 60
                                    mModel, mSeat = nil, nil
                                end
                            end
                        end
                    end
                    lastFind = now
                end

                -- ╨Я╨╛╨╖╨╕╤Ж╨╕╨╛╨╜╨╕╤А╨╛╨▓╨░╨╜╨╕╨╡ ╨╜╨░ ╨▒╨╡╨│╨╛╨▓╨╛╨╣ ╨┤╨╛╤А╨╛╨╢╨║╨╡ (╤Б╨╡╤А╨▓╨╡╤А ╨┤╨░╤С╤В ╨╗╨╛╨▓╨║╨╛╤Б╤В╤М ╨╖╨░ ╤Б╨░╨╝ ╤Д╨░╨║╤В ╤Б╤В╨╛╤П╨╜╨╕╤П)
                if isTreadmill and mModel and mSeat and mSeat.Parent then
                    pcall(function()
                        hrp.CFrame = mSeat.CFrame * CFrame.new(0, mSeat.Size.Y / 2 + 3, 0)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end)
                end

                local ev = KV.getMuscleEvent()
                if ev and mModel and mModel.Parent then
                    local count = KV.Config.UltraFastRep and (KV.Config.FastRepMultiplier * 5) or KV.Config.FastRepMultiplier
                    for _ = 1, count do
                        if (not isTreadmill) and mSeat then
                            ev:FireServer("rep", mSeat)
                        else
                            ev:FireServer("rep")
                        end
                    end
                end
            end
            task.wait(KV.Config.TrainDelay > 0 and KV.Config.TrainDelay or 0.05)
        end
        pcall(KV.leaveMachine)
    end)
end

KV.createToggle(KV.trainingPage, "Auto Bench Press (╨Ц╨╕╨╝ ╨╗╨╡╨╢╨░)", "╨б╨░╨┤╨╕╤В╤Б╤П ╨╜╨░ ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╕╨╣ ╨╢╨╕╨╝ ╨╗╨╡╨╢╨░ 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨│╤А╤Г╨┤╤М!", KV.Config.AutoBenchPress, function(v)
    KV.Config.AutoBenchPress = v
    if v then
        KV.startMachineFarm("AutoBenchPress", {"bench", "benchpress", "bench press"})
    end
end)

KV.createToggle(KV.trainingPage, "Auto Squat Rack (╨Я╤А╨╕╤Б╨╡╨┤╨░╨╜╨╕╤П)", "╨б╨░╨┤╨╕╤В╤Б╤П ╨╜╨░ ╨▒╨╗╨╕╨╢╨░╨╣╤И╤Г╤О ╤Б╤В╨╛╨╣╨║╤Г ╨┐╤А╨╕╤Б╨╡╨┤╨░╨╜╨╕╨╣ 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨╜╨╛╨│╨╕!", KV.Config.AutoSquat, function(v)
    KV.Config.AutoSquat = v
    if v then
        KV.startMachineFarm("AutoSquat", {"squat", "squatrack", "squat rack"})
    end
end)

KV.createToggle(KV.trainingPage, "Auto Treadmill (╨С╨╡╨│╨╛╨▓╨░╤П ╨┤╨╛╤А╨╛╨╢╨║╨░)", "╨Т╤Б╤В╨░╨╡╤В ╨╜╨░ ╨▒╨╗╨╕╨╢╨░╨╣╤И╤Г╤О ╨▒╨╡╨│╨╛╨▓╤Г╤О ╨┤╨╛╤А╨╛╨╢╨║╤Г ╨╕ ╨║╨░╤З╨░╨╡╤В ╨╗╨╛╨▓╨║╨╛╤Б╤В╤М!", KV.Config.AutoTreadmillMachine, function(v)
    KV.Config.AutoTreadmillMachine = v
    if v then
        KV.startMachineFarm("AutoTreadmillMachine", {"treadmill", "tread"}, true)
    end
end)

KV.createToggle(KV.trainingPage, "Auto Pull-ups (╨Я╨╛╨┤╤В╤П╨│╨╕╨▓╨░╨╜╨╕╤П)", "╨Т╤Б╤В╨░╨╡╤В ╨║ ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╡╨╝╤Г ╤В╤Г╤А╨╜╨╕╨║╤Г 1 ╤А╨░╨╖ ╨╕ ╨┐╨╛╨┤╤В╤П╨│╨╕╨▓╨░╨╡╤В╤Б╤П!", KV.Config.AutoPullups, function(v)
    KV.Config.AutoPullups = v
    if v then
        KV.startMachineFarm("AutoPullups", {"pullup", "pull-up", "pull up", "bar"})
    end
end)

KV.createToggle(KV.trainingPage, "Auto Boulder Throw (╨С╤А╨╛╤Б╨╛╨║ ╨▓╨░╨╗╤Г╨╜╨░)", "╨Я╨╛╨┤╤Е╨╛╨┤╨╕╤В ╨║ ╨▓╨░╨╗╤Г╨╜╤Г 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨▒╤А╨╛╤Б╨║╨╕!", KV.Config.AutoBoulder, function(v)
    KV.Config.AutoBoulder = v
    if v then
        KV.startMachineFarm("AutoBoulder", {"boulder", "boulderthrow", "boulder throw"})
    end
end)

KV.createToggle(KV.trainingPage, "Auto Rock Farm (╨Ъ╨░╨╝╨╡╨╜╤М)", "╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨║ ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╡╨╝╤Г ╨║╨░╨╝╨╜╤О 1 ╤А╨░╨╖ ╨╕ ╨╜╨╡╨┐╤А╨╡╤А╤Л╨▓╨╜╨╛ ╨▒╤М╨╡╤В!", KV.Config.AutoRockMachine, function(v)
    KV.Config.AutoRockMachine = v
    if v then
        task.spawn(function()
            local rockPart, lastScan, lastTP = nil, 0, 0
            while KV.Config.AutoRockMachine do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if (tick() - lastScan) > 2 then
                        rockPart = KV.getTargetRockPart("Any")
                        lastScan = tick()
                    end
                    if rockPart and rockPart.Parent and (tick() - lastTP) > 2
                        and (rockPart.Position - hrp.Position).Magnitude > 8 then
                        hrp.CFrame = CFrame.lookAt(rockPart.Position + Vector3.new(0, 2, 4), rockPart.Position)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        lastTP = tick()
                    end
                end
                KV.trainTool("Punch")
                task.wait(KV.Config.TrainDelay > 0 and KV.Config.TrainDelay or 0.05)
            end
        end)
    end
end)

KV.createToggle(KV.trainingPage, "ULTRA FAST INSTANT REP MODE (TURBO 100X)", "╨г╨╗╤М╤В╤А╨░-╤Б╨║╨╛╤А╨╛╤Б╤В╨╜╨╛╨╣ ╤А╨╡╨╢╨╕╨╝: ╨╝╨│╨╜╨╛╨▓╨╡╨╜╨╜╤Л╨╣ ╤Б╨┐╨░╨╝ ╨╕╨▓╨╡╨╜╤В╨╛╨▓ ╨║╨░╤З╨░╨╜╨╕╤П ╨▒╨╡╨╖ ╨╖╨░╨┤╨╡╤А╨╢╨║╨╕!", KV.Config.UltraFastRep, function(v)
    KV.Config.UltraFastRep = v
    if v then
        KV.notify("Vortex Turbo Farm", "Ultra-fast farm enabled! (100x Rep Spam)", 3)
    end
end)

KV.createSlider(KV.trainingPage, "Fast Rep Multiplier (1x-100x)", 1, 100, 10, function(v)
    KV.Config.FastRepMultiplier = v
end, nil, "╨г╤Б╨║╨╛╤А╨╕╤В╨╡╨╗╤М ╤Д╨░╤А╨╝╨░: ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛ ╨╛╤В╨┐╤А╨░╨▓╨╗╤П╨╡╨╝╤Л╤Е ╨┐╨░╨║╨╡╤В╨╛╨▓ ╨║╨░╤З╨░╨╜╨╕╤П ╨╖╨░ ╨╛╨┤╨╕╨╜ ╤А╨░╨╖ (╨┤╨╛ 100x)")

KV.createSlider(KV.trainingPage, "Train Delay Speed (sec)", 0, 0.05, KV.Config.TrainDelay, function(v)
    KV.Config.TrainDelay = v
end, nil, "╨Ч╨░╨┤╨╡╤А╨╢╨║╨░ ╨╝╨╡╨╢╨┤╤Г ╨┐╨╛╨▓╤В╨╛╤А╨░╨╝╨╕ (0 = ╨╝╨│╨╜╨╛╨▓╨╡╨╜╨╜╨╛)")

-- ============================================================
-- 4. ╨а╨Р╨Ч╨Ф╨Х╨Ы: ROCKS & GYM MACHINES (╨Ш╨б╨Я╨а╨Р╨Т╨Ы╨Х╨Э ╨д╨Р╨а╨Ь ╨Ъ╨Р╨Ь╨Э╨Х╨Щ)
-- ============================================================
KV.sectionLabel(KV.rocksPage, "AUTO ROCK FARM ENGINE (FIXED)")
KV.RockInfoLabel = Instance.new("TextLabel", KV.createGlassPanel(KV.rocksPage, 34))
KV.RockInfoLabel.BackgroundTransparency = 1; KV.RockInfoLabel.Position = UDim2.new(0, 12, 0, 0); KV.RockInfoLabel.Size = UDim2.new(1, -24, 1, 0)
KV.RockInfoLabel.Font = Enum.Font.GothamBold; KV.RockInfoLabel.TextColor3 = KV.AccentColor; KV.RockInfoLabel.TextSize = 11; KV.RockInfoLabel.TextXAlignment = Enum.TextXAlignment.Left; CollectionService:AddTag(KV.RockInfoLabel, "AccentText")
KV.RockInfoLabel.Text = "Selected Rock Tier: Any"

KV.createToggle(KV.rocksPage, "Auto Farm Selected Rock", "╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨║ ╨║╨░╨╝╨╜╤О 1 ╤А╨░╨╖ ╨╕ ╨╜╨╡╨┐╤А╨╡╤А╤Л╨▓╨╜╨╛ ╨▒╤М╨╡╤В!", KV.Config.AutoRock, function(v)
    KV.Config.AutoRock = v
    if v then
        task.spawn(function()
            local rockPart, lastScan, lastTP = nil, 0, 0
            while KV.Config.AutoRock do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if (tick() - lastScan) > 2 then
                        rockPart = KV.getTargetRockPart(KV.Config.SelectedRockTier)
                        lastScan = tick()
                    end
                    if rockPart and rockPart.Parent and (tick() - lastTP) > 2
                        and (rockPart.Position - hrp.Position).Magnitude > 8 then
                        hrp.CFrame = CFrame.lookAt(rockPart.Position + Vector3.new(0, 2, 4), rockPart.Position)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        lastTP = tick()
                    end
                end

                if char and char:FindFirstChildOfClass("Humanoid") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
                    if punch and punch.Parent == LocalPlayer.Backpack then
                        hum:EquipTool(punch)
                    end
                    if punch then pcall(function() punch:Activate() end) end

                    local ev = KV.getMuscleEvent()
                    if ev then
                        ev:FireServer("punch", "leftHand")
                        ev:FireServer("punch", "rightHand")
                        for i = 1, KV.Config.FastRepMultiplier do
                            ev:FireServer("rep")
                        end
                    end
                end
                task.wait(KV.Config.TrainDelay > 0 and KV.Config.TrainDelay or 0.05)
            end
        end)
    end
end)

KV.createToggle(KV.rocksPage, "Auto Treadmill Farm (Agility)", "╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨╜╨░ ╨▒╨╡╨│╨╛╨▓╤Г╤О ╨┤╨╛╤А╨╛╨╢╨║╤Г 1 ╤А╨░╨╖ ╨╕ ╨║╨░╤З╨░╨╡╤В ╨╗╨╛╨▓╨║╨╛╤Б╤В╤М!", KV.Config.AutoTreadmill, function(v)
    KV.Config.AutoTreadmill = v
    if v then
        task.spawn(function()
            local treadPart, lastScan, lastTP = nil, 0, 0
            while KV.Config.AutoTreadmill do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not treadPart or not treadPart.Parent or (tick() - lastScan) > 5 then
                        treadPart = KV.findNearestMachine({"treadmill", "tread"})
                        lastScan = tick()
                    end
                    if treadPart and treadPart.Parent and (tick() - lastTP) > 2
                        and (treadPart.Position - hrp.Position).Magnitude > 8 then
                        KV.safeTeleport(treadPart.CFrame * CFrame.new(0, 3, 0))
                        lastTP = tick()
                    end
                end
                local ev = KV.getMuscleEvent()
                if ev then ev:FireServer("rep") end
                task.wait(KV.Config.TrainDelay > 0 and KV.Config.TrainDelay or 0.05)
            end
        end)
    end
end)

KV.sectionLabel(KV.rocksPage, "SELECT ROCK TIER")
for _, rData in ipairs(KV.rockTiers) do
    KV.createButton(KV.rocksPage, rData[1], function()
        return KV.t("╨Т╤Л╨▒╤А╨░╤В╤М ", "Select ") .. rData[1] .. KV.t(" ╨┤╨╗╤П ╤Д╨░╤А╨╝╨╕╨╜╨│╨░", " for farming")
            .. " (" .. rData[2] .. ")"
    end, function()
        KV.Config.SelectedRockTier = rData[3]
        KV.RockInfoLabel.Text = "Selected Rock Tier: " .. rData[1] .. " (" .. rData[2] .. ")"
        KV.notify("Vortex Rock", "Selected rock tier: " .. rData[1], 2)
    end)
end

-- ============================================================
-- 5. ╨а╨Р╨Ч╨Ф╨Х╨Ы: COMBAT & KILLAURA
-- ============================================================
KV.sectionLabel(KV.combatPage, "ADVANCED KILL AURA ENGINE (BRING & BEAT)")

KV.KillAuraStatusLabel = Instance.new("TextLabel", KV.createGlassPanel(KV.combatPage, 34))
KV.KillAuraStatusLabel.BackgroundTransparency = 1; KV.KillAuraStatusLabel.Position = UDim2.new(0, 12, 0, 0); KV.KillAuraStatusLabel.Size = UDim2.new(1, -24, 1, 0)
KV.KillAuraStatusLabel.Font = Enum.Font.GothamBold; KV.KillAuraStatusLabel.TextColor3 = KV.AccentColor; KV.KillAuraStatusLabel.TextSize = 11; KV.KillAuraStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; CollectionService:AddTag(KV.KillAuraStatusLabel, "AccentText")
KV.KillAuraStatusLabel.Text = "Kill Aura Mode: Bring To Me"

KV.createButton(KV.combatPage, "Mode 1: Bring Target To Me (╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╨╛╨▓╨░╤В╤М ╨▓╤А╨░╨│╨░ ╨║ ╤Б╨╡╨▒╨╡)", "╨Я╤А╨╕╤В╤П╨│╨╕╨▓╨░╨╡╤В/╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨║╨╛╤А╨┐╤Г╤Б ╨▓╤А╨░╨│╨░ ╨┐╤А╤П╨╝╨╛ ╨┐╨╡╤А╨╡╨┤ ╨▓╨░╤И╨╕╨╝╨╕ ╨║╤Г╨╗╨░╨║╨░╨╝╨╕ ╨╕ ╨▒╤М╨╡╤В!", function()
    KV.Config.KillAuraMode = "Bring To Me"
    KV.KillAuraStatusLabel.Text = "Kill Aura Mode: Bring To Me"
    KV.notify("Vortex Killaura", "Mode: pull enemies to me and beat them!", 2)
end)

KV.createButton(KV.combatPage, "Mode 2: Magnet TP To Target (╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╨╛╨▓╨░╤В╤М╤Б╤П ╨║ ╨▓╤А╨░╨│╤Г)", "╨Ь╨│╨╜╨╛╨▓╨╡╨╜╨╜╨╛ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╨░╤Б ╨╖╨░ ╤Б╨┐╨╕╨╜╤Г / ╨▓ ╨╗╨╕╤Ж╨╛ ╨▓╤А╨░╨│╤Г ╨╕ ╨╜╨░╨╜╨╛╤Б╨╕╤В ╤Г╨┤╨░╤А╤Л", function()
    KV.Config.KillAuraMode = "Magnet TP to Target"
    KV.KillAuraStatusLabel.Text = "Kill Aura Mode: Magnet TP To Target"
    KV.notify("Vortex Killaura", "Mode: teleport to enemies and beat them!", 2)
end)

KV.createButton(KV.combatPage, "Mode 3: Orbit Target (╨Ю╤А╨▒╨╕╤В╨░ ╨▓╨╛╨║╤А╤Г╨│ ╤Ж╨╡╨╗╨╕)", "╨Т╤А╨░╤Й╨░╨╡╤В╤Б╤П ╨┐╨╛ ╨║╤А╤Г╨│╤Г ╨▓╨╛╨║╤А╤Г╨│ ╤Ж╨╡╨╗╨╕ ╨╕ ╨╜╨░╨╜╨╛╤Б╨╕╤В ╤Б╨╡╤А╨╕╨╕ ╤Г╨┤╨░╤А╨╛╨▓", function()
    KV.Config.KillAuraMode = "Orbit Target"
    KV.KillAuraStatusLabel.Text = "Kill Aura Mode: Orbit Target"
    KV.notify("Vortex Killaura", "Mode: orbit around enemies!", 2)
end)

KV.createToggle(KV.combatPage, "Enable Kill Aura (Auto Hit & Teleport)", "╨Р╨║╤В╨╕╨▓╨╕╤А╤Г╨╡╤В Kill Aura: ╨▒╤М╨╡╤В, ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╤А╨░╨│╨╛╨▓ ╨┐╤А╤П╨╝╨╛ ╨║ ╨▓╨░╨╝ ╨╕╨╗╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В╤Б╤П ╨║ ╨╜╨╕╨╝!", KV.Config.KillAura, function(v)
    KV.Config.KillAura = v
    if v then
        task.spawn(function()
            local angle = 0
            while KV.Config.KillAura do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                    local myHrp = char.HumanoidRootPart
                    local myHum = char:FindFirstChildOfClass("Humanoid")

                    if myHum.Health > 0 then
                        local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
                        if punch and punch.Parent == LocalPlayer.Backpack then
                            myHum:EquipTool(punch)
                        end
                        if punch then pcall(function() punch:Activate() end) end

                        local ev = KV.getMuscleEvent()

                        for _, otherPlayer in pairs(Players:GetPlayers()) do
                            if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                                local oChar = otherPlayer.Character
                                local oHrp = oChar:FindFirstChild("HumanoidRootPart")
                                local oHum = oChar:FindFirstChildOfClass("Humanoid")
                                local ff = oChar:FindFirstChildOfClass("ForceField")

                                if oHrp and oHum and oHum.Health > 0 and not ff then
                                    local dist = (oHrp.Position - myHrp.Position).Magnitude
                                    if dist <= KV.Config.KillAuraRange then
                                        if ev then
                                            for i = 1, KV.Config.PunchMultiplier do
                                                ev:FireServer("punch", "leftHand")
                                                ev:FireServer("punch", "rightHand")
                                            end
                                        end

                                        if KV.Config.KillAuraMode == "Bring To Me" then
                                            -- ╤Б╨╡╤А╨▓╨╡╤А ╨╜╨╡ ╨┐╨╛╨╖╨▓╨╛╨╗╤П╨╡╤В ╨┤╨▓╨╕╨│╨░╤В╤М ╤З╤Г╨╢╨╛╨│╨╛ ╨╕╨│╤А╨╛╨║╨░ тАФ
                                            -- ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╨╝╤Б╤П ╤Б╨░╨╝╨╕ ╨▓╨┐╨╗╨╛╤В╨╜╤Г╤О ╨┐╨╡╤А╨╡╨┤ ╤Ж╨╡╨╗╤М╤О ╨╕ ╨▒╤М╤С╨╝
                                            pcall(function()
                                                myHrp.CFrame = CFrame.lookAt(
                                                    oHrp.Position - oHrp.CFrame.LookVector * 2.5 + Vector3.new(0, 1, 0),
                                                    oHrp.Position)
                                                myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                            end)
                                        elseif KV.Config.KillAuraMode == "Magnet TP to Target" then
                                            KV.safeTeleport(oHrp.CFrame * CFrame.new(0, 0, 2.5))
                                        elseif KV.Config.KillAuraMode == "Orbit Target" then
                                            angle = angle + 0.3
                                            local offset = Vector3.new(math.sin(angle) * 4, 1, math.cos(angle) * 4)
                                            KV.safeTeleport(CFrame.new(oHrp.Position + offset, oHrp.Position))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(KV.Config.KillAuraDelay)
            end
        end)
    end
end)

KV.createSlider(KV.combatPage, "Kill Aura Range (Studs)", 5, 150, KV.Config.KillAuraRange, function(v) KV.Config.KillAuraRange = v end, nil, "╨а╨░╨┤╨╕╤Г╤Б ╨▓ ╤Б╤В╤Г╨┤╨░╤Е ╨┤╨╗╤П ╨╛╨▒╨╜╨░╤А╤Г╨╢╨╡╨╜╨╕╤П ╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨░╤Ж╨╕╨╕ ╨▓╤А╨░╨│╨╛╨▓")
KV.createSlider(KV.combatPage, "Punch Hit Speed (ms)", 10, 100, 30, function(v) KV.Config.KillAuraDelay = v / 1000 end, nil, "╨Ч╨░╨┤╨╡╤А╨╢╨║╨░ ╤Г╨┤╨░╤А╨╛╨▓ ╨▓ ╨╝╨╕╨╗╨╗╨╕╤Б╨╡╨║╤Г╨╜╨┤╨░╤Е")
KV.createSlider(KV.combatPage, "Punch Event Multiplier (1x-10x)", 1, 10, 2, function(v) KV.Config.PunchMultiplier = v end, nil, "╨Ъ╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛ ╨╛╤В╨┐╤А╨░╨▓╨╗╤П╨╡╨╝╤Л╤Е ╨┐╨░╨║╨╡╤В╨╛╨▓ ╤Г╨┤╨░╤А╨╛╨▓ ╨╖╨░ ╨╕╤В╨╡╤А╨░╤Ж╨╕╤О")

KV.sectionLabel(KV.combatPage, "PLAYER TARGETING & SERVER DESTRUCTION")
KV.TargetInfoLbl = Instance.new("TextLabel", KV.createGlassPanel(KV.combatPage, 34))
KV.TargetInfoLbl.BackgroundTransparency = 1; KV.TargetInfoLbl.Position = UDim2.new(0, 12, 0, 0); KV.TargetInfoLbl.Size = UDim2.new(1, -24, 1, 0)
KV.TargetInfoLbl.Font = Enum.Font.GothamBold; KV.TargetInfoLbl.TextColor3 = KV.AccentColor; KV.TargetInfoLbl.TextSize = 11; KV.TargetInfoLbl.TextXAlignment = Enum.TextXAlignment.Left; CollectionService:AddTag(KV.TargetInfoLbl, "AccentText")
KV.TargetInfoLbl.Text = "Selected Target: None Selected"

KV.createButton(KV.combatPage, "Select Nearest Player as Target", "╨Т╤Л╨▒╨╕╤А╨░╨╡╤В ╨▒╨╗╨╕╨╢╨░╨╣╤И╨╡╨│╨╛ ╨║ ╨▓╨░╨╝ ╨╕╨│╤А╨╛╨║╨░ ╨▓ ╨║╨░╤З╨╡╤Б╤В╨▓╨╡ ╤Ж╨╡╨╗╨╕", function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position
    local nearestP, minDist = nil, math.huge

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minDist then
                minDist = dist
                nearestP = p
            end
        end
    end

    if nearestP then
        KV.Config.SelectedTargetPlayer = nearestP
        KV.TargetInfoLbl.Text = "Selected Target: " .. nearestP.Name
        KV.notify("Vortex Target", "Target selected: " .. nearestP.Name, 2)
    end
end)

KV.createButton(KV.combatPage, "Bring Selected Target to Me", "╨Я╤А╨╕╤В╤П╨│╨╕╨▓╨░╨╡╤В ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨│╨╛ ╨╕╨│╤А╨╛╨║╨░ ╨┐╤А╤П╨╝╨╛ ╨║ ╨▓╨░╤И╨╕╨╝ ╨║╤Г╨╗╨░╨║╨░╨╝", function()
    if KV.Config.SelectedTargetPlayer and KV.Config.SelectedTargetPlayer.Character and KV.Config.SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            KV.Config.SelectedTargetPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end)
        KV.notify("Vortex Target", "Player pulled to you!", 2)
    end
end)

KV.createToggle(KV.combatPage, "Loop Kill Selected Target", "╨Э╨╡╨┐╤А╨╡╤А╤Л╨▓╨╜╨╛ ╨▒╤М╨╡╤В ╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨│╨╛ ╨╕╨│╤А╨╛╨║╨░", KV.Config.TargetLoopKill, function(v)
    KV.Config.TargetLoopKill = v
    if v then
        task.spawn(function()
            while KV.Config.TargetLoopKill do
                if KV.Config.SelectedTargetPlayer and KV.Config.SelectedTargetPlayer.Character and KV.Config.SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local tHrp = KV.Config.SelectedTargetPlayer.Character.HumanoidRootPart
                    local tHum = KV.Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if tHum and tHum.Health > 0 then
                        KV.safeTeleport(tHrp.CFrame * CFrame.new(0, 0, 2.5))
                        local ev = KV.getMuscleEvent()
                        if ev then
                            ev:FireServer("punch", "leftHand")
                            ev:FireServer("punch", "rightHand")
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end)

KV.createToggle(KV.combatPage, "Auto Kill Entire Server", "╨Ч╨░╤Ж╨╕╨║╨╗╨╡╨╜╨╜╤Л╨╣ ╨░╨▓╤В╨╛-╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╨┐╨╛ ╨▓╤Б╨╡╨╝ ╨╕╨│╤А╨╛╨║╨░╨╝ ╤Б╨╡╤А╨▓╨╡╤А╨░ ╨╕ ╨╕╤Е ╤Г╨╜╨╕╤З╤В╨╛╨╢╨╡╨╜╨╕╨╡", KV.Config.AutoKillServer, function(v)
    KV.Config.AutoKillServer = v
    if v then
        task.spawn(function()
            while KV.Config.AutoKillServer do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        local hrp = p.Character.HumanoidRootPart
                        local ff = p.Character:FindFirstChildOfClass("ForceField")

                        if hum.Health > 0 and not ff and KV.Config.AutoKillServer then
                            KV.safeTeleport(hrp.CFrame * CFrame.new(0, 0, 2.5))
                            local ev = KV.getMuscleEvent()
                            if ev then
                                ev:FireServer("punch", "leftHand")
                                ev:FireServer("punch", "rightHand")
                            end
                            task.wait(0.08)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

KV.createToggle(KV.combatPage, "Auto Join & Win Brawls", "╨Р╨▓╤В╨╛-╨▓╤Е╨╛╨┤ ╨╜╨░ Brawl ╤В╤Г╤А╨╜╨╕╤А╤Л ╤Б╨╡╤А╨▓╨╡╤А╨░ ╨╕ ╨╜╨╡╨╝╨╡╨┤╨╗╨╡╨╜╨╜╨░╤П ╨┐╨╛╨▒╨╡╨┤╨░", KV.Config.AutoBrawl, function(v)
    KV.Config.AutoBrawl = v
    if v then
        task.spawn(function()
            while KV.Config.AutoBrawl do
                local joinEvent = ReplicatedStorage:FindFirstChild("joinBrawl") or LocalPlayer:FindFirstChild("joinBrawl")
                if joinEvent then joinEvent:FireServer() end
                task.wait(2)
            end
        end)
    end
end)

KV.sectionLabel(KV.combatPage, "LEGEND BOSS KILLER ENGINE (GODMODE & FAST ATTACK)")

KV.BOSS_TARGET_FOLDERS = {
    "bossFolder", "BossFolder", "Bosses", "Boss", "bossIsland", "BossIsland",
    "worldboss", "WorldBoss", "eventBoss", "EventBoss",
    "enemies", "Enemies", "enemy", "Enemy", "mobs", "Mobs",
    "battleIsland", "BattleIsland", "warriors", "Warriors",
    "arena", "Arena", "raids", "Raids", "spawns", "Spawns",
}
KV.BOSS_NAME_KEYWORDS = {
    "boss", "╨▒╨╛╤Б╤Б", "evil", "king", "warrior", "brute", "titan",
    "champion", "monster", "giant", "fighter", "bandit", "enemy",
    "warlord", "overlord", "chief", "colossus", "juggernaut", "million",
    "overcharged", "zombie", "demon", "dragon", "alien", "skeleton",
    "golem", "gorilla", "shark", "phantom", "reaper", "behemoth",
}
KV.BOSS_NAME_EXCLUDES = {
    "statue", "portal", "gate", "leaderboard", "display", "decor",
    "island", "beach", "gym", "ring", "quest", "trainer", "merchant",
    "vendor", "shop", "guide", "villager", "pet", "animal", "rock",
    "bench", "squat", "tread", "pull", "boulder", "dummy",
}

-- ╨Ш╤Й╨╡╤В ╨╝╨╛╨┤╨╡╨╗╤М ╤Б ╨╢╨╕╨▓╤Л╨╝ Humanoid, ╨┐╨╛╨┤╨╜╨╕╨╝╨░╤П╤Б╤М ╨▓╨▓╨╡╤А╤Е ╨╛╤В ╨╛╨▒╤К╨╡╨║╤В╨░
KV.modelWithHumanoidFrom = function(inst)
    local cur = inst
    while cur and cur ~= Workspace and cur ~= game do
        if cur:IsA("Model") then
            local hum = cur:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then return cur end
        end
        cur = cur.Parent
    end
    return nil
end

KV.getActiveBoss = function()
    local char = LocalPlayer.Character
    local myPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
    local bestModel, bestHum, bestHrp, bestScore, bestDist = nil, nil, nil, -1, math.huge

    -- ╨Ю╨▒╤Й╨░╤П ╨┐╤А╨╕╤С╨╝╨║╨░ ╨║╨░╨╜╨┤╨╕╨┤╨░╤В╨░: score тАФ ╨┐╤А╨╕╨╛╤А╨╕╤В╨╡╤В ╨╕╤Б╤В╨╛╤З╨╜╨╕╨║╨░ (3=billboard, 2=╨┐╨░╨┐╨║╨░, 1=╨╕╨╝╤П)
    local function accept(obj, score)
        if not obj or not obj:IsA("Model") then return end
        if Players:GetPlayerFromCharacter(obj) then return end
        local hum = obj:FindFirstChildOfClass("Humanoid")
        local hrp = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
            or obj:FindFirstChild("Torso") or obj:FindFirstChildWhichIsA("BasePart")
        if not (hum and hum.Health > 0 and hrp) then return end
        local dist = myPos and (hrp.Position - myPos).Magnitude or 0
        if score > bestScore or (score == bestScore and dist < bestDist) then
            bestModel, bestHum, bestHrp, bestScore, bestDist = obj, hum, hrp, score, dist
        end
    end

    local function namePasses(n)
        for _, ex in ipairs(KV.BOSS_NAME_EXCLUDES) do
            if string.find(n, ex) then return false end
        end
        for _, kw in ipairs(KV.BOSS_NAME_KEYWORDS) do
            if string.find(n, kw) then return true end
        end
        return false
    end

    -- 1) BillboardGui ╤Б ╨╜╨░╨┤╨┐╨╕╤Б╤М╤О Boss/HP ╨╜╨░╨┤ ╨│╨╛╨╗╨╛╨▓╨╛╨╣ тАФ ╤Б╨░╨╝╤Л╨╣ ╤В╨╛╤З╨╜╤Л╨╣ ╨┐╤А╨╕╨╖╨╜╨░╨║
    for _, bb in ipairs(Workspace:GetDescendants()) do
        if bb:IsA("BillboardGui") then
            local txt = ""
            for _, tl in ipairs(bb:GetDescendants()) do
                if tl:IsA("TextLabel") and type(tl.Text) == "string" then
                    txt = txt .. " " .. tl.Text
                end
            end
            txt = string.lower(txt)
            local isBossText = string.find(txt, "boss") or string.find(txt, "╨▒╨╛╤Б╤Б")
            local isHpText = string.find(txt, "%d+%s*/%s*%d+")
            if isBossText or isHpText then
                local root = bb.Adornee or bb.Parent
                local model = KV.modelWithHumanoidFrom(root)
                if model then
                    if isBossText then
                        accept(model, 3)
                    else
                        -- HP-╨▒╨░╤А ╨▒╨╡╨╖ ╤Б╨╗╨╛╨▓╨░ Boss: ╨┐╤А╨╛╨┐╤Г╤Б╨║╨░╨╡╨╝ ╤В╨╛╨╗╤М╨║╨╛ ╨╡╤Б╨╗╨╕ ╨╕╨╝╤П ╨╜╨╡ ╨┐╨╛╤Е╨╛╨╢╨╡ ╨╜╨░ ╨┤╨╡╨║╨╛╤А/╤Б╨╜╨░╤А╤П╨┤
                        local n = string.lower(model.Name)
                        local okName = true
                        for _, ex in ipairs(KV.BOSS_NAME_EXCLUDES) do
                            if string.find(n, ex) then okName = false break end
                        end
                        if okName then accept(model, 2) end
                    end
                end
            end
        end
    end

    -- 2) ╨Ш╨│╤А╨╛╨▓╤Л╨╡ ╨┐╨░╨┐╨║╨╕ ╤Б ╨▓╤А╨░╨│╨░╨╝╨╕ / ╨▒╨╛╤Б╤Б╨░╨╝╨╕ тАФ ╨а╨Х╨Ъ╨г╨а╨б╨Ш╨Т╨Э╨л╨Щ ╨┐╨╛╨╕╤Б╨║ (╨┐╨░╨┐╨║╨░ ╨╝╨╛╨╢╨╡╤В ╨▒╤Л╤В╤М ╨▓╨╗╨╛╨╢╨╡╨╜╨╜╨╛╨╣)
    for _, fName in ipairs(KV.BOSS_TARGET_FOLDERS) do
        local folder = Workspace:FindFirstChild(fName, true)
        if folder then
            for _, obj in pairs(folder:GetDescendants()) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                    local n = string.lower(obj.Name)
                    local okName = true
                    for _, ex in ipairs(KV.BOSS_NAME_EXCLUDES) do
                        if string.find(n, ex) then okName = false break end
                    end
                    if okName then accept(obj, 2) end
                end
            end
        end
    end

    -- 3) ╨Ь╨╛╨┤╨╡╨╗╨╕ ╤Б ╨║╨╗╤О╤З╨╡╨▓╤Л╨╝╨╕ ╤Б╨╗╨╛╨▓╨░╨╝╨╕ ╨▓ ╨╕╨╝╨╡╨╜╨╕ ╨┐╨╛ ╨▓╤Б╨╡╨╝╤Г Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and namePasses(string.lower(obj.Name)) then
            accept(obj, 1)
        end
    end

    return bestModel, bestHum, bestHrp
end

KV.createToggle(KV.combatPage, "Auto Farm Boss (Godmode Safe TP & Fast Beat)", "╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨С╨╛╤Б╤Б╨░: ╨┐╨╛╨╖╨╕╤Ж╨╕╤П ╤Г ╨▒╨╛╤Б╤Б╨░ + ╨▒╨╡╨╖ ╤Г╤А╨╛╨╜╨░ ╨┐╨╛ ╨▓╨░╨╝ + ╨▒╤Л╤Б╤В╤А╨░╤П ╨░╤В╨░╨║╨░!", KV.Config.AutoKillBoss, function(v)
    KV.Config.AutoKillBoss = v
    if v then
        KV.notify("Vortex Boss", KV.tn("╨Р╨▓╤В╨╛-╤Д╨░╤А╨╝ ╨С╨╛╤Б╤Б╨░ ╨▓╨║╨╗╤О╤З╨╡╨╜! ╨Э╨░╨▓╨╡╨┤╨╡╨╜╨╕╨╡...", "Boss auto farm enabled! Targeting..."), 3)
        task.spawn(function()
            local notifiedNoBoss = false
            local lastTargetName = nil
            local cachedBoss, cachedHum, cachedHrp, lastSearch = nil, nil, nil, 0
            while KV.Config.AutoKillBoss do
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChildOfClass("Humanoid") then
                    local myHrp = myChar.HumanoidRootPart
                    local myHum = myChar:FindFirstChildOfClass("Humanoid")

                    for _, p in pairs(myChar:GetChildren()) do
                        if p:IsA("BasePart") then p.CanTouch = false end
                    end
                    myHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

                    -- ╨┐╨╡╤А╨╡╤Б╨║╨░╨╜╨╕╤А╨╛╨▓╨░╤В╤М ╨╝╨╕╤А ╨╜╨╡ ╤З╨░╤Й╨╡ ╤А╨░╨╖╨░ ╨▓ ╤Б╨╡╨║╤Г╨╜╨┤╤Г (╨║╤Н╤И ╤Ж╨╡╨╗╨╕)
                    if (tick() - lastSearch) > 1
                        or not cachedBoss or not cachedBoss.Parent
                        or not cachedHum or cachedHum.Health <= 0 then
                        cachedBoss, cachedHum, cachedHrp = KV.getActiveBoss()
                        lastSearch = tick()
                    end
                    local bossModel, bossHum, bossHrp = cachedBoss, cachedHum, cachedHrp

                    if bossModel and bossModel.Parent and bossHrp and bossHum and bossHum.Health > 0 then
                        notifiedNoBoss = false
                        if lastTargetName ~= bossModel.Name then
                            lastTargetName = bossModel.Name
                            KV.notify("Vortex Boss", KV.tn("╨ж╨╡╨╗╤М ╨╖╨░╤Е╨▓╨░╤З╨╡╨╜╨░: ", "Target acquired: ") .. bossModel.Name, 3)
                        end

                        local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or myChar:FindFirstChild("Punch")
                        if punch and punch.Parent == LocalPlayer.Backpack then
                            myHum:EquipTool(punch)
                        end
                        if punch then pcall(function() punch:Activate() end) end

                        myHrp.CFrame = CFrame.lookAt(bossHrp.Position + (bossHrp.CFrame.LookVector * -2.5) + Vector3.new(0, 1, 0), bossHrp.Position)
                        myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                        local ev = KV.getMuscleEvent()
                        if ev then
                            for i = 1, KV.Config.BossHitMultiplier do
                                ev:FireServer("punch", "leftHand")
                                ev:FireServer("punch", "rightHand")
                            end
                        end
                        pcall(function()
                            local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
                            if rEvents and rEvents:FindFirstChild("punchEvent") then
                                rEvents.punchEvent:FireServer("rightHand")
                                rEvents.punchEvent:FireServer("leftHand")
                            end
                        end)
                    else
                        lastTargetName = nil
                        if not notifiedNoBoss then
                            KV.notify("Vortex Boss", KV.tn("╨Ю╨╢╨╕╨┤╨░╨╜╨╕╨╡ ╤Б╨┐╨░╨▓╨╜╨░ ╨С╨╛╤Б╤Б╨░ ╨╜╨░ ╨║╨░╤А╤В╨╡...", "Waiting for boss spawn..."), 3)
                            notifiedNoBoss = true
                        end
                        task.wait(1.5)
                    end
                end
                task.wait(0.04)
            end
        end)
    else
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                if p:IsA("BasePart") then p.CanTouch = true end
            end
        end
    end
end)

KV.createSlider(KV.combatPage, "Boss Hit Multiplier (1x-20x)", 1, 20, 5, function(v)
    KV.Config.BossHitMultiplier = v
end, nil, "╨Ъ╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛ ╤Г╨┤╨░╤А╨╛╨▓ ╨┐╨╛ ╨▒╨╛╤Б╤Б╤Г ╨╖╨░ ╨╛╨┤╨╕╨╜ ╤Ж╨╕╨║╨╗")

-- ============================================================
-- 6. ╨а╨Р╨Ч╨Ф╨Х╨Ы: PROTECTION
-- ============================================================
KV.sectionLabel(KV.protectionPage, "SAFETY & DEFENSE MODS")
local antiConn
KV.createToggle(KV.protectionPage, "Godmode / Anti-Hit", "╨Ю╤В╨║╨╗╤О╤З╨░╨╡╤В ╨║╨╛╨╗╨╗╨╕╨╖╨╕╨╕ ╤Г╤А╨╛╨╜╨░ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨░ (╨╖╨░╤Й╨╕╤В╨░ ╨╛╤В ╤З╤Г╨╢╨╕╤Е ╤Г╨┤╨░╤А╨╛╨▓)", KV.Config.AntiHit, function(v)
    KV.Config.AntiHit = v
    if v then
        antiConn = RunService.Stepped:Connect(function()
            if KV.Config.AntiHit and LocalPlayer.Character then
                for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                    if p:IsA("BasePart") then p.CanTouch = false end
                end
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
            end
        end)
        table.insert(KV.ScriptConnections, antiConn)
    else
        if antiConn then antiConn:Disconnect() end
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                if p:IsA("BasePart") then p.CanTouch = true end
            end
        end
    end
end)

KV.createToggle(KV.protectionPage, "Auto Low HP Sky Safe TP", "╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓ ╨╜╨╡╨▒╨╡╤Б╨╜╤Г╤О ╨╖╨╛╨╜╤Г ╨▒╨╡╨╖╨╛╨┐╨░╤Б╨╜╨╛╤Б╤В╨╕ ╨┐╤А╨╕ ╨┐╨░╨┤╨╡╨╜╨╕╨╕ HP ╨╜╨╕╨╢╨╡ 25%", KV.Config.AutoSafeTPLowHP, function(v)
    KV.Config.AutoSafeTPLowHP = v
end)

KV.createToggle(KV.protectionPage, "Anti-Ragdoll & Stun", "╨Ч╨░╨┐╤А╨╡╤В ╨┐╨░╨┤╨╡╨╜╨╕╨╣ ╨╕ ╤Б╤В╨░╨╜╨╛╨▓", KV.Config.AntiRagdoll, function(v)
    KV.Config.AntiRagdoll = v
    if v then
        task.spawn(function()
            while KV.Config.AntiRagdoll do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
                task.wait(0.5)
            end
        end)
    end
end)

KV.createToggle(KV.protectionPage, "Anti-Knockback", "╨Ю╤В╨║╨╗╤О╤З╨░╨╡╤В ╨╛╤В╨▒╤А╨░╤Б╤Л╨▓╨░╨╜╨╕╨╡ ╨┐╤А╨╕ ╤Г╨┤╨░╤А╨░╤Е", KV.Config.AntiKnockback, function(v)
    KV.Config.AntiKnockback = v
end)

KV.createButton(KV.protectionPage, "Teleport to Sky Safe Zone", "╨б╨┐╨░╨▓╨╜╨╕╤В ╨╜╨╡╨▒╨╡╤Б╨╜╤Г╤О ╨┐╨╗╨░╤В╤Д╨╛╤А╨╝╤Г ╨╕ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨▓╨░╤Б ╤В╤Г╨┤╨░", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local p = Workspace:FindFirstChild("Vortex_SafePlatform")
        if not p then
            p = Instance.new("Part")
            p.Name = "Vortex_SafePlatform"
            p.Size = Vector3.new(60, 2, 60)
            p.Position = Vector3.new(0, 5000, 0)
            p.Anchored = true
            p.Material = Enum.Material.SmoothPlastic
            p.Color = KV.AccentColor
            p.Parent = Workspace
        end
        KV.safeTeleport(CFrame.new(0, 5005, 0))
        KV.notify("Vortex Safe Zone", "Teleported to the sky platform!", 3)
    end
end)

-- ============================================================
-- 7. ╨а╨Р╨Ч╨Ф╨Х╨Ы: TELEPORTS & POINTS
-- ============================================================
KV.sectionLabel(KV.teleportsPage, "WORLD TELEPORTS")

KV.locationDisplayList = {
    {"Spawn Beach", "Start area"},
    {"Tiny Island", "Tiny Island"},
    {"Legend Beach", "Legend Beach"},
    {"Frost Gym", "Frost zone"},
    {"Mythic Gym", "Mythic zone"},
    {"Jungle Gym", "Jungle zone"},
    {"Industrial Gym", "Industrial zone"},
    {"Eternal Gym", "Eternal zone"},
    {"Legend Gym", "Legend zone"},
    {"Muscle King Gym", "Muscle King zone"},
    {"Overcharged Gym", "Overcharged zone"},
    {"Temporary Zone", "Event / temporary zone"},
}

for _, loc in ipairs(KV.locationDisplayList) do
    KV.createButton(KV.teleportsPage, loc[1], function()
        return KV.t("╨С╨╡╨╖╨╛╨┐╨░╤Б╨╜╤Л╨╣ ╤Г╨╝╨╜╤Л╨╣ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В: ", "Safe smart teleport: ") .. loc[2]
    end, function()
        KV.smartTeleportToIsland(loc[1])
    end)
end

KV.sectionLabel(KV.teleportsPage, "WAYPOINTS & PLAYER TELEPORT")
KV.WaypointLabel = Instance.new("TextLabel", KV.createGlassPanel(KV.teleportsPage, 34))
KV.WaypointLabel.BackgroundTransparency = 1; KV.WaypointLabel.Position = UDim2.new(0, 12, 0, 0); KV.WaypointLabel.Size = UDim2.new(1, -24, 1, 0)
KV.WaypointLabel.Font = Enum.Font.GothamBold; KV.WaypointLabel.TextColor3 = KV.AccentColor; KV.WaypointLabel.TextSize = 11; KV.WaypointLabel.TextXAlignment = Enum.TextXAlignment.Left; CollectionService:AddTag(KV.WaypointLabel, "AccentText")
KV.WaypointLabel.Text = "Saved Waypoint: None"

KV.createButton(KV.teleportsPage, "Save Current Position as Waypoint", "╨б╨╛╤Е╤А╨░╨╜╤П╨╡╤В ╨▓╨░╤И╤Г ╤В╨╡╨║╤Г╤Й╤Г╤О ╨┐╨╛╨╖╨╕╤Ж╨╕╤О ╨▓ ╨┐╨░╨╝╤П╤В╤М", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        KV.Config.SavedWaypoint = LocalPlayer.Character.HumanoidRootPart.CFrame
        local p = KV.Config.SavedWaypoint.Position
        KV.WaypointLabel.Text = string.format("Saved Waypoint: (%.0f, %.0f, %.0f)", p.X, p.Y, p.Z)
        KV.notify("Vortex Waypoint", "Position saved!", 2)
    end
end)

KV.createButton(KV.teleportsPage, "Teleport to Saved Waypoint", "╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨╜╨░ ╤А╨░╨╜╨╡╨╡ ╤Б╨╛╤Е╤А╨░╨╜╨╡╨╜╨╜╤Г╤О ╤В╨╛╤З╨║╤Г", function()
    if KV.Config.SavedWaypoint then
        KV.safeTeleport(KV.Config.SavedWaypoint)
        KV.notify("Vortex Waypoint", "Teleported to saved waypoint!", 2)
    else
        KV.notify("Vortex Waypoint", "No saved waypoint!", 2)
    end
end)

KV.createButton(KV.teleportsPage, "Teleport to Strongest Player", "╨в╨╡╨╗╨╡╨┐╨╛╤А╤В╨╕╤А╤Г╨╡╤В ╨║ ╨╕╨│╤А╨╛╨║╤Г ╤Б ╨╝╨░╨║╤Б╨╕╨╝╨░╨╗╤М╨╜╨╛╨╣ ╤Б╨╕╨╗╨╛╨╣ ╨╜╨░ ╤Б╨╡╤А╨▓╨╡╤А╨╡", function()
    local topP, maxStr = nil, -1
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local ls = p:FindFirstChild("leaderstats")
            local str = ls and ls:FindFirstChild("Strength") and ls.Strength.Value or 0
            if str > maxStr then
                maxStr = str
                topP = p
            end
        end
    end
    if topP and topP.Character and topP.Character:FindFirstChild("HumanoidRootPart") then
        KV.safeTeleport(topP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
        KV.notify("Vortex TP", "Teleported to top player: " .. topP.Name, 2)
    end
end)

-- ============================================================
-- 8. ╨а╨Р╨Ч╨Ф╨Х╨Ы: AUTOMATION & EGGS
-- ============================================================
KV.sectionLabel(KV.automationPage, "REBIRTH ENGINE (MUSCLE LEGENDS)")

-- ╨б╨╛╤Е╤А╨░╨╜╨╡╨╜╨╕╨╡ ╨┐╨╛╨╖╨╕╤Ж╨╕╨╕ ╨┐╨╡╤А╨╡╨┤ ╤А╨╡╨▒╨╕╤А╤В╨╛╨╝ ╨╕ ╨▓╨╛╨╖╨▓╤А╨░╤В ╨┐╨╛╤Б╨╗╨╡ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨░ ╨╜╨░ ╤Б╨┐╨░╨▓╨╜
KV.rebirthRestoreActive = false

KV.savePositionForRebirth = function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.CFrame or nil
end

KV.restorePositionAfterRebirth = function(savedCF)
    if not KV.Config.StayAfterRebirth or not savedCF then return end
    if KV.rebirthRestoreActive then return end
    KV.rebirthRestoreActive = true
    task.spawn(function()
        local t0 = tick()
        while tick() - t0 < 8 do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - savedCF.Position).Magnitude
                if dist > 15 then
                    pcall(function()
                        hrp.CFrame = savedCF
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                    task.wait(0.4)
                else
                    KV.rebirthRestoreActive = false
                    return
                end
            end
            task.wait(0.2)
        end
        KV.rebirthRestoreActive = false
    end)
end

KV.triggerRebirth = function()
    local savedCF = KV.savePositionForRebirth()
    local done = false

    -- 1. ╨Ъ╨░╨╜╨╛╨╜╨╕╤З╨╡╤Б╨║╨╕╨╣ ╤А╨╡╨╝╨╛╤Г╤В ╨╕╨│╤А╤Л: rEvents.rebirthRemote:InvokeServer("rebirthRequest")
    pcall(function()
        local rb = KV.getREvent("rebirthRemote")
        if rb and rb:IsA("RemoteFunction") then
            local res = rb:InvokeServer("rebirthRequest")
            if res == true then done = true end
        end
    end)

    -- 2. ╨д╨╛╨╗╨▒╤Н╨║: muscleEvent
    if not done then
        local ev = KV.getMuscleEvent()
        if ev then
            pcall(function() ev:FireServer("rebirthRequest") end)
            pcall(function() ev:FireServer("rebirth") end)
            pcall(function() ev:FireServer("requestRebirth") end)
        end
    end

    -- 3. ╨Ю╤Б╤В╨░╨╗╤М╨╜╤Л╨╡ ╤А╨╡╨╝╨╛╤Г╤В╤Л ╤Б "rebirth" ╨▓ ╨╕╨╝╨╡╨╜╨╕ (╤В╨╛╨╗╤М╨║╨╛ ╨╡╤Б╨╗╨╕ ╨╛╤Б╨╜╨╛╨▓╨╜╨╛╨╣ ╨╜╨╡ ╨╛╤В╨▓╨╡╤В╨╕╨╗)
    if not done then
        pcall(function()
            local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
            if rEvents then
                for _, child in pairs(rEvents:GetChildren()) do
                    if string.find(string.lower(child.Name), "rebirth") then
                        if child:IsA("RemoteFunction") and child.Name ~= "rebirthRemote" then
                            pcall(function() child:InvokeServer("rebirthRequest") end)
                        elseif child:IsA("RemoteEvent") then
                            pcall(function() child:FireServer("rebirthRequest") end)
                        end
                    end
                end
            end
        end)
    end

    -- ╨Т╨╛╨╖╨▓╤А╨░╤В ╨╜╨░ ╨╕╤Б╤Е╨╛╨┤╨╜╤Г╤О ╤В╨╛╤З╨║╤Г ╨▓╨╝╨╡╤Б╤В╨╛ ╤Б╨┐╨░╨▓╨╜╨░
    if KV.Config.StayAfterRebirth then
        KV.restorePositionAfterRebirth(savedCF)
    end
    return done
end

KV.createToggle(KV.automationPage, "Auto Rebirth (╨С╨╡╤Б╨║╨╛╨╜╨╡╤З╨╜╤Л╨╣ ╨░╨▓╤В╨╛-╤А╨╡╨▒╨╕╤А╤В)", "╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╨▓╤Л╨┐╨╛╨╗╨╜╤П╨╡╤В ╨┐╨╡╤А╨╡╤А╨╛╨╢╨┤╨╡╨╜╨╕╨╡ ╤Б╤А╨░╨╖╤Г ╨┐╤А╨╕ ╨┤╨╛╤Б╤В╨╕╨╢╨╡╨╜╨╕╨╕ ╨╜╤Г╨╢╨╜╨╛╨│╨╛ ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨░ ╤Б╨╕╨╗╤Л", KV.Config.AutoRebirth, function(v)
    KV.Config.AutoRebirth = v
    if v then
        task.spawn(function()
            while KV.Config.AutoRebirth do
                local char = LocalPlayer.Character
                local busy = (char and char:GetAttribute("IsRebirthing") == true)
                    or (LocalPlayer:GetAttribute("LastMapCFrame") ~= nil)
                if not busy then
                    KV.triggerRebirth()
                end
                task.wait(0.4)
            end
        end)
    end
end)

KV.createToggle(KV.automationPage, "Stay In Place After Rebirth (╨Э╨╡ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨╛╨▓╨░╤В╤М ╨╜╨░ ╤Б╨┐╨░╨▓╨╜)", "╨б╨╛╤Е╤А╨░╨╜╤П╨╡╤В ╨▓╨░╤И╤Г ╨┐╨╛╨╖╨╕╤Ж╨╕╤О ╨┤╨╛ ╨┐╨╡╤А╨╡╤А╨╛╨╢╨┤╨╡╨╜╨╕╤П ╨╕ ╨▓╨╛╨╖╨▓╤А╨░╤Й╨░╨╡╤В ╨▓╨░╤Б ╨╛╨▒╤А╨░╤В╨╜╨╛ ╨┐╨╛╤Б╨╗╨╡ ╨╜╨╡╨│╨╛", KV.Config.StayAfterRebirth, function(v)
    KV.Config.StayAfterRebirth = v
    KV.notify("Vortex Rebirth", v
        and KV.tn("╨Я╨╛╤Б╨╗╨╡ ╤А╨╡╨▒╨╕╤А╤В╨░ ╨▓╤Л ╨╛╤Б╤В╨░╨╜╨╡╤В╨╡╤Б╤М ╨╜╨░ ╨╝╨╡╤Б╤В╨╡!", "After rebirth you will stay in place!")
        or KV.tn("╨Я╨╛╤Б╨╗╨╡ ╤А╨╡╨▒╨╕╤А╤В╨░ ╨▒╤Г╨┤╨╡╤В ╨╛╨▒╤Л╤З╨╜╤Л╨╣ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╨╜╨░ ╤Б╨┐╨░╨▓╨╜.", "Normal spawn teleport after rebirth."), 3)
end)

KV.createButton(KV.automationPage, "Manual Rebirth (╨Я╨╡╤А╨╡╤А╨╛╨┤╨╕╤В╤М╤Б╤П ╨┐╤А╤П╨╝╨╛ ╤Б╨╡╨╣╤З╨░╤Б)", "╨Я╤А╨╕╨╜╤Г╨┤╨╕╤В╨╡╨╗╤М╨╜╨╛ ╨╖╨░╨┐╤А╨░╤И╨╕╨▓╨░╨╡╤В ╨┐╨╡╤А╨╡╤А╨╛╨╢╨┤╨╡╨╜╨╕╨╡ ╨╜╨░ ╤Б╨╡╤А╨▓╨╡╤А╨╡ ╤З╨╡╤А╨╡╨╖ ╨▓╤Б╨╡ ╨║╨░╨╜╨░╨╗╤Л", function()
    KV.triggerRebirth()
    KV.notify("Vortex Rebirth", KV.tn("╨Ч╨░╨┐╤А╨╛╤Б ╨╜╨░ ╨┐╨╡╤А╨╡╤А╨╛╨╢╨┤╨╡╨╜╨╕╨╡ ╨╛╤В╨┐╤А╨░╨▓╨╗╨╡╨╜!", "Rebirth requested!"), 2)
end)

KV.sectionLabel(KV.automationPage, "CHESTS & ORBS MAGNET")
KV.createButton(KV.automationPage, "Collect All Map Chests", "╨Р╨▓╤В╨╛-╤В╨╡╨╗╨╡╨┐╨╛╤А╤В ╨┐╨╛ ╨▓╤Б╨╡╨╝ ╤Б╤Г╨╜╨┤╤Г╨║╨░╨╝ ╨║╨░╤А╤В╤Л ╨╕ ╨╕╤Е ╤Б╨▒╨╛╤А", function()
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(string.lower(obj.Name), "chest") then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                KV.safeTeleport(part.CFrame)
                count = count + 1
                task.wait(0.3)
            end
        end
    end
    KV.notify("Chests", "Chests collected: " .. tostring(count), 3)
end)

KV.createToggle(KV.automationPage, "Auto Collect Map Orbs", "╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╨┐╤А╨╕╤В╤П╨│╨╕╨▓╨░╨╡╤В/╤Б╨╛╨▒╨╕╤А╨░╨╡╤В ╤Б╤Д╨╡╤А╤Л ╤Б╨╛ ╨▓╤Б╨╡╨╣ ╨║╨░╤А╤В╤Л", KV.Config.AutoCollectOrbs, function(v)
    KV.Config.AutoCollectOrbs = v
    if v then
        task.spawn(function()
            while KV.Config.AutoCollectOrbs do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if string.find(string.lower(obj.Name), "orb") then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                part.CFrame = char.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end)

KV.sectionLabel(KV.automationPage, "MASS EGG HATCHER (╨Ф╨Ю 500 ╨Ч╨Р ╨а╨Р╨Ч)")

-- ╨Ф╨╕╨╜╨░╨╝╨╕╤З╨╡╤Б╨║╨╕╨╣ ╨║╨░╤В╨░╨╗╨╛╨│ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨╛╨▓ ╨╕╨╖ ╤Б╨░╨╝╨╛╨╣ ╨╕╨│╤А╤Л (╨╛╨▒╨╜╨╛╨▓╨╗╨╡╨╜╨╕╤П ╨╜╨╡ ╨╗╨╛╨╝╨░╤О╤В ╤Б╨┐╨╕╤Б╨╛╨║).
-- ╨Т╤Б╨╡╨│╨┤╨░ ╨╛╨▒╤К╨╡╨┤╨╕╨╜╤П╨╡╨╝ ╤Б ╨▒╨░╨╖╨╛╨▓╤Л╨╝ ╤Б╨┐╨╕╤Б╨║╨╛╨╝, ╤З╤В╨╛╨▒╤Л ╨▓╨░╨╢╨╜╤Л╨╡ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╤Л (Overcharged ╨╕ ╤В.╨┐.) ╨╜╨╡ ╨┐╤А╨╛╨┐╨░╨┤╨░╨╗╨╕.
KV.getCrystalCatalog = function()
    local names = {}
    local seen = {}
    local add = function(n)
        if type(n) == "string" and n ~= "" and not seen[n] then
            seen[n] = true
            table.insert(names, n)
        end
    end
    pcall(function()
        local shared = ReplicatedStorage:WaitForChild("shared", 5)
        local catalogs = shared and shared:WaitForChild("catalogs", 5)
        local prices = catalogs and catalogs:WaitForChild("crystalPrices", 5)
        if prices then
            for _, entry in pairs(prices:GetChildren()) do
                add(entry.Name)
            end
        end
    end)
    for _, n in ipairs(KV.crystalsList) do
        add(n)
    end
    table.sort(names)
    return names
end

KV.listContains = function(list, value)
    for _, v in ipairs(list) do
        if v == value then return true end
    end
    return false
end

KV.crystalCatalog = KV.getCrystalCatalog()
if not KV.listContains(KV.crystalCatalog, KV.Config.SelectedCrystal) then
    KV.Config.SelectedCrystal = KV.crystalCatalog[1] or "Blue Crystal"
end

KV.getCrystalPrice = function(name)
    local ok, price, kind = pcall(function()
        local shared = ReplicatedStorage:FindFirstChild("shared")
        local catalogs = shared and shared:FindFirstChild("catalogs")
        local prices = catalogs and catalogs:FindFirstChild("crystalPrices")
        local entry = prices and prices:FindFirstChild(name)
        if not entry then return nil, nil end
        local p = entry:FindFirstChild("price")
        local k = entry:FindFirstChild("priceType")
        return p and tonumber(p.Value) or nil, k and k.Value or "Gems"
    end)
    if ok then return price, kind end
    return nil, nil
end

-- ╨б╤В╨░╤В╤Г╤Б-╤Б╤В╤А╨╛╨║╨░: ╨║╤А╨╕╤Б╤В╨░╨╗╨╗ / ╨╝╨╡╤Б╤В╨░ ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡ / ╨│╨╡╨╝╤Л / ╤В╨╡╨║╤Г╤Й╨╡╨╡ ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛
KV.HatchStatusPanel = KV.createGlassPanel(KV.automationPage, 34)
KV.HatchStatusLabel = Instance.new("TextLabel", KV.HatchStatusPanel)
KV.HatchStatusLabel.BackgroundTransparency = 1
KV.HatchStatusLabel.Position = UDim2.new(0, 12, 0, 0)
KV.HatchStatusLabel.Size = UDim2.new(1, -24, 1, 0)
KV.HatchStatusLabel.Font = Enum.Font.GothamBold
KV.HatchStatusLabel.TextColor3 = Color3.fromRGB(241, 245, 249)
KV.HatchStatusLabel.TextSize = 11
KV.HatchStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

KV.refreshHatchStatus = function()
    local free, owned, cap = KV.freePetSlots()
    local gems = KV.getCurrency("Gems") or 0
    local slotText
    if free then
        slotText = KV.t("╨╝╨╡╤Б╤В╨░: ", "slots: ") .. owned .. "/" .. cap
            .. KV.t(" (╤Б╨▓╨╛╨▒╨╛╨┤╨╜╨╛ ", " (free ") .. free .. ")"
    else
        slotText = KV.t("╨┐╨╡╤В╨╛╨▓: ", "pets: ") .. owned
            .. KV.t(" (╨▓╨╝╨╡╤Б╤В╨╕╨╝╨╛╤Б╤В╤М ╨╜╨╡╨╕╨╖╨▓╨╡╤Б╤В╨╜╨░ тАФ ╨╛╨│╤А╨░╨╜╨╕╤З╨╡╨╜╨╕╨╡ ╨┐╨╛ ╨╛╤В╨║╨░╨╖╤Г ╤Б╨╡╤А╨▓╨╡╤А╨░)", " (capacity unknown тАФ server denial will stop us)")
    end
    KV.HatchStatusLabel.Text = KV.t("╨Ъ╤А╨╕╤Б╤В╨░╨╗╨╗: ", "Crystal: ") .. KV.Config.SelectedCrystal
        .. " | " .. slotText
        .. " | " .. KV.t("╨У╨╡╨╝╤Л: ", "Gems: ") .. tostring(gems)
        .. " | " .. KV.t("╨Ю╤В╨║╤А╤Л╤В╤М: ", "Hatch: ") .. tostring(KV.Config.HatchCount)
end

-- ╨Я╤А╨╛╨▓╨╡╤А╨║╨░ ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨░ ╨┐╨╡╤А╨╡╨┤ ╨╝╨░╤Б╤Б╨╛╨▓╤Л╨╝ ╨╛╤В╨║╤А╤Л╤В╨╕╨╡╨╝: 1..500, ╨╝╨╡╤Б╤В╨░ ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡, ╨▓╨░╨╗╤О╤В╨░
KV.validateHatchCount = function(count)
    count = math.floor(tonumber(count) or 0)
    if count < 1 then
        return nil, KV.tn("╨Ь╨╕╨╜╨╕╨╝╤Г╨╝ тАФ 1 ╤П╨╣╤Ж╨╛!", "Minimum is 1 egg!")
    end
    if count > 500 then
        return nil, KV.tn("╨Ь╨░╨║╤Б╨╕╨╝╤Г╨╝ тАФ 500 ╤П╨╕╤Ж ╨╖╨░ ╨╛╨┤╨╕╨╜ ╤А╨░╨╖!", "Maximum is 500 eggs at once!")
    end

    local free, owned, cap = KV.freePetSlots()
    if free and count > free then
        return nil, string.format(
           KV.tn("╨б╨▓╨╛╨▒╨╛╨┤╨╜╨╛ ╤В╨╛╨╗╤М╨║╨╛ %d ╨╝╨╡╤Б╤В (╨╖╨░╨╜╤П╤В╨╛ %d ╨╕╨╖ %d), ╨░ ╨╖╨░╨┐╤А╨╛╤И╨╡╨╜╨╛ %d! ╨г╨╝╨╡╨╜╤М╤И╨╕╤В╨╡ ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛.",
              "Only %d free slots (used %d of %d) but %d requested! Reduce the amount."),
            free, owned, cap, count)
    end

    local price, kind = KV.getCrystalPrice(KV.Config.SelectedCrystal)
    if price and price > 0 then
        local balance = KV.getCurrency(kind)
        if balance then
            if balance < price then
                return nil, string.format(
                   KV.tn("╨Э╨╡ ╤Е╨▓╨░╤В╨░╨╡╤В ╨▓╨░╨╗╤О╤В╤Л: ╨╜╤Г╨╢╨╜╨╛ %d %s, ╤Г ╨▓╨░╤Б %d.",
                      "Not enough currency: need %d %s, you have %d."),
                    price, kind or "Gems", balance)
            end
            local affordable = math.floor(balance / price)
            if count > affordable then
                return nil, string.format(
                   KV.tn("╨е╨▓╨░╤В╨╕╤В ╤В╨╛╨╗╤М╨║╨╛ ╨╜╨░ %d ╨╕╨╖ %d ╤П╨╕╤Ж (╤Ж╨╡╨╜╨░ %d %s, ╨▒╨░╨╗╨░╨╜╤Б %d).",
                      "Enough for only %d of %d eggs (price %d %s, balance %d)."),
                    affordable, count, price, kind or "Gems", balance)
            end
        end
    end
    return count, nil
end

-- ╨Ь╨░╤Б╤Б╨╛╨▓╨╛╨╡ ╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡: count ╤П╨╕╤Ж ╨┐╨╛╨┤╤А╤П╨┤ (╨╛╤В╨╝╨╡╨╜╨░ тАФ ╨┐╨╛╨▓╤В╨╛╤А╨╜╤Л╨╝ ╨╜╨░╨╢╨░╤В╨╕╨╡╨╝ ╨╕╨╗╨╕ Stop)
KV.hatchState = {running = false, cancel = false}

-- ╨в╨╛╤З╨╜╨░╤П ╨┐╤А╨╕╤З╨╕╨╜╨░ ╨╛╤В╨║╨░╨╖╨░ ╤Б╨╡╤А╨▓╨╡╤А╨░ ╨┐╤А╨╕ ╨╛╤В╨║╤А╤Л╤В╨╕╨╕
KV.describeDenial = function()
    local free = KV.freePetSlots()
    if free ~= nil and free <= 0 then
        return KV.tn("╤Б╨╡╤А╨▓╨╡╤А ╨╛╤В╨║╨░╨╖╨░╨╗: ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╤М ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╨┐╨╛╨╗╨╛╨╜ тАФ ╨┐╤А╨╛╨┤╨░╨╣╤В╨╡ ╨╕╨╗╨╕ ╤Г╨╗╤Г╤З╤И╨╕╤В╨╡ ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓",
            "server denied: pet inventory is full тАФ sell or upgrade pets")
    end
    local price, kind = KV.getCrystalPrice(KV.Config.SelectedCrystal)
    if price and price > 0 then
        local balance = KV.getCurrency(kind)
        if balance and balance < price then
            return string.format(
               KV.tn("╤Б╨╡╤А╨▓╨╡╤А ╨╛╤В╨║╨░╨╖╨░╨╗: ╨╜╨╡ ╤Е╨▓╨░╤В╨░╨╡╤В ╨▓╨░╨╗╤О╤В╤Л (%s: ╨╜╤Г╨╢╨╜╨╛ %d, ╨╡╤Б╤В╤М %d)",
                  "server denied: not enough currency (%s: need %d, have %d)"),
                kind or "Gems", price, balance)
        end
    end
    return KV.tn("╤Б╨╡╤А╨▓╨╡╤А ╨╛╤В╨║╨░╨╖╨░╨╗: ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╤М ╨┐╨╛╨╗╨╛╨╜ ╨╕╨╗╨╕ ╨╜╨╡ ╤Е╨▓╨░╤В╨░╨╡╤В ╨▓╨░╨╗╤О╤В╤Л",
        "server denied: inventory full or not enough currency")
end

-- ============================================================
-- ╨Ь╨░╤Б╤Б╨╛╨▓╨╛╨╡ ╨╛╤В╨║╤А╤Л╤В╨╕╨╡ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨╛╨▓ (╨┤╨╛ 500 ╨╖╨░ ╤А╨░╨╖)
-- ============================================================
KV.autoCrystalSync = nil -- ╤Б╨╕╨╜╤Е╤А╨╛╨╜╨╕╨╖╨░╤Ж╨╕╤П ╨┐╨╕╨╗╨╗╨░ ╤В╤Г╨╝╨▒╨╗╨╡╤А╨░ ╨┐╤А╨╕ ╨▓╨╜╨╡╤И╨╜╨╡╨╝ ╤Б╨▒╤А╨╛╤Б╨╡

KV.hatchBatch = function(count)
    if KV.hatchState.running then
        KV.hatchState.cancel = true
        KV.notify("Vortex Hatch", KV.tn("╨Ь╨░╤Б╤Б╨╛╨▓╨╛╨╡ ╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡ ╨╛╤Б╤В╨░╨╜╨░╨▓╨╗╨╕╨▓╨░╨╡╤В╤Б╤П...", "Stopping mass hatch..."), 2)
        return
    end
    local n, err = KV.validateHatchCount(count)
    if not n then
        KV.notify("Vortex Hatch", err, 5)
        return
    end

    if KV.Config.AutoCrystal then
        KV.Config.AutoCrystal = false -- ╤Б╨╜╨░╤З╨░╨╗╨░ ╨│╨░╤Б╨╕╨╝ ╨░╨▓╤В╨╛-╤А╨╡╨╢╨╕╨╝, ╤З╤В╨╛╨▒╤Л ╨╜╨╡ ╨┤╤Г╨▒╨╗╨╕╤А╨╛╨▓╨░╤В╤М ╨╛╤В╨║╤А╤Л╤В╨╕╤П
        if KV.autoCrystalSync then KV.autoCrystalSync(false) end
    end
    KV.hatchState.running = true
    KV.hatchState.cancel = false
    KV.Config.HatchPower = true
    task.spawn(function()
        local opened = 0
        local failReason = nil
        local lastPetText = nil
        -- ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╨╝ ╤Б╤В╤А╨╛╨│╨╛ ╨┤╨╕╤Б╤В╨░╨╜╤Ж╨╕╨╛╨╜╨╜╨╛ (╨▒╨╡╨╖ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨░ ╨║ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╤Г)
        for _ = 1, n do
            if KV.hatchState.cancel or not KV.Config.HatchPower then
                failReason = KV.tn("╨╛╤Б╤В╨░╨╜╨╛╨▓╨╗╨╡╨╜╨╛ ╨┐╨╛╨╗╤М╨╖╨╛╨▓╨░╤В╨╡╨╗╨╡╨╝", "stopped by user")
                break
            end
            local ok, petOrReason, rarity = KV.openCrystalOnce(KV.Config.SelectedCrystal)
            -- "nogrow" (╨┐╨╕╤В╨╛╨╝╨╡╤Ж ╨╜╨╡ ╤Г╤Б╨┐╨╡╨╗ ╨┐╨╛╤П╨▓╨╕╤В╤М╤Б╤П/╨║╤Г╨╗╨┤╨░╤Г╨╜) тАФ ╨┐╤А╨╛╨▒╤Г╨╡╨╝ ╨╡╤Й╤С ╨┤╨╛ 3 ╤А╨░╨╖, ╨╜╨╡ ╨▒╤А╨╛╤Б╨░╨╡╨╝ ╨▒╨░╤В╤З
            local tries = 1
            while not ok and petOrReason == "nogrow" and tries < 3 do
                tries = tries + 1
                task.wait(1.2)
                if KV.hatchState.cancel or not KV.Config.HatchPower then break end
                ok, petOrReason, rarity = KV.openCrystalOnce(KV.Config.SelectedCrystal)
            end
            if not ok and (KV.hatchState.cancel or not KV.Config.HatchPower) then
                failReason = KV.tn("╨╛╤Б╤В╨░╨╜╨╛╨▓╨╗╨╡╨╜╨╛ ╨┐╨╛╨╗╤М╨╖╨╛╨▓╨░╤В╨╡╨╗╨╡╨╝", "stopped by user")
                break
            end
            if ok then
                opened = opened + 1
                if type(petOrReason) == "string" then
                    lastPetText = petOrReason .. (rarity and (" (" .. tostring(rarity) .. ")") or "")
                end
            else
                if petOrReason == "denied" then
                    failReason = KV.describeDenial()
                elseif petOrReason == "nogrow" then
                    failReason = KV.tn("╤Б╨╡╤А╨▓╨╡╤А ╨┐╤А╨╕╨╜╤П╨╗ ╨▓╤Л╨╖╨╛╨▓, ╨╜╨╛ ╨┐╨╕╤В╨╛╨╝╨╡╤Ж ╨╜╨╡ ╨┐╨╛╤П╨▓╨╕╨╗╤Б╤П ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡ тАФ ╨┐╤А╨╛╨▓╨╡╤А╤М╤В╨╡, ╤Е╨▓╨░╤В╨░╨╡╤В ╨╗╨╕ ╨▓╨░╨╗╤О╤В╤Л ╨╕ ╨╝╨╡╤Б╤В, ╨╗╨╕╨▒╨╛ ╨┐╨╛╨┤╨╛╨╣╨┤╨╕╤В╨╡ ╨║ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╤Г ╨▓╤А╤Г╤З╨╜╤Г╤О",
                        "server accepted the call but no pet appeared тАФ check currency and free slots, or stand next to the crystal manually")
                elseif petOrReason == "invokefail" then
                    failReason = KV.tn("╨╛╤И╨╕╨▒╨║╨░ ╨▓╤Л╨╖╨╛╨▓╨░ openCrystalRemote",
                        "openCrystalRemote call failed")
                else
                    failReason = KV.tn("╤А╨╡╨╝╨╛╤Г╤В openCrystalRemote ╨╜╨╡ ╨╜╨░╨╣╨┤╨╡╨╜",
                        "openCrystalRemote not found")
                end
                break
            end
            if opened % 25 == 0 then KV.refreshHatchStatus() end
            task.wait(KV.Config.HatchDelay)
        end
        KV.hatchState.running = false
        KV.Config.HatchPower = false
        KV.refreshHatchStatus()
        local msg = string.format(KV.t("╨Ю╤В╨║╤А╤Л╤В╨╛ ╤П╨╕╤Ж: %d ╨╕╨╖ %d", "Eggs opened: %d of %d"), opened, n)
        if lastPetText then
            msg = msg .. " | " .. KV.t("╨┐╨╛╤Б╨╗╨╡╨┤╨╜╨╕╨╣: ", "last: ") .. lastPetText
        end
        if failReason then
            msg = msg .. " тАФ " .. failReason
        end
        KV.notify("Vortex Hatch", msg, 5)
    end)
end

KV.createSlider(KV.automationPage, "Eggs Per Batch (1-500)", 1, 500, KV.Config.HatchCount, function(v)
    KV.Config.HatchCount = math.floor(v)
    KV.refreshHatchStatus()
end, nil, "╨б╨║╨╛╨╗╤М╨║╨╛ ╤П╨╕╤Ж ╨╛╤В╨║╤А╤Л╨▓╨░╤В╤М ╨╖╨░ ╨╛╨┤╨╕╨╜ Mass Hatch (╨╝╨░╨║╤Б╨╕╨╝╤Г╨╝ 500)")

local acCard, acSet
acCard, acSet = KV.createToggle(KV.automationPage, "Auto Hatch Selected Egg/Crystal", "╨Р╨▓╤В╨╛-╨╛╤В╨║╤А╤Л╤В╨╕╨╡ ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨│╨╛ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨░ ╨┐╨╛╨║╨░ ╨▓╨║╨╗╤О╤З╨╡╨╜╨╛ (╨╛╤Б╤В╨░╨╜╨╛╨▓╨║╨░ ╨┐╤А╨╕ ╨╛╤В╨║╨░╨╖╨╡ ╤Б╨╡╤А╨▓╨╡╤А╨░)", KV.Config.AutoCrystal, function(v)
    KV.Config.AutoCrystal = v
    if v then
        if KV.hatchState.running then
            KV.Config.AutoCrystal = false
            if KV.autoCrystalSync then KV.autoCrystalSync(false) end
            KV.notify("Vortex Hatch", KV.tn("╨Ш╨┤╤С╤В ╨╝╨░╤Б╤Б╨╛╨▓╨╛╨╡ ╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡ тАФ ╤Б╨╜╨░╤З╨░╨╗╨░ ╨╛╤Б╤В╨░╨╜╨╛╨▓╨╕╤В╨╡ ╨╡╨│╨╛ (Stop).",
                "Mass hatch is running тАФ stop it first (Stop)."), 4)
            return
        end
        -- ╨╛╤В╨║╤А╤Л╤В╨╕╨╡ ╨┤╨╕╤Б╤В╨░╨╜╤Ж╨╕╨╛╨╜╨╜╨╛╨╡, ╨▒╨╡╨╖ ╤В╨╡╨╗╨╡╨┐╨╛╤А╤В╨░
        task.spawn(function()
            local nogrowStreak = 0
            while KV.Config.AutoCrystal do
                local ok, reason = KV.openCrystalOnce(KV.Config.SelectedCrystal)
                if not ok and reason == "nogrow" and nogrowStreak < 2 then
                    -- ╨┐╨╕╤В╨╛╨╝╨╡╤Ж ╨╜╨╡ ╨┐╨╛╤П╨▓╨╕╨╗╤Б╤П тАФ ╨┐╤А╨╛╨▒╤Г╨╡╨╝ ╨╡╤Й╤С ╨┤╨╛ 3 ╤А╨░╨╖ ╨┐╨╛╨┤╤А╤П╨┤, ╨┐╤А╨╡╨╢╨┤╨╡ ╤З╨╡╨╝ ╨╛╤Б╤В╨░╨╜╨╛╨▓╨╕╤В╤М╤Б╤П
                    nogrowStreak = nogrowStreak + 1
                    task.wait(1.2)
                elseif not ok then
                    KV.Config.AutoCrystal = false
                    if KV.autoCrystalSync then KV.autoCrystalSync(false) end
                    local msg
                    if reason == "denied" then
                        msg = KV.tn("╨Р╨▓╤В╨╛-╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡ ╨╛╤Б╤В╨░╨╜╨╛╨▓╨╗╨╡╨╜╨╛: ", "Auto hatch stopped: ") .. KV.describeDenial()
                    elseif reason == "nogrow" then
                        msg = KV.tn("╨Р╨▓╤В╨╛-╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡ ╨╛╤Б╤В╨░╨╜╨╛╨▓╨╗╨╡╨╜╨╛: ╤Б╨╡╤А╨▓╨╡╤А ╨┐╤А╨╕╨╜╤П╨╗ ╨▓╤Л╨╖╨╛╨▓, ╨╜╨╛ ╨┐╨╕╤В╨╛╨╝╨╡╤Ж ╨╜╨╡ ╨┐╨╛╤П╨▓╨╕╨╗╤Б╤П ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡ (╨▓╨░╨╗╤О╤В╨░/╨╝╨╡╤Б╤В╨░ ╨╕╨╗╨╕ ╨▒╨╗╨╕╨╖╨╛╤Б╤В╤М ╨║ ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╤Г).",
                            "Auto hatch stopped: server accepted the call but no pet appeared (currency/slots or proximity to the crystal).")
                    elseif reason == "invokefail" then
                        msg = KV.tn("╨Р╨▓╤В╨╛-╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡ ╨╛╤Б╤В╨░╨╜╨╛╨▓╨╗╨╡╨╜╨╛: ╨╛╤И╨╕╨▒╨║╨░ ╨▓╤Л╨╖╨╛╨▓╨░ openCrystalRemote.",
                            "Auto hatch stopped: openCrystalRemote call failed.")
                    else
                        msg = KV.tn("╨Р╨▓╤В╨╛-╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡ ╨╛╤Б╤В╨░╨╜╨╛╨▓╨╗╨╡╨╜╨╛: ╤А╨╡╨╝╨╛╤Г╤В openCrystalRemote ╨╜╨╡ ╨╜╨░╨╣╨┤╨╡╨╜.",
                            "Auto hatch stopped: openCrystalRemote not found.")
                    end
                    KV.notify("Vortex Hatch", msg, 5)
                    break
                end
                if ok then nogrowStreak = 0 end
                task.wait(KV.Config.HatchDelay)
            end
            KV.refreshHatchStatus()
        end)
    end
end, function(body)
    -- ╨╜╨░╤Б╤В╤А╨╛╨╣╨║╨╕ ╨┐╤А╤П╨╝╨╛ ╨▓ popup: ╨╖╨░╨┤╨╡╤А╨╢╨║╨░ ╨╝╨╡╨╢╨┤╤Г ╨░╨▓╤В╨╛-╨╛╤В╨║╤А╤Л╤В╨╕╤П╨╝╨╕
    KV.createSlider(body, "╨Ч╨░╨┤╨╡╤А╨╢╨║╨░ ╨╝╨╡╨╢╨┤╤Г ╨╛╤В╨║╤А╤Л╤В╨╕╤П╨╝╨╕ (0.01 ╤Б╨╡╨║)", 5, 100, math.floor(KV.Config.HatchDelay * 100 + 0.5), function(v)
        KV.Config.HatchDelay = math.floor(v) / 100
    end, nil, "25 = 0.25 ╤Б╨╡╨║╤Г╨╜╨┤╤Л ╨╝╨╡╨╢╨┤╤Г ╨╛╤В╨║╤А╤Л╤В╨╕╤П╨╝╨╕ (╨┤╨╕╨░╨┐╨░╨╖╨╛╨╜ 0.05тАУ1.00; ╨╝╨╡╨╜╤М╤И╨╡ тАФ ╨╕╨│╤А╨░ ╨╝╨╛╨╢╨╡╤В ╨╜╨╡ ╤Г╤Б╨┐╨╡╨▓╨░╤В╤М)")
end)
KV.autoCrystalSync = acSet

KV.createButton(KV.automationPage, "MASS HATCH (╨╛╤В╨║╤А╤Л╤В╤М ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨╡ ╨║╨╛╨╗╨╕╤З╨╡╤Б╤В╨▓╨╛)", "╨С╤Л╤Б╤В╤А╨╛ ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╤В ╨┤╨╛ 500 ╤П╨╕╤Ж ╨┐╨╛╨┤╤А╤П╨┤ ╤Б ╨┐╤А╨╛╨▓╨╡╤А╨║╨╛╨╣ ╨╝╨╡╤Б╤В ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡ ╨╕ ╨▓╨░╨╗╤О╤В╤Л", function()
    KV.hatchBatch(KV.Config.HatchCount)
end)

KV.createButton(KV.automationPage, "Hatch x10", "╨С╤Л╤Б╤В╤А╨╛ ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╤В 10 ╤П╨╕╤Ж ╨┐╨╛╨┤╤А╤П╨┤", function()
    KV.hatchBatch(10)
end)

KV.createButton(KV.automationPage, "Hatch x1", "╨Ю╤В╨║╤А╤Л╨▓╨░╨╡╤В ╨╛╨┤╨╜╨╛ ╤П╨╣╤Ж╨╛", function()
    KV.hatchBatch(1)
end)

KV.createButton(KV.automationPage, "Stop Mass Hatch", "╨Ю╤Б╤В╨░╨╜╨░╨▓╨╗╨╕╨▓╨░╨╡╤В ╨╕╨┤╤Г╤Й╨╡╨╡ ╨╝╨░╤Б╤Б╨╛╨▓╨╛╨╡ ╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡", function()
    if KV.hatchState.running then
        KV.hatchState.cancel = true
        KV.notify("Vortex Hatch", KV.tn("╨Ю╤Б╤В╨░╨╜╨░╨▓╨╗╨╕╨▓╨░╨╡╨╝ ╨╝╨░╤Б╤Б╨╛╨▓╨╛╨╡ ╨▓╤Л╨╗╤Г╨┐╨╗╨╡╨╜╨╕╨╡...", "Stopping mass hatch..."), 2)
    else
        KV.notify("Vortex Hatch", KV.tn("╨б╨╡╨╣╤З╨░╤Б ╨╜╨╕╤З╨╡╨│╨╛ ╨╜╨╡ ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╤В╤Б╤П.", "Nothing is hatching right now."), 2)
    end
end)

KV.sectionLabel(KV.automationPage, "CRYSTAL SELECTOR (╨Т╨л╨С╨Ю╨а ╨Ъ╨а╨Ш╨б╨в╨Р╨Ы╨Ы╨Р)")

-- ╨Ъ╨░╤А╤В╨╛╤З╨║╨╕-╨║╤А╨╕╤Б╤В╨░╨╗╨╗╤Л: ╨Ы╨Ъ╨Ь = ╨▓╤Л╨▒╤А╨░╤В╤М (╨▒╨╡╨╖ popup), ╨▓╤Л╨▒╤А╨░╨╜╨╜╤Л╨╣ ╨┐╨╛╨┤╤Б╨▓╨╡╤З╨╡╨╜ ╨░╨║╤Ж╨╡╨╜╤В╨╛╨╝ + ╨│╨░╨╗╨╛╤З╨║╨░
KV.crystalCards = {}

KV.updateCrystalCards = function()
    for name, card in pairs(KV.crystalCards) do
        local sel = (name == KV.Config.SelectedCrystal)
        KV.tw(card.stroke, {
            Color = sel and KV.AccentColor or Color3.fromRGB(255, 255, 255),
            Transparency = sel and 0.35 or 0.94,
        }, 0.15):Play()
        KV.tw(card.nameLbl, {TextColor3 = sel and KV.AccentColor or Color3.fromRGB(241, 245, 249)}, 0.15):Play()
        KV.tw(card.checkLbl, {TextTransparency = sel and 0 or 1}, 0.15):Play()
    end
end

for _, crystalName in ipairs(KV.crystalCatalog) do
    local card = Instance.new("TextButton", KV.automationPage)
    card.Name = "CrystalCard_" .. crystalName
    card.BackgroundColor3 = KV.currentTheme().panel
    card.BackgroundTransparency = 0
    card.Size = UDim2.new(1, -10, 0, 42)
    card.AutoButtonColor = false
    card.Text = ""
    CollectionService:AddTag(card, "ThemePanel")
    KV.applyCorner(card, 10)
    local cardStroke = KV.applyStroke(card, Color3.fromRGB(255, 255, 255), 0.94, 1)

    card.MouseEnter:Connect(function()
        local base = KV.currentTheme().panel
        KV.tw(card, {BackgroundColor3 = Color3.new(
            math.min(1, base.R + 0.05), math.min(1, base.G + 0.05), math.min(1, base.B + 0.05)
        )}, 0.12):Play()
    end)
    card.MouseLeave:Connect(function()
        KV.tw(card, {BackgroundColor3 = KV.currentTheme().panel}, 0.15):Play()
    end)

    local nameLbl = Instance.new("TextLabel", card)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Position = UDim2.new(0, 14, 0.5, -8)
    nameLbl.Size = UDim2.new(1, -110, 0, 16)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Text = crystalName
    nameLbl.TextColor3 = Color3.fromRGB(241, 245, 249)
    nameLbl.TextSize = 11
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 2

    local priceLbl = Instance.new("TextLabel", card)
    priceLbl.BackgroundTransparency = 1
    priceLbl.AnchorPoint = Vector2.new(1, 0.5)
    priceLbl.Position = UDim2.new(1, -44, 0.5, 0)
    priceLbl.Size = UDim2.new(0, 90, 0, 14)
    priceLbl.Font = Enum.Font.Gotham
    priceLbl.Text = ""
    priceLbl.TextColor3 = Color3.fromRGB(148, 163, 184)
    priceLbl.TextSize = 9
    priceLbl.TextXAlignment = Enum.TextXAlignment.Right
    priceLbl.ZIndex = 2
    do
        local price, kind = KV.getCrystalPrice(crystalName)
        if price and price > 0 then
            priceLbl.Text = tostring(price) .. " " .. tostring(kind or "Gems")
        end
    end

    local checkLbl = Instance.new("TextLabel", card)
    checkLbl.BackgroundTransparency = 1
    checkLbl.AnchorPoint = Vector2.new(1, 0.5)
    checkLbl.Position = UDim2.new(1, -16, 0.5, 0)
    checkLbl.Size = UDim2.new(0, 18, 0, 18)
    checkLbl.Font = Enum.Font.GothamBold
    checkLbl.Text = "тЬУ"
    checkLbl.TextColor3 = KV.AccentColor
    checkLbl.TextSize = 14
    checkLbl.ZIndex = 2
    CollectionService:AddTag(checkLbl, "AccentText")
    checkLbl.TextTransparency = 1

    KV.bindTooltip(card, KV.t("╨Т╤Л╨▒╤А╨░╤В╤М ", "Select ") .. crystalName .. KV.t(" ╨┤╨╗╤П ╨╛╤В╨║╤А╤Л╤В╨╕╤П", " to open"))

    card.MouseButton1Click:Connect(function()
        KV.Config.SelectedCrystal = crystalName
        KV.refreshHatchStatus()
        KV.updateCrystalCards()
        KV.notify(KV.tn("╨Ъ╤А╨╕╤Б╤В╨░╨╗╨╗ ╨▓╤Л╨▒╤А╨░╨╜: ", "Crystal selected: ") .. crystalName, KV.tn("╨в╨╡╨┐╨╡╤А╤М ╨╡╨│╨╛ ╨╝╨╛╨╢╨╜╨╛ ╨╛╤В╨║╤А╤Л╨▓╨░╤В╤М ╨║╨╜╨╛╨┐╨║╨░╨╝╨╕ ╨╜╨╕╨╢╨╡.", "You can now open it with the buttons above."), 2)
    end)

    KV.crystalCards[crystalName] = {stroke = cardStroke, nameLbl = nameLbl, checkLbl = checkLbl}
end

KV.updateCrystalCards()
KV.refreshHatchStatus()

-- ============================================================
-- 9. ╨а╨Р╨Ч╨Ф╨Х╨Ы: PETS & INVENTORY
-- ============================================================
KV.sectionLabel(KV.petsPage, "PET MANAGEMENT ENGINE")
KV.createButton(KV.petsPage, "Auto Evolve All Pets", "╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╨╛╨▒╤К╨╡╨┤╨╕╨╜╤П╨╡╤В ╨╛╨┤╨╕╨╜╨░╨║╨╛╨▓╤Л╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╨┤╨╗╤П ╤Н╨▓╨╛╨╗╤О╤Ж╨╕╨╕", function()
    local ev = KV.getMuscleEvent()
    if ev then ev:FireServer("evolvePetAll") end
    KV.notify("Vortex Pets", "Evolution request sent!", 2)
end)

KV.createButton(KV.petsPage, "Equip Best Pets", "╨Р╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ ╨╜╨░╨┤╨╡╨▓╨░╨╡╤В ╨╗╤Г╤З╤И╨╕╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╨▓ ╨╕╨╜╨▓╨╡╨╜╤В╨░╤А╨╡", function()
    local ev = KV.getMuscleEvent()
    if ev then ev:FireServer("equipBestPets") end
    KV.notify("Vortex Pets", "Best pets equipped!", 2)
end)

KV.createButton(KV.petsPage, "╨Я╤А╨╛╨┤╨░╤В╤М ╨╛╨▒╤Л╤З╨╜╤Л╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓", "╨Я╤А╨╛╨┤╨░╤С╤В ╨▓╤Б╨╡╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╤А╨░╤А╨╕╤В╨╡╤В╨░ Common, ╨╛╤Б╨▓╨╛╨▒╨╛╨╢╨┤╨░╤П ╨╝╨╡╤Б╤В╨░ ╨┤╨╗╤П ╨║╤А╨╕╤Б╤В╨░╨╗╨╗╨╛╨▓", function()
    local ev = nil
    pcall(function() ev = KV.getREvent("sellPetEvent") end)
    if not ev then
        KV.notify("Vortex Pets", KV.tn("╨а╨╡╨╝╨╛╤Г╤В sellPetEvent ╨╜╨╡ ╨╜╨░╨╣╨┤╨╡╨╜.", "sellPetEvent remote not found."), 4)
        return
    end
    local pf = LocalPlayer:FindFirstChild("petsFolder")
    if not pf then
        KV.notify("Vortex Pets", KV.tn("╨Я╨░╨┐╨║╨░ ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╨╜╨╡ ╨╜╨░╨╣╨┤╨╡╨╜╨░.", "Pets folder not found."), 4)
        return
    end
    local toSell = {}
    for _, rarityFolder in pairs(pf:GetChildren()) do
        if string.lower(rarityFolder.Name) == "common" then
            for _, pet in ipairs(rarityFolder:GetChildren()) do
                table.insert(toSell, pet)
            end
        end
    end
    if #toSell == 0 then
        KV.notify("Vortex Pets", KV.tn("╨Ю╨▒╤Л╤З╨╜╤Л╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓ ╨╜╨╡╤В тАФ ╨┐╤А╨╛╨┤╨░╨▓╨░╤В╤М ╨╜╨╡╤З╨╡╨│╨╛.", "No common pets тАФ nothing to sell."), 3)
        return
    end
    local sold = 0
    for _, pet in ipairs(toSell) do
        local ok = pcall(function() ev:FireServer("sellPet", pet) end)
        if ok then sold = sold + 1 end
        task.wait(0.05)
    end
    KV.refreshHatchStatus()
    KV.notify("Vortex Pets", string.format(KV.tn("╨Я╤А╨╛╨┤╨░╨╜╨╛ ╨╛╨▒╤Л╤З╨╜╤Л╤Е ╨┐╨╕╤В╨╛╨╝╤Ж╨╡╨▓: %d", "Common pets sold: %d"), sold), 4)
end)

-- ============================================================
-- 10. ╨а╨Р╨Ч╨Ф╨Х╨Ы: MOVEMENT & ESP
-- ============================================================
KV.sectionLabel(KV.movementPage, "FLIGHT & SPEED ENGINE")
KV.createToggle(KV.movementPage, "Fly Mode (WASD + Shift/Space)", "╨а╨╡╨╢╨╕╨╝ ╤Б╨▓╨╛╨▒╨╛╨┤╨╜╨╛╨│╨╛ ╨┐╨╛╨╗╨╡╤В╨░ Vortex", KV.Config.FlyEnabled, function(v)
    KV.Config.FlyEnabled = v
    if v then KV.startFlight() else KV.stopFlight() end
end)
KV.createSlider(KV.movementPage, "Fly Speed", 20, 300, KV.Config.FlySpeed, function(v) KV.Config.FlySpeed = v end, nil, "╨б╨║╨╛╤А╨╛╤Б╤В╤М ╨┐╨╛╨╗╨╡╤В╨░ ╨▓ ╨▓╨╛╨╖╨┤╤Г╤Е╨╡")

KV.createToggle(KV.movementPage, "Speed Hack", "╨Ш╨╖╨╝╨╡╨╜╨╡╨╜╨╕╨╡ ╤Б╨║╨╛╤А╨╛╤Б╤В╨╕ ╤Е╨╛╨┤╤М╨▒╤Л", KV.Config.SpeedHack, function(v)
    KV.Config.SpeedHack = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
KV.createSlider(KV.movementPage, "WalkSpeed Value", 16, 300, KV.Config.SpeedValue, function(v)
    KV.Config.SpeedValue = v
    if KV.Config.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end, nil, "╨Ч╨╜╨░╤З╨╡╨╜╨╕╨╡ ╤Б╨║╨╛╤А╨╛╤Б╤В╨╕ ╤Е╨╛╨┤╤М╨▒╤Л")

KV.createToggle(KV.movementPage, "Jump Power Hack", "╨Ш╨╖╨╝╨╡╨╜╨╡╨╜╨╕╨╡ ╨▓╤Л╤Б╨╛╤В╤Л ╨┐╤А╤Л╨╢╨║╨░", KV.Config.JumpPowerHack, function(v)
    KV.Config.JumpPowerHack = v
end)
KV.createSlider(KV.movementPage, "Jump Power Value", 50, 450, KV.Config.JumpPowerValue, function(v)
    KV.Config.JumpPowerValue = v
    if KV.Config.JumpPowerHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
    end
end, nil, "╨б╨╕╨╗╨░ ╨▓╤Л╤Б╨╛╤В╤Л ╨┐╤А╤Л╨╢╨║╨░")

KV.createSlider(KV.movementPage, "Custom World Gravity", 0, 196, 196, function(v)
    KV.Config.GravityValue = v
    Workspace.Gravity = v
end, nil, "╨Э╨░╤Б╤В╤А╨╛╨╣╨║╨░ ╨│╤А╨░╨▓╨╕╤В╨░╤Ж╨╕╨╕ ╨╕╨│╤А╨╛╨▓╨╛╨│╨╛ ╨╝╨╕╤А╨░")

KV.createToggle(KV.movementPage, "Noclip", "╨Я╤А╨╛╤Е╨╛╨┤ ╤Б╨║╨▓╨╛╨╖╤М ╤Б╤В╨╡╨╜╤Л ╨╕ ╨╛╨▒╤К╨╡╨║╤В╤Л", KV.Config.Noclip, function(v) KV.Config.Noclip = v end)
KV.createToggle(KV.movementPage, "Infinite Jump", "╨С╨╡╤Б╨║╨╛╨╜╨╡╤З╨╜╤Л╨╡ ╨┐╤А╤Л╨╢╨║╨╕ ╨▓ ╨▓╨╛╨╖╨┤╤Г╤Е╨╡", KV.Config.InfJump, function(v) KV.Config.InfJump = v end)
KV.createToggle(KV.movementPage, "Bunny Hop", "╨Р╨▓╤В╨╛-╨┐╤А╤Л╨╢╨╛╨║ ╨┐╤А╨╕ ╨║╨░╤Б╨░╨╜╨╕╨╕ ╨╖╨╡╨╝╨╗╨╕", KV.Config.Bhop, function(v) KV.Config.Bhop = v end)

-- Movement Render Loop
KV.moveConn = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if KV.Config.Bhop and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            if KV.Config.SpeedHack then
                hum.WalkSpeed = KV.Config.SpeedValue
            end
            if KV.Config.JumpPowerHack then
                hum.JumpPower = KV.Config.JumpPowerValue
            end
        end
    end
end)
table.insert(KV.ScriptConnections, KV.moveConn)

KV.sectionLabel(KV.movementPage, "SPECTATE & VISUAL ESP")
KV.createToggle(KV.movementPage, "Spectate Target Player", "╨а╨╡╨╢╨╕╨╝ ╨╜╨░╨▒╨╗╤О╨┤╨╡╨╜╨╕╤П ╨╛╤В ╨┐╨╡╤А╨▓╨╛╨│╨╛/╤В╤А╨╡╤В╤М╨╡╨│╨╛ ╨╗╨╕╤Ж╨░ ╨╖╨░ ╨▓╤Л╨▒╤А╨░╨╜╨╜╨╛╨╣ ╤Ж╨╡╨╗╤М╤О", KV.Config.SpectateTarget, function(v)
    KV.Config.SpectateTarget = v
    if v and KV.Config.SelectedTargetPlayer and KV.Config.SelectedTargetPlayer.Character and KV.Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = KV.Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end)

KV.espDrawings = {} -- [Player] = Drawing.Text тАФ ╤Б╨╛╨╖╨┤╨░╨╡╤В╤Б╤П ╨╛╨┤╨╕╨╜ ╤А╨░╨╖ ╨╕ ╨┐╨╡╤А╨╡╨╕╤Б╨┐╨╛╨╗╤М╨╖╤Г╨╡╤В╤Б╤П

-- ╨Ю╨┐╤А╨╡╨┤╨╡╨╗╤П╨╡╤В╤Б╤П ╨║╨░╨║ ╨┐╤А╨╕╤Б╨▓╨░╨╕╨▓╨░╨╜╨╕╨╡: forward-╨┤╨╡╨║╨╗╨░╤А╨░╤Ж╨╕╤П ╨╡╤Б╤В╤М ╨▓ ╨╜╨░╤З╨░╨╗╨╡ ╤Б╨║╤А╨╕╨┐╤В╨░
-- (╨╜╤Г╨╢╨╜╨░ ╨▓╨╜╤Г╤В╤А╨╕ completeScriptUnload)
clearESP = function()
    for playerKey, drawing in pairs(KV.espDrawings) do
        if drawing then
            pcall(function() drawing.Visible = false end)
            pcall(function() drawing:Remove() end)
        end
        KV.espDrawings[playerKey] = nil
    end
end

KV.createToggle(KV.movementPage, "Player NameTags ESP", "╨Я╨╛╨║╨░╨╖╤Л╨▓╨░╨╡╤В ╨╕╨╝╨╡╨╜╨░ ╨╕ ╨┤╨╕╤Б╤В╨░╨╜╤Ж╨╕╤О ╨┤╨╛ ╨╕╨│╤А╨╛╨║╨╛╨▓", KV.Config.PlayerESP, function(v)
    KV.Config.PlayerESP = v
    if v then
        if Drawing == nil or type(Drawing.new) ~= "function" then
            KV.notify("Vortex ESP", "This injector does not support Drawing тАФ ESP unavailable", 4)
            KV.Config.PlayerESP = false
            return
        end
        task.spawn(function()
            while KV.Config.PlayerESP do
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local seen = {}

                if myHrp then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer then
                            local c = p.Character
                            local hrp = c and c:FindFirstChild("HumanoidRootPart")
                            local hum = c and c:FindFirstChildOfClass("Humanoid")
                            if hrp and hum and hum.Health > 0 then
                                seen[p] = true
                                local d = KV.espDrawings[p]
                                if not d then
                                    local ok, newDrawing = pcall(function()
                                        local obj = Drawing.new("Text")
                                        obj.Size = 14
                                        obj.Center = true
                                        obj.Outline = true
                                        return obj
                                    end)
                                    if ok and newDrawing then
                                        d = newDrawing
                                        KV.espDrawings[p] = d
                                    end
                                end
                                if d then
                                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                                    d.Text = p.Name .. " [" .. math.floor((hrp.Position - myHrp.Position).Magnitude) .. "m]"
                                    d.Position = Vector2.new(pos.X, pos.Y - 25)
                                    d.Color = KV.AccentColor
                                    d.Visible = onScreen
                                end
                            end
                        end
                    end
                end

                -- ╤З╨╕╤Б╤В╨╕╨╝ ╤А╨╕╤Б╤Г╨╜╨║╨╕ ╨╕╨│╤А╨╛╨║╨╛╨▓, ╨║╨╛╤В╨╛╤А╤Л╤Е ╨▒╨╛╨╗╤М╤И╨╡ ╨╜╨╡╤В ╨╜╨░ ╤Б╨╡╤А╨▓╨╡╤А╨╡ / ╨╛╨╜╨╕ ╨╝╨╡╤А╤В╨▓╤Л
                for p, d in pairs(KV.espDrawings) do
                    if not seen[p] then
                        pcall(function() d.Visible = false end)
                        pcall(function() d:Remove() end)
                        KV.espDrawings[p] = nil
                    end
                end

                task.wait(0.1)
            end
            clearESP()
        end)
    else
        clearESP()
    end
end)

KV.createToggle(KV.movementPage, "Full Bright", "╨г╨▒╨╕╤А╨░╨╡╤В ╤В╨╡╨╜╨╕ ╨╜╨░ ╨║╨░╤А╤В╨╡ ╨╕ ╨▓╨║╨╗╤О╤З╨░╨╡╤В ╨┤╨╡╨╜╤М", KV.Config.FullBright, function(v)
    KV.Config.FullBright = v
    if v then
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1; Lighting.ClockTime = 12; Lighting.GlobalShadows = true
    end
end)

KV.createSlider(KV.movementPage, "Camera FOV", 40, 120, KV.Config.CustomFOV, function(v)
    KV.Config.CustomFOV = v
    Camera.FieldOfView = v
end, nil, "╨г╨│╨╛╨╗ ╨╛╨▒╨╖╨╛╤А╨░ ╨║╨░╨╝╨╡╤А╤Л")

KV.sectionLabel(KV.movementPage, "SERVER UTILS")
KV.createButton(KV.movementPage, "Rejoin Same Server", "╨Я╨╡╤А╨╡╨╖╨░╨╣╤В╨╕ ╨╜╨░ ╤Н╤В╨╛╤В ╨╢╨╡ ╤Б╨╡╤А╨▓╨╡╤А", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

KV.createButton(KV.movementPage, "Server Hop (Random Server)", "╨Я╨╛╨┤╨║╨╗╤О╤З╨╕╤В╤М╤Б╤П ╨║ ╤Б╨╗╤Г╤З╨░╨╣╨╜╨╛╨╝╤Г ╤Б╨╡╤А╨▓╨╡╤А╤Г", function()
    KV.notify("Vortex Server", "Searching for server...", 2)
    pcall(function()
        local sfUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local req = HttpService:JSONDecode(game:HttpGet(sfUrl))
        if req and req.data then
            for _, s in pairs(req.data) do
                if s.playing ~= s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    end)
end)

KV.createButton(KV.movementPage, "Copy JobID to Clipboard", "╨Ъ╨╛╨┐╨╕╤А╤Г╨╡╤В ID ╤В╨╡╨║╤Г╤Й╨╡╨│╨╛ ╤Б╨╡╤А╨▓╨╡╤А╨░ ╨▓ ╨▒╤Г╤Д╨╡╤А ╨╛╨▒╨╝╨╡╨╜╨░", function()
    pcall(function() setclipboard(tostring(game.JobId)) end)
    KV.notify("Vortex Server", "JobID copied to clipboard!", 2)
end)

-- ============================================================
-- ╨а╨Р╨Ч╨Ф╨Х╨Ы: VISUALS (╨╜╨╡╨▒╨╛, ╤Б╨╗╨╡╨┤, ╤Н╤Д╤Д╨╡╨║╤В ╨┐╤А╤Л╨╢╨║╨░)
-- ============================================================
KV.sectionLabel(KV.visualsPage, "CUSTOM SKY")

KV.SKY_PRESETS = {
    {name = "Default", desc = function() return KV.t("╨б╤В╨░╨╜╨┤╨░╤А╤В╨╜╨╛╨╡ ╨┤╨╜╨╡╨▓╨╜╨╛╨╡ ╨╜╨╡╨▒╨╛", "Standard daylight sky") end,
        timeOfDay = "14:00:00", ambient = Color3.fromRGB(128,128,128), outdoor = Color3.fromRGB(150,150,150), fog = Color3.fromRGB(190,200,215), fogEnd = 100000},
    {name = "Night", desc = function() return KV.t("╨в╤С╨╝╨╜╨╛╨╡ ╨╜╨╛╤З╨╜╨╛╨╡ ╨╜╨╡╨▒╨╛", "Dark night sky") end,
        timeOfDay = "00:00:00", ambient = Color3.fromRGB(30,35,60), outdoor = Color3.fromRGB(40,45,80), fog = Color3.fromRGB(10,12,25), fogEnd = 60000},
    {name = "Sunset", desc = function() return KV.t("╨Ю╤А╨░╨╜╨╢╨╡╨▓╤Л╨╣ ╨╖╨░╨║╨░╤В", "Orange sunset") end,
        timeOfDay = "18:30:00", ambient = Color3.fromRGB(140,90,70), outdoor = Color3.fromRGB(200,120,80), fog = Color3.fromRGB(230,140,90), fogEnd = 80000},
    {name = "Neon", desc = function() return KV.t("╨Э╨╡╨╛╨╜╨╛╨▓╨╛-╤Д╨╕╨╛╨╗╨╡╤В╨╛╨▓╨░╤П ╨░╤В╨╝╨╛╤Б╤Д╨╡╤А╨░", "Neon purple atmosphere") end,
        timeOfDay = "20:00:00", ambient = Color3.fromRGB(70,40,110), outdoor = Color3.fromRGB(90,50,150), fog = Color3.fromRGB(60,30,90), fogEnd = 50000},
    {name = "Cosmic", desc = function() return KV.t("╨Ъ╨╛╤Б╨╝╨╕╤З╨╡╤Б╨║╨╕╨╣ ╨║╤А╨░╤Б╨╜╤Л╨╣", "Deep space red") end,
        timeOfDay = "02:00:00", ambient = Color3.fromRGB(80,25,35), outdoor = Color3.fromRGB(120,35,50), fog = Color3.fromRGB(50,10,20), fogEnd = 40000},
}

KV.applySkyPreset = function(preset)
    local ok = pcall(function()
        Lighting.TimeOfDay = preset.timeOfDay
        Lighting.Ambient = preset.ambient
        Lighting.OutdoorAmbient = preset.outdoor
        Lighting.FogColor = preset.fog
        Lighting.FogEnd = preset.fogEnd
        Lighting.FogStart = 0
    end)
    if ok then
        KV.Config.SkyMode = preset.name
        KV.notify("Vortex Visuals", "Sky preset: " .. preset.name, 2)
    end
end

for _, preset in ipairs(KV.SKY_PRESETS) do
    KV.createButton(KV.visualsPage, "Sky: " .. preset.name, preset.desc, function()
        KV.applySkyPreset(preset)
    end)
end

KV.sectionLabel(KV.visualsPage, "TRAIL BEHIND PLAYER")

KV.activeTrail = nil
KV.activeTrailAttachments = {}

KV.removeTrail = function()
    if KV.activeTrail then pcall(function() KV.activeTrail:Destroy() end) KV.activeTrail = nil end
    for _, a in ipairs(KV.activeTrailAttachments) do pcall(function() a:Destroy() end) end
    KV.activeTrailAttachments = {}
end

KV.createTrail = function(char)
    KV.removeTrail()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(0, 1.5, 0)
        a0.Parent = hrp
        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0, -1.5, 0)
        a1.Parent = hrp
        local trail = Instance.new("Trail")
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Color = ColorSequence.new(KV.AccentColor, Color3.fromRGB(255,255,255))
        trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1)})
        trail.Lifetime = tonumber(KV.Config.TrailLifetime) or 0.6
        trail.LightEmission = 0.6
        trail.FaceCamera = true
        trail.Parent = hrp
        KV.activeTrail = trail
        KV.activeTrailAttachments = {a0, a1}
    end)
end

KV.trailLoopConn = nil
KV.createToggle(KV.visualsPage, "Player Trail", "╨п╤А╨║╨╕╨╣ ╤Б╨╗╨╡╨┤ ╨╖╨░ ╨┐╨╡╤А╤Б╨╛╨╜╨░╨╢╨╡╨╝ (╤Ж╨▓╨╡╤В ╨░╨║╤Ж╨╡╨╜╤В╨░ ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░)", KV.Config.TrailEnabled, function(v)
    KV.Config.TrailEnabled = v
    if v then
        KV.createTrail(LocalPlayer.Character)
        if not KV.trailLoopConn then
            KV.trailLoopConn = task.spawn(function()
                while KV.Config.TrailEnabled do
                    task.wait(1)
                    if KV.Config.TrailEnabled and (not KV.activeTrail or not KV.activeTrail.Parent) then
                        KV.createTrail(LocalPlayer.Character)
                    end
                end
            end)
        end
    else
        KV.removeTrail()
    end
end)

KV.createSlider(KV.visualsPage, "Trail Length (sec)", 2, 20, math.floor((tonumber(KV.Config.TrailLifetime) or 0.6) * 10 + 0.5), function(v)
    KV.Config.TrailLifetime = v / 10
    if KV.activeTrail then KV.activeTrail.Lifetime = KV.Config.TrailLifetime end
end, nil, "╨Ф╨╗╨╕╨╜╨░ ╨╖╨░╤В╤Г╤Е╨░╨╜╨╕╤П ╤Б╨╗╨╡╨┤╨░ (0.2 - 2.0 ╤Б╨╡╨║╤Г╨╜╨┤╤Л)")

KV.sectionLabel(KV.visualsPage, "JUMP EFFECT")

KV.spawnJumpRing = function(pos)
    pcall(function()
        local ring = Instance.new("Part")
        ring.Shape = Enum.PartType.Cylinder
        ring.Size = Vector3.new(0.2, 2, 2)
        ring.CFrame = CFrame.new(pos + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, math.rad(90))
        ring.Anchored = true
        ring.CanCollide = false
        ring.CanQuery = false
        ring.CanTouch = false
        ring.Material = Enum.Material.Neon
        ring.Color = KV.AccentColor
        ring.Transparency = 0.25
        ring.Parent = Workspace
        KV.tw(ring, {Size = Vector3.new(0.2, 9, 9), Transparency = 1}, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
        game:GetService("Debris"):AddItem(ring, 0.5)
    end)
end

KV.bindJumpRing = function(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum:GetAttribute("VortexRingBound") then return end
    hum:SetAttribute("VortexRingBound", true)
    hum.StateChanged:Connect(function(_, newState)
        if KV.Config.JumpRing and newState == Enum.HumanoidStateType.Jumping then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then KV.spawnJumpRing(hrp.Position - Vector3.new(0, 2.5, 0)) end
        end
    end)
end

KV.jumpCharConn = nil
KV.createToggle(KV.visualsPage, "Jump Ring Effect", "╨Э╨╡╨╛╨╜╨╛╨▓╨╛╨╡ ╨║╨╛╨╗╤М╤Ж╨╛ ╨┐╨╛╨┤ ╨╜╨╛╨│╨░╨╝╨╕ ╨┐╤А╨╕ ╨║╨░╨╢╨┤╨╛╨╝ ╨┐╤А╤Л╨╢╨║╨╡", KV.Config.JumpRing, function(v)
    KV.Config.JumpRing = v
    if v then
        if LocalPlayer.Character then KV.bindJumpRing(LocalPlayer.Character) end
        if not KV.jumpCharConn then
            KV.jumpCharConn = LocalPlayer.CharacterAdded:Connect(KV.bindJumpRing)
        end
    else
        if KV.jumpCharConn then KV.jumpCharConn:Disconnect() KV.jumpCharConn = nil end
    end
end)

-- ============================================================
-- ╨а╨Р╨Ч╨Ф╨Х╨Ы: ABOUT (╨▓╨╗╨░╨┤╨╡╨╗╨╡╤Ж ╨╕ ╨┐╨╛╨┤╨┤╨╡╤А╨╢╨║╨░)
-- ============================================================
KV.sectionLabel(KV.aboutPage, "VORTEX SCRIPT")

KV.aboutPanel = KV.createGlassPanel(KV.aboutPage, 96)
KV.aboutText = Instance.new("TextLabel", KV.aboutPanel)
KV.aboutText.BackgroundTransparency = 1
KV.aboutText.Position = UDim2.new(0, 12, 0, 8)
KV.aboutText.Size = UDim2.new(1, -24, 1, -16)
KV.aboutText.Font = Enum.Font.GothamMedium
KV.aboutText.TextColor3 = Color3.fromRGB(241,245,249)
KV.aboutText.TextSize = 11
KV.aboutText.TextXAlignment = Enum.TextXAlignment.Left
KV.aboutText.TextYAlignment = Enum.TextYAlignment.Top
KV.aboutText.TextWrapped = true
KV.aboutText.Text = "Vortex v тАФ Muscle Legends Hub\nOwner: harin\nDiscord: harin\nMenu key: Right Shift"

KV.createButton(KV.aboutPage, "Owner: harin", "╨Т╨╗╨░╨┤╨╡╨╗╨╡╤Ж ╨╕ ╤А╨░╨╖╤А╨░╨▒╨╛╤В╤З╨╕╨║ ╤Б╨║╤А╨╕╨┐╤В╨░ Vortex", function()
    KV.notify("Vortex", "Owner: harin", 3)
end)

KV.createButton(KV.aboutPage, "Discord: harin", "╨Э╨░╨╢╨╝╨╕╤В╨╡, ╤З╤В╨╛╨▒╤Л ╤Б╨║╨╛╨┐╨╕╤А╨╛╨▓╨░╤В╤М Discord ╨▓╨╗╨░╨┤╨╡╨╗╤М╤Ж╨░ ╨▓ ╨▒╤Г╤Д╨╡╤А ╨╛╨▒╨╝╨╡╨╜╨░", function()
    local ok = pcall(function() setclipboard("harin") end)
    if ok then
        KV.notify("Vortex", "Discord copied to clipboard!", 3)
    else
        KV.notify("Vortex", "Discord: harin", 3)
    end
end)

-- ============================================================
-- ╨Ч╨Р╨У╨а╨г╨Ч╨Ъ╨Р, ╨Р╨Э╨Ш╨Ь╨Р╨ж╨Ш╨Ш ╨Ю╨в╨Ъ╨а╨л╨в╨Ш╨п/╨Ч╨Р╨Ъ╨а╨л╨в╨Ш╨п ╨Ь╨Х╨Э╨о ╨Ш ╨Ъ╨Ы╨Р╨Т╨Ш╨и╨Р (Right Shift)
-- ============================================================
KV.switchTab("ClickGUI")

KV.loadingDone = false

KV.openMenu = function()
    if guiVisible or isAnimating then return end
    isAnimating = true
    guiVisible = true
    KV.MainFrame.Position = UDim2.new(KV.menuTargetPos.X.Scale, KV.menuTargetPos.X.Offset, KV.menuTargetPos.Y.Scale, KV.menuTargetPos.Y.Offset + 24)
    KV.menuScale.Scale = 0.95
    KV.MainFrame.Visible = true
    KV.OpenBtn.Visible = false
    KV.tw(KV.MainFrame, {Position = KV.menuTargetPos}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
    local s = KV.tw(KV.menuScale, {Scale = 1}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    s:Play()
    s.Completed:Connect(function() isAnimating = false end)
    bootSet("[Vortex] menu OPEN тАФ marker will vanish in 2s")
    task.delay(2, bootDone)
end

KV.closeMenu = function()
    if not guiVisible or isAnimating then return end
    isAnimating = true
    guiVisible = false
    if KV.FuncPopupLayer.Visible then KV.closeFuncPopup() end
    KV.tw(KV.MainFrame, {Position = UDim2.new(KV.menuTargetPos.X.Scale, KV.menuTargetPos.X.Offset, KV.menuTargetPos.Y.Scale, KV.menuTargetPos.Y.Offset + 24)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
    local s = KV.tw(KV.menuScale, {Scale = 0.95}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    s:Play()
    s.Completed:Connect(function()
        KV.MainFrame.Visible = false
        KV.MainFrame.Position = KV.menuTargetPos
        KV.OpenBtn.Visible = true
        isAnimating = false
    end)
end

KV.toggleMenu = function()
    if not KV.loadingDone then return end
    if guiVisible then KV.closeMenu() else KV.openMenu() end
end

KV.CloseHeaderBtn.MouseButton1Click:Connect(KV.closeMenu)
KV.OpenBtn.MouseButton1Click:Connect(KV.toggleMenu)

KV.mainKeyConn = UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        KV.toggleMenu()
    end
end)
table.insert(KV.ScriptConnections, KV.mainKeyConn)

-- ╨н╨║╤А╨░╨╜ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕: ╨┐╤А╨╛╨│╤А╨╡╤Б╤Б-╨▒╨░╤А + ╤Б╤В╨░╤В╤Г╤Б╤Л, ╨╖╨░╤В╨╡╨╝ ╨┐╨╗╨░╨▓╨╜╤Л╨╣ ╨▓╤Е╨╛╨┤ ╨▓ ╨╝╨╡╨╜╤О
KV.playLoadingSequence = function()
    -- ╨╝╤П╨│╨║╨╕╨╣ ╨▓╤К╨╡╨╖╨┤ ╨║╨░╤А╤В╨╛╤З╨║╨╕ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕
    KV.LoadModal.GroupTransparency = 1
    KV.LoadModal.Position = UDim2.new(0, 18, 0, 6)
    KV.tw(KV.LoadModal, {GroupTransparency = 0}, 0.35, Enum.EasingStyle.Quint):Play()
    KV.tw(KV.LoadModal, {Position = UDim2.new(0, 18, 0, 18)}, 0.35, Enum.EasingStyle.Quint):Play()
    task.wait(0.3)

    local steps = {
        KV.t("╨Ш╨╜╨╕╤Ж╨╕╨░╨╗╨╕╨╖╨░╤Ж╨╕╤П ╤П╨┤╤А╨░...", "Initializing core..."),
        KV.t("╨Ч╨░╨│╤А╤Г╨╖╨║╨░ ╨╝╨╛╨┤╤Г╨╗╨╡╨╣...", "Loading modules..."),
        KV.t("╨Я╨╛╨┤╨│╨╛╤В╨╛╨▓╨║╨░ ╨╕╨╜╤В╨╡╤А╤Д╨╡╨╣╤Б╨░...", "Preparing interface..."),
        KV.t("╨У╨╛╤В╨╛╨▓╨╛! ╨Ю╤В╨║╤А╤Л╨▓╨░╨╡╨╝ ╨╝╨╡╨╜╤О...", "Ready! Opening menu..."),
    }
    local total = 2.4
    local startT = tick()
    while (tick() - startT) < total do
        local p = math.clamp((tick() - startT) / total, 0, 1)
        KV.LoadBarFill.Size = UDim2.new(p, 0, 1, 0)
        KV.LoadPercent.Text = math.floor(p * 100) .. "%"
        local idx = math.min(#steps, math.floor(p * (#steps - 1)) + 1)
        KV.LoadStatus.Text = steps[idx]
        task.wait(0.03)
    end
    KV.LoadBarFill.Size = UDim2.new(1, 0, 1, 0)
    KV.LoadPercent.Text = "100%"
    KV.LoadStatus.Text = steps[#steps]
    task.wait(0.45)

    -- ╨┐╨╗╨░╨▓╨╜╤Л╨╣ ╤Г╤Е╨╛╨┤ ╨║╨░╤А╤В╨╛╤З╨║╨╕ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕
    KV.tw(KV.LoadModal, {GroupTransparency = 1}, 0.3, Enum.EasingStyle.Quint):Play()
    KV.tw(KV.LoadModal, {Position = UDim2.new(0, 18, 0, -14)}, 0.3, Enum.EasingStyle.Quint):Play()
    task.wait(0.32)
    KV.LoadModal.Visible = false
    KV.loadingDone = true
    KV.openMenu()
    KV.OpenBtn.Visible = false
    KV.notify("Vortex ", KV.tn("╨Ч╨░╨│╤А╤Г╨╖╨║╨░ ╨╖╨░╨▓╨╡╤А╤И╨╡╨╜╨░! ╨Ь╨╡╨╜╤О: [Right Shift]",
        "Loaded! Menu: [Right Shift]"), 5)
end
task.spawn(function()
    local ok, err = pcall(KV.playLoadingSequence)
    if not ok then
        warn("[Vortex STAGE Z]: ╨╛╤И╨╕╨▒╨║╨░ ╨░╨╜╨╕╨╝╨░╤Ж╨╕╨╕ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕: " .. tostring(err))
        pcall(function()
            KV.LoadModal.Visible = false
            KV.loadingDone = true
            KV.openMenu()
        end)
        if not guiVisible then pcall(function() KV.OpenBtn.Visible = true end) end
    end
end)

-- ╨б╤В╤А╨░╤Е╨╛╨▓╨║╨░: ╨╡╤Б╨╗╨╕ ╨┐╨╛ ╨╗╤О╨▒╨╛╨╣ ╨┐╤А╨╕╤З╨╕╨╜╨╡ ╨╝╨╡╨╜╤О ╨╜╨╡ ╨╛╤В╨║╤А╤Л╨╗╨╛╤Б╤М ╨╖╨░ 8 ╤Б╨╡╨║╤Г╨╜╨┤ тАФ ╨╛╤В╨║╤А╤Л╨▓╨░╨╡╨╝ ╨┐╤А╨╕╨╜╤Г╨┤╨╕╤В╨╡╨╗╤М╨╜╨╛
task.delay(8, function()
    if not KV.loadingDone then
        warn("[Vortex STAGE Z]: ╤В╨░╨╣╨╝╨░╤Г╤В ╨╖╨░╨│╤А╤Г╨╖╨║╨╕ тАФ ╨┐╤А╨╕╨╜╤Г╨┤╨╕╤В╨╡╨╗╤М╨╜╨╛╨╡ ╨╛╤В╨║╤А╤Л╤В╨╕╨╡ ╨╝╨╡╨╜╤О")
        pcall(function()
            KV.LoadModal.Visible = false
            KV.loadingDone = true
            if not guiVisible then KV.openMenu() end
        end)
    end
    -- ╨д╨╕╨╜╨░╨╗╤М╨╜╨░╤П ╨┐╤А╨╛╨▓╨╡╤А╨║╨░: ╨╡╤Б╨╗╨╕ ╨╝╨╡╨╜╤О ╤В╨░╨║ ╨╕ ╨╜╨╡ ╨▓╨╕╨┤╨╜╨╛ тАФ ╤Е╨╛╤В╤П ╨▒╤Л ╨┐╨╛╨║╨░╨╢╨╡╨╝ ╨║╨╜╨╛╨┐╨║╤Г ╨╛╤В╨║╤А╤Л╤В╨╕╤П
    task.wait(0.5)
    pcall(function()
        if not (KV.MainFrame.Visible and guiVisible) and not KV.OpenBtn.Visible then
            warn("[Vortex STAGE Z]: ╨╝╨╡╨╜╤О ╨╜╨╡ ╨╛╤В╨╛╨▒╤А╨░╨╢╨░╨╡╤В╤Б╤П тАФ ╨┐╨╛╨║╨░╨╖╤Л╨▓╨░╤О ╨║╨╜╨╛╨┐╨║╤Г OpenBtn")
            KV.OpenBtn.Visible = true
        end
        if not (KV.MainFrame.Visible and guiVisible) then
            bootSet("[Vortex] FAILED: menu not visible (open F9, send log)", Color3.fromRGB(255,90,90))
        end
    end)
end)

print("[Vortex STAGE Z]: ╨Ч╨Р╨У╨а╨г╨Ч╨Ъ╨Р ╨Ч╨Р╨Т╨Х╨а╨и╨Х╨Э╨Р тАФ ╤Н╨║╤А╨░╨╜ ╨╖╨░╨│╤А╤Г╨╖╨║╨╕ ╨░╨╜╨╕╨╝╨╕╤А╨╛╨▓╨░╨╜, ╨╝╨╡╨╜╤О ╨╛╤В╨║╤А╨╛╨╡╤В╤Б╤П ╨░╨▓╤В╨╛╨╝╨░╤В╨╕╤З╨╡╤Б╨║╨╕ (╨╝╨╡╨╜╤О: RightShift)")
print("[Vortex Glass UI Engine v]: Muscle Legends Hub loaded successfully!")

end)

if not _guiOk then
    local msg = tostring(_guiErr)
    warn("[Vortex GUI BUILD ERROR]: " .. msg)
    print("[Vortex GUI BUILD ERROR]: " .. msg)
    bootSet("[Vortex] BUILD ERROR: " .. msg, Color3.fromRGB(255, 90, 90))
end


