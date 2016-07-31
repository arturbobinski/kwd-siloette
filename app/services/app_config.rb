class AppConfig

  def self.patterns
    {
      phonenumber:    '(1-?)?(\s+)?(\([2-9]\d{2}\)|[2-9]\d{2})(\s+)?-?[2-9]\d{2}-?\d{4}',
      slug:           '[a-z0-9]+(?:-[a-z0-9]+)*',
      zipcode:        '(\d{5}(?:[-\s]\d{4})?|(GIR|[A-Z]\d[A-Z\d]??|[A-Z]{2}\d[A-Z\d]??)[ ]??(\d[A-Z]{2}))',
    }
  end
end