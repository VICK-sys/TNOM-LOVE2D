local text = "Night 1\n\n12 AM"
local displayedText = ""
local textIndex = 1
local typingSpeed = 0.1
local pauseDuration = 2
local fadeDuration = 2

local textTimer = 0
local pauseTimer = 0
local fadeTimer = 0
local alpha = 1
local fading = false

local stateManager = require "libs.stateManager"

local soundPool = {}
for i = 1, 10 do
    table.insert(soundPool, love.audio.newSource("assets/sounds/letter_sound.ogg", "static"))
end
local currentSoundIndex = 1

local night = {}

function night.load()
    night.font = love.graphics.newFont("assets/fonts/vcr.ttf", 64)
    love.graphics.setFont(night.font)
end

function night.update(dt)
    if displayedText == "Night 1\n\n12 AM" and not fading then
        fadeTimer = fadeTimer + dt
        if fadeTimer >= fadeDuration then
            fading = true
        end
    elseif fading then
        alpha = math.max(0, alpha - dt / 3)
        if alpha == 0 then
            fading = false
            stateManager.switch(require "states/game")
        end
    elseif pauseTimer < pauseDuration then
        pauseTimer = pauseTimer + dt
    else
        textTimer = textTimer + dt
        if textTimer >= typingSpeed and textIndex <= #text then
            displayedText = displayedText .. text:sub(textIndex, textIndex)
            textIndex = textIndex + 1
            textTimer = 0

            soundPool[currentSoundIndex]:stop()
            soundPool[currentSoundIndex]:play()
            currentSoundIndex = (currentSoundIndex % #soundPool) + 1

            if displayedText == "Night 1" then
                pauseTimer = 0
            end
        end
    end
end

function night.draw()
    local textWidth = night.font:getWidth(displayedText)
    local textHeight = night.font:getHeight()

    local x = (love.graphics.getWidth() - textWidth) / 2
    local y = (love.graphics.getHeight() - textHeight) / 3

    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.printf(displayedText, x, y, textWidth, "center")
    love.graphics.setColor(1, 1, 1, 1)
end

return night

