module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      if Client.find_by(identifier: params[:identifier], root_url: params[:rootUrl])
        status 403
        body "that is already a client"
      else
        client = Client.new(identifier: params[:identifier], root_url: params[:rootUrl])
        if client.save
          status 200
          body "{'identifier':'#{client.identifier}'}"
        else
          status 400
          body "not a valid client"
        end
      end
    end

    post '/sources/:IDENTIFIER/data' do
      client = Client.find_by(identifier: params[:IDENTIFIER])
      if !client
        status 403
        body "Client doesn't exist."
      elsif PayloadRequest.find_by(requested_at: DateTime.strptime(JSON.parse(params[:payload])["requestedAt"], "%Y-%m-%d %H:%M:%S %z"))
        status 403
        body "This is already entered"
      else
        payload_request = JsonTablePopulator.new(params[:payload], client.id)
        if payload_request.save
          status 200
        else
          status 400
          body "No payload request found"
        end
      end
    end

  end

  def link_to(href, link_text)
    "<a href='#{href}'>#{link_text}</a>"
  end

  def breakdown_table(data, name)
    @data = data
    erb :'shared/_generic_table', locals: {category_name: name}
  end

end
