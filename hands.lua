dofile("sdk/draw_rounded_quad.lua")

local TEXT_WIDTH = 10
local TEXT_HEIGHT = 25

local COLORS = {
	["white"] = function()
		set_color(1, 1, 1, 0.5)
	end;
	["black"] = function()
		set_color(0, 0, 0, 0.3)
	end;
	["green"] = function()
		set_color(0, 150, 0, 0.5)
	end;
}

local hands = {
	["left"] = false;
	["right"] = false;
}

local gui = {
	["background"] = COLORS.black;

	["width"] = 35;
	["height"] = 35*2;
	["corners"] = 7;

	position = {
		["x"] = 15;
		["y"] = 100;
	}
}

local buttons = {
	[1] = {
		["background"] = COLORS.white;

		["width"] = (gui.width - 4);
		["height"] = (gui.height - 8) / 2;

		position = {
			["x"] = gui.position.x + 2;
			["y"] = gui.position.y + 2;
		};

		["text"] = "L";
		["hand"] = BODYPARTS.L_HAND;
	};
	[2] = {
		["background"] = COLORS.white;

		["width"] = (gui.width - 4);
		["height"] = (gui.height - 8) / 2;

		position = {
			["x"] = gui.position.x + 2;
			["y"] = gui.position.y + (gui.height / 2) + 2;
		};

		["text"] = "R";
		["hand"] = BODYPARTS.R_HAND;
	};
}

local function getPlayer()
	return get_world_state().selected_player
end

local function updateHandState()
	local player = getPlayer()
	if (player == - 1) then
		return
	end

	handmap = {
		[BODYPARTS.L_HAND] = buttons[1];
		[BODYPARTS.R_HAND] = buttons[2];
	}

	for hand, button in pairs(handmap) do
		if (get_grip_info(player, hand)) == 1 then
			button.background = COLORS.green
		else
			button.background = COLORS.white
		end
	end
end

local function mouseUp(mouseButton, mouseX, mouseY)
	local player = getPlayer()
	if (player == -1) then
		return
	end

	for index, button in pairs(buttons) do
		if (mouseX > button.position.x and mouseX < button.position.x + button.width and
			mouseY > button.position.y and mouseY < button.position.y + button.height) then
			if (button.background == COLORS.white) then
				set_grip_info(player, button.hand, 1)
			else
				set_grip_info(player, button.hand, 0)
			end
		end
	end
end

local function draw()
	updateHandState()

	local function drawGui()
		gui.background()
		draw_rounded_quad(gui.position.x, gui.position.y, gui.width, gui.height, gui.corners)
	end

	local function drawButtons()
		for _, button in pairs(buttons) do
			button.background()
			draw_rounded_quad(button.position.x, button.position.y, button.width, button.height, gui.corners)

			COLORS.black()

			draw_text(button.text, 
				button.position.x + (button.width / 2 - TEXT_WIDTH / 2), 
				button.position.y + (button.height / 2 - TEXT_HEIGHT / 2), 2 )
		end
	end

	drawGui()
	drawButtons()
end

local SCRIPT_ID = "hands.lua"

add_hook("draw2d", SCRIPT_ID, draw)
add_hook("mouse_button_up", SCRIPT_ID, mouseUp)