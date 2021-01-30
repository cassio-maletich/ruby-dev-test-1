class Folder < ApplicationRecord
    belongs_to :parent, class_name: "Folder"
    has_many :children, class_name: "Folder", foreign_key: "parent_id"
    
    validates_presence_of :name
    validates_presence_of :parent_id, message: "must have a parent"
end
