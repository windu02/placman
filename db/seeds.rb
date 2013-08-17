# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# puts 'ROLES'
# YAML.load(ENV['ROLES']).each do |role|
#   Role.find_or_create_by_name({ :name => role }, :without_protection => true)
#   puts 'role: ' << role
# end

puts 'USERS'
adminuser = User.new({
#                         :firstname => ENV['ADMIN_FIRSTNAME'].dup,
#                         :lastname => ENV['ADMIN_LASTNAME'].dup,
                        :email => ENV['ADMIN_EMAIL'].dup,
                        :password => ENV['ADMIN_PASSWORD'].dup,
                        :password_confirmation => ENV['ADMIN_PASSWORD'].dup
                    })
# adminuser.skip_confirmation!
adminuser.save
# adminuser.add_role :admin
# puts 'user: ' << adminuser.firstname + ' ' + adminuser.lastname + ' has admin role'
puts 'user: ' << adminuser.email + ' has no role. Password: ' + ENV['ADMIN_PASSWORD'].dup

# puts 'SUPER ADMIN'
# superadmin = AdminUser.new({    :email => ENV['SUPERADMIN_EMAIL'].dup,
#                                 :password => ENV['SUPERADMIN_PASSWORD'].dup,
#                                 :password_confirmation => ENV['SUPERADMIN_PASSWORD'].dup
#                          })
# superadmin.save
# puts 'super admin: ' << superadmin.email