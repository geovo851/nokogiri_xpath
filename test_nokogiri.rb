require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("http://minfin.com.ua/currency/nbu/"))

puts "\n Exchanges Rates..."
puts "---------------------------------------------------------"
puts 'Loading...'

Dir.mkdir("Exchanges_rates") unless File.exists?("Exchanges_rates")

file_name = "Exchanges_rates/Exchanges rates on #{Date.strptime(DateTime.now.to_s, '%Y-%m-%d')}.txt"
File.open(file_name, 'w') do |f|

  f.puts 'Exchanges Rates...'

  tbodies = page.xpath("//table[@class='mfm-table mfcur-table-lg mfcur-table-lg-nbu']/tbody")
  tbodies.each do |tbody|
    tbody.elements.each do |el|
      currency_code   = el.elements[0].first_element_child['href'].split('/').last
      currency_name   = el.elements[0].text.gsub(/\s+/, ' ').strip
      currency_value  = el.elements[1].xpath('text()').text.gsub(/\s+/, ' ').strip +
                        el.elements[1].xpath('span[1]').text.gsub(/\s+/, ' ').strip
      currency_change = el.elements[1].xpath('span[last()]').text.gsub(/\s+/, ' ').strip.gsub(/\s+/, '')
      puts "#{currency_code} -- #{currency_name} -- #{currency_value} -- #{currency_change}"
      f.puts "#{currency_code} -- #{currency_name} -- #{currency_value} -- #{currency_change}"
    end
  end

end

puts "Created file - #{file_name}"
puts 'Finish...'
