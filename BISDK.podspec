Pod::Spec.new do |s|
  s.name         = "BISDK"
  s.version      = "0.0.1"
  s.summary      = "BISDK is a swift client SDK for Comunicating with Beyond Identity's passwordless sign in."
  s.homepage     = "https://github.com/byndid/bi-sdk-swift"
  s.ios.deployment_target = "12.0"
  s.source       = { :git => "https://github.com/byndid/bi-sdk-swift.git", :tag => s.version }

  # Subspec for the only the External Authenticator
  s.subspec 'Authenticator' do |auth|
    auth.source_files = "Source/Authenticator"
    auth.frameworks = 'AuthenticationServices', 'Foundation', 'UIKit'
    auth.dependency "Source/Core"
    auth.dependency "Source/Resources"
  end

  # Subspec for the only the Embedded Authenticator
  s.subspec 'Embedded' do |embedded|
    embedded.source_files = "Source/Embedded"
    embedded.frameworks = 'AuthenticationServices', 'Foundation', 'UIKit'
    embedded.dependency "Source/Core"
    embedded.dependency "Source/Resources"
  end
end