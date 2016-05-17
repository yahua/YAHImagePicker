#
#  Be sure to run `pod spec lint voice.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "YAHImagePicker"
  s.version      = "0.0.1"
  s.summary      = "照片选择器"

  s.description  = <<-DESC
                   自定义照片选择器，支持照片和视频
                   DESC

  s.homepage     = "https://github.com/yahua/YAHImagePicker"
  

  s.license      = "MIT"
  

  s.author             = { "yahua" => "yahua523@163.com" }

  s.platform     = :ios, "7.0"

  s.requires_arc = true

  s.source       = { :git => "https://github.com/yahua/YAHImagePicker.git", :tag => "#{s.version}" }

  #s.source_files  = "YAHImagePicker/**/*.*"

  s.dependency 'KVOController'

  s.subspec 'controller' do |ss|

    ss.dependency 'YAHImagePicker/logic'
    ss.dependency 'YAHImagePicker/view'
    #ss.public_header_files = 'YHCommon/extobjc/*.h'
    ss.source_files = 'YAHImagePicker/controller'
  end

  s.subspec 'logic' do |ss|

    #ss.public_header_files = 'YHCommon/extobjc/*.h'
    ss.source_files = 'YAHImagePicker/logic'
  end

  s.subspec 'other' do |ss|

    #ss.public_header_files = 'YHCommon/extobjc/*.h'
    ss.source_files = 'YAHImagePicker/other'
  end

  s.subspec 'resource' do |ss|

    #ss.public_header_files = 'YHCommon/extobjc/*.h'
    ss.source_files = 'YAHImagePicker/resource/*.*'
  end

  s.subspec 'view' do |ss|

    ss.dependency 'YAHImagePicker/other'
    ss.dependency 'YAHImagePicker/logic'
    #ss.public_header_files = 'YHCommon/extobjc/*.h'
    ss.source_files = 'YAHImagePicker/view'
  end


end
