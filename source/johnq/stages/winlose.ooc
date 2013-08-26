
// third party
import dye/[core, math, sprite, input]
import gnaar/[zbag]

// ours
import johnq/[johnq, stage]

WinLoseStage: class extends Stage {

    bg: GlSprite

    init: func (.john, spritePath: String) {
        super(john)

        bg = GlSprite new(spritePath)
        bg center = false
        add(bg)
    }

    setup: func {
        setupEvents()
    }

    setupEvents: func {
        input onKeyPress(|kr|
            match (kr scancode) {
                case KeyCode ENTER || KeyCode ESC =>
                    john hose publish(ZBag make("return to menu") )
            }
        )
    }

}

WinStage: class extends WinLoseStage {

    init: func (.john) {
        super(john, "assets/png/win.png")
    }

}

LoseStage: class extends WinLoseStage {

    init: func (.john) {
        super(john, "assets/png/lose.png")
    }

}

