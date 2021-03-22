Pod::Spec.new do |s|
  s.name                  = "BISDK"
  s.version               = "0.0.1"
  s.summary               = "A swift client SDK for comunicating with Beyond Identity's passwordless authentication."

  s.homepage              = "https://github.com/byndid/bi-sdk-swift.git"
  s.license               = { :type => "Apache License", :file => 'LICENSE' }
  s.author                = { "Anna" => "email removed" }

  s.ios.deployment_target = "12.0"

  s.source                = { :git => "https://github.com/byndid/bi-sdk-swift.git", :commit => "09a1e7d6b2cc7037375de0e6a1acf45df1f5c585" }
  s.source_files          = "**/Source/**/*.{swift}"
  s.resources             = "Source/Resources"
  s.frameworks            = 'AuthenticationServices', 'Foundation', 'UIKit'
end 
