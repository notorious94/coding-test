# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_user = User.create(email: 'user@admin.com',
                         password: 123_456,
                         password_confirmation: 123_456)

100.times do
  Campaign.create(name: Faker::Company.unique.name,
                  image: 'https://drive.google.com/file/d/1ySv3C9gzvcdG0PfqJVmNx68aLsCVYoNv/view?usp=sharing',
                  sector: Faker::Job.field,
                  country: Faker::Address.country,
                  creator_id: admin_user.id,
                  target_amount: Faker::Number.decimal(l_digits: 10, r_digits: 2),
                  investment_multiple: Faker::Number.decimal(l_digits: 2, r_digits: 2))
end
