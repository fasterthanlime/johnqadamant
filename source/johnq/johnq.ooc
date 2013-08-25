
// third-party
use dye
import dye/[core, app]


// sdk
import structs/[ArrayList, HashMap]

// ours
import johnq/[stage]
import johnq/stages/[menu, winlose, game]

JohnQ: class extends App {

    stages := HashMap<String, Stage> new()
    currentStage: Stage

    init: func {
        super("John Q", 800, 600)
    }

    setup: func {
        stages put("menu", MenuStage new(this))
        stages put("win", WinStage new(this))
        stages put("lose", LoseStage new(this))
        stages put("game", GameStage new(this))
        switchTo("menu")
    }

    switchTo: func (stageName: String) {
        stage := stages get(stageName)
        if (!stage) {
            raise("Unknown stage: %s" format(stageName))
        }
        currentStage = stage
        dye setScene(stage)

        logger info("Switched to stage: %s", stageName)
    }

    update: func {
        currentStage update()
    }

}

main: func {
    j := JohnQ new()
    j run(60.0) // 60FPS baby :)
}

