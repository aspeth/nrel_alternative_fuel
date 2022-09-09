# Let's use Faraday's recommended approach to integrating with 3rd party services. I don't ever have this
# stuff memorized, I just googled "faraday ruby examples" to get to https://lostisland.github.io/faraday/usage/


# If possible, try to make it so your service class always returns the same type of object.
# Here you are parsing json and returning it with symbolized keys. So we should try to make it so this class _always_ returns a ruby hash.
# More on this later.
class NRELService
  URL = "https://developer.nrel.gov/"
  API_KEY = ENV["nrel_api_key"]

  # this is how simple your code can look if you pull the crusty stuff out into its own methods
  def self.get_stations(location_string)
    with_error_handling do
      connection.get("/api/alt-fuel-stations/v1/nearest", location: location_string)
    end
  end

  # the crusty stuff is held privately to indicate to other developers that it is crusty and your intention is
  # that they use these nice, clean, publicly available methods above.
  private

  def self.connection
    # Looking at your request, there are always going to be parameters that are 'baked in' to every request
    # you make to NREL. So first thing you want to do is DRY that up and get it out of the way. Luckily, Faraday
    # provides a way of supplying default params that will be included in every request, in addition to custom ones!
    Faraday.new(url: URL, params: { api_key: API_KEY, format: "json" }) do |faraday|
      faraday.use Faraday::Response::RaiseError
    end
  end

  def self.with_error_handling
    # Always think about what could go wrong. Associate-level coders give themselves away by writing code that assumes things will
    # go the way they expect them to!

    # One nice feature of Faraday that you could use is its ability to raise exceptions on bad responses:
    # I got this by googling 'handling faraday exceptions' once I saw in the Faraday documentation that the library defines
    # its own error classes like ClientError, etc. https://www.rubydoc.info/github/lostisland/faraday/Faraday/Error
    # googling also got me here: https://lostisland.github.io/faraday/middleware/raise-error

    # Even more googling of 'faraday handle exceptions example'
    # https://dalibornasevic.com/posts/80-a-walkthrough-for-handling-and-testing-exceptions
    # Which is a fantastic model for basic exception handling in an API Client. Let's use it:
    #

    # I also looked up https://developer.nrel.gov/docs/errors/ to see what NREL will do when they need to send an error response.
    # (An alternative to all this exception handling stuff is to simply look at `response.status` and decide what to do for a 403, 404, 500, etc.)

    response = yield
    JSON.parse(response.body, symbolize_keys: true)
  rescue Faraday::ForbiddenError => e
    # I know NREL is going to send 403s for problems with my API key, so I handle here.
    # By returning a simple hash with an `error:` key
    Rails.logger.error("Nrel::ApiClient Error", e.response.body)

    # Look! Even when an error occurs, we return a ruby hash with symbolized keys.
    # Anyone who uses our service can expect that the return value will be some sort of Hash
    return { error: "There was a problem with your API KEY. Check the application logs" }
  rescue Faraday::ClientError => e
    if e.status == 429 # NREL says they'll return 429s once rate limits exceed
      return { error: "NREL rate limits exceeded. Try again later." }
    else
      Rails.logger.error("Nrel::ApiClient Error", e.response.body)
      return { error: "There was a problem with your request. Check the application logs"}
    end
  rescue Faraday::ServerError => e
    Rails.logger.error("Nrel::ApiClient Error", e.response.body)
    return { error: "The NREL API experienced an unknown server error. Check the application logs for more details" }
  end
end
