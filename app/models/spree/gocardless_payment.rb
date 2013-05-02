class GocardlessPayment < ActiveRecord::Base
  attr_accessible :number, :paid, :resource_id, :resource_type, :status
end