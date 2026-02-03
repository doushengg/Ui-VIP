local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

if CoreGui:FindFirstChild("CustomPanoramicBG") then
    CoreGui:FindFirstChild("CustomPanoramicBG"):Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "CustomPanoramicBG"
sg.IgnoreGuiInset = true
sg.Parent = CoreGui

local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(1, 0, 1, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = sg

local bg = Instance.new("ImageLabel")
bg.Name = "PanoramicImage"
bg.Image = "rbxassetid://116994069918873"
bg.BackgroundTransparency = 1
bg.Size = UDim2.new(1, 0, 1, 0) 
bg.AnchorPoint = Vector2.new(0.5, 0.5)
bg.Position = UDim2.new(0.5, 0, 0.8, 0)
bg.ScaleType = Enum.ScaleType.Fit
bg.Parent = MainContainer

local baseY = 0.898
local comboY = baseY - 0.09 
local lastUpdate = 0

-- Fungsi Label
local function createTextLabel(name, text, pos, size, color)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = text
    label.Size = size or UDim2.new(0.12, 0, 0.05, 0) 
    label.Position = pos
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.BackgroundTransparency = 1
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextScaled = true 
    label.Font = Enum.Font.GothamBold 
    label.TextStrokeTransparency = 1
    label.ZIndex = 5 
    label.Parent = MainContainer
    
    local uitextsize = Instance.new("UITextSizeConstraint")
    uitextsize.MaxTextSize = 35
    uitextsize.Parent = label
    
    return label
end

-- Update FPS & Ping
local fpsLabel = createTextLabel("FPSLabel", "0", UDim2.new(0.22, 0, 0.75, 0))
local pingLabel = createTextLabel("PingLabel", "0", UDim2.new(0.78, 0, 0.75, 0))
local noPacksLabel = createTextLabel("NoPacksLabel", "NO PACKS", UDim2.new(0.33, 0, 0.72, 0))
local withPacksLabel = createTextLabel("WithPacksLabel", "WITH PACKS", UDim2.new(0.68, 0, 0.72, 0))

-- Fungsi Dekorasi
local function addDecoration(parent, pos, name)
    local deco = Instance.new("ImageLabel")
    deco.Name = name
    deco.Image = "rbxassetid://121872344658107"
    deco.Size = UDim2.new(0.18, 0, 0.25, 0) 
    deco.Position = pos 
    deco.AnchorPoint = Vector2.new(0.5, 0.5)
    deco.BackgroundTransparency = 1
    deco.ZIndex = 1
    deco.Parent = parent
    
    local aspect = Instance.new("UIAspectRatioConstraint")
    aspect.AspectRatio = 1
    aspect.Parent = deco
end

addDecoration(MainContainer, UDim2.new(0.22, 0, 0.80, 0), "DecoFPS")
addDecoration(MainContainer, UDim2.new(0.78, 0, 0.80, 0), "DecoPing")

-- Fungsi Button
local function createBtn(name, text, pos, parent, assetId, scriptUrl)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = text
    btn.Size = UDim2.new(0.07, 0, 0.065, 0) 
    btn.Position = pos
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.FontFace = Font.new("rbxasset://fonts/families/InterTight.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(70, 70, 70) 
    btn.ZIndex = 10 
    btn.Parent = parent

    local originalSize = btn.Size
    local pressedSize = UDim2.new(originalSize.X.Scale * 0.85, 0, originalSize.Y.Scale * 0.85, 0)

    if assetId then
        btn.BackgroundTransparency = 1
        local btnImg = Instance.new("ImageLabel")
        btnImg.Image = "rbxassetid://" .. assetId
        btnImg.Size = UDim2.new(2.3, 0, 1.8, 0)
        btnImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        btnImg.AnchorPoint = Vector2.new(0.5, 0.5)
        btnImg.BackgroundTransparency = 1
        btnImg.ZIndex = 9 
        btnImg.Parent = btn
    end

    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = pressedSize}):Play()
    end)

    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if scriptUrl then
            task.spawn(function()
                local success, err = pcall(function()
                    loadstring(game:HttpGet(scriptUrl))()
                end)
                if not success then warn("Execution Error: " .. err) end
            end)
        end
    end)

    return btn
