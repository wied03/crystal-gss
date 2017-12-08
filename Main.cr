require "./gsslib"

# TODO: Can/should this be moved into the lib wrapper??
def handle_status(function,
                  major_status,
                  minor_status)
  return if major_status == 0
  minor_status_for_disp_status = uninitialized UInt32
  minor_status_for_disp_status_ptr = pointerof(minor_status_for_disp_status)
  mech_oid = uninitialized GssLib::Oid
  buffer = GssLib::Buffer.new
  buffer_pointer = pointerof(buffer)
  problems = [] of String
  capture_issues = ->(status_type: Int32,
                      status_desc: String,
                      code: UInt32) do
    message_context = UInt32.new(-1)
    while message_context != 0
      major_status = GssLib.gss_display_status(minor_status_for_disp_status_ptr,
                                               code,
                                               status_type,
                                               pointerof(mech_oid),
                                               pointerof(message_context),
                                               buffer_pointer)
      raise "Unable to even get error status!" unless major_status == 0
      # Value is a raw C string/char* pointer, need to get it into a Crystal string
      error_message = String.new(buffer.value)
      problems << "#{status_desc} error code: #{code} - details: #{error_message}"
      # Our Crystal string is copied from buffer, so still need to free this
      GssLib.gss_release_buffer(minor_status_for_disp_status_ptr,
                                buffer_pointer) if buffer.length != 0
    end
  end
  capture_issues.call(1, "Major", major_status)
  capture_issues.call(2, "Minor", minor_status)
  raise "While calling #{function}, encountered the following errors: #{problems}"
end

def get_name(upn)
  buffer = GssLib::Buffer.new
  buffer.value = upn
  buffer.length = upn.size
  minor_status = uninitialized UInt32
  minor_pointer = pointerof(minor_status)
  # TODO: Can Crystal do currying and improve how we call this stuff?
  status = GssLib.gss_import_name(minor_pointer,
                                  pointerof(buffer),
                                  GssExternVariableFetcher.gss_nt_user_name,
                                  out target_name)
  handle_status("gss_import_name", status, minor_status)
  target_name
end

def acquire_credential(password, target_name)
  buffer = GssLib::Buffer.new
  buffer.value = password
  buffer.length = password.size
  minor_status = uninitialized UInt32
  minor_pointer = pointerof(minor_status)

  desired_mechanisms = GssLib::OidSet.new
  desired_mechanisms.count = 1
  desired_mechanisms.elements = GssExternVariableFetcher.gss_krb5_mechanism
  puts "Calling gss_acquire_cred_with_password"
  status = GssLib.gss_acquire_cred_with_password(minor_pointer,
                                                 target_name,
                                                 pointerof(buffer),
                                                 0, # default time of 0
                                                 pointerof(desired_mechanisms),
                                                 GssLib::GSS_C_INITIATE,
                                                 out credential,
                                                 nil,
                                                 nil)
  handle_status("gss_acquire_cred_with_password", status, minor_status)
  credential
end

def do_stuff
  target_name = get_name("someone@FOO.COM")
  # TODO: Can we wrap this and have some type of finalizer/disposer?
  target_name_pointer = pointerof(target_name)
  minor_status = uninitialized UInt32
  minor_pointer = pointerof(minor_status)
  begin
    puts "Name created, now getting credential"
    credential = acquire_credential("thePassword", target_name)
    begin
      puts "Got credential OK!"
      # TODO: Create context, get token, etc.
    ensure
      puts "Releasing credential"
      status = GssLib.gss_release_cred(minor_pointer,
                                       pointerof(credential))
      handle_status("gss_release_cred", status, minor_status)
    end
  ensure
    puts "Releasing name"
    status = GssLib.gss_release_name(minor_pointer,
                                     target_name_pointer)
    handle_status("gss_release_name", status, minor_status)
  end
end

do_stuff()
