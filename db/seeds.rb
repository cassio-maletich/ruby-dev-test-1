# Create root folder skipping parent validation
root_folder = Folder.new(name: "/")
root_folder.save(validate: false)