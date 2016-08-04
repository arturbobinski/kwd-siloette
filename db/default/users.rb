unless user = User.find_by(email: 'admin@strpprs.com')
  password = Figaro.env.default_admin_passowrd

  User.create({
    first_name:             'Admin',
    last_name:              'Strpprs',
    email:                  'admin@strpprs.com',
    password:               password,
    password_confirmation:  password,
    role:                   'admin',
    verified:               true,
    is_admin:               true
  })
end