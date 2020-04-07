# Uncomment the next line to define a global platform for your project
platform :ios, '13.2'

target 'TsundokuBreak' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TsundokuBreak
    pod 'SwiftLint'
    pod 'R.swift'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'Moya'
    pod 'LicensePlist'
    pod 'ColorMatchTabs'
    pod 'Cards'
    pod 'MaterialComponents/Buttons'
    pod 'AlamofireImage'
    pod 'SwiftGifOrigin'
    pod 'MBProgressHUD'

  target 'TsundokuBreakTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'TsundokuBreakUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
        '$(FRAMEWORK_SEARCH_PATHS)'
      ]
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
     end
  end
  end

end
