class WellKnown::WebfingerController < ApplicationController
  allow_unauthenticated_access

  # Example response from https://datatracker.ietf.org/doc/html/rfc7033#section-4.3
  # GET /.well-known/webfinger?
  #     resource=acct%3Abob%40example.com&
  #     rel=http%3A%2F%2Fwebfinger.example%2Frel%2Fprofile-page&
  #     rel=http%3A%2F%2Fwebfinger.example%2Frel%2Fbusinesscard
  #
  #  HTTP/1.1 200 OK
  #  Access-Control-Allow-Origin: *
  #  Content-Type: application/jrd+json
  #
  #  {
  #    "subject" : "acct:bob@example.com",
  #    "aliases" :
  #    [
  #      "https://www.example.com/~bob/"
  #    ],
  #    "properties" :
  #    {
  #        "http://example.com/ns/role" : "employee"
  #    },
  #    "links" :
  #    [
  #      {
  #        "rel" : "http://webfinger.example/rel/profile-page",
  #        "href" : "https://www.example.com/~bob/"
  #      },
  #      {
  #        "rel" : "http://webfinger.example/rel/businesscard",
  #        "href" : "https://www.example.com/~bob/bob.vcf"
  #      }
  #    ]
  #  }

  def show
    if resource_user.blank?
      render json: { error: "User not found" }, status: :not_found
      return
    end

    result = {
      subject: resource_param,
      properties: {
        "http://example.com/ns/role" => "author"
      },
      links: [
        { rel: "http://webfinger.example/rel/profile-page", href: "TODO" },
        { rel: "http://webfinger.example/rel/businesscard", href: "TODO" }
      ]
    }

    expires_in 3.days, public: true
    render json: result, status: :ok, content_type: "application/jrd+json"
  end

  private

    def resource_user
      return nil if resource_param.blank?
      email_address = resource_param.sub("acct:", "")
      User.find_by(email_address: email_address)
    end

    def resource_param
      params.require(:resource)
    end
end
