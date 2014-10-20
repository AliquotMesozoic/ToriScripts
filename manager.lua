-- Script manager written by Motota
local Globals = dofile("api/globals.lua")

local CLOSE_MENU_DELAY = 0.5


local Button = dofile("api/button.lua")
local COLORS = Globals.COLORS

local button = Button:new("Scripts", 75, 25, 75, 30, COLORS.BLACK)

local scripts = get_files("data/script", "lua")


local maxLength = 0
for _, s in pairs(scripts) do
	if #s > maxLength then
		maxLength = #s
	end
end
maxLength = maxLength * Globals.TEXT_SIZE[1] + 15

for y=1, #scripts do
	Button:new(scripts[y], 75, 30+(y*30), maxLength, 30, COLORS.BLACK)
end

button:setClick(function(self)
	echo(os.clock())
end)