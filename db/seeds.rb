# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


post1 = Post.new
post1.title = 'Primer Post de busqueda de animales'
post1.body = '<h1>Esto es el cuerpo de animal!</h1>'
post1.author = 'Abc ana'
post1.tags = 'saludos'
post1.published = true
post1.published_on = DateTime.now
post1.save

post2 = Post.new
post2.title = 'Posts de colecciones de flores paisaje'
post2.body = '<h1>Esto es el cuerpo de una flor !</h1>'
post2.author = 'Xyz aba'
post2.tags = 'básico'
post2.published = true
post2.published_on = DateTime.now
post2.save

post3 = Post.new
post3.title = 'Posts de colecciones de fotos de paisajes'
post3.body = '<h1>Esto es el cuerpo de muchos paisajes!</h1>'
post3.author = 'Xyz aba'
post3.tags = 'complejo'
post3.published = true
post3.published_on = DateTime.now
post3.save

post4 = Post.new
post4.title = 'Posts de colecciones de fotos de paisajes de nevadas'
post4.body = '<h1>Esto es el cuerpo de muchos paisajes de nevadas!</h1>'
post4.author = 'Xyz aba'
post4.tags = 'complejo'
post4.published = false
post4.published_on = DateTime.now
post4.save