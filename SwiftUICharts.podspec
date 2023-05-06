Pod::Spec.new do |s|
  s.name             = 'SwiftUICharts'
  s.version          = '2.10.2'
  s.summary          = 'A charts / plotting library for SwiftUI.'
  s.description      = 'A charts / plotting library for SwiftUI. Works on macOS, iOS, watchOS, and tvOS and has accessibility features built in.'
  s.homepage         = 'https://github.com/willdale/SwiftUICharts'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'willdale' => 'www.linkedin.com/in/willdale-dev' }
  s.source           = { :git => 'https://github.com/willdale/SwiftUICharts.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  s.tvos.deployment_target = '14.0'
  s.watchos.deployment_target = '7.0'
  s.macos.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/SwiftUICharts/**/*'
end
