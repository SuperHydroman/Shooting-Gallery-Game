--[[

Game: Shooting Gallery
Price: $1.50
Author: Gideon van den Herik
Copyright: All rights reserved ©

--]]


-- Load function runs when the game loads.
function love.load()
	target = {}
	target.x = 300
	target.y = 300
	target.radius = 50

	score = 0
	highscore = 0
	oldHighscore = 0
	timer = 0					-- The amount of time the player gets					--[[
	gameState = 1				-- GameState 1 = MainMenu, GameState2 = InSession			These all are defined in love.mousePressed()
	gameDelay = 0				-- Delay(seconds) in between games						--]]
	delayComplete = false

	gameFont = love.graphics.newFont(30)
	desc = love.graphics.newFont(25)
	extra_desc = love.graphics.newFont(20)

	sprites = {}
	sprites.sky = love.graphics.newImage("assets/sprites/sky.png")
	sprites.targets = love.graphics.newImage("assets/sprites/targets.png")
	sprites.crosshair = love.graphics.newImage("assets/sprites/crosshair.png")

	love.mouse.setVisible(false)

	bgm = love.audio.newSource("assets/audio/tracks/bg-music.mp3", "stream")
	sfx = love.audio.newSource("assets/audio/sfx/bullet-impact.wav", "static")
--	start = love.audio.newSource("assets/audio/sfx/start-sound.wav", "static")		-- Preset start sound (better?)
	start = love.audio.newSource("assets/audio/sfx/go.wav", "static")				-- Custom start sound (funny?)
--	gameOver = love.audio.newSource("assets/audio/sfx/gameOver2.mp3", "static")		-- Preset Game Oversound(better?)
	gameOver = love.audio.newSource("assets/audio/sfx/gameOver.wav", "static")		-- Custom Game Oversound(funny?)


-- Background music properties
	bgm:setVolume(0.4)
	bgm:setLooping(true)

-- Sound effect properties
	sfx:setVolume(1)
	start:setVolume(1)
	gameOver:setVolume(0.5)

-- Initiating Audio play
	bgm:play()

end

-- Update funtion updates the game
function  love.update(dt)			-- DT = Delta Time
	if timer > 0 then
		timer = timer - dt
	end

	if timer < 0 then
		timer = 0
		gameOver:play()
		oldHighscore = highscore
		if score > highscore then
			highscore = score
		end
		gameState= 1
	elseif timer == 0 then
		if gameDelay > 0 then
			gameDelay = gameDelay - dt
		end

		if gameDelay < 0 then
			gameDelay = 0
			delayComplete = true
		end
	end
end

-- Creates the visuals of your game
function love.draw()
	love.graphics.draw(sprites.sky, 0, 0)

	love.graphics.setFont(gameFont)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Score: " .. score, 15, 0)
	love.graphics.print("Time: " .. math.ceil(timer), 315, 0)
	love.graphics.print("Highscore: " .. highscore, 15, love.graphics.getHeight() - 40)

	if gameState == 1 and gameDelay <= 0 then
		love.graphics.setFont(gameFont)
		love.graphics.printf("Click anywhere to begin..", 0, 250, love.graphics.getWidth(), "center")
	elseif gameState == 1 and gameDelay > 0 then
		love.graphics.printf("Congratulations!!", 0, 200, love.graphics.getWidth(), "center")
		love.graphics.setFont(desc)
		love.graphics.printf("You scored: "..score.." points!", 0, 250, love.graphics.getWidth(), "center")
		if score > oldHighscore then
			love.graphics.setFont(extra_desc)
			love.graphics.printf("You've beaten the highscore with " .. (score-oldHighscore) .. " points!", 0, 300, love.graphics.getWidth(), "center")
		end
	end

	if gameState == 2 then
		love.graphics.draw(sprites.targets, target.x - target.radius, target.y - target.radius)
	end
	love.graphics.draw(sprites.crosshair, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 and gameState == 2 and gameDelay == 3 then
		local mouseToTarget = distanceBetween(x, y, target.x, target.y)
		if mouseToTarget < target.radius then
			score = score + 1
			target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
			target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
			sfx:play()
		elseif mouseToTarget > target.radius and score ~= 0 then
			score = score - 1
		end
	elseif button == 1 and gameState == 1 and gameDelay == 0 then
		gameState = 2
		gameDelay = 3
		timer = 10
		score = 0
		start:play()
	end
end

function distanceBetween(x1, y1, x2, y2)
	return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end