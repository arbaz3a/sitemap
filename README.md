# Sitemap Builder (Ruby)

A command-line tool that crawls a website and generates a sitemap in the standard [sitemap protocol](https://www.sitemaps.org/protocol.html) XML format. Built as a solution to [Gophercises Exercise #5](https://gophercises.com), written in Ruby.

## How it works

1. Takes a starting URL from the command line.
2. Fetches the page and extracts every `<a href>` link.
3. Keeps only links that belong to the same domain (relative links like `/about` are resolved, `www.` is ignored, `#fragments` are removed).
4. Visits each new link using a breadth-first queue, repeating until no new pages are found.
5. Outputs all discovered pages as sitemap XML.

## Features

- **Same-domain filtering**: external links are ignored.
- **Cycle-safe**: a `Set` of visited URLs prevents infinite loops (`/about -> /contact -> /about`).
- **Breadth-first crawl**: each page is found via its shortest path.
- **Optional depth limit** (`-d`): control how many clicks away from the start page to crawl.
- **Redirect handling**: follows redirects up to a maximum number of tries.
- **Clean output**: progress and errors go to stderr, so the XML on stdout can be redirected to a file.

## Project structure

| Class | Responsibility |
|---|---|
| `ArgumentParser` | Reads `-u` and `-d` flags |
| `UrlValidator` | Checks the URL is a valid HTTP/HTTPS URL |
| `PageFetcher` | Fetches HTML and follows redirects |
| `LinkExtractor` | Extracts `href` values with Nokogiri |
| `LinkCleaner` | Resolves relative links, filters domain, removes fragments and duplicates |
| `Crawler` | BFS crawl with a queue of `[url, depth]` and a visited set |
| `SitemapXml` | Builds the XML output with `Nokogiri::XML::Builder` |

## Requirements

- Ruby 3+
- [Nokogiri](https://nokogiri.org/): `gem install nokogiri`

## Usage

```bash
# Crawl the whole site
ruby sitemap.rb -u https://quotes.toscrape.com

# Limit the crawl to 2 clicks from the start page
ruby sitemap.rb -u https://quotes.toscrape.com -d 2

# Save the sitemap to a file
ruby sitemap.rb -u https://quotes.toscrape.com -d 2 > sitemap.xml
```

| Flag | Description |
|---|---|
| `-u URL` | Starting URL (required) |
| `-d DEPTH` | Maximum depth to crawl (optional, default: no limit) |

## Example output

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://quotes.toscrape.com/</loc>
  </url>
  <url>
    <loc>https://quotes.toscrape.com/login</loc>
  </url>
</urlset>
```

## Notes

- Be polite: use a depth limit on large sites, since the crawler fetches pages one at a time and some sites block bots.
- This project was built to practice Ruby classes, BFS, URL handling, and XML generation.