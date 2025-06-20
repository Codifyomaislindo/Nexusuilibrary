-- NexusUI v1.0
-- Biblioteca premium para interfaces Roblox
-- Suporte total para mobile e PC

local NexusUI = {}
NexusUI.__index = NexusUI
NexusUI.Version = "1.0"
NexusUI.Icons = {}

-- Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Configurações de tema
NexusUI.Themes = {
    Dark = {
        Primary = Color3.fromRGB(0, 120, 215),
        Secondary = Color3.fromRGB(46, 204, 113),
        Background = Color3.fromRGB(25, 25, 25),
        Card = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(240, 240, 240),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Error = Color3.fromRGB(231, 76, 60),
        Border = Color3.fromRGB(60, 60, 60),
        BorderRadius = 12,
        Shadow = true
    },
    Purple = {
        Primary = Color3.fromRGB(156, 39, 176),
        Secondary = Color3.fromRGB(233, 30, 99),
        Background = Color3.fromRGB(30, 30, 46),
        Card = Color3.fromRGB(50, 50, 70),
        Text = Color3.fromRGB(240, 240, 240),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Error = Color3.fromRGB(244, 67, 54),
        Border = Color3.fromRGB(80, 60, 100),
        BorderRadius = 14,
        Shadow = true
    }
}

-- Ícones (Font Awesome)
NexusUI.Icons = {
    Settings = "rbxassetid://10734961563",
    Check = "rbxassetid://10734960253",
    Close = "rbxassetid://10734960583",
    Info = "rbxassetid://10734962423",
    Warning = "rbxassetid://10734962863",
    ChevronDown = "rbxassetid://10734959743",
    Sliders = "rbxassetid://10734963503",
    ToggleOn = "rbxassetid://10734963853",
    ToggleOff = "rbxassetid://10734964103"
}

-- Sistema de responsividade
function NexusUI:IsMobile()
    return UserInputService.TouchEnabled
end

function NexusUI:AdaptSize(size)
    if self:IsMobile() then
        return UDim2.new(size.X.Scale, size.X.Offset * 1.3, size.Y.Scale, size.Y.Offset * 1.3)
    end
    return size
end

function NexusUI:AdaptPosition(position)
    if self:IsMobile() then
        return UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + 30)
    end
    return position
end

-- Funções de utilidade
function NexusUI:Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        if property == "Parent" then
            instance.Parent = value
        else
            instance[property] = value
        end
    end
    return instance
end

function NexusUI:ApplyTheme(element, theme)
    local currentTheme = theme or self.CurrentTheme
    
    if element:IsA("TextButton") or element:IsA("TextLabel") or element:IsA("TextBox") then
        element.TextColor3 = currentTheme.Text
        element.Font = Enum.Font.Gotham
        element.TextSize = self:IsMobile() and 18 or 16
    end
    
    if element:IsA("Frame") or element:IsA("TextButton") or element:IsA("ScrollingFrame") then
        element.BackgroundColor3 = currentTheme.Card
    end
    
    if element:IsA("UIStroke") then
        element.Color = currentTheme.Border
    end
end

