
// third party
import dye/[core, math, sprite]

// sdk

// ours

Shot: class extends GlGroup {

    sprite: GlGridSprite
    type: Int

    init: func (=type, initialPos: Vec2) {
        super()

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

    update: func {
        pos add!(0, 12)

        // later: shot-specific behaviour
        match type {
            case 0 =>
            case 1 =>
            case 2 =>
            case 3 =>
        }
    }

}

