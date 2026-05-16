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
        -- Player Movement (Grid based with arrow keys)
        local nextX = player.x
        local nextY = player.y

        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then nextY = player.y - 1 end
        if love.keyboard.isDown("down") or love.keyboard.isDown("s") then nextY = player.y + 1 end
        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then nextX = player.x - 1 end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then nextX = player.x + 1 end

        -- Check boundaries and collision
        if currentMap[nextY] and currentMap[nextY][nextX] == 0 then
            player.x = nextX
            player.y = nextY
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

        -- Enemy catch player
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
