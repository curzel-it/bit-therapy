#include "game_loop.h"

std::thread startGameLoop(Game * game) {
    return std::thread([game]() {
        bool gameIsRunning = true;
        auto frameDuration = std::chrono::milliseconds(uint32_t(1000 / game->gameFps));
        
        while (gameIsRunning) { 
            auto frameStart = std::chrono::steady_clock::now();
            game->update(frameDuration);
            auto frameEnd = std::chrono::steady_clock::now();
            auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(frameEnd - frameStart);
            
            auto sleepDuration = frameDuration - elapsedTime;
            if (sleepDuration > std::chrono::milliseconds(0)) {
                std::this_thread::sleep_for(sleepDuration);
            }
        }
    });
}