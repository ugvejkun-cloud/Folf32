--[[
    ================================================================================
    Vortex 0.23 — MUSCLE LEGENDS MASTER HUB
    ================================================================================
    Название клиента: Vortex 0.23
    Открытие / Скрытие меню: Right Shift (r.shift) или кнопка Vortex на экране
    
    Особенности v0.23:
      - Стартовое приветственное окно: "Привет! Какой язык ты предпочитаешь?"
      - Двуязычный интерфейс (Русский / English) с модальным переключением
      - 10 Удобных разделов с индикаторами состояния [ВКЛ / ВЫКЛ]
      - Онлайн-авторизация (GitHub Whitelist integration)
      - Исправлен фарм камней (поворот лицом + CFrame.lookAt)
      - Исправлен вылуп яиц/кристаллов (авто-телепорт вплотную + мульти-Remote)
    ================================================================================
--]]

print("==================================================")
print("[Vortex 0.23]: SCRIPT EXECUTION STARTED!")
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
-- СИСТЕМА АВТОРИЗАЦИИ / WHITELIST (GITHUB AUTH)
-- ============================================================
local WHITELIST_URL = "https://raw.githubusercontent.com/ugvejkun-cloud/Folf32/main/whitelist.json"
local ENABLE_WHITELIST = true

-- Встроенный резервный список: работает даже когда GitHub недоступен (429/таймаут)
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
    print("[Vortex STAGE A]: авторизация игрока '" .. LocalPlayer.Name .. "'")

    -- До 3 попыток: raw.githubusercontent иногда отдает 429/таймаут
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
                        print("[Vortex STAGE B]: whitelist OK (попытка " .. attempt .. ")")
                        return true
                    end
                end
                print("[Vortex STAGE B]: ник '" .. LocalPlayer.Name .. "' НЕ найден в whitelist.json")
                return false -- список загружен, игрока в нем нет
            end
            warn("[Vortex Auth]: JSON некорректен (попытка " .. attempt .. ")")
        else
            warn("[Vortex Auth]: HttpGet whitelist не удался (попытка " .. attempt .. "): " .. tostring(response))
        end
        task.wait(0.5)
    end

    -- GitHub недоступен: проверяем по встроенному списку
    if nameAllowed(playerName) then
        print("[Vortex STAGE B]: доступ по встроенному резервному списку")
        return true
    end
    warn("[Vortex Auth]: не удалось загрузить whitelist.json (попыток: 3)")
    return false
end

if not checkPlayerWhitelist() then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Vortex Auth Error",
            Text = "Нет доступа! Ник: " .. LocalPlayer.Name,
            Duration = 10
        })
    end)
    -- ВИДИМЫЙ на экране отказ (инжекторы часто не показывают SetCore-уведомления)
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
    warn("[Vortex Auth]: Доступ запрещен для игрока " .. LocalPlayer.Name)
    return
end

print("[Vortex STAGE C]: whitelist пройден, создаю интерфейс...")

-- Защита от повторного запуска Vortex
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

-- Хранилище подключений для полной выгрузки (Unload)
local ScriptConnections = {}
-- Forward-декларация: определяется позже в секции ESP, но нужна в completeScriptUnload
local clearESP

-- ============================================================
-- ГЛОБАЛЬНЫЙ КОНФИГ Vortex 0.23
-- ============================================================
local Config = {
    -- Язык по умолчанию
    Language          = "RU", -- "RU" или "EN"

    -- Glass UI Настройки
    Glow              = true,
    BgOpacity         = 25,
    GlassIntensity    = 75,
    EnableTooltips    = true,
    GuiScale          = 1,      -- масштаб окна GUI (0.7 - 1.5)

    -- Визуальные эффекты (Visuals)
    SkyMode           = "Default", -- Default / Night / Sunset / Neon / Cosmic
    TrailEnabled      = false,
    TrailLifetime     = 0.6,    -- длина следа за персонажем (сек)
    JumpRing          = false,  -- круг под ногами при прыжке

    -- Тренировки
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

    -- Тренажеры игры (Machine Farm)
    AutoBenchPress       = false,
    AutoSquat            = false,
    AutoTreadmillMachine = false,
    AutoPullups          = false,
    AutoBoulder          = false,
    AutoRockMachine      = false,

    -- Камни и Тренажеры
    AutoRock          = false,
    SelectedRockTier  = "Any",
    RockOffset        = 3,
    AutoTreadmill     = false,

    -- Бой & Kill Aura
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

    -- Защита
    AntiHit           = false,
    AntiRagdoll       = false,
    AntiKnockback     = false,
    AutoSafeTPLowHP   = false,
    AntiAFK           = true,

    -- Фарминг & Автоматизация
    AutoRebirth       = false,
    StayAfterRebirth  = true,   -- после ребирта возвращаться на исходную точку (не спавн)
    AutoChest         = false,
    AutoCrystal       = false,
    SelectedCrystal   = "Blue Crystal",
    HatchCount        = 50,     -- сколько яиц открывать за один Mass Hatch (1..500)
    HatchDelay        = 0.12,   -- задержка между открытиями яиц (сек)
    HatchPower        = false,  -- флаг живости массового вылупления (гасится при Unload)
    AutoCollectOrbs   = false,

    -- Тема окна (сначала — сплошной чёрный)
    ThemeIndex        = 1,

    -- Питомцы
    AutoEvolvePets    = false,
    AutoEquipBest     = false,

    -- Полет & Движение
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

    -- Визуал & Спектейт
    PlayerESP         = false,
    FullBright        = false,
    ShowOnScreenHUD   = true,
    CustomFOV         = 70,
    SpectateTarget    = false,

    -- Размер Персонажа
    PlayerScale       = 1,
    
    -- Точки сохранения
    SavedWaypoint     = nil
}

-- Вспомогательная функция локализации (Локализация текста RU / EN)
local function t(ruText, enText)
    if Config.Language == "EN" then
        return enText or ruText
    end
    return ruText
end

-- Текст для HUD/тостов: ВСЕГДА английский, независимо от языка интерфейса
local function tn(ruText, enText)
    return enText or ruText
end

-- ============================================================
-- ЖИВАЯ ЛОКАЛИЗАЦИЯ UI: словарь RU -> EN + ре-применение
-- ============================================================
local LangDict = {
    ["Переключает язык интерфейса между Русским и English"] = "Switches the interface language between Russian and English",
    ["Красный цвет интерфейса"] = "Interface red color",
    ["Зеленый цвет интерфейса"] = "Interface green color",
    ["Синий цвет интерфейса"] = "Interface blue color",
    ["Пульсирующая неоновая рамка меню"] = "Pulsing neon menu frame",
    ["Интенсивность размытия стекла"] = "Glass blur intensity",
    ["Отображение описания функций внизу экрана"] = "Show feature descriptions at the bottom of the screen",
    ["Удаляет текстуры карты для увеличения FPS"] = "Removes map textures to boost FPS",
    ["Полная выгрузка скрипта Vortex 0.23 и очистка памяти"] = "Fully unload Vortex 0.23 and free memory",
    ["Делает персонажа незаметным мини-карликом"] = "Makes your character a tiny unnoticed dwarf",
    ["Стандартный человеческий размер"] = "Standard human size",
    ["Большой накачанный персонаж"] = "Big muscular character",
    ["Огромный титан на всю карту"] = "Huge titan across the whole map",
    ["Колоссальный гигант"] = "Colossal giant",
    ["Точная настройка масштаба персонажа (1x - 30x)"] = "Fine-tune character scale (1x - 30x)",
    ["Auto OP (Универсальный сумасшедший кликер)"] = "Auto OP (Universal Crazy Clicker)",
    ["Сели за ЛЮБОЙ тренажер или взяли ЛЮБОЙ снаряд — мгновенно качает на предельной турбо-скорости!"] = "Sit on ANY machine or grab ANY equipment — instantly trains at max turbo speed!",
    ["Авто-фарм Силы через Гантели"] = "Auto farm Strength with Dumbbells",
    ["Авто-фарм Силы через Отжимания"] = "Auto farm Strength with Pushups",
    ["Авто-фарм Силы через Пресс"] = "Auto farm Strength with Situps",
    ["Авто-фарм Силы через Штангу"] = "Auto farm Strength with Barbell",
    ["Авто-удары по груше/воздуху для прокачки"] = "Auto punches on the bag/air for training",
    ["Автоматически чередует все снаряды для максимальной прокачки"] = "Automatically cycles all equipment for maximum training",
    ["Walk While Training (Ходить во время упражнения)"] = "Walk While Training (Move During Exercise)",
    ["Позволяет свободно ходить со штангой, гантелями или во время выполнения упражнений!"] = "Allows you to walk freely with a barbell, dumbbells or during exercises!",
    ["GYM MACHINES AUTO-FARM (БЛИЖАЙШИЙ ТРЕНАЖЕР)"] = "GYM MACHINES AUTO-FARM (NEAREST MACHINE)",
    ["Auto Bench Press (Жим лежа)"] = "Auto Bench Press",
    ["Садится на ближайший жим лежа 1 раз и качает грудь!"] = "Sits on the nearest bench press once and trains chest!",
    ["Auto Squat Rack (Приседания)"] = "Auto Squat Rack (Squats)",
    ["Садится на ближайшую стойку приседаний 1 раз и качает ноги!"] = "Sits on the nearest squat rack once and trains legs!",
    ["Auto Treadmill (Беговая дорожка)"] = "Auto Treadmill (Running Track)",
    ["Встает на ближайшую беговую дорожку 1 раз и качает ловкость!"] = "Steps on the nearest treadmill once and trains agility!",
    ["Auto Pull-ups (Подтягивания)"] = "Auto Pull-ups",
    ["Встает к ближайшему турнику 1 раз и подтягивается!"] = "Moves to the nearest pull-up bar once and does pull-ups!",
    ["Auto Boulder Throw (Бросок валуна)"] = "Auto Boulder Throw",
    ["Подходит к валуну 1 раз и качает броски!"] = "Approaches the boulder once and trains throwing!",
    ["Auto Rock Farm (Камень)"] = "Auto Rock Farm (Rock)",
    ["Телепортируется к ближайшему камню 1 раз и непрерывно бьет!"] = "Teleports to the nearest rock once and hits it continuously!",
    ["Ультра-скоростной режим: мгновенный спам ивентов качания без задержки!"] = "Ultra-fast mode: instant training event spam with no delay!",
    ["Ускоритель фарма: количество отправляемых пакетов качания за один раз (до 100x)"] = "Farm booster: number of training packets sent per tick (up to 100x)",
    ["Задержка между повторами (0 = мгновенно)"] = "Delay between reps (0 = instant)",
    ["Телепортируется к камню 1 раз и непрерывно бьет!"] = "Teleports to the rock once and hits it continuously!",
    ["Телепортируется на беговую дорожку 1 раз и качает ловкость!"] = "Teleports to the treadmill once and trains agility!",
    ["SELECT ROCK TIER (ТОЧНЫЕ ТРЕБОВАНИЯ)"] = "SELECT ROCK TIER (EXACT REQUIREMENTS)",
    ["Mode 1: Bring Target To Me (Телепортировать врага к себе)"] = "Mode 1: Bring Target To Me (Teleport Enemy To You)",
    ["Притягивает/телепортирует корпус врага прямо перед вашими кулаками и бьет!"] = "Pulls/teleports the enemy body right in front of your fists and hits!",
    ["Mode 2: Magnet TP To Target (Телепортироваться к врагу)"] = "Mode 2: Magnet TP To Target (Teleport To Enemy)",
    ["Мгновенно телепортирует вас за спину / в лицо врагу и наносит удары"] = "Instantly teleports you behind/in front of the enemy and strikes",
    ["Mode 3: Orbit Target (Орбита вокруг цели)"] = "Mode 3: Orbit Target (Circle Around Target)",
    ["Вращается по кругу вокруг цели и наносит серии ударов"] = "Orbits around the target and lands hit combos",
    ["Активирует Kill Aura: бьет, телепортирует врагов прямо к вам или телепортируется к ним!"] = "Activates Kill Aura: hits, teleports enemies to you or you to them!",
    ["Радиус в студах для обнаружения и телепортации врагов"] = "Radius in studs for detecting and teleporting enemies",
    ["Задержка ударов в миллисекундах"] = "Strike delay in milliseconds",
    ["Количество отправляемых пакетов ударов за итерацию"] = "Number of hit packets sent per iteration",
    ["Выбирает ближайшего к вам игрока в качестве цели"] = "Selects the nearest player to you as a target",
    ["Притягивает выбранного игрока прямо к вашим кулакам"] = "Pulls the selected player right to your fists",
    ["Непрерывно бьет и телепортирует выбранного игрока"] = "Continuously hits and teleports the selected player",
    ["Зацикленный авто-телепорт по всем игрокам сервера и их уничтожение"] = "Looped auto-teleport across all server players and their elimination",
    ["Авто-вход на Brawl турниры сервера и немедленная победа"] = "Auto-joins server Brawl tournaments and wins instantly",
    ["Авто-фарм Босса: позиция у босса + без урона по вам + быстрая атака!"] = "Auto boss farm: positioned at the boss + no damage to you + fast attacks!",
    ["Количество ударов по боссу за один цикл"] = "Number of hits on the boss per cycle",
    ["Отключает коллизии урона персонажа (защита от чужих ударов)"] = "Disables damage collisions for your character (protection from enemy hits)",
    ["Автоматически телепортирует в небесную зону безопасности при падении HP ниже 25%"] = "Automatically teleports to the sky safe zone when HP drops below 25%",
    ["Запрет падений и станов"] = "Prevents ragdoll and stuns",
    ["Отключает отбрасывание при ударах"] = "Disables knockback from hits",
    ["Спавнит небесную платформу и телепортирует вас туда"] = "Spawns a sky platform and teleports you there",
    ["Сохраняет вашу текущую позицию в память"] = "Saves your current position to memory",
    ["Телепортирует на ранее сохраненную точку"] = "Teleports to the previously saved point",
    ["Телепортирует к игроку с максимальной силой на сервере"] = "Teleports to the strongest player on the server",
    ["Auto Rebirth (Бесконечный авто-ребирт)"] = "Auto Rebirth (Infinite Auto-Rebirth)",
    ["Автоматически выполняет перерождение сразу при достижении нужного количества силы"] = "Automatically rebirths as soon as the required strength is reached",
    ["Manual Rebirth (Переродиться прямо сейчас)"] = "Manual Rebirth (Rebirth Right Now)",
    ["Принудительно запрашивает перерождение на сервере через все каналы"] = "Forcefully requests a rebirth on the server via all channels",
    ["Авто-телепорт по всем сундукам карты и их сбор"] = "Auto-teleports to all map chests and collects them",
    ["Автоматически притягивает/собирает сферы со всей карты"] = "Automatically attracts/collects orbs from across the map",
    ["Авто-открытие кристалла с питомцами (авто-телепорт вплотную)"] = "Auto-opens pet crystals (auto-teleport up close)",
    ["Автоматически объединяет одинаковых питомцев для эволюции"] = "Automatically merges identical pets for evolution",
    ["Автоматически надевает лучших питомцев в инвентаре"] = "Automatically equips the best pets in your inventory",
    ["Режим свободного полета Vortex"] = "Vortex free flight mode",
    ["Скорость полета в воздухе"] = "Flight speed in the air",
    ["Изменение скорости ходьбы"] = "Change walk speed",
    ["Значение скорости ходьбы"] = "Walk speed value",
    ["Изменение высоты прыжка"] = "Change jump height",
    ["Сила высоты прыжка"] = "Jump power value",
    ["Настройка гравитации игрового мира"] = "Game world gravity setting",
    ["Проход сквозь стены и объекты"] = "Walk through walls and objects",
    ["Бесконечные прыжки в воздухе"] = "Infinite jumps in the air",
    ["Авто-прыжок при касании земли"] = "Auto-jump when touching the ground",
    ["Режим наблюдения от первого/третьего лица за выбранной целью"] = "First/third person spectate mode for the selected target",
    ["Показывает имена и дистанцию до игроков"] = "Shows names and distance to players",
    ["Убирает тени на карте и включает день"] = "Removes map shadows and sets daytime",
    ["Угол обзора камеры"] = "Camera field of view",
    ["Перезайти на этот же сервер"] = "Rejoin this same server",
    ["Подключиться к случайному серверу"] = "Connect to a random server",
    ["Копирует ID текущего сервера в буфер обмена"] = "Copies the current server ID to clipboard",
    ["Switch Theme (Сменить Тему)"] = "Switch Theme",
    ["Stay In Place After Rebirth (Не телепортовать на спавн)"] = "Stay In Place After Rebirth",
    ["Сохраняет вашу позицию до перерождения и возвращает вас обратно после него"] = "Saves your position before rebirth and returns you there after it",
    ["MASS EGG HATCHER (ДО 500 ЗА РАЗ)"] = "MASS EGG HATCHER (UP TO 500 AT ONCE)",
    ["Eggs Per Batch (1-500)"] = "Eggs Per Batch (1-500)",
    ["Сколько яиц открывать за один Mass Hatch (максимум 500)"] = "How many eggs to open per Mass Hatch (max 500)",
    ["Авто-открытие выбранного кристалла пока включено (остановка при отказе сервера)"] = "Auto-opens the selected crystal while enabled (stops on server denial)",
    ["MASS HATCH (открыть выбранное количество)"] = "MASS HATCH (open selected amount)",
    ["Быстро открывает до 500 яиц подряд с проверкой мест в инвентаре и валюты"] = "Quickly opens up to 500 eggs in a row, checking inventory slots and currency",
    ["Hatch x10"] = "Hatch x10",
    ["Быстро открывает 10 яиц подряд"] = "Quickly opens 10 eggs in a row",
    ["Hatch x1"] = "Hatch x1",
    ["Открывает одно яйцо"] = "Opens one egg",
    ["Stop Mass Hatch"] = "Stop Mass Hatch",
    ["Останавливает идущее массовое вылупление"] = "Stops the running mass hatch",
    ["CRYSTAL SELECTOR (ВЫБОР ЯЙЦА)"] = "CRYSTAL SELECTOR",
    ["Встает на ближайшую беговую дорожку и качает ловкость!"] = "Steps onto the nearest treadmill and trains agility!",
    ["Активирует Kill Aura: бьет, телепортирует врагов прямо к вам или телепортируется к ним!"] = "Enables Kill Aura: hits enemies, dashes to them or pulls them into your fists!",
    ["Настройки, язык и темы интерфейса"] = "Settings, language and UI themes",
    ["Обзор статистики и прогресса"] = "Stats and progress overview",
    ["Тренажёры и авто-фарм"] = "Gym machines and auto farm",
    ["Камни и спортзалы"] = "Rocks and gyms",
    ["Kill Aura и охота на боссов"] = "Kill Aura and boss hunting",
    ["Защита и безопасность"] = "Protection and safety",
    ["Точки и телепорты"] = "Waypoints and teleports",
    ["Яйца и авто-действия"] = "Eggs and auto actions",
    ["Питомцы и инвентарь"] = "Pets and inventory",
    ["Движение и ESP"] = "Movement and ESP",
    ["Инициализация ядра..."] = "Initializing core...",
    ["Загрузка модулей..."] = "Loading modules...",
    ["Подготовка интерфейса..."] = "Preparing interface...",
    ["Готово! Открываем меню..."] = "Ready! Opening menu...",
    ["Загрузка завершена! Меню: [Right Shift]"] = "Loaded! Menu: [Right Shift]",
    -- Короткие названия вкладок (без иконок)
    ["Настройки"] = "Settings",
    ["Главная"] = "Home",
    ["Фарм"] = "Farm",
    ["Камни"] = "Rocks",
    ["Бой"] = "Combat",
    ["Защита"] = "Protection",
    ["Телепорты"] = "Teleports",
    ["Авто"] = "Auto",
    ["Питомцы"] = "Pets",
    ["Движение"] = "Movement",
    ["Защита от урона и авто-TP"] = "Damage protection and auto TP",
    ["Кристаллы и авто-действия"] = "Crystals and auto actions",
    ["Загрузка..."] = "Loading...",
    ["CRYSTAL SELECTOR (ВЫБОР КРИСТАЛЛА)"] = "CRYSTAL SELECTOR (PICK A CRYSTAL)",
    ["Продать обычных питомцев"] = "Sell Common Pets",
    ["Продаёт всех питомцев раритета Common, освобождая места для кристаллов"] = "Sells all Common-rarity pets to free up slots for crystals",
    ["Задержка между открытиями (0.01 сек)"] = "Open delay (0.01 sec)",
    ["12 = 0.12 секунды между открытиями (диапазон 0.05–1.00)"] = "12 = 0.12 seconds between openings (range 0.05–1.00)",
    ["Сохраняет все настройки Vortex в буфер обмена"] = "Saves all Vortex settings to the clipboard",
    ["Загружает настройки Vortex из буфера обмена"] = "Loads Vortex settings from the clipboard",
    ["Яркий след за персонажем (цвет акцента интерфейса)"] = "Bright trail behind your character (interface accent color)",
    ["Длина затухания следа (0.2 - 2.0 секунды)"] = "Trail fade length (0.2 - 2.0 seconds)",
    ["Неоновое кольцо под ногами при каждом прыжке"] = "Neon ring under your feet on every jump",
    ["Владелец и разработчик скрипта Vortex"] = "Owner and developer of the Vortex script",
    ["Нажмите, чтобы скопировать Discord владельца в буфер обмена"] = "Click to copy the owner's Discord to clipboard",
}

