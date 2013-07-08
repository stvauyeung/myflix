# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: "Mad Men", description: "Don Draper seduces a multitude of women while heading the creative department of a boutique advertisement agency.", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Archer", description: "Dysfunctional spy agency Isis protects the world from terrorist activity despite being led by an alcoholic mother son pair.", small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "South Park", description: "A class of potty mouthed third graders seek adventure in their small mountain community in Colorado.", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: "Pulp Fiction", description: "I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know my name is the Lord when I lay my vengeance upon thee.", small_cover_url: "/tmp/pulp_fiction.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
Video.create(title: "Breaking Bad", description: "High school chemistry teacher, Walter White, is diagnosed with lung cancer. He turns to a life of crime, producing and selling methamphetamine with the aim of securing his family's financial future.", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
Video.create(title: "Tomb Raider", description: "Lara Croft races against time and villains to recover a powerful artefact called the Triangle of Light.", small_cover_url: "/tmp/tomb_raider.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
Video.create(title: "Pulp Fiction 2", description: "I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know my name is the Lord when I lay my vengeance upon thee.", small_cover_url: "/tmp/pulp_fiction.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
Video.create(title: "Breaking Bad 2", description: "High school chemistry teacher, Walter White, is diagnosed with lung cancer. He turns to a life of crime, producing and selling methamphetamine with the aim of securing his family's financial future.", small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
Video.create(title: "Tomb Raider 2", description: "Lara Croft races against time and villains to recover a powerful artefact called the Triangle of Light.", small_cover_url: "/tmp/tomb_raider.jpg", large_cover_url: "/tmp/mad_men_large.jpg")
Video.create(title: "Tomb Raider 3", description: "Lara Croft races against time and villains to recover a powerful artefact called the Triangle of Light.", small_cover_url: "/tmp/tomb_raider.jpg", large_cover_url: "/tmp/mad_men_large.jpg")

Category.create(name: "Action")
Category.create(name: "Comedy")

c = Category.find 1
c2 = Category.find 2

Video.find(1).categories << c
Video.find(2).categories << c
Video.find(3).categories << c
Video.find(4).categories << c2
Video.find(5).categories << c2
Video.find(6).categories << c2
Video.find(7).categories << c2
Video.find(8).categories << c2
Video.find(9).categories << c2
Video.find(10).categories << c2

User.create(name: "Joe", email:"joe@joe.com", password: "password")
User.create(name: "Molly", email:"molly@molly.com", password: "password")