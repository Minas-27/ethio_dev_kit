#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint amharic_stt.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'amharic_stt'
  s.version          = '0.1.0'
  s.summary          = 'On-device Amharic (am-ET) speech-to-text for Flutter.'
  s.description      = <<-DESC
A thin, typed Flutter wrapper over iOS SFSpeechRecognizer, fixed to the Amharic
(am-ET) locale. Does not bundle a recognition engine; availability depends on
the device/OS.
                       DESC
  s.homepage         = 'https://github.com/abroid-dev/ethio_dev_kit/tree/main/packages/amharic_stt'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Abraham' => 'abroid.dev@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # The plugin records audio (a required-reason API), so ship a privacy manifest.
  s.resource_bundles = {'amharic_stt_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
