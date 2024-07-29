
function love.load()
    -- Set window size
    love.window.setMode(800, 600)
    
    gravity = 500
    
   
    balls = {}
    
  
    for i = 1, 10 do
        spawnBall()
    end
end

function spawnBall()
    local ball = {
        x = math.random(100, 700),
        y = math.random(100, 500),
        radius = 20,
        speedX = math.random(-200, 200),
        speedY = math.random(-200, 200),
        color = {math.random(), math.random(), math.random()}
    }
    table.insert(balls, ball)
end

function love.update(dt)
    for _, ball in ipairs(balls) do
        -- Apply gravity to the ball's vertical speed
        ball.speedY = ball.speedY + gravity * dt
      
        ball.x = ball.x + ball.speedX * dt
        ball.y = ball.y + ball.speedY * dt

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
    for _, ball in ipairs(balls) do
        love.graphics.setColor(ball.color)
        love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    end
end
