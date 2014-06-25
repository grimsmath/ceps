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
catalog01 = Catalog.create(title: '2009-2010 Academic Calendar')
catalog02 = Catalog.create(title: '2010-2011 Academic Calendar')
catalog03 = Catalog.create(title: '2011-2012 Academic Calendar')
catalog04 = Catalog.create(title: '2012-2013 Academic Calendar')
catalog05 = Catalog.create(title: '2013-2014 Academic Calendar')
catalog06 = Catalog.create(title: '2014-2015 Academic Calendar')
catalog07 = Catalog.create(title: '2015-2016 Academic Calendar')

# =============================================
# Catalogs
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

sem19 = Semester.create(title: 'Fall 2015',     catalog_id: catalog07.id)
sem20 = Semester.create(title: 'Spring 2016',   catalog_id: catalog07.id)
sem21 = Semester.create(title: 'Summer 2016',   catalog_id: catalog07.id)

# =============================================
# Courses
# =============================================
Course.destroy_all()
# c01 = Course.create(title: 'Introduction Computer Hardware',
#                     number: 'CDA3101',
#                     credits: 4,
#                     is_locked: false,
#                     semester_id: sem14.id,
#                     sections: [
#                       {
#                         crn: 10001,
#                         enr_cap: 50,
#                         enr_act: 43,
#                         wait_cap: 10,
#                         wait_act: 0
#                       },
#                       {
#                         crn: 10002,
#                         enr_cap: 50,
#                         enr_act: 40,
#                         wait_cap: 10,
#                         wait_act: 0
#                       }
#                     ])
#
# c02 = Course.create(title: 'Software Engineering',
#                     number: 'CEN4010',
#                     credits: 3,
#                     is_locked: false,
#                     semester_id: sem14.id)
#
# c03 = Course.create(title: 'Engineering of Software II',
#                     number: 'CEN6017',
#                     credits: 3,
#                     is_locked: false,
#                     semester_id: sem14.id)
#
# c04 = Course.create(title: 'Computer Applications for Busi',
#                     number: 'CGS1100',
#                     credits: 3,
#                     is_locked: false,
#                     semester_id: sem14.id)
#
# c05 = Course.create(title: 'Microcomputer Applica Software',
#                     number: 'CGS1570',
#                     credits: 3,
#                     is_locked: false,
#                     semester_id: sem14.id)