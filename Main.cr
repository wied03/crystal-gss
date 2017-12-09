require "./gssapi/gssapi"

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
  invoker = GssApi::FunctionInvoker(GssApi::GssLib::CredentialStruct).new("gss_acquire_cred_with_password")
  invoker.invoke do |minor_pointer|
      status = GssApi::GssLib.gss_acquire_cred_with_password(minor_pointer,
                                                         target_name.structure,
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
  target_name = GssApi::GssName.new("someone@FOO.COM",
                                    GssApi::GssExternVariableFetcher.gss_nt_user_name)
  begin
    puts "Name created, now getting credential"
    #credential = acquire_credential("thePassword", target_name)
    puts "Got credential OK!"
  end
end

do_stuff()
