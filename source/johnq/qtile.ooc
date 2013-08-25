
// third party
import dye/[core, math, sprite]

use tiled
import tiled/[Map, Tile, helpers]

// sdk
import io/File
import structs/[ArrayList]

QMap: class extends GlGroup {

    map: Map
    tiles := ArrayList<QTile> new()

    init: func {
        // not much?
    }

    load: func (path: String) {
        reset!()

        map = Map new(File new(path))
        "Loaded map %s" printfln(path)
        "width / height = %d, %d" printfln(map width, map height)
        "tile width / height = %d, %d" printfln(map tileWidth, map tileHeight)
        "layer count = %d" printfln(map layers size)

        layer := map layers get(0)
        layer each(|x, y, tile|
            pos := tile getPosition()
            //"Tile at %d, %d. Position = %d, %d" printfln(x, y, pos x, pos y)

            qtile := QTile new(pos x / map tileWidth, pos y / map tileHeight)
            qtile pos set!(x * map tileWidth, y * map tileHeight)
            addTile(qtile)
        )
    }

    reset!: func {
        while (!tiles empty?()) {
            tile := tiles removeAt(0)
            remove(tile) // gfx
        }
    }

    addTile: func (tile: QTile) {
        tiles add(tile)
        add(tile) // gfx
    }

    drawChildren: func (dye: DyeContext, modelView: Matrix4) {
        for (c in children) {
            actualPos := c pos add(pos)
            if (actualPos x < -map tileWidth ||
                actualPos x > dye width + map tileWidth ||
                actualPos y < -map tileHeight ||
                actualPos y > dye height + map tileHeight) {
                continue // skip that one.
            }

            c render(dye, modelView)
        }
    }

}

QTile: class extends GlGridSprite {

    init: func (=x, =y) {
        super("assets/png/tiles1.png", 2, 2)
    }

}

