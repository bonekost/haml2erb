require 'haml2erb/version'
require 'haml2erb/engine'

module Haml2Erb
  def self.convert template, options = {}
    engine = Engine.new({ format: :html5 }.merge(options))
    engine.call(template)
  end
end
