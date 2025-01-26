class QA < ApplicationRecord
    validates :question, presence: true
    validates :answer, presence: true
    validates :embedding, presence: true

    # Add any additional methods or logic for the QA model here
end