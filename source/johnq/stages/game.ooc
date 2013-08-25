
// ours
import johnq/[johnq, stage, player]

// third party
import dye/[core, sprite, input]
import gnaar/[zbag]

use tiled
import tiled/[Map, Tile, helpers]

// sdk
import io/File

GameStage: class extends Stage {

    player: Player
    map: Map

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

        file := File new("assets/maps/SmithThompson.tmx")
        map = Map new(file)
        "Loaded map, width / height = %d, %d" printfln(map width, map height)
        "tile width / height = %d, %d" printfln(map tileWidth, map tileHeight)
        "layer count = %d" printfln(map layers size)

        layer := map layers get(0)
        layer each(|x, y, tile|
            pos := tile getPosition()
            "Tile at %d, %d. Position = %d, %d" printfln(x, y, pos x, pos y)
        )
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

