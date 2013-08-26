
// ours
import johnq/[johnq, stage]

// third party
import dye/[core, sprite, input]
import gnaar/[utils, zbag]

// sdk
import structs/[ArrayList]

SelectorStage: class extends Stage {

    currentIndex := 0
    currentChar: Character
    chars: Chars

    init: super func

    setup: func {
        bg := GlSprite new("assets/png/selector.png")
        bg center = false
        add(bg)

        chars = Chars new()
        for (c in chars characters) {
            add(c preview)
        }
        updateCurrent()

        initEvents()
    }

    initEvents: func {
        input onKeyRelease(|kr|
            match (kr scancode) {
                case KeyCode ENTER =>
                    bag := ZBag make("new game", currentChar x, currentChar y, currentChar challenge)
                    john hose publish(bag)
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
        currentIndex += delta
        if (currentIndex < 0) {
            currentIndex = 9
        }

        if (currentIndex > 9) {
            currentIndex = 0
        }

        updateCurrent()
    }

    updateCurrent: func {
        currentChar = chars characters get(currentIndex)
        "Switched to char %d, %s" printfln(currentIndex, currentChar name)
    }

    update: func {
        alpha := 0.1

        for (c in chars characters) {
            target := 0.0
            if (c == currentChar) {
                target = 1.0
            }
            c preview opacity = \
                target * alpha + \
                c preview opacity * (1.0 - alpha)
        }
    }

}

Chars: class {

    characters := ArrayList<Character> new()

    init: func {
        doc := parseYaml("assets/yml/chars.yml")
        map := doc toMap()
        list := map get("characters") toList()

        "Got %d characters" printfln(list size)
        for (el in list) {
            ch := el toMap()
            xy := ch get("ship") toList()
            (x, y) := (xy get(0) toInt(), xy get(1) toInt())

            name := ch get("name") toScalar()
            description := ch get("description") toScalar()
            challenge :=  ch get("challenge") toScalar()
            characters add(Character new(x, y, name, description, challenge))
        }
    }

}

Character: class {

    x, y: Int
    name, description, challenge: String

    preview: ShipPreview

    init: func (=x, =y, =name, =description, =challenge) {
        preview = ShipPreview new(x, y)
    }

}

ShipPreview: class extends GlGridSprite {

    init: func (=x, =y) {
        super("assets/png/ship.png", 4, 4)
        pos set!(256, 720 - 256)
        opacity = 0.0
    }

}

