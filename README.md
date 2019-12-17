# Jekyll::Library

Jekyll::Library is a Jekyll generator plugin that automates the retrieval of book covers and related metadata based on an ISBN.  During operation the plugin:

1. Identifies pages that include ISBN numbers in their front matter.  Pages are chosen based on the `pages` and `collections` configuration settings.
2. Checks to see if metadata has already been retrieved for the ISBN.
3. If no metadata has been retrieved
  1. Uses the Calibre `fetch-ebook-metadata` tool to retrieve metadata and a cover for the full
  2. Stores the cover image in the location specified by the `cover_folder` setting.
  3. Stores the metadata information in its cache, stored in the directory specified by the `cache_folder` settings, or ".jekyll-cache" if not specified.
4. Updates the page front matter to add
  1. image - contains the relative URL for the cover
  2. book - contains a hash containing other relevant metadata (see below)

The additional information in the front matter can then be used during page layout to include the book metadata in the page.

## Pre-requisites

This plugin makes use of the `fetch-ebook-metadata` tool that ships with [Calibre](https://calibre-ebook.com/).  This tool must be available and in the path of the shell that is executing the Jekyll build.

## Installation

Add this plugin to your application's Gemfile:

```ruby
group :jekyll_plugins do
  gem "jekyll-library", git: "git@github.com:fancypantalons/jekyll-library.git"
end
```

And then execute:

    $ bundle

## Configuration

Without any additional configuration this plugin will **not** process any pages.

The following is an example of a basic configuration:

```yaml
library:
  cover_folder: assets/images/covers
  collections:
    - posts
```

### Page selection

The following settings control the pages the plugin selects for processing:

- `pages` - A boolean setting that, if set to `true`, causes the plugin to generate short URLs for Jekyll pages.
- `collections` - A list of collection names.  The plugin will generate short URLs for the pages in these collections.

### Cover storage

Cover files retrieved by `fetch-ebook-metadata` are stored in the path specified by the `cover_folder` setting.  This setting is required!

### Caching

To avoid retrieving book metadata unnecessarily, the plugin maintains a cache file named `library-cache` in the configured cache directory, which by default is set to `.jekyll-cache`.

You can change the location of the cache file using the `cache_folder` setting.  For example:

```yaml
library:
  cover_folder: assets/images/covers
  cache_folder: .cache
  collections:
    - posts
```

Each entry in the cache file includes the ISBN of the book and the corresponding metadata.

# Thanks

* Huge thanks to the entire Calibre team!
