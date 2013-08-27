
// ours
import johnq/[johnq, stage]

// third party
import dye/[core, sprite, input, text]
import gnaar/[zbag, yaml]

// sdk
import structs/[ArrayList]

SelectorStage: class extends Stage {

    currentIndex := 0
    currentChar: Character
    chars: Chars

    nameText, descText: GlText

    init: super func

    setup: func {
        bg := GlSprite new("assets/png/selector.png")
        bg center = false
        add(bg)

        nameText = GlText new("assets/ttf/USDeclaration.ttf", "", 26)
        nameText color set!(0, 0, 0)
        nameText pos set!(40, 720 - 260)
        add(nameText)

        descText = GlText new("assets/ttf/USDeclaration.ttf", "", 18)
        descText color set!(0, 0, 0)
        descText pos set!(40, 720 - 360)
        add(descText)

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
                    john hose publish(ZBag make("return to menu"))
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
        nameText value = currentChar name
        descText value = currentChar description
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
        pos set!(512 + 128, 720 - 256 + 32)
        opacity = 0.0
    }

}

