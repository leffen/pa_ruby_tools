require 'gem_release'


module PaRubyTools

  class DoGemRelease
    attr_reader :dry_run, :version, :host

    CHANGE_LOG_FILES = %w(CHANGELOG.md Changelog.md Changes.md)

    def initialize(host, version = nil, dry_run=false)
      @version = version || next_version
      @host = host
      @dry_run = dry_run
    end

    def git_is_clean?
      !do_command(check_git_status_cmd)
    end

    def has_gem_credentials?
      File.exists?(File.expand_path('~/.gem/credentials'))
    end

    def has_valid_changelog?
      CHANGE_LOG_FILES.each do |file|
        if File.exist?(file)
          return true if File.read(file).match(/^## #{@version} \(/)
        end
      end
      false
    end

    def do_bump_version
      do_command(bump_cmd)
    end

    def is_tests_green?
      do_command(test_cmd)
    end

    def next_version
      GemRelease::VersionFile.new(target: version).new_number
    end

    def do_gem_release
      puts "Doing gem release of version: #{@version} "

      puts "Checking git ...."
      return false unless git_is_clean?

      puts "Checking gem credentials ...."
      return false unless has_gem_credentials?

      puts "Checking that changelog mentions the version #{@version}"
      return false unless has_valid_changelog?

      puts "Executing test and deploy command "
      "#{test_cmd} && #{bump_cmd}"
      return false unless has_valid_changelog?

      # Yay we made it all the way
      true
    end

    private

    def check_git_status_cmd
      'test -n "$(git status --porcelain)"'
    end

    def test_cmd
      "bundle exec rspec"
    end

    def bump_cmd
      "gem bump -v #{@version} --release --tag --host #{@host}"
    end

    def do_command(cmd)
      if dry_run
        puts cmd
      else
        system(cmd)
      end
    end


  end
end