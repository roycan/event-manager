require "csv"
require 'google/apis/civicinfo_v2'


def clean_zipcode(zipcode)

  # zip codes are 5 digit numbers
  # pad zeros in front to make 5 digits
  # truncate when necessary

  zipcode = zipcode.to_s.rjust(5, "0")[0..4]
end


def legislators_by_zipcode(zipcode)
  begin
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
    response = civic_info.representative_info_by_address(address: 80202,
                            levels: 'country',
                            roles: ['legislatorUpperBody',
                              'legislatorLowerBody'])
    legislators = response.officials
    return legislators = legislators.map(&:name).join(", ")
  rescue
    return legislators =  "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end




puts "Event Manager Initialized"

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol) if File.exist? ("event_attendees.csv")
# Dir.glob("*").each { |f| puts f}

template_letter = File.read("form_letter.html")

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = row[:zipcode]

  zipcode = clean_zipcode(zipcode)

  legislators = legislators_by_zipcode(zipcode)

  puts "#{name}  #{zipcode} #{legislators}"

  personal_letter = template_letter.gsub("FIRST_NAME", name)
  personal_letter = personal_letter.gsub("LEGISLATORS", legislators)

  puts personal_letter

  # create a file for each personal_letter
  Dir.mkdir("output") unless Dir.exist? ("output")
  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts personal_letter
  end

end
