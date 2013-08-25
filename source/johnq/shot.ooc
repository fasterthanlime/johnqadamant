
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

    init: func (=stage, =type, initialPos: Vec2) {
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
    }

    update: func -> Bool {
        pos add!(0, 12)

        // later: shot-specific behaviour
        match type {
            case 0 =>
            case 1 =>
            case 2 =>
            case 3 =>
        }

        if (!pos inside?(origin, stageSize)) {
            // die!
            return false
        }

        true
    }

}

