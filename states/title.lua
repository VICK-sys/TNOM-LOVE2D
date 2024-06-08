local title = {}
local tween = require "libs.tween"
local stateManager = require "libs.stateManager"

local buttons = {}
local startTime
local backgroundMusic
local shader
local canvas

local logoPosition
local logoAlpha
local fade
local fadeTween
local fadeTweenBye

local titleBGPosition
local titleBGTween
local titleBGSprite

local nightSpriteVisibility

function title.load()
    title.images = {
        black = love.graphics.newImage("assets/images/menuStuff/black.png"),
        titleBG = love.graphics.newImage("assets/images/menuStuff/TitleBG.png"),
        titleLogo = love.graphics.newImage("assets/images/menuStuff/TitleLogoThing.png"),
        titleBG2 = love.graphics.newImage("assets/images/menuStuff/TitleBG2.png"),
        night1 = love.graphics.newImage("assets/images/menuStuff/night1.png"),
    }

    title.buttonImages = {
        newGame = love.graphics.newImage("assets/images/menuStuff/NewGameButton.png"),
        continue = love.graphics.newImage("assets/images/menuStuff/ContinueButton.png"),
    }

    title.newGameSound = love.audio.newSource("assets/sounds/new_game.ogg", "static")

    title.font = love.graphics.newFont(32)

    buttons = {
        {
            x = 40,
            y = 400,
            image = title.buttonImages.newGame,
            action = function()
                startFadeOut = true
                title.newGameSound:play()
            end,
            width = title.buttonImages.newGame:getWidth(),
            height = title.buttonImages.newGame:getHeight(),
            isHovered = false,
        },
        {
            x = 40,
            y = 550,
            image = title.buttonImages.continue,
            action = function() end,
            width = title.buttonImages.continue:getWidth(),
            height = title.buttonImages.continue:getHeight(),
            isHovered = false,
        },
    }

    logoPosition = {x = love.graphics.getWidth() / 4, y = love.graphics.getHeight() / 2.6}

    fade = {alpha = 1}
    fadeTween = tween.new(2, fade, {alpha = 0}, 'linear')
    fadeTweenBye = tween.new(5.5, fade, {alpha = 1}, 'linear')

    backgroundMusic = love.audio.newSource("assets/music/menu_music.ogg", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:play()

    shader = love.graphics.newShader("assets/shaders/tv_shader.glsl")
    shader:send("resolution", {love.graphics.getWidth(), love.graphics.getHeight()})

    canvas = love.graphics.newCanvas()
    startTime = love.timer.getTime()

    titleBGPosition = {x = love.graphics.getWidth()}
    local pingPongTarget = {x = 525}
    titleBGTween = tween.new(2, titleBGPosition, pingPongTarget, 'inOutQuad')

    titleBGSprite = title.images.titleBG

    nightSpriteVisibility = {
        x = 400,
        y = 585,
        alpha = 0,
    }
end

function title.update(dt)
    fadeTween:update(dt)
    titleBGTween:update(dt)
    shader:send("time", love.timer.getTime() - startTime)

    if startFadeOut then
        backgroundMusic:stop()
        fadeTweenBye:update(dt)

        if fade.alpha >= 1 then
            stateManager.switch(require "states/cutscene")
        end
    end

    local mouseX, mouseY = love.mouse.getPosition()
    for _, button in ipairs(buttons) do
        button.isHovered = mouseX >= button.x and mouseX <= button.x + button.width and
                           mouseY >= button.y and mouseY <= button.y + button.height
    end

    nightSpriteVisibility.alpha = buttons[2].isHovered and 1 or 0
end

function title.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    love.graphics.draw(title.images.titleBG, titleBGPosition.x, (love.graphics.getHeight() - title.images.titleBG:getHeight()) / 3 + 1)

    love.graphics.setColor(1, 1, 1, logoAlpha)
    love.graphics.draw(title.images.titleLogo, logoPosition.x - title.images.titleLogo:getWidth() / 2, logoPosition.y - title.images.titleLogo:getHeight() / 2, 0, 0.7, 0.7)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(title.images.titleBG2, 0, 0)

    if nightSpriteVisibility.alpha > 0 then
        love.graphics.setColor(1, 1, 1, nightSpriteVisibility.alpha)
        love.graphics.draw(title.images.night1, nightSpriteVisibility.x, nightSpriteVisibility.y)
        love.graphics.setColor(1, 1, 1, 1)
    end

    for _, button in ipairs(buttons) do
        local alpha = button.isHovered and 1 or 0.5
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.draw(button.image, button.x, button.y)
    end

    love.graphics.setColor(0, 0, 0, fade.alpha)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setCanvas()

    love.graphics.setShader(shader)
    love.graphics.draw(canvas, 0, 0)
    love.graphics.setShader()
end

function title.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for _, button in ipairs(buttons) do
            if x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height then
                button.action()
            end
        end
    end
end

return title
