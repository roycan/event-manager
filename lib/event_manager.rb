require "csv"

puts "Event Manager Initialized"

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol) if File.exist? ("event_attendees.csv")
# Dir.glob("*").each { |f| puts f}

contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]

  # zip codes are 5 digit numbers
  # pad zeros in front to make 5 digits
  # truncate when necessary

  zipcode = zipcode.to_s.rjust(5, "0")[0..4]


  puts "#{name}  #{zipcode}"
end
