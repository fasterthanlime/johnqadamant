
// ours
import johnq/[johnq, stage, player, qtile, shot]

// third party
import dye/[core, sprite, input, math]
import gnaar/[zbag]

GameStage: class extends Stage {

    player: Player
    map := QMap new(this)
    shots := GlGroup new()

    init: super func

    // shoot stuff
    shootCounter := 0
    shootThreshold : Int { get {
        match (player shotType) {
            case 0 => 2
            case 1 => 4
            case 2 => 5
            case 3 => 10
        }
    } }

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
        map load("assets/maps/SmithThompson2.tmx")
        shots clear()
    }

    initEvents: func {
        input onKeyRelease(|kr|
            match (kr scancode) {
                case KeyCode ESC =>
                    john hose publish(ZBag make("return to menu"))
                
                case KeyCode F1 =>
                    player shotType = 0
                case KeyCode F2 =>
                    player shotType = 1
                case KeyCode F3 =>
                    player shotType = 2
                case KeyCode F4 =>
                    player shotType = 3
            }
        )
    }

    update: func {
        handleInput()
        player update()
        map update()
        updateShots()
    }

    updateShots: func {
        iter := shots children iterator()
        while (iter hasNext?()) {
            s := iter next()
            match s {
                case (shot: Shot) =>
                    if (!shot update()) iter remove()
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

        if (input isPressed(KeyCode SPACE)) {
            shootCounter += 1
            if (shootCounter > shootThreshold) {
                shootCounter = 0
                player shoot()
            }
        }

    }

}

