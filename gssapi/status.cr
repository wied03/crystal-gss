module GssApi
  module FunctionStatus
    def self.check_result(function,
                          major_status,
                          minor_status)
      errors = get_errors major_status, minor_status
      raise "While calling #{function}, encountered the following errors: #{errors}" if errors.any?
    end
    def self.get_errors(major_status,
                        minor_status)
      problems = [] of String
      return problems if major_status == 0
      minor_status_for_disp_status = uninitialized UInt32
      minor_status_for_disp_status_ptr = pointerof(minor_status_for_disp_status)
      mech_oid = uninitialized GssApi::GssLib::Oid
      buffer = GssApi::GssLib::Buffer.new
      buffer_pointer = pointerof(buffer)
      capture_issues = ->(status_type: Int32,
                          status_desc: String,
                          code: UInt32) do
        message_context = UInt32.new(-1)
        while message_context != 0
          major_status = GssApi::GssLib.gss_display_status(minor_status_for_disp_status_ptr,
                                                           code,
                                                           status_type,
                                                           pointerof(mech_oid),
                                                           pointerof(message_context),
                                                           buffer_pointer)
          raise "Unable to even get error status!" unless major_status == 0
          # Value is a raw C string/char* pointer, need to get it into a Crystal string
          error_message = String.new(buffer.value)
          problems << "#{status_desc} error code: #{code} - details: #{error_message}"
          # Our Crystal string is copied from buffer, so still need to free this
          GssApi::GssLib.gss_release_buffer(minor_status_for_disp_status_ptr,
                                            buffer_pointer) if buffer.length != 0
        end
      end
      capture_issues.call(1, "Major", major_status)
      capture_issues.call(2, "Minor", minor_status)
      problems
    end
  end
end
