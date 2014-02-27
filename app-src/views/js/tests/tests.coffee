'use strict'

mocha.setup 'bdd'

mocha.globals ['require']
mocha.checkLeaks()
mocha.run()
