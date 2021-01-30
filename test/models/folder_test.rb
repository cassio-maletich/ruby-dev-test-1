require 'test_helper'

class FolderTest < ActiveSupport::TestCase
  test "create" do
    root_folder = Folder.first
    folder = Folder.new(name: "Folder 1", parent_id: root_folder.id)
    assert folder.valid?
  end

  test "shouldn't create 1 - missing parent" do
    folder = Folder.new(name: "Folder 1")
    assert_not folder.valid?
    assert_not_empty folder.errors[:parent_id]
  end

  test "shouldn't create 2 - missing name" do
    root_folder = Folder.first
    folder = Folder.new(parent_id: root_folder.id)
    assert_not folder.valid?
    assert_not_empty folder.errors[:name]
  end
end
