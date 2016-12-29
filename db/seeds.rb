# Template
# Product.create!(
#   name: 'Honey Crisp',
#   code: 3283,
#   price: 1.00,
#   keywords: 'Apple',
#   department: 'Produce'
# )

# Apples
Product.create!(
  name: 'Ambrosia',
  code: "94210",
  price: 1.00,
  keywords: 'Apple',
  department: 'Produce'
)

Product.create!(
  name: 'Braeburns',
  code: "4101",
  price: 1.00,
  keywords: 'Apple',
  department: 'Produce'
)

Product.create!(
  name: 'Fuji',
  code: "4129",
  price: 1.00,
  keywords: 'Apple',
  department: 'Produce'
)

Product.create!(
  name: 'Granny Smith',
  code: "4138",
  price: 1.00,
  keywords: 'Apple',
  department: 'Produce'
)

Product.create!(
  name: 'Pink Lady',
  code: "4128",
  price: 1.00,
  keywords: 'Apple',
  department: 'Produce'
)



Product.create!(
  name: 'Honey Crisp',
  code: "3283",
  price: 1.00,
  keywords: 'Apple',
  department: 'Produce'
)


Product.create!(
  name: 'Corn',
  code: "4590",
  price: 1.00,
  keywords: 'Corn',
  department: 'Produce'
)

Product.create!(
  name: 'Spanish Onion',
  code: "4093",
  price: 1.00,
  keywords: 'Onion',
  department: 'Produce'
)

data = Roo::Excelx.new("./Bulk_Spreadsheet.xlsx")

data.default_sheet = data.sheets.first

2.upto(data.last_row) do |line|
  name = data.cell(line, 'E')
  code = data.cell(line, 'B')

  # if code < 100.000
    Product.create!(
      name: name,
      code: code,
      department: 'Bulk'
    )
  # end

end
