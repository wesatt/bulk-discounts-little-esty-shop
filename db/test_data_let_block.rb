# this file exists to copy/paste test data as needed in a let block

# merchant status:["disabled", "enabled"] disabled by default
let!(:merchant1) { create(:merchant, status: 1) }
let!(:merchant2) { create(:merchant, status: 1) }
let!(:merchant3) { create(:merchant, status: 1) }
let!(:merchant4) { create(:merchant, status: 1) }
let!(:merchant5) { create(:merchant, status: 1) }
let!(:merchant6) { create(:merchant, status: 1) }

# item status:["Disabled", "Enabled"] disabled by default
let!(:item1) { create(:item, unit_price: 100, status: 1, merchant: merchant1) }
let!(:item2) { create(:item, unit_price: 100, status: 1, merchant: merchant2) }
let!(:item3) { create(:item, unit_price: 100, status: 1, merchant: merchant3) }
let!(:item4) { create(:item, unit_price: 100, status: 1, merchant: merchant4) }
let!(:item5) { create(:item, unit_price: 100, status: 1, merchant: merchant5) }
let!(:item6) { create(:item, unit_price: 100, status: 1, merchant: merchant6) }
let!(:item7) { create(:item, unit_price: 100, status: 1, merchant: merchant1) }
let!(:item8) { create(:item, unit_price: 100, status: 1, merchant: merchant2) }
let!(:item9) { create(:item, unit_price: 100, status: 1, merchant: merchant3) }
let!(:item10) { create(:item, unit_price: 100, status: 1, merchant: merchant4) }
let!(:item11) { create(:item, unit_price: 100, status: 1, merchant: merchant5) }
let!(:item12) { create(:item, unit_price: 100, status: 1, merchant: merchant6) }

let!(:bulk_discount1) { BulkDiscount.create(percentage: 0.10, quantity_threshold: 10, merchant: merchant1) }
let!(:bulk_discount2) { BulkDiscount.create(percentage: 0.11, quantity_threshold: 11, merchant: merchant2) }
let!(:bulk_discount3) { BulkDiscount.create(percentage: 0.12, quantity_threshold: 12, merchant: merchant3) }
let!(:bulk_discount4) { BulkDiscount.create(percentage: 0.13, quantity_threshold: 13, merchant: merchant4) }
let!(:bulk_discount5) { BulkDiscount.create(percentage: 0.14, quantity_threshold: 14, merchant: merchant5) }
let!(:bulk_discount6) { BulkDiscount.create(percentage: 0.15, quantity_threshold: 15, merchant: merchant6) }
let!(:bulk_discount7) { BulkDiscount.create(percentage: 0.25, quantity_threshold: 20, merchant: merchant1) }
let!(:bulk_discount8) { BulkDiscount.create(percentage: 0.26, quantity_threshold: 21, merchant: merchant2) }
let!(:bulk_discount9) { BulkDiscount.create(percentage: 0.27, quantity_threshold: 22, merchant: merchant3) }
let!(:bulk_discount10) { BulkDiscount.create(percentage: 0.28, quantity_threshold: 23, merchant: merchant4) }
let!(:bulk_discount11) { BulkDiscount.create(percentage: 0.29, quantity_threshold: 24, merchant: merchant5) }
let!(:bulk_discount12) { BulkDiscount.create(percentage: 0.30, quantity_threshold: 25, merchant: merchant6) }

let!(:customer1) { create(:customer) }
let!(:customer2) { create(:customer) }
let!(:customer3) { create(:customer) }
let!(:customer4) { create(:customer) }
let!(:customer5) { create(:customer) }
let!(:customer6) { create(:customer) }

# invoice status:["in progress", "completed", "cancelled"] no default
let!(:invoice1) { create(:invoice, status: 0, customer: customer1) }
let!(:invoice2) { create(:invoice, status: 0, customer: customer2) }
let!(:invoice3) { create(:invoice, status: 0, customer: customer3) }
let!(:invoice4) { create(:invoice, status: 0, customer: customer4) }
let!(:invoice5) { create(:invoice, status: 0, customer: customer5) }
let!(:invoice6) { create(:invoice, status: 0, customer: customer6) }
let!(:invoice7) { create(:invoice, status: 0, customer: customer1) }
let!(:invoice8) { create(:invoice, status: 0, customer: customer2) }
let!(:invoice9) { create(:invoice, status: 0, customer: customer3) }
let!(:invoice10) { create(:invoice, status: 0, customer: customer4) }
let!(:invoice11) { create(:invoice, status: 0, customer: customer5) }
let!(:invoice12) { create(:invoice, status: 0, customer: customer6) }

