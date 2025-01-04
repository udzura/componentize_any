def to_uleb128_bin(size)
  if size < 0x80
    [size].pack("C")
  else
    [(size & 0x7f) | 0x80].pack("C") + to_uleb128_bin(size >> 7)
  end  
end

b1 = IO.read ARGV[0], encoding: "BINARY"
idx = b1.index("\x01\x08\x00\x61\x73\x6d\x01\x00\x00\x00")
raise "not a component wasm file" if idx.nil?

b2 = IO.read ARGV[1], encoding: "BINARY"
size = b2.size
data = to_uleb128_bin(size)

buf = ""
buf << b1[0...idx]
buf << "\01" << data
buf << b2
buf << b1[idx...b1.size]

IO.write "combo.wasm", buf
puts "created combo.wasm"
puts "run: `wasm-tools dump combo.wasm 2>&1 | less`"