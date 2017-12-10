require "./gssapi/gssapi"

def do_stuff
  #puts "spnego item is #{GssApi::GssMechanism::SPNEGO}"

  # TODO: test without a name/password (rely on ticket cache instead)
  upn_name = GssApi::GssName.new("brady@FOO.COM",
                                 GssApi::GssMechanism::NT_USER_NAME)
  puts "Name #{upn_name} created, now getting credential"
  # credential = GssApi::GssCredential.new(upn_name,
  #                                        "7jhN5KCqDZnKG3q",
  #                                        GssApi::GssLib::GssCredentialUsageFlags::Initiate)
  #puts "Got credential OK!"
  target_name = GssApi::GssName.new("ldap@kdc.foo.com",
                                    GssApi::GssMechanism::NT_HOST_BASED_SERVICE)

  target_name = target_name.canonicalize(GssApi::GssMechanism::SPNEGO)

  puts "canonical done (#{target_name}) init context"

  # invoker = GssApi::VoidFunctionInvoker.new("gss_init_sec_context")
  # output_buffer = GssApi::GssLib::Buffer.new
  # invoker.invoke do |minor_pointer|
  #   # TODO: Own class, flags, etc.
  #   dummy_input_buffer = uninitialized GssApi::GssLib::Buffer
  #   stat = GssApi::GssLib.gss_init_sec_context(minor_pointer,
  #                                              credential.structure,
  #                                              out context,
  #                                              target_name.structure,
  #                                              GssApi::GssMechanism::SPNEGO.underlying,
  #                                              2, # mutual auth
  #                                              0, # default lifetime
  #                                              nil,
  #                                              pointerof(dummy_input_buffer),
  #                                              out actual_mechanism,
  #                                              pointerof(output_buffer),
  #                                              out actual_flags,
  #                                              out actual_time)
  #   stat
  # end
  # puts "token size #{output_buffer.length}"
end

do_stuff()
