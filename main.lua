function love.load()
    love.window.setMode(800, 600)
    gravity = 500
    friction = 0.99
    rotationSpeed = 2
    balls = {}

    for i = 1, 10 do
        spawnBall()
    end

    shader = love.graphics.newShader([[
        extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 pixel = Texel(texture, texture_coords);
            float wave = sin(screen_coords.y * 0.05 + time) * 0.05;
            pixel.r = pixel.r + wave;
            return pixel * color;
        }
    ]])
end

function spawnBall()
    local ball = {
        x = math.random(100, 700),
        y = math.random(100, 500),
        radius = math.random(15, 25),
        speedX = math.random(-200, 200),
        speedY = math.random(-200, 200),
        color = {math.random(), math.random(), math.random()},
        rotation = 0,
        angularSpeed = math.random(-rotationSpeed, rotationSpeed)
    }
    table.insert(balls, ball)
end

function love.update(dt)
    for _, ball in ipairs(balls) do
        ball.speedY = ball.speedY + gravity * dt
        ball.speedX = ball.speedX * friction
        ball.speedY = ball.speedY * friction
        
        ball.x = ball.x + ball.speedX * dt
        ball.y = ball.y + ball.speedY * dt
        
        ball.rotation = ball.rotation + ball.angularSpeed * dt

        if ball.x - ball.radius < 0 then
            ball.x = ball.radius
            ball.speedX = -ball.speedX
        elseif ball.x + ball.radius > love.graphics.getWidth() then
            ball.x = love.graphics.getWidth() - ball.radius
            ball.speedX = -ball.speedX
        end
        
        if ball.y - ball.radius < 0 then
            ball.y = ball.radius
            ball.speedY = -ball.speedY
        elseif ball.y + ball.radius > love.graphics.getHeight() then
            ball.y = love.graphics.getHeight() - ball.radius
            ball.speedY = -ball.speedY
        end
    end
end

function love.draw()
    shader:send("time", love.timer.getTime())
    love.graphics.setShader(shader)
    for _, ball in ipairs(balls) do
        love.graphics.setColor(ball.color)
        love.graphics.push()
        love.graphics.translate(ball.x, ball.y)
        love.graphics.rotate(ball.rotation)
        love.graphics.circle("fill", 0, 0, ball.radius)
        love.graphics.pop()
    end
    love.graphics.setShader()
end
