# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# =============================================
# Users
# =============================================
User.destroy_all()
User.create(email: 'david.king@unf.edu', first_name: 'David', last_name: 'King', password: 'password')

# =============================================
# Catalogs
# =============================================
Catalog.destroy_all()
catalog01 = Catalog.create(title: '2009-2010 Academic Catalog')
catalog02 = Catalog.create(title: '2010-2011 Academic Catalog')
catalog03 = Catalog.create(title: '2011-2012 Academic Catalog')
catalog04 = Catalog.create(title: '2012-2013 Academic Catalog')
catalog05 = Catalog.create(title: '2013-2014 Academic Catalog')
catalog06 = Catalog.create(title: '2014-2015 Academic Catalog')

# =============================================
# Semesters
# =============================================
Semester.destroy_all()
sem01 = Semester.create(title: 'Fall 2009',     catalog_id: catalog01.id)
sem02 = Semester.create(title: 'Spring 2010',   catalog_id: catalog01.id)
sem03 = Semester.create(title: 'Summer 2010',   catalog_id: catalog01.id)

sem04 = Semester.create(title: 'Fall 2010',     catalog_id: catalog02.id)
sem05 = Semester.create(title: 'Spring 2011',   catalog_id: catalog02.id)
sem06 = Semester.create(title: 'Summer 2011',   catalog_id: catalog02.id)

sem07 = Semester.create(title: 'Fall 2011',     catalog_id: catalog03.id)
sem08 = Semester.create(title: 'Spring 2012',   catalog_id: catalog03.id)
sem09 = Semester.create(title: 'Summer 2012',   catalog_id: catalog03.id)

sem10 = Semester.create(title: 'Fall 2012',     catalog_id: catalog04.id)
sem11 = Semester.create(title: 'Spring 2013',   catalog_id: catalog04.id)
sem12 = Semester.create(title: 'Summer 2013',   catalog_id: catalog04.id)

sem13 = Semester.create(title: 'Fall 2013',     catalog_id: catalog05.id)
sem14 = Semester.create(title: 'Spring 2014',   catalog_id: catalog05.id)
sem15 = Semester.create(title: 'Summer 2014',   catalog_id: catalog05.id)

sem16 = Semester.create(title: 'Fall 2014',     catalog_id: catalog06.id)
sem17 = Semester.create(title: 'Spring 2015',   catalog_id: catalog06.id)
sem18 = Semester.create(title: 'Summer 2015',   catalog_id: catalog06.id)

# =============================================
# Courses
# =============================================
Course.destroy_all()