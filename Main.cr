require "./gssapi/gssapi"

def do_stuff
  # TODO: This works on Linux but crashes the Mac
  #puts "spnego item is #{GssApi::GssMechanism::SPNEGO}"
  upn_name = GssApi::GssName.new("brady@FOO.COM",
                                 GssApi::GssMechanism::NT_USER_NAME)
  puts "Name #{upn_name} created"
  target_name = GssApi::GssName.new("ldap@kdc.foo.com",
                                    GssApi::GssMechanism::NT_HOST_BASED_SERVICE)

  target_name = target_name.canonicalize(GssApi::GssMechanism::SPNEGO)

  puts "canonical done (#{target_name}) init context"

  invoker = GssApi::VoidFunctionInvoker.new("gss_init_sec_context")
  output_buffer = GssApi::GssLib::Buffer.new
  context = nil.as(GssApi::GssLib::ContextStruct)
  puts "Context currently is #{context}"
  invoker.invoke do |minor_pointer|
    # TODO: Move context to its own class, handle flags, etc.
    dummy_input_buffer = uninitialized GssApi::GssLib::Buffer
    stat = GssApi::GssLib.gss_init_sec_context(minor_pointer,
                                               nil, #credential.structure,
                                               pointerof(context),
                                               target_name.structure,
                                               GssApi::GssMechanism::SPNEGO.underlying,
                                               # If we request mutual auth/2, we can't get names with gss_inquire_context
                                               8 | 16 | 32, # mutual+sequence+conf+integ
                                               0, # default lifetime
                                               nil,
                                               pointerof(dummy_input_buffer),
                                               out actual_mechanism,
                                               pointerof(output_buffer),
                                               out actual_flags,
                                               out actual_time)
    puts "we got status #{stat} time #{actual_time} flags #{actual_flags}"
    # Not sure why we;re getting continue needed, happens even without 2
    # GSS_S_CONTINUE_NEEDED is actually what 1 is, need to do a bitwise and
    # https://tools.ietf.org/html/rfc2744.html talks about how this works
    stat = UInt32.new(0) if stat == 1
    stat
  end
  puts "Context now is #{context}"
  puts "token size #{output_buffer.length}"
  slice = output_buffer.value.to_slice(output_buffer.length)
  puts "token is #{slice.hexdump}"
  # TODO: gss_delete_sec_context
  invoker = GssApi::VoidFunctionInvoker.new("gss_inquire_context")
  source_name = uninitialized GssApi::GssLib::NameStruct
  established_targ_name = uninitialized GssApi::GssLib::NameStruct
  invoker.invoke do |minor_pointer|
    # TODO: These names all need to be released/managed
    stat = GssApi::GssLib.gss_inquire_context(minor_pointer,
                                       context,
                                       pointerof(source_name),
                                       pointerof(established_targ_name),
                                       out lifetime,
                                       out mechanism,
                                       out flags,
                                       out local_init,
                                       out open)
    puts "inquire stat #{stat} open #{open} local_init #{local_init}"
    stat
  end
  puts "the name is #{established_targ_name}"
  instance = GssApi::GssName.allocate
  instance.copy(established_targ_name)
  puts "established_targ_name is #{instance}"
  puts "source_name name is #{source_name}"
  instance = GssApi::GssName.allocate
  instance.copy(source_name)
  puts "source_name is #{instance}"
end

do_stuff()
