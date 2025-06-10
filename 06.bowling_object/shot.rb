# frozen_string_literal: true

class Shot
  attr_reader :pins # テスト用のattr_reader

  def initialize(pin_count)
    @pins = pin_count == 'X' ? 10 : pin_count.to_i
  end
end
