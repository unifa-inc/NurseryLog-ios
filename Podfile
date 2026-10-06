platform :ios, '15.0'

# Ensure all pods match the deployment target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
    end
  end
end
use_frameworks!

target 'NurseryLog' do
  pod 'RxSwift',     '~> 6.7'
  pod 'RxCocoa',     '~> 6.7'
  pod 'Alamofire',   '~> 5.9'
  pod 'RxAlamofire', '~> 6.0'
  pod 'RealmSwift',  '~> 20.0'
  pod 'NSObject+Rx', '~> 5.0'
  pod 'R.swift'
  pod 'MaterialComponents/TextControls+OutlinedTextFields',       '~> 124.2'
  pod 'MaterialComponents/TextControls+OutlinedTextFieldsTheming','~> 124.2'
  pod 'MaterialComponents/TextControls+FilledTextFields',         '~> 124.2'
  pod 'MaterialComponents/TextControls+FilledTextFieldsTheming',  '~> 124.2'
  pod 'MaterialComponents/TextControls+OutlinedTextAreas',        '~> 124.2'
  pod 'MaterialComponents/TextControls+OutlinedTextAreasTheming', '~> 124.2'
  pod 'MaterialComponents/TextControls+FilledTextAreas',          '~> 124.2'
  pod 'MaterialComponents/TextControls+FilledTextAreasTheming',   '~> 124.2'
  pod 'MaterialComponents/Buttons',                               '~> 124.2'
  pod 'MaterialComponents/Buttons+Theming',                       '~> 124.2'
  pod 'MaterialComponents/schemes/Color',                         '~> 124.2'
  pod 'MaterialComponents/schemes/Typography',                    '~> 124.2'
  pod 'MaterialComponents/schemes/Container',                     '~> 124.2'
  pod 'MaterialComponents/Banner',                                '~> 124.2'
  pod 'MaterialComponents/Banner+Theming',                        '~> 124.2'

  target 'NurseryLogTests' do
    inherit! :search_paths
    pod 'RxTest',     '~> 6.7'
    pod 'RxBlocking', '~> 6.7'
  end
end
