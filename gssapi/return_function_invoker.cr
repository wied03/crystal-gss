require "./function_invoker"

# TODO: Move these back into same file
module GssApi
  class VoidFunctionInvoker < FunctionInvoker
    protected def process_result(minor_status, block_result)
      major_status = block_result
      check_result(major_status,
                   minor_status)
      nil
    end
  end

  class ReturnFunctionInvoker(T) < FunctionInvoker
    protected def process_result(minor_status, block_result)
      # TODO: Mult assiign?
      major_status = block_result[0]
      return_value = block_result[1]
      check_result(major_status,
                   minor_status)
      return_value
    end
  end
end
