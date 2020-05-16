require "csv"
require 'google/apis/civicinfo_v2'
require "erb"


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
    response = civic_info.representative_info_by_address(address: zipcode,
                            levels: 'country',
                            roles: ['legislatorUpperBody',
                              'legislatorLowerBody'])
    return legislators = response.officials
    # return legislators = legislators.map(&:name).join(", ")
  rescue
    return legislators =  "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end


def save_template_letter(personal_letter, id)

  # puts personal_letter

  # create a file for each personal_letter
  Dir.mkdir("output") unless Dir.exist? ("output")
  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts personal_letter
  end
end


def clean_phone_numbers(number)
  num = number.gsub(/\D+/, '')

  if num.length == 10
    return num
  elsif num.length == 11 and num[0] == 1
    return num = num[1..11]
  else
    return ""
  end

end







puts "Event Manager Initialized"

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol) if File.exist? ("event_attendees.csv")
# Dir.glob("*").each { |f| puts f}

template_letter = File.read("form_letter.erb")

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = row[:zipcode]
  home_phone = row[:homephone]
  home_phone = clean_phone_numbers(home_phone)

  zipcode = clean_zipcode(zipcode)

  puts "#{name}  #{zipcode} #{home_phone}"

  legislators = legislators_by_zipcode(zipcode)


  if legislators.kind_of? (Array)
    legislators.each do |l|
      puts l.name
      puts l.urls
    end
  elsif legislators.kind_of? (String)
    puts legislators
  end

  template = ERB.new(template_letter)
  personal_letter = template.result(binding)

  save_template_letter(personal_letter, id )


end
