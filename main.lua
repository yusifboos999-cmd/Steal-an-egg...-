-- Steal an Egg! Pro Script for Delta Executor
-- Developed for Mobile & High Performance

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- التحقق من عدم تكرار الواجهة
if CoreGui:FindFirstChild("StealAnEggProUI") then
    CoreGui.StealAnEggProUI:Destroy()
end

-- إنشاء واجهة المستخدم الرئيسية (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggProUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- زوايا دائرية للواجهة
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- شريط العنوان
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.Text = "  🥚 Steal an Egg! | Pro Hub"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 16
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- زر الإخفاء والإظهار (Toggle Button)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.1, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- دالة لإنشاء الأزرار التفاعلية
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- المتغيرات للتحكم بالخصائص
local autoStealEnabled = false
local espEnabled = false
local antiAfkEnabled = true

-- 1. خاصية السرقة التلقائية للبيض (Auto Steal / Collect Eggs)
createButton("Auto Steal Eggs: [ OFF ]", 60, function(sender)
    autoStealEnabled = not autoStealEnabled
    if autoStealEnabled then
        sender.Text = "Auto Steal Eggs: [ ON ]"
        sender.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        sender.Text = "Auto Steal Eggs: [ OFF ]"
        sender.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if autoStealEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj.Name:lower():find("nest")) then
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt and prompt.Parent then
                        -- الانتقال المؤقت نحو البيضة وتفعيل البرومبت
                        local oldPos = hrp.CFrame
                        hrp.CFrame = prompt.Parent.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                        fireproximityprompt(prompt)
                        task.wait(0.1)
                        hrp.CFrame = oldPos
                    end
                end
            end
        end
    end
end)

-- 2. كاشف البيض واللاعبين (ESP / Highlights)
createButton("Toggle ESP (Eggs & Players): [ OFF ]", 110, function(sender)
    espEnabled = not espEnabled
    if espEnabled then
        sender.Text = "Toggle ESP: [ ON ]"
        sender.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find("egg") and not obj:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "Highlight"
                hl.FillColor = Color3.fromRGB(255, 215, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = obj
            end
        end
    else
        sender.Text = "Toggle ESP: [ OFF ]"
        sender.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Highlight") and obj.Parent and obj.Parent.Name:lower():find("egg") then
                obj:Destroy()
            end
        end
    end
end)

-- 3. قفزة فائقة (Super Jump)
createButton("Super Jump: [ OFF ]", 160, function(sender)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.JumpPower == 50 then
            humanoid.JumpPower = 120
            sender.Text = "Super Jump: [ ON ]"
            sender.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        else
            humanoid.JumpPower = 50
            sender.Text = "Super Jump: [ OFF ]"
            sender.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        end
    end
end)

-- 4. القفز السيرفرات السريع (Server Hop) للبحث عن بيض سري (Secret / Mythic)
createButton("Quick Server Hop", 210, function()
    local HttpService = game:GetService("HttpService")
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/public?sortOrder=Asc&limit=100"))
    for _, srv in ipairs(Servers.data) do
        if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
            break
        end
    end
end)

-- 5. مانع الطرد للكسل (Anti-AFK) مدمج
local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if antiAfkEnabled then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFigure or workspace.CurrentCamera.CFrame)
    end
end)

createButton("Anti-AFK: [ ACTIVE ]", 260, function(sender)
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        sender.Text = "Anti-AFK: [ ACTIVE ]"
        sender.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        sender.Text = "Anti-AFK: [ OFF ]"
        sender.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end
end)

-- زر إغلاق الواجهة بالكامل
createButton("Close Script", 310, function()
    ScreenGui:Destroy()
end)
