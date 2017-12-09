module GssApi
  class GssCredential
    @structure : GssApi::GssLib::CredentialStruct

    def initialize(name : GssName,
                   password : String,
                   usage_flags : GssApi::GssLib::GssCredentialUsageFlags,
                   desired_mechanism : GssApi::GssLib::GssMechanism)
      @closed = false
      buffer = GssApi::GssLib::Buffer.new
      buffer.value = password
      buffer.length = password.size

      desired_mechs = GssApi::GssLib::OidSet.new
      desired_mechs.count = 1
      desired_mechs.elements = desired_mechanism
      puts "Calling gss_acquire_cred_with_password"
      invoker = GssApi::FunctionInvoker(GssApi::GssLib::CredentialStruct).new("gss_acquire_cred_with_password")
      @structure = invoker.invoke do |minor_pointer|
        status = GssApi::GssLib.gss_acquire_cred_with_password(minor_pointer,
                                                               name.structure,
                                                               pointerof(buffer),
                                                               0, # default time of 0
                                                               pointerof(desired_mechs),
                                                               usage_flags,
                                                               out credential,
                                                               nil,
                                                               nil)
        {status, credential}
      end
    end

    def finalize
      return if @closed
      @closed = true
      puts "Cleaning up credential"
      begin
        invoker = GssApi::VoidFunctionInvoker.new("gss_release_cred")
        invoker.invoke do |minor_pointer|
          GssApi::GssLib.gss_release_cred(minor_pointer,
                                          pointerof(@structure))
        end
      rescue
        nil
      end
    end
  end
end
