# Copyright (c) 2012, LessPainful <karl@lesspainful.com>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

Motion::Project::App.setup do |app|
 app.development do
   app.vendor_project File.join(File.dirname(__FILE__),"..",'..','framework'), :static
 end
end


namespace 'calabash' do
  desc "Run Calabash tests. Params are passed to cucumber"

  # Retrieve optional Calabash args.
  def gather_calabash_env
     sdk = ENV['sdk'] || ENV['SDK_VERSION'] || "6.0" #Calabash env vars
     os = ENV['os'] || ENV['OS'] || 'ios5' #Calabash env vars
     device = ENV['device'] || ENV['DEVICE'] || 'iphone' #Calabash env vars
     {:sdk => sdk, :os => os, :device => device, :str => "SDK_VERSION=#{sdk} OS=#{os} DEVICE=#{device}"}
  end


  task :run do
    # Retrieve optional args to pass to cucumber.
    args = ENV["args"] || ""

    calabash_env = gather_calabash_env

    # Retrieve optional bundle path.
    bundle_path = ENV['APP_BUNDLE_PATH']
    unless bundle_path
      build = "build/iPhoneSimulator-#{calabash_env[:sdk]}-Development"
      unless File.exist?(build)
        App.fail "No dir found in #{build}. Please build app first."
      end
      app = Dir.glob("#{build}/*").find {|d| /\.app$/.match(d)}
      unless File.exist?(app)
        App.fail "No .app found in #{build}. Please build app first."
      end
      bundle_path = File.expand_path("#{app}")
    end

    App.fail "No app found in #{bundle_path} (APP_BUNDLE_PATH)" unless File.exist?(bundle_path)

    cmd = "#{calabash_env[:str]} APP_BUNDLE_PATH=\"#{bundle_path}\" cucumber #{args}"
    App.info 'Run', cmd
    system(cmd)
  end

  desc "Start Calabash console."
  task :console do
    # Retrieve configuration settings.
    calabash_env = gather_calabash_env
    cmd = "#{calabash_env[:str]} calabash-ios console"
    App.info 'Run', cmd
    system(cmd)
  end

end

