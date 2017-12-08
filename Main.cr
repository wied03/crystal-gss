require "./krbwrapper"

puts "Create buffer"
buffer = KrbWrapper::Buffer.new
spn = "HTTP/foo.com"
buffer.buffer = spn
buffer.length = spn.size
name_result = uninitialized KrbWrapper::NameStruct

puts "Calling func"
status = KrbWrapper.gss_import_name(out minor_status,
  pointerof(buffer),
  KrbWrapper.gss_c_nt_user_name,
  pointerof(name_result))

puts "major status is #{status} minor status is #{minor_status}!"
