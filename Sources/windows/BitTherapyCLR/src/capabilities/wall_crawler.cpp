#include "wall_crawler.h"

#include <chrono>
#include <iostream>

#include "../game/game.h"

WallCrawler::WallCrawler(Rect bounds) : 
    bounds(bounds)
{}

void WallCrawler::update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) {
    if (entity->direction.x > 0 && entity->frame.maxX() >= bounds.w) {
        entity->direction.x = 0.0;
        entity->direction.y = -1.0;
        entity->frame.x = bounds.w - entity->frame.w;
        return;
    }    
    if (entity->direction.x < 0 && entity->frame.x <= bounds.x) {
        entity->direction.x = 0.0;
        entity->direction.y = 1.0;
        entity->frame.x = 0.0;
        return;
    }
    if (entity->direction.y > 0 && entity->frame.maxY() >= bounds.h) {
        entity->direction.x = entity->frame.x == bounds.x ? 1.0 : -1.0;
        entity->direction.y = 0.0;
        entity->frame.y = bounds.h - entity->frame.h;
        return;
    }
    if (entity->direction.y < 0 && entity->frame.y <= bounds.y - entity->frame.h) {
        entity->direction.x = 0.0;
        entity->direction.y = 1.0;
        
        if (entity->frame.x == bounds.x) {
            entity->frame.x = bounds.w - entity->frame.w;
        } else {
            entity->frame.x = bounds.x;
        }
        return;
    }
}