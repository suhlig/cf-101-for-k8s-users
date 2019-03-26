require 'git_dirty/file_task'

module GitDirty
  #
  # This is the DSL method to use in a Rakefile, e.g.
  #
  # <code>
  # require 'git_dirty'
  # git_dirty_file '/tmp/git-dirty-status'
  # </code>
  #
  def git_dirty_file(*args, &block)
    GitDirtyFileTask.define_task(*args, &block)
  end
end

# Make the DSL globally available
self.extend GitDirty
