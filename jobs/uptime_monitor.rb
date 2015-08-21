require_relative '../lib/monitor_fetcher'

SCHEDULER.every '2m' do
  monitor_fetcher = MonitorFetcher.new

  puts monitor_fetcher.up_monitors.count
  send_event('up_monitors',     value: monitor_fetcher.up_monitors.count,
                                total: monitor_fetcher.monitors.count)

  send_event('down_monitors',   value: monitor_fetcher.down_monitors.count,
                                total: monitor_fetcher.monitors.count)

  send_event('paused_monitors', value: monitor_fetcher.paused_monitors.count,
                                total: monitor_fetcher.monitors.count)
end
