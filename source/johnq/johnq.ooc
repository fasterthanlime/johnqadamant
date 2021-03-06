
// third-party
use dye
import dye/[core, app, input]

use gnaar
import gnaar/[zbag, hose, sound]

// sdk
import structs/[ArrayList, HashMap]

// ours
use johnqadamant
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

    // sound why not?
    boombox: Boombox

    init: func {
        // Yeaaaah, 720p baby.
        super("John Quincy Adamant", 1280, 720)
        escQuits? = false
        dye setIcon("assets/bmp/icon.bmp")
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

        dye input onKeyPress(KeyCode F12, |kp|
            boombox config mute = !boombox config mute
        )

        // initial state
        switchTo("story")

        // musiccc
        boombox = Boombox new()
        boombox playMusic("johnq_menu", -1)
    }

    onEvent: func (bag: ZBag) {
        message := bag pull()
        logger info("Global game event: %s", message)

        match message {
            case "read story" =>
                boombox playMusic("johnq_menu", -1)
                switchTo("story")
            case "select character" =>
                boombox playMusic("johnq_menu", -1)
                switchTo("selector")
            case "new game" =>
                (x, y) = (bag pullInt(), bag pullInt())
                challenge = bag pull()
                switchTo("game")
                boombox playMusic("johnq1", -1)
            case "return to menu" =>
                boombox playMusic("johnq_menu", -1)
                switchTo("menu")
            case "lost" =>
                switchTo("lose")
                boombox playMusic("johnq_death", -1)
            case "won" =>
                switchTo("win")
                boombox playMusic("johnq_win", -1)
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

