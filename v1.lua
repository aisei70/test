local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- プレイヤーのUIコンテナを取得
local playerGui = player:WaitForChild("PlayerGui")

-- 1. 新しいScreenGuiを作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyCustomUI"
screenGui.Parent = playerGui

-- 2. ボタンを作成
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50) -- 横200, 縦50ピクセル
button.Position = UDim2.new(0.5, -100, 0.5, -25) -- 画面中央
button.Text = "ここをクリック！"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui

-- 3. ボタンが押された時の処理
button.MouseButton1Click:Connect(function()
    button.Text = "クリックされました！"
    print(player.Name .. "さんがボタンを押しました。")
end)
