require 'rdl'
extend RDL::Annotate
type Test, :plus, '(Fixnum or String, Fixnum or String) -> Fixnum', typecheck: :now
