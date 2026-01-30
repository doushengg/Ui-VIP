local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local targetGui = LocalPlayer:FindFirstChild("PlayerGui") or game.CoreGui

local PRIMARY_FONT = Enum.Font.FredokaOne 
local SECONDARY_FONT = Enum.Font.GothamMedium
local TEXT_COLOR = Color3.fromRGB(45, 45, 45)
local BG_COLOR = Color3.fromRGB(255, 255, 255)
local SHADOW_COLOR = Color3.fromRGB(110, 110, 110)

if targetGui:FindFirstChild("ZorvexCarouselUI") then 
    targetGui.ZorvexCarouselUI:Destroy() 
end

local scriptData = {
    ["REBIRTH + GLITCH"] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Combo-Reb-Gc.lua'))()",
    ["PACKS REBIRTH"]    = "loadstring(game:HttpGet('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Packs-Reb.lua'))()",
    ["GLITCH"]           = "loadstring(game:HttpGet('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Glitch.lua'))()",
    ["SCRIPT VIP"]       = "loadstring(game:HttpGet('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Script.lua'))()",
    ["REBIRTH"]          = "loadstring(game:HttpGet('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Rebirth.lua'))()",
    ["PACKS STRENGTH"]   = "loadstring(game:HttpGet('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Packs-Str.lua'))()",
    ["COMBO PACKS"]      = "loadstring(game:HttpGet('https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Packs-Combo.lua'))()",
}

local sg = Instance.new("ScreenGui", targetGui)
sg.Name = "ZorvexCarouselUI"
sg.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 800, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 1

local showBtnContainer = Instance.new("Frame", sg)
showBtnContainer.Name = "ShowButtonContainer"
showBtnContainer.Size = UDim2.new(0, 120, 0, 35)
showBtnContainer.Position = UDim2.new(0.823, 0, -0.0697, 0) 
showBtnContainer.AnchorPoint = Vector2.new(0.5, 0.5)
showBtnContainer.BackgroundTransparency = 1
showBtnContainer.Visible = false 

local showShadow = Instance.new("Frame", showBtnContainer)
showShadow.Size = UDim2.new(1, 0, 1, 0)
showShadow.Position = UDim2.new(0, 0, 0, 3)
showShadow.BackgroundColor3 = SHADOW_COLOR
showShadow.BorderSizePixel = 0
Instance.new("UICorner", showShadow).CornerRadius = UDim.new(0, 8)

local showBtn = Instance.new("TextButton", showBtnContainer)
showBtn.Name = "ShowButton"
showBtn.Text = "VIP USER"
showBtn.Size = UDim2.new(1, 0, 1, 0)
showBtn.BackgroundColor3 = BG_COLOR
showBtn.TextColor3 = TEXT_COLOR
showBtn.Font = PRIMARY_FONT
showBtn.TextSize = 14
showBtn.AutoButtonColor = false
Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0, 8)

local buttons = {}
local currentOrder = {"REBIRTH + GLITCH", "PACKS REBIRTH", "GLITCH", "SCRIPT VIP", "REBIRTH", "PACKS STRENGTH", "COMBO PACKS"}
local isAnimating = false 

local radiusX, radiusY = 280, 70  
local centerX, centerY = 0.5, 0.4
local smoothTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

local function updateUI()
    local total = #currentOrder
    for i, name in ipairs(currentOrder) do
        local container = buttons[name]
        local btn = container:FindFirstChild("MainBtn")
        local shadow = container:FindFirstChild("Shadow")
        local uicMain = btn:FindFirstChildOfClass("UICorner")
        local uicShadow = shadow:FindFirstChildOfClass("UICorner")
        
        local angle = ((i - 4) / total) * (math.pi * 2)
        local xPos = centerX + math.sin(angle) * (radiusX / 800)
        local zPos = math.cos(angle) 
        local yPos = centerY + (zPos * (radiusY / 400))
        local scale = 0.7 + (zPos * 0.3)
        local zIndex = math.round((zPos + 1) * 10)

        TweenService:Create(container, smoothTweenInfo, {
            Position = UDim2.new(xPos, 0, yPos, 0),
            Size = UDim2.new(0, 180 * scale, 0, 65 * scale),
            ZIndex = zIndex
        }):Play()

        TweenService:Create(btn, smoothTweenInfo, {
            BackgroundTransparency = 0,
            TextTransparency = 0,
            TextSize = 18 * scale
        }):Play()
        
        TweenService:Create(shadow, smoothTweenInfo, {
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 0, 0, 6 * scale)
        }):Play()

        uicMain.CornerRadius = UDim.new(0, 12 * scale)
        uicShadow.CornerRadius = UDim.new(0, 12 * scale)
    end
