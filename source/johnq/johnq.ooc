
// third-party
use dye
import dye/[core, app, input]

use gnaar
import gnaar/[zbag, hose]

// sdk
import structs/[ArrayList, HashMap]

// ours
import johnq/[stage]
import johnq/stages/[menu, winlose, game, story, selector]

JohnQ: class extends App {

    // parts of the game we can switch from and to
    stages := HashMap<String, Stage> new()
    currentStage: Stage

    // events
    hose := FireHose new()

    // MWAHAHAHAHA GLOBALS
    x, y: Int
    challenge: String

    init: func {
        // Yeaaaah, 720p baby.
        super("John Quincy Adamant", 1280, 720)
        escQuits? = false
    }

    setup: func {
        // stages
        stages put("story", StoryStage new(this))
        stages put("menu", MenuStage new(this))
        stages put("selector", SelectorStage new(this))

        stages put("game", GameStage new(this))

        stages put("win", WinStage new(this))
        stages put("lose", LoseStage new(this))

        // events
        hose subscribe(|bag| onEvent(bag))

        dye input onKeyPress(KeyCode F11, |kp|
            dye setFullscreen(!dye fullscreen)
        )

        // initial state
        switchTo("story")
    }

    onEvent: func (bag: ZBag) {
        message := bag pull()
        logger info("Global game event: %s", message)

        match message {
            case "read story" =>
                switchTo("story")
            case "select character" =>
                switchTo("selector")
            case "new game" =>
                (x, y) = (bag pullInt(), bag pullInt())
                challenge = bag pull()
                switchTo("game")
            case "return to menu" =>
                switchTo("menu")
            case "lost" =>
                switchTo("lose")
            case "won" =>
                switchTo("win")
            case "exit" =>
                quit()
        }
    }

    switchTo: func (stageName: String) {
        stage := stages get(stageName)
        if (!stage) {
            raise("Unknown stage: %s" format(stageName))
        }

        stage prepare()
        currentStage = stage
        dye setScene(stage)

        logger info("Switched to stage: %s", stageName)
    }

    update: func {
        hose dispatch()
        currentStage update()
    }

}

main: func {
    j := JohnQ new()
    j run(60.0) // 60FPS baby :)
}

