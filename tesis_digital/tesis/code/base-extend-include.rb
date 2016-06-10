module Bezel
  class Base
    extend Bezel::Associations
    extend ActiveModel::Naming
    include Bezel::Connections
    include ActiveModel::Conversion
    
    # ...
  
  end
end