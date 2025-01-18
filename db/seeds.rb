# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Creating a default admin user

# User.create!(
#   name: "STAR",
#   email: 'admin@example.com',
#   password: 'password',
#   password_confirmation: 'password',
#   user_type: 'admin'
# )

# user = User.first

# 10.times do |i|
#   Post.create(
#     title: "Post ##{i + 1}",
#     content: "This is the content for post ##{i + 1}.",
#     user_id: user.id
#   )
# end

Student.create([{ name: 'Alice' }, { name: 'Bob' }])
Course.create([{ name: 'Math' }, { name: 'Science' }])
