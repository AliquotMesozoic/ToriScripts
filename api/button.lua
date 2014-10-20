-- Button API written by Motota
local Globals = dofile("api/globals.lua")

local COLORS = Globals.COLORS
local TEXT_SIZE = Globals.TEXT_SIZE

local SCRIPT_ID = "motota.buttonAPI"



local buttons = {}

local function setColor(color)
	set_color(color[1], color[2], color[3], color[4])
end

Button = {
	defaults = {
		__index = {
			draw = function(self)
				setColor(self.color)
				draw_quad(self.x, self.y, self.width, self.height)
				setColor(COLORS.BLACK)
				draw_text(self.text, 
					self.x + (self.width / 2 - (TEXT_SIZE[1] * #self.text )/ 2), 
					self.y + (self.height / 2 - TEXT_SIZE[2] / 2), 1)

			end;
			setColor = function(self, color)
				self.color = color
			end;
			setText = function(self, text)
				self.text = text
			end;
			setClick = function(self, onClick)
				self.onClick = onClick
			end;
			setHover = function(self, onHover)
				self.onHover = onHover
			end;
			onHover = function(self, id)
				self:setColor(COLORS.BLUE)
			end;
			setNotHover = function(self, onNotHover)
				self.onNotHover = onNotHover
			end;
			onNotHover = function(self, id)
				self.color = self.defaultColor;
			end;
			setDimensions = function(self, x, y, width, height)
				self.x = x
				self.y = y
				self.width = width
				self.height = height
			end;
			setVisible = function(self, bool)
				self.visible = bool
			end;
			inBounds = function(self, x, y)
				return (x > self.x and x < (self.x + self.width) and y > self.y and y < (self.y + self.height))
			end;
		};
	};
	new = function(self, text, x, y, width, height, color)
		table.insert(buttons, setmetatable({
			x = x;
			y = y;
			width = width;
			height = height;
			text = text;
			color = color;
			defaultColor = color;
			visible = true;
		}, self.defaults))
		return buttons[#buttons]
	end;
	remove = function(self, buttonId)
		table.remove(buttons, buttonId)
	end;
}

local function draw()
	local function drawButtons()
		for index, button in pairs(buttons) do
			if (button.visible) then
				button:draw()
			end
		end
	end

	drawButtons()
end

local function mouseMove(mouseX, mouseY)
	for index, button in pairs(buttons) do
		if (button.visible and button.onHover and button:inBounds(mouseX, mouseY)) then
			button:onHover(index)
		elseif (button.visible and button.onNotHover) then
			button:onNotHover(index)
		end
	end
end

local function mouseUp(mouseButton, mouseX, mouseY)
	for index, button in pairs(buttons) do
		if (button.visible and button.onClick and button:inBounds(mouseX, mouseY)) then
			button:onClick(mouseButton, index)
		end
	end
end

add_hook("draw2d", SCRIPT_ID, draw)
add_hook("mouse_move", SCRIPT_ID, mouseMove)
add_hook("mouse_button_up", SCRIPT_ID, mouseUp)

return Button