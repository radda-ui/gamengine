io.stdout:setvbuf("no")

DEBUG = true

function love.load()
    love.keysPressed = {}
    love.callback = {}
    love.callback["escape"] = love.quit
    love.callback["f1"] = love.restart
end

function love.update(dt)
    require("libs.3rd.lurker").update(dt)
    for key, func in pairs(love.callback) do
        if love.keysPressed[key] then
            func()
        end
    end
    love.keysPressed = {}
end

function love.draw()
    love.graphics.clear(.2,.2,.2,1)
end

function love.keypressed(key)
    love.keysPressed[key] = true
end

function love.wasPressed(key)
    return love.keysPressed[key]
end

function love.quit()
    --save("props.lua")
    love.event.quit()
end

function love.restart()
    --save("props.lua")
    love.event.quit("restart")
end
