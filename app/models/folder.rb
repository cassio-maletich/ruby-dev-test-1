class Folder < ApplicationRecord
    belongs_to :parent, class_name: "Folder"
    has_many :children, class_name: "Folder", foreign_key: "parent_id"

    validates_presence_of :name
end
