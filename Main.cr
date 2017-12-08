require "./krbwrapper"

# TODO: Can this be moved into the lib wrapper??
def handle_status(function,
                  major_status,
                  minor_status)
  return if major_status == 0
  minor_status_for_disp_status = uninitialized UInt32
  minor_status_for_disp_status_ptr = pointerof(minor_status_for_disp_status)
  mech_oid = uninitialized KrbWrapper::Oid
  message_context = UInt32.new(0)
  buffer = KrbWrapper::Buffer.new
  problems = [] of String
  # TODO: Need to check minor status with 2 instead of 1 for the type
  while 1
    major_status = KrbWrapper.gss_display_status(minor_status_for_disp_status_ptr,
                                                 major_status,
                                                 1,
                                                 pointerof(mech_oid),
                                                 pointerof(message_context),
                                                 pointerof(buffer))
    raise "Unable to even get error status!" unless major_status == 0
    problems << "While calling #{function}, #{buffer.value}"
    KrbWrapper.gss_release_buffer(minor_status_for_disp_status_ptr, pointerof(buffer)) if buffer.length != 0
    break if message_context == 0
  end
  raise "Errors: #{problems}"
end

def get_name()
  buffer = KrbWrapper::Buffer.new
  spn = "mule@FOO.COM"
  buffer.value = spn
  buffer.length = spn.size
  minor_status = uninitialized UInt32
  minor_pointer = pointerof(minor_status)
  status = KrbWrapper.gss_import_name(minor_pointer,
                                      pointerof(buffer),
                                      BswWrapper.bsw_gss_nt_user_name,
                                      out target_name)
  handle_status("gss_import_name", status, minor_status)
  target_name
end

def acquire_credential(password, target_name)
  buffer = KrbWrapper::Buffer.new
  buffer.value = password
  buffer.length = password.size
  minor_status = uninitialized UInt32
  minor_pointer = pointerof(minor_status)

  desired_mechanisms = KrbWrapper::OidSet.new
  desired_mechanisms.count = 1
  desired_mechanisms.elements = BswWrapper.bsw_gss_krb5_mechanism
  puts "Calling gss_acquire_cred_with_password"
  status = KrbWrapper.gss_acquire_cred_with_password(minor_pointer,
                                                     target_name,
                                                     pointerof(buffer),
                                                     0, # default time of 0
                                                     pointerof(desired_mechanisms),
                                                     KrbWrapper::GSS_INITIATE,
                                                     out credential,
                                                     nil,
                                                     nil)
  handle_status("gss_acquire_cred_with_password", status, minor_status)
  credential
end

def do_stuff
  target_name = get_name
  target_name_pointer = pointerof(target_name)
  minor_status = uninitialized UInt32
  minor_pointer = pointerof(minor_status)
  begin
    puts "Name created, now getting credential"
    credential = acquire_credential("thePassword", target_name)
    begin
      puts "Got credential OK!"
    ensure
      puts "Releasing credential"
      status = KrbWrapper.gss_release_cred(minor_pointer,
                                           pointerof(credential))
      handle_status("gss_release_cred", status, minor_status)
    end
  ensure
    puts "Releasing name"
    status = KrbWrapper.gss_release_name(minor_pointer,
                                         target_name_pointer)
    handle_status("gss_release_name", status, minor_status)
  end
end

do_stuff()
