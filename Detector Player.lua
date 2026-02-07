local ZorVexKillerUI = {}
ZorVexKillerUI.__index = ZorVexKillerUI

-- Tabel Global untuk melacak status kematian
local DeadPlayers = {}

-- // FUNGSI DRAGGING //
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

function ZorVexKillerUI.new()
    local self = setmetatable({}, ZorVexKillerUI)
    
    self.SelectedPlayerName = game.Players.LocalPlayer.Name
    self.AllHistoryStats = {} 
    self.IsDropdownOpen = false
    self.IsLogOpen = false

    self:CreateBaseUI()
    self:InitTracking()
    self:StartUpdateLoop()
    
    return self
end

function ZorVexKillerUI:FormatNumber(n)
    n = tonumber(n) or 0
    if n < 1000 then return tostring(math.floor(n)) end
    local symbols = {"", "k", "M", "B", "T", "Qa", "Qi"}
    local symbolIndex = math.floor(math.log10(n) / 3)
    if symbolIndex >= #symbols then symbolIndex = #symbols - 1 end
    local power = 10 ^ (symbolIndex * 3)
    return string.format("%.1f", n / power):gsub("%.0$", "") .. symbols[symbolIndex + 1]
end

function ZorVexKillerUI:CreateBaseUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "ZorVexKillerFinal"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.Parent = game.CoreGui
    self.Gui = sg

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 380, 0, 240)
    main.Position = UDim2.new(0.5, -190, 0.5, -120)
    main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    main.BackgroundTransparency = 0.1
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = sg
    self.MainFrame = main
    
    MakeDraggable(main)
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
    local stroke = Instance.new("UIStroke", main)
    stroke.Thickness = 3
    stroke.Color = Color3.fromRGB(230, 230, 230)

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = main
    self.ContentFrame = contentFrame

    self.NameLabel = self:CreateLabel("LOADING...", 27, UDim2.new(0, 0, 0, 75), contentFrame)
    self.UserSubLabel = self:CreateLabel("@username", 16, UDim2.new(0, 0, 0, 95), contentFrame)
    self.UserSubLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
    
    self.StatsLabel = self:CreateLabel("Kill : 0 Players", 22, UDim2.new(0, 0, 0, 135), contentFrame)
    self.StatsLabel.TextColor3 = Color3.fromRGB(180, 0, 0)

    local dropBtn = Instance.new("TextButton")
    dropBtn.Name = "DropdownBtn"
    dropBtn.Size = UDim2.new(0.9, 0, 0, 45)
    dropBtn.Position = UDim2.new(0.05, 0, 0, 15)
    dropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropBtn.BackgroundTransparency = 0.1
    dropBtn.Text = "Select Player ▼"
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.TextSize = 18
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.ZIndex = 200
    dropBtn.Parent = main
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 8)

    local logBtn = Instance.new("TextButton")
    logBtn.Name = "LogBtn"
    logBtn.Size = UDim2.new(0.9, 0, 0, 45)
    logBtn.Position = UDim2.new(0.05, 0, 1, -60)
    logBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    logBtn.BackgroundTransparency = 0.1
    logBtn.Text = "Korban ▼"
    logBtn.Font = Enum.Font.GothamBold
    logBtn.TextSize = 18
    logBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    logBtn.ZIndex = 200
    logBtn.Parent = main
    self.LogBtn = logBtn
    Instance.new("UICorner", logBtn).CornerRadius = UDim.new(0, 8)

    self.DropList = self:CreateScrollList(main, 150)
    self.LogList = self:CreateScrollList(main, 150)
    
    self.DropList.Position = UDim2.new(0.05, 0, 0, 65)
    self.DropList.Size = UDim2.new(0.9, 0, 0, 155)
    
    self.LogList.Position = UDim2.new(0.05, 0, 0, 65)
    self.LogList.Size = UDim2.new(0.9, 0, 0, 110)

    dropBtn.MouseButton1Click:Connect(function()
        self.IsDropdownOpen = not self.IsDropdownOpen
        self.IsLogOpen = false
        self:RefreshUIState()
        if self.IsDropdownOpen then self:UpdateDropdownUI() end
    end)

    logBtn.MouseButton1Click:Connect(function()
        self.IsLogOpen = not self.IsLogOpen
        self.IsDropdownOpen = false
        self:RefreshUIState()
        if self.IsLogOpen then self:RenderLogList() end
    end)
