platform :ios, '14.1'

target 'Snippets' do
	use_frameworks!
	
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
	
	# Encode/Decode
	pod 'DynamicJSON'
	
	# UIColor
	pod 'Hex'
	pod 'DynamicColor'
	
	# UI Parts
	pod 'Sourceful'
	pod 'TagListView'
	pod 'EmptyDataSet-Swift'
	
	# Resource Utilities
	pod 'R.swift'
	
	# Coding
	pod 'InstantiateStandard'
	
	# Search
	pod 'Fuse'
	
	# Functional
	pod 'Runes'
	pod 'Curry'
	pod 'CollectionKit-Swift', :git => 'git@github.com:GeneralD/CollectionKit.git'
	
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.4'
		end
		if target.name == 'SwiftPrelude'
			target.build_configurations.each do |config|
				config.build_settings['SWIFT_VERSION'] = '4.2'
			end
		end
	end
end