local TextBindings = {}

-- value: строка ИЛИ функция, возвращающая строку (для динамических надписей)
local function resolveText(value)
    if type(value) == "function" then
        local ok, res = pcall(value)
        value = (ok and res) or ""
    end
    if Config.Language == "EN" and type(value) == "string" then
        local en = LangDict[value]
        if en then return en end
    end
    return value
end

-- Регистрирует TextLabel/TextButton для живого обновления при смене языка
local function bindText(inst, getter)
    table.insert(TextBindings, {inst = inst, get = getter})
    pcall(function() inst.Text = getter() end)
end

local function applyLanguage()
    for _, binding in ipairs(TextBindings) do
        local inst = binding.inst
        if inst and inst.Parent then
            local ok, txt = pcall(binding.get)
            if ok then inst.Text = txt end
        end
    end
end

local AccentColor = Color3.fromRGB(201, 180, 255) -- лаванда — как на референсе Silicate

local AccentPresets = {
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

-- Темы окна: единый near-black фон (окно = сайдбар = шапка), карточки чуть светлее.
local UIThemes = {
    {name = "Black",     window = Color3.fromRGB(11, 11, 13),    panel = Color3.fromRGB(24, 24, 27),    bar = Color3.fromRGB(11, 11, 13),    side = Color3.fromRGB(11, 11, 13),    accent = Color3.fromRGB(201, 180, 255)},
    {name = "Slate",     window = Color3.fromRGB(15, 17, 20),    panel = Color3.fromRGB(27, 30, 35),    bar = Color3.fromRGB(15, 17, 20),    side = Color3.fromRGB(15, 17, 20),    accent = Color3.fromRGB(148, 163, 184)},
    {name = "Midnight",  window = Color3.fromRGB(10, 12, 20),    panel = Color3.fromRGB(20, 24, 38),    bar = Color3.fromRGB(10, 12, 20),    side = Color3.fromRGB(10, 12, 20),    accent = Color3.fromRGB(96, 165, 250)},
    {name = "Crimson",   window = Color3.fromRGB(17, 11, 12),    panel = Color3.fromRGB(30, 19, 20),    bar = Color3.fromRGB(17, 11, 12),    side = Color3.fromRGB(17, 11, 12),    accent = Color3.fromRGB(248, 113, 113)},
    {name = "Cyberpunk", window = Color3.fromRGB(8, 11, 14),     panel = Color3.fromRGB(18, 24, 27),    bar = Color3.fromRGB(8, 11, 14),     side = Color3.fromRGB(8, 11, 14),     accent = Color3.fromRGB(45, 212, 191)},
}

local function currentTheme()
    return UIThemes[Config.ThemeIndex] or UIThemes[1]
end

local rockTiers = {
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

local crystalsList = {
    "Blue Crystal", "Green Crystal", "Frost Crystal", "Mythic Crystal", "Infernal Crystal", "Galaxy Crystal"
}

-- ============================================================
-- УТИЛИТЫ И ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ Vortex
-- ============================================================
local function round(n) return math.floor(n + 0.5) end

local function applyCorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = inst
    return c
end

local function applyStroke(inst, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255,255,255)
    s.Transparency = transparency or 0.9
    s.Thickness = thickness or 1
    s.Parent = inst
    return s
end

local function tw(inst, props, dur, style, direction)
    return TweenService:Create(inst, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props)
end

local function notify(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Vortex 0.23",
            Text = message or "",
            Duration = duration or 4
        })
    end)
end

-- Игровая модель и ивенты Muscle Legends
local function getMuscleEvent()
    return LocalPlayer:FindFirstChild("muscleEvent") or ReplicatedStorage:FindFirstChild("muscleEvent")
end

-- Ленивый доступ к ремоутам папки ReplicatedStorage.rEvents
local function getREvent(name)
    local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
    if not rEvents then return nil end
    local r = rEvents:FindFirstChild(name)
    if r then return r end
    r = rEvents:WaitForChild(name, 5)
    return r
end

-- Модуль GlobalFunctions игры (проверка требований тренажёров и т.п.)
local _globalFunctions = nil
local function getGlobalFunctions()
    if _globalFunctions ~= nil then return _globalFunctions or nil end
    local ok, mod = pcall(function()
        local shared = ReplicatedStorage:WaitForChild("shared", 5)
        local modules = shared and shared:WaitForChild("modules", 5)
        return require(modules.GlobalFunctions)
    end)
    _globalFunctions = ok and mod or false
    return _globalFunctions or nil
end

-- Текущий занятый тренажёр (значение Value у LocalPlayer.machineInUse)
local function getMachineInUse()
    local v = LocalPlayer:FindFirstChild("machineInUse")
    if v then return v.Value end
    return nil
end

local function leaveMachine()
    pcall(function()
        local remote = getREvent("machineInteractRemote")
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
-- ИНВЕНТАРЬ ПИТОМЦЕВ: количество, вместимость, свободные места
-- ============================================================
local CAPACITY_SEARCH_NAMES = {
    "ItemCapacity", "itemCapacity", "Capacity", "capacity",
    "MaxItems", "maxItems", "PetCapacity", "petCapacity",
    "MaxPets", "maxPets", "StorageSize", "storageSize",
}

local function countOwnedPets()
    local n = 0
    local pf = LocalPlayer:FindFirstChild("petsFolder")
    if pf then
        for _, rarityFolder in pairs(pf:GetChildren()) do
            n = n + #rarityFolder:GetChildren()
        end
    end
    return n
end

local function detectItemCapacity()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    for _, name in ipairs(CAPACITY_SEARCH_NAMES) do
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
    -- Проба Data-модуля игры (ReplicatorClient), как в open-source скрипте
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

-- free, owned, capacity (capacity/free = nil, если вместимость найти не удалось)
local function freePetSlots()
    local owned = countOwnedPets()
    local cap = detectItemCapacity()
    if cap then
        return math.max(0, cap - owned), owned, cap
    end
    return nil, owned, nil
end

-- Баланс валюты: "Gems" (по умолчанию) или "Tokens"
local function getCurrency(kind)
    local name = (kind == "Tokens") and "Tokens" or "Gems"
    local v = LocalPlayer:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    v = ls and ls:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return tonumber(v.Value) or 0 end
    return nil
end

-- ============================================================
-- ПОИСК И НАДЕЖНЫЙ ФАРМ КАМНЯ (Rock Farming Engine)
-- ============================================================
local function getTargetRockPart(tierKeyword)
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
-- НАДЕЖНОЕ ОТКРЫТИЕ КРИСТАЛЛОВ / ЯИЦ
-- ============================================================
local function teleportToCrystal(crystalName)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myHrp = char.HumanoidRootPart

    local crystalObj = nil
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v:IsA("Model") or v:IsA("BasePart")) and (string.find(string.lower(v.Name), string.lower(crystalName)) or v.Name == crystalName) then
            crystalObj = v:IsA("BasePart") and v or (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))
            if crystalObj then break end
        end
    end

    if crystalObj then
        pcall(function()
            myHrp.CFrame = crystalObj.CFrame * CFrame.new(0, 2, 3)
        end)
    end
end

-- Одно открытие кристалла (дистанционно, без телепорта — как в open-source).
-- Возвращает:
--   true,  petName, rarity  — выпал питомец
--   false, "denied"         — сервер отказал (инвентарь полон / не хватает валюты)
--   false, "invokefail"     — вызов ремоута упал
--   false, "noremote"       — ремоут openCrystalRemote не найден
local function openCrystalOnce(crystalName)
    local remote = nil
    pcall(function()
        remote = getREvent("openCrystalRemote")
    end)
    if remote and remote:IsA("RemoteFunction") then
        local ok, a, b = pcall(function()
            return remote:InvokeServer("openCrystal", crystalName)
        end)
        if ok then
            -- Толерантная расшифровка ответа: (pet, rarity) | (true, pet) | таблица | Instance
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
            if petName then return true, tostring(petName), rarity end
            return false, "denied"
        end
        return false, "invokefail"
    end

    -- Фолбэк: muscleEvent (старая схема, только если ремоута нет вовсе)
    local ev = getMuscleEvent()
    if ev then
        pcall(function() ev:FireServer("openCrystal", crystalName) end)
        pcall(function() ev:FireServer("crys", crystalName) end)
        pcall(function() ev:FireServer("openEgg", crystalName) end)
        return true, nil, nil
    end
    return false, "noremote"
end

local function hatchCrystal(crystalName)
    -- Открытие строго дистанционно — телепорт не используется
    return openCrystalOnce(crystalName)
end

-- ============================================================
-- УМНЫЙ ТЕЛЕПОРТ Vortex (Smart Teleport Engine)
-- ============================================================
local islandDatabase = {
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
    -- Временная (событийная) зона: без фиксированной позиции — ищем по имени в мире
    ["Temporary Zone"]   = {pos = nil, keywords = {"temporary zone", "temporary", "temp zone", "event zone", "eventzone", "limited time", "временная"}},
}

local function safeTeleport(targetCFrame)
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

local function smartTeleportToIsland(islandName)
    local data = islandDatabase[islandName]
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
        safeTeleport(foundPart.CFrame * CFrame.new(0, 5, 0))
    elseif targetPos then
        safeTeleport(CFrame.new(targetPos))
    else
        notify("Vortex Teleport", tn("Локация не найдена на этом сервере: ", "Location not found on this server: ") .. islandName, 3)
        return
    end
    notify("Vortex Teleport", "Teleported to " .. islandName, 2)
end

-- Поиск ближайшего тренажера по ключевым словам
-- Сначала смотрим в игровые папки (machinesFolder / Treadmills),
-- затем — общий обход Workspace. blacklist: модель -> время блокировки.
local function findNearestMachine(machineKeywords, blacklist)
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

    -- 1) Игровые папки с тренажёрами
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

    -- 2) Если в папках ничего не нашли — общий обход
    if not foundInFolders or not bestPart then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                tryObject(obj)
            end
        end
    end
    return bestPart, bestModel
end

-- Сиденье тренажёра (для машин из machinesFolder PrimaryPart и есть Seat)
local function getMachineSeat(model)
    if not model then return nil end
    if model:IsA("Seat") then return model end
    local pp = model.PrimaryPart
    if pp and pp:IsA("Seat") then return pp end
    local s = model:FindFirstChildWhichIsA("Seat", true)
    return s
end

-- Серверное подключение к тренажёру: machineInteractRemote:InvokeServer("useMachine", seat)
local function engageMachine(machineModel, seat)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not seat then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- если уже сидим на другом тренажёре — сначала встаём
    local inUse = getMachineInUse()
    if inUse and inUse ~= seat then
        leaveMachine()
        task.wait(0.15)
    end

    -- телепорт строго над сиденьем (несколько попыток, как требует сервер)
    for _ = 1, 3 do
        pcall(function()
            hrp.CFrame = seat.CFrame * CFrame.new(0, 5, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)
        task.wait(0.05)
    end

    local remote = getREvent("machineInteractRemote")
    if remote and remote:IsA("RemoteFunction") then
        local ok, res = pcall(function() return remote:InvokeServer("useMachine", seat) end)
        if ok and res == true then
            local t0 = tick()
            while getMachineInUse() ~= seat and tick() - t0 < 0.8 do
                task.wait(0.03)
            end
            if getMachineInUse() == seat then return true end
        end
        if ok and res == false then
            -- сервер отказал (требования не выполнены / занято)
            return false
        end
    end

    -- Фолбэк без ремоута: обычная посадка
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

-- Экуип и тренировки
local function trainTool(toolSearchName)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Если включен режим ходьбы со штангой / гантелями — запрещаем принудительную анимацию сидения
    if Config.WalkWhileTraining then
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

    local ev = getMuscleEvent()
    if ev then
        local repCount = Config.UltraFastRep and (Config.FastRepMultiplier * 5) or Config.FastRepMultiplier
        for i = 1, repCount do
            ev:FireServer("rep")
        end
    end
end

-- Anti-AFK
pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do conn:Disable() end
end)
local afkConn = LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)
table.insert(ScriptConnections, afkConn)

-- Auto Low HP Teleport Safety
local lowHpConn = RunService.Heartbeat:Connect(function()
    if Config.AutoSafeTPLowHP and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and (hum.Health / hum.MaxHealth) < 0.25 then
            safeTeleport(CFrame.new(0, 5005, 0))
            notify("Vortex Safety", "Low HP! Emergency teleport to sky safe zone!", 3)
            task.wait(5)
        end
    end
end)
table.insert(ScriptConnections, lowHpConn)

-- ============================================================
-- СИСТЕМА ПОЛЕТА (FLY ENGINE)
-- ============================================================
local flying = false
local flyBv, flyBg
local flyKeys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}

local function startFlight()
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

    flying = true

    local conn = RunService.RenderStepped:Connect(function()
        if not flying or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if flyBv then flyBv:Destroy() end
            if flyBg then flyBg:Destroy() end
            return
        end

        local cam = Workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)

        if flyKeys.W then moveDir = moveDir + cam.CFrame.LookVector end
        if flyKeys.S then moveDir = moveDir - cam.CFrame.LookVector end
        if flyKeys.A then moveDir = moveDir - cam.CFrame.RightVector end
        if flyKeys.D then moveDir = moveDir + cam.CFrame.RightVector end
        if flyKeys.Space then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if flyKeys.Shift then moveDir = moveDir - Vector3.new(0, 1, 0) end

        flyBg.CFrame = cam.CFrame
        flyBv.Velocity = moveDir * Config.FlySpeed
    end)
    table.insert(ScriptConnections, conn)
end

local function stopFlight()
    flying = false
    if flyBv then flyBv:Destroy() end
    if flyBg then flyBg:Destroy() end
end

local flyDownConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true
    elseif input.KeyCode == Enum.KeyCode.S then flyKeys.S = true
    elseif input.KeyCode == Enum.KeyCode.A then flyKeys.A = true
    elseif input.KeyCode == Enum.KeyCode.D then flyKeys.D = true
    elseif input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = true
    end
end)
table.insert(ScriptConnections, flyDownConn)

local flyUpConn = UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false
    elseif input.KeyCode == Enum.KeyCode.S then flyKeys.S = false
    elseif input.KeyCode == Enum.KeyCode.A then flyKeys.A = false
    elseif input.KeyCode == Enum.KeyCode.D then flyKeys.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = false
    end
end)
table.insert(ScriptConnections, flyUpConn)

-- Noclip & Physics Loop
local noclipConn = RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    if Config.AntiKnockback and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.Y, 0)
    end
end)
table.insert(ScriptConnections, noclipConn)

-- Inf Jump Input
local infJumpConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space and Config.InfJump then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
table.insert(ScriptConnections, infJumpConn)

-- ============================================================
-- БАЗА ГУИ (Vortex GLASS UI FRAMEWORK)
-- ============================================================
local targetParent = nil
if typeof(gethui) == "function" then
    pcall(function() targetParent = gethui() end)
end
if not targetParent then
    pcall(function()
        if syn and syn.protect_gui then
            targetParent = CoreGui
        end
    end)
end
if not targetParent then
    pcall(function() targetParent = LocalPlayer:WaitForChild("PlayerGui") end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = FRAMEWORK_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
print("[Vortex STAGE D]: ScreenGui создан")

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    end
end)
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = targetParent end)
end
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Vortex 0.23",
        Text = "Vortex loaded! Press Right Shift or the on-screen button.",
        Duration = 5
    })
end)

-- ============================================================
-- ЛОГОТИП (стилизованный чёрный кот по мотивам референса)
-- ============================================================
local function createCatLogo(parent, s)
    local logo = Instance.new("Frame", parent)
    logo.BackgroundTransparency = 1
    logo.Size = UDim2.new(0, s, 0, s)
    logo.ClipsDescendants = false

    local headW = math.floor(s * 0.68)
    local headH = math.floor(s * 0.58)
    local earS  = math.floor(s * 0.34)

    -- уши: повёрнутые квадраты, верхние углы выглядывают из-за головы
    local function ear(xPos, rot)
        local e = Instance.new("Frame", logo)
        e.Size = UDim2.new(0, earS, 0, earS)
        e.Position = xPos
        e.Rotation = rot
        e.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
        e.BorderSizePixel = 0
        e.ZIndex = 21
        applyCorner(e, 4)
        applyStroke(e, Color3.fromRGB(235, 235, 245), 0.5, 1)
        return e
    end
    ear(UDim2.new(0, math.floor(s * 0.08), 0, math.floor(s * 0.14)), -20)
    ear(UDim2.new(1, -earS - math.floor(s * 0.08), 0, math.floor(s * 0.14)), 20)

    -- голова
    local head = Instance.new("Frame", logo)
    head.AnchorPoint = Vector2.new(0.5, 1)
    head.Position = UDim2.new(0.5, 0, 1, -math.floor(s * 0.03))
    head.Size = UDim2.new(0, headW, 0, headH)
    head.BackgroundColor3 = Color3.fromRGB(9, 9, 11)
    head.BorderSizePixel = 0
    head.ZIndex = 22
    applyCorner(head, math.floor(headW * 0.44))
    applyStroke(head, Color3.fromRGB(235, 235, 245), 0.7, 1)

    -- светящиеся глаза-штрихи «^ ^»
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
        applyCorner(e, eyeH)
        applyStroke(e, Color3.fromRGB(255, 255, 255), 0.3, 2)
    end
    eye(-math.floor(headW * 0.19), -16)
    eye(math.floor(headW * 0.19), 16)
    return logo
end

-- ============================================================
-- ЭКРАН ЗАГРУЗКИ СКРИПТА (компактная карточка сверху слева, как на референсе)
-- ============================================================
local LoadModal = Instance.new("CanvasGroup", ScreenGui)
LoadModal.Name = "LoadModal"
LoadModal.Size = UDim2.new(0, 330, 0, 96)
LoadModal.Position = UDim2.new(0, 18, 0, 18)
LoadModal.BackgroundColor3 = currentTheme().window
LoadModal.BackgroundTransparency = 0
LoadModal.BorderSizePixel = 0
LoadModal.ZIndex = 20
CollectionService:AddTag(LoadModal, "ThemeWindow")
applyCorner(LoadModal, 14)
local loadStroke = applyStroke(LoadModal, AccentColor, 0.55, 1)
CollectionService:AddTag(loadStroke, "AccentStroke")

