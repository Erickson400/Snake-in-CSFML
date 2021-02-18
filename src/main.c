#include <stdio.h>
#include <stdlib.h>
#include "Game.h"

#include "SFML/Graphics.h"

#define SCREEN_SIZE 700

int main() {
	sfRenderWindow* window = sfRenderWindow_create((sfVideoMode){700,700}, "Snake in CSFML, by Eric", sfClose | sfTitlebar, NULL);
	sfView* view = sfView_create();

	// Set viewport size
	sfView_setCenter(view, (sfVector2f) { MAP_SIZE /2, MAP_SIZE /2 });
	sfView_setSize(view, (sfVector2f) { MAP_SIZE, MAP_SIZE });

	sfRenderWindow_setFramerateLimit(window, 60);
	sfRenderWindow_setView(window, view);
	sfRenderWindow_setKeyRepeatEnabled(window, sfFalse);

	Game_Setup();
	printf("Enjoy!");

	while (sfRenderWindow_isOpen(window)) {
		sfEvent event;
		while (sfRenderWindow_pollEvent(window, &event)) {

			// Key Input
			Game_Input(&event);
			if (event.type == sfEvtClosed) {
				sfRenderWindow_close(window);
			}else if (event.type == sfEvtKeyPressed) {
				if (event.key.code == sfKeyEscape) {
					sfRenderWindow_close(window);
				}
			}
		}

		// Render/Update
		Game_Draw(window);
		sfRenderWindow_display(window);
	}

	Game_Destroy();
	sfView_destroy(view);
	sfRenderWindow_destroy(window);
	return 0;
}