end

local function animateOut(destroy)
    isAnimating = true
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    if destroy then 
        sg:Destroy() 
    else 
        mainFrame.Visible = false 
        showBtnContainer.Visible = true 
        isAnimating = false 
    end
end

local function animateIn()
    isAnimating = true
    showBtnContainer.Visible = false
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Visible = true
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 800, 0, 400)})
    tween:Play()
    tween.Completed:Wait()
    isAnimating = false
end

local function jumpTo(targetName)
    if isAnimating then return end
    isAnimating = true
    local targetIdx = table.find(currentOrder, targetName)
    local diff = targetIdx - 4
    if diff ~= 0 then
        for i = 1, math.abs(diff) do
            if diff > 0 then table.insert(currentOrder, table.remove(currentOrder, 1))
            else table.insert(currentOrder, 1, table.remove(currentOrder, #currentOrder)) end
        end
        updateUI()
        task.wait(0.3)
    end
    isAnimating = false
end

local function createButton(name)
    local container = Instance.new("Frame", mainFrame)
    container.Name = name
    container.BackgroundTransparency = 1
    container.AnchorPoint = Vector2.new(0.5, 0.5)

    local shadow = Instance.new("Frame", container)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.BackgroundColor3 = SHADOW_COLOR
    shadow.BorderSizePixel = 0
    Instance.new("UICorner", shadow)

    local btn = Instance.new("TextButton", container)
    btn.Name = "MainBtn"
    btn.Text = name
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Font = PRIMARY_FONT
    btn.TextColor3 = TEXT_COLOR
    btn.BackgroundColor3 = BG_COLOR
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Down:Connect(function()
        local scale = btn.Parent.Size.Y.Offset / 65
        TweenService:Create(btn, TweenInfo.new(0.05), {Position = UDim2.new(0, 0, 0, 4 * scale)}):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if isAnimating then return end
        local myIndex = table.find(currentOrder, name)
        if myIndex ~= 4 then 
            jumpTo(name)
        else
            local code = scriptData[name]
            if code then
                task.delay(0.1, function()
                    pcall(function() loadstring(code)() end)
                    animateOut(false)
                end)
            end
        end
    end)
    
    buttons[name] = container
end

local function createNavBtn(text, pos, shadowCol, callback)
    local cont = Instance.new("Frame", mainFrame)
    cont.Size = UDim2.new(0, 100, 0, 35)
    cont.Position = pos
    cont.AnchorPoint = Vector2.new(0.5, 0.5)
    cont.BackgroundTransparency = 1

    local sh = Instance.new("Frame", cont)
    sh.Size = UDim2.new(1,0,1,0)
    sh.Position = UDim2.new(0,0,0,3)
    sh.BackgroundColor3 = shadowCol
    sh.BorderSizePixel = 0
    Instance.new("UICorner", sh).CornerRadius = UDim.new(0, 8)

    local b = Instance.new("TextButton", cont)
    b.Size = UDim2.new(1,0,1,0)
    b.Text = text
    b.Font = SECONDARY_FONT
    b.BackgroundColor3 = (text == "DELETE" and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(240, 240, 240))
    b.TextColor3 = (text == "DELETE" and Color3.new(1,1,1) or TEXT_COLOR)
    b.TextSize = 11
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Down:Connect(function() b.Position = UDim2.new(0,0,0,2) end)
    b.MouseButton1Up:Connect(function() b.Position = UDim2.new(0,0,0,0) end)
    b.MouseButton1Click:Connect(callback)
end

createNavBtn("DELETE", UDim2.new(0.43, 0, 0.8, 0), Color3.fromRGB(20, 20, 20), function() animateOut(true) end)
createNavBtn("HIDE", UDim2.new(0.57, 0, 0.8, 0), Color3.fromRGB(110, 110, 110), function() animateOut(false) end)

showBtn.MouseButton1Down:Connect(function() showBtn.Position = UDim2.new(0,0,0,2) end)
showBtn.MouseButton1Up:Connect(function() showBtn.Position = UDim2.new(0,0,0,0) end)
showBtn.MouseButton1Click:Connect(animateIn)

for _, name in ipairs(currentOrder) do 
    createButton(name) 
end

updateUI()
