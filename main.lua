local player_size = 16
local player_speed = 180 --px/ssd

function _config()
    ---@type Usagi.Config
    return {
        name = "Shmup",
        game_id = "com.cde123456781.shmup",
        game_width = 320,
        game_height = 320,
    }
end

function _init()
    -- Live reload preserves globals across saved edits but resets locals.
    -- Stash mutable game state in a capitalized global like `State` so it
    -- survives reloads; F5 calls _init again to reset.
    State = {
        player = {
            x = usagi.GAME_W / 2 - player_size / 2,
            y = usagi.GAME_H - 60
        },
        night_mode = false,
    }
end

function _update(dt)
    local input_delta = { x = 0, y = 0 };
    if (input.held(input.UP)) then
        input_delta.y -= 1
    end
    if (input.held(input.DOWN)) then
        input_delta.y += 1
    end
    if (input.held(input.LEFT)) then
        input_delta.x -= 1
    end
    if (input.held(input.RIGHT)) then
        input_delta.x += 1
    end

    if (input.key_pressed(input.KEY_SPACE)) then
        State.night_mode = not State.night_mode
    end

    local normalised_input = util.vec_normalize(input_delta);
    State.player.x += normalised_input.x * player_speed * dt
    State.player.y += normalised_input.y * player_speed * dt
    State.player.x = util.clamp(State.player.x, 0, usagi.GAME_W - player_size)
    State.player.y = util.clamp(State.player.y, 0, usagi.GAME_H - player_size)
end

function _draw(dt)
    if (State.night_mode) then
        gfx.clear(gfx.COLOR_BLACK)
        gfx.rect_fill(
            State.player.x,
            State.player.y,
            player_size,
            player_size,
            gfx.COLOR_WHITE
        );
    else
        gfx.clear(gfx.COLOR_WHITE);
        gfx.rect_fill(
            State.player.x,
            State.player.y,
            player_size,
            player_size,
            gfx.COLOR_BLACK
        );
    end
end
