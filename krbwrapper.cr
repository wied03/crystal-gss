@[Link("heimdal-gssapi")]
lib KrbWrapper
  struct Buffer
    length : LibC::SizeT
    value : UInt8*
  end

  struct Oid
    length : UInt32
    elements : Void*
  end

  type NameStruct = Void*

  # output_name is a pointer of a pointer
  fun gss_import_name(minor_status_ptr : Int32*,
                      buffer : Buffer*,
                      oid : Oid*,
                      output_name : NameStruct*) : Int32
end

@[Link("bwwrapper")]
lib BswWrapper
  fun bsw_gss_nt_user_name : KrbWrapper::Oid*
end
