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
      puts "Doing gem release of version: #{@version} to host=#{@host}"

      puts "Checking git ...."
      return message("Please ensure that all is committed to git before releasing") unless git_is_clean?

      puts "Checking gem credentials ...."
      return message("To deploy a gem you must have gem credentials") unless has_gem_credentials?

      puts "Checking that changelog mentions the version #{@version}"
      return message("Recommended practice for releasing gems is to have a changelog file with the latest changes") unless has_valid_changelog?

      puts "Executing test and deploy command "
      return message("Ups could not perform test and deploy command... Please check your test output") unless do_command("#{test_cmd} && #{bump_cmd}")

      # Yay we made it all the way
      puts "Successfull release "
      true
    end

    private

    def message(msg)
      puts msg
      false
    end

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