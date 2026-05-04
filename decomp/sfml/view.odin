package sfml


sfView :: struct{}

sfView_create :: proc() -> ^sfView {
    return new(sfView)
}

sfView_setCenter :: proc(view: ^sfView, center: sfVector2f) {}

sfView_setSize :: proc(view: ^sfView, size: sfVector2f) {}

sfView_destroy :: proc(view: ^sfView) {}
