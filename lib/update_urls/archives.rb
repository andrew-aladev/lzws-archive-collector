require "addressable/uri"
require "uri"

require_relative "../common/colorize"
require_relative "../common/data"
require_relative "../common/format"
require_relative "../common/query"

# href='*.Z'
# href="*.Z"
# href=*.Z
PAGE_WITH_ARCHIVES_REGEXP = Regexp.new(
  "
    href[[:space:]]*=[[:space:]]*
    (?:
        '
        (
          [^']+
          #{ARCHIVE_POSTFIX_FOR_REGEXP}
        )
        '
      |
        \"
        (
          [^\"]+
          #{ARCHIVE_POSTFIX_FOR_REGEXP}
        )
        \"
      |
        (
          [^[:space:]>]+
          #{ARCHIVE_POSTFIX_FOR_REGEXP}
        )
        [[:space:]>]
    )
  ",
  Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED
)
.freeze

# -r--r--r--  1 257  7070  337967 Jul 29  1992 *.Z
LISTING_WITH_ARCHIVES_REGEXP = Regexp.new(
  "
    (
      [^[:space:]]+
      #{ARCHIVE_POSTFIX_FOR_REGEXP}
    )
    (?:
        [[:space:]]
      |
        \\Z
    )
  ",
  Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED
)
.freeze

def get_archive_urls_from_page_url(url)
  begin
    uri    = URI url
    scheme = uri.scheme

    case scheme
    when "ftp"
      data, is_listing = get_content_or_listing_from_ftp uri
      regexp           = is_listing ? LISTING_WITH_ARCHIVES_REGEXP : PAGE_WITH_ARCHIVES_REGEXP

    when "http", "https"
      data   = get_http_content uri
      regexp = PAGE_WITH_ARCHIVES_REGEXP

    else
      raise StandardError, "unknown uri scheme: #{scheme}"
    end

  rescue QueryError => query_error
    warn query_error
    return []
  rescue StandardError => error
    warn error
    return nil
  end

  data
    .scan(regexp)
    .flatten
    .compact
    .map do |archive_url|
      uri    = URI Addressable::URI.parse(url).join(archive_url).to_s
      scheme = uri.scheme

      case scheme
      when "ftp", "http", "https"
        uri.to_s
      else
        raise StandardError, "unknown uri scheme: #{scheme}"
      end
    rescue StandardError => error
      warn error
      next nil
    end
    .compact
end

def get_archive_urls(page_urls)
  valid_page_urls   = []
  invalid_page_urls = []
  archive_urls      = []

  page_urls
    .shuffle
    .each_with_index do |page_url, index|
      percent = format_percent index, page_urls.length
      warn "- #{percent}% checking page, url: #{page_url}"

      new_archive_urls = get_archive_urls_from_page_url page_url
      next if new_archive_urls.nil?

      if new_archive_urls.empty?
        invalid_page_urls << page_url
        page_text = "invalid"
      else
        valid_page_urls << page_url
        page_text = "valid".light_green
      end

      archive_text = colorize_length new_archive_urls.length
      warn "received #{archive_text} archive urls, page is #{page_text}"

      archive_urls.concat new_archive_urls
    end

  valid_page_urls   = valid_page_urls.sort.uniq
  invalid_page_urls = invalid_page_urls.sort.uniq
  archive_urls      = archive_urls.sort.uniq

  valid_page_text   = colorize_length valid_page_urls.length
  invalid_page_text = colorize_length invalid_page_urls.length
  archive_text      = colorize_length archive_urls.length
  warn \
    "-- received #{archive_text} archive urls " \
    "from #{valid_page_text} valid page urls, " \
    "#{invalid_page_text} invalid page urls"

  [valid_page_urls, invalid_page_urls, archive_urls]
end
