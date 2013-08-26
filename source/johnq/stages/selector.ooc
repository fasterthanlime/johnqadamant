
// ours
import johnq/[johnq, stage]

// third party
import dye/[core, sprite, input]
import gnaar/[utils, zbag]

// sdk
import structs/[ArrayList]

SelectorStage: class extends Stage {

    current := 0
    chars: Chars

    init: super func

    setup: func {
        bg := GlSprite new("assets/png/selector.png")
        bg center = false
        add(bg)

        chars = Chars new()
        updateCurrent()

        initEvents()
    }

    initEvents: func {
        input onKeyRelease(|kr|
            match (kr scancode) {
                case KeyCode ENTER =>
                    john hose publish(ZBag make("new game"))
                case KeyCode LEFT =>
                    cycle(-1)
                case KeyCode RIGHT =>
                    cycle(1)
                case KeyCode ESC =>
                    john hose publish(ZBag make("exit"))
            }
        )
    }

    cycle: func (delta: Int) {
        current += delta
        if (current < 0) {
            current = 9
        }

        if (current > 9) {
            current = 0
        }

        updateCurrent()
    }

    updateCurrent: func {
        // change preview, name, description
    }

}

Chars: class {

    characters := ArrayList<Character> new()

    init: func {
        doc := parseYaml("assets/yml/chars.yml")
        map := doc toMap()
        list := map get("characters") toList()
        "Got %d characters" printfln(list size)
    }

}

Character: class {

    preview: ShipPreview

    init: func {
    }

}

ShipPreview: class extends GlGroup {

    stage: SelectorStage
    sprite: GlGridSprite

    init: func (=stage, x, y: Int) {
        sprite = GlGridSprite new("assets/png/ship.png", 4, 4)
        (sprite x, sprite y) = (x, y)
    }

}

