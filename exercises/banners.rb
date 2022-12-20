#PROCESS
# CUTOFF
# input a string and a integer length
# output: a slice of string from the beginning to the given integer
#
# WORDWRAP
# input a string and an integer length
# output: a string with newlines that make it fit the integer width
#
# given a string
# given an integer
#
# break the string into slices
#   create variables start = 0 and end = banner_width - 1
#   until the start variable is greater than or equal to the length of the string
#   put a slice of the string from start to end indexes in an array
#   increment start and end by banner_width
#
#   join the array elements together with \n

class Banner

  def initialize(message, banner_width = false, banner_style = "dynamic")
    if banner_width
      if banner_style == "cutoff" || banner_style == "dynamic"
        @message = cut_off(message, banner_width)
      elsif banner_style == "wordwrap"
        @message = word_wrap(message, banner_width)
      end
      @banner_width = banner_width + 2
    else
      @banner_width = message.length + 2
      @message = message
    end
  end

  def to_s
    [horizontal_rule, empty_line, message_line(@message), empty_line, horizontal_rule].join("\n")
  end

  private

  def word_wrap(message, banner_width)
    start_index = 0
    end_index = banner_width - 1
    wrapped_strings = []

    until start_index >= message.length
      wrapped_strings << message[start_index..end_index]
      start_index += banner_width
      end_index += banner_width
    end

    wrapped_strings
  end


  def cut_off(message, banner_width)
    message[0..banner_width - 1]
  end

  def horizontal_rule
    "+#{'-' * @banner_width}+"
  end

  def empty_line
    "|#{' ' * @banner_width}|"
  end

  def message_line(message)
    if message.class == Array
      message.map! do |line|
        "|#{line.center(@banner_width)}|"
      end

      message.join("\n")
    else
      "|#{message.center(@banner_width)}|"
    end
  end
end

banner = Banner.new('To boldly go where no one has gone before.', 20)
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

banner = Banner.new('To boldly go where no one has gone before.', 10, 'wordwrap')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+
#
banner = Banner.new('To boldly go where no one has gone before.')
puts banner
