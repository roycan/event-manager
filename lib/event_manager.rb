puts "Event Manager Initialized"

lines = File.readlines ("event_attendees.csv") if File.exist? ("event_attendees.csv")
# Dir.glob("*").each { |f| puts f}

lines.each_with_index do |line, idx|
  next if idx == 0
  puts line.split(",")[2]
end
