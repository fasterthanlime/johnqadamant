
// ours
import johnq/[johnq, stage, player, qtile]

// third party
import dye/[core, sprite, input, math]
import gnaar/[zbag]

GameStage: class extends Stage {

    player: Player
    map := QMap new()

    yDelta := -4

    init: super func

    setup: func {
        player = Player new(this)
        add(map)
        add(player)

        initEvents()

        reset!()
    }

    prepare: func {
        reset!()
    }

    reset!: func {
        player pos set!(john dye width * 0.5, john dye height * 0.2)
        map load("assets/maps/SmithThompson.tmx")
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

        map pos y += yDelta
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

