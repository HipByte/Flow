module Net
  class AsyncTask < Android::Os::AsyncTask
    attr_accessor :background_callback
    attr_accessor :main_callback

    def self.async(&callback)
      async_task = new
      async_task.background_callback = callback
      async_task.execute([])
    end

    def self.main_async(&callback)
      async_task = new
      async_task.main_callback = callback
      async_task.execute([])
    end

    def doInBackground(params)
      background_callback.call(params) if background_callback
    end

    def onPostExecute(result)
      main_callback.call(result) if main_callback
    end
  end
end
