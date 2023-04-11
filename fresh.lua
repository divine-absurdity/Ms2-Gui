local tabs = {
    {
        name = "My Tab",
        elements = {
            {
                type = "toggle",
                name = "My Toggle",
                callback = function(value)
                    print(value)
                end
            }
        }
    },
    {
        name = "Another Tab",
        elements = {
            {
                type = "label",
                name = "My Label",
                text = "This is a label element"
            },
            {
                type = "textbox",
                name = "My Textbox",
                default = "Enter text here",
                callback = function(value)
                    print("Text entered:", value)
                end
            },
            {
                type = "button",
                name = "My Button",
                text = "Click me!",
                callback = function()
                    print("Button clicked!")
                end
            }
        }
    }
}

local theme = {
    background = Color3.fromRGB(32, 32, 32),
    text = Color3.fromRGB(255, 255, 255),
    primary = Color3.fromRGB(102, 102, 102),
    secondary = Color3.fromRGB(51, 51, 51),
    tertiary = Color3.fromRGB(77, 77, 77),
    accent = Color3.fromRGB(0, 162, 255)
}

-- create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MyGameGUI"

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.BackgroundTransparency = 1

local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Parent = mainFrame
tabFrame.Size = UDim2.new(0.25, 0, 1, 0)
tabFrame.BackgroundColor3 = theme.secondary

local elementFrame = Instance.new("Frame")
elementFrame.Name = "ElementFrame"
elementFrame.Parent = mainFrame
elementFrame.Position = UDim2.new(0.25, 0, 0, 0)
elementFrame.Size = UDim2.new(0.75, 0, 1, 0)
elementFrame.BackgroundColor3 = theme.primary

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = elementFrame
UIListLayout.SortOrder = Enum.SortOrder.Custom

local currentTab = nil
local tabButtons = {}

-- create tab buttons
for i, tab in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "TabButton" .. i
    tabButton.Parent = tabFrame
    tabButton.Position = UDim2.new(0, 10, 0, (i-1)*30 + 10)
    tabButton.Size = UDim2.new(0.9, -20, 0, 20)
    tabButton.BackgroundColor3 = theme.tertiary
    tabButton.BorderSizePixel = 0
    tabButton.TextColor3 = theme.text
    tabButton.Text = tab.name
    tabButton.Font = Enum.Font.SourceSans
    tabButton.TextSize = 14
    tabButton.AutoButtonColor = false
    
    -- set current tab to first tab
    if i == 1 then
        currentTab = tab
        tabButton.BackgroundColor3 = theme.primary
    end
    
    -- add callback to switch tabs
    tabButton.MouseButton1Click:Connect(function()
        currentTab = tab
        for _, instance in pairs(elementFrame:GetDescendants()) do
            if instance.ClassName ~= "UIListLayout" then
                instance:Destroy()
            end
        end
        for _, element in ipairs(tab.elements) do
            createGuiElement(element, elementFrame)
        end
        for _, button in ipairs(tabButtons) do
            if button == tabButton then
                button.BackgroundColor3 = theme.primary
            else
                button.BackgroundColor3 = theme.tertiary
            end
        end
    end)
    
    table.insert(tabButtons, tabButton)
end

-- function to create GUI element
function createGuiElement(element, parent)
    local guiElement = nil
    
    if element.type == "toggle" then
        guiElement = Instance.new("TextButton")
        guiElement.Name = "Toggle"
        guiElement.Parent = parent
        guiElement.Size = UDim2.new(1, 0, 0, 20)
        guiElement.BackgroundColor3 = theme.tertiary
        guiElement.BorderSizePixel = 0
        guiElement.TextColor3 = theme.text
        guiElement.Text = element.name
        guiElement.Font = Enum.Font.SourceSans
        guiElement.TextSize = 14
        guiElement.AutoButtonColor = false
        
        local toggleValue = false
        
        -- add callback to toggle button
        guiElement.MouseButton1Click:Connect(function()
            toggleValue = not toggleValue
            element.callback(toggleValue)
        end)
        
    elseif element.type == "label" then
        guiElement = Instance.new("TextLabel")
        guiElement.Name = "Label"
        guiElement.Parent = parent
        guiElement.Size = UDim2.new(1, 0, 0, 20)
        guiElement.BackgroundColor3 = theme.tertiary
        guiElement.BorderSizePixel = 0
        guiElement.TextColor3 = theme.text
        guiElement.Text = element.text
        guiElement.Font = Enum.Font.SourceSans
        guiElement.TextSize = 14
        
    elseif element.type == "textbox" then
        guiElement = Instance.new("TextBox")
        guiElement.Name = "Textbox"
        guiElement.Parent = parent
        guiElement.Size = UDim2.new(1, 0, 0, 20)
        guiElement.BackgroundColor3 = theme.tertiary
        guiElement.BorderSizePixel = 0
        guiElement.TextColor3 = theme.text
        guiElement.Text = element.default
        guiElement.Font = Enum.Font.SourceSans
        guiElement.TextSize = 14
        
        -- add callback to textbox
        guiElement.FocusLost:Connect(function()
            element.callback(guiElement.Text)
        end)
        
    elseif element.type == "button" then
        guiElement = Instance.new("TextButton")
        guiElement.Name = "Button"
        guiElement.Parent = parent
        guiElement.Size = UDim2.new(1, 0, 0, 20)
        guiElement.BackgroundColor3 = theme.tertiary
        guiElement.BorderSizePixel = 0
        guiElement.TextColor3 = theme.text
        guiElement.Text = element.text
        guiElement.Font = Enum.Font.SourceSans
        guiElement.TextSize = 14
        guiElement.AutoButtonColor = false
        
        -- add callback to button
        guiElement.MouseButton1Click:Connect(function()
            element.callback()
        end)
    end
    
    return guiElement
end

-- initialize GUI with first tab
for i, element in ipairs(currentTab.elements) do
    createGuiElement(element, elementFrame)
end

-- display GUI
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")