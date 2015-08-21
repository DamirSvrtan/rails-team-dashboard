
require 'github-trending'

GITHUB_TRENDING_BLACKLIST = ['rails/rails',
                             'Homebrew/homebrew',
                             'mitchellh/vagrant',
                             'gitlabhq/gitlabhq',
                             'venmo/slather', # iOS Testing Tool
                             'jekyll/jekyll',
                             'ruby/ruby',
                             'twbs/bootstrap-sass',
                             'KrauseFx/fastlane', # iOS Deployment Tool
                             'sass/sass',
                             'plataformatec/devise',
                             'discourse/discourse',
                             'middleman/middleman',
                             'fastlane/gym', # iOS Tool
                             'sinatra/sinatra',
                             'CocoaPods/CocoaPods']

SCHEDULER.every '1m' do
  trending_ruby_repos = Github::Trending.get(:ruby)

  whitlelisted_repos = trending_ruby_repos.reject do |repo|
    GITHUB_TRENDING_BLACKLIST.include?(repo.name)
  end

  formatted_trending_ruby_repos = whitlelisted_repos.first(3).map do |repo|
    { name: repo.name, star_count: repo.star_count, description: repo.description }
  end

  send_event('github_trending', items: formatted_trending_ruby_repos)
end
