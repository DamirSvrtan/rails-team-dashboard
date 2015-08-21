require 'httparty'

class MonitorFetcher
  BASE_URL = 'http://api.uptimerobot.com'
  MONITORS_REQUEST_URL = "#{BASE_URL}/getMonitors"
  API_KEY  = ENV['UPTIME_ROBOT_API_KEY']

  def initialize
    @offset = 0
    @monitors = []
    collect_monitors
  end

  def up_monitors
    monitors.select { |monitor| monitor['status'].to_i == 2 }
  end

  def down_monitors
    monitors.select { |monitor| [8, 9].include?(monitor['status'].to_i) }
  end

  def paused_monitors
    monitors.select { |monitor| ![2, 8, 9].include?(monitor['status'].to_i) }
  end

  attr_accessor :offset, :monitors

  private

  def collect_monitors
    loop do
      response_body = execute_request

      break if response_body['stat'] != 'ok'

      self.monitors += response_body['monitors']['monitor']

      self.offset += 50

      break if monitors.count == response_body['total'].to_i
    end
  end

  def execute_request
    response =
      HTTParty.get(MONITORS_REQUEST_URL, query: monitors_query_parameters.merge(offset: offset))

    JSON.parse(response.body)
  end

  def monitors_query_parameters
    { apiKey: API_KEY, format: :json, noJsonCallback: 1, customUptimeRatio: 30 }
  end
end
