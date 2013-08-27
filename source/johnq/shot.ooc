
// third party
import dye/[core, math, sprite]

// sdk

// ours
import johnq/stages/[game]

ShotType: enum {
    // friendly
    PELLET
    DROP
    DOLLAR
    MISSILE

    ASH
    STARS
    CHAIN
    FIREBALL

    BREAD
    FEATHER

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

            case ShotType DROP =>
                (x, y) = (1, 0)

            case ShotType DOLLAR =>
                (x, y) = (2, 0)

            case ShotType MISSILE =>
                (x, y) = (3, 0)



            case ShotType ASH =>
                (x, y) = (0, 1)

            case ShotType STARS =>
                (x, y) = (1, 1)

            case ShotType CHAIN =>
                (x, y) = (2, 1)

            case ShotType FIREBALL =>
                (x, y) = (3, 1)


            case ShotType BREAD =>
                (x, y) = (0, 2)

            case ShotType FEATHER =>
                (x, y) = (1, 2)


            case ShotType MIL_MISSILE =>
                (x, y) = (0, 1)
                friendly = false
        }

        if (friendly) {
            sprite = GlGridSprite new("assets/png/shots.png", 4, 4)
        } else {
            sprite = GlGridSprite new("assets/png/mobshots.png", 2, 2)
        }

        (sprite x, sprite y) = (x, y)
        add(sprite)
        pos set!(initialPos)
        vel set!(initialVel)

        initAttributes()
    }

    initAttributes: func {
        damage = match type {
            case ShotType PELLET =>      3
            case ShotType DROP   =>      3
            case ShotType DOLLAR =>      3
            case ShotType MISSILE =>     3

            case ShotType ASH =>         8
            case ShotType STARS =>       8
            case ShotType CHAIN =>       5
            case ShotType FIREBALL =>    5

            case ShotType BREAD =>       20
            case ShotType FEATHER =>     3

            case ShotType MIL_MISSILE => 10
            case => 0
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

