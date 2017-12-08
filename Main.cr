require "./krbwrapper"

puts "Create buffer"
buffer = KrbWrapper::Buffer.new
spn = "HTTP/foo.com"
buffer.value = spn
buffer.length = spn.size
name_result = uninitialized KrbWrapper::NameStruct

puts "Calling func"
status = KrbWrapper.gss_import_name(out minor_status,
  pointerof(buffer),
  pointerof(KrbWrapper.gss_c_nt_user_name), # we need a pointer to the singleton but this doesn't work in crystal
  pointerof(name_result))

puts "major status is #{status} minor status is #{minor_status}!"
