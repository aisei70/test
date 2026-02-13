local Player = game:GetService("Players").LocalPlayer
local Root = (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StealRemote = Remotes:WaitForChild("StealEntity")
local ReplaceRemote = Remotes:WaitForChild("ReplaceEntity")
local SellRemote = Remotes:WaitForChild("SellEntity")

if Player.PlayerGui:FindFirstChild("MiniStealGui") then
    Player.PlayerGui.MiniStealGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "MiniStealGui"

-- サイズを 260x400 から 180x240 に大幅縮小
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 240)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "AUTO STEAL"
Title.TextColor3 = Color3.new(1, 1, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local sellAuto, stealAuto, posLock, lockCF = false, false, false, nil

task.spawn(function()
    while task.wait() do
        if posLock and lockCF then
            Root.CFrame = lockCF
            Root.Velocity = Vector3.zero
        end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if sellAuto then
            for i = 1, 12 do SellRemote:FireServer(i) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if stealAuto then
            for _, target in ipairs(Players:GetPlayers()) do
                if target == Player then continue end
                local tBase = target:GetAttribute("Base")
                if tBase then
                    task.spawn(function()
                        for slot = 1, 12 do
                            if not stealAuto then break end
                            StealRemote:FireServer(tBase, slot)
                            ReplaceRemote:FireServer("Place", slot, slot)
                        end
                    end)
                end
            end
        end
    end
end)

local function CreateBtn(text, pos, color)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    return btn
end

local LBtn = CreateBtn("LOCK POS: OFF", 50, Color3.fromRGB(50, 50, 50))
LBtn.MouseButton1Click:Connect(function()
    posLock = not posLock
    lockCF = posLock and Root.CFrame or nil
    LBtn.Text = posLock and "LOCK: ON" or "LOCK POS: OFF"
    LBtn.BackgroundColor3 = posLock and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(50, 50, 50)
end)

local SBtn = CreateBtn("AUTO SELL: OFF", 100, Color3.fromRGB(50, 50, 50))
SBtn.MouseButton1Click:Connect(function()
    sellAuto = not sellAuto
    SBtn.Text = sellAuto and "SELL: ON" or "AUTO SELL: OFF"
    SBtn.BackgroundColor3 = sellAuto and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(50, 50, 50)
end)

local TBtn = CreateBtn("AUTO STEAL: OFF", 150, Color3.fromRGB(50, 50, 50))
TBtn.MouseButton1Click:Connect(function()
    stealAuto = not stealAuto
    TBtn.Text = stealAuto and "STEAL: ON" or "AUTO STEAL: OFF"
    TBtn.BackgroundColor3 = stealAuto and Color3.fromRGB(200, 0, 50) or Color3.fromRGB(50, 50, 50)
end)