#  transaction result:["success", "failed"] no default
let!(:transaction1) { create(:transaction, invoice: invoice1, result: 0) }
let!(:transaction2) { create(:transaction, invoice: invoice2, result: 0) }
let!(:transaction3) { create(:transaction, invoice: invoice3, result: 0) }
let!(:transaction4) { create(:transaction, invoice: invoice4, result: 0) }
let!(:transaction5) { create(:transaction, invoice: invoice5, result: 0) }
let!(:transaction6) { create(:transaction, invoice: invoice6, result: 0) }
let!(:transaction7) { create(:transaction, invoice: invoice7, result: 0) }
let!(:transaction8) { create(:transaction, invoice: invoice8, result: 0) }
let!(:transaction9) { create(:transaction, invoice: invoice9, result: 0) }
let!(:transaction10) { create(:transaction, invoice: invoice10, result: 0) }
let!(:transaction11) { create(:transaction, invoice: invoice11, result: 0) }
let!(:transaction12) { create(:transaction, invoice: invoice12, result: 0) }
let!(:transaction13) { create(:transaction, invoice: invoice1, result: 0) }
let!(:transaction14) { create(:transaction, invoice: invoice2, result: 0) }
let!(:transaction15) { create(:transaction, invoice: invoice3, result: 0) }
let!(:transaction16) { create(:transaction, invoice: invoice4, result: 0) }
let!(:transaction17) { create(:transaction, invoice: invoice5, result: 0) }
let!(:transaction18) { create(:transaction, invoice: invoice6, result: 0) }
let!(:transaction19) { create(:transaction, invoice: invoice7, result: 0) }
let!(:transaction20) { create(:transaction, invoice: invoice8, result: 0) }
let!(:transaction21) { create(:transaction, invoice: invoice9, result: 0) }
let!(:transaction22) { create(:transaction, invoice: invoice10, result: 0) }
let!(:transaction23) { create(:transaction, invoice: invoice11, result: 0) }
let!(:transaction24) { create(:transaction, invoice: invoice12, result: 0) }

# invoice_item status:["pending", "packaged", "shipped"] no default
let!(:invoice_item1) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item1, invoice: invoice1) }
let!(:invoice_item2) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item2, invoice: invoice2) }
let!(:invoice_item3) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item3, invoice: invoice3) }
let!(:invoice_item4) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item4, invoice: invoice4) }
let!(:invoice_item5) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item5, invoice: invoice5) }
let!(:invoice_item6) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item6, invoice: invoice6) }
let!(:invoice_item7) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item1, invoice: invoice7) }
let!(:invoice_item8) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item2, invoice: invoice8) }
let!(:invoice_item9) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item3, invoice: invoice9) }
let!(:invoice_item10) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item4, invoice: invoice10) }
let!(:invoice_item11) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item5, invoice: invoice11) }
let!(:invoice_item12) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item6, invoice: invoice12) }
let!(:invoice_item13) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item2, invoice: invoice1) }
let!(:invoice_item14) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item3, invoice: invoice2) }
let!(:invoice_item15) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item4, invoice: invoice3) }
let!(:invoice_item16) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item5, invoice: invoice4) }
let!(:invoice_item17) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item6, invoice: invoice5) }
let!(:invoice_item18) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item1, invoice: invoice6) }
let!(:invoice_item19) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item2, invoice: invoice7) }
let!(:invoice_item20) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item3, invoice: invoice8) }
let!(:invoice_item21) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item4, invoice: invoice9) }
let!(:invoice_item22) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item5, invoice: invoice10) }
let!(:invoice_item23) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item6, invoice: invoice11) }
let!(:invoice_item24) { create(:invoice_item, unit_price: 100, quantity: 1, status: 0, item: item1, invoice: invoice12) }
