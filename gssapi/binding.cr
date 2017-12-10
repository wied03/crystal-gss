module GssApi
  @[Link("krb5-gssapi")]
  lib GssLib
    struct Buffer
      length : LibC::SizeT
      value : UInt8*
    end

    struct Oid
      length : UInt32
      elements : Void*
    end

    type GssMechanism = GssLib::Oid*

    struct OidSet
      count : LibC::SizeT
      elements : GssMechanism
    end

    type NameStruct = Void*
    alias Status = UInt32
    alias MajorStatus = Status
    alias StatusPtr = Status*
    type CredentialStruct = Void*
    type ContextStruct = Void*
    type ChannelBindingsStruct = Void*

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
                        oid : GssMechanism,
                        output_name : NameStruct*) : MajorStatus

    fun gss_release_buffer(minor_status_ptr : StatusPtr,
                           buffer : Buffer*) : MajorStatus

    fun gss_release_name(minor_status_ptr : StatusPtr,
                         name : NameStruct*) : MajorStatus

    fun gss_release_cred(minor_status_ptr : StatusPtr,
                         cred : CredentialStruct*) : MajorStatus

    fun gss_acquire_cred(minor_status_ptr : StatusPtr,
                         name : NameStruct,
                         time: Int32,
                         desired_mechs: OidSet*,
                         cred_usage: GssCredentialUsageFlags,
                         credential_id: CredentialStruct*,
                         actual_mechs: OidSet**,
                         time_rec: Int32*) : MajorStatus

    fun gss_display_status(minor_status_ptr : StatusPtr,
                           status_code : UInt32,
                           status_type : Int32,
                           mechanism_type: GssMechanism,
                           message_context: UInt32*,
                           buffer : Buffer*) : MajorStatus

# TODO: Flags
#define GSS_C_DELEG_FLAG        1
#define GSS_C_MUTUAL_FLAG       2
#define GSS_C_REPLAY_FLAG       4
#define GSS_C_SEQUENCE_FLAG     8
#define GSS_C_CONF_FLAG         16
#define GSS_C_INTEG_FLAG        32
#define GSS_C_ANON_FLAG         64
#define GSS_C_PROT_READY_FLAG   128
#define GSS_C_TRANS_FLAG        256
#define GSS_C_DELEG_POLICY_FLAG 32768
#define GSS_C_NO_UI_FLAG  0x80000000

    fun gss_init_sec_context(minor_status_ptr : StatusPtr,
                             credential       : CredentialStruct,
                             context          : ContextStruct*,
                             target_name      : NameStruct,
                             mechanism        : GssMechanism,
                             flags            : UInt32,
                             time             : UInt32,
                             channel_bindings : ChannelBindingsStruct,
                             input_token      : Buffer*,
                             actual_mechanism : GssMechanism*,
                             output_token     : Buffer*,
                             actual_flags     : UInt32*,
                             time_valid_for   : UInt32*) : MajorStatus

    fun gss_canonicalize_name(minor_status_ptr : StatusPtr,
                              target_name      : NameStruct,
                              mechanism        : GssMechanism,
                              output_name      : NameStruct*) : MajorStatus

    fun gss_display_name(minor_status_ptr : StatusPtr,
                         input_name       : NameStruct,
                         output_buffer    : Buffer*,
                         output_type      : GssMechanism*) : MajorStatus
  end
end
