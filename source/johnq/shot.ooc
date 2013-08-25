
// third party
import dye/[core, math, sprite]

// sdk

// ours
import johnq/stages/[game]

Shot: class extends GlGroup {

    origin := static vec2(0, 0)
    stageSize: static Vec2

    stage: GameStage
    sprite: GlGridSprite
    type: Int

    vel := vec2(0, 0)

    init: func (=stage, =type, initialPos, initialVel: Vec2) {
        super()

        if (!stageSize) {
            stageSize = vec2(stage size x, stage size y)
        }

        sprite = GlGridSprite new("assets/png/shots.png", 2, 2)
        match type {
            case 0 =>
                sprite x = 0
                sprite y = 0
            case 1 =>
                sprite x = 1
                sprite y = 0
            case 2 =>
                sprite x = 0
                sprite y = 1
            case 3 =>
                sprite x = 1
                sprite y = 1
        }
        add(sprite)
        pos set!(initialPos)
        vel set!(initialVel)
    }

    update: func -> Bool {
        pos add!(vel)

        // later: shot-specific behaviour
        match type {
            // Rat pellet
            case 0 =>

            // Fire balls of the dragon
            case 1 =>

            // Missiles
            case 2 =>

            // Ninja stars
            case 3 =>
                angle += 5.0
        }

        if (!pos inside?(origin, stageSize)) {
            // die!
            return false
        }

        true
    }

}

