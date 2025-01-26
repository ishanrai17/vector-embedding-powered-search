class DataStore < ApplicationRecord
    
    validates :processed, inclusion: { in: [true, false] }
end