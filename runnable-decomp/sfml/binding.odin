package sfml

import "core:c"
foreign import sfml {
    "../csfml-system.lib",
    "../csfml-window.lib",
    "../csfml-graphics.lib",
}

@(default_calling_convention = "c")
foreign sfml {
    // Window
    sfRenderWindow_create :: proc(
        mode: sfVideoMode,
        title: cstring,
        style: sfWindowStyle,
        context_settings: ^sfContextSettings) -> ^sfRenderWindow ---
    sfRenderWindow_setFramerateLimit :: proc(window: ^sfRenderWindow, fps: c.uint) ---
    sfRenderWindow_setView :: proc(window: ^sfRenderWindow, view: ^sfView) ---
    sfRenderWindow_drawSprite :: proc(window: ^sfRenderWindow, sprite: ^sfSprite, states: ^sfRenderState) ---
    sfRenderWindow_setKeyRepeatEnabled :: proc(window: ^sfRenderWindow, enable: sfBool) ---
    sfRenderWindow_isOpen :: proc(window: ^sfRenderWindow) -> sfBool ---
    sfRenderWindow_pollEvent :: proc(window: ^sfRenderWindow, event: ^sfEvent) -> sfBool ---
    sfRenderWindow_display :: proc(window: ^sfRenderWindow) ---
    sfRenderWindow_clear :: proc(window: ^sfRenderWindow, color: sfColor) ---
    sfRenderWindow_close :: proc(window: ^sfRenderWindow) ---
    sfRenderWindow_destroy :: proc(window: ^sfRenderWindow) ---
    
    // View
    sfView_create :: proc() -> ^sfView ---
    sfView_setCenter :: proc(view: ^sfView, center: sfVector2f) ---
    sfView_setSize :: proc(view: ^sfView, size: sfVector2f) ---
    sfView_destroy :: proc(view: ^sfView) ---

    // Graphics
    sfImage_create :: proc(width, height: c.uint) -> ^sfImage ---
    sfImage_setPixel :: proc(image: ^sfImage, x, y: c.uint, color: sfColor) ---
    sfTexture_create :: proc(width, height: c.uint) -> ^sfTexture ---
    sfTexture_updateFromImage :: proc(texture: ^sfTexture, image: ^sfImage, x, y: c.uint) ---
    sfTexture_destroy :: proc(texture: ^sfTexture) ---
    sfSprite_create :: proc() -> ^sfSprite ---
    sfSprite_setTexture :: proc(sprite: ^sfSprite, texture: ^sfTexture, resetRect: sfBool) ---
    sfSprite_destroy :: proc(sprite: ^sfSprite) ---
}
