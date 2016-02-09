# Uncomment this line to define a global platform for your project
platform :ios, '7.0'

# ignore all warnings from all pods
inhibit_all_warnings!

def shared_pods
    pod 'Parse', '~> 1.8.1'
    pod 'SVProgressHUD', '~> 1.1.3'
    pod 'UICKeyChainStore'
end

target 'VideoBroadcast' do
    shared_pods
    pod 'OpenTok'
end
