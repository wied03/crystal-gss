module GssApi
  class GssCredential
    @structure : GssApi::GssLib::CredentialStruct
    getter structure

    def initialize(name : GssName,
                   usage_flags : GssApi::GssLib::GssCredentialUsageFlags)
      @closed = false

      desired_mechs = GssApi::GssLib::OidSet.new
      desired_mechs.count = 0
      desired_mechs.elements = nil
      @structure = GssApi::Functions.gss_acquire_cred(name.structure,
                                                      0, # default time of 0
                                                      pointerof(desired_mechs),
                                                      usage_flags,
                                                      nil,
                                                      nil)
    end

    def finalize
      return if @closed
      @closed = true
      puts "Cleaning up credential"
      begin
        GssApi::Functions.gss_release_cred pointerof(@structure)
      rescue
        nil
      end
    end
  end
end
