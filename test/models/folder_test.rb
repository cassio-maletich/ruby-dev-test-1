require 'test_helper'

class FolderTest < ActiveSupport::TestCase
  setup do 
    @root_folder = Folder.first
  end

  test "create" do
    folder = Folder.new(name: "Folder 1", parent: @root_folder)
    assert folder.valid?
  end

  test "shouldn't create 1 - missing parent" do
    folder = Folder.new(name: "Folder 1")
    assert_not folder.valid?
    assert_not_empty folder.errors[:parent]
  end

  test "shouldn't create 2 - missing name" do
    folder = Folder.new(parent: @root_folder)
    assert_not folder.valid?
    assert_not_empty folder.errors[:name]
  end

  test "parent" do
    folder = Folder.create(name: "Folder 1", parent: @root_folder)
    assert_equal @root_folder, folder.parent
  end

  test "grandparent" do
    folder1 = Folder.create(name: "Folder 1", parent: @root_folder)
    folder2 = Folder.create(name: "Folder 2", parent: folder1)
    assert_equal @root_folder, folder2.parent.parent
  end

  test "child" do
    folder = Folder.create(name: "Folder 1", parent: @root_folder)
    assert @root_folder.children.include? folder
  end

  test "grandchild" do
    folder1 = Folder.create(name: "Folder 1", parent: @root_folder)
    folder2 = Folder.create(name: "Folder 2", parent: folder1)
    assert_equal folder2, @root_folder.children.first.children.first
  end
end
