require "./krbwrapper"

buffer = KrbWrapper::Buffer.new
spn = "mule@FOO.COM"
buffer.value = spn
buffer.length = spn.size + 1
name_result = uninitialized KrbWrapper::NameStruct
minor_status = uninitialized Int32
status = KrbWrapper.gss_import_name(pointerof(minor_status),
                                    pointerof(buffer),
                                    BswWrapper.bsw_gss_nt_user_name,
                                    pointerof(name_result))

raise "Problem!" unless status == 0
begin
  puts "Name created"
ensure
  puts "Releasing name..."
  KrbWrapper.gss_release_name(pointerof(minor_status),
                              pointerof(name_result))
end