function NexusUI:CreateRoundedFrame(parent, size, position)
    local frame = self:Create("Frame", {
        Parent = parent,
        Size = self:AdaptSize(size),
        Position = self:AdaptPosition(position),
        BackgroundTransparency = 0,
        BorderSizePixel = 0
    })
    
    local corner = self:Create("UICorner", {
        Parent = frame,
        CornerRadius = UDim.new(0, self.CurrentTheme.BorderRadius)
    })
    
    local stroke = self:Create("UIStroke", {
        Parent = frame,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    self:ApplyTheme(frame)
    self:ApplyTheme(stroke)
    
    if self.CurrentTheme.Shadow then
        self:CreateShadow(frame)
    end
    
    return frame
end

function NexusUI:CreateShadow(target)
    local shadow = self:Create("ImageLabel", {
        Name = "DropShadow",
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0, -5, 0, -5),
        BackgroundTransparency = 1,
        Parent = target,
        ZIndex = target.ZIndex - 1
    })
    
    return shadow
end

function NexusUI:CreateIcon(parent, iconId, size, position)
    local icon = self:Create("ImageLabel", {
        Parent = parent,
        Image = self.Icons[iconId] or iconId,
        Size = self:AdaptSize(size),
        Position = self:AdaptPosition(position),
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit
    })
    
    return icon
end

-- Componentes principais
function NexusUI:CreateWindow(title)
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Remover UIs anteriores
    if playerGui:FindFirstChild("NexusUI") then
        playerGui.NexusUI:Destroy()
    end
    
    local mainScreen = self:Create("ScreenGui", {
        Name = "NexusUI",
        Parent = playerGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    local mainFrame = self:CreateRoundedFrame(mainScreen, 
        UDim2.new(0.8, 0, 0.85, 0), 
        UDim2.new(0.1, 0, 0.075, 0)
    )
    
    local titleBar = self:CreateRoundedFrame(mainFrame, 
        UDim2.new(1, -20, 0.1, 0), 
        UDim2.new(0, 10, 0, 10)
    )
    titleBar.BackgroundColor3 = self.CurrentTheme.Primary
    
    local titleLabel = self:Create("TextLabel", {
        Parent = titleBar,
        Text = title,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = self:IsMobile() and 20 or 18
    })
    self:ApplyTheme(titleLabel)
    titleLabel.TextColor3 = self.CurrentTheme.Text
    
    local settingsIcon = self:CreateIcon(titleBar, "Settings", 
        UDim2.new(0.8, 0, 0.8, 0), 
        UDim2.new(0.95, -30, 0.1, 0)
    )
    
    local contentFrame = self:Create("ScrollingFrame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -20, 0.85, -20),
        Position = UDim2.new(0, 10, 0.15, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    local uiListLayout = self:Create("UIListLayout", {
        Parent = contentFrame,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    self:ApplyTheme(contentFrame)
    
    return {
        Screen = mainScreen,
        MainFrame = mainFrame,
        Content = contentFrame,
        TitleBar = titleBar
    }
end

function NexusUI:CreateButton(parent, config)
    local buttonFrame = self:CreateRoundedFrame(parent, 
        self:AdaptSize(UDim2.new(1, -20, 0, 50)), 
        UDim2.new(0, 10, 0, 0)
    )
    
    local button = self:Create("TextButton", {
        Parent = buttonFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Button",
        AutoButtonColor = false
    })
    
    if config.Icon then
        local icon = self:CreateIcon(button, config.Icon, 
            UDim2.new(0, 30, 0, 30), 
            UDim2.new(0, 10, 0.5, -15)
        )
        
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.PaddingLeft = UDim.new(0, 50)
    end
    
    self:ApplyTheme(button)
    
    -- Animações
    button.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = self.CurrentTheme.Primary
        }):Play()
        TweenService:Create(button, TweenInfo.new(0.2), {
            TextColor3 = self.CurrentTheme.Text
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = self.CurrentTheme.Card
        }):Play()
        TweenService:Create(button, TweenInfo.new(0.2), {
            TextColor3 = self.CurrentTheme.Text
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            Size = self:AdaptSize(UDim2.new(0.98, -20, 0, 48))
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            Size = self:AdaptSize(UDim2.new(1, -20, 0, 50))
        }):Play()
    end)
    
    -- Suporte mobile
    if self:IsMobile() then
        local touchCount = 0
        
        button.TouchTap:Connect(function()
            touchCount += 1
            if touchCount == 1 then
                TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
                    Size = self:AdaptSize(UDim2.new(0.98, -20, 0, 48))
                }):Play()
                task.wait(0.1)
                TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
                    Size = self:AdaptSize(UDim2.new(1, -20, 0, 50))
                }):Play()
            end
        end)
    end
    
    if config.Callback then
        button.MouseButton1Click:Connect(config.Callback)
    end
    
    return buttonFrame
end

