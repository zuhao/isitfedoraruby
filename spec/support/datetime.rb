class RandomDate
  # Construct a random datetime in the format of: "2009-11-01 10:08:42"
  def self.date
    DateTime.civil(rand(2008...2014),
                   rand(1...12), rand(1...30), rand(0...23),
                   rand(0...59), rand(0...59))
  end
end
