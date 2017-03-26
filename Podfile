# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'swift-github-repo-search-lab' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inherit! :search_paths

  # Pods for swift-github-repo-search-lab
  pod 'Alamofire', '~> 4.0'
  pod 'SwiftyJSON'
  
  target 'swift-github-repo-search-labTests' do
      inherit! :search_paths
      pod 'OHHTTPStubs'
      pod 'Quick'
      pod 'Nimble'
      pod 'KIF', '~> 3.0', :configurations => ['Debug']
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
