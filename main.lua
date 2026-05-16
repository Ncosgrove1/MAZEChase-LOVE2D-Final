-- ==========================================
-- MAZE CHASE - LOVE2D GAME
-- ==========================================

-- Game States: 'title', 'playing', 'win', 'gameover'
local gameState = "title"

-- Player settings
local player = { x = 2, y = 2, size = 20, speed = 15, lives = 3 }
local score = 0
local currentLevel = 1

-- Enemy settings
local enemy = { x = 10, y = 10, size = 20, speed = 2, timer = 0 }

-- Grid settings (15x15 grid, 0 = path, 1 = wall)
local gridSize = 20
local levels = {
    {
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1 },
        { 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1 },
        { 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
    },
    -- Level 2
    {
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1 },
        { 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1 },
        { 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
    },
    -- Level 3 (Harder)
    {
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1 },
        { 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 },
        { 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1 },
        { 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 },
        { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
    }
}

local currentMap = {}
local coins = {}

-- Load game configuration
function love.load()
    love.window.setTitle("Retro Maze Chase")
    love.window.setMode(300, 350) -- Extra 50px at the bottom for UI
    loadLevel(currentLevel)
    player.moveTimer = 0          -- Tracks time passed
    player.moveCooldown = 0.2     -- Seconds between moves (0.2 = 5 moves per second)
end

-- Load and setup a level layout
function loadLevel(levelIndex)
    -- Reset map
    currentMap = {}
    coins = {}

    local sourceMap = levels[levelIndex]
    for r = 1, #sourceMap do
        currentMap[r] = {}
        for c = 1, #sourceMap[r] do
            currentMap[r][c] = sourceMap[r][c]
            -- Places coin on path spaces
            if sourceMap[r][c] == 0 then
                table.insert(coins, { r = r, c = c })
            end
        end
    end

    -- Reset positions
    player.x = 2
    player.y = 2
    enemy.x = 13
    enemy.y = 13
end

-- Checks if coins are all collected
function checkWinCondition()
    if #coins == 0 then
        if currentLevel < #levels then
            currentLevel = currentLevel + 1
            loadLevel(currentLevel)
        else
            gameState = "win"
        end
    end
end

-- Handle input and game logic
function love.update(dt)
    if gameState == "playing" then
        -- Increase the timer by the time passed since the last frame
        player.moveTimer = player.moveTimer + dt

        -- Only checks for movement if enough time has passed
        if player.moveTimer >= player.moveCooldown then
            local nextX = player.x
            local nextY = player.y
            local moved = false

            if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
                nextY = player.y - 1
                moved = true
            elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
                nextY = player.y + 1
                moved = true
            elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
                nextX = player.x - 1
                moved = true
            elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
                nextX = player.x + 1
                moved = true
            end

            -- Checks boundaries and collision
            if moved then
                if currentMap[nextY] and currentMap[nextY][nextX] == 0 then
                    player.x = nextX
                    player.y = nextY
                end
                -- Reset the timer after an attempted move
                player.moveTimer = 0
            end
        end

        -- Collect coins
        for i, coin in ipairs(coins) do
            if coin.r == player.y and coin.c == player.x then
                table.remove(coins, i)
                score = score + 100
                break
            end
        end
        checkWinCondition()

        -- Enemy AI (Simple chase)
        enemy.timer = enemy.timer + dt
        if enemy.timer > 0.3 then
            enemy.timer = 0
            if enemy.x < player.x and currentMap[enemy.y][enemy.x + 1] == 0 then
                enemy.x = enemy.x + 1
            elseif enemy.x > player.x and currentMap[enemy.y][enemy.x - 1] == 0 then
                enemy.x = enemy.x - 1
            elseif enemy.y < player.y and currentMap[enemy.y + 1][enemy.x] == 0 then
                enemy.y = enemy.y + 1
            elseif enemy.y > player.y and currentMap[enemy.y - 1][enemy.x] == 0 then
                enemy.y = enemy.y - 1
            end
        end

        -- When the enemy catches player
        if enemy.x == player.x and enemy.y == player.y then
            player.lives = player.lives - 1
            if player.lives <= 0 then
                gameState = "gameover"
            else
                -- Respawn safely without resetting level
                player.x = 2
                player.y = 2
                enemy.x = 13
                enemy.y = 13
            end
        end
    end
end

-- Render graphics
function love.draw()
    -- Title Screen
    if gameState == "title" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("RETRO MAZE CHASE", 0, 100, 300, "center")
        love.graphics.printf("Press SPACE to Start", 0, 150, 300, "center")

        -- Playing State
    elseif gameState == "playing" then
        -- Draw Walls
        love.graphics.setColor(0.3, 0.5, 0.9)
        for r = 1, #currentMap do
            for c = 1, #currentMap[r] do
                if currentMap[r][c] == 1 then
                    love.graphics.rectangle("fill", (c - 1) * gridSize, (r - 1) * gridSize, gridSize - 1, gridSize - 1)
                end
            end
        end

        -- Coin Graphic
        love.graphics.setColor(1, 0.8, 0.2)
        for _, coin in ipairs(coins) do
            love.graphics.circle("fill", (coin.c - 1) * gridSize + 10, (coin.r - 1) * gridSize + 10, 3)
        end

        -- Player Graphic
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("fill", (player.x - 1) * gridSize + 2, (player.y - 1) * gridSize + 2, 16, 16)

        -- Enemy Graphic
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.rectangle("fill", (enemy.x - 1) * gridSize + 2, (enemy.y - 1) * gridSize + 2, 16, 16)

        -- UI (Bottom HUD)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. score, 10, 310)
        love.graphics.print("Lives: " .. player.lives, 230, 310)

        -- Win State
    elseif gameState == "win" then
        love.graphics.setColor(0, 1, 0)
        love.graphics.printf("YOU WIN!", 0, 100, 300, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Final Score: " .. score, 0, 140, 300, "center")
        love.graphics.printf("Press R to Restart", 0, 180, 300, "center")

        -- Game Over State
    elseif gameState == "gameover" then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("GAME OVER", 0, 100, 300, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Final Score: " .. score, 0, 140, 300, "center")
        love.graphics.printf("Press R to Restart", 0, 180, 300, "center")
    end
end

-- Button Presses
function love.keypressed(key)
    if gameState == "title" and key == "space" then
        gameState = "playing"
    elseif (gameState == "win" or gameState == "gameover") and key == "r" then
        -- Reset game variables
        score = 0
        currentLevel = 1
        player.lives = 3
        loadLevel(currentLevel)
        gameState = "playing"
    end
end
