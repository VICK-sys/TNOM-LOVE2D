local stateManager = require("libs.stateManager")
local titleState = require("states.title")

local volume = 0.5
local volumeTimer = 0
local volumeDisplayTime = 2

function love.keypressed(key)
    if key == "-" then
        volume = math.max(0, volume - 0.1)
        volumeTimer = volumeDisplayTime
    elseif key == "=" then
        volume = math.min(1, volume + 0.1)
        volumeTimer = volumeDisplayTime
    elseif key == "0" then
        if volume > 0 then
            volume = 0
            volumeTimer = volumeDisplayTime
        else
            volume = 1
            volumeTimer = volumeDisplayTime
        end
    end
    love.audio.setVolume(volume)
end

local function drawVolumeBar()
    local barWidth = 200
    local barHeight = 20
    local barX = 550
    local barY = 20
    local fillWidth = volume * barWidth

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", barX, barY, fillWidth, barHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Volume: " .. math.floor(volume * 100) .. "%", barX, barY + barHeight + 5)
end

local function load()
    stateManager.switch(titleState)
end

local function update(dt)
    volumeTimer = math.max(0, volumeTimer - dt)
    stateManager.update(dt)
end

local function draw()
    stateManager.draw()
    if volumeTimer > 0 then
        drawVolumeBar()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    stateManager.mousepressed(x, y, button, istouch, presses)
end

love.load = load
love.update = update
love.draw = draw