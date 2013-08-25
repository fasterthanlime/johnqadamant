
// ours
import johnq/[johnq, stage, player, qtile, shot]

// third party
import dye/[core, sprite, input, math]
import gnaar/[zbag]

GameStage: class extends Stage {

    player: Player
    map := QMap new()
    shots := GlGroup new()

    yDelta := -2

    init: super func

    setup: func {
        player = Player new(this)
        add(map)
        add(player)
        add(shots)

        initEvents()

        reset!()
    }

    prepare: func {
        reset!()
    }

    reset!: func {
        player pos set!(john dye width * 0.5, john dye height * 0.2)
        map load("assets/maps/SmithThompson.tmx")
        shots clear()
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

        for (s in shots children) {
            match s {
                case (shot: Shot) => shot update()
            }
        }
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

