
// ours
import johnq/[johnq, stage, player]

// third party
import dye/[core, sprite, input]
import gnaar/[zbag]

GameStage: class extends Stage {

    player: Player

    init: super func

    setup: func {
        player = Player new(this)
        add(player)

        initEvents()

        reset!()
    }

    prepare: func {
        reset!()
    }

    reset!: func {
        player pos set!(john dye width * 0.5, john dye height * 0.2)
    }

    initEvents: func {
        input onKeyRelease(|kr|
            match (kr scancode) {
                case KeyCode SPACE =>
                    player shoot()

                case KeyCode ESC =>
                    john hose publish(ZBag make("return to menu"))
            }
        )
    }

    update: func {
        handleInput()
        player update()
    }

    handleInput: func {
        if (input isPressed(KeyCode LEFT)) {
            player move(-1, 0)
        }

        if (input isPressed(KeyCode RIGHT)) {
            player move( 1, 0)
        }

        if (input isPressed(KeyCode UP)) {
            player move(0,  1)
        }

        if (input isPressed(KeyCode DOWN)) {
            player move(0, -1)
        }
    }

}

