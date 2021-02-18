#include "Game.h"

static void addTail() {
	// Index points to EMPTY element
	if (tailIndex == MAP_SIZE * MAP_SIZE) return;
	tail[tailIndex] = (SnakeTail){ tail[tailIndex-1].x, tail[tailIndex-1].y };
	tailIndex++;
};
static void shiftTails() {
	//tail[4] = (SnakeTail){ tail[3].x,tail[3].y };
	//tail[3] = (SnakeTail){ tail[2].x,tail[2].y };
	//tail[2] = (SnakeTail){ tail[1].x,tail[1].y };
	//tail[1] = (SnakeTail){ tail[0].x,tail[0].y };
	//tail[0] = (SnakeTail){ player.x, player.y };
	
	for (uint16 i = 0; i < tailIndex; i++) { 
		uint16 index = tailIndex - i - 1; // goes from last tail to 0

		if (index == 0) {
			tail[index] = (SnakeTail){ player.x, player.y };
		}
		else {
			tail[index] = (SnakeTail){ tail[index-1].x,  tail[index-1].y };
		}
	}

}

static void food_randomLocation(Food* p_food) {
	p_food->x = rand() % MAP_SIZE;
	p_food->y = rand() % MAP_SIZE;
};
static void food_checkIfOnSnake(Food* p_food) {
	for (uint16 i = 0; i < tailIndex; i++) {
		if (p_food->x == tail[i].x && p_food->y == tail[i].y) {
			food_randomLocation(p_food);
			addTail();
		}
	}
};

static void Restart() {
	player = (SnakePlayer){ MAP_SIZE / 2,MAP_SIZE / 2 ,Right};
	tailIndex = 0;
	cycleCount = 0;

	// Setup the first 6 snake tails
	for (uint8 i = 0; i < 6; i++) {
		if (i == 0) {
			tail[i] = (SnakeTail){ player.x, player.y };
		}
		else {
			tail[i] = (SnakeTail){ player.x - i, player.y };
		}
		tailIndex++;
	}

	food_randomLocation(&food1); // Set the food's location
	food_randomLocation(&food2); // Set the food's location
}
static void snake_checkIfTouchedTail() {
	for (uint16 i = 1; i < tailIndex; i++) {
		if (tail[i].x == player.x && tail[i].y == player.y) {
			Restart();
			return;
		}
	}
}

void Game_Setup() {
	map = sfImage_create(MAP_SIZE, MAP_SIZE);
	texture = sfTexture_create(MAP_SIZE, MAP_SIZE);
	sprite = sfSprite_create();
	sfSprite_setTexture(sprite, texture, sfFalse);

	srand(SEED); // Set random number generator seed
	Restart();
};
void Game_Draw(sfRenderWindow* window) {
	if (b_isPaused) return; // Dont do anything if the game is paused

	// Update Player position per cycle
	if (cycleCount % cycleRate == 0) {
		switch (player.MovingDir)
		{
		case Up:
			player.y--;
			break;
		case Left:
			player.x--;
			break;
		case Down:
			player.y++;
			break;
		case Right:
			player.x++;
			break;
		}

		// Wraps the snake around the screen if it goes off edge
		if (player.x == 0xFF) player.x = MAP_SIZE - 1;
		if (player.y == 0xFF) player.y = MAP_SIZE - 1;
		if (player.x == MAP_SIZE) player.x = 0;
		if (player.y == MAP_SIZE) player.y = 0;

		b_hasMoved = 1; // Allows the Input function to change the snake's direction
		shiftTails(); // Shift the tails after the player moves
		(void)rand(); // Randomize the food's location for later

		// Collision checks
		snake_checkIfTouchedTail();
		food_checkIfOnSnake(&food1);
		food_checkIfOnSnake(&food2);
	}
	cycleCount++;

	

	// Clear Screen
	for (uint8 y = 0; y < 50; y++) {
		for (uint8 x = 0; x < 50; x++) {
			sfImage_setPixel(map, x, y, (sfColor) { 30,30,30, 255 });
		}
	}

	// Draw Player
	sfImage_setPixel(map, player.x, player.y, (sfColor) {0,200,0,255});

	// Draw tails
	for (uint16 i = 0; i < tailIndex; i++) { // Index is the size. not the last element
		if (i != 0) {
			sfImage_setPixel(map, tail[i].x, tail[i].y, sfGreen);
		}
	}

	// Draw Food
	sfImage_setPixel(map, food1.x, food1.y, sfRed);
	sfImage_setPixel(map, food2.x, food2.y, sfRed);

	sfTexture_updateFromImage(texture, map, 0, 0);
	sfRenderWindow_drawSprite(window, sprite, NULL);
};
void Game_Input(sfEvent* event) {

	// Speedup snake if mouse button is held
	if (event->type == sfEvtMouseButtonPressed) {
		if (event->mouseButton.button == sfMouseLeft) cycleRate = cycleRate_Boost;
	}
	if (event->type == sfEvtMouseButtonReleased) {
		if (event->mouseButton.button == sfMouseLeft) cycleRate = cycleRate_Normal;
	}

	// Pause toggle if space is pressed
	if (event->type == sfEvtKeyPressed) {
		if (event->key.code == sfKeySpace) b_isPaused = !b_isPaused;
	}

	// Movement keys
	if (event->type == sfEvtKeyPressed) { 
		if (!b_hasMoved) return; // Exit function if its not allowed to change the snake's direction
		b_hasMoved = 0; 

		// Resets the keys to released
		UpPressed = 0;
		LeftPressed = 0;
		DownPressed = 0;
		RightPressed = 0;

		//Check if specific key is pressed
		switch (event->key.code)
		{
		case sfKeyW:
			UpPressed = 1;
			break;
		case sfKeyA:
			LeftPressed = 1;
			break;
		case sfKeyS:
			DownPressed = 1;
			break;
		case sfKeyD:
			RightPressed = 1;
			break;
		}
	}

	// Only allow the snake to turn side to side depending on its facing direction
	switch (player.MovingDir)
	{
	case Up:
		if (LeftPressed) player.MovingDir = Left;
		if (RightPressed) player.MovingDir = Right;
		break;
	case Left:
		if (DownPressed) player.MovingDir = Down;
		if (UpPressed) player.MovingDir = Up;
		break;
	case Down:
		if (RightPressed) player.MovingDir = Right;
		if (LeftPressed) player.MovingDir = Left;
		break;
	case Right:
		if (UpPressed) player.MovingDir = Up;
		if (DownPressed) player.MovingDir = Down;
		break;
	}
};
void Game_Destroy() {
	sfTexture_destroy(texture);
	sfSprite_destroy(sprite);
};


