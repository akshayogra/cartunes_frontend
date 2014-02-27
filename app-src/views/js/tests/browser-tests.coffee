mocha.setup 'bdd'

# TODO : Run all the -test.coffee files
require './fail-test.coffee'

mocha.globals ['require']
mocha.checkLeaks()
mocha.run()
