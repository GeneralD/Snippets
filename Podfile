platform :ios, '14.1'

target 'Snippets' do
	use_frameworks!
	inhibit_all_warnings!
	
	# Reactive
	pod 'RxSwift', '~> 6'
	pod 'RxCocoa'
	pod 'RxBinding'
	pod 'RxOptional'
	pod 'RxAnimated'
	pod 'RxGRDB'
	pod 'RxCells'
	pod 'RxViewController'
	pod 'RxDocumentPicker'
	pod 'RxSwiftExt'
	
	# UI Parts
	pod 'Sourceful'
	pod 'TagListView'
	pod 'EmptyDataSet-Swift'
	
	# Resource Utilities
	pod 'R.swift.Library'
	
	# Coding
	pod 'InstantiateStandard'
	
	# Search
	pod 'Fuse'
	
	# Functional
	pod 'Runes'
	pod 'Curry'
	pod 'CollectionKit-Swift', :git => 'git@github.com:GeneralD/CollectionKit.git'
end

target 'DashSourceful' do
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'Sourceful'
	pod 'R.swift.Library'
end

target 'Entity' do
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'GRDB.swift'
end

target 'LanguageThemeColor' do
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'DynamicColor'
	pod 'DynamicJSON'
	pod 'Hex'
	pod 'R.swift.Library'
end

target 'RxPropertyChaining' do
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'RxSwift', '~> 6'
end

target 'RxPropertyWrapper' do
	use_frameworks!
	inhibit_all_warnings!
	
	pod 'RxSwift', '~> 6'
	pod 'RxRelay'
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.4'
		end
	end
end
