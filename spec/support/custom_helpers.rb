# frozen_string_literal: true

# put all of your helpers for test here
# or you may consider make new module
module CustomHelpers
  def setup_header(**keyword_args)
    keyword_args.each do |key, val|
      header key.to_s.upcase, val
    end
  end
end
