
// ours
import johnq/[johnq, stage, player, qtile, shot, gameui]

// third party
import dye/[core, sprite, input, math, primitives]
import gnaar/[zbag]

GameStage: class extends Stage {

    player: Player
    map := QMap new(this)
    shots := GlGroup new()

    ui: GameUI

    init: super func

    // shoot stuff
    shootCounter := 0
    shootThreshold : Int { get {
        match (player shotType) {
            case ShotType PELLET =>      2
            case ShotType DROP   =>      3
            case ShotType DOLLAR =>      1
            case ShotType MISSILE =>     4

            case ShotType ASH =>         2
            case ShotType STARS =>       5
            case ShotType CHAIN =>       24
            case ShotType FIREBALL =>    12

            case ShotType BREAD =>       5
            case ShotType FEATHER =>     15
        }
    } }

    setup: func {
        player = Player new(this)
        add(map)
        add(player)
        add(shots)

        ui = GameUI new(this)
        add(ui)

        initEvents()

        reset!()
    }

    prepare: func {
        reset!()
        player prepare()
    }

    reset!: func {
        player reset!()
        map load("assets/maps/SmithThompson2.tmx")
        shots clear()
    }

    initEvents: func {
        input onKeyRelease(|kr|
            match (kr scancode) {
                case KeyCode ESC =>
                    john hose publish(ZBag make("select character"))
            }
        )
    }

    update: func {
        handleInput()
        player update()
        map update()
        updateShots()
        ui update()
    }

    updateShots: func {
        iter := shots children iterator()
        while (iter hasNext?()) {
            s := iter next()
            match s {
                case (shot: Shot) =>
                    if (!shot update()) {
                        iter remove()
                    } else {
                        if (shot friendly) {
                            // can we hurt enemies?
                            for (mob in map mobs) {
                                x := mob pos x + map pos x - shot pos x
                                y := mob pos y + map pos y - shot pos y
                                distSquared := x * x + y * y

                                if (distSquared < mob radiusSquared) {
                                    mob takeDamage(shot)
                                    if (shot oneShot?) {
                                        iter remove()
                                    }
                                }
                            }
                        } else {
                            // can we hurt the player?
                            if (player hitbox contains?(shot pos)) {
                                map explode(shot pos)
                                player takeShotDamage(shot)
                                shot alive = false
                                iter remove()
                            }
                        }
                    }
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

    lost: func {
        john hose publish(ZBag make("lost"))
    }

    won: func {
        john hose publish(ZBag make("won"))
    }

}

Hitbox: class {
    bl := vec2(0, 0)
    tr := vec2(0, 0)

    init: func

    contains?: func (v: Vec2) -> Bool {
        v inside?(bl, tr)
    }
}