local LoadLogo = createCatLogo(LoadModal, 46)
LoadLogo.Position = UDim2.new(0, 14, 0.5, -23)

local LoadTitle = Instance.new("TextLabel", LoadModal)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Position = UDim2.new(0, 72, 0, 16)
LoadTitle.Size = UDim2.new(1, -120, 0, 18)
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Text = "Vortex"
LoadTitle.TextColor3 = Color3.fromRGB(235, 235, 240)
LoadTitle.TextSize = 15
LoadTitle.TextXAlignment = Enum.TextXAlignment.Left
LoadTitle.ZIndex = 21

local LoadVersion = Instance.new("TextLabel", LoadModal)
LoadVersion.BackgroundTransparency = 1
LoadVersion.Position = UDim2.new(1, -56, 0, 17)
LoadVersion.Size = UDim2.new(0, 44, 0, 16)
LoadVersion.Font = Enum.Font.GothamMedium
LoadVersion.Text = "v0.23"
LoadVersion.TextColor3 = Color3.fromRGB(120, 122, 130)
LoadVersion.TextSize = 10
LoadVersion.TextXAlignment = Enum.TextXAlignment.Right
LoadVersion.ZIndex = 21

local LoadStatus = Instance.new("TextLabel", LoadModal)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Position = UDim2.new(0, 72, 0, 40)
LoadStatus.Size = UDim2.new(1, -86, 0, 16)
LoadStatus.Font = Enum.Font.Gotham
LoadStatus.Text = "Загрузка..."
LoadStatus.TextColor3 = Color3.fromRGB(140, 142, 150)
LoadStatus.TextSize = 10
LoadStatus.TextXAlignment = Enum.TextXAlignment.Left
LoadStatus.ZIndex = 21

local LoadBarBG = Instance.new("Frame", LoadModal)
LoadBarBG.Position = UDim2.new(0, 16, 1, -22)
LoadBarBG.Size = UDim2.new(1, -32, 0, 4)
LoadBarBG.BackgroundColor3 = Color3.fromRGB(38, 38, 43)
LoadBarBG.BorderSizePixel = 0
LoadBarBG.ZIndex = 21
applyCorner(LoadBarBG, 2)

local LoadBarFill = Instance.new("Frame", LoadBarBG)
LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadBarFill.BackgroundColor3 = AccentColor
LoadBarFill.BorderSizePixel = 0
LoadBarFill.ZIndex = 22
CollectionService:AddTag(LoadBarFill, "AccentFill")
applyCorner(LoadBarFill, 2)

local LoadPercent = Instance.new("TextLabel", LoadModal)
LoadPercent.BackgroundTransparency = 1
LoadPercent.Position = UDim2.new(1, -48, 1, -36)
LoadPercent.Size = UDim2.new(0, 34, 0, 12)
LoadPercent.Font = Enum.Font.GothamBold
LoadPercent.Text = "0%"
LoadPercent.TextColor3 = Color3.fromRGB(120, 122, 130)
LoadPercent.TextSize = 9
LoadPercent.TextXAlignment = Enum.TextXAlignment.Right
LoadPercent.ZIndex = 21

-- ============================================================
-- КНОПКА ОТКРЫТИЯ НА ЭКРАНЕ Vortex
-- ============================================================
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "Vortex_OpenBtn"
OpenBtn.Size = UDim2.new(0, 160, 0, 40)
OpenBtn.Position = UDim2.new(0, 15, 0.35, 0)
OpenBtn.BackgroundColor3 = currentTheme().window
OpenBtn.BackgroundTransparency = 0
OpenBtn.Text = "Vortex 0.23"
OpenBtn.TextColor3 = Color3.fromRGB(240, 250, 248)
OpenBtn.TextSize = 11
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Draggable = true
CollectionService:AddTag(OpenBtn, "ThemeWindow")
applyCorner(OpenBtn, 10)
local openBtnStroke = applyStroke(OpenBtn, AccentColor, 0.4, 1.5)
CollectionService:AddTag(openBtnStroke, "AccentStroke")
OpenBtn.Visible = false -- появится после экрана загрузки

-- ============================================================
-- ON-SCREEN HUD
-- ============================================================
local OnScreenHUD = Instance.new("Frame", ScreenGui)
OnScreenHUD.Name = "OnScreenHUD"
OnScreenHUD.BackgroundTransparency = 1
OnScreenHUD.Position = UDim2.new(1, -240, 0, 20)
OnScreenHUD.Size = UDim2.new(0, 220, 0, 120)
OnScreenHUD.Visible = Config.ShowOnScreenHUD

local HUDPanel = Instance.new("Frame", OnScreenHUD)
HUDPanel.BackgroundColor3 = currentTheme().window
HUDPanel.BackgroundTransparency = 0
HUDPanel.Size = UDim2.new(1, 0, 1, 0)
CollectionService:AddTag(HUDPanel, "ThemeWindow")
applyCorner(HUDPanel, 12)
local HUDStroke = applyStroke(HUDPanel, AccentColor, 0.4, 1.5)
CollectionService:AddTag(HUDStroke, "AccentStroke")

local HUDContentLabel = Instance.new("TextLabel", HUDPanel)
HUDContentLabel.BackgroundTransparency = 1
HUDContentLabel.Position = UDim2.new(0, 12, 0, 10)
HUDContentLabel.Size = UDim2.new(1, -24, 1, -20)
HUDContentLabel.Font = Enum.Font.GothamBold
HUDContentLabel.TextColor3 = Color3.fromRGB(240, 250, 248)
HUDContentLabel.TextSize = 11
HUDContentLabel.TextXAlignment = Enum.TextXAlignment.Left
HUDContentLabel.TextYAlignment = Enum.TextYAlignment.Top
HUDContentLabel.TextWrapped = true

local hudConn = RunService.RenderStepped:Connect(function(dt)
    if Config.ShowOnScreenHUD then
        local fps = math.floor(1 / dt)
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local str = leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0
        local reb = leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0
        
        HUDContentLabel.Text = string.format("Vortex 0.23 HUD:\n  • FPS: %d | Ping: %d ms\n  • Player: %s\n  • Strength: %s\n  • Rebirths: %s", fps, ping, LocalPlayer.Name, tostring(str), tostring(reb))
    end
end)
table.insert(ScriptConnections, hudConn)

-- ============================================================
-- ГЛАВНОЕ ОКНО Vortex 0.23 (690x520)
-- ============================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = currentTheme().window
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -345, 0.5, -260)
MainFrame.Size = UDim2.new(0, 690, 0, 520)
MainFrame.Active = true
MainFrame.Visible = false -- пока идёт экран загрузки
LoadModal.Visible = true
print("[Vortex STAGE E]: главное окно построено, показан экран загрузки")
MainFrame.ClipsDescendants = true
CollectionService:AddTag(MainFrame, "ThemeWindow")
applyCorner(MainFrame, 18)
local MainStroke = applyStroke(MainFrame, AccentColor, 0.3, 1.5)
CollectionService:AddTag(MainStroke, "AccentStroke")

-- Состояние анимаций открытия/закрытия меню
local menuScale = Instance.new("UIScale", MainFrame)
menuScale.Scale = 1
local menuTargetPos = MainFrame.Position
local guiVisible, isAnimating = false, false

local GlassLayer1 = Instance.new("Frame", MainFrame)
GlassLayer1.Size = UDim2.new(1,0,1,0); GlassLayer1.BackgroundColor3 = Color3.fromRGB(255,255,255); GlassLayer1.BackgroundTransparency = 1; GlassLayer1.BorderSizePixel = 0; GlassLayer1.ZIndex = 0; applyCorner(GlassLayer1, 18)

local GlassLayer2 = Instance.new("Frame", MainFrame)
GlassLayer2.Size = UDim2.new(1,0,1,0); GlassLayer2.BackgroundColor3 = Color3.fromRGB(14,14,16); GlassLayer2.BackgroundTransparency = 0.4; GlassLayer2.BorderSizePixel = 0; GlassLayer2.ZIndex = 0; applyCorner(GlassLayer2, 18)

local BgOverlay = Instance.new("Frame", MainFrame)
BgOverlay.Size = UDim2.new(1,0,1,0); BgOverlay.BackgroundColor3 = Color3.fromRGB(5,8,10); BgOverlay.BackgroundTransparency = 1; BgOverlay.BorderSizePixel = 0; BgOverlay.ZIndex = 2; applyCorner(BgOverlay, 18)

-- Бренд-шапка над сайдбаром: иконка-ромб + название + версия
local BrandHeader = Instance.new("Frame", MainFrame)
BrandHeader.BackgroundColor3 = currentTheme().bar
BrandHeader.BackgroundTransparency = 0
BrandHeader.BorderSizePixel = 0
BrandHeader.Position = UDim2.new(0, 0, 0, 0)
BrandHeader.Size = UDim2.new(0, 190, 0, 58)
BrandHeader.ZIndex = 6
BrandHeader.Active = true
CollectionService:AddTag(BrandHeader, "ThemeBar")

-- Мини-логотип (кот) в бренд-шапке
local BrandIcon = createCatLogo(BrandHeader, 30)
BrandIcon.Position = UDim2.new(0, 14, 0.5, -15)

local BrandTitle = Instance.new("TextLabel", BrandHeader)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Position = UDim2.new(0, 42, 0, 9)
BrandTitle.Size = UDim2.new(1, -50, 0, 22)
BrandTitle.Font = Enum.Font.GothamBold
BrandTitle.Text = "Vortex"
BrandTitle.TextColor3 = Color3.fromRGB(241, 245, 249)
BrandTitle.TextSize = 16
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
BrandTitle.ZIndex = 7

local BrandVer = Instance.new("TextLabel", BrandHeader)
BrandVer.BackgroundTransparency = 1
BrandVer.Position = UDim2.new(0, 42, 0, 32)
BrandVer.Size = UDim2.new(1, -50, 0, 14)
BrandVer.Font = Enum.Font.GothamMedium
BrandVer.Text = "v0.23"
BrandVer.TextColor3 = Color3.fromRGB(148, 163, 184)
BrandVer.TextSize = 10
BrandVer.TextXAlignment = Enum.TextXAlignment.Left
BrandVer.ZIndex = 7

-- Шапка контента: заголовок страницы + подзаголовок + кнопка закрытия
local TopBar = Instance.new("Frame", MainFrame)
TopBar.BackgroundColor3 = currentTheme().bar
TopBar.BackgroundTransparency = 0
TopBar.BorderSizePixel = 0
TopBar.Position = UDim2.new(0, 190, 0, 0)
TopBar.Size = UDim2.new(1, -190, 0, 58)
TopBar.Active = true
TopBar.ZIndex = 6
CollectionService:AddTag(TopBar, "ThemeBar")

local PageTitle = Instance.new("TextLabel", TopBar)
PageTitle.BackgroundTransparency = 1
PageTitle.Position = UDim2.new(0, 18, 0, 9)
PageTitle.Size = UDim2.new(1, -70, 0, 22)
PageTitle.Font = Enum.Font.GothamBold
PageTitle.Text = "Settings"
PageTitle.TextColor3 = Color3.fromRGB(241, 245, 249)
PageTitle.TextSize = 16
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.ZIndex = 7

local PageSub = Instance.new("TextLabel", TopBar)
PageSub.BackgroundTransparency = 1
PageSub.Position = UDim2.new(0, 18, 0, 33)
PageSub.Size = UDim2.new(1, -70, 0, 14)
PageSub.Font = Enum.Font.GothamMedium
PageSub.Text = "Language, themes, GUI size and configs"
PageSub.TextColor3 = Color3.fromRGB(148, 163, 184)
PageSub.TextSize = 10
PageSub.TextXAlignment = Enum.TextXAlignment.Left
PageSub.ZIndex = 7

local CloseHeaderBtn = Instance.new("TextButton", TopBar)
CloseHeaderBtn.AnchorPoint = Vector2.new(1, 0.5)
CloseHeaderBtn.Position = UDim2.new(1, -14, 0.5, 0)
CloseHeaderBtn.Size = UDim2.new(0, 28, 0, 28)
CloseHeaderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseHeaderBtn.BackgroundTransparency = 1
CloseHeaderBtn.Text = "✕"
CloseHeaderBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
CloseHeaderBtn.Font = Enum.Font.GothamBold
CloseHeaderBtn.TextSize = 13
CloseHeaderBtn.ZIndex = 8
CloseHeaderBtn.AutoButtonColor = false
CloseHeaderBtn.MouseEnter:Connect(function()
    tw(CloseHeaderBtn, {TextColor3 = Color3.fromRGB(248, 113, 113)}, 0.15):Play()
end)
CloseHeaderBtn.MouseLeave:Connect(function()
    tw(CloseHeaderBtn, {TextColor3 = Color3.fromRGB(148, 163, 184)}, 0.15):Play()
end)

-- ЕДИНАЯ ВЫГРУЗКА СКРИПТА: останавливает все while-циклы (через флаги Config),
-- отключает все соединения и уничтожает GUI
local function completeScriptUnload()
    notify("Vortex", tn("Выгрузка скрипта Vortex 0.23...", "Unloading Vortex 0.23..."), 2)

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
        Config[flagName] = false
    end

    for _, conn in ipairs(ScriptConnections) do
        pcall(function() conn:Disconnect() end)
    end
    ScriptConnections = {}

    pcall(stopFlight)
    pcall(function() clearESP() end)
    pcall(function() ScreenGui:Destroy() end)
    print("[Vortex Framework]: Unloaded successfully.")
end
-- Перетаскивание окна за шапку (контент или бренд)
local dragging, dragStart, startPos = false, nil, nil
local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end
TopBar.InputBegan:Connect(beginDrag)
BrandHeader.InputBegan:Connect(beginDrag)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        menuTargetPos = MainFrame.Position -- запоминаем позицию для анимаций
    end
end)

-- Подвал с описанием (Description Footer Bar) — только под контентом
local DescFooterBar = Instance.new("Frame", MainFrame)
DescFooterBar.Name = "DescFooterBar"
DescFooterBar.BackgroundColor3 = currentTheme().bar
DescFooterBar.BackgroundTransparency = 0
DescFooterBar.BorderSizePixel = 0
DescFooterBar.Position = UDim2.new(0, 190, 1, -28)
DescFooterBar.Size = UDim2.new(1, -190, 0, 28)
DescFooterBar.ZIndex = 8
CollectionService:AddTag(DescFooterBar, "ThemeBar")

local DescTextLabel = Instance.new("TextLabel", DescFooterBar)
DescTextLabel.BackgroundTransparency = 1
DescTextLabel.Position = UDim2.new(0, 16, 0, 0)
DescTextLabel.Size = UDim2.new(1, -32, 1, 0)
DescTextLabel.Font = Enum.Font.GothamMedium
DescTextLabel.TextColor3 = Color3.fromRGB(126, 130, 136)
DescTextLabel.TextSize = 10
DescTextLabel.TextXAlignment = Enum.TextXAlignment.Left
DescTextLabel.Text = "Vortex 0.23: " .. t("Наведите курсор на функцию для описания...", "Hover over feature to view description...")
bindText(DescTextLabel, function()
    return "Vortex 0.23: " .. t("Наведите курсор на функцию для описания...", "Hover over feature to view description...")
end)

-- Сайдбар: полная высота под бренд-шапкой
local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.BackgroundColor3 = currentTheme().side; Sidebar.BackgroundTransparency = 0; Sidebar.BorderSizePixel = 0; Sidebar.Position = UDim2.new(0,0,0,58); Sidebar.Size = UDim2.new(0,190,1,-58); Sidebar.ZIndex = 5; Sidebar.ScrollBarThickness = 3; Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y; Sidebar.CanvasSize = UDim2.new(0,0,0,0)
CollectionService:AddTag(Sidebar, "ThemeSide")

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder; SideLayout.Padding = UDim.new(0,4)
local SidePadding = Instance.new("UIPadding", Sidebar)
SidePadding.PaddingTop = UDim.new(0,8); SidePadding.PaddingLeft = UDim.new(0,8); SidePadding.PaddingRight = UDim.new(0,8)

local pages, pageCanvases, tabButtons, TabInfo, currentTab = {}, {}, {}, {}, nil
local PagesContainer = Instance.new("Frame", MainFrame)
PagesContainer.BackgroundTransparency = 1; PagesContainer.Position = UDim2.new(0,202,0,66); PagesContainer.Size = UDim2.new(1,-214,1,-102); PagesContainer.ZIndex = 5

local function createPage(name)
    -- CanvasGroup-обёртка даёт fade-анимацию смены страницы (GroupTransparency)
    local cg = Instance.new("CanvasGroup", PagesContainer)
    cg.Name = name.."Canvas"
    cg.BackgroundTransparency = 1
    cg.Size = UDim2.new(1, 0, 1, 0)
    cg.Visible = false
    cg.ZIndex = 5
    cg.GroupTransparency = 1
    local page = Instance.new("ScrollingFrame", cg)
    page.Name = name.."Page"; page.BackgroundTransparency = 1; page.Size = UDim2.new(1,0,1,0); page.CanvasSize = UDim2.new(0,0,0,1250); page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = AccentColor; page.Visible = true; page.ZIndex = 5
    CollectionService:AddTag(page, "AccentScroll")
    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0,8)
    pages[name] = cg
    pageCanvases[name] = cg
    return page
end

-- Создаем ровно 10 Разделов
local clickGuiPage    = createPage("ClickGUI")
local dashboardPage   = createPage("Dashboard")
local trainingPage    = createPage("Training")
local rocksPage       = createPage("Rocks")
local combatPage      = createPage("Combat")
local protectionPage  = createPage("Protection")
local teleportsPage   = createPage("Teleports")
local automationPage  = createPage("Automation")
local petsPage        = createPage("Pets")
local movementPage    = createPage("Movement")
local visualsPage     = createPage("Visuals")
local aboutPage       = createPage("About")

local function switchTab(tabName)
    currentTab = tabName
    for name, cg in pairs(pages) do
        local active = (name == tabName)
        if active then
            cg.Visible = true
            tw(cg, {GroupTransparency = 0}, 0.18):Play()
        else
            local anim = tw(cg, {GroupTransparency = 1}, 0.15)
            anim:Play()
            anim.Completed:Connect(function()
                if currentTab ~= name then cg.Visible = false end
            end)
        end
    end
    for name, entry in pairs(tabButtons) do
        local active = (name == tabName)
        entry.active = active
        tw(entry.btn, {BackgroundTransparency = active and 0.9 or 1}, 0.2):Play()
        entry.nameLbl.TextColor3 = active and Color3.fromRGB(241, 245, 249) or Color3.fromRGB(148, 163, 184)
    end
    local info = TabInfo[tabName]
    if info then
        -- HUD (заголовок/подзаголовок страницы) всегда на английском
        PageTitle.Text = info.title
        PageSub.Text = info.sub or ""
    end
end

-- Вкладка без иконок (как в референсе): только короткое имя + hover-подсветка
local function createTabButton(displayName, internalName, subTitle)
    local btn = Instance.new("TextButton", Sidebar)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 5
    applyCorner(btn, 8)

    local nameLbl = Instance.new("TextLabel", btn)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Position = UDim2.new(0, 14, 0.5, -8)
    nameLbl.Size = UDim2.new(1, -22, 0, 16)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Text = displayName -- всегда EN
    nameLbl.TextColor3 = Color3.fromRGB(148, 163, 184)
    nameLbl.TextSize = 11
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 6

    local entry = {btn = btn, nameLbl = nameLbl, active = false}
    btn.MouseEnter:Connect(function()
        if not entry.active then
            tw(btn, {BackgroundTransparency = 0.95}, 0.12):Play()
            tw(nameLbl, {TextColor3 = Color3.fromRGB(214, 216, 224)}, 0.12):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not entry.active then
            tw(btn, {BackgroundTransparency = 1}, 0.15):Play()
            tw(nameLbl, {TextColor3 = Color3.fromRGB(148, 163, 184)}, 0.15):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function() switchTab(internalName) end)
    tabButtons[internalName] = entry
    TabInfo[internalName] = {title = displayName, sub = subTitle}
    return btn
