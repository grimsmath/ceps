class Integer
  def to_b?
    self.zero?
  end

  def to_constraint
    if self.zero?
      return 'AND'
    else
      return 'OR'
    end
  end
end