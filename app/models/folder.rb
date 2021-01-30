class Folder < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :parent_id, message: "must have a parent"
end