end

function ZorVexKillerUI:RefreshUIState()
    local targetData = self.AllHistoryStats[self.SelectedPlayerName]
    self.LogBtn.Visible = not self.IsDropdownOpen
    self.DropList.Visible = self.IsDropdownOpen
    self.LogList.Visible = self.IsLogOpen
    self.ContentFrame.Visible = not (self.IsDropdownOpen or self.IsLogOpen)
    self.MainFrame.DropdownBtn.Text = self.IsDropdownOpen and "Close ▲" or "Select Player ▼"
    if targetData then
        self.LogBtn.Text = self.IsLogOpen and "Close ▲" or "Korban [ "..#targetData.Logs.." ] ▼"
    end
end

function ZorVexKillerUI:CreateLabel(txt, size, pos, parent)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = txt
    l.Font = Enum.Font.GothamBold
    l.TextSize = size
    l.TextColor3 = Color3.fromRGB(0, 0, 0)
    l.TextXAlignment = Enum.TextXAlignment.Center
    l.Parent = parent
    return l
end

function ZorVexKillerUI:CreateScrollList(parent, zindex)
    local sc = Instance.new("ScrollingFrame")
    sc.Visible = false
    sc.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    sc.BackgroundTransparency = 0.1
    sc.ZIndex = zindex
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 4
    sc.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
    sc.Parent = parent
    local layout = Instance.new("UIListLayout", sc)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return sc
end

function ZorVexKillerUI:UpdateDropdownUI()
    for _, child in ipairs(self.DropList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local playerCount = 0
    for name, data in pairs(self.AllHistoryStats) do
        playerCount = playerCount + 1
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, -10, 0, 45) 
        itemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        itemFrame.ZIndex = 160
        itemFrame.Parent = self.DropList
        Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 8)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 165
        btn.Parent = itemFrame

        local dLabel = Instance.new("TextLabel")
        dLabel.Size = UDim2.new(1, 0, 0.6, 0)
        dLabel.Position = UDim2.new(0, 0, 0, 2)
        dLabel.Text = data.DisplayName
        dLabel.Font = Enum.Font.GothamBold
        dLabel.TextColor3 = data.IsOnline and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(150, 0, 0)
        dLabel.TextSize = 16
        dLabel.TextXAlignment = Enum.TextXAlignment.Center -- Teks Tengah
        dLabel.BackgroundTransparency = 1
        dLabel.ZIndex = 162
        dLabel.Parent = itemFrame

        local uLabel = Instance.new("TextLabel")
        uLabel.Size = UDim2.new(1, 0, 0.4, 0)
        uLabel.Position = UDim2.new(0, 0, 0.5, 0)
        uLabel.Text = "@" .. name .. (data.IsOnline and "" or " (Offline)")
        uLabel.Font = Enum.Font.Gotham
        uLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        uLabel.TextSize = 12
        uLabel.TextXAlignment = Enum.TextXAlignment.Center -- Teks Tengah
        uLabel.BackgroundTransparency = 1
        uLabel.ZIndex = 162
        uLabel.Parent = itemFrame

        btn.MouseButton1Click:Connect(function()
            self.SelectedPlayerName = name
            self.IsDropdownOpen = false
            self:RefreshUIState()
        end)
    end
    self.DropList.CanvasSize = UDim2.new(0, 0, 0, playerCount * 52)
end

