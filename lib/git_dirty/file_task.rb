require 'rake/file_task'

#
# Records the git status in a separate file, which can then be included
# e.g. as part of a file-based build process.
#
module GitDirty
  class FileTask < Rake::FileTask
    include Rake::DSL

    def initialize(name, *args)
      super
      desc "Write git status to #{name} (should be git-ignored)"
    end

    def needed?
      (actual_state != persisted_state).tap do |needed|
        if application.options.trace
          if needed
            application.trace "*** #{name} IS needed"
          else
            application.trace "*** #{name} is NOT needed"
          end
        end
      end
    end

    def execute(args=nil)
      if application.options.trace
        application.trace "*** Writing actual state '#{actual_state}' to #{name}"
      end

      File.write(name, actual_state)
    end

    private

    def actual_state
      if clean?
        rev
      else
        "#{rev}*"
      end
    end

    def persisted_state
      return nil unless File.exist?(name)
      File.read(name).chomp
    end

    def clean?
      `git status --porcelain`.chomp.empty?
    end

    def rev
      `git rev-parse --short HEAD`.chomp
    end
  end
end
