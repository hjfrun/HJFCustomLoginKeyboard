Pod::Spec.new do |s|
    s.name         = "HJFCustomLoginKeyboard"
    s.version      = "0.0.1"
    s.summary      = "A Custom Keyboard Designed for Login Page."
    s.homepage     = "https://github.com/hjfrun/HJFCustomLoginKeyboard"
    s.license      = "MIT"
    s.author             = { "hjfrun" => "hale1007@qq.com" }
    s.platform     = :ios, "7.0"
    s.source       = { :git => "https://github.com/hjfrun/HJFCustomLoginKeyboard.git", :tag => s.version }
    s.source_files  = "HJFCustomLoginKeyboard/**/*.{h,m}"
    s.resources = "HJFCustomLoginKeyboard/*.{xib}", "HJFCustomLoginKeyboard/keyboard resources/*.{png,aiff}"
    s.requires_arc = true
end
