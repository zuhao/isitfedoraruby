# Taken from
# https://github.com/gitlabhq/gitlabhq/blob/master/lib/tasks/gitlab/task_helpers.rake
#

module IsItFedoraRuby
  class TaskAbortedByUserError < StandardError; end
end

namespace :fedora do

  # Ask if the user wants to continue
  #
  # Returns "yes" the user chose to continue
  # Raises Gitlab::TaskAbortedByUserError if the user chose *not* to continue
  def ask_to_continue
    answer = prompt("Do you want to continue (yes/no)? ", %w{yes no})
    raise IsItFedoraRuby::TaskAbortedByUserError unless answer == "yes"
  end

  # Prompt the user to input something
  #
  # message - the message to display before input
  # choices - array of strings of acceptable answers or nil for any answer
  #
  # Returns the user's answer
  def prompt(message, choices = nil)
    begin
      print(message)
      answer = STDIN.gets.chomp
    end while choices.present? && !choices.include?(answer)
    answer
  end
end
