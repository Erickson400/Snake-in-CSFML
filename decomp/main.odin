package main

import "sfml"
import "system"

Direction :: enum int { UP, DOWN, LEFT, RIGHT }
Tail :: struct { x, y: u8 }

image: ^sfml.sfImage
texture: ^sfml.sfTexture
sprite: ^sfml.sfSprite

tick_modulo: u8
frame_counter: int
paused: bool
input_delay: bool // Incomplete
key_north: bool
key_west: bool
key_south: bool
key_east: bool

fruit_a_position: [2]u8
fruit_b_position: [2]u8

snake_position: [2]u8
snake_move_dir: Direction
snake_length: u16
tails: [2500]Tail

// Complete
main :: proc() {
    window := sfml.sfRenderWindow_create({700, 700, 0}, "Snake in CSFML, by Eric", .Default, sfml.sfContextSettingsNull())
    view := sfml.sfView_create()
    sfml.sfView_setCenter(view, {25, 25})
    sfml.sfView_setSize(view, {50, 50})
    sfml.sfRenderWindow_setFramerateLimit(window, 60)
    sfml.sfRenderWindow_setView(window, view)
    sfml.sfRenderWindow_setKeyRepeatEnabled(window, false)
    InitGame()
    system.printf("Enjoy!")
    for sfml.sfRenderWindow_isOpen(window) {
        event: sfml.sfEvent
        for sfml.sfRenderWindow_pollEvent(window, &event) {
            HandleInput(event)
            if (event.type == sfml.sfEventType.sfEvtClosed) {
                sfml.sfRenderWindow_close(window)
            } else if ((event.type == sfml.sfEventType.sfEvtKeyPressed) && (event.key.code == sfml.sfKeyCode.sfKeyEscape)) {
                sfml.sfRenderWindow_close(window)
            }
        }
        Update(window)
        sfml.sfRenderWindow_display(window)
    }
    DestroyGame()
    sfml.sfView_destroy(view)
    sfml.sfRenderWindow_destroy(window)
}

// Complete
InitGame :: proc() {
    image = sfml.sfImage_create(50, 50)
    texture = sfml.sfTexture_create(50, 50)
    sprite = sfml.sfSprite_create()
    sfml.sfSprite_setTexture(sprite, texture)
    system.srand(0xe0134fb)
    InitGameObjects()
}

// Complete
InitGameObjects :: proc() {
    snake_position = {25, 25}
    snake_move_dir = .RIGHT
    snake_length = 0
    frame_counter = 0
    for i in 0..<6 {
        if i == 0 {
            tails[0] = {25, 25}
        } else {
            tails[i] = {snake_position[0] - u8(i), snake_position[1]}
        }
        snake_length += 1
    }
    ChangeFruitPosition(&fruit_a_position)
    ChangeFruitPosition(&fruit_b_position)
}

// Complete
ChangeFruitPosition :: proc(fruit_position: ^[2]u8) {
    fruit_position[0] = u8(system.rand() % 50)
    fruit_position[1] = u8(system.rand() % 50)
}

// Complete
HandleInput :: proc(event: sfml.sfEvent) {
    if event.type == sfml.sfEventType.sfEvtMouseButtonPressed \
    && event.mouseButton.button == sfml.sfMouseButton.sfMouseLeft {
        tick_modulo = 2
    } else if event.type == sfml.sfEventType.sfEvtMouseButtonReleased \
    && event.mouseButton.button == sfml.sfMouseButton.sfMouseLeft {
        tick_modulo = 10
    }

    if event.type == sfml.sfEventType.sfEvtKeyPressed \
    && event.key.code == sfml.sfKeyCode.sfKeySpace {
        paused = !paused
    }
    if event.type == sfml.sfEventType.sfEvtKeyPressed {
        if input_delay do return
    }
    input_delay = false
    key_north = false
    key_west = false
    key_south = false
    key_east = false
    key_code := event.key.code
    #partial switch key_code {
    case sfml.sfKeyCode.sfKeyA:
        key_west = true
    case sfml.sfKeyCode.sfKeyD:
        key_east = true
    case sfml.sfKeyCode.sfKeyS:
        key_south = true
    case sfml.sfKeyCode.sfKeyW:
        key_north = true
    }

    switch snake_move_dir {
    case .UP:
        if (key_west) {
            snake_move_dir = .LEFT
        } else if (key_east) {
            snake_move_dir = .RIGHT
        }
    case .LEFT:
        if (key_south) {
            snake_move_dir = .DOWN
        } else if (key_north) {
            snake_move_dir = .UP
        }
    case .DOWN:
        if (key_east) {
            snake_move_dir = .RIGHT
        } else if (key_west) {
            snake_move_dir = .LEFT
        }
    case .RIGHT:
        if (key_north) {
            snake_move_dir = .UP
        } else if (key_south) {
            snake_move_dir = .DOWN
        }
    }
}

