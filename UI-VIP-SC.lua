local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local targetGui = LocalPlayer:FindFirstChild("PlayerGui") or game.CoreGui

if targetGui:FindFirstChild("ZorvexCarouselUI") then 
    targetGui.ZorvexCarouselUI:Destroy() 
end

local scriptData = {
    ["REBIRTH + GLITCH"] = "loadstring(game:HttpGet(('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Combo-Reb-Gc.lua'))()",
    ["PACKS REBIRTH"]    = "loadstring(game:HttpGet(('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Packs-Reb.lua'))()",
    ["GLITCH"]           = "loadstring(game:HttpGet(('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Glitch.lua'))()",
    ["SCRIPT VIP"]       = "loadstring(game:HttpGet(('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Script.lua'))()",
    ["REBIRTH"]          = "loadstring(game:HttpGet(('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Rebirth.lua'))()",
    ["PACKS STRENGTH"]   = "loadstring(game:HttpGet(('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Packs-Str.lua'))()",
    ["COMBO PACKS"]      = "loadstring(game:HttpGet(('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Packs-Combo.lua'))()",
}

local sg = Instance.new("ScreenGui", targetGui)
sg.Name = "ZorvexCarouselUI"
sg.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 800, 0, 250)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 1

local positions = {
    [1] = {pos = UDim2.new(0.05, 0, 0.4, -60), size = UDim2.new(0, 90, 0, 30), z = 1, trans = 0.7, textSize = 9}, 
    [2] = {pos = UDim2.new(0.2, 0, 0.4, -45), size = UDim2.new(0, 105, 0, 35), z = 3, trans = 0.6, textSize = 11}, 
    [3] = {pos = UDim2.new(0.35, 0, 0.4, -30), size = UDim2.new(0, 125, 0, 42), z = 6, trans = 0.4, textSize = 13}, 
    [4] = {pos = UDim2.new(0.5, 0, 0.4, 0),    size = UDim2.new(0, 165, 0, 58), z = 10, trans = 0.2, textSize = 17}, 
    [5] = {pos = UDim2.new(0.65, 0, 0.4, -30), size = UDim2.new(0, 125, 0, 42), z = 6, trans = 0.4, textSize = 13}, 
    [6] = {pos = UDim2.new(0.8, 0, 0.4, -45), size = UDim2.new(0, 105, 0, 35), z = 3, trans = 0.6, textSize = 11}, 
    [7] = {pos = UDim2.new(0.95, 0, 0.4, -60), size = UDim2.new(0, 90, 0, 30), z = 1, trans = 0.7, textSize = 9}, 
}

local buttons = {}
local currentOrder = {"REBIRTH + GLITCH", "PACKS REBIRTH", "GLITCH", "SCRIPT VIP", "REBIRTH", "PACKS STRENGTH", "COMBO PACKS"}
local isAnimating = false 

local function closeMenu()
    isAnimating = true
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.4)
    sg:Destroy()
end

local function updateUI()
    local moveInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out) 
    for i, name in ipairs(currentOrder) do
        local btn = buttons[name]
        local config = positions[i]
        btn.ZIndex = config.z
        TweenService:Create(btn, moveInfo, {
            Position = config.pos, Size = config.size, TextSize = config.textSize,
            BackgroundTransparency = config.trans, TextTransparency = 0
        }):Play()
    end
end

local function jumpTo(targetName)
    if isAnimating then return end
    isAnimating = true
    local targetIdx = table.find(currentOrder, targetName)
    if targetIdx == 4 then isAnimating = false return end
    
    local diff = targetIdx - 4
    local jumpingButtons = {}
    if diff > 0 then
        for i = 1, diff do table.insert(jumpingButtons, currentOrder[i]) end
    else
        for i = #currentOrder, #currentOrder + diff + 1, -1 do table.insert(jumpingButtons, currentOrder[i]) end
    end

    local fadeOutInfo = TweenInfo.new(0.15)
    for _, name in pairs(jumpingButtons) do
        local btn = buttons[name]
        TweenService:Create(btn, fadeOutInfo, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1, TextTransparency = 1}):Play()
    end
    task.wait(0.15)

    if diff > 0 then
        for i = 1, math.abs(diff) do table.insert(currentOrder, table.remove(currentOrder, 1)) end
    else
        for i = 1, math.abs(diff) do table.insert(currentOrder, 1, table.remove(currentOrder, #currentOrder)) end
    end

    for _, name in pairs(jumpingButtons) do
        local btn = buttons[name]
        btn.Size = UDim2.new(0,0,0,0)
        btn.Position = positions[table.find(currentOrder, name)].pos
    end

    updateUI()
    task.wait(0.2) 
    isAnimating = false
end

local cancelBtn = Instance.new("TextButton", mainFrame)
cancelBtn.Name = "CancelButton"
cancelBtn.Text = "CANCEL"
cancelBtn.Size = UDim2.new(0, 100, 0, 35)
cancelBtn.Position = UDim2.new(0.5, 0, 0.85, 0)
cancelBtn.AnchorPoint = Vector2.new(0.5, 0.5)
cancelBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
cancelBtn.TextColor3 = Color3.fromRGB(200, 0, 0)
cancelBtn.Font = Enum.Font.GothamBold
cancelBtn.TextSize = 12
Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8)
cancelBtn.MouseButton1Click:Connect(closeMenu)

local function createButton(name)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Name = name
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    buttons[name] = btn
    
    btn.MouseButton1Click:Connect(function()
        if isAnimating then return end
        local myIndex = table.find(currentOrder, name)
        
        if myIndex ~= 4 then
            jumpTo(name)
        else
            local code = scriptData[name]
            if code then
                task.spawn(function()
                    pcall(function() loadstring(code)() end)
                end)
                
                local config = positions[4]
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, config.size.X.Offset * 0.9, 0, config.size.Y.Offset * 0.9)}):Play()
                task.wait(0.1)
                
                closeMenu()
            end
        end
    end)
end

for _, name in ipairs(currentOrder) do createButton(name) end
updateUI()