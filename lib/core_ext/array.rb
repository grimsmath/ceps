class Array
  def drop_last
    self[0...-1]
  end

  def mean
    self.sum / self.size
  end
end