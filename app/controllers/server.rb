module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    def breakdown_table(joined_table, name)
      @data = joined_table.count
      erb :'shared/_generic_table', locals: {category_name: name}
    end

    get '/sources/:IDENTIFIER' do
      @client = Client.find_by(identifier: params[:IDENTIFIER])
      # @client_identifier = params[:IDENTIFIER].split(".com")
      erb :'client/show'
    end

    # get /sources/:IDENTIFIER/urls/:RELATIVEPATH do
    # end

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
      url = Url.find_by(url_path: JSON.parse(params[:payload])["url"])
      if !client
        status 403
        body "Client doesn't exist."
      elsif JsonTablePopulator.payload_already_exists?(params[:payload], client.id)
      # elsif PayloadRequest.exists?(requested_at: DateTime.strptime(JSON.parse(params[:payload])["requestedAt"], "%Y-%m-%d %H:%M:%S %z"), responded_in: JSON.parse(params[:payload])["respondedIn"], url_id: url.id)
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


end
