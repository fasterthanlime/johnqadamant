
// ours
import johnq/[johnq, stage]
import johnq/stages/[game]

// third party
import dye/[core, sprite, math]

Player: class extends GlGroup {

    stage: GameStage
    body: GlSprite

    vel := vec2(0.0, 0.0)
    maxVel := 8.0

    init: func (=stage) {
        body = GlSprite new("assets/png/ship.png")
        add(body)
    }

    shoot: func {
        // not yet
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

    dampVel: func {
        factor := 0.85
        vel set!(vel x * factor, vel y * factor)
    }

    update: func {
        pos add!(vel)
        dampVel()
    }

}

