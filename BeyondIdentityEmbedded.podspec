# THIS FILE IS GENERATED. DO NOT EDIT.

Pod::Spec.new do |s|
  s.name             = 'BeyondIdentityEmbedded'
  s.version          = '2.0.8'
  s.author           = 'Beyond Identity'
  s.summary          = 'Passwordless identities for workforces and customers'
  s.license          = 'Apache License, Version 2.0'
  s.homepage         = 'https://beyondidentity.com'
  s.documentation_url = 'https://developer.beyondidentity.com'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.5'
  s.source           = { :git => 'https://github.com/gobeyondidentity/bi-sdk-swift.git', :tag => s.version.to_s }
  s.source_files = 'Sources/Embedded/**/*'
  s.dependency 'BeyondIdentityCoreSDK', '2.0.8'
end