// Complete
Update :: proc(window: ^sfml.sfRenderWindow) {
    if !paused {
        if frame_counter % int(tick_modulo) == 0 {
            switch snake_move_dir {
            case .UP:
                snake_position[1] -= 1
            case .LEFT:
                snake_position[0] -= 1
            case .DOWN:
                snake_position[1] += 1
            case .RIGHT:
                snake_position[0] += 1
            }

            if snake_position[0] == 255 {
                snake_position[0] = 49
            }
            if snake_position[1] == 255 {
                snake_position[1] = 49
            }
            if snake_position[0] == 50 {
                snake_position[0] = 0
            }
            if snake_position[1] == 50 {
                snake_position[1] = 0
            }

            input_delay = true
            MoveTailsForward()
            system.srand()
            CheckCollisionWithTail()
            CheckFruitCollision(&fruit_a_position)
            CheckFruitCollision(&fruit_b_position)
        }

        frame_counter += 1
        
        // Draw snake head
        dark_green := sfml.sfColor{0, 100, 0, 255}
        sfml.sfImage_setPixel(image, int(snake_position[0]), int(snake_position[1]), dark_green)
        
        // Draw tails
        green := sfml.sfColor{0, 255, 0, 255}
        for i in 0..<snake_length {
            if i != 0 {
                sfml.sfImage_setPixel(image, int(tails[i].x), int(tails[i].y), green)
            }
        }

        // Draw fruit A and B
        red := sfml.sfColor{255, 0, 0, 255}
        sfml.sfImage_setPixel(image, int(fruit_a_position[0]), int(fruit_a_position[1]), red)
        sfml.sfImage_setPixel(image, int(fruit_b_position[0]), int(fruit_b_position[1]), red)

        // Update Texture. Then render sprite to window
        sfml.sfTexture_updateFromImage(texture, image)
        sfml.sfRenderWindow_drawSprite(window, sprite, nil)
    }
}

// Complete
CheckFruitCollision :: proc(fruit_position: ^[2]u8) {
    for i in 0..<snake_length {
        if (tails[i].x == fruit_position[0]) \
        && (tails[i].y == fruit_position[1]) {
            ChangeFruitPosition(fruit_position)
            AddTail()
        }
    }
}

// Complete
AddTail :: proc() {
    if snake_length < 2500 {
        tails[snake_length] = tails[snake_length - 1]
        snake_length += 1
    }
}

// Complete
CheckCollisionWithTail :: proc() {
    i := 1
    for {
        if int(snake_length) <= i {
            return
        }
        if (tails[i].x == snake_position[0]) \
        && (tails[i].y == snake_position[1]) {
            break
        }
        i += 1
    }
    InitGameObjects()
}

// Complete
MoveTailsForward :: proc() {
    for i in 0..<snake_length {
        tail_index := snake_length - i - 1
        if tail_index == 0 {
            tails[0] = { snake_position[0], snake_position[1] }
        } else {
            tails[tail_index] = tails[tail_index - 1]
        }
    }
}

// Complete
DestroyGame :: proc() {
    sfml.sfTexture_destroy(texture)
    sfml.sfSprite_destroy(sprite)
}