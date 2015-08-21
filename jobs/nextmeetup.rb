require 'httparty'
require 'pry'

SCHEDULER.every '130s' do
  request_url =
    "https://api.meetup.com/2/events?&group_id=13140052&page=1&key=#{ENV['MEETUP_API_KEY']}"

  response = HTTParty.get(request_url)

  meetup_time_in_miliseconds = response['results'].first['time']

  meetup_datetime  = Time.at(meetup_time_in_miliseconds / 1000).to_datetime
  current_datetime = DateTime.now
  time_difference  = meetup_datetime - current_datetime

  days  = (time_difference).to_i
  hours = ((time_difference - days) * 24).to_i
  minutes = (((time_difference - days) * 24 - hours) * 60).to_i

  until_next_meeetup = if days > 0
                         "#{days} days"
                       elsif hours > 0
                         "#{hours} hours"
                       else
                         "#{minutes} min"
                       end

  send_event('nextmeetup', current: until_next_meeetup)
end
