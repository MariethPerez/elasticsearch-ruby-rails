# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


post1 = Post.new
post1.title = 'Primer post1'
post1.body = '<h1>Esto es el cuerpo del post1!</h1>'
post1.author = 'Abc abc'
post1.tags = 'saludos'
post1.published = true
post1.published_on = DateTime.now
post1.save

post2 = Post.new
post2.title = 'Primer post2'
post2.body = '<h1>Esto es el cuerpo del post2!</h1>'
post2.author = 'Xyz xyz'
post2.tags = 'saludos'
post2.published = true
post2.published_on = DateTime.now
post2.save