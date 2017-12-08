require "./krbwrapper"

puts "Create buffer"
buffer = KrbWrapper::Buffer.new
spn = "HTTP/foo.com"
buffer.value = spn
buffer.length = spn.size
name_result = uninitialized KrbWrapper::NameStruct
oid_ptr = BswWrapper.bsw_gss_nt_user_name
puts "Calling func using #{oid_ptr}"
status = KrbWrapper.gss_import_name(out minor_status,
  pointerof(buffer),
  oid_ptr,
  pointerof(name_result))

puts "major status is #{status} minor status is #{minor_status}!"
