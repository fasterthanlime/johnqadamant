
// third party
import dye/[core, math, sprite, primitives]

// ours
import johnq/[player]
import johnq/stages/[game]

GameUI: class extends GlGroup {

    stage: GameStage

    bg: GlRectangle
    lifeBar: GlRectangle

    lifeHeight: Float

    init: func (=stage) {
        pos set!(1152, 0)

        bg := GlRectangle new(vec2(128, stage size y))
        bg center = false
        bg color set!(20, 20, 20)
        add(bg)

        paddingY := 20.0
        lifeHeight = stage size y - paddingY * 2.0

        lifeBar = GlRectangle new(vec2(64, lifeHeight))
        lifeBar center = false
        lifeBar pos set!(32, 20)
        lifeBar color set!(255, 0, 0)
        add(lifeBar)
    }

    update: func {
        lifeBar size y = stage player life as Float / 100.0 * lifeHeight
    }

}
