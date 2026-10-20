-- ==========================================
-- TUẤN VIP PRO MAX V1 - SLOW BONE COLLECTOR
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

if CoreGui:FindFirstChild("TuanProMaxGUI") then
    CoreGui.TuanProMaxGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TuanProMaxGUI"
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 0)
ToggleBtn.Text = "MENU"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 28)
ToggleCorner.Parent = ToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 400)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Kéo thả mượt mà trên mobile
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "✨ TUẤN VIP PRO MAX V1 ✨"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Title.TextColor3 = Color3.fromHSV(i, 1, 1)
            task.wait(0.05)
        end
    end
end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 300)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local function CreateButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
        callback(active)
    end)
end

_G.AutoBone = false
_G.SpeedMode = false
_G.FlyMode = false
_G.KillPlayer = false

-- 1. Auto Nhặt Xương (Đã làm chậm nhịp, đứng lại bấm tương tác liên tục cho chắc cú)
CreateButton("Auto Nhặt Xương (Bone): OFF", 10, function(state)
    _G.AutoBone = state
    task.spawn(function()
        while _G.AutoBone do
            task.wait(1.0) -- Tăng thời gian chờ vòng lặp để nhân vật đứng lại hẳn
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if not _G.AutoBone then break end
                    local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
                    if (v.Name:lower():find("bone") or v.Name:lower():find("xuong") or prompt) then
                        local targetPart = nil
                        if v:IsA("Model") then
                            targetPart = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                        elseif v:IsA("BasePart") then
                            targetPart = v
                        end
                        
                        if targetPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            -- Teleport tới sát cục xương
                            player.Character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                            
                            -- Kích hoạt chữ E liên tục trong 0.8 giây để game chắc chắn nhận lệnh lượm
                            for i = 1, 3 do
                                if not _G.AutoBone then break end
                                if prompt then
                                    fireproximityprompt(prompt)
                                else
                                    local foundPrompt = targetPart:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if foundPrompt then
                                        fireproximityprompt(foundPrompt)
                                    end
                                end
                                task.wait(0.25)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

CreateButton("Tốc Độ Siêu Tốc (Speed): OFF", 100, function(state)
    _G.SpeedMode = state
    task.spawn(function()
        while _G.SpeedMode do
            task.wait(0.5)
            pcall(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = 100
                end
            end)
        end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end)
end)

CreateButton("Tính Năng Bay (Fly): OFF", 110, function(state)
    _G.FlyMode = state
    if _G.FlyMode then
        pcall(function()
            local hrp = player.Character.HumanoidRootPart
            local bg = Instance.new("BodyGyro", hrp)
            local bv = Instance.new("BodyVelocity", hrp)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = hrp.CFrame
            bv.velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            
            task.spawn(function()
                while _G.FlyMode and player.Character and hrp do
                    task.wait()
                    bv.velocity = Workspace.CurrentCamera.CoordinateFrame.lookVector * 50
                    bg.cframe = Workspace.CurrentCamera.CoordinateFrame
                end
                bg:Destroy()
                bv:Destroy()
            end)
        end)
    end
end)

CreateButton("Càn Quét Player: OFF", 160, function(state)
    _G.KillPlayer = state
    task.spawn(function()
        while _G.KillPlayer do
            task.wait(0.5)
            pcall(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            local tool = player.Backpack:FindFirstOfClass("Tool") or player.Character:FindFirstOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end)
        end
    end)
end)

print("TUẤN VIP PRO MAX V1 - Đã làm chậm nhịp nhặt xương hoàn hảo!")
