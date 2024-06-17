#ifndef LINEAR_MOVEMENT_H
#define LINEAR_MOVEMENT_H

#include "entity.h"

class LinearMovement : public EntityCapability {
public:
    void update(long timeSinceLastUpdate, Entity * entity) override;
};

#endif
