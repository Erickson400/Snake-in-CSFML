package sfml

sfWindowStyle :: enum int {
    None,
    Titlebar,
    Resize,
    Close,
    Fullscreen,
    Default,
}

sfContextSettings :: struct{}
sfContextSettingsNull :: proc() -> sfContextSettings {
    return sfContextSettings{}
}

sfRenderWindow :: struct{}
sfRenderState :: struct{}


sfRenderWindow_create :: proc(
    mode: sfVideoMode,
    title: string,
    style: sfWindowStyle,
    context_settings: sfContextSettings) -> ^sfRenderWindow{
    return new(sfRenderWindow)
}

sfRenderWindow_setFramerateLimit :: proc(window: ^sfRenderWindow, fps: int) {}

sfRenderWindow_setView :: proc(window: ^sfRenderWindow, view: ^sfView) {}

sfRenderWindow_drawSprite :: proc(window: ^sfRenderWindow, sprite: ^sfSprite, states: ^sfRenderState) {}

sfRenderWindow_setKeyRepeatEnabled :: proc(window: ^sfRenderWindow, enable: bool) {}

sfRenderWindow_destroy :: proc(window: ^sfRenderWindow) {}

sfRenderWindow_isOpen :: proc(window: ^sfRenderWindow) -> bool { return true }

sfRenderWindow_pollEvent :: proc(window: ^sfRenderWindow, event: ^sfEvent) -> bool { return true }

sfRenderWindow_close :: proc(window: ^sfRenderWindow) {}

sfRenderWindow_display :: proc(window: ^sfRenderWindow) {}