end

-- Tombol Utama
local idKiri, idKanan, idTengah = "90324985463031", "136605780293258", "139510249638548"

createBtn("ScriptAll", "Script All", UDim2.new(0.5, 0, baseY, 0), MainContainer, idTengah, "https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Script.lua")
createBtn("ComboL", "Combo", UDim2.new(0.34, 0, comboY, 0), MainContainer, idKiri, "https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Combo-Reb-Gc.lua")
createBtn("Glitch", "Glitch", UDim2.new(0.3, 0, baseY + 0.03, 0), MainContainer, idKiri, "https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Glitch.lua")
createBtn("RebirthL", "Rebirth", UDim2.new(0.18, 0, baseY + 0.03, 0), MainContainer, idKiri, "https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Rebirth.lua")
createBtn("ComboR", "Combo", UDim2.new(0.66, 0, comboY, 0), MainContainer, idKanan, "https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Packs-Combo.lua")
createBtn("Strength", "Strength", UDim2.new(0.7, 0, baseY + 0.03, 0), MainContainer, idKanan, "https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Packs-Str.lua")
createBtn("RebirthR", "Rebirth", UDim2.new(0.82, 0, baseY + 0.03, 0), MainContainer, idKanan, "https://raw.githubusercontent.com/doushengg/VipUser/refs/heads/main/Vip-Packs-Reb.lua")

--- MODIFIKASI: TOMBOL DELETE (CLOSE UI) DENGAN ASSET ID BARU ---
local idDelete = "79447515263335"
local deleteBtn = createBtn("DeleteUI", "", UDim2.new(0.92, 0, 0.06, 0), MainContainer, idDelete)
deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih agar kontras dengan asset baru

deleteBtn.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(MainContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0, 0, 1.2, 0),
        Size = UDim2.new(0.8, 0, 0.8, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        sg:Destroy()
    end)
end)
-----------------------------------------------------------------

-- Hide & Show Logic
local hideBtn = Instance.new("TextButton")
hideBtn.Name = ""
hideBtn.Size = UDim2.new(0.12, 0, 0.06, 0)
hideBtn.Position = UDim2.new(0.5, 0, baseY - 0.35, 0)
hideBtn.AnchorPoint = Vector2.new(0.5, 0.5)
hideBtn.BackgroundTransparency = 1 
hideBtn.Parent = MainContainer

local hideBgImg = Instance.new("ImageLabel")
hideBgImg.Image = "rbxassetid://71482232276430" 
hideBgImg.Size = UDim2.new(2.5, 0, 3.5, 0)
hideBgImg.Position = UDim2.new(0.5, 0, 0.5, 0)
hideBgImg.AnchorPoint = Vector2.new(0.5, 0.5)
hideBgImg.BackgroundTransparency = 1
hideBgImg.Parent = hideBtn

local showBtn = Instance.new("TextButton")
showBtn.Name = ""
showBtn.Size = UDim2.new(0.08, 0, 0.04, 0)
showBtn.Position = UDim2.new(0.5, 0, 0.8, 0)
showBtn.AnchorPoint = Vector2.new(0.5, 0.5)
showBtn.BackgroundTransparency = 1
showBtn.Visible = false
showBtn.Parent = sg

local showBgImg = Instance.new("ImageLabel")
showBgImg.Image = "rbxassetid://140384161497939" 
showBgImg.Size = UDim2.new(4, 0, 4, 0)
showBgImg.Position = UDim2.new(0.5, 0, 0.6, 0)
showBgImg.AnchorPoint = Vector2.new(0.5, 0.5)
showBgImg.BackgroundTransparency = 1
showBgImg.Parent = showBtn

hideBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainContainer, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(0, 0, 1.2, 0)}):Play()
    task.wait(1.2)
    showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
    showBtn.Visible = false
    TweenService:Create(MainContainer, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
end)

RunService.RenderStepped:Connect(function(dt)
    if tick() - lastUpdate >= 0.1 then
        local currentFps = math.floor(1/dt)
        fpsLabel.Text = tostring(currentFps > 60 and 60 or currentFps)
        local p = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        pingLabel.Text = tostring(math.floor(p))
        lastUpdate = tick()
    end
end)
