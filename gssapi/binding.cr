module GssApi
  @[Link("heimdal-gssapi")]
  lib GssLib
    struct Buffer
      length : LibC::SizeT
      value : UInt8*
    end

    struct Oid
      length : UInt32
      elements : Void*
    end

    struct OidSet
      count : LibC::SizeT
      elements : Oid*
    end

    type NameStruct = Void*
    alias Status = UInt32
    alias MajorStatus = Status
    alias StatusPtr = Status*
    type CredentialStruct = Void*

    enum GssCredentialUsageFlags
      Both # 0
      Initiate # 1
      Accept # 2
    end

    # https://github.com/crystal-lang/crystal/issues/4845
    # $gss_c_nt_user_name = __gss_c_nt_user_name_oid_desc : Oid

    # output_name is a pointer of a pointer
    fun gss_import_name(minor_status_ptr : StatusPtr,
                        buffer : Buffer*,
                        oid : Oid*,
                        output_name : NameStruct*) : MajorStatus

    fun gss_release_buffer(minor_status_ptr : StatusPtr,
                           buffer : Buffer*) : MajorStatus

    fun gss_release_name(minor_status_ptr : StatusPtr,
                         name : NameStruct*) : MajorStatus

    fun gss_release_cred(minor_status_ptr : StatusPtr,
                         cred : CredentialStruct*) : MajorStatus

    fun gss_acquire_cred_with_password(minor_status_ptr : StatusPtr,
                                       name : NameStruct,
                                       password: Buffer*,
                                       time: Int32,
                                       desired_mechs: OidSet*,
                                       cred_usage: GssCredentialUsageFlags,
                                       credential_id: CredentialStruct*,
                                       actual_mechs: OidSet**,
                                       time_rec: Int32*) : MajorStatus

    fun gss_display_status(minor_status_ptr : StatusPtr,
                           status_code : UInt32,
                           status_type : Int32,
                           mechanism_type: Oid*,
                           message_context: UInt32*,
                           buffer : Buffer*) : MajorStatus
  end
end
