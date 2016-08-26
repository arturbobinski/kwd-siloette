pages = [
  {
    title: 'Terms of Use',
    slug: 'terms-of-use',
    page_type: 'legal',
    body: 'Please edit me <a href="/admin/pages/terms-of-use/edit">here</a>.'
  },
  {
    title: 'Privacy Policy',
    slug: 'privacy-policy',
    page_type: 'legal',
    body: 'Please edit me <a href="/admin/pages/privacy-policy/edit">here</a>.'
  },
  {
    title: 'Refund Policy',
    slug: 'refund-policy',
    page_type: 'legal',
    body: 'Please edit me <a href="/admin/pages/refund-polic/edit">here</a>.'
  },
  {
    title: 'Content Policy',
    slug: 'content-policy',
    page_type: 'legal',
    body: 'Please edit me <a href="/admin/pages/content-policy/edit">here</a>.'
  },
  {
    title: 'Software License Agreement',
    slug: 'software-license-agreement',
    page_type: 'legal',
    body: 'Please edit me <a href="/admin/pages/software-license-agreement/edit">here</a>.'
  },
  {
    title: 'FAQs for Performers',
    slug: 'faqs-for-perfomers',
    page_type: 'faq',
    body: 'Please edit me <a href="/admin/pages/faqs-for-perfomers/edit">here</a>.'
  },
  {
    title: 'FAQs for Customers',
    slug: 'faqs-for-customers',
    page_type: 'faq',
    body: 'Please edit me <a href="/admin/pages/faqs-for-customers/edit">here</a>.'
  },
  {
    title: 'About',
    slug: 'about',
    page_type: 'general',
    body: 'Please edit me <a href="/admin/pages/about/edit">here</a>.'
  },
  {
    title: 'Contact Us',
    slug: 'contact-us',
    page_type: 'general',
    body: 'Please edit me <a href="/admin/pages/privacy/edit">here</a>.'
  },
  {
    title: 'Deals',
    slug: 'deals',
    page_type: 'deals',
    body: 'Please edit me <a href="/admin/pages/deals/edit">here</a>.'
  },
  {
    title: 'Tips',
    slug: 'tips',
    page_type: 'tips',
    body: 'Please edit me <a href="/admin/pages/tips/edit">here</a>.'
  }
]

pages.each do |page|
  Page.find_or_create_by(slug: page[:slug]) do |p|
    p.title = page[:title]
    p.body = page[:body]
    p.page_type = page[:page_type] if page[:page_type]
  end
end