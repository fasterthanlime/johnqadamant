
// ours
import johnq/[johnq, stage]

// third party
import dye/[core, sprite, input]
import gnaar/[zbag]

MenuStage: class extends Stage {

    init: super func

    setup: func {
        bg := GlSprite new("assets/png/titlescreen.png")
        bg center = false
        add(bg)

        initEvents()
    }

    initEvents: func {
        input onKeyRelease(|kr|
            match (kr scancode) {
                case KeyCode SPACE =>
                    john hose publish(ZBag make("new game"))
                case KeyCode ESC =>
                    john hose publish(ZBag make("exit"))
            }
        )
    }

}


