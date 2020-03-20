# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'SimpleBillMgr' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'SwiftyJSON', '~> 4.2.0'
  pod 'Alamofire'
  # SQLite.swift 与 Xcode 10.2 兼容性不佳
  pod 'SQLite.swift', '~> 0.12.0' #, '~> 0.11.5'
  pod 'IQKeyboardManager'
  pod 'SwiftDate'
  pod 'Charts'
  pod 'SnapKit'
  pod "EFColorPicker"
  # pod 'Daysquare', :git => 'https://github.com/unixzii/Daysquare.git'

  target 'SimpleBillMgrTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SimpleBillMgrUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
