module GssApi
  class FunctionInvoker(T)
    def initialize(func_name : String)
      @func_name = func_name
    end

    def invoke : T
      minor_status = uninitialized UInt32
      minor_pointer = pointerof(minor_status)
      block_result = yield minor_pointer
      major_status, return_value = block_result
      check_result(major_status,
                   minor_status)
      return_value
    end

    protected def check_result(major_status,
                             minor_status)
      errors = get_errors major_status, minor_status
      raise "While calling #{@func_name}, encountered the following errors: #{errors}" if errors.any?
    end

    private def get_errors(major_status,
                           minor_status)
      problems = [] of String
      return problems if major_status == 0
      minor_status_for_disp_status = uninitialized UInt32
      minor_status_for_disp_status_ptr = pointerof(minor_status_for_disp_status)
      mech_oid = nil.as(GssApi::GssLib::GssMechanism)
      buffer = GssApi::GssLib::Buffer.new
      buffer_pointer = pointerof(buffer)
      status_failure = false
      capture_issues = ->(status_type: Int32,
                          status_desc: String,
                          code: UInt32) do
        first_run = true
        # this value must be zero (initially) for gss_display_status to work properly
        message_context = UInt32.new(0)
        while first_run || message_context != 0
          first_run = false
          GssApi::GssLib.gss_display_status(minor_status_for_disp_status_ptr,
                                            code,
                                            status_type,
                                            mech_oid,
                                            pointerof(message_context),
                                            buffer_pointer)
          # Value is a raw C string/char* pointer, need to get it into a Crystal string
          error_message = String.new(buffer.value)
          # This is how this shows up
          if message_context == UInt32::MAX
            problems << "Unable to even get #{status_desc} message status: #{error_message}"
            status_failure = true
            break
          end
          problems << "#{status_desc} error code: #{code} - details: #{error_message}"
          # Our Crystal string is copied from buffer, so still need to free this
          GssApi::GssLib.gss_release_buffer(minor_status_for_disp_status_ptr,
                                            buffer_pointer) if buffer.length != 0
        end
      end
      capture_issues.call(1, "Major", major_status)
      capture_issues.call(2, "Minor", minor_status) unless status_failure
      problems
    end
  end

  class VoidFunctionInvoker < FunctionInvoker(Void)
    def invoke : Void
      super do |minor_status|
        major_status = yield minor_status
        {major_status, nil}
      end
    end
  end
end
