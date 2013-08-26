
// ours
import johnq/[johnq, stage, shot]
import johnq/stages/[game]

// third party
import dye/[core, sprite, math, primitives]

// sdk
import math

Player: class extends GlGroup {

    stage: GameStage

    collisionRect: GlRectangle
    halfSize: Vec2
    body: GlSprite
    hitbox: Hitbox

    vel := vec2(0.0, 0.0)

    maxVelX := 10.0
    maxVelY := 8.0

    shotType := ShotType PELLET

    life := 100

    /** missiles are shot in X from sin(missileAngle) */
    missileAngle := 0.0

    init: func (=stage) {
        body = GlSprite new("assets/png/ship-small.png")
        add(body)

        collisionRect = GlRectangle new(vec2(45, 25))
        collisionRect color set!(255, 0, 0)
        collisionRect opacity = 0.3
        collisionRect pos y = -15
        //add(collisionRect)

        halfSize = collisionRect size mul(0.5)

        hitbox = Hitbox new()
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
                speed := 25.0

                delta := 32
                incr := 360.0 / delta as Float
                a := 0.0
                delta times(||
                    vel := Vec2 fromAngle(a toRadians()) mul(speed)
                    propel(pos, vel)
                    a += incr
                )

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
                vel := vec2(0, 10)
                propel(pos add(0, 25), vel)
        }
    }

    takeShotDamage: func (shot: Shot) {
        life -= shot damage

        if (life < 0) {
            life = 0
            stage lost()
        }
    }

    reset!: func {
        life = 100
        pos set!(stage center x, stage size y * 0.2)
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
        if (vel x > maxVelX) {
            vel x = maxVelX
        }

        if (vel x < -maxVelX) {
            vel x = -maxVelX
        }

        if (vel y > maxVelY) {
            vel y = maxVelY
        }

        if (vel y < -maxVelY) {
            vel y = -maxVelY
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

        maxY := stage size y
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

        hitbox bl set!(pos x + collisionRect pos x - halfSize x,
                       pos y + collisionRect pos y - halfSize y)
        hitbox tr set!(pos x + collisionRect pos x + halfSize x,
                       pos y + collisionRect pos y + halfSize y)
    }

}

