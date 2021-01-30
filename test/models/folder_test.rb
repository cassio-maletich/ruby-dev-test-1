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

  test "parent" do
    root_folder = Folder.first
    folder = Folder.new(name: "Folder 1", parent_id: root_folder.id)
    assert_equal root_folder, folder.parent
  end

  test "grandparent" do
    root_folder = Folder.first
    folder1 = Folder.create(name: "Folder 1", parent: root_folder)
    folder2 = Folder.create(name: "Folder 2", parent: folder1)
    assert_equal root_folder, folder2.parent.parent
  end

  test "child" do
    root_folder = Folder.first
    folder = Folder.create(name: "Folder 1", parent: root_folder)
    assert root_folder.children.include? folder
  end

  test "grandchild" do
    root_folder = Folder.first
    folder1 = Folder.create(name: "Folder 1", parent: root_folder)
    folder2 = Folder.create(name: "Folder 2", parent: folder1)
    assert_equal folder2, root_folder.children.first.children.first
  end
end
