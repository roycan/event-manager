require "csv"

puts "Event Manager Initialized"

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol) if File.exist? ("event_attendees.csv")
# Dir.glob("*").each { |f| puts f}

contents.each do |row|
  puts name = row[:first_name]
end
