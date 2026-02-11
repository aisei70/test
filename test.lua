local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- サービス取得
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- 初期設定
getgenv().KillAuraActive = false
getgenv().antiGrab = true
local ATTACK_RANGE = 25
local POWER = 10000
local SELECTED_MODE = "効果なし" 

-- FTAPイベント (掴み回避用)
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents", 5)
local StruggleEvent = CharacterEvents and CharacterEvents:FindFirstChild("Struggle")
local IsHeld = LocalPlayer:WaitForChild("IsHeld", 5)

-- メインウィンドウの作成
local Window = Rayfield:CreateWindow({
    Name = "⚡ものひとスクリプト & Anti-Grab",
    LoadingTitle = "Loading Blitz System...",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BlitzAuraConfig",
        FileName = "CombinedSettings"
    }
})

-- --- Main Settings タブ (Kill Aura) ---
local MainTab = Window:CreateTab("Main Settings", 4483362458)
MainTab:CreateSection("Kill Aura Controls")

MainTab:CreateToggle({
    Name = "Enable Kill Aura",
    CurrentValue = false,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        getgenv().KillAuraActive = Value
        local status = Value and "Activated!" or "Deactivated"
        Rayfield:Notify({Title = "System", Content = "Kill Aura " .. status, Duration = 2})
    end,
})

MainTab:CreateDropdown({
    Name = "Attack Mode",
    Options = {"効果なし", "ずっと飛ばし続ける", "はねる?"},
    CurrentOption = {"効果なし"}, 
    MultipleOptions = false,
    Flag = "AttackMode",
    Callback = function(Option)
        SELECTED_MODE = Option[1]
    end,
})

MainTab:CreateSlider({
    Name = "Attack Range",
    Range = {10, 150},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 25,
    Flag = "RangeSlider",
    Callback = function(Value)
        ATTACK_RANGE = Value
    end,
})

MainTab:CreateSlider({
    Name = "Yeet Power",
    Range = {1000, 100000},
    Increment = 500,
    Suffix = "Velocity",
    CurrentValue = 10000,
    Flag = "PowerSlider",
    Callback = function(Value)
        POWER = Value
    end,
})

-- --- Defense タブ (Anti-Grab) ---
local DefenseTab = Window:CreateTab("Defense", 4483362458)
DefenseTab:CreateSection("Anti-Grab System")

DefenseTab:CreateToggle({
    Name = "Anti Grab (Perfect)",
    CurrentValue = getgenv().antiGrab,
    Flag = "AntiGrabToggle",
    Callback = function(Value) 
        getgenv().antiGrab = Value 
    end,
})

-- ───────────────────────────────────────────────
--          ロジック一括管理 (Heartbeat/RenderStepped)
-- ───────────────────────────────────────────────

-- Kill Aura ロジック
RunService.Heartbeat:Connect(function()
    if not getgenv().KillAuraActive then return end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = player.Character:FindFirstChild("Humanoid")
                
                if targetRoot and targetHum and targetHum.Health > 0 then
                    local distance = (targetRoot.Position - rootPart.Position).Magnitude
                    
                    if distance <= ATTACK_RANGE then
                        if SELECTED_MODE == "ずっと飛ばし続ける" then
                            targetRoot.Velocity = Vector3.new(targetRoot.Velocity.X * 2, POWER * 2, targetRoot.Velocity.Z * 2)
                            local bf = targetRoot:FindFirstChild("AntiGravity") or Instance.new("BodyForce")
                            bf.Name = "AntiGravity"
                            bf.Force = Vector3.new(0, 50000, 0)
                            bf.Parent = targetRoot
                        elseif SELECTED_MODE == "はねる?" then
                            targetRoot.RotVelocity = Vector3.new(100, 100, 100)
                            targetRoot.Velocity = Vector3.new(math.random(-POWER, POWER), POWER, math.random(-POWER, POWER))
                        end
                    end
                end
            end
        end
    end
end)

-- Anti-Grab ロジック
RunService.RenderStepped:Connect(function()
    if getgenv().antiGrab and IsHeld and IsHeld.Value then
        if StruggleEvent then 
            StruggleEvent:FireServer(LocalPlayer) 
        end
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

Rayfield:Notify({Title = "Success", Content = "All Systems Loaded!", Duration = 3})
