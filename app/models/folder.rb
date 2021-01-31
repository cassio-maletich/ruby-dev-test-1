class Folder < ApplicationRecord
    belongs_to :parent, class_name: "Folder"
    has_many :children, class_name: "Folder", foreign_key: "parent_id"

    validates :name, presence: true, uniqueness: { scope: :parent_id }

    has_many_attached :files
end
