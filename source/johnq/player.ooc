
// ours
import johnq/[johnq, stage, shot]
import johnq/stages/[game]

// third party
import dye/[core, sprite, math, primitives]

// sdk
import math

Player: class extends GlGroup {

    stage: GameStage

    hitbox: GlRectangle
    body: GlSprite

    vel := vec2(0.0, 0.0)
    maxVel := 8.0

    shotType := ShotType PELLET

    /** missiles are shot in X from sin(missileAngle) */
    missileAngle := 0.0

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
        match shotType {
            case ShotType PELLET =>
                yDelta := 25
                xDelta := 8
                vel := vec2(0, 25)

                f := func (xd: Float) {
                    propel(pos add(xd, yDelta), vel)
                }
                f(-xDelta); f(xDelta)

            case ShotType FIREBALL =>
                yDelta := 25
                xDelta := 12
                vxDelta := 4

                f := func (xd, xd2, y: Float) {
                    propel(pos add(xd, y), vec2(xd2, 15))
                }
                f(-xDelta, -vxDelta, yDelta - 18)
                f(0, 0, yDelta)
                f(xDelta, vxDelta, yDelta - 18)

            case ShotType MISSILE =>
                missileAngle += 0.2
                if (missileAngle > 2 * PI) {
                    missileAngle -= 2 * PI
                }

                factor := 45.0
                x1 := sin(missileAngle)
                yDelta := 12

                propel(vec2(pos x + x1 * factor, pos y + yDelta), vec2( x1 * 2.0, 15))
                propel(vec2(pos x - x1 * factor, pos y + yDelta), vec2(-x1 * 2.0, 15))

            case ShotType STARS =>
                yDelta := 8
                xDelta := 30
                vel := vec2(0, 10)

                f := func (xd: Float) {
                    propel(pos add(xd, yDelta), vel)
                }
                f(-xDelta); f(xDelta)
        }
    }

    propel: func (pos, vel: Vec2) {
        stage shots add(Shot new(stage, shotType, pos, vel))
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

