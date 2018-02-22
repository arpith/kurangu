require 'rdl'
require 'types/core'

extend RDL::Annotate
type '() -> String'
def the_answer()
  return 'forty-two'
end

the_answer()