end

-- 12 разделов: короткие EN-названия без иконок (HUD всегда на английском)
createTabButton("Settings", "ClickGUI", "Language, themes, GUI size and configs")
createTabButton("Home", "Dashboard", "Stats and progress overview")
createTabButton("Farm", "Training", "Gym machines and auto farm")
createTabButton("Rocks", "Rocks", "Rock tiers and gyms")
createTabButton("Combat", "Combat", "Kill aura and boss hunting")
createTabButton("Protection", "Protection", "Defense and auto safe TP")
createTabButton("Teleports", "Teleports", "World locations and waypoints")
createTabButton("Auto", "Automation", "Crystals and auto actions")
createTabButton("Pets", "Pets", "Pets and inventory")
createTabButton("Movement", "Movement", "Movement and ESP")
createTabButton("Visuals", "Visuals", "Sky, trails and jump effects")
createTabButton("About", "About", "Owner harin | Discord harin")

-- UI Компоненты с Индикатором Статуса [ВКЛ / ВЫКЛ]
local accentToggles = {}

local function bindTooltip(frame, descriptionText)
    frame.MouseEnter:Connect(function()
        if Config.EnableTooltips then
            DescTextLabel.Text = "Vortex 0.23: " .. tostring(resolveText(descriptionText))
        end
    end)
    frame.MouseLeave:Connect(function()
        if Config.EnableTooltips then
            DescTextLabel.Text = "Vortex 0.23: " .. t("Наведите курсор на функцию для описания...", "Hover over feature to view description...")
        end
    end)
end

local function sectionLabel(page, text)
    local lbl = Instance.new("TextLabel", page)
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1,-10,0,18); lbl.Font = Enum.Font.GothamBold; lbl.Text = string.upper(tostring(resolveText(text))); lbl.TextColor3 = Color3.fromRGB(110, 118, 129); lbl.TextSize = 9; lbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(lbl, function() return string.upper(tostring(resolveText(text))) end)
    return lbl
end

local function createGlassPanel(page, height)
    local panel = Instance.new("Frame", page)
    panel.BackgroundColor3 = currentTheme().panel; panel.BackgroundTransparency = 0; panel.Size = UDim2.new(1,-10,0,height)
    CollectionService:AddTag(panel, "ThemePanel")
    applyCorner(panel, 10); applyStroke(panel, Color3.fromRGB(255,255,255), 0.94, 1)
    -- мягкая подсветка при наведении
    panel.MouseEnter:Connect(function()
        local base = currentTheme().panel
        tw(panel, {BackgroundColor3 = Color3.new(
            math.min(1, base.R + 0.05), math.min(1, base.G + 0.05), math.min(1, base.B + 0.05)
        )}, 0.12):Play()
    end)
    panel.MouseLeave:Connect(function()
        tw(panel, {BackgroundColor3 = currentTheme().panel}, 0.15):Play()
    end)
    return panel
end

-- ============================================================
-- ПОПАП НАСТРОЕК ФУНКЦИИ: ЛКМ по карточке-тумблеру открывает окно
-- ============================================================
local FuncPopupLayer = Instance.new("CanvasGroup", ScreenGui)
FuncPopupLayer.Name = "FuncPopupLayer"
FuncPopupLayer.Size = UDim2.new(1, 0, 1, 0)
FuncPopupLayer.BackgroundTransparency = 1
FuncPopupLayer.Visible = false
FuncPopupLayer.ZIndex = 30
FuncPopupLayer.GroupTransparency = 1

local PopupBlocker = Instance.new("TextButton", FuncPopupLayer)
PopupBlocker.Size = UDim2.new(1, 0, 1, 0)
PopupBlocker.BackgroundTransparency = 1
PopupBlocker.Text = ""
PopupBlocker.AutoButtonColor = false
PopupBlocker.ZIndex = 31

local FuncPopup = Instance.new("Frame", FuncPopupLayer)
FuncPopup.Name = "FuncPopup"
FuncPopup.AnchorPoint = Vector2.new(0.5, 0.5)
FuncPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
FuncPopup.Size = UDim2.new(0, 360, 0, 0)
FuncPopup.AutomaticSize = Enum.AutomaticSize.Y
FuncPopup.BackgroundColor3 = currentTheme().window
FuncPopup.BorderSizePixel = 0
FuncPopup.ZIndex = 32
CollectionService:AddTag(FuncPopup, "ThemeWindow")
applyCorner(FuncPopup, 14)
local popupStroke = applyStroke(FuncPopup, AccentColor, 0.5, 1)
CollectionService:AddTag(popupStroke, "AccentStroke")

local FuncPopupScale = Instance.new("UIScale", FuncPopup)
FuncPopupScale.Scale = 0.94

local popupLayout = Instance.new("UIListLayout", FuncPopup)
popupLayout.SortOrder = Enum.SortOrder.LayoutOrder
popupLayout.Padding = UDim.new(0, 8)

local popupPad = Instance.new("UIPadding", FuncPopup)
popupPad.PaddingTop = UDim.new(0, 16); popupPad.PaddingBottom = UDim.new(0, 16)
popupPad.PaddingLeft = UDim.new(0, 16); popupPad.PaddingRight = UDim.new(0, 16)

local PopTitle = Instance.new("TextLabel", FuncPopup)
PopTitle.Name = "PopTitle"
PopTitle.BackgroundTransparency = 1
PopTitle.LayoutOrder = 1
PopTitle.Size = UDim2.new(1, -30, 0, 20)
PopTitle.Font = Enum.Font.GothamBold
PopTitle.Text = ""
PopTitle.TextColor3 = Color3.fromRGB(241, 245, 249)
PopTitle.TextSize = 14
PopTitle.TextXAlignment = Enum.TextXAlignment.Left
PopTitle.ZIndex = 33

local PopDesc = Instance.new("TextLabel", FuncPopup)
PopDesc.Name = "PopDesc"
PopDesc.BackgroundTransparency = 1
PopDesc.LayoutOrder = 2
PopDesc.Size = UDim2.new(1, 0, 0, 0)
PopDesc.AutomaticSize = Enum.AutomaticSize.Y
PopDesc.Font = Enum.Font.Gotham
PopDesc.Text = ""
PopDesc.TextWrapped = true
PopDesc.TextColor3 = Color3.fromRGB(148, 163, 184)
PopDesc.TextSize = 10
PopDesc.TextXAlignment = Enum.TextXAlignment.Left
PopDesc.ZIndex = 33

local PopCloseBtn = Instance.new("TextButton", FuncPopup)
PopCloseBtn.Name = "PopClose"
PopCloseBtn.AnchorPoint = Vector2.new(1, 0)
PopCloseBtn.Position = UDim2.new(1, -10, 0, 10)
PopCloseBtn.Size = UDim2.new(0, 26, 0, 26)
PopCloseBtn.BackgroundTransparency = 1
PopCloseBtn.Text = "✕"
PopCloseBtn.Font = Enum.Font.GothamBold
PopCloseBtn.TextSize = 12
PopCloseBtn.TextColor3 = Color3.fromRGB(148, 163, 184)
PopCloseBtn.ZIndex = 34
PopCloseBtn.AutoButtonColor = false

