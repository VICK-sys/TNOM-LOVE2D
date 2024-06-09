local game = {}

function game.load()
    game.images = {
        background = love.graphics.newImage("assets/images/inGame/Black.png"),
        desk = love.graphics.newImage("assets/images/inGame/Office2.png"),
        office = love.graphics.newImage("assets/images/inGame/Office.png"),
    }
    game.music = love.audio.newSource("assets/music/office_ambience.ogg", "stream")
    game.musicTimer = 3
    game.fade = {alpha = 0}
    game.fadeTween = require("libs.tween").new(3, game.fade, {alpha = 1}, 'linear')
    game.offsets = {desk = {x = 0, y = 0}, office = {x = 0, y = 0}}
    game.camera = {x = 0, y = 0, scale = 1}
    game.cameraLimit = {x = game.images.office:getWidth() - love.graphics.getWidth() - 135, y = 0}
end

function game.update(dt)
    game.fadeTween:update(dt)
    game.musicTimer = game.musicTimer - dt
    if game.musicTimer <= 0 then
        game.music:play()
    end

    local centerX = love.graphics.getWidth() / 2
    local mouseX, mouseY = love.mouse.getPosition()
    local distanceDesk = mouseX - centerX - 75
    local distanceOffice = centerX - mouseX
    local speed = 0.1
    game.offsets.desk.x = math.max(0, math.min(game.offsets.desk.x + distanceDesk * speed * dt, game.cameraLimit.x - 10))
    game.offsets.office.x = math.max(0, math.min(game.offsets.office.x + distanceOffice * speed * dt, game.cameraLimit.x))
end

function game.draw()
    local scale = game.camera.scale
    love.graphics.setColor(0, 0, 0, game.fade.alpha)
    love.graphics.draw(game.images.background, -game.camera.x * scale, 0, 0, scale)
    love.graphics.draw(game.images.background, (game.camera.x + game.images.background:getWidth() - love.graphics.getWidth()) * scale, 0, 0, scale)
    love.graphics.setColor(1, 1, 1, game.fade.alpha)

    local imageWidth = game.images.office:getWidth()
    local imageHeight = game.images.office:getHeight()
    love.graphics.draw(game.images.office, game.offsets.office.x + (love.graphics.getWidth()/2 - imageWidth/2) * scale, game.offsets.office.y + (love.graphics.getHeight()/2 - imageHeight/2) * scale, 0, scale, scale)

    local imageWidth2 = game.images.desk:getWidth()
    local imageHeight2 = game.images.desk:getHeight() / 3.5
    love.graphics.draw(game.images.desk, game.offsets.desk.x + (love.graphics.getWidth()/2 - imageWidth2/2) * scale, game.offsets.desk.y + (love.graphics.getHeight()/2 - imageHeight2/2) * scale, 0, scale, scale)
end

return game

