unless user = User.find_by(email: 'admin@strpprs.com')
  password = Figaro.env.default_admin_passowrd

  User.create({
    first_name:             'Admin',
    last_name:              'Strpprs',
    email:                  'admin@strpprs.com',
    password:               password,
    password_confirmation:  password,
    role:                   'admin',
    is_admin:               true
  })
end

pages = [
  {
    title: 'Terms of Use',
    slug: 'terms-of-use',
    body: 'Please edit me <a href="/admin/pages/terms-of-use/edit">here</a>.'
  },
  {
    title: 'Privacy',
    slug: 'privacy',
    body: 'Please edit me <a href="/admin/pages/privacy/edit">here</a>.'
  },
  {
    title: 'FAQs',
    slug: 'faqs',
    body: 'Please edit me <a href="/admin/pages/faqs/edit">here</a>.'
  },
  {
    title: 'About',
    slug: 'about',
    body: 'Please edit me <a href="/admin/pages/about/edit">here</a>.'
  },
  {
    title: 'Contact Us',
    slug: 'contact_us',
    body: 'Please edit me <a href="/admin/pages/privacy/edit">here</a>.'
  },
  {
    title: 'Deals',
    slug: 'deals',
    body: 'Please edit me <a href="/admin/pages/deals/edit">here</a>.',
    for_dancer: true
  },
  {
    title: 'Tips',
    slug: 'tips',
    body: 'Please edit me <a href="/admin/pages/tips/edit">here</a>.',
    for_dancer: true
  }
]

pages.each do |page|
  Page.find_or_create_by(slug: page[:slug]) do |p|
    p.title = page[:title]
    p.body = page[:body]
    p.for_dancer = page[:for_dancer] if page[:for_dancer]
  end
end
