Pod::Spec.new do |s|
  s.name = 'SwiftPin'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.version = '0.0.1'
  s.summary  = 'Configurable view to ask for pin input'
  s.source = { :git => '', :tag => "#{s.version}" }
  s.authors = 'Peter IJlst'
  s.license = 'MIT'
  s.homepage = 'https://github.com/0xPr0xy/SwiftPin/blob/master/README.md'
  s.source_files = 'SwiftPin/Classes/**/*.swift'
end
