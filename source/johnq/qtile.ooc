
// third party
import dye/[core, math, sprite]

QTile: class extends GlGroup {

    sprite: GlGridSprite = null

    init: func {
        loadSprite()
    }

    loadSprite: func {
        sprite = GlGridSprite new("assets/png/tiles1.png", 2, 2)
    }

}

