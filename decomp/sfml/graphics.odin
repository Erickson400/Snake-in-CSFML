package sfml

import "core:odin/ast"
sfImage :: struct {}
sfTexture :: struct {}
sfSprite :: struct {}
sfColor :: struct {r, g, b, a: u8}

sfImage_create :: proc(width, height: int) -> ^sfImage {
    return new(sfImage)
}

sfTexture_create :: proc(width, height: int) -> ^sfTexture {
    return new(sfTexture)
}

sfSprite_create :: proc() -> ^sfSprite {
    return new(sfSprite)
}

sfImage_setPixel :: proc(image: ^sfImage, x, y: int, color: sfColor) {}

sfSprite_setTexture :: proc(sprite: ^sfSprite, texture: ^sfTexture) {}

sfTexture_updateFromImage :: proc(texture: ^sfTexture, image: ^sfImage) {}

sfTexture_destroy :: proc(texture: ^sfTexture) {}

sfSprite_destroy :: proc(sprite: ^sfSprite) {}
