require 'httparty'

SCHEDULER.every '2m' do
  headers = { 'Authorization' => "token #{ENV['BUGSNAG_API_KEY']}" }
  request_url = 'https://api.bugsnag.com/accounts/508ea9d12511bbfe2300001a/projects'

  response = HTTParty.get(request_url, query: { per_page: 100 },  headers: headers)

  # rails_projects = response.select { |project| project['type'] == 'rails' }

  project_list = response.map do |project|
    open_errors_count =
      HTTParty.get(project['errors_url'], query: { per_page: 100, status: 'open' },
                                          headers: headers).count

    { value: open_errors_count, label: project['name'] }
  end

  ordered_project_list = project_list.sort_by { |project| project[:value] }.reverse

  send_event('buzzwords', items: ordered_project_list.first(5))
end
