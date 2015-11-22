module Net
  class AsyncTask < Android::Os::AsyncTask
    attr_accessor :callback

    def self.async(&block)
      async_task = new
      async_task.callback = block
      async_task.execute([])
    end

    def doInBackground(params)
      callback.call(params)
    end
  end
end
