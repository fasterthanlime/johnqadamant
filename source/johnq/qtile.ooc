
// third party
import dye/[core, math, sprite]

use tiled
import tiled/[Map, Tile, Tileset, helpers]

// sdk
import io/File
import structs/[ArrayList]
import math/Random

// ours
import johnq/stages/[game]

QMap: class extends GlGroup {

    stage: GameStage

    map: Map
    tiles := ArrayList<QTile> new()
    mobs := ArrayList<Mob> new()

    yDelta := -1

    init: func (=stage)

    load: func (path: String) {
        reset!()

        map = Map new(File new(path))
        "Loaded map %s" printfln(path)
        "width / height = %d, %d" printfln(map width, map height)
        "tile width / height = %d, %d" printfln(map tileWidth, map tileHeight)
        "layer count = %d" printfln(map layers size)

        decor := map layers get("decor")
        if (!decor) raise("Malformed map: %s" format(path))
        decor each(|x, y, tile|
            pos := tile getPosition()
            tileset := tile tileset
            (tileX, tileY) := (pos x / tileset tileWidth, pos y / tileset tileHeight)

            qtile := QTile new(tileX, tileY)
            qtile pos set!(convertMapPos(x, y))
            addTile(qtile)
        )

        mobs := map layers get("mobs")
        if (mobs) {
            mobs each(|x, y, tile|
                pos := tile getPosition()
                tileset := tile tileset
                (tileX, tileY) := (pos x / tileset tileWidth, pos y / tileset tileHeight)

                mob := Mob new(tileX, tileY)
                mob pos set!(convertMapPos(x, y))
                addMob(mob)
            )
        }
    }

    convertMapPos: func (x, y: Int) -> Vec2 {
        vec2(x * map tileWidth, (map height - y) * map tileHeight)
    }

    reset!: func {
        while (!tiles empty?()) {
            tile := tiles removeAt(0)
            remove(tile) // gfx
        }

        while (!mobs empty?()) {
            mob := mobs removeAt(0)
            remove(mob) // gfx
        }
    }

    addTile: func (tile: QTile) {
        tiles add(tile)
        add(tile) // gfx
    }

    addMob: func (mob: Mob) {
        mobs add(mob)
        add(mob) // gfx
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

    update: func {
        pos y += yDelta

        for (mob in mobs) {
            y := (pos y + mob pos y)
            padding := 100

            mob active = (y > -padding && y < stage size y + padding)

            padding = 20
            if (mob pos x < padding) mob pos x = padding
            if (mob pos x > stage size x - padding) mob pos x = stage size x - padding
            mob update()
        }
    }

}

QTile: class extends GlGridSprite {

    init: func (=x, =y) {
        super("assets/png/tiles2.png", 16, 16)
    }

}

MobType: enum {
    MOLAR
    DOVE
    UNK1
    UNK2

    toString: func -> String {
        match this {
            case MobType MOLAR => "molar"
            case MobType DOVE => "dove"
            case => "unk"
        }
    }
}

Mob: class extends GlGridSprite {

    type: MobType
    active := false

    xDelta := 3.0
    counter := 0

    yDelta := 1.0

    init: func (=x, =y) {
        super("assets/png/mobs.png", 2, 2)

        type = match y {
            case 0 => match x {
                case 0 => MobType MOLAR
                case 1 => MobType DOVE
            }
            case 1 => match x {
                case 0 => MobType UNK1
                case 1 => MobType UNK2
            }
        }
    }

    update: func {
        if (!active) return

        match type {
            case MobType MOLAR => updateMolar()
            case MobType DOVE  => updateDove()
        }
    }

    updateMolar: func {
    }

    updateDove: func {
        counter -= 1
        if (counter < 0) {
            resetCounter()
            xDelta *= -1.0
        }

        pos x += xDelta
        pos y -= yDelta
    }

    resetCounter: func {
        counter = Random randInt(30, 60)
    }

}

