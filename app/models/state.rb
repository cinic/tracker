# Class named State.rb
# device states and GIS
class State < ActiveRecord::Base
  belongs_to :device
end
