require "./krbwrapper"

buffer = KrbWrapper::Buffer.new
spn = "mule@FOO.COM"
buffer.value = spn
buffer.length = spn.size + 1
minor_status = uninitialized Int32
minor_pointer = pointerof(minor_status)

status = KrbWrapper.gss_import_name(minor_pointer,
                                    pointerof(buffer),
                                    BswWrapper.bsw_gss_nt_user_name,
                                    out target_name)
target_name_pointer = pointerof(target_name)

raise "Problem!" unless status == 0
begin
  puts "Name created"
  # status = KrbWrapper.gss_acquire_cred_with_password(minor_pointer,
  #                                                    name_pointer)
ensure
  KrbWrapper.gss_release_name(minor_pointer,
                              target_name_pointer)
end
