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

  test "shouldn't create 3 - duplicated name" do
    f = @root_folder.children.first
    folder = Folder.new(parent: @root_folder, name: f.name)
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
    assert_equal folder2, @root_folder.children.find(folder1.id).children.find(folder2.id)
  end

  test "has attachment" do
    @root_folder.files.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test.csv')), filename: 'test.csv')
    assert @root_folder.files.attached?
  end

  test "has no attachment" do
    assert_not @root_folder.files.attached?
  end

  test "has attachment & grandchild" do
    folder1 = Folder.create(name: "Folder 1", parent: @root_folder)
    folder2 = Folder.create(name: "Folder 2", parent: folder1)

    folder1.files.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test.csv')), filename: 'test.csv')

    assert_includes @root_folder.children, folder1
    assert_includes folder1.children, folder2
    assert folder1.files.attached?
  end

  test "has attachment & grandchild 2" do
    folder1 = Folder.create(name: "Folder 1", parent: @root_folder)
    folder2 = Folder.create(name: "Folder 2", parent: folder1)

    folder1.files.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test.csv')), filename: 'test.csv')
    folder2.files.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'test.csv')), filename: 'test.csv')

    assert_includes folder1.children, folder2
    assert folder1.files.attached?
    assert folder2.files.attached?
  end
end
