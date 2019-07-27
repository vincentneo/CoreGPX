#
# Be sure to run `pod lib lint GPXKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CoreGPX'
  s.version          = '0.7.0'
  s.summary          = 'A library for reading and creation of GPX location log files.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
GPXKit is designed to replace the aging, and abandoned project, iOS-GPX-Framework. This pod will be able to help developers parse and create GPX files more easily. More features will be added to the future.
                       DESC

  s.homepage         = 'https://github.com/vincentneo/CoreGPX'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vincentneo' => '23420208+vincentneo@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/vincentneo/CoreGPX.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ivincentneo'

  s.swift_versions = ['4.2', '5.0']
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Classes'
  
  # s.resource_bundles = {
  #   'GPXKit' => ['GPXKit/Assets/*.png']
  # }

  #s.public_header_files = 'Classes/Dependencies/TBXML/'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'TBXML'
end
