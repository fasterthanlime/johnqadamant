
// third party
import dye/[core, math, sprite]

// sdk

// ours
import johnq/stages/[game]

ShotType: enum {
    // friendly
    PELLET
    FIREBALL
    MISSILE
    STARS

    // unfriendly
    MIL_MISSILE
}

Shot: class extends GlGroup {

    origin := static vec2(0, 0)
    stageSize: static Vec2

    stage: GameStage
    sprite: GlGridSprite
    type: ShotType

    friendly := true

    vel := vec2(0, 0)

    alive := true

    // attributes
    damage: Int
    oneShot? := true

    init: func (=stage, =type, initialPos, initialVel: Vec2) {
        super()

        if (!stageSize) {
            stageSize = vec2(stage size x, stage size y)
        }

        x, y: Int
        match type {
            case ShotType PELLET =>
                (x, y) = (0, 0)

            case ShotType FIREBALL =>
                (x, y) = (1, 0)

            case ShotType MISSILE =>
                (x, y) = (0, 1)

            case ShotType STARS =>
                (x, y) = (1, 1)

            case ShotType MIL_MISSILE =>
                (x, y) = (0, 1)
                friendly = false
        }

        spritePath := "assets/png/%sshots.png" format(friendly ? "" : "mob")
        sprite = GlGridSprite new(spritePath, 2, 2)
        (sprite x, sprite y) = (x, y)
        add(sprite)
        pos set!(initialPos)
        vel set!(initialVel)

        initAttributes()
    }

    initAttributes: func {
        damage = match type {
            case ShotType PELLET =>      3
            case ShotType FIREBALL =>    5
            case ShotType MISSILE =>     20
            case ShotType STARS =>       8
            case ShotType MIL_MISSILE => 10
        }

        oneShot? = match type {
            case ShotType STARS =>
                false
            case =>
                true
        }
    }

    update: func -> Bool {
        pos add!(vel)

        // later: shot-specific behaviour
        match type {
            // Rat pellet
            case ShotType PELLET =>

            // Fire balls of the dragon
            case ShotType FIREBALL =>

            // Missiles
            case ShotType MISSILE =>
                setAngleFromVel()

            // Ninja stars
            case ShotType STARS =>
                angle += 5.0

            // Green missile
            case ShotType MIL_MISSILE =>
                setAngleFromVel()
        }

        if (!pos inside?(origin, stageSize)) {
            // die!
            alive = false
        }

        alive
    }

    setAngleFromVel: func {
        // ah, I thought it wasn't that simple...
        angle = vel angle() toDegrees()
    }

}

