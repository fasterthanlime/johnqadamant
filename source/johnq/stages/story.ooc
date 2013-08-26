
// third party
import dye/[core, math, sprite, input]
import gnaar/[zbag]

// ours
import johnq/[johnq, stage]

StoryStage: class extends Stage {

    bg, body, fg: GlSprite

    counter := 0
    yBody := 0.0

    init: func (.john) {
        super(john)

        bg = GlSprite new("assets/png/story-bg.png")
        bg center = false
        add(bg)

        body = GlSprite new("assets/png/story-body.png")
        body center = false
        add(body)

        yBody = 200 - body height
        body pos y = yBody

        fg = GlSprite new("assets/png/story-props.png")
        fg center = false
        add(fg)
    }

    setup: func {
        setupEvents()
    }

    setupEvents: func {
        input onKeyRelease(|kr|
            match (kr scancode) {
                case KeyCode ESC =>
                    john hose publish(ZBag make("return to menu"))
            }
        )
    }

    next: func {
        john hose publish(ZBag make("select character") )
    }

    update: func {
        if (yBody < 0) {
            yBody += 0.7

            if (input isPressed(KeyCode SPACE)) {
                yBody += 15.0
            }
        } else {
            yBody = 0

            counter += 1
            if (input isPressed(KeyCode SPACE)) {
                counter += 5
            }

            if (counter > 100) {
                bg opacity *= 0.92
            }
            if (counter > 130) {
                next()
            }
        }

        body pos y = body pos y * 0.91 + yBody * 0.09
    }

}
