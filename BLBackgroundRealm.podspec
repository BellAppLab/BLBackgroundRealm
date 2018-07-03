Pod::Spec.new do |s|

  s.name                = "BLBackgroundRealm"
  s.version             = "1.0.3"
  s.summary             = "A collection of handy classes and extensions that make it easier to work with `Realm` in the background."
  s.screenshot          = "https://github.com/BellAppLab/BLBackgroundRealm/raw/master/Images/background_realm.png"

  s.description         = <<-DESC
BLBackgroundRealm is a collection of handy classes and extensions that make it easier to work with `Realm` in the background.

It's main focus is to enhance existing `Realm`s and Realm-based code bases with very little overhead and refactoring.

**Note**: Although this module makes it more convenient to work with a `Realm` in the background, it does **not** make  `Realm`s nor its objects thread-safe. They should still be accessed only from within their appropriate thread.

For the Swift counterpart, see [BackgroundRealm](https://github.com/BellAppLab/BackgroundRealm).
                   DESC

  s.homepage            = "https://github.com/BellAppLab/BLBackgroundRealm"

  s.license             = { :type => "MIT", :file => "LICENSE" }

  s.author              = { "Bell App Lab" => "apps@bellapplab.com" }
  s.social_media_url    = "https://twitter.com/BellAppLab"

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "10.0"
  s.watchos.deployment_target = "3.0"

  s.module_name         = 'BLBackgroundRealm'
  s.header_dir          = 'Headers'

  s.source              = { :git => "https://github.com/BellAppLab/BLBackgroundRealm.git", :tag => "#{s.version}" }

  s.source_files        = "BLBackgroundRealm", "Headers"

  s.framework           = "Foundation"
  s.dependency          'Realm', '~> 3.0'

end
