require "./krbwrapper"

puts "Create buffer"
buffer = KrbWrapper::Buffer.new
spn = "mule@FOO.COM"
buffer.value = spn
buffer.length = spn.size + 1
name_result = uninitialized KrbWrapper::NameStruct
status = KrbWrapper.gss_import_name(out minor_status,
  pointerof(buffer),
  BswWrapper.bsw_gss_nt_user_name,
  pointerof(name_result))

puts "major status is #{status} minor status is #{minor_status}!"
