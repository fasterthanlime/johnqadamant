
// third party
import dye/core

use deadlogger
import deadlogger/[Log, Logger]

// ours
import johnq

Stage: class extends Scene {

    john: JohnQ
    logger: Logger

    init: func (=john) {
        super(john dye)

        logger = Log getLogger(class name)
        logger info("Stage set!")

        setup()
    }

    /* Called when created */
    setup: func {
        // override
    }

    /* Called every 1/60th of a second */
    update: func {
        // override
    }

    /* Called when just switched to. */
    prepare: func {
    }

}