function ZorVexKillerUI:RenderLogList()
    for _, v in ipairs(self.LogList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local targetData = self.AllHistoryStats[self.SelectedPlayerName]
    if not targetData then return end
    
    for _, data in ipairs(targetData.Logs) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, -10, 0, 50) 
        item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        item.ZIndex = 160
        item.Parent = self.LogList
        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)

        local topLabel = Instance.new("TextLabel")
        topLabel.Size = UDim2.new(1, 0, 0, 25)
        topLabel.Position = UDim2.new(0, 0, 0, 5)
        topLabel.Text = data.displayName .. " [ " .. data.count .. " Killed ]"
        topLabel.Font = Enum.Font.GothamBold
        topLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
        topLabel.TextSize = 16
        topLabel.TextXAlignment = Enum.TextXAlignment.Center -- Teks Tengah
        topLabel.BackgroundTransparency = 1
        topLabel.ZIndex = 162
        topLabel.Parent = item

        local bottomLabel = Instance.new("TextLabel")
        bottomLabel.Size = UDim2.new(1, 0, 0, 20)
        bottomLabel.Position = UDim2.new(0, 0, 0, 25)
        bottomLabel.Text = "[ Time " .. data.time .. " ] @" .. data.userName
        bottomLabel.Font = Enum.Font.Gotham
        bottomLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
        bottomLabel.TextSize = 13
        bottomLabel.TextXAlignment = Enum.TextXAlignment.Center -- Teks Tengah
        bottomLabel.BackgroundTransparency = 1
        bottomLabel.ZIndex = 162
        bottomLabel.Parent = item
    end
    self.LogList.CanvasSize = UDim2.new(0, 0, 0, #targetData.Logs * 56)
end

-- // CORE LOGIC //
function ZorVexKillerUI:GetKillValueObject(p)
    local ls = p:FindFirstChild("leaderstats")
    if ls then return ls:FindFirstChild("Kills") or ls:FindFirstChild("Kill") end
    return nil
end

function ZorVexKillerUI:InitTracking()
    task.spawn(function()
        while true do
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health > 0 then DeadPlayers[player.Name] = nil end
                end
            end
            task.wait(0.1)
        end
    end)
    
    local function setupPlayer(p)
        task.spawn(function()
            local ls = p:WaitForChild("leaderstats", 20)
            local killObj = nil
            repeat 
                killObj = self:GetKillValueObject(p)
                if not killObj then task.wait(0.5) end
            until killObj or not p.Parent
            if not killObj then return end
            
            if not self.AllHistoryStats[p.Name] then
                self.AllHistoryStats[p.Name] = {DisplayName = p.DisplayName, IsOnline = true, SessionKills = 0, LastTotal = killObj.Value, IsCalibrated = false, Logs = {}}
            else
                self.AllHistoryStats[p.Name].IsOnline = true
                self.AllHistoryStats[p.Name].LastTotal = killObj.Value
            end
            
            task.wait(1.5)
            if self.AllHistoryStats[p.Name] then self.AllHistoryStats[p.Name].IsCalibrated = true end

            killObj.Changed:Connect(function(newVal)
                local data = self.AllHistoryStats[p.Name]
                if data and data.IsCalibrated and newVal > data.LastTotal then
                    data.SessionKills = data.SessionKills + (newVal - data.LastTotal)
                    for _, victim in ipairs(game.Players:GetPlayers()) do
                        if victim ~= p and victim.Character and victim.Character:FindFirstChild("Humanoid") then
                            if victim.Character.Humanoid.Health <= 0 and not DeadPlayers[victim.Name] then
                                DeadPlayers[victim.Name] = true 
                                local existingEntry = nil
                                for _, log in ipairs(data.Logs) do if log.userName == victim.Name then existingEntry = log break end end
                                if existingEntry then
                                    existingEntry.count = existingEntry.count + 1
                                    existingEntry.time = os.date("%H:%M")
                                else
                                    table.insert(data.Logs, 1, {displayName = victim.DisplayName, userName = victim.Name, time = os.date("%H:%M"), count = 1})
                                end
                            end
                        end
                    end
                end
                if data then data.LastTotal = newVal end
            end)
            self:UpdateDropdownUI()
        end)
    end
    
    for _, p in ipairs(game.Players:GetPlayers()) do setupPlayer(p) end
    game.Players.PlayerAdded:Connect(setupPlayer)
    game.Players.PlayerRemoving:Connect(function(p)
        if self.AllHistoryStats[p.Name] then self.AllHistoryStats[p.Name].IsOnline = false self:UpdateDropdownUI() end
    end)
end

function ZorVexKillerUI:StartUpdateLoop()
    task.spawn(function()
        while task.wait(0.5) do
            local targetData = self.AllHistoryStats[self.SelectedPlayerName]
            if targetData then
                self.NameLabel.Text = targetData.DisplayName
                self.UserSubLabel.Text = "@" .. self.SelectedPlayerName
                self.StatsLabel.Text = "Kill : " .. self:FormatNumber(targetData.SessionKills) .. " Players"
            end
        end
    end)
end

local KillerTracker = ZorVexKillerUI.new()