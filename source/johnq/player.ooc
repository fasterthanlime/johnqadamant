
// ours
import johnq/[johnq, stage, shot]
import johnq/stages/[game]

// third party
import dye/[core, sprite, math, primitives]

Player: class extends GlGroup {

    stage: GameStage

    hitbox: GlRectangle
    body: GlSprite

    vel := vec2(0.0, 0.0)
    maxVel := 8.0

    shotType := 0

    init: func (=stage) {
        hitbox = GlRectangle new(vec2(67, 42))
        hitbox color set!(255, 0, 0)
        hitbox opacity = 0.3
        hitbox pos y = -10
        add(hitbox)

        body = GlSprite new("assets/png/ship-small.png")
        add(body)
    }

    shoot: func {
        yDelta := 25
        xDelta := 8
        stage shots add(Shot new(stage, shotType, pos add(-xDelta, yDelta)))
        stage shots add(Shot new(stage, shotType, pos add( xDelta, yDelta)))
    }

    move: func (deltaX, deltaY: Float) {
        factor := 3.0
        vel x += deltaX * factor
        vel y += deltaY * factor

        constrainVel()
    }

    constrainVel: func {
        if (vel x > maxVel) {
            vel x = maxVel
        }

        if (vel x < -maxVel) {
            vel x = -maxVel
        }

        if (vel y > maxVel) {
            vel y = maxVel
        }

        if (vel y < -maxVel) {
            vel y = -maxVel
        }
    }

    constrainPos: func {
        if (pos x < 0) {
            pos x = 0
        }

        if (pos x > stage size x) {
            pos x = stage size x
        }

        if (pos y < 0) {
            pos y = 0
        }

        maxY := stage size y - 200
        if (pos y > maxY) {
            pos y = maxY
        }
    }

    dampVel: func {
        factor := 0.85
        vel set!(vel x * factor, vel y * factor)
    }

    update: func {
        pos add!(vel)
        dampVel()
        constrainPos()
    }

}

