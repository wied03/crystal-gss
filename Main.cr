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

  invoker = GssApi::VoidFunctionInvoker.new("gss_init_sec_context")
  output_buffer = GssApi::GssLib::Buffer.new
  invoker.invoke do |minor_pointer|
    # TODO: Own class, flags, etc.
    no_context = nil.as(GssApi::GssLib::ContextStruct)
    dummy_input_buffer = uninitialized GssApi::GssLib::Buffer
    stat = GssApi::GssLib.gss_init_sec_context(minor_pointer,
                                               nil, #credential.structure,
                                               pointerof(no_context),
                                               target_name.structure,
                                               GssApi::GssMechanism::SPNEGO.underlying,
                                               2 | 8 | 16 | 32, # mutual+sequence+conf+integ
                                               0, # default lifetime
                                               nil,
                                               pointerof(dummy_input_buffer),
                                               out actual_mechanism,
                                               pointerof(output_buffer),
                                               out actual_flags,
                                               out actual_time)
    # Not sure why we;re getting continue needed, happens even without 2
    stat = UInt32.new(0) if stat == GssApi::GssExternVariableFetcher::GSS_S_CONTINUE_NEEDED
    stat
  end
  puts "token size #{output_buffer.length}"
end

do_stuff()
