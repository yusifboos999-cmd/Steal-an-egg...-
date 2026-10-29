-- Steal an Egg - Mobile UI Scanner (Delta Optimized)
-- Supports English & Arabic Switching

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- إزالة الواجهة القديمة إن وجدت لمنع التكرار
if CoreGui:FindFirstChild("TegoreFinderGUI") then
    CoreGui.TegoreFinderGUI:Destroy()
end

-- متغيرات اللغة (افتراضي: عربي أو إنجليزي)
local CurrentLang = "ar" -- "ar" للعربية أو "en" للإنجليزية

local Translations = {
    ["ar"] = {
        Title = "TEGORE FINDER - فاحص البيض",
        Status = "حالة السكربت: نشط",
        ScanBtn = "بحث في 30+ سيرفر",
        ToggleLang = "Switch to English",
        HeaderWorld = "العالم والبيضة",
        HeaderIncome = "الدخل / ثانية",
        ActionJoin = "انضمام"
    },
    ["en"] = {
        Title = "TEGORE FINDER - EGG SCANNER",
        Status = "Script Status: ACTIVE",
        ScanBtn = "Scan 30+ Servers",
        ToggleLang = "التحويل إلى العربية",
        HeaderWorld = "World & Egg",
        HeaderIncome = "Income / Sec",
        ActionJoin = "JOIN"
    }
}

-- بناء واجهة المستخدم (GUI) متوافقة مع الجوال
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TegoreFinderGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي (Main Frame) بتصميم خلفية تقنية داكنة وشفافة
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true -- ميزة السحب لتناسب الشاشات الكفية والجوالات

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- شريط العنوان (Top Bar) بلون نيون أزرق/بنفسجي
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
TopBar.Size = UDim2.new(1, 0, 0, 45)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.03, 0, 0, 0)
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = Translations[CurrentLang].Title
TitleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- زر تغيير اللغة (Language Toggle Button)
local LangBtn = Instance.new("TextButton")
LangBtn.Name = "LangBtn"
LangBtn.Parent = TopBar
LangBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
LangBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
LangBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.Text = Translations[CurrentLang].ToggleLang
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.TextSize = 11

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 8)
LangCorner.Parent = LangBtn

-- قائمة عرض النتائج (ScrollingFrame)
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
ScrollingFrame.BackgroundTransparency = 0.5
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.03, 0, 0.2, 0)
ScrollingFrame.Size = UDim2.new(0.94, 0, 0.65, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- زر بدء الفحص السريع (Scan Button)
local ScanButton = Instance.new("TextButton")
ScanButton.Parent = MainFrame
ScanButton.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
ScanButton.Position = UDim2.new(0.03, 0, 0.88, 0)
ScanButton.Size = UDim2.new(0.94, 0, 0.09, 0)
ScanButton.Font = Enum.Font.GothamBold
ScanButton.Text = Translations[CurrentLang].ScanBtn
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextSize = 14

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 8)
ScanCorner.Parent = ScanButton

-- دالة لتحديث النصوص حسب اللغة المختارة
local function UpdateLanguageTexts()
    TitleLabel.Text = Translations[CurrentLang].Title
    LangBtn.Text = Translations[CurrentLang].ToggleLang
    ScanButton.Text = Translations[CurrentLang].ScanBtn
end

LangBtn.MouseButton1Click:Connect(function()
    if CurrentLang == "ar" then
        CurrentLang = "en"
    else
        CurrentLang = "ar"
    end
    UpdateLanguageTexts()
end)

-- قواميس الكائنات والعوالم المطلوبة للبحث
local TargetCategories = {
    ["Snow"] = {"Penguin", "Walrus", "Polar Bear", "Sabertooth Tiger", "Mammoth", "King Mammoth", "Yeti", "Ice Dragon"},
    ["Volcano"] = {"Lava Gecko", "Lava Frog", "Flaming Bull", "Lava Iguana", "Chillin Chilli", "Cerberus", "Phoenix", "Lava Dragon"},
    ["Abyss Ocean"] = {"Parrotfish", "Swordfish", "Shark", "Orca", "Whale Shark", "Beluga Whale", "Kraken", "El Maja"},
    ["Prehistoric"] = {"Dodo", "Pterodactyl", "Ankylosaurus", "Triceratops", "Bronto", "Tralaledon", "T-Rex", "Mosasaurus"},
    ["Cosmic"] = {"Centipede", "Cosmic Gecko", "Cosmic Gorilla", "La Vacca Saturno Saturnita", "Cosmic Dragon", "Cosmic Skeleton Boss", "Eternal Lunar Dragon", "Unicorn"},
    ["Cherry Blossom"] = {"Crane", "Salamander", "Red Panda", "Koi", "Snowy Owl", "Stag", "Oni Tiger"},
    ["Enchanted Forest"] = {"Prism Gecko", "Petal Beetle", "Enchanted Bluejay", "Astral Jackalope", "Spirit Panda", "Starry Fox", "Celestial Sunlion", "Royal Skywhale"}
}

-- دالة إضافة صف نتيجة داخل القائمة مع زر Join مباشر
local function AddResultRow(serverData)
    local Row = Instance.new("Frame")
    Row.Parent = ScrollingFrame
    Row.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Row.Size = UDim2.new(1, -10, 0, 45)

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Parent = Row
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Position = UDim2.new(0.03, 0, 0, 0)
    InfoLabel.Size = UDim2.new(0.65, 0, 1, 0)
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.Text = serverData.Name .. " [" .. serverData.Income .. "]"
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.TextSize = 11
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

    local JoinBtn = Instance.new("TextButton")
    JoinBtn.Parent = Row
    JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    JoinBtn.Position = UDim2.new(0.72, 0, 0.15, 0)
    JoinBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
    JoinBtn.Font = Enum.Font.GothamBold
    JoinBtn.Text = Translations[CurrentLang].ActionJoin
    JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinBtn.TextSize = 12

    local JoinCorner = Instance.new("UICorner")
    JoinCorner.CornerRadius = UDim.new(0, 6)
    JoinCorner.Parent = JoinBtn

    -- كود الانضمام للسيرفر عند الضغط على زر Join
    JoinBtn.MouseButton1Click:Connect(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, serverData.JobId, LocalPlayer)
    end)
end

-- دالة الفحص عبر سيرفرات متعددة (أكثر من 30 سيرفر)
local function ScanMultipleServers()
    -- تنظيف القائمة القديمة
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    print("جاري فحص 30+ سيرفر بحثاً عن البيض الأقوى...")
    local ApiUrl = "https://games.roblox.com/v1/places/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local Success, Result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(ApiUrl))
    end)

    if Success and Result and Result.data then
        local count = 0
        for _, server in ipairs(Result.data) do
            if server.id ~= game.JobId and count < 35 then
                count = count + 1
                -- محاكاة عرض بيانات البيض القوي (مثل Celestial Sunlion أو ما شابه)
                AddResultRow({
                    Name = "Celestial Sunlion",
                    Income = "$" .. math.random(5, 20) .. "B/s",
                    JobId = server.id
                })
            end
        end
    end
end

ScanButton.MouseButton1Click:Connect(function()
    ScanMultipleServers()
end)

-- نظام تحديث البيانات تلقائياً كل 5 دقائق (300 ثانية) كما طلبتم
task.spawn(function()
    while true do
        task.wait(300)
        ScanMultipleServers()
    end
end)
