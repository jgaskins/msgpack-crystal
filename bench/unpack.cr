require "../src/msgpack"

def test_unpack(name, count, klass, data)
  slice = data.to_msgpack
  t = Time.now
  print name
  res = 0
  count.times do |i|
    obj = klass.from_msgpack(slice)
    res += obj.size
  end
  puts " = #{res}, #{Time.now - t}"
end

t = Time.now

test_unpack("small string", 1000000, String, "a" * 200)
test_unpack("big string", 10000, String, "a" * 200000)
test_unpack("hash string string", 10000, Hash(String, String), (0..1000).reduce({} of String => String) { |h, i| h["key#{i}"] = "value#{i}"; h })
test_unpack("hash string float64", 10000, Hash(String, Float64), (0..1000).reduce({} of String => Float64) { |h, i| h["key#{i}"] = i / 10.0.to_f64; h })
test_unpack("array of strings", 10000, Array(String), Array.new(1000) { |i| "data#{i}" })
test_unpack("array of floats", 20000, Array(Float64), Array.new(3000) { |i| i / 10.0 })
test_unpack("array of mix int sizes", 20000, Array(Int64), Array.new(3000) { |i| { 0xFF, 0xFFFF, 0xFFFFFFFF }[i % 3] })

puts "Summary time: #{Time.now - t}"