local function closeFuncPopup()
    if not FuncPopupLayer.Visible then return end
    local anim = tw(FuncPopupLayer, {GroupTransparency = 1}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    tw(FuncPopupScale, {Scale = 0.97}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
    anim.Completed:Connect(function()
        if FuncPopupLayer.GroupTransparency >= 0.99 then FuncPopupLayer.Visible = false end
    end)
end

-- buildBody(parent) создаёт тело popup; все его дочерние GuiObject
-- (кроме заголовка/описания/крестика) попадают в общий список LayoutOrder
local function openFuncPopup(title, desc, buildBody)
    for _, child in ipairs(FuncPopup:GetChildren()) do
        if child:IsA("GuiObject") and child:GetAttribute("PopupBody") then
            child:Destroy()
        end
    end
    PopTitle.Text = tostring(resolveText(title or ""))
    PopDesc.Text = tostring(resolveText(desc or ""))
    PopDesc.Visible = (desc ~= nil and desc ~= "")
    if buildBody then
        local ok, err = pcall(buildBody, FuncPopup)
        if not ok then warn("[Vortex] popup body error: " .. tostring(err)) end
    end
    local order = 2
    for _, child in ipairs(FuncPopup:GetChildren()) do
        if child:IsA("GuiObject") and child ~= PopTitle and child ~= PopDesc and child ~= PopCloseBtn then
            child:SetAttribute("PopupBody", true)
            order = order + 1
            child.LayoutOrder = order
        end
    end
    FuncPopupLayer.Visible = true
    FuncPopupLayer.GroupTransparency = 1
    FuncPopupScale.Scale = 0.97
    tw(FuncPopupLayer, {GroupTransparency = 0}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
    tw(FuncPopupScale, {Scale = 1}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
end

PopupBlocker.MouseButton1Click:Connect(closeFuncPopup)
PopCloseBtn.MouseButton1Click:Connect(closeFuncPopup)
PopCloseBtn.MouseEnter:Connect(function()
    tw(PopCloseBtn, {TextColor3 = Color3.fromRGB(248, 113, 113)}, 0.12):Play()
end)
PopCloseBtn.MouseLeave:Connect(function()
    tw(PopCloseBtn, {TextColor3 = Color3.fromRGB(148, 163, 184)}, 0.12):Play()
end)

-- Тумблер внутри popup (общий вид с карточкой)
local function buildPopupSwitch(parent, getState, onFlip)
    local row = Instance.new("TextButton", parent)
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = currentTheme().panel
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.ZIndex = 33
    CollectionService:AddTag(row, "ThemePanel")
    applyCorner(row, 10)
    applyStroke(row, Color3.fromRGB(255, 255, 255), 0.94, 1)

    local rowLbl = Instance.new("TextLabel", row)
    rowLbl.BackgroundTransparency = 1
    rowLbl.Position = UDim2.new(0, 14, 0.5, -8)
    rowLbl.Size = UDim2.new(1, -70, 0, 16)
    rowLbl.Font = Enum.Font.GothamBold
    rowLbl.Text = getState() and t("Включено", "Enabled") or t("Выключено", "Disabled")
    rowLbl.TextColor3 = getState() and AccentColor or Color3.fromRGB(148, 163, 184)
    rowLbl.TextSize = 11
    rowLbl.TextXAlignment = Enum.TextXAlignment.Left
    rowLbl.ZIndex = 34

    local indicator = Instance.new("Frame", row)
    indicator.AnchorPoint = Vector2.new(1, 0.5)
    indicator.Position = UDim2.new(1, -14, 0.5, 0)
    indicator.Size = UDim2.new(0, 44, 0, 22)
    indicator.BackgroundColor3 = getState() and AccentColor or Color3.fromRGB(51, 65, 85)
    indicator.ZIndex = 34
    applyCorner(indicator, 11)

    local dot = Instance.new("Frame", indicator)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.Position = getState() and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.ZIndex = 35
    applyCorner(dot, 8)

    local function paint()
        local on = getState()
        rowLbl.Text = on and t("Включено", "Enabled") or t("Выключено", "Disabled")
        tw(rowLbl, {TextColor3 = on and AccentColor or Color3.fromRGB(148, 163, 184)}, 0.15):Play()
        tw(indicator, {BackgroundColor3 = on and AccentColor or Color3.fromRGB(51, 65, 85)}, 0.15):Play()
        tw(dot, {Position = on and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}, 0.15):Play()
    end

    row.MouseButton1Click:Connect(function()
        onFlip()
        paint()
    end)
    return paint
end

local function createButton(page, name, desc, callback, extras)
    local panel = createGlassPanel(page, 46)
    local btn = Instance.new("TextButton", panel)
    btn.BackgroundTransparency = 1; btn.Size = UDim2.new(1,0,1,0); btn.Text = ""; btn.ZIndex = 2

    local lbl = Instance.new("TextLabel", panel)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,14,0,6); lbl.Size = UDim2.new(1,-50,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = resolveText(name); lbl.TextColor3 = Color3.fromRGB(241,245,249); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(lbl, function() return resolveText(name) end)

    local descLbl = Instance.new("TextLabel", panel)
    descLbl.BackgroundTransparency = 1; descLbl.Position = UDim2.new(0,14,0,24); descLbl.Size = UDim2.new(1,-50,0,16)
    descLbl.Font = Enum.Font.Gotham; descLbl.Text = resolveText(desc); descLbl.TextColor3 = Color3.fromRGB(148,163,184); descLbl.TextSize = 9; descLbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(descLbl, function() return resolveText(desc) end)

    local chev = Instance.new("TextLabel", panel)
    chev.BackgroundTransparency = 1; chev.AnchorPoint = Vector2.new(1,0.5); chev.Position = UDim2.new(1,-16,0.5,0); chev.Size = UDim2.new(0,18,0,18)
    chev.Font = Enum.Font.GothamBold; chev.Text = "›"; chev.TextColor3 = Color3.fromRGB(148,163,184); chev.TextSize = 16; chev.ZIndex = 3

    bindTooltip(btn, desc)

    btn.MouseButton1Click:Connect(function()
        -- с настройками (extras) — открываем popup; чистое действие — выполняем сразу
        if extras then
            openFuncPopup(name, desc, function(body)
                extras(body)
                local run = Instance.new("TextButton", body)
                run.Size = UDim2.new(1, 0, 0, 40)
                run.BackgroundColor3 = AccentColor
                run.BorderSizePixel = 0
                run.Text = t("Запустить", "Run")
                run.Font = Enum.Font.GothamBold
                run.TextSize = 12
                run.TextColor3 = Color3.fromRGB(17, 17, 20)
                run.AutoButtonColor = false
                run.ZIndex = 33
                CollectionService:AddTag(run, "AccentFill")
                applyCorner(run, 10)
                run.MouseButton1Click:Connect(function()
                    closeFuncPopup()
                    callback()
                end)
            end)
            return
        end
        tw(panel, {BackgroundColor3 = AccentColor, BackgroundTransparency = 0}, 0.1):Play()
        task.delay(0.15, function() tw(panel, {BackgroundColor3 = currentTheme().panel, BackgroundTransparency = 0}, 0.15):Play() end)
        callback()
    end)
    return panel
end

local function createToggle(page, name, desc, default, callback, extras)
    local btn = createGlassPanel(page, 48)
    local clickArea = Instance.new("TextButton", btn)
    clickArea.BackgroundTransparency = 1; clickArea.Size = UDim2.new(1,0,1,0); clickArea.Text = ""; clickArea.ZIndex = 2

    local state = default

    local lbl = Instance.new("TextLabel", btn)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,14,0,7); lbl.Size = UDim2.new(1,-70,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = resolveText(name); lbl.TextColor3 = Color3.fromRGB(226,232,240); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(lbl, function() return resolveText(name) end)

    local descLbl = Instance.new("TextLabel", btn)
    descLbl.BackgroundTransparency = 1; descLbl.Position = UDim2.new(0,14,0,26); descLbl.Size = UDim2.new(1,-70,0,16)
    descLbl.Font = Enum.Font.Gotham; descLbl.Text = resolveText(desc); descLbl.TextColor3 = Color3.fromRGB(148,163,184); descLbl.TextSize = 9; descLbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(descLbl, function() return resolveText(desc) end)

    local indicator = Instance.new("Frame", btn)
    indicator.AnchorPoint = Vector2.new(1,0.5); indicator.Position = UDim2.new(1,-14,0.5,0); indicator.Size = UDim2.new(0,38,0,20)
    indicator.BackgroundColor3 = state and AccentColor or Color3.fromRGB(51,65,85)
    indicator.ZIndex = 3
    applyCorner(indicator, 10)

    local dot = Instance.new("Frame", indicator)
    dot.AnchorPoint = Vector2.new(0,0.5); dot.Position = state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)
    dot.Size = UDim2.new(0,14,0,14); dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dot.ZIndex = 4
    applyCorner(dot, 7)

    bindTooltip(clickArea, desc)
    table.insert(accentToggles, {indicator = indicator, getState = function() return state end})

    local function paintCard()
        tw(indicator, {BackgroundColor3 = state and AccentColor or Color3.fromRGB(51,65,85)}, 0.15):Play()
        tw(dot, {Position = state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)}, 0.15):Play()
    end

    -- ЛКМ по карточке: открыть настройки (popup с тумблером)
    clickArea.MouseButton1Click:Connect(function()
        openFuncPopup(name, desc, function(body)
            buildPopupSwitch(body, function() return state end, function()
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

local function createSlider(page, name, min, max, default, callback, colorAccent, desc)
    local sliderFrame = createGlassPanel(page, 56)
    local lbl = Instance.new("TextLabel", sliderFrame)
    lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,12,0,6); lbl.Size = UDim2.new(0,250,0,16)
    lbl.Font = Enum.Font.GothamBold; lbl.Text = resolveText(name); lbl.TextColor3 = Color3.fromRGB(241,245,249); lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    bindText(lbl, function() return resolveText(name) end)

    local valLbl = Instance.new("TextLabel", sliderFrame)
    valLbl.BackgroundTransparency = 1; valLbl.Position = UDim2.new(1,-70,0,6); valLbl.Size = UDim2.new(0,58,0,16)
    valLbl.Font = Enum.Font.GothamBold; valLbl.Text = tostring(default); valLbl.TextColor3 = colorAccent or AccentColor; valLbl.TextSize = 11; valLbl.TextXAlignment = Enum.TextXAlignment.Right
    if not colorAccent then CollectionService:AddTag(valLbl, "AccentText") end

    local BarBG = Instance.new("TextButton", sliderFrame)
    BarBG.BackgroundColor3 = Color3.fromRGB(51,65,85); BarBG.BorderSizePixel = 0; BarBG.Position = UDim2.new(0,12,0,34); BarBG.Size = UDim2.new(1,-24,0,8); BarBG.AutoButtonColor = false; BarBG.Text = ""
    applyCorner(BarBG, 4)

    local BarFill = Instance.new("Frame", BarBG)
    BarFill.BackgroundColor3 = colorAccent or AccentColor; BarFill.BorderSizePixel = 0; BarFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    applyCorner(BarFill, 4)
    if not colorAccent then CollectionService:AddTag(BarFill, "AccentFill") end

    local Knob = Instance.new("Frame", BarBG)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 3
    applyCorner(Knob, 7)

    bindTooltip(BarBG, desc or function()
        return t("Настройка параметра ", "Adjust parameter ") .. resolveText(name)
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

local function createColorSwatchGrid(page, presets, onPick, size)
    local Row = Instance.new("Frame", page)
    Row.BackgroundTransparency = 1; Row.Size = UDim2.new(1,0,0, math.ceil(#presets/6) * (size+6) + 6)
    local grid = Instance.new("UIGridLayout", Row)
    grid.CellSize = UDim2.new(0,size,0,size); grid.CellPadding = UDim2.new(0,6,0,6)

    local selectedStroke = nil
    for _, preset in ipairs(presets) do
        local swatch = Instance.new("TextButton", Row)
        swatch.BackgroundColor3 = preset.color; swatch.AutoButtonColor = false; swatch.Text = ""
        applyCorner(swatch, size/2)
        local sStroke = applyStroke(swatch, Color3.fromRGB(255,255,255), 0.6, 1.5)

        bindTooltip(swatch, function()
            return t("Применить цветовой пресет: ", "Apply color preset: ") .. preset.name
        end)

        swatch.MouseButton1Click:Connect(function()
            onPick(preset.color)
            if selectedStroke then tw(selectedStroke, {Transparency = 0.6, Thickness = 1.5}, 0.15):Play() end
            tw(sStroke, {Transparency = 0, Thickness = 2.5}, 0.15):Play()
            selectedStroke = sStroke
        end)
    end
    return Row
end

local function applyAccent(newColor)
    AccentColor = newColor
    for _, inst in ipairs(CollectionService:GetTagged("AccentStroke")) do tw(inst, {Color = newColor}, 0.25):Play() end
    for _, inst in ipairs(CollectionService:GetTagged("AccentFill")) do tw(inst, {BackgroundColor3 = newColor}, 0.25):Play() end
    for _, inst in ipairs(CollectionService:GetTagged("AccentText")) do tw(inst, {TextColor3 = newColor}, 0.25):Play() end
    for _, tog in ipairs(accentToggles) do if tog.getState() then tw(tog.indicator, {BackgroundColor3 = newColor}, 0.25):Play() end end
end

-- Применение темы окна (сплошные фоны, без прозрачности)
local function applyTheme(idx)
    if not UIThemes[idx] then idx = 1 end
    Config.ThemeIndex = idx
    local theme = UIThemes[idx]
    for _, inst in ipairs(CollectionService:GetTagged("ThemeWindow")) do
        tw(inst, {BackgroundColor3 = theme.window, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemeBar")) do
        tw(inst, {BackgroundColor3 = theme.bar, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemeSide")) do
        tw(inst, {BackgroundColor3 = theme.side, BackgroundTransparency = 0}, 0.25):Play()
    end
    for _, inst in ipairs(CollectionService:GetTagged("ThemePanel")) do
        tw(inst, {BackgroundColor3 = theme.panel, BackgroundTransparency = 0}, 0.25):Play()
    end
    applyAccent(theme.accent)
    if currentTab and pages[currentTab] then
        switchTab(currentTab)
    end
end

-- Экран загрузки и анимации меню определены в конце файла (playLoadingSequence / openMenu / closeMenu)

-- ============================================================
-- 1. РАЗДЕЛ: SETTINGS (бывший ClickGUI)
-- ============================================================
sectionLabel(clickGuiPage, "GUI SIZE & LAYOUT")
local guiSizeScale = Instance.new("UIScale", MainFrame)
guiSizeScale.Scale = Config.GuiScale
createSlider(clickGuiPage, "GUI Size (%)", 70, 150, math.floor(Config.GuiScale * 100 + 0.5), function(v)
    Config.GuiScale = v / 100
    tw(guiSizeScale, {Scale = Config.GuiScale}, 0.12):Play()
end, nil, "Overall scale of the Vortex window (70% - 150%)")

sectionLabel(clickGuiPage, "LANGUAGE & THEME PRESETS")
createButton(clickGuiPage, "Switch Language / Сменить Язык (RU / EN)", "Переключает язык интерфейса между Русским и English", function()
    Config.Language = (Config.Language == "RU") and "EN" or "RU"
    applyLanguage()
    notify("Vortex Language", tn("Язык изменен на Русский", "Language changed to English"), 3)
end)

createButton(clickGuiPage, "Switch Theme (Сменить Тему)", function()
    return t("Текущая тема: ", "Current theme: ") .. UIThemes[Config.ThemeIndex].name
        .. t(" — нажмите для следующей (Black → Slate → Midnight → Crimson → Cyberpunk)", " — click for next (Black → Slate → Midnight → Crimson → Cyberpunk)")
end, function()
    local nextIdx = (Config.ThemeIndex % #UIThemes) + 1
    applyTheme(nextIdx)
    notify("Vortex Theme", tn("Тема: ", "Theme: ") .. UIThemes[nextIdx].name, 2)
end)

local rSlider, gSlider, bSlider
createColorSwatchGrid(clickGuiPage, AccentPresets, function(color)
    applyAccent(color)
    rSlider.fill.Size = UDim2.new(color.R,0,1,0); rSlider.valLbl.Text = tostring(round(color.R*255))
    gSlider.fill.Size = UDim2.new(color.G,0,1,0); gSlider.valLbl.Text = tostring(round(color.G*255))
    bSlider.fill.Size = UDim2.new(color.B,0,1,0); bSlider.valLbl.Text = tostring(round(color.B*255))
end, 36)

sectionLabel(clickGuiPage, "CUSTOM RGB ACCENT")
local currentR, currentG, currentB = AccentColor.R*255, AccentColor.G*255, AccentColor.B*255
local function updateCustomColor()
    local newColor = Color3.fromRGB(round(currentR), round(currentG), round(currentB))
    applyAccent(newColor)
end

rSlider = createSlider(clickGuiPage, "Red Accent", 0, 255, round(currentR), function(v) currentR=v; updateCustomColor() end, Color3.fromRGB(248,113,113), "Красный цвет интерфейса")
gSlider = createSlider(clickGuiPage, "Green Accent", 0, 255, round(currentG), function(v) currentG=v; updateCustomColor() end, Color3.fromRGB(74,222,128), "Зеленый цвет интерфейса")
bSlider = createSlider(clickGuiPage, "Blue Accent", 0, 255, round(currentB), function(v) currentB=v; updateCustomColor() end, Color3.fromRGB(96,165,250), "Синий цвет интерфейса")

-- ============================================================
-- SAVED CONFIGS: сохранение/загрузка настроек в буфер обмена
-- ============================================================
sectionLabel(clickGuiPage, "SAVED CONFIGS")

local function serializeConfig()
    local parts = {}
    for k, v in pairs(Config) do
        local tv = type(v)
        if tv == "boolean" or tv == "number" or tv == "string" then
            table.insert(parts, k .. "=" .. tostring(v))
        end
    end
    table.sort(parts)
    return "VORTEX_CONFIG;" .. table.concat(parts, ";")
end

local function deserializeConfig(str)
    if type(str) ~= "string" or not string.find(str, "VORTEX_CONFIG", 1, true) then
        return nil, tn("Буфер обмена не содержит конфига Vortex", "Clipboard does not contain a Vortex config")
    end
    local loaded = 0
    for entry in string.gmatch(str, "[^;]+") do
        local k, v = string.match(entry, "^([%w_]+)=(.*)$")
        if k ~= nil and Config[k] ~= nil then
            local cur = Config[k]
            local tv = type(cur)
            if tv == "boolean" then
                if v == "true" then Config[k] = true loaded = loaded + 1
                elseif v == "false" then Config[k] = false loaded = loaded + 1 end
            elseif tv == "number" then
                local n = tonumber(v)
                if n ~= nil then Config[k] = n loaded = loaded + 1 end
            elseif tv == "string" then
                Config[k] = v loaded = loaded + 1
            end
        end
    end
    if loaded == 0 then
        return nil, tn("Не удалось применить значения из буфера", "Failed to apply values from clipboard")
    end
    return loaded, nil
end

local function readClipboardText()
    local ok, res = pcall(function()
        if type(readclipboard) == "function" then return readclipboard() end
        local g = getgenv and getgenv()
        if g and type(g.readclipboard) == "function" then return g.readclipboard() end
        error("no clipboard reader")
    end)
    if ok and type(res) == "string" then return res end
    return nil
end

createButton(clickGuiPage, "Save Config to Clipboard", "Сохраняет все настройки Vortex в буфер обмена", function()
    local ok = pcall(function() setclipboard(serializeConfig()) end)
    if ok then
        notify("Vortex Config", "Config copied to clipboard!", 3)
    else
        notify("Vortex Config", "Clipboard is not available in this injector", 4)
    end
end)

createButton(clickGuiPage, "Load Config from Clipboard", "Загружает настройки Vortex из буфера обмена", function()
    local text = readClipboardText()
    if not text then
        notify("Vortex Config", "Clipboard read is not available in this injector", 4)
        return
    end
    local loaded, err = deserializeConfig(text)
    if not loaded then
        notify("Vortex Config", err or "Invalid config", 4)
        return
    end
    pcall(function()
        applyTheme(Config.ThemeIndex or 1)
        tw(guiSizeScale, {Scale = tonumber(Config.GuiScale) or 1}, 0.12):Play()
        DescFooterBar.Visible = Config.EnableTooltips ~= false
    end)
    notify("Vortex Config", "Config loaded: " .. tostring(loaded) .. " options applied", 3)
end)

sectionLabel(clickGuiPage, "INTERFACE GLASS & SETTINGS")
createToggle(clickGuiPage, "Glow Outline", "Пульсирующая неоновая рамка меню", Config.Glow, function(v)
    Config.Glow = v; tw(MainStroke, {Transparency = v and 0.3 or 0.8}, 0.3):Play()
end)
createSlider(clickGuiPage, "Glass Blur Intensity", 0, 100, Config.GlassIntensity, function(v)
    Config.GlassIntensity = v
    GlassLayer2.BackgroundTransparency = 0.15 + (1 - v/100) * 0.5
end, nil, "Интенсивность размытия стекла")

createToggle(clickGuiPage, "Hover Description Bar", "Отображение описания функций внизу экрана", Config.EnableTooltips, function(v)
    Config.EnableTooltips = v
    DescFooterBar.Visible = v
end)

createButton(clickGuiPage, "Optimize FPS (Smooth Plastic)", "Удаляет текстуры карты для увеличения FPS", function()
    pcall(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
        end
        Lighting.GlobalShadows = false
    end)
    notify("FPS Boost", "Map textures optimized!", 2)
end)

-- Unload кнопка использует общую completeScriptUnload (определена выше, у шапки окна)
createButton(clickGuiPage, "Unload & Terminate Vortex", "Полная выгрузка скрипта Vortex 0.23 и очистка памяти", completeScriptUnload)

-- ============================================================
-- 2. РАЗДЕЛ: DASHBOARD
-- ============================================================
sectionLabel(dashboardPage, "Vortex • Player Live Overview")
local StatsPanel = createGlassPanel(dashboardPage, 110)
local StatsText = Instance.new("TextLabel", StatsPanel)
StatsText.BackgroundTransparency = 1; StatsText.Position = UDim2.new(0, 12, 0, 10); StatsText.Size = UDim2.new(1, -24, 1, -20)
StatsText.Font = Enum.Font.GothamMedium; StatsText.TextColor3 = Color3.fromRGB(241,245,249); StatsText.TextSize = 11; StatsText.TextXAlignment = Enum.TextXAlignment.Left; StatsText.TextYAlignment = Enum.TextYAlignment.Top

local dashConn = RunService.RenderStepped:Connect(function()
    local dashCanvas = pageCanvases["Dashboard"]
    if dashCanvas and dashCanvas.Visible then
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local str = leaderstats and leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value or 0
        local reb = leaderstats and leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value or 0
        local agi = leaderstats and leaderstats:FindFirstChild("Agility") and leaderstats.Agility.Value or 0
        local dur = leaderstats and leaderstats:FindFirstChild("Durability") and leaderstats.Durability.Value or 0

        StatsText.Text = string.format("ACCOUNT STATS:\n  • Name: %s (UserId: %d)\n  • Strength: %s | Rebirths: %s\n  • Agility: %s | Durability: %s", LocalPlayer.Name, LocalPlayer.UserId, tostring(str), tostring(reb), tostring(agi), tostring(dur))
    end
end)
table.insert(ScriptConnections, dashConn)

sectionLabel(dashboardPage, "QUICK CHARACTER SIZE PRESETS")
local function setCharacterScale(val)
    Config.PlayerScale = val
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
    notify("Vortex Size", "Character scale set: " .. tostring(val) .. "x", 2)
end

createButton(dashboardPage, "Micro Size (0.1x)", "Делает персонажа незаметным мини-карликом", function() setCharacterScale(0.1) end)
createButton(dashboardPage, "Normal Size (1x)", "Стандартный человеческий размер", function() setCharacterScale(1) end)
createButton(dashboardPage, "Big Muscle (5x)", "Большой накачанный персонаж", function() setCharacterScale(5) end)
createButton(dashboardPage, "Giant Monster (15x)", "Огромный титан на всю карту", function() setCharacterScale(15) end)
createButton(dashboardPage, "Colossal God (30x)", "Колоссальный гигант", function() setCharacterScale(30) end)

createSlider(dashboardPage, "Custom Size Multiplier", 1, 30, 1, function(v) setCharacterScale(v) end, nil, "Точная настройка масштаба персонажа (1x - 30x)")

-- ============================================================
-- 3. РАЗДЕЛ: AUTO FARM / TRAINING
-- ============================================================
sectionLabel(trainingPage, "AUTO OP — UNIVERSAL TURBO FAST FARM")

createToggle(trainingPage, "Auto OP (Универсальный сумасшедший кликер)", "Сели за ЛЮБОЙ тренажер или взяли ЛЮБОЙ снаряд — мгновенно качает на предельной турбо-скорости!", Config.AutoOpFarm, function(v)
    Config.AutoOpFarm = v
    if v then
        notify("Vortex Auto OP", "Auto OP enabled! Just sit on any machine or grab any equipment!", 4)
        task.spawn(function()
            while Config.AutoOpFarm do
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local ev = getMuscleEvent()

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
                            local count = Config.UltraFastRep and (Config.FastRepMultiplier * 10) or (Config.FastRepMultiplier * 3)
                            for i = 1, count do
                                ev:FireServer("rep")
                            end
                        end
                    end
                end
                task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.01)
            end
        end)
    end
end)

sectionLabel(trainingPage, "AUTOMATED EXERCISE MACHINES")
createToggle(trainingPage, "Auto Dumbbell Farm", "Авто-фарм Силы через Гантели", Config.AutoDumbbell, function(v)
    Config.AutoDumbbell = v
    if v then
        task.spawn(function()
            while Config.AutoDumbbell do
                trainTool("Dumbbell")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Auto Pushups Farm", "Авто-фарм Силы через Отжимания", Config.AutoPushups, function(v)
    Config.AutoPushups = v
    if v then
        task.spawn(function()
            while Config.AutoPushups do
                trainTool("Pushups")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Auto Situps Farm", "Авто-фарм Силы через Пресс", Config.AutoSitups, function(v)
    Config.AutoSitups = v
    if v then
        task.spawn(function()
            while Config.AutoSitups do
                trainTool("Situps")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Auto Weight Bar Farm", "Авто-фарм Силы через Штангу", Config.AutoWeight, function(v)
    Config.AutoWeight = v
    if v then
        task.spawn(function()
            while Config.AutoWeight do
                trainTool("Weight")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Auto Punching Bag Farm", "Авто-удары по груше/воздуху для прокачки", Config.AutoPunch, function(v)
    Config.AutoPunch = v
    if v then
        task.spawn(function()
            while Config.AutoPunch do
                trainTool("Punch")
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Multi-Tool Super Farm (All-in-One)", "Автоматически чередует все снаряды для максимальной прокачки", Config.AutoMultiTool, function(v)
    Config.AutoMultiTool = v
    if v then
        task.spawn(function()
            local tools = {"Dumbbell", "Pushups", "Situps", "Weight"}
            local idx = 1
            while Config.AutoMultiTool do
                trainTool(tools[idx])
                idx = (idx % #tools) + 1
                task.wait(Config.TrainDelay)
            end
        end)
    end
end)

createToggle(trainingPage, "Walk While Training (Ходить во время упражнения)", "Позволяет свободно ходить со штангой, гантелями или во время выполнения упражнений!", Config.WalkWhileTraining, function(v)
    Config.WalkWhileTraining = v
    if v then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
        end
        notify("Vortex Walk", "Walk while training enabled!", 2)
        -- Постоянный цикл: не дает игре усадить вас, пока вы держите снаряд.
        -- Тренажеры-сиденья (жим, присед и т.д.) не затрагиваются — снаряд в руках не экипирован.
        task.spawn(function()
            while Config.WalkWhileTraining do
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

sectionLabel(trainingPage, "GYM MACHINES AUTO-FARM (БЛИЖАЙШИЙ ТРЕНАЖЕР)")

-- Общий движок фарма на тренажере:
--  * серверное подключение: machineInteractRemote:InvokeServer("useMachine", seat)
--  * rep шлётся с аргументом-сиденьем: muscleEvent:FireServer("rep", seat)
--  * чёрный список отказавших машин (60 сек), автоматический re-engage при разрыве
--  * для беговых дорожек (isTreadmill=true): просто стоит на treadmillPart
local function startMachineFarm(configKey, keywords, isTreadmill)
    task.spawn(function()
        local mModel, mSeat, lastFind = nil, nil, 0
        local blacklist = {}
        while Config[configKey] do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local now = tick()
                local inUse = getMachineInUse()

                local needFind = false
                if not mModel or not mModel.Parent then
                    needFind = true
                elseif (not isTreadmill) and mSeat ~= nil and inUse ~= mSeat then
                    needFind = true -- связь с тренажёром потеряна — переподключаемся
                elseif (now - lastFind) > 1.5 then
                    local okPos, mPos = pcall(function() return mModel:GetPivot().Position end)
                    if okPos and (mPos - hrp.Position).Magnitude > 40 then
                        needFind = true -- унесло дальше 40 стадов — возвращаемся
                    else
                        lastFind = now
                    end
                end

                if needFind and (now - lastFind) > 0.5 then
                    local part, model = findNearestMachine(keywords, blacklist)
                    mModel = model or part
                    mSeat = nil
                    if mModel then
                        if isTreadmill then
                            mSeat = part
                        else
                            mSeat = getMachineSeat(mModel)
                            if not mSeat and part and part:IsA("Seat") then mSeat = part end
                            if mSeat then
                                local okEngage = engageMachine(mModel, mSeat)
                                if not okEngage then
                                    blacklist[mModel] = now + 60
                                    mModel, mSeat = nil, nil
                                end
                            end
                        end
                    end
                    lastFind = now
                end

                -- Позиционирование на беговой дорожке (сервер даёт ловкость за сам факт стояния)
                if isTreadmill and mModel and mSeat and mSeat.Parent then
                    pcall(function()
                        hrp.CFrame = mSeat.CFrame * CFrame.new(0, mSeat.Size.Y / 2 + 3, 0)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end)
                end

                local ev = getMuscleEvent()
                if ev and mModel and mModel.Parent then
                    local count = Config.UltraFastRep and (Config.FastRepMultiplier * 5) or Config.FastRepMultiplier
                    for _ = 1, count do
                        if (not isTreadmill) and mSeat then
                            ev:FireServer("rep", mSeat)
                        else
                            ev:FireServer("rep")
                        end
                    end
                end
            end
            task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.05)
        end
        pcall(leaveMachine)
    end)
end

createToggle(trainingPage, "Auto Bench Press (Жим лежа)", "Садится на ближайший жим лежа 1 раз и качает грудь!", Config.AutoBenchPress, function(v)
    Config.AutoBenchPress = v
    if v then
        startMachineFarm("AutoBenchPress", {"bench", "benchpress", "bench press"})
    end
end)

createToggle(trainingPage, "Auto Squat Rack (Приседания)", "Садится на ближайшую стойку приседаний 1 раз и качает ноги!", Config.AutoSquat, function(v)
    Config.AutoSquat = v
    if v then
        startMachineFarm("AutoSquat", {"squat", "squatrack", "squat rack"})
    end
end)

createToggle(trainingPage, "Auto Treadmill (Беговая дорожка)", "Встает на ближайшую беговую дорожку и качает ловкость!", Config.AutoTreadmillMachine, function(v)
    Config.AutoTreadmillMachine = v
    if v then
        startMachineFarm("AutoTreadmillMachine", {"treadmill", "tread"}, true)
    end
end)

createToggle(trainingPage, "Auto Pull-ups (Подтягивания)", "Встает к ближайшему турнику 1 раз и подтягивается!", Config.AutoPullups, function(v)
    Config.AutoPullups = v
    if v then
        startMachineFarm("AutoPullups", {"pullup", "pull-up", "pull up", "bar"})
    end
end)

createToggle(trainingPage, "Auto Boulder Throw (Бросок валуна)", "Подходит к валуну 1 раз и качает броски!", Config.AutoBoulder, function(v)
    Config.AutoBoulder = v
    if v then
        startMachineFarm("AutoBoulder", {"boulder", "boulderthrow", "boulder throw"})
    end
end)

createToggle(trainingPage, "Auto Rock Farm (Камень)", "Телепортируется к ближайшему камню 1 раз и непрерывно бьет!", Config.AutoRockMachine, function(v)
    Config.AutoRockMachine = v
    if v then
        task.spawn(function()
            local rockPart, lastScan, lastTP = nil, 0, 0
            while Config.AutoRockMachine do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if (tick() - lastScan) > 2 then
                        rockPart = getTargetRockPart("Any")
                        lastScan = tick()
                    end
                    if rockPart and rockPart.Parent and (tick() - lastTP) > 2
                        and (rockPart.Position - hrp.Position).Magnitude > 8 then
                        hrp.CFrame = CFrame.lookAt(rockPart.Position + Vector3.new(0, 2, 4), rockPart.Position)
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        lastTP = tick()
                    end
                end
                trainTool("Punch")
                task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.05)
            end
        end)
    end
end)

createToggle(trainingPage, "ULTRA FAST INSTANT REP MODE (TURBO 100X)", "Ультра-скоростной режим: мгновенный спам ивентов качания без задержки!", Config.UltraFastRep, function(v)
    Config.UltraFastRep = v
    if v then
        notify("Vortex Turbo Farm", "Ultra-fast farm enabled! (100x Rep Spam)", 3)
    end
end)

createSlider(trainingPage, "Fast Rep Multiplier (1x-100x)", 1, 100, 10, function(v)
    Config.FastRepMultiplier = v
end, nil, "Ускоритель фарма: количество отправляемых пакетов качания за один раз (до 100x)")

createSlider(trainingPage, "Train Delay Speed (sec)", 0, 0.05, Config.TrainDelay, function(v)
    Config.TrainDelay = v
end, nil, "Задержка между повторами (0 = мгновенно)")

-- ============================================================
-- 4. РАЗДЕЛ: ROCKS & GYM MACHINES (ИСПРАВЛЕН ФАРМ КАМНЕЙ)
-- ============================================================
sectionLabel(rocksPage, "AUTO ROCK FARM ENGINE (FIXED)")
local RockInfoLabel = Instance.new("TextLabel", createGlassPanel(rocksPage, 34))
RockInfoLabel.BackgroundTransparency = 1; RockInfoLabel.Position = UDim2.new(0, 12, 0, 0); RockInfoLabel.Size = UDim2.new(1, -24, 1, 0)
RockInfoLabel.Font = Enum.Font.GothamBold; RockInfoLabel.TextColor3 = AccentColor; RockInfoLabel.TextSize = 11; RockInfoLabel.TextXAlignment = Enum.TextXAlignment.Left; CollectionService:AddTag(RockInfoLabel, "AccentText")
RockInfoLabel.Text = "Selected Rock Tier: Any"

createToggle(rocksPage, "Auto Farm Selected Rock", "Телепортируется к камню 1 раз и непрерывно бьет!", Config.AutoRock, function(v)
    Config.AutoRock = v
    if v then
        task.spawn(function()
            local rockPart, lastScan, lastTP = nil, 0, 0
            while Config.AutoRock do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if (tick() - lastScan) > 2 then
                        rockPart = getTargetRockPart(Config.SelectedRockTier)
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

                    local ev = getMuscleEvent()
                    if ev then
                        ev:FireServer("punch", "leftHand")
                        ev:FireServer("punch", "rightHand")
                        for i = 1, Config.FastRepMultiplier do
                            ev:FireServer("rep")
                        end
                    end
                end
                task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.05)
            end
        end)
    end
end)

createToggle(rocksPage, "Auto Treadmill Farm (Agility)", "Телепортируется на беговую дорожку 1 раз и качает ловкость!", Config.AutoTreadmill, function(v)
    Config.AutoTreadmill = v
    if v then
        task.spawn(function()
            local treadPart, lastScan, lastTP = nil, 0, 0
            while Config.AutoTreadmill do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not treadPart or not treadPart.Parent or (tick() - lastScan) > 5 then
                        treadPart = findNearestMachine({"treadmill", "tread"})
                        lastScan = tick()
                    end
                    if treadPart and treadPart.Parent and (tick() - lastTP) > 2
                        and (treadPart.Position - hrp.Position).Magnitude > 8 then
                        safeTeleport(treadPart.CFrame * CFrame.new(0, 3, 0))
                        lastTP = tick()
                    end
                end
                local ev = getMuscleEvent()
                if ev then ev:FireServer("rep") end
                task.wait(Config.TrainDelay > 0 and Config.TrainDelay or 0.05)
            end
        end)
    end
end)

sectionLabel(rocksPage, "SELECT ROCK TIER")
for _, rData in ipairs(rockTiers) do
    createButton(rocksPage, rData[1], function()
        return t("Выбрать ", "Select ") .. rData[1] .. t(" для фарминга", " for farming")
            .. " (" .. rData[2] .. ")"
    end, function()
        Config.SelectedRockTier = rData[3]
        RockInfoLabel.Text = "Selected Rock Tier: " .. rData[1] .. " (" .. rData[2] .. ")"
        notify("Vortex Rock", "Selected rock tier: " .. rData[1], 2)
    end)
end

-- ============================================================
-- 5. РАЗДЕЛ: COMBAT & KILLAURA
-- ============================================================
sectionLabel(combatPage, "ADVANCED KILL AURA ENGINE (BRING & BEAT)")

local KillAuraStatusLabel = Instance.new("TextLabel", createGlassPanel(combatPage, 34))
KillAuraStatusLabel.BackgroundTransparency = 1; KillAuraStatusLabel.Position = UDim2.new(0, 12, 0, 0); KillAuraStatusLabel.Size = UDim2.new(1, -24, 1, 0)
KillAuraStatusLabel.Font = Enum.Font.GothamBold; KillAuraStatusLabel.TextColor3 = AccentColor; KillAuraStatusLabel.TextSize = 11; KillAuraStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; CollectionService:AddTag(KillAuraStatusLabel, "AccentText")
KillAuraStatusLabel.Text = "Kill Aura Mode: Bring To Me"

createButton(combatPage, "Mode 1: Bring Target To Me (Телепортировать врага к себе)", "Притягивает/телепортирует корпус врага прямо перед вашими кулаками и бьет!", function()
    Config.KillAuraMode = "Bring To Me"
    KillAuraStatusLabel.Text = "Kill Aura Mode: Bring To Me"
    notify("Vortex Killaura", "Mode: pull enemies to me and beat them!", 2)
end)

createButton(combatPage, "Mode 2: Magnet TP To Target (Телепортироваться к врагу)", "Мгновенно телепортирует вас за спину / в лицо врагу и наносит удары", function()
    Config.KillAuraMode = "Magnet TP to Target"
    KillAuraStatusLabel.Text = "Kill Aura Mode: Magnet TP To Target"
    notify("Vortex Killaura", "Mode: teleport to enemies and beat them!", 2)
end)

createButton(combatPage, "Mode 3: Orbit Target (Орбита вокруг цели)", "Вращается по кругу вокруг цели и наносит серии ударов", function()
    Config.KillAuraMode = "Orbit Target"
    KillAuraStatusLabel.Text = "Kill Aura Mode: Orbit Target"
    notify("Vortex Killaura", "Mode: orbit around enemies!", 2)
end)

createToggle(combatPage, "Enable Kill Aura (Auto Hit & Teleport)", "Активирует Kill Aura: бьет, телепортирует врагов прямо к вам или телепортируется к ним!", Config.KillAura, function(v)
    Config.KillAura = v
    if v then
        task.spawn(function()
            local angle = 0
            while Config.KillAura do
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

                        local ev = getMuscleEvent()

                        for _, otherPlayer in pairs(Players:GetPlayers()) do
                            if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                                local oChar = otherPlayer.Character
                                local oHrp = oChar:FindFirstChild("HumanoidRootPart")
                                local oHum = oChar:FindFirstChildOfClass("Humanoid")
                                local ff = oChar:FindFirstChildOfClass("ForceField")

                                if oHrp and oHum and oHum.Health > 0 and not ff then
                                    local dist = (oHrp.Position - myHrp.Position).Magnitude
                                    if dist <= Config.KillAuraRange then
                                        if ev then
                                            for i = 1, Config.PunchMultiplier do
                                                ev:FireServer("punch", "leftHand")
                                                ev:FireServer("punch", "rightHand")
                                            end
                                        end

                                        if Config.KillAuraMode == "Bring To Me" then
                                            -- сервер не позволяет двигать чужого игрока —
                                            -- телепортируемся сами вплотную перед целью и бьём
                                            pcall(function()
                                                myHrp.CFrame = CFrame.lookAt(
                                                    oHrp.Position - oHrp.CFrame.LookVector * 2.5 + Vector3.new(0, 1, 0),
                                                    oHrp.Position)
                                                myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                            end)
                                        elseif Config.KillAuraMode == "Magnet TP to Target" then
                                            safeTeleport(oHrp.CFrame * CFrame.new(0, 0, 2.5))
                                        elseif Config.KillAuraMode == "Orbit Target" then
                                            angle = angle + 0.3
                                            local offset = Vector3.new(math.sin(angle) * 4, 1, math.cos(angle) * 4)
                                            safeTeleport(CFrame.new(oHrp.Position + offset, oHrp.Position))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(Config.KillAuraDelay)
            end
        end)
    end
end)

createSlider(combatPage, "Kill Aura Range (Studs)", 5, 150, Config.KillAuraRange, function(v) Config.KillAuraRange = v end, nil, "Радиус в студах для обнаружения и телепортации врагов")
createSlider(combatPage, "Punch Hit Speed (ms)", 10, 100, 30, function(v) Config.KillAuraDelay = v / 1000 end, nil, "Задержка ударов в миллисекундах")
createSlider(combatPage, "Punch Event Multiplier (1x-10x)", 1, 10, 2, function(v) Config.PunchMultiplier = v end, nil, "Количество отправляемых пакетов ударов за итерацию")

sectionLabel(combatPage, "PLAYER TARGETING & SERVER DESTRUCTION")
local TargetInfoLbl = Instance.new("TextLabel", createGlassPanel(combatPage, 34))
TargetInfoLbl.BackgroundTransparency = 1; TargetInfoLbl.Position = UDim2.new(0, 12, 0, 0); TargetInfoLbl.Size = UDim2.new(1, -24, 1, 0)
TargetInfoLbl.Font = Enum.Font.GothamBold; TargetInfoLbl.TextColor3 = AccentColor; TargetInfoLbl.TextSize = 11; TargetInfoLbl.TextXAlignment = Enum.TextXAlignment.Left; CollectionService:AddTag(TargetInfoLbl, "AccentText")
TargetInfoLbl.Text = "Selected Target: None Selected"

createButton(combatPage, "Select Nearest Player as Target", "Выбирает ближайшего к вам игрока в качестве цели", function()
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
        Config.SelectedTargetPlayer = nearestP
        TargetInfoLbl.Text = "Selected Target: " .. nearestP.Name
        notify("Vortex Target", "Target selected: " .. nearestP.Name, 2)
    end
end)

createButton(combatPage, "Bring Selected Target to Me", "Притягивает выбранного игрока прямо к вашим кулакам", function()
    if Config.SelectedTargetPlayer and Config.SelectedTargetPlayer.Character and Config.SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            Config.SelectedTargetPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end)
        notify("Vortex Target", "Player pulled to you!", 2)
    end
end)

createToggle(combatPage, "Loop Kill Selected Target", "Непрерывно бьет и телепортирует выбранного игрока", Config.TargetLoopKill, function(v)
    Config.TargetLoopKill = v
    if v then
        task.spawn(function()
            while Config.TargetLoopKill do
                if Config.SelectedTargetPlayer and Config.SelectedTargetPlayer.Character and Config.SelectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local tHrp = Config.SelectedTargetPlayer.Character.HumanoidRootPart
                    local tHum = Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if tHum and tHum.Health > 0 then
                        safeTeleport(tHrp.CFrame * CFrame.new(0, 0, 2.5))
                        local ev = getMuscleEvent()
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

createToggle(combatPage, "Auto Kill Entire Server", "Зацикленный авто-телепорт по всем игрокам сервера и их уничтожение", Config.AutoKillServer, function(v)
    Config.AutoKillServer = v
    if v then
        task.spawn(function()
            while Config.AutoKillServer do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        local hrp = p.Character.HumanoidRootPart
                        local ff = p.Character:FindFirstChildOfClass("ForceField")

                        if hum.Health > 0 and not ff and Config.AutoKillServer then
                            safeTeleport(hrp.CFrame * CFrame.new(0, 0, 2.5))
                            local ev = getMuscleEvent()
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

createToggle(combatPage, "Auto Join & Win Brawls", "Авто-вход на Brawl турниры сервера и немедленная победа", Config.AutoBrawl, function(v)
    Config.AutoBrawl = v
    if v then
        task.spawn(function()
            while Config.AutoBrawl do
                local joinEvent = ReplicatedStorage:FindFirstChild("joinBrawl") or LocalPlayer:FindFirstChild("joinBrawl")
                if joinEvent then joinEvent:FireServer() end
                task.wait(2)
            end
        end)
    end
end)

sectionLabel(combatPage, "LEGEND BOSS KILLER ENGINE (GODMODE & FAST ATTACK)")

local BOSS_TARGET_FOLDERS = {
    "bossFolder", "BossFolder", "Bosses", "Boss", "bossIsland", "BossIsland",
    "worldboss", "WorldBoss", "eventBoss", "EventBoss",
    "enemies", "Enemies", "enemy", "Enemy", "mobs", "Mobs",
    "battleIsland", "BattleIsland", "warriors", "Warriors",
    "arena", "Arena", "raids", "Raids", "spawns", "Spawns",
}
local BOSS_NAME_KEYWORDS = {
    "boss", "босс", "evil", "king", "warrior", "brute", "titan",
    "champion", "monster", "giant", "fighter", "bandit", "enemy",
    "warlord", "overlord", "chief", "colossus", "juggernaut", "million",
    "overcharged", "zombie", "demon", "dragon", "alien", "skeleton",
    "golem", "gorilla", "shark", "phantom", "reaper", "behemoth",
}
local BOSS_NAME_EXCLUDES = {
    "statue", "portal", "gate", "leaderboard", "display", "decor",
    "island", "beach", "gym", "ring", "quest", "trainer", "merchant",
    "vendor", "shop", "guide", "villager", "pet", "animal", "rock",
    "bench", "squat", "tread", "pull", "boulder", "dummy",
}

-- Ищет модель с живым Humanoid, поднимаясь вверх от объекта
local function modelWithHumanoidFrom(inst)
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

local function getActiveBoss()
    local char = LocalPlayer.Character
    local myPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
    local bestModel, bestHum, bestHrp, bestScore, bestDist = nil, nil, nil, -1, math.huge

    -- Общая приёмка кандидата: score — приоритет источника (3=billboard, 2=папка, 1=имя)
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
        for _, ex in ipairs(BOSS_NAME_EXCLUDES) do
            if string.find(n, ex) then return false end
        end
        for _, kw in ipairs(BOSS_NAME_KEYWORDS) do
            if string.find(n, kw) then return true end
        end
        return false
    end

    -- 1) BillboardGui с надписью Boss/HP над головой — самый точный признак
    for _, bb in ipairs(Workspace:GetDescendants()) do
        if bb:IsA("BillboardGui") then
            local txt = ""
            for _, tl in ipairs(bb:GetDescendants()) do
                if tl:IsA("TextLabel") and type(tl.Text) == "string" then
                    txt = txt .. " " .. tl.Text
                end
            end
            txt = string.lower(txt)
            local isBossText = string.find(txt, "boss") or string.find(txt, "босс")
            local isHpText = string.find(txt, "%d+%s*/%s*%d+")
            if isBossText or isHpText then
                local root = bb.Adornee or bb.Parent
                local model = modelWithHumanoidFrom(root)
                if model then
                    if isBossText then
                        accept(model, 3)
                    else
                        -- HP-бар без слова Boss: пропускаем только если имя не похоже на декор/снаряд
                        local n = string.lower(model.Name)
                        local okName = true
                        for _, ex in ipairs(BOSS_NAME_EXCLUDES) do
                            if string.find(n, ex) then okName = false break end
                        end
                        if okName then accept(model, 2) end
                    end
                end
            end
        end
    end

    -- 2) Игровые папки с врагами / боссами — РЕКУРСИВНЫЙ поиск (папка может быть вложенной)
    for _, fName in ipairs(BOSS_TARGET_FOLDERS) do
        local folder = Workspace:FindFirstChild(fName, true)
        if folder then
            for _, obj in pairs(folder:GetDescendants()) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                    local n = string.lower(obj.Name)
                    local okName = true
                    for _, ex in ipairs(BOSS_NAME_EXCLUDES) do
                        if string.find(n, ex) then okName = false break end
                    end
                    if okName then accept(obj, 2) end
                end
            end
        end
    end

    -- 3) Модели с ключевыми словами в имени по всему Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and namePasses(string.lower(obj.Name)) then
            accept(obj, 1)
        end
    end

    return bestModel, bestHum, bestHrp
end

createToggle(combatPage, "Auto Farm Boss (Godmode Safe TP & Fast Beat)", "Авто-фарм Босса: позиция у босса + без урона по вам + быстрая атака!", Config.AutoKillBoss, function(v)
    Config.AutoKillBoss = v
    if v then
        notify("Vortex Boss", tn("Авто-фарм Босса включен! Наведение...", "Boss auto farm enabled! Targeting..."), 3)
        task.spawn(function()
            local notifiedNoBoss = false
            local lastTargetName = nil
            local cachedBoss, cachedHum, cachedHrp, lastSearch = nil, nil, nil, 0
            while Config.AutoKillBoss do
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChildOfClass("Humanoid") then
                    local myHrp = myChar.HumanoidRootPart
                    local myHum = myChar:FindFirstChildOfClass("Humanoid")

                    for _, p in pairs(myChar:GetChildren()) do
                        if p:IsA("BasePart") then p.CanTouch = false end
                    end
                    myHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    myHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

                    -- пересканировать мир не чаще раза в секунду (кэш цели)
                    if (tick() - lastSearch) > 1
                        or not cachedBoss or not cachedBoss.Parent
                        or not cachedHum or cachedHum.Health <= 0 then
                        cachedBoss, cachedHum, cachedHrp = getActiveBoss()
                        lastSearch = tick()
                    end
                    local bossModel, bossHum, bossHrp = cachedBoss, cachedHum, cachedHrp

                    if bossModel and bossModel.Parent and bossHrp and bossHum and bossHum.Health > 0 then
                        notifiedNoBoss = false
                        if lastTargetName ~= bossModel.Name then
                            lastTargetName = bossModel.Name
                            notify("Vortex Boss", tn("Цель захвачена: ", "Target acquired: ") .. bossModel.Name, 3)
                        end

                        local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or myChar:FindFirstChild("Punch")
                        if punch and punch.Parent == LocalPlayer.Backpack then
                            myHum:EquipTool(punch)
                        end
                        if punch then pcall(function() punch:Activate() end) end

                        myHrp.CFrame = CFrame.lookAt(bossHrp.Position + (bossHrp.CFrame.LookVector * -2.5) + Vector3.new(0, 1, 0), bossHrp.Position)
                        myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

                        local ev = getMuscleEvent()
                        if ev then
                            for i = 1, Config.BossHitMultiplier do
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
                            notify("Vortex Boss", tn("Ожидание спавна Босса на карте...", "Waiting for boss spawn..."), 3)
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

createSlider(combatPage, "Boss Hit Multiplier (1x-20x)", 1, 20, 5, function(v)
    Config.BossHitMultiplier = v
end, nil, "Количество ударов по боссу за один цикл")

-- ============================================================
-- 6. РАЗДЕЛ: PROTECTION
-- ============================================================
sectionLabel(protectionPage, "SAFETY & DEFENSE MODS")
local antiConn
createToggle(protectionPage, "Godmode / Anti-Hit", "Отключает коллизии урона персонажа (защита от чужих ударов)", Config.AntiHit, function(v)
    Config.AntiHit = v
    if v then
        antiConn = RunService.Stepped:Connect(function()
            if Config.AntiHit and LocalPlayer.Character then
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
        table.insert(ScriptConnections, antiConn)
    else
        if antiConn then antiConn:Disconnect() end
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                if p:IsA("BasePart") then p.CanTouch = true end
            end
        end
    end
end)

createToggle(protectionPage, "Auto Low HP Sky Safe TP", "Автоматически телепортирует в небесную зону безопасности при падении HP ниже 25%", Config.AutoSafeTPLowHP, function(v)
    Config.AutoSafeTPLowHP = v
end)

createToggle(protectionPage, "Anti-Ragdoll & Stun", "Запрет падений и станов", Config.AntiRagdoll, function(v)
    Config.AntiRagdoll = v
    if v then
        task.spawn(function()
            while Config.AntiRagdoll do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
                task.wait(0.5)
            end
        end)
    end
end)

createToggle(protectionPage, "Anti-Knockback", "Отключает отбрасывание при ударах", Config.AntiKnockback, function(v)
    Config.AntiKnockback = v
end)

createButton(protectionPage, "Teleport to Sky Safe Zone", "Спавнит небесную платформу и телепортирует вас туда", function()
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
            p.Color = AccentColor
            p.Parent = Workspace
        end
        safeTeleport(CFrame.new(0, 5005, 0))
        notify("Vortex Safe Zone", "Teleported to the sky platform!", 3)
    end
end)

-- ============================================================
-- 7. РАЗДЕЛ: TELEPORTS & POINTS
-- ============================================================
sectionLabel(teleportsPage, "WORLD TELEPORTS")

local locationDisplayList = {
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

for _, loc in ipairs(locationDisplayList) do
    createButton(teleportsPage, loc[1], function()
        return t("Безопасный умный телепорт: ", "Safe smart teleport: ") .. loc[2]
    end, function()
        smartTeleportToIsland(loc[1])
    end)
end

sectionLabel(teleportsPage, "WAYPOINTS & PLAYER TELEPORT")
local WaypointLabel = Instance.new("TextLabel", createGlassPanel(teleportsPage, 34))
WaypointLabel.BackgroundTransparency = 1; WaypointLabel.Position = UDim2.new(0, 12, 0, 0); WaypointLabel.Size = UDim2.new(1, -24, 1, 0)
WaypointLabel.Font = Enum.Font.GothamBold; WaypointLabel.TextColor3 = AccentColor; WaypointLabel.TextSize = 11; WaypointLabel.TextXAlignment = Enum.TextXAlignment.Left; CollectionService:AddTag(WaypointLabel, "AccentText")
WaypointLabel.Text = "Saved Waypoint: None"

createButton(teleportsPage, "Save Current Position as Waypoint", "Сохраняет вашу текущую позицию в память", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Config.SavedWaypoint = LocalPlayer.Character.HumanoidRootPart.CFrame
        local p = Config.SavedWaypoint.Position
        WaypointLabel.Text = string.format("Saved Waypoint: (%.0f, %.0f, %.0f)", p.X, p.Y, p.Z)
        notify("Vortex Waypoint", "Position saved!", 2)
    end
end)

createButton(teleportsPage, "Teleport to Saved Waypoint", "Телепортирует на ранее сохраненную точку", function()
    if Config.SavedWaypoint then
        safeTeleport(Config.SavedWaypoint)
        notify("Vortex Waypoint", "Teleported to saved waypoint!", 2)
    else
        notify("Vortex Waypoint", "No saved waypoint!", 2)
    end
end)

createButton(teleportsPage, "Teleport to Strongest Player", "Телепортирует к игроку с максимальной силой на сервере", function()
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
        safeTeleport(topP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
        notify("Vortex TP", "Teleported to top player: " .. topP.Name, 2)
    end
end)

-- ============================================================
-- 8. РАЗДЕЛ: AUTOMATION & EGGS
-- ============================================================
sectionLabel(automationPage, "REBIRTH ENGINE (MUSCLE LEGENDS)")

-- Сохранение позиции перед ребиртом и возврат после телепорта на спавн
local rebirthRestoreActive = false

local function savePositionForRebirth()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.CFrame or nil
end

local function restorePositionAfterRebirth(savedCF)
    if not Config.StayAfterRebirth or not savedCF then return end
    if rebirthRestoreActive then return end
    rebirthRestoreActive = true
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
                    rebirthRestoreActive = false
                    return
                end
            end
            task.wait(0.2)
        end
        rebirthRestoreActive = false
    end)
end

local function triggerRebirth()
    local savedCF = savePositionForRebirth()
    local done = false

    -- 1. Канонический ремоут игры: rEvents.rebirthRemote:InvokeServer("rebirthRequest")
    pcall(function()
        local rb = getREvent("rebirthRemote")
        if rb and rb:IsA("RemoteFunction") then
            local res = rb:InvokeServer("rebirthRequest")
            if res == true then done = true end
        end
    end)

    -- 2. Фолбэк: muscleEvent
    if not done then
        local ev = getMuscleEvent()
        if ev then
            pcall(function() ev:FireServer("rebirthRequest") end)
            pcall(function() ev:FireServer("rebirth") end)
            pcall(function() ev:FireServer("requestRebirth") end)
        end
    end

    -- 3. Остальные ремоуты с "rebirth" в имени (только если основной не ответил)
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

    -- Возврат на исходную точку вместо спавна
    if Config.StayAfterRebirth then
        restorePositionAfterRebirth(savedCF)
    end
    return done
end

createToggle(automationPage, "Auto Rebirth (Бесконечный авто-ребирт)", "Автоматически выполняет перерождение сразу при достижении нужного количества силы", Config.AutoRebirth, function(v)
    Config.AutoRebirth = v
    if v then
        task.spawn(function()
            while Config.AutoRebirth do
                local char = LocalPlayer.Character
                local busy = (char and char:GetAttribute("IsRebirthing") == true)
                    or (LocalPlayer:GetAttribute("LastMapCFrame") ~= nil)
                if not busy then
                    triggerRebirth()
                end
                task.wait(0.4)
            end
        end)
    end
end)

createToggle(automationPage, "Stay In Place After Rebirth (Не телепортовать на спавн)", "Сохраняет вашу позицию до перерождения и возвращает вас обратно после него", Config.StayAfterRebirth, function(v)
    Config.StayAfterRebirth = v
    notify("Vortex Rebirth", v
        and tn("После ребирта вы останетесь на месте!", "After rebirth you will stay in place!")
        or tn("После ребирта будет обычный телепорт на спавн.", "Normal spawn teleport after rebirth."), 3)
end)

createButton(automationPage, "Manual Rebirth (Переродиться прямо сейчас)", "Принудительно запрашивает перерождение на сервере через все каналы", function()
    triggerRebirth()
    notify("Vortex Rebirth", tn("Запрос на перерождение отправлен!", "Rebirth requested!"), 2)
end)

sectionLabel(automationPage, "CHESTS & ORBS MAGNET")
createButton(automationPage, "Collect All Map Chests", "Авто-телепорт по всем сундукам карты и их сбор", function()
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(string.lower(obj.Name), "chest") then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                safeTeleport(part.CFrame)
                count = count + 1
                task.wait(0.3)
            end
        end
    end
    notify("Chests", "Chests collected: " .. tostring(count), 3)
end)

createToggle(automationPage, "Auto Collect Map Orbs", "Автоматически притягивает/собирает сферы со всей карты", Config.AutoCollectOrbs, function(v)
    Config.AutoCollectOrbs = v
    if v then
        task.spawn(function()
            while Config.AutoCollectOrbs do
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

sectionLabel(automationPage, "MASS EGG HATCHER (ДО 500 ЗА РАЗ)")

-- Динамический каталог кристаллов из самой игры (обновления не ломают список)
local function getCrystalCatalog()
    local names = {}
    pcall(function()
        local shared = ReplicatedStorage:WaitForChild("shared", 5)
        local catalogs = shared and shared:WaitForChild("catalogs", 5)
        local prices = catalogs and catalogs:WaitForChild("crystalPrices", 5)
        if prices then
            for _, entry in pairs(prices:GetChildren()) do
                table.insert(names, entry.Name)
            end
        end
    end)
    table.sort(names)
    if #names == 0 then names = crystalsList end
    return names
end

local function listContains(list, value)
    for _, v in ipairs(list) do
        if v == value then return true end
    end
    return false
end

local crystalCatalog = getCrystalCatalog()
if not listContains(crystalCatalog, Config.SelectedCrystal) then
    Config.SelectedCrystal = crystalCatalog[1] or "Blue Crystal"
end

local function getCrystalPrice(name)
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

-- Статус-строка: кристалл / места в инвентаре / гемы / текущее количество
local HatchStatusPanel = createGlassPanel(automationPage, 34)
local HatchStatusLabel = Instance.new("TextLabel", HatchStatusPanel)
HatchStatusLabel.BackgroundTransparency = 1
HatchStatusLabel.Position = UDim2.new(0, 12, 0, 0)
HatchStatusLabel.Size = UDim2.new(1, -24, 1, 0)
HatchStatusLabel.Font = Enum.Font.GothamBold
HatchStatusLabel.TextColor3 = Color3.fromRGB(241, 245, 249)
HatchStatusLabel.TextSize = 11
HatchStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local function refreshHatchStatus()
    local free, owned, cap = freePetSlots()
    local gems = getCurrency("Gems") or 0
    local slotText
    if free then
        slotText = t("места: ", "slots: ") .. owned .. "/" .. cap
            .. t(" (свободно ", " (free ") .. free .. ")"
    else
        slotText = t("петов: ", "pets: ") .. owned
            .. t(" (вместимость неизвестна — ограничение по отказу сервера)", " (capacity unknown — server denial will stop us)")
    end
    HatchStatusLabel.Text = t("Кристалл: ", "Crystal: ") .. Config.SelectedCrystal
        .. " | " .. slotText
        .. " | " .. t("Гемы: ", "Gems: ") .. tostring(gems)
        .. " | " .. t("Открыть: ", "Hatch: ") .. tostring(Config.HatchCount)
end

-- Проверка количества перед массовым открытием: 1..500, места в инвентаре, валюта
local function validateHatchCount(count)
    count = math.floor(tonumber(count) or 0)
    if count < 1 then
        return nil, tn("Минимум — 1 яйцо!", "Minimum is 1 egg!")
    end
    if count > 500 then
        return nil, tn("Максимум — 500 яиц за один раз!", "Maximum is 500 eggs at once!")
    end

    local free, owned, cap = freePetSlots()
    if free and count > free then
        return nil, string.format(
           tn("Свободно только %d мест (занято %d из %d), а запрошено %d! Уменьшите количество.",
              "Only %d free slots (used %d of %d) but %d requested! Reduce the amount."),
            free, owned, cap, count)
    end

    local price, kind = getCrystalPrice(Config.SelectedCrystal)
    if price and price > 0 then
        local balance = getCurrency(kind)
        if balance then
            if balance < price then
                return nil, string.format(
                   tn("Не хватает валюты: нужно %d %s, у вас %d.",
                      "Not enough currency: need %d %s, you have %d."),
                    price, kind or "Gems", balance)
            end
            local affordable = math.floor(balance / price)
            if count > affordable then
                return nil, string.format(
                   tn("Хватит только на %d из %d яиц (цена %d %s, баланс %d).",
                      "Enough for only %d of %d eggs (price %d %s, balance %d)."),
                    affordable, count, price, kind or "Gems", balance)
            end
        end
    end
    return count, nil
end

-- Массовое вылупление: count яиц подряд (отмена — повторным нажатием или Stop)
local hatchState = {running = false, cancel = false}

-- Точная причина отказа сервера при открытии
local function describeDenial()
    local free = freePetSlots()
    if free ~= nil and free <= 0 then
        return tn("сервер отказал: инвентарь питомцев полон — продайте или улучшите питомцев",
            "server denied: pet inventory is full — sell or upgrade pets")
    end
    local price, kind = getCrystalPrice(Config.SelectedCrystal)
    if price and price > 0 then
        local balance = getCurrency(kind)
        if balance and balance < price then
            return string.format(
               tn("сервер отказал: не хватает валюты (%s: нужно %d, есть %d)",
                  "server denied: not enough currency (%s: need %d, have %d)"),
                kind or "Gems", price, balance)
        end
    end
    return tn("сервер отказал: инвентарь полон или не хватает валюты",
        "server denied: inventory full or not enough currency")
end

-- ============================================================
-- Массовое открытие кристаллов (до 500 за раз)
-- ============================================================
local autoCrystalSync = nil -- синхронизация пилла тумблера при внешнем сбросе

local function hatchBatch(count)
    if hatchState.running then
        hatchState.cancel = true
        notify("Vortex Hatch", tn("Массовое вылупление останавливается...", "Stopping mass hatch..."), 2)
        return
    end
    local n, err = validateHatchCount(count)
    if not n then
        notify("Vortex Hatch", err, 5)
        return
    end

    if Config.AutoCrystal then
        Config.AutoCrystal = false -- сначала гасим авто-режим, чтобы не дублировать открытия
        if autoCrystalSync then autoCrystalSync(false) end
    end
    hatchState.running = true
    hatchState.cancel = false
    Config.HatchPower = true
    task.spawn(function()
        local opened = 0
        local failReason = nil
        local lastPetText = nil
        -- открываем строго дистанционно (без телепорта к кристаллу)
        for _ = 1, n do
            if hatchState.cancel or not Config.HatchPower then
                failReason = tn("остановлено пользователем", "stopped by user")
                break
            end
            local ok, petOrReason, rarity = openCrystalOnce(Config.SelectedCrystal)
            if ok then
                opened = opened + 1
                if type(petOrReason) == "string" then
                    lastPetText = petOrReason .. (rarity and (" (" .. tostring(rarity) .. ")") or "")
                end
            else
                if petOrReason == "denied" then
                    failReason = describeDenial()
                elseif petOrReason == "invokefail" then
                    failReason = tn("ошибка вызова openCrystalRemote",
                        "openCrystalRemote call failed")
                else
                    failReason = tn("ремоут openCrystalRemote не найден",
                        "openCrystalRemote not found")
                end
                break
            end
            if opened % 25 == 0 then refreshHatchStatus() end
            task.wait(Config.HatchDelay)
        end
        hatchState.running = false
        Config.HatchPower = false
        refreshHatchStatus()
        local msg = string.format(t("Открыто яиц: %d из %d", "Eggs opened: %d of %d"), opened, n)
        if lastPetText then
            msg = msg .. " | " .. t("последний: ", "last: ") .. lastPetText
        end
        if failReason then
            msg = msg .. " — " .. failReason
        end
        notify("Vortex Hatch", msg, 5)
    end)
end

createSlider(automationPage, "Eggs Per Batch (1-500)", 1, 500, Config.HatchCount, function(v)
    Config.HatchCount = math.floor(v)
    refreshHatchStatus()
end, nil, "Сколько яиц открывать за один Mass Hatch (максимум 500)")

local acCard, acSet
acCard, acSet = createToggle(automationPage, "Auto Hatch Selected Egg/Crystal", "Авто-открытие выбранного кристалла пока включено (остановка при отказе сервера)", Config.AutoCrystal, function(v)
    Config.AutoCrystal = v
    if v then
        if hatchState.running then
            Config.AutoCrystal = false
            if autoCrystalSync then autoCrystalSync(false) end
            notify("Vortex Hatch", tn("Идёт массовое вылупление — сначала остановите его (Stop).",
                "Mass hatch is running — stop it first (Stop)."), 4)
            return
        end
        -- открытие дистанционное, без телепорта
        task.spawn(function()
            while Config.AutoCrystal do
                local ok, reason = openCrystalOnce(Config.SelectedCrystal)
                if not ok then
                    Config.AutoCrystal = false
                    if autoCrystalSync then autoCrystalSync(false) end
                    local msg
                    if reason == "denied" then
                        msg = tn("Авто-вылупление остановлено: ", "Auto hatch stopped: ") .. describeDenial()
                    elseif reason == "invokefail" then
                        msg = tn("Авто-вылупление остановлено: ошибка вызова openCrystalRemote.",
                            "Auto hatch stopped: openCrystalRemote call failed.")
                    else
                        msg = tn("Авто-вылупление остановлено: ремоут openCrystalRemote не найден.",
                            "Auto hatch stopped: openCrystalRemote not found.")
                    end
                    notify("Vortex Hatch", msg, 5)
                    break
                end
                task.wait(Config.HatchDelay)
            end
            refreshHatchStatus()
        end)
    end
end, function(body)
    -- настройки прямо в popup: задержка между авто-открытиями
    createSlider(body, "Задержка между открытиями (0.01 сек)", 5, 100, math.floor(Config.HatchDelay * 100 + 0.5), function(v)
        Config.HatchDelay = math.floor(v) / 100
    end, nil, "12 = 0.12 секунды между открытиями (диапазон 0.05–1.00)")
end)
autoCrystalSync = acSet

createButton(automationPage, "MASS HATCH (открыть выбранное количество)", "Быстро открывает до 500 яиц подряд с проверкой мест в инвентаре и валюты", function()
    hatchBatch(Config.HatchCount)
end)

createButton(automationPage, "Hatch x10", "Быстро открывает 10 яиц подряд", function()
    hatchBatch(10)
end)

createButton(automationPage, "Hatch x1", "Открывает одно яйцо", function()
    hatchBatch(1)
end)

createButton(automationPage, "Stop Mass Hatch", "Останавливает идущее массовое вылупление", function()
    if hatchState.running then
        hatchState.cancel = true
        notify("Vortex Hatch", tn("Останавливаем массовое вылупление...", "Stopping mass hatch..."), 2)
    else
        notify("Vortex Hatch", tn("Сейчас ничего не открывается.", "Nothing is hatching right now."), 2)
    end
end)

sectionLabel(automationPage, "CRYSTAL SELECTOR (ВЫБОР КРИСТАЛЛА)")

-- Карточки-кристаллы: ЛКМ = выбрать (без popup), выбранный подсвечен акцентом + галочка
local crystalCards = {}

local function updateCrystalCards()
    for name, card in pairs(crystalCards) do
        local sel = (name == Config.SelectedCrystal)
        tw(card.stroke, {
            Color = sel and AccentColor or Color3.fromRGB(255, 255, 255),
            Transparency = sel and 0.35 or 0.94,
        }, 0.15):Play()
        tw(card.nameLbl, {TextColor3 = sel and AccentColor or Color3.fromRGB(241, 245, 249)}, 0.15):Play()
        tw(card.checkLbl, {TextTransparency = sel and 0 or 1}, 0.15):Play()
    end
end

for _, crystalName in ipairs(crystalCatalog) do
    local card = Instance.new("TextButton", automationPage)
    card.Name = "CrystalCard_" .. crystalName
    card.BackgroundColor3 = currentTheme().panel
    card.BackgroundTransparency = 0
    card.Size = UDim2.new(1, -10, 0, 42)
    card.AutoButtonColor = false
    card.Text = ""
    CollectionService:AddTag(card, "ThemePanel")
    applyCorner(card, 10)
    local cardStroke = applyStroke(card, Color3.fromRGB(255, 255, 255), 0.94, 1)

    card.MouseEnter:Connect(function()
        local base = currentTheme().panel
        tw(card, {BackgroundColor3 = Color3.new(
            math.min(1, base.R + 0.05), math.min(1, base.G + 0.05), math.min(1, base.B + 0.05)
        )}, 0.12):Play()
    end)
    card.MouseLeave:Connect(function()
        tw(card, {BackgroundColor3 = currentTheme().panel}, 0.15):Play()
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
        local price, kind = getCrystalPrice(crystalName)
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
    checkLbl.Text = "✓"
    checkLbl.TextColor3 = AccentColor
    checkLbl.TextSize = 14
    checkLbl.ZIndex = 2
    CollectionService:AddTag(checkLbl, "AccentText")
    checkLbl.TextTransparency = 1

    bindTooltip(card, t("Выбрать ", "Select ") .. crystalName .. t(" для открытия", " to open"))

    card.MouseButton1Click:Connect(function()
        Config.SelectedCrystal = crystalName
        refreshHatchStatus()
        updateCrystalCards()
        notify(tn("Кристалл выбран: ", "Crystal selected: ") .. crystalName, tn("Теперь его можно открывать кнопками ниже.", "You can now open it with the buttons above."), 2)
    end)

    crystalCards[crystalName] = {stroke = cardStroke, nameLbl = nameLbl, checkLbl = checkLbl}
end

updateCrystalCards()
refreshHatchStatus()

-- ============================================================
-- 9. РАЗДЕЛ: PETS & INVENTORY
-- ============================================================
sectionLabel(petsPage, "PET MANAGEMENT ENGINE")
createButton(petsPage, "Auto Evolve All Pets", "Автоматически объединяет одинаковых питомцев для эволюции", function()
    local ev = getMuscleEvent()
    if ev then ev:FireServer("evolvePetAll") end
    notify("Vortex Pets", "Evolution request sent!", 2)
end)

createButton(petsPage, "Equip Best Pets", "Автоматически надевает лучших питомцев в инвентаре", function()
    local ev = getMuscleEvent()
    if ev then ev:FireServer("equipBestPets") end
    notify("Vortex Pets", "Best pets equipped!", 2)
end)

createButton(petsPage, "Продать обычных питомцев", "Продаёт всех питомцев раритета Common, освобождая места для кристаллов", function()
    local ev = nil
    pcall(function() ev = getREvent("sellPetEvent") end)
    if not ev then
        notify("Vortex Pets", tn("Ремоут sellPetEvent не найден.", "sellPetEvent remote not found."), 4)
        return
    end
    local pf = LocalPlayer:FindFirstChild("petsFolder")
    if not pf then
        notify("Vortex Pets", tn("Папка питомцев не найдена.", "Pets folder not found."), 4)
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
        notify("Vortex Pets", tn("Обычных питомцев нет — продавать нечего.", "No common pets — nothing to sell."), 3)
        return
    end
    local sold = 0
    for _, pet in ipairs(toSell) do
        local ok = pcall(function() ev:FireServer("sellPet", pet) end)
        if ok then sold = sold + 1 end
        task.wait(0.05)
    end
    refreshHatchStatus()
    notify("Vortex Pets", string.format(tn("Продано обычных питомцев: %d", "Common pets sold: %d"), sold), 4)
end)

-- ============================================================
-- 10. РАЗДЕЛ: MOVEMENT & ESP
-- ============================================================
sectionLabel(movementPage, "FLIGHT & SPEED ENGINE")
createToggle(movementPage, "Fly Mode (WASD + Shift/Space)", "Режим свободного полета Vortex", Config.FlyEnabled, function(v)
    Config.FlyEnabled = v
    if v then startFlight() else stopFlight() end
end)
createSlider(movementPage, "Fly Speed", 20, 300, Config.FlySpeed, function(v) Config.FlySpeed = v end, nil, "Скорость полета в воздухе")

createToggle(movementPage, "Speed Hack", "Изменение скорости ходьбы", Config.SpeedHack, function(v)
    Config.SpeedHack = v
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider(movementPage, "WalkSpeed Value", 16, 300, Config.SpeedValue, function(v)
    Config.SpeedValue = v
    if Config.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end, nil, "Значение скорости ходьбы")

createToggle(movementPage, "Jump Power Hack", "Изменение высоты прыжка", Config.JumpPowerHack, function(v)
    Config.JumpPowerHack = v
end)
createSlider(movementPage, "Jump Power Value", 50, 450, Config.JumpPowerValue, function(v)
    Config.JumpPowerValue = v
    if Config.JumpPowerHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
    end
end, nil, "Сила высоты прыжка")

createSlider(movementPage, "Custom World Gravity", 0, 196, 196, function(v)
    Config.GravityValue = v
    Workspace.Gravity = v
end, nil, "Настройка гравитации игрового мира")

createToggle(movementPage, "Noclip", "Проход сквозь стены и объекты", Config.Noclip, function(v) Config.Noclip = v end)
createToggle(movementPage, "Infinite Jump", "Бесконечные прыжки в воздухе", Config.InfJump, function(v) Config.InfJump = v end)
createToggle(movementPage, "Bunny Hop", "Авто-прыжок при касании земли", Config.Bhop, function(v) Config.Bhop = v end)

-- Movement Render Loop
local moveConn = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if Config.Bhop and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            if Config.SpeedHack then
                hum.WalkSpeed = Config.SpeedValue
            end
            if Config.JumpPowerHack then
                hum.JumpPower = Config.JumpPowerValue
            end
        end
    end
end)
table.insert(ScriptConnections, moveConn)

sectionLabel(movementPage, "SPECTATE & VISUAL ESP")
createToggle(movementPage, "Spectate Target Player", "Режим наблюдения от первого/третьего лица за выбранной целью", Config.SpectateTarget, function(v)
    Config.SpectateTarget = v
    if v and Config.SelectedTargetPlayer and Config.SelectedTargetPlayer.Character and Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = Config.SelectedTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end)

local espDrawings = {} -- [Player] = Drawing.Text — создается один раз и переиспользуется

-- Определяется как присваивание: forward-декларация есть в начале скрипта
-- (нужна внутри completeScriptUnload)
clearESP = function()
    for playerKey, drawing in pairs(espDrawings) do
        if drawing then
            pcall(function() drawing.Visible = false end)
            pcall(function() drawing:Remove() end)
        end
        espDrawings[playerKey] = nil
    end
end

createToggle(movementPage, "Player NameTags ESP", "Показывает имена и дистанцию до игроков", Config.PlayerESP, function(v)
    Config.PlayerESP = v
    if v then
        if Drawing == nil or type(Drawing.new) ~= "function" then
            notify("Vortex ESP", "This injector does not support Drawing — ESP unavailable", 4)
            Config.PlayerESP = false
            return
        end
        task.spawn(function()
            while Config.PlayerESP do
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
                                local d = espDrawings[p]
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
                                        espDrawings[p] = d
                                    end
                                end
                                if d then
                                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                                    d.Text = p.Name .. " [" .. math.floor((hrp.Position - myHrp.Position).Magnitude) .. "m]"
                                    d.Position = Vector2.new(pos.X, pos.Y - 25)
                                    d.Color = AccentColor
                                    d.Visible = onScreen
                                end
                            end
                        end
                    end
                end

                -- чистим рисунки игроков, которых больше нет на сервере / они мертвы
                for p, d in pairs(espDrawings) do
                    if not seen[p] then
                        pcall(function() d.Visible = false end)
                        pcall(function() d:Remove() end)
                        espDrawings[p] = nil
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

createToggle(movementPage, "Full Bright", "Убирает тени на карте и включает день", Config.FullBright, function(v)
    Config.FullBright = v
    if v then
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1; Lighting.ClockTime = 12; Lighting.GlobalShadows = true
    end
end)

createSlider(movementPage, "Camera FOV", 40, 120, Config.CustomFOV, function(v)
    Config.CustomFOV = v
    Camera.FieldOfView = v
end, nil, "Угол обзора камеры")

sectionLabel(movementPage, "SERVER UTILS")
createButton(movementPage, "Rejoin Same Server", "Перезайти на этот же сервер", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

createButton(movementPage, "Server Hop (Random Server)", "Подключиться к случайному серверу", function()
    notify("Vortex Server", "Searching for server...", 2)
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

createButton(movementPage, "Copy JobID to Clipboard", "Копирует ID текущего сервера в буфер обмена", function()
    pcall(function() setclipboard(tostring(game.JobId)) end)
    notify("Vortex Server", "JobID copied to clipboard!", 2)
end)

-- ============================================================
-- РАЗДЕЛ: VISUALS (небо, след, эффект прыжка)
-- ============================================================
sectionLabel(visualsPage, "CUSTOM SKY")

local SKY_PRESETS = {
    {name = "Default", desc = function() return t("Стандартное дневное небо", "Standard daylight sky") end,
        timeOfDay = "14:00:00", ambient = Color3.fromRGB(128,128,128), outdoor = Color3.fromRGB(150,150,150), fog = Color3.fromRGB(190,200,215), fogEnd = 100000},
    {name = "Night", desc = function() return t("Тёмное ночное небо", "Dark night sky") end,
        timeOfDay = "00:00:00", ambient = Color3.fromRGB(30,35,60), outdoor = Color3.fromRGB(40,45,80), fog = Color3.fromRGB(10,12,25), fogEnd = 60000},
    {name = "Sunset", desc = function() return t("Оранжевый закат", "Orange sunset") end,
        timeOfDay = "18:30:00", ambient = Color3.fromRGB(140,90,70), outdoor = Color3.fromRGB(200,120,80), fog = Color3.fromRGB(230,140,90), fogEnd = 80000},
    {name = "Neon", desc = function() return t("Неоново-фиолетовая атмосфера", "Neon purple atmosphere") end,
        timeOfDay = "20:00:00", ambient = Color3.fromRGB(70,40,110), outdoor = Color3.fromRGB(90,50,150), fog = Color3.fromRGB(60,30,90), fogEnd = 50000},
    {name = "Cosmic", desc = function() return t("Космический красный", "Deep space red") end,
        timeOfDay = "02:00:00", ambient = Color3.fromRGB(80,25,35), outdoor = Color3.fromRGB(120,35,50), fog = Color3.fromRGB(50,10,20), fogEnd = 40000},
}

local function applySkyPreset(preset)
    local ok = pcall(function()
        Lighting.TimeOfDay = preset.timeOfDay
        Lighting.Ambient = preset.ambient
        Lighting.OutdoorAmbient = preset.outdoor
        Lighting.FogColor = preset.fog
        Lighting.FogEnd = preset.fogEnd
        Lighting.FogStart = 0
    end)
    if ok then
        Config.SkyMode = preset.name
        notify("Vortex Visuals", "Sky preset: " .. preset.name, 2)
    end
end

for _, preset in ipairs(SKY_PRESETS) do
    createButton(visualsPage, "Sky: " .. preset.name, preset.desc, function()
        applySkyPreset(preset)
    end)
end

sectionLabel(visualsPage, "TRAIL BEHIND PLAYER")

local activeTrail = nil
local activeTrailAttachments = {}

local function removeTrail()
    if activeTrail then pcall(function() activeTrail:Destroy() end) activeTrail = nil end
    for _, a in ipairs(activeTrailAttachments) do pcall(function() a:Destroy() end) end
    activeTrailAttachments = {}
end

local function createTrail(char)
    removeTrail()
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
        trail.Color = ColorSequence.new(AccentColor, Color3.fromRGB(255,255,255))
        trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1)})
        trail.Lifetime = tonumber(Config.TrailLifetime) or 0.6
        trail.LightEmission = 0.6
        trail.FaceCamera = true
        trail.Parent = hrp
        activeTrail = trail
        activeTrailAttachments = {a0, a1}
    end)
end

local trailLoopConn = nil
createToggle(visualsPage, "Player Trail", "Яркий след за персонажем (цвет акцента интерфейса)", Config.TrailEnabled, function(v)
    Config.TrailEnabled = v
    if v then
        createTrail(LocalPlayer.Character)
        if not trailLoopConn then
            trailLoopConn = task.spawn(function()
                while Config.TrailEnabled do
                    task.wait(1)
                    if Config.TrailEnabled and (not activeTrail or not activeTrail.Parent) then
                        createTrail(LocalPlayer.Character)
                    end
                end
            end)
        end
    else
        removeTrail()
    end
end)

createSlider(visualsPage, "Trail Length (sec)", 2, 20, math.floor((tonumber(Config.TrailLifetime) or 0.6) * 10 + 0.5), function(v)
    Config.TrailLifetime = v / 10
    if activeTrail then activeTrail.Lifetime = Config.TrailLifetime end
end, nil, "Длина затухания следа (0.2 - 2.0 секунды)")

sectionLabel(visualsPage, "JUMP EFFECT")

local function spawnJumpRing(pos)
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
        ring.Color = AccentColor
        ring.Transparency = 0.25
        ring.Parent = Workspace
        tw(ring, {Size = Vector3.new(0.2, 9, 9), Transparency = 1}, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
        game:GetService("Debris"):AddItem(ring, 0.5)
    end)
end

local function bindJumpRing(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum:GetAttribute("VortexRingBound") then return end
    hum:SetAttribute("VortexRingBound", true)
    hum.StateChanged:Connect(function(_, newState)
        if Config.JumpRing and newState == Enum.HumanoidStateType.Jumping then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then spawnJumpRing(hrp.Position - Vector3.new(0, 2.5, 0)) end
        end
    end)
end

local jumpCharConn = nil
createToggle(visualsPage, "Jump Ring Effect", "Неоновое кольцо под ногами при каждом прыжке", Config.JumpRing, function(v)
    Config.JumpRing = v
    if v then
        if LocalPlayer.Character then bindJumpRing(LocalPlayer.Character) end
        if not jumpCharConn then
            jumpCharConn = LocalPlayer.CharacterAdded:Connect(bindJumpRing)
        end
    else
        if jumpCharConn then jumpCharConn:Disconnect() jumpCharConn = nil end
    end
end)

-- ============================================================
-- РАЗДЕЛ: ABOUT (владелец и поддержка)
-- ============================================================
sectionLabel(aboutPage, "VORTEX SCRIPT")

local aboutPanel = createGlassPanel(aboutPage, 96)
local aboutText = Instance.new("TextLabel", aboutPanel)
aboutText.BackgroundTransparency = 1
aboutText.Position = UDim2.new(0, 12, 0, 8)
aboutText.Size = UDim2.new(1, -24, 1, -16)
aboutText.Font = Enum.Font.GothamMedium
aboutText.TextColor3 = Color3.fromRGB(241,245,249)
aboutText.TextSize = 11
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.TextWrapped = true
aboutText.Text = "Vortex v0.23 — Muscle Legends Hub\nOwner: harin\nDiscord: harin\nMenu key: Right Shift"

createButton(aboutPage, "Owner: harin", "Владелец и разработчик скрипта Vortex", function()
    notify("Vortex", "Owner: harin", 3)
end)

createButton(aboutPage, "Discord: harin", "Нажмите, чтобы скопировать Discord владельца в буфер обмена", function()
    local ok = pcall(function() setclipboard("harin") end)
    if ok then
        notify("Vortex", "Discord copied to clipboard!", 3)
    else
        notify("Vortex", "Discord: harin", 3)
    end
end)

-- ============================================================
-- ЗАГРУЗКА, АНИМАЦИИ ОТКРЫТИЯ/ЗАКРЫТИЯ МЕНЮ И КЛАВИША (Right Shift)
-- ============================================================
switchTab("ClickGUI")

local loadingDone = false

local function openMenu()
    if guiVisible or isAnimating then return end
    isAnimating = true
    guiVisible = true
    MainFrame.Position = UDim2.new(menuTargetPos.X.Scale, menuTargetPos.X.Offset, menuTargetPos.Y.Scale, menuTargetPos.Y.Offset + 24)
    menuScale.Scale = 0.95
    MainFrame.Visible = true
    OpenBtn.Visible = false
    tw(MainFrame, {Position = menuTargetPos}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
    local s = tw(menuScale, {Scale = 1}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    s:Play()
    s.Completed:Connect(function() isAnimating = false end)
end

local function closeMenu()
    if not guiVisible or isAnimating then return end
    isAnimating = true
    guiVisible = false
    if FuncPopupLayer.Visible then closeFuncPopup() end
    tw(MainFrame, {Position = UDim2.new(menuTargetPos.X.Scale, menuTargetPos.X.Offset, menuTargetPos.Y.Scale, menuTargetPos.Y.Offset + 24)}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
    local s = tw(menuScale, {Scale = 0.95}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    s:Play()
    s.Completed:Connect(function()
        MainFrame.Visible = false
        MainFrame.Position = menuTargetPos
        OpenBtn.Visible = true
        isAnimating = false
    end)
end

local function toggleMenu()
    if not loadingDone then return end
    if guiVisible then closeMenu() else openMenu() end
end

CloseHeaderBtn.MouseButton1Click:Connect(closeMenu)
OpenBtn.MouseButton1Click:Connect(toggleMenu)

local mainKeyConn = UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)
table.insert(ScriptConnections, mainKeyConn)

-- Экран загрузки: прогресс-бар + статусы, затем плавный вход в меню
local function playLoadingSequence()
    -- мягкий въезд карточки загрузки
    LoadModal.GroupTransparency = 1
    LoadModal.Position = UDim2.new(0, 18, 0, 6)
    tw(LoadModal, {GroupTransparency = 0}, 0.35, Enum.EasingStyle.Quint):Play()
    tw(LoadModal, {Position = UDim2.new(0, 18, 0, 18)}, 0.35, Enum.EasingStyle.Quint):Play()
    task.wait(0.3)

    local steps = {
        t("Инициализация ядра...", "Initializing core..."),
        t("Загрузка модулей...", "Loading modules..."),
        t("Подготовка интерфейса...", "Preparing interface..."),
        t("Готово! Открываем меню...", "Ready! Opening menu..."),
    }
    local total = 2.4
    local startT = tick()
    while (tick() - startT) < total do
        local p = math.clamp((tick() - startT) / total, 0, 1)
        LoadBarFill.Size = UDim2.new(p, 0, 1, 0)
        LoadPercent.Text = math.floor(p * 100) .. "%"
        local idx = math.min(#steps, math.floor(p * (#steps - 1)) + 1)
        LoadStatus.Text = steps[idx]
        task.wait(0.03)
    end
    LoadBarFill.Size = UDim2.new(1, 0, 1, 0)
    LoadPercent.Text = "100%"
    LoadStatus.Text = steps[#steps]
    task.wait(0.45)

    -- плавный уход карточки загрузки
    tw(LoadModal, {GroupTransparency = 1}, 0.3, Enum.EasingStyle.Quint):Play()
    tw(LoadModal, {Position = UDim2.new(0, 18, 0, -14)}, 0.3, Enum.EasingStyle.Quint):Play()
    task.wait(0.32)
    LoadModal.Visible = false
    loadingDone = true
    openMenu()
    OpenBtn.Visible = false
    notify("Vortex 0.23", tn("Загрузка завершена! Меню: [Right Shift]",
        "Loaded! Menu: [Right Shift]"), 5)
end
task.spawn(function()
    local ok, err = pcall(playLoadingSequence)
    if not ok then
        warn("[Vortex STAGE Z]: ошибка анимации загрузки: " .. tostring(err))
        pcall(function()
            LoadModal.Visible = false
            loadingDone = true
            openMenu()
        end)
        if not guiVisible then pcall(function() OpenBtn.Visible = true end) end
    end
end)

-- Страховка: если по любой причине меню не открылось за 8 секунд — открываем принудительно
task.delay(8, function()
    if not loadingDone then
        warn("[Vortex STAGE Z]: таймаут загрузки — принудительное открытие меню")
        pcall(function()
            LoadModal.Visible = false
            loadingDone = true
            if not guiVisible then openMenu() end
        end)
    end
    -- Финальная проверка: если меню так и не видно — хотя бы покажем кнопку открытия
    task.wait(0.5)
    pcall(function()
        if not (MainFrame.Visible and guiVisible) and not OpenBtn.Visible then
            warn("[Vortex STAGE Z]: меню не отображается — показываю кнопку OpenBtn")
            OpenBtn.Visible = true
        end
    end)
end)

print("[Vortex STAGE Z]: ЗАГРУЗКА ЗАВЕРШЕНА — экран загрузки анимирован, меню откроется автоматически (меню: RightShift)")
print("[Vortex Glass UI Engine v0.23]: Muscle Legends Hub loaded successfully!")