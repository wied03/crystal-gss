require "./gssapi/gssapi"

def get_name(upn)
  buffer = GssApi::GssLib::Buffer.new
  buffer.value = upn
  buffer.length = upn.size
  invoker = GssApi::ReturnFunctionInvoker(GssApi::GssLib::NameStruct).new("gss_import_name")
  invoker.invoke do |minor_pointer|
    status = GssApi::GssLib.gss_import_name(minor_pointer,
                                            pointerof(buffer),
                                            GssApi::GssExternVariableFetcher.gss_nt_user_name,
                                            out target_name)
    {status, target_name}
  end
end

def acquire_credential(password, target_name)
  buffer = GssApi::GssLib::Buffer.new
  buffer.value = password
  buffer.length = password.size
  minor_status = uninitialized UInt32
  minor_pointer = pointerof(minor_status)

  desired_mechanisms = GssApi::GssLib::OidSet.new
  desired_mechanisms.count = 1
  desired_mechanisms.elements = GssApi::GssExternVariableFetcher.gss_krb5_mechanism
  puts "Calling gss_acquire_cred_with_password"
  invoker = GssApi::ReturnFunctionInvoker(GssApi::GssLib::CredentialStruct).new("gss_acquire_cred_with_password")
  invoker.invoke do |minor_pointer|
      status = GssApi::GssLib.gss_acquire_cred_with_password(minor_pointer,
                                                         target_name,
                                                         pointerof(buffer),
                                                         0, # default time of 0
                                                         pointerof(desired_mechanisms),
                                                         GssApi::GssLib::GSS_C_INITIATE,
                                                         out credential,
                                                         nil,
                                                         nil)
      {status, credential}
  end
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
      invoker = GssApi::VoidFunctionInvoker.new("gss_release_cred")
      invoker.invoke do |minor_pointer|
        GssApi::GssLib.gss_release_cred(minor_pointer,
                                        pointerof(credential))
      end
    end
  ensure
    puts "Releasing name"
    invoker = GssApi::VoidFunctionInvoker.new("gss_release_name")
    invoker.invoke do |minor_pointer|
      GssApi::GssLib.gss_release_name(minor_pointer,
                                      target_name_pointer)
    end
  end
end

do_stuff()
