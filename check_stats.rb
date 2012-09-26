require './dslmodem.rb'

raise "Incorrect number of arguments supplied. Need URL, username and password" if ARGV.size != 3

modem = DSLModem.new(ARGV[0], ARGV[1], ARGV[2])

while true
  modem.get_stats_page
  statistics = modem.statistics

  status = if modem.offline?
    "Offline"
  else
    "Online. Bandwidth: #{statistics[:bandwidth_downstream]}/#{statistics[:bandwidth_upstream]}. Margin: #{statistics[:margin_downstream]}/#{statistics[:margin_upstream]}"
  end

  puts "#{Time.now}: #{status}"
  sleep 60
end
