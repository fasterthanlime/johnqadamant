
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
            case ShotType PELLET => 2
            case ShotType FIREBALL => 2
            case ShotType MISSILE => 5
            case ShotType STARS => 10
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
                    john hose publish(ZBag make("return to menu"))
                
                case KeyCode F1 =>
                    player shotType = ShotType PELLET
                case KeyCode F2 =>
                    player shotType = ShotType FIREBALL
                case KeyCode F3 =>
                    player shotType = ShotType MISSILE
                case KeyCode F4 =>
                    player shotType = ShotType STARS
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
                                mobPos := mob pos add(map pos)
                                if (mobPos dist(shot pos) < mob radius) {
                                    map explode(shot pos)
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

}

Hitbox: class {
    bl := vec2(0, 0)
    tr := vec2(0, 0)

    init: func

    contains?: func (v: Vec2) -> Bool {
        v inside?(bl, tr)
    }
}