function NexusUI:CreateToggle(parent, config)
    local toggleFrame = self:CreateRoundedFrame(parent, 
        self:AdaptSize(UDim2.new(1, -20, 0, 50)), 
        UDim2.new(0, 10, 0, 0)
    )
    
    local label = self:Create("TextLabel", {
        Parent = toggleFrame,
        Text = config.Text or "Toggle",
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    self:ApplyTheme(label)
    
    local toggleBackground = self:CreateRoundedFrame(toggleFrame, 
        UDim2.new(0.2, 0, 0.6, 0), 
        UDim2.new(0.75, 0, 0.2, 0)
    )
    toggleBackground.BackgroundColor3 = self.CurrentTheme.Background
    
    local toggleState = self:Create("Frame", {
        Parent = toggleBackground,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.CurrentTheme.TextSecondary,
        BorderSizePixel = 0
    })
    
    local corner = self:Create("UICorner", {
        Parent = toggleState,
        CornerRadius = UDim.new(1, 0)
    })
    
    local state = config.Default or false
    
    local function updateToggle()
        if state then
            TweenService:Create(toggleState, TweenInfo.new(0.2), {
                Position = UDim2.new(0.5, 0, 0, 0),
                BackgroundColor3 = self.CurrentTheme.Secondary
            }):Play()
        else
            TweenService:Create(toggleState, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = self.CurrentTheme.TextSecondary
            }):Play()
        end
    end
    
    updateToggle()
    
    local function toggle()
        state = not state
        updateToggle()
        if config.Callback then
            config.Callback(state)
        end
    end
    
    toggleBackground.MouseButton1Click:Connect(toggle)
    
    -- Suporte mobile
    if self:IsMobile() then
        toggleBackground.TouchTap:Connect(toggle)
    end
    
    return toggleFrame
end

function NexusUI:CreateSlider(parent, config)
    local sliderFrame = self:CreateRoundedFrame(parent, 
        self:AdaptSize(UDim2.new(1, -20, 0, 70)), 
        UDim2.new(0, 10, 0, 0)
    )
    
    local label = self:Create("TextLabel", {
        Parent = sliderFrame,
        Text = config.Text or "Slider",
        Size = UDim2.new(1, -20, 0.3, 0),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    self:ApplyTheme(label)
    
    local valueLabel = self:Create("TextLabel", {
        Parent = sliderFrame,
        Text = tostring(config.Default or 50),
        Size = UDim2.new(0.2, 0, 0.3, 0),
        Position = UDim2.new(0.8, 0, 0, 5),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    self:ApplyTheme(valueLabel)
    
    local sliderTrack = self:CreateRoundedFrame(sliderFrame, 
        UDim2.new(0.9, 0, 0.15, 0), 
        UDim2.new(0.05, 0, 0.55, 0)
    )
    sliderTrack.BackgroundColor3 = self.CurrentTheme.Background
    
    local sliderFill = self:CreateRoundedFrame(sliderTrack, 
        UDim2.new(0.5, 0, 1, 0), 
        UDim2.new(0, 0, 0, 0)
    )
    sliderFill.BackgroundColor3 = self.CurrentTheme.Primary
    
    local sliderThumb = self:Create("Frame", {
        Parent = sliderTrack,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0.5, -10, 0.5, -10),
        BackgroundColor3 = self.CurrentTheme.Text,
        BorderSizePixel = 0
    })
    
    local corner = self:Create("UICorner", {
        Parent = sliderThumb,
        CornerRadius = UDim.new(1, 0)
    })
    
    local stroke = self:Create("UIStroke", {
        Parent = sliderThumb,
        Thickness = 2,
        Color = self.CurrentTheme.Primary
    })
    
    local min = config.Min or 0
    local max = config.Max or 100
    local value = config.Default or 50
    
    local function updateSlider(newValue)
        value = math.clamp(newValue, min, max)
        local fillPercent = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
        sliderThumb.Position = UDim2.new(fillPercent, -10, 0.5, -10)
        valueLabel.Text = tostring(math.floor(value))
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    updateSlider(value)
    
    local dragging = false
    
    local function updateFromInput(input)
        if dragging then
            local absolutePos = input.Position.X
            local relativePos = absolutePos - sliderTrack.AbsolutePosition.X
            local percent = math.clamp(relativePos / sliderTrack.AbsoluteSize.X, 0, 1)
            updateSlider(min + percent * (max - min))
        end
    end
    
    sliderThumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    sliderThumb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            updateFromInput(input)
        end
    end)
    
    -- Suporte mobile
    sliderTrack.InputBegan:Connect(function(input)
        if self:IsMobile() and input.UserInputType == Enum.UserInputType.Touch then
            updateFromInput(input)
        end
    end)
    
    return sliderFrame
end

function NexusUI:CreateDropdown(parent, config)
    local dropdownFrame = self:CreateRoundedFrame(parent, 
        self:AdaptSize(UDim2.new(1, -20, 0, 50)), 
        UDim2.new(0, 10, 0, 0)
    )
    
    local label = self:Create("TextLabel", {
        Parent = dropdownFrame,
        Text = config.Text or "Dropdown",
        Size = UDim2.new(0.8, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    self:ApplyTheme(label)
    
    local chevron = self:CreateIcon(dropdownFrame, "ChevronDown", 
        UDim2.new(0, 20, 0, 20), 
        UDim2.new(0.95, -25, 0.5, -10)
    )
    
    local optionsFrame = self:CreateRoundedFrame(parent, 
        self:AdaptSize(UDim2.new(1, -40, 0, 0)), 
        UDim2.new(0, 20, 0, 60)
    )
    optionsFrame.Visible = false
    optionsFrame.BackgroundColor3 = self.CurrentTheme.Card
    optionsFrame.ZIndex = dropdownFrame.ZIndex + 1
    
    local optionsList = self:Create("UIListLayout", {
        Parent = optionsFrame,
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local selectedOption = config.Default or (config.Options and config.Options[1])
    
    local function updateDropdown()
        if selectedOption then
            label.Text = selectedOption
        end
    end
    
    updateDropdown()
    
    local function toggleDropdown()
        optionsFrame.Visible = not optionsFrame.Visible
        if optionsFrame.Visible then
            TweenService:Create(chevron, TweenInfo.new(0.2), {
                Rotation = 180
            }):Play()
            
            -- Criar opções
            for i, option in ipairs(config.Options or {}) do
                local optionButton = self:Create("TextButton", {
                    Parent = optionsFrame,
                    Text = option,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    LayoutOrder = i
                })
                self:ApplyTheme(optionButton)
                
                optionButton.MouseEnter:Connect(function()
                    optionButton.TextColor3 = self.CurrentTheme.Primary
                end)
                
                optionButton.MouseLeave:Connect(function()
                    optionButton.TextColor3 = self.CurrentTheme.Text
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    updateDropdown()
                    toggleDropdown()
                    if config.Callback then
                        config.Callback(option)
                    end
                end)
            end
            
            optionsFrame.Size = UDim2.new(1, -40, 0, #config.Options * 42)
        else
            TweenService:Create(chevron, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
            
            -- Limpar opções
            for _, child in ipairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
        end
    end
    
    dropdownFrame.MouseButton1Click:Connect(toggleDropdown)
    
    -- Suporte mobile
    if self:IsMobile() then
        dropdownFrame.TouchTap:Connect(toggleDropdown)
    end
    
    return dropdownFrame
end

function NexusUI:Notify(title, message, duration)
    duration = duration or 5
    
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local notificationScreen = playerGui:FindFirstChild("NexusUINotifications") or self:Create("ScreenGui", {
        Name = "NexusUINotifications",
        Parent = playerGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    local notification = self:CreateRoundedFrame(notificationScreen, 
        UDim2.new(0.8, 0, 0, 80), 
        UDim2.new(0.1, 0, 0.05, 0)
    )
    notification.BackgroundColor3 = self.CurrentTheme.Card
    notification.ZIndex = 100
    
    local titleLabel = self:Create("TextLabel", {
        Parent = notification,
        Text = title,
        Size = UDim2.new(1, -50, 0.4, 0),
        Position = UDim2.new(0, 50, 0, 10),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = self:IsMobile() and 18 or 16
    })
    self:ApplyTheme(titleLabel)
    
    local messageLabel = self:Create("TextLabel", {
        Parent = notification,
        Text = message,
        Size = UDim2.new(1, -50, 0.6, 0),
        Position = UDim2.new(0, 50, 0.4, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextSize = self:IsMobile() and 16 or 14
    })
    self:ApplyTheme(messageLabel)
    messageLabel.TextColor3 = self.CurrentTheme.TextSecondary
    
    local closeButton = self:Create("TextButton", {
        Parent = notification,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundTransparency = 1,
        Text = "X",
        Font = Enum.Font.GothamBold,
        TextSize = 18
    })
    self:ApplyTheme(closeButton)
    
    closeButton.MouseButton1Click:Connect(function()
        notification:Destroy()
    end)
    
    -- Animação de entrada
    notification.Position = UDim2.new(0.1, 0, -0.1, 0)
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.1, 0, 0.05, 0)
    }):Play()
    
    -- Fechar automaticamente
    task.spawn(function()
        wait(duration)
        if notification and notification.Parent then
            TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0.1, 0, -0.1, 0)
            }):Play()
            wait(0.3)
            notification:Destroy()
        end
    end)
end

-- Inicialização
function NexusUI:Init(themeName)
    self.CurrentTheme = self.Themes[themeName] or self.Themes.Dark
    return self
end

return NexusUI:Init("Dark")