require "./krbwrapper"

buffer = KrbWrapper::Buffer.new
spn = "mule@FOO.COM"
buffer.value = spn
buffer.length = spn.size
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
  pw = "thePassword"
  buffer.value = pw
  buffer.length = pw.size

  desired_mechanisms = KrbWrapper::OidSet.new
  desired_mechanisms.count = 1
  desired_mechanisms.elements = BswWrapper.bsw_gss_krb5_mechanism
  status = KrbWrapper.gss_acquire_cred_with_password(minor_pointer,
                                                     target_name_pointer,
                                                     pointerof(buffer),
                                                     0, # default time of 0
                                                     pointerof(desired_mechanisms),
                                                     KrbWrapper::GSS_INITIATE,
                                                     out credential,
                                                     nil,
                                                     nil)
  raise "Problem acquiring credentials!" unless status == 0
  credential_pointer = pointerof(credential)
  begin
    puts "Would go do other things"
  ensure
    KrbWrapper.gss_release_cred(minor_pointer, credential_pointer)
  end
ensure
  KrbWrapper.gss_release_name(minor_pointer,
                              target_name_pointer)
end
