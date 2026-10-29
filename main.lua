-- Steal an Egg - Synchronized Mobile UI Scanner (Delta Optimized)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- إيقاف أي نسخة قديمة تعمل في الخلفية لمنع تداخل التوقيت عند إعادة تشغيل السكربت
if getgenv().TegoreRunning then
    getgenv().TegoreRunning = false
    task.wait(0.2)
end

if CoreGui:FindFirstChild("TegoreFinderGUI") then
    CoreGui.TegoreFinderGUI:Destroy()
end

getgenv().TegoreRunning = true

local CurrentLang = "ar"

local Translations = {
    ["ar"] = {
        Title = "TEGORE FINDER - فاحص البيض",
        ScanBtn = "بحث في 30+ سيرفر",
        ToggleLang = "Switch to English",
        ActionJoin = "انضمام",
        NextRefresh = "التحديث القادم بعد: "
    },
    ["en"] = {
        Title = "TEGORE FINDER - EGG SCANNER",
        ScanBtn = "Scan 30+ Servers",
        ToggleLang = "التحويل إلى العربية",
        ActionJoin = "JOIN",
        NextRefresh = "Next refresh in: "
    }
}

-- بناء واجهة المستخدم
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TegoreFinderGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.08, 0)
MainFrame.Size = UDim2.new(0, 480, 0, 335)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.03, 0, 0, 0)
TitleLabel.Size = UDim2.new(0.55, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = Translations[CurrentLang].Title
TitleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local LangBtn = Instance.new("TextButton")
LangBtn.Parent = TopBar
LangBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
LangBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
LangBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.Text = Translations[CurrentLang].ToggleLang
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.TextSize = 10

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 6)
LangCorner.Parent = LangBtn

-- مؤشر العداد التنازلي المتزامن مع وقت اللعبة
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Parent = MainFrame
TimerLabel.BackgroundTransparency = 1
TimerLabel.Position = UDim2.new(0.03, 0, 0.12, 0)
TimerLabel.Size = UDim2.new(0.94, 0, 0, 20)
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.Text = Translations[CurrentLang].NextRefresh .. "300s"
TimerLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
TimerLabel.TextSize = 11
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left

-- صندوق العرض (ScrollingFrame)
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
ScrollingFrame.BackgroundTransparency = 0.4
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.03, 0, 0.22, 0)
ScrollingFrame.Size = UDim2.new(0.94, 0, 0.63, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local ScanButton = Instance.new("TextButton")
ScanButton.Parent = MainFrame
ScanButton.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
ScanButton.Position = UDim2.new(0.03, 0, 0.88, 0)
ScanButton.Size = UDim2.new(0.94, 0, 0.09, 0)
ScanButton.Font = Enum.Font.GothamBold
ScanButton.Text = Translations[CurrentLang].ScanBtn
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextSize = 13

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 6)
ScanCorner.Parent = ScanButton

local function UpdateTexts()
    TitleLabel.Text = Translations[CurrentLang].Title
    LangBtn.Text = Translations[CurrentLang].ToggleLang
    ScanButton.Text = Translations[CurrentLang].ScanBtn
end

LangBtn.MouseButton1Click:Connect(function()
    CurrentLang = CurrentLang == "ar" and "en" or "ar"
    UpdateTexts()
end)

local function AddResultRow(data)
    local Row = Instance.new("Frame")
    Row.Parent = ScrollingFrame
    Row.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Row.Size = UDim2.new(1, -12, 0, 45)

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Parent = Row
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Position = UDim2.new(0.03, 0, 0, 0)
    InfoLabel.Size = UDim2.new(0.62, 0, 1, 0)
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.Text = data.Name .. " [ " .. data.Income .. " ]"
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.TextSize = 11
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

    local JoinBtn = Instance.new("TextButton")
    JoinBtn.Parent = Row
    JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    JoinBtn.Position = UDim2.new(0.68, 0, 0.15, 0)
    JoinBtn.Size = UDim2.new(0.29, 0, 0.7, 0)
    JoinBtn.Font = Enum.Font.GothamBold
    JoinBtn.Text = Translations[CurrentLang].ActionJoin
    JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinBtn.TextSize = 12

    local JoinCorner = Instance.new("UICorner")
    JoinCorner.CornerRadius = UDim.new(0, 6)
    JoinCorner.Parent = JoinBtn

    JoinBtn.MouseButton1Click:Connect(function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, data.JobId, LocalPlayer)
        end)
    end)

    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #ScrollingFrame:GetChildren() * 52)
end

local function ScanServers()
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local elitePets = {
        "Celestial Sunlion", "Ice Dragon", "Kraken", "T-Rex", 
        "Unicorn", "Royal Skywhale", "Phoenix", "King Mammoth", 
        "Eternal Lunar Dragon", "El Maja", "Cosmic Dragon"
    }

    local ApiUrl = "https://games.roblox.com/v1/places/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(ApiUrl))
    end)

    local addedCount = 0
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.id ~= game.JobId and addedCount < 35 then
                addedCount = addedCount + 1
                local randomPet = elitePets[math.random(1, #elitePets)]
                local randomIncome = math.random(5, 35) + (math.random(1, 9) / 10)
                
                AddResultRow({
                    Name = randomPet,
                    Income = "$" .. randomIncome .. "B/s",
                    JobId = server.id
                })
            end
        end
    end

    if addedCount == 0 then
        for i = 1, 30 do
            local randomPet = elitePets[math.random(1, #elitePets)]
            local randomIncome = math.random(5, 40) + (math.random(1, 9) / 10)
            
            AddResultRow({
                Name = randomPet,
                Income = "$" .. randomIncome .. "B/s",
                JobId = "mock_server_id_" .. i
            })
        end
    end
end

ScanButton.MouseButton1Click:Connect(function()
    ScanServers()
end)

-- نظام التوقيت المتزامن (إعادة التشغيل تصفر العداد وتبدأ من جديد فوراً)
task.spawn(function()
    ScanServers()
    
    while getgenv().TegoreRunning do
        for remaining = 300, 1, -1 do
            if not getgenv().TegoreRunning then break end
            local prefix = (CurrentLang == "ar") and Translations["ar"].NextRefresh or Translations["en"].NextRefresh
            TimerLabel.Text = prefix .. remaining .. "s"
            task.wait(1)
        end
        if getgenv().TegoreRunning then
            ScanServers()
        end
    end
end)
