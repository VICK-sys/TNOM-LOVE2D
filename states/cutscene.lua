local tween = require "libs.tween"
local stateManager = require "libs.stateManager"

local cutscene = {}
local imagePath = "assets/images/menuStuff/newspaper.png"
local duration = 2
local zoomSpeed = 0.015
local rotationSpeed = 0.005
local maxElapsedTime = 12.9
local skipKey = "f"

local image
local fade = {alpha = 1}
local zoom = 1
local rotation = 0
local elapsedTime = 0
local eventTriggered = false
local skipAllowed = false

function cutscene.load()
    image = love.graphics.newImage(imagePath)
    fadeTween = tween.new(duration, fade, {alpha = 0}, 'linear')
    cutsceneMusic = love.audio.newSource("assets/music/news_in.ogg", "static")
    cutsceneMusic:play()
    skipAllowed = true
end

function cutscene.update(dt)
    fadeTween:update(dt)
    if love.keyboard.isDown(skipKey) and skipAllowed then
        love.audio.stop(cutsceneMusic)
        stateManager.switch(require "states/night")
    end
    zoom = zoom + zoomSpeed * dt
    rotation = rotation + rotationSpeed * dt
    elapsedTime = elapsedTime + dt
    if elapsedTime > maxElapsedTime and not eventTriggered then
        stateManager.switch(require "states/night")
    end
end

function cutscene.draw()
    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    love.graphics.scale(zoom, zoom)
    love.graphics.rotate(rotation)
    love.graphics.translate(-image:getWidth() / 2, -image:getHeight() / 2)
    love.graphics.draw(image, 0, 0)
    love.graphics.pop()
    love.graphics.setColor(0, 0, 0, fade.alpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
    if skipAllowed then
        local font = love.graphics.newFont(12)
        love.graphics.setFont(font)
        love.graphics.print('Press F to skip', love.graphics.getWidth() - 100, love.graphics.getHeight() - 30)
    end
end

return cutscene

