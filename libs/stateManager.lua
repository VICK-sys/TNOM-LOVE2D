-- stateManager.lua
local stateManager = {}

stateManager.currentState = nil

function stateManager.switch(state)
    stateManager.currentState = state
    if state.load then
        state.load()
    end
end

function stateManager.update(dt)
    if stateManager.currentState and stateManager.currentState.update then
        stateManager.currentState.update(dt)
    end
end

function stateManager.draw()
    if stateManager.currentState and stateManager.currentState.draw then
        stateManager.currentState.draw()
    end
end

function stateManager.mousepressed(x, y, button, istouch, presses)
    if stateManager.currentState and stateManager.currentState.mousepressed then
        stateManager.currentState.mousepressed(x, y, button, istouch, presses)
    end
end

return stateManager